/**
 * Tabela: dim_status_ordem_servico
 *
 * Descrição:
 * Disponibiliza os cinco status oficiais a partir de valores fixos.
 * Preserva descrição e flags; Atrasada é considerada aberta.
 *
 * Dependências:
 * - Nenhuma tabela operacional
 */

CREATE OR REPLACE VIEW dim_status_ordem_servico AS
SELECT
    s.status_id,
    s.nome,
    s.descricao,
    s.status_id IN (1, 2, 3) AS considera_aberta,
    s.status_id = 4 AS considera_finalizada
FROM (
    VALUES
        (0, 'Não iniciadas', 'Ordem de serviço criada, mas ainda não iniciada.'),
        (1, 'Atrasada', 'Ordem de serviço com status explícito de atraso.'),
        (2, 'Pausada', 'Ordem de serviço temporariamente pausada.'),
        (3, 'Em Andamento', 'Ordem de serviço em execução por um técnico.'),
        (4, 'Finalizadas', 'Ordem de serviço finalizada pelo técnico responsável.')
) AS s(status_id, nome, descricao);
