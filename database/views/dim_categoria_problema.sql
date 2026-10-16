/**
 * Tabela: dim_categoria_problema
 *
 * Descrição:
 * Disponibiliza as categorias de problema utilizadas
 * nas ordens de serviço e análises do BI.
 *
 * Dependências:
 * - public.traduzir_categoria_problema(INTEGER)
 */

CREATE OR REPLACE VIEW dim_categoria_problema AS
SELECT
    categoria_problema_id,
    public.traduzir_categoria_problema(categoria_problema_id) AS nome
FROM generate_series(1, 10) AS categoria(categoria_problema_id);
