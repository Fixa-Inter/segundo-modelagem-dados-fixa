/**
 * Tabela: dim_status_problema
 *
 * Descrição:
 * Disponibiliza os status utilizados pelos problemas
 * registrados no sistema.
 *
 * Dependências:
 * - public.traduzir_status_problema(INTEGER)
 */

CREATE OR REPLACE VIEW dim_status_problema AS
SELECT
    status_problema_id,
    public.traduzir_status_problema(status_problema_id) AS nome
FROM generate_series(0, 2) AS status_problema(status_problema_id);
