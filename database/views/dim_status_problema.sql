/**
 * Tabela: dim_status_problema
 *
 * Descrição:
 * Disponibiliza os status utilizados pelos problemas
 * registrados no sistema.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE OR REPLACE VIEW dim_status_problema AS
SELECT *
FROM (
    VALUES
        (0, 'Pendente'),
        (1, 'Aprovado'),
        (2, 'Reprovado')
) AS status_problema (
    status_problema_id,
    nome
);
