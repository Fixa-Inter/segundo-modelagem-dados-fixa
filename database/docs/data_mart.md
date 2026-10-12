# Data Mart FIXA

As nove dimensões e as três fatos são views PostgreSQL sobre as tabelas
operacionais. Os IDs mantêm os valores originais; não há geração independente
de chaves nem tabelas físicas de Data Warehouse.

## Hierarquia e escopo do gestor

A organização analítica é instituição → endereço → local. Cada gestor
possui um endereço em `usuario.endereco_id`, que define a unidade de análise
para os problemas, ocorrências, ordens de serviço e técnicos.

O BI pode filtrar as três fatos por `fato.endereco_id = gestor.endereco_id`.
A exposição dessa coluna permite aplicar o filtro; as views não implementam
autenticação nem Row Level Security.

A instituição é alcançada pela sequência:

```text
fato.endereco_id → dim_endereco.endereco_id
                → dim_endereco.instituicao_id → dim_instituicao.instituicao_id

dim_local.endereco_id → dim_endereco.endereco_id

dim_tecnico.endereco_id → dim_endereco.endereco_id
```

A instituição permanece disponível para análises administrativas. As três
fatos expõem apenas `endereco_id` e `local_id` para a localização do registro,
sem chave direta de instituição. O endereço vem sempre do local do problema
ou da ocorrência, inclusive na OS vinculada a um problema.

| Dimensão | Chave | Origem |
| --- | --- | --- |
| dim_tecnico | tecnico_id | usuario.id, com tipo_acesso = 3 |
| dim_instituicao | instituicao_id | instituicao.id |
| dim_endereco | endereco_id | endereco.id |
| dim_local | local_id | local_endereco.id |
| dim_categoria_problema | categoria_problema_id | Códigos oficiais de 1 a 10 |
| dim_categoria_equipamento | categoria_equipamento_id | categoria_equipamento.id |
| dim_status_ordem_servico | status_id | status_ordem_servico.id |
| dim_status_problema | status_problema_id | problema.status, de 0 a 2 |
| dim_tempo | data_id | Data no formato inteiro YYYYMMDD |

`dim_endereco` contém `endereco_id`, `instituicao_id`, `cnpj`, `logradouro`,
`numero`, `complemento`, `bairro`, `cidade`, `estado`, `cep` e `esta_ativo`.

`dim_local` contém somente `local_id`, `endereco_id`, `nome_local`,
`tipo_local`, `descricao` e `esta_ativo`. Os campos `logradouro`, `numero`,
`bairro`, `cidade`, `estado` e `cep` passaram a ser expostos na dimensão de
endereço. O código numérico `tipo_local_endereco` não é mais exposto na
view de local; a tradução oficial em `tipo_local` foi preservada.

| Fato | Grão | Referências às dimensões |
| --- | --- | --- |
| fato_ordem_servico | Uma linha por ordem_servico_id | tecnico_id, status_id, categoria_problema_id, endereco_id, local_id, data_criacao_id, data_prevista_id, data_inicio_id, data_conclusao_id |
| fato_problema | Uma linha por problema_id | endereco_id, local_id, categoria_equipamento_id, status_problema_id, data_criacao_id |
| fato_ocorrencia | Uma linha por ocorrencia_id | tecnico_id, endereco_id, local_id, categoria_problema_id, categoria_equipamento_id, data_criacao_id |

Os códigos e descrições oficiais permanecem disponíveis nas dimensões;
as fatos de OS e ocorrência mantêm `prioridade` e `prioridade_nome`.
As datas de início e conclusão podem ser nulas quando o evento ainda não
ocorreu. A dimensão de tempo conserva o intervalo original: de 2025-01-01
até cinco anos após a data atual. Datas fora desse intervalo serão apontadas
pela validação de relacionamentos.

## Criação e atualização

Para bancos novos, `scripts/criar_banco.sql` inclui `dim_endereco` entre
`dim_instituicao` e `dim_local`. As demais etapas do fluxo são preservadas.

Para atualizar um banco que já possui as views:

```sh
psql -d fixa -f scripts/atualizar_views.sql
psql -d fixa -f scripts/validar_views.sql
```

A atualização recria as doze views em uma transação. A remoção segue
fatos → local → endereço → instituição; a recriação segue
instituição → endereço → local, antes das fatos. As dimensões consultam
as tabelas operacionais diretamente.

`CREATE OR REPLACE VIEW` não permite remover colunas nem renomear as colunas
existentes dessa forma. O script não utiliza `CASCADE`: se houver views
externas dependentes, a operação falha e a transação não é aplicada.
As permissões específicas e os proprietários das views recriadas precisam
ser reaplicados quando diferirem dos padrões do usuário executor.
Os consumidores devem passar a usar `endereco_id` nas três fatos.

## Validação

`scripts/validar_views.sql` consulta todas as dimensões e fatos, verifica
duplicidade dos três grãos, compara contagens com as tabelas operacionais
e verifica vinte relações entre fatos e dimensões, incluindo datas.
Também verifica endereço → instituição, local → endereço e técnico → endereço,
a coerência endereço/local em cada fato e o filtro pelo endereço do gestor.
As consultas de inconsistência devem retornar zero linhas. Datas opcionais
nulas não contam como referências inválidas.

Os cálculos de OS aberta e atrasada, finalizações, reaberturas,
reatribuições, tarefas, tempos e problemas que geraram OS preservam as
expressões originais. As CTEs e a função de janela da OS não foram alteradas.

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
