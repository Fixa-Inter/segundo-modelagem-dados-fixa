/**
 * Tabela: dim_status_ordem_servico
 *
 * Descrição:
 * Disponibiliza os cinco status oficiais a partir de valores fixos.
 * Preserva descrição e flags; Atrasada é considerada aberta.
 *
 * Dependências:
 * - Nenhuma tabela operacional
 * - public.traduzir_status_ordem_servico(INTEGER)
 */

CREATE OR REPLACE VIEW dim_status_ordem_servico AS
SELECT
    s.status_id,
    public.traduzir_status_ordem_servico(s.status_id) AS nome,
    s.descricao,
    s.status_id IN (1, 2, 3) AS considera_aberta,
    s.status_id = 4 AS considera_finalizada
FROM (
    VALUES
        (0, 'Ordem de serviço criada, mas ainda não iniciada.'),
        (1, 'Ordem de serviço com status explícito de atraso.'),
        (2, 'Ordem de serviço temporariamente pausada.'),
        (3, 'Ordem de serviço em execução por um técnico.'),
        (4, 'Ordem de serviço finalizada pelo técnico responsável.')
) AS s(status_id, descricao);
