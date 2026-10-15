/**
 * Tabela: dim_local
 *
 * Descrição:
 * Disponibiliza os locais existentes dentro de cada unidade,
 * permitindo análises por sala, laboratório e demais ambientes.
 *
 * Dependências:
 * - local_unidade
 * - public.traduzir_tipo_local_unidade(INTEGER)
 */

CREATE OR REPLACE VIEW dim_local AS
SELECT
    le.id AS local_id,
    le.unidade_id,
    le.nome AS nome_local,
    public.traduzir_tipo_local_unidade(le.tipo_local_unidade) AS tipo_local,
    le.descricao,
    le.esta_ativo
FROM local_unidade le;
