# Data Mart FIXA

As nove dimensões e as três fatos são views PostgreSQL sobre as tabelas
operacionais. Os IDs mantêm os valores originais; não há geração independente
de chaves nem tabelas físicas de Data Warehouse.

As PKs operacionais usam BIGSERIAL e as FKs usam BIGINT. As views herdam
BIGINT para os IDs das entidades. Códigos fixos de status/categoria e chaves
de calendário YYYYMMDD permanecem INTEGER.

## Hierarquia e escopo do gestor

A organização analítica é instituição → unidade → local. Cada gestor
possui uma unidade em `usuario.unidade_id`, que define a unidade de análise
para os problemas, ocorrências, ordens de serviço e técnicos.

O BI pode filtrar as três fatos por `fato.unidade_id = gestor.unidade_id`.
A exposição dessa coluna permite aplicar o filtro; as views não implementam
autenticação nem Row Level Security.

A instituição é alcançada pela sequência:

```text
fato.unidade_id → dim_unidade.unidade_id
                → dim_unidade.instituicao_id → dim_instituicao.instituicao_id

dim_local.unidade_id → dim_unidade.unidade_id

dim_tecnico.unidade_id → dim_unidade.unidade_id
```

A instituição permanece disponível para análises administrativas. As três
fatos expõem apenas `unidade_id` e `local_id` para a localização do registro,
sem chave direta de instituição. A unidade vem sempre do local do problema
ou da ocorrência, inclusive na OS vinculada a um problema.

| Dimensão | Chave | Origem |
| --- | --- | --- |
| dim_tecnico | tecnico_id | usuario.id, com tipo_acesso = 3 |
| dim_instituicao | instituicao_id | instituicao.id |
| dim_unidade | unidade_id | unidade.id |
| dim_local | local_id | local_endereco.id |
| dim_categoria_problema | categoria_problema_id | Códigos oficiais de 1 a 10 |
| dim_categoria_equipamento | categoria_equipamento_id | categoria_equipamento.id |
| dim_status_ordem_servico | status_id | Valores fixos oficiais de 0 a 4 |
| dim_status_problema | status_problema_id | problema.status, de 0 a 2 |
| dim_tempo | data_id | Data no formato inteiro YYYYMMDD |

`dim_unidade` contém `unidade_id`, `instituicao_id`, `cnpj`, `logradouro`,
`numero`, `complemento`, `bairro`, `cidade`, `estado`, `cep`, `esta_ativo` e `nome`.
O nome da unidade é obrigatório e possui até 100 caracteres.

`dim_local` contém somente `local_id`, `unidade_id`, `nome_local`,
`tipo_local`, `descricao` e `esta_ativo`. Os campos `logradouro`, `numero`,
`bairro`, `cidade`, `estado` e `cep` passaram a ser expostos na dimensão de
unidade. O código numérico `tipo_local_endereco` não é mais exposto na
view de local; a tradução oficial em `tipo_local` foi preservada.

| Fato | Grão | Referências às dimensões |
| --- | --- | --- |
| fato_ordem_servico | Uma linha por ordem_servico_id | tecnico_id, status_id, categoria_problema_id, unidade_id, local_id, data_criacao_id, data_prevista_id, data_inicio_id, data_conclusao_id |
| fato_problema | Uma linha por problema_id | unidade_id, local_id, categoria_equipamento_id, status_problema_id, data_criacao_id |
| fato_ocorrencia | Uma linha por ocorrencia_id | tecnico_id, unidade_id, local_id, categoria_problema_id, categoria_equipamento_id, data_criacao_id |

Os códigos e descrições oficiais permanecem disponíveis nas dimensões;
as fatos de OS e ocorrência mantêm `prioridade` e `prioridade_nome`.
As datas de início e conclusão podem ser nulas quando o evento ainda não
ocorreu. A dimensão de tempo conserva o intervalo original: de 2025-01-01
até cinco anos após a data atual. Datas fora desse intervalo serão apontadas
pela validação de relacionamentos.

## Criação e atualização

Para bancos novos, `scripts/criar_banco.sql` inclui `dim_unidade` entre
`dim_instituicao` e `dim_local`. As demais etapas do fluxo são preservadas.

Para recriar as views de um banco cujas tabelas operacionais já usam o novo modelo:

```sh
psql -d fixa -f scripts/atualizar_views.sql
psql -d fixa -f scripts/validar_views.sql
```

A atualização recria as doze views em uma transação. A remoção segue
fatos → local → unidade → instituição; a recriação segue
instituição → unidade → local, antes das fatos. As dimensões consultam
as tabelas operacionais diretamente.

`CREATE OR REPLACE VIEW` não permite remover colunas nem renomear as colunas
existentes dessa forma. O script não utiliza `CASCADE`: se houver views
externas dependentes, a operação falha e a transação não é aplicada.
As permissões específicas e os proprietários das views recriadas precisam
ser reaplicados quando diferirem dos padrões do usuário executor.
Os consumidores devem passar a usar `unidade_id` nas três fatos.

## Validação

`scripts/validar_views.sql` consulta todas as dimensões e fatos, verifica
duplicidade dos três grãos, compara contagens com as tabelas operacionais
e verifica vinte relações entre fatos e dimensões, incluindo datas.
Também verifica unidade → instituição, local → unidade e técnico → unidade,
a coerência unidade/local em cada fato e o filtro pela unidade do gestor.
As consultas de integridade devem retornar zero linhas. O relatório de
divergências entre status e prazo pode retornar linhas para análise de negócio.
Datas opcionais
nulas não contam como referências inválidas.

Os campos ordem_servico.status_ordem_servico e tarefa.status_ordem_servico
são inteiros de 0 a 4, com default 0 e CHECK.
A auditoria registra status_anterior e status_novo sem FKs de status.
A dimensão de status usa VALUES e preserva nome, descrição e flags.

OS abertas incluem Atrasada (1), Pausada (2) e Em Andamento (3). Não
iniciadas (0) seguem fora da flag de abertura, como na regra anterior.
O indicador esta_atrasada mantém a métrica por prazo: OS aberta com
data_prevista < NOW(). Ele não é sinônimo de status_ordem_servico = 1. A validação
reporta as divergências para decisão de negócio, sem sincronizar os estados.
Reabertura é qualquer transição de Finalizadas (4) para um estado não final
(0, 1, 2, 3). Início e tempo pausado usam os códigos 3 e 2, respectivamente.
Tarefas mantêm estados independentes; a carga apenas cria cenários coerentes.

A carga mantém o volume das tabelas preservadas, inclusive 249 transições,
e representa os cinco status. Remove somente os quatro registros do antigo
cadastro de status. O RPA grava unidade e unidade_id no destino, mantendo
os nomes de origem do banco legado.

Não havia arquivo DBML no checkout. A modelagem física e dimensional
atual está documentada em database/modelagem_fixa.dbml.
O script de atualização de views não migra dados ou tabelas operacionais
de bancos antigos; scripts/criar_banco.sql é para um banco vazio.

## Resultado da revisão de hierarquia em 12/10/2026

Os testes foram executados em uma instância temporária do PostgreSQL 18.6
embarcado no PGlite 0.5.9, usando as tabelas, triggers e a massa de dados
de `database/seeds/data_load_fixa.sql` do projeto. O banco configurado não
foi alterado nesta tarefa.

| Fato | Linhas | Grãos duplicados | Relações sem correspondência | Endereço/local incoerentes |
| --- | ---: | ---: | ---: | ---: |
| fato_ordem_servico | 160 | 0 | 0 | 0 |
| fato_problema | 240 | 0 | 0 | 0 |
| fato_ocorrencia | 100 | 0 | 0 | 0 |

As novas dimensões expuseram 24 endereços e 144 locais com exatamente as
colunas esperadas. As vinte verificações de relações das fatos e as três
verificações da hierarquia retornaram zero inconsistências. As três
verificações de endereço/local e as três de escopo do gestor também
retornaram zero linhas. O script de validação executou 70 instruções SQL.

O filtro por endereço 1 retornou 12 OS, 12 problemas e 6 ocorrências,
coincidindo com as consultas às tabelas operacionais. A separação de
endereços da mesma instituição foi validada sem mistura de unidades.

A comparação de todas as linhas das três fatos, antes e depois da revisão
na mesma transação, confirmou valores idênticos para todas as colunas
preservadas, incluindo todos os KPIs. O novo endereço de cada registro
correspondeu ao endereço do seu local. A comparação do SQL confirmou que
somente os campos e joins de localização foram alterados nas fatos.

Os arquivos operacionais, carga inicial, triggers e demais arquivos fora
da camada analítica permaneceram idênticos aos existentes antes da tarefa.
Os doze cabeçalhos das views seguem o padrão solicitado no novo contexto,
com abertura `/**`. Os comentários das tabelas mantêm abertura `/*`.

A atualização foi reaplicada com sucesso às views existentes. Uma view
externa dependente criada para teste impediu a atualização; o rollback
preservou todas as doze views. O script oficial de criação também foi
executado em outra instância vazia, com carga inicial e validação concluídas.
Não foram encontradas inconsistências na massa testada.

## Arquivos desta revisão

Criado:

- `database/views/dim_endereco.sql`

Alterados na estrutura ou nos relacionamentos:

- `database/views/dim_local.sql`
- `database/views/fato_ordem_servico.sql`
- `database/views/fato_problema.sql`
- `database/views/fato_ocorrencia.sql`
- `scripts/criar_banco.sql`
- `scripts/atualizar_views.sql`
- `scripts/validar_views.sql`
- `database/docs/data_mart.md`

Alterados apenas na abertura do comentário, para atender ao novo padrão:

- `database/views/dim_tempo.sql`
- `database/views/dim_tecnico.sql`
- `database/views/dim_categoria_problema.sql`
- `database/views/dim_categoria_equipamento.sql`
- `database/views/dim_instituicao.sql`
- `database/views/dim_status_ordem_servico.sql`
- `database/views/dim_status_problema.sql`

Não havia DBML do Data Mart no repositório; a hierarquia e seus
relacionamentos estão documentados aqui.
