/**
 * Tabela: dim_status_ordem_servico
 *
 * Descrição:
 * Disponibiliza os status das ordens de serviço
 * utilizados nas análises do BI.
 *
 * Dependências:
 * - status_ordem_servico
 */

CREATE OR REPLACE VIEW dim_status_ordem_servico AS
SELECT
    s.id AS status_id,
    s.nome,
    s.descricao,
    CASE
        WHEN s.nome IN (
            'Em andamento',
            'Pausadas'
        )
        THEN TRUE
        ELSE FALSE
    END AS considera_aberta,
    CASE
        WHEN s.nome = 'Finalizadas'
        THEN TRUE
        ELSE FALSE
    END AS considera_finalizada
FROM status_ordem_servico s;
