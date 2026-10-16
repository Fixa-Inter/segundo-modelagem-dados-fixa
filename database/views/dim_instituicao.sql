/**
 * Tabela: dim_instituicao
 *
 * Descrição:
 * Disponibiliza informações das instituições utilizadas
 * nas análises gerenciais do BI.
 *
 * Dependências:
 * - instituicao
 * - public.traduzir_tipo_instituicao(INTEGER)
 */

CREATE OR REPLACE VIEW dim_instituicao AS
SELECT
    i.id AS instituicao_id,
    i.nome,
    i.tipo_instituicao,
    public.traduzir_tipo_instituicao(i.tipo_instituicao) AS tipo_instituicao_nome,
    i.email_corporativo,
    i.dominio_email,
    i.esta_ativo
FROM instituicao i;
