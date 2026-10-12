/**
 * Tabela: fato_ordem_servico
 *
 * Descrição:
 * Centraliza as informações das ordens de serviço
 * para indicadores e análises por endereço e local.
 * Uma linha representa uma ordem de serviço.
 *
 * Dependências:
 * - ordem_servico
 * - problema
 * - local_endereco
 * - status_ordem_servico
 * - tarefa
 * - ordem_servico_status_auditoria
 * - ordem_servico_tecnico_auditoria
 */

CREATE OR REPLACE VIEW fato_ordem_servico AS
WITH historico_status AS (
    SELECT
        osa.id AS auditoria_id,
        osa.ordem_servico_id,
        osa.status_anterior_id,
        status_anterior.nome AS status_anterior,
        osa.status_novo_id,
        status_novo.nome AS status_novo,
        osa.data_alteracao,
        LEAD(osa.data_alteracao) OVER (
            PARTITION BY osa.ordem_servico_id
            ORDER BY osa.data_alteracao, osa.id
        ) AS proxima_alteracao
    FROM ordem_servico_status_auditoria osa
    JOIN status_ordem_servico status_anterior
        ON status_anterior.id = osa.status_anterior_id
    JOIN status_ordem_servico status_novo
        ON status_novo.id = osa.status_novo_id
),
resumo_status AS (
    SELECT
        hs.ordem_servico_id,
        MIN(hs.data_alteracao)
            FILTER (
                WHERE hs.status_novo = 'Em andamento'
            ) AS data_inicio,
        MAX(hs.data_alteracao)
            FILTER (
                WHERE hs.status_novo = 'Finalizadas'
            ) AS ultima_finalizacao,
        COUNT(*)
            FILTER (
                WHERE hs.status_novo = 'Finalizadas'
            )::INTEGER AS qtd_finalizacoes,
        COUNT(*)
            FILTER (
                WHERE hs.status_anterior = 'Finalizadas'
                  AND hs.status_novo IN (
                      'Em andamento',
                      'Pausadas'
                  )
            )::INTEGER AS qtd_reaberturas,
        COALESCE(
            SUM(
                CASE
                    WHEN hs.status_novo = 'Pausadas'
                    THEN
                        EXTRACT(
                            EPOCH FROM (
                                COALESCE(
                                    hs.proxima_alteracao,
                                    NOW()
                                )
                                - hs.data_alteracao
                            )
                        ) / 60
                    ELSE 0
                END
            ),
            0
        ) AS tempo_pausado_minutos
    FROM historico_status hs
    GROUP BY hs.ordem_servico_id
),
reatribuicoes AS (
    SELECT
        ota.ordem_servico_id,
        COUNT(*)::INTEGER AS qtd_reatribuicoes
    FROM ordem_servico_tecnico_auditoria ota
    GROUP BY ota.ordem_servico_id
),
tarefas AS (
    SELECT
        t.ordem_servico_id,
        COUNT(*)::INTEGER AS qtd_tarefas
    FROM tarefa t
    GROUP BY t.ordem_servico_id
)
SELECT
    os.id AS ordem_servico_id,
    os.problema_id,
    os.usuario_id AS tecnico_id,
    os.status_ordem_servico_id AS status_id,
    os.categoria_problema AS categoria_problema_id,
    le.endereco_id AS endereco_id,
    p.local_endereco_id AS local_id,
    TO_CHAR(os.data_criacao, 'YYYYMMDD')::INTEGER AS data_criacao_id,
    TO_CHAR(os.data_prevista, 'YYYYMMDD')::INTEGER AS data_prevista_id,
    CASE
        WHEN rs.data_inicio IS NOT NULL
        THEN TO_CHAR(rs.data_inicio, 'YYYYMMDD')::INTEGER
    END AS data_inicio_id,
    CASE
        WHEN s.nome = 'Finalizadas'
         AND rs.ultima_finalizacao IS NOT NULL
        THEN TO_CHAR(rs.ultima_finalizacao, 'YYYYMMDD')::INTEGER
    END AS data_conclusao_id,
    os.data_criacao,
    os.data_prevista,
    rs.data_inicio,
    CASE
        WHEN s.nome = 'Finalizadas'
        THEN rs.ultima_finalizacao
    END AS data_conclusao,
    os.prioridade,
    COALESCE(t.qtd_tarefas, 0) AS qtd_tarefas,
    COALESCE(rs.qtd_reaberturas, 0) AS qtd_reaberturas,
    COALESCE(r.qtd_reatribuicoes, 0) AS qtd_reatribuicoes,
    COALESCE(rs.tempo_pausado_minutos, 0) AS tempo_pausado_minutos,
    CASE
        WHEN rs.data_inicio IS NOT NULL
        THEN
            EXTRACT(
                EPOCH FROM (
                    rs.data_inicio
                    - os.data_criacao
                )
            ) / 60
    END AS tempo_espera_minutos,
    CASE
        WHEN s.nome = 'Finalizadas'
         AND rs.data_inicio IS NOT NULL
         AND rs.ultima_finalizacao IS NOT NULL
        THEN
            (
                EXTRACT(
                    EPOCH FROM (
                        rs.ultima_finalizacao
                        - rs.data_inicio
                    )
                ) / 60
            )
            -
            COALESCE(rs.tempo_pausado_minutos, 0)
    END AS tempo_resolucao_minutos,
    CASE
        WHEN s.nome IN (
            'Em andamento',
            'Pausadas'
        )
        THEN TRUE
        ELSE FALSE
    END AS esta_aberta,
    CASE
        WHEN s.nome IN (
            'Em andamento',
            'Pausadas'
        )
        AND os.data_prevista < NOW()
        THEN TRUE
        ELSE FALSE
    END AS esta_atrasada,
    CASE
        WHEN s.nome = 'Finalizadas'
        THEN TRUE
        ELSE FALSE
    END AS finalizada,
    CASE
        WHEN COALESCE(rs.qtd_finalizacoes, 0) > 0
        THEN TRUE
        ELSE FALSE
    END AS foi_finalizada,
    CASE
        WHEN s.nome = 'Finalizadas'
         AND rs.ultima_finalizacao IS NOT NULL
         AND rs.ultima_finalizacao <= os.data_prevista
        THEN TRUE
        ELSE FALSE
    END AS concluida_no_prazo,
    CASE
        WHEN COALESCE(rs.qtd_reaberturas, 0) > 0
        THEN TRUE
        ELSE FALSE
    END AS foi_reaberta,
    CASE
        WHEN COALESCE(r.qtd_reatribuicoes, 0) > 0
        THEN TRUE
        ELSE FALSE
    END AS foi_reatribuida,
    CASE os.prioridade
        WHEN 0 THEN 'Alta'
        WHEN 1 THEN 'Média'
        WHEN 2 THEN 'Baixa'
    END AS prioridade_nome
FROM ordem_servico os
JOIN problema p
    ON p.id = os.problema_id
JOIN local_endereco le
    ON le.id = p.local_endereco_id
JOIN status_ordem_servico s
    ON s.id = os.status_ordem_servico_id
LEFT JOIN resumo_status rs
    ON rs.ordem_servico_id = os.id
LEFT JOIN reatribuicoes r
    ON r.ordem_servico_id = os.id
LEFT JOIN tarefas t
    ON t.ordem_servico_id = os.id;