# Chaves primárias e estrangeiras do FIXA

O modelo operacional possui **28 PKs BIGSERIAL**, **38 FKs BIGINT** e
**3 identificadores históricos BIGINT sem FK**. BIGSERIAL gera uma coluna
BIGINT com default nextval e uma sequence BIGINT associada.

Os tipos foram alterados nas definições individuais, no SQL físico
consolidado e nos parâmetros/variáveis de IDs das três procedures.
As views herdam BIGINT das colunas operacionais. Status, prioridades,
categorias numéricas, dificuldade e chaves de calendário YYYYMMDD continuam
INTEGER. As chaves das dimensões fixas de enum e calendário são analíticas,
sem PK/FK física ou geração por sequence.

## Mapeamento completo

Todas as PKs abaixo são id BIGSERIAL.
Cada FK listada usa BIGINT; os nomes, destinos e ações de exclusão foram preservados.

| Tabela | PK | FKs BIGINT e destinos |
| --- | --- | --- |
| aptidao | id BIGSERIAL | usuario_id → usuario.id |
| categoria_equipamento | id BIGSERIAL | usuario_id → usuario.id |
| contrato | id BIGSERIAL | plano_id → plano.id; unidade_id → unidade.id |
| equipamento | id BIGSERIAL | local_endereco_id → local_endereco.id; modelo_equipamento_id → modelo_equipamento.id; usuario_id → usuario.id |
| evento | id BIGSERIAL | local_endereco_id → local_endereco.id; usuario_id → usuario.id |
| feedback | id BIGSERIAL | usuario_id → usuario.id |
| foto | id BIGSERIAL | observacao_conclusao_id → observacao_conclusao.id; ocorrencia_id → ocorrencia.id; ordem_servico_id → ordem_servico.id; problema_id → problema.id; usuario_id → usuario.id |
| instituicao | id BIGSERIAL | Nenhuma |
| local_endereco | id BIGSERIAL | unidade_id → unidade.id |
| marca_equipamento | id BIGSERIAL | Nenhuma |
| modelo_equipamento | id BIGSERIAL | categoria_equipamento_id → categoria_equipamento.id; marca_equipamento_id → marca_equipamento.id |
| observacao_conclusao | id BIGSERIAL | ordem_servico_id → ordem_servico.id |
| ocorrencia | id BIGSERIAL | categoria_equipamento_id → categoria_equipamento.id; local_endereco_id → local_endereco.id; usuario_id → usuario.id |
| ordem_servico | id BIGSERIAL | problema_id → problema.id; usuario_id → usuario.id |
| ordem_servico_status_auditoria | id BIGSERIAL | ordem_servico_id → ordem_servico.id |
| ordem_servico_tecnico_auditoria | id BIGSERIAL | ordem_servico_id → ordem_servico.id; tecnico_anterior_id → usuario.id; tecnico_novo_id → usuario.id |
| pagamento | id BIGSERIAL | contrato_id → contrato.id |
| pagamento_auditoria | id BIGSERIAL | Nenhuma |
| plano | id BIGSERIAL | Nenhuma |
| problema | id BIGSERIAL | categoria_equipamento_id → categoria_equipamento.id; local_endereco_id → local_endereco.id; usuario_id → usuario.id |
| problema_auditoria | id BIGSERIAL | Nenhuma |
| super_admin | id BIGSERIAL | Nenhuma |
| tarefa | id BIGSERIAL | ordem_servico_id → ordem_servico.id |
| turno | id BIGSERIAL | unidade_id → unidade.id |
| turno_usuario | id BIGSERIAL | turno_id → turno.id; usuario_id → usuario.id |
| unidade | id BIGSERIAL | instituicao_id → instituicao.id |
| usuario | id BIGSERIAL | unidade_id → unidade.id |
| usuario_auditoria | id BIGSERIAL | Nenhuma |

## Identificadores históricos sem FK

- usuario_auditoria.usuario_id: BIGINT.
- problema_auditoria.problema_id: BIGINT.
- pagamento_auditoria.pagamento_id: BIGINT.

A ausência de FK nessas três colunas é intencional: as auditorias continuam
existindo após a exclusão do registro original. Não foram adicionadas FKs.

## Criação e migração

Para um banco vazio, o fluxo permanece:

    psql SUA_CONEXAO -f scripts/criar_banco.sql
    psql SUA_CONEXAO -f scripts/validar_chaves.sql

Para o banco criado com a versão anterior do schema FIXA:

    psql SUA_CONEXAO -f scripts/migrar_chaves_bigint.sql
    psql SUA_CONEXAO -f scripts/validar_chaves.sql
    psql SUA_CONEXAO -f scripts/validar_views.sql

A migração foi preparada para public e para os nomes atuais de constraints
do modelo FIXA. Ela preserva registros e os valores das sequences,
amplia os limites das sequences para 64 bits, recria FKs com as mesmas
definições e recria as 12 views. Não executa o Data Load.

A trigger de reatribuição é removida e recriada com o mesmo arquivo atual
dentro da transação: sua cláusula WHEN depende de usuario_id e impede a
alteração do tipo enquanto existir. As demais triggers permanecem ativas.
As assinaturas anteriores INTEGER das três procedures são substituídas
pelas versões com IDs BIGINT, incluindo o tratamento das versões sem fotos.

A operação é transacional. Dependências externas não são removidas por
CASCADE: impedem a migração e causam rollback. Como há recriação de views
e procedures, proprietários e permissões específicas precisam ser
reaplicados quando diferirem dos padrões do usuário executor. O ALTER TABLE
adquire locks; o lock_timeout da migração é de 10 segundos.

A migração não foi aplicada ao banco Aiven nesta tarefa.
Não execute criar_banco.sql em um banco já preenchido.

## Verificação

- 69 colunas de IDs foram verificadas no catálogo: 28 PKs, 38 FKs e 3 históricos.
- Todas as 28 sequences possuem tipo BIGINT e limite máximo de 64 bits.
- As demais colunas conservaram seus tipos.
- Criação completa e Data Load passaram.
- validar_chaves.sql, validar_views.sql, validar_status.sql e validar_auditorias.sql passaram.
- As 56 verificações transacionais das procedures com fotos passaram.
- IDs acima de 2.147.483.647 foram gerados nas 28 sequences.
- As três procedures, fotos e auditorias aceitaram IDs acima do limite de INTEGER.
- A migração foi aplicada duas vezes à versão anterior, preservando todas as linhas,
  definições de constraints e valores das sequences.
- Uma view externa dependente impediu a migração e o rollback preservou as views.
- O SQL físico consolidado existente cobre 25 tabelas; suas PKs e FKs também
  foram convertidas e sua carga testada. As 28 tabelas completas são criadas
  pelo script modular criar_banco.sql.
- Testes executados em PostgreSQL 18.6 embarcado no PGlite 0.5.9.

## Consumidores

O RPA utiliza int do Python e psycopg2, compatíveis com os IDs BIGINT;
não foi necessário mudar seu código. A origem legada não foi alterada.

No backend principal segundo-api-app, a busca não encontrou IDs físicos
declarados como Integer ou conversões de IDs físicos para int. As conversões
intValue observadas são de códigos de enum e foram mantidas.

No backend secundário segundo-api-fixa, o arquivo
src/main/java/com/example/api_fixa/model/Foto.java ainda possui quatro campos
Integer: problemaId, ocorrenciaId, ordemServicoId e UsuarioId. Esses campos
precisam de Long para representar IDs acima de 32 bits. O arquivo também
possui anotações ManyToOne sobre esses escalares e não está marcado como
Entity, condições já existentes que exigem revisão própria de persistência.
Os backends não foram alterados nesta mudança dos arquivos SQL.
