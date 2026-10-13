/**
 * Tabela: dim_categoria_equipamento
 *
 * Descrição:
 * Disponibiliza as categorias de equipamentos
 * utilizadas nas análises do BI.
 *
 * Dependências:
 * - categoria_equipamento
 */

CREATE OR REPLACE VIEW dim_categoria_equipamento AS
SELECT
    ce.id AS categoria_equipamento_id,
    ce.nome,
    ce.descricao,
    ce.esta_ativo
FROM categoria_equipamento ce;
