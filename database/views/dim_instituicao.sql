/**
 * Tabela: dim_instituicao
 *
 * Descrição:
 * Disponibiliza informações das instituições utilizadas
 * nas análises gerenciais do BI.
 *
 * Dependências:
 * - instituicao
 */

CREATE OR REPLACE VIEW dim_instituicao AS
SELECT
    i.id AS instituicao_id,
    i.nome,
    i.tipo_instituicao,
    CASE i.tipo_instituicao
        WHEN 1 THEN 'Escola'
        WHEN 2 THEN 'Faculdade'
        WHEN 3 THEN 'Empresa'
        WHEN 4 THEN 'Órgão Público'
    END AS tipo_instituicao_nome,
    i.email_corporativo,
    i.dominio_email,
    i.esta_ativo
FROM instituicao i;
