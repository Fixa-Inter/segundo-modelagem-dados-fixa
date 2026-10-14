/**
 * Tabela: fato_ordem_servico
 *
 * Descrição:
 * Centraliza as informações das ordens de serviço
 * para indicadores e análises por unidade e local.
 * esta_atrasada preserva o cálculo por prazo para status abertos (1, 2, 3).
 * O status Atrasada pode divergir do prazo; validar_views reporta isso.
 * Uma linha representa uma ordem de serviço.
 *
 * Dependências:
 * - ordem_servico
 * - problema
 * - local_endereco
 * - tarefa
 * - ordem_servico_status_auditoria
 * - ordem_servico_tecnico_auditoria
 */

CREATE OR REPLACE VIEW fato_ordem_servico AS
WITH historico_status AS (
    SELECT
        osa.id AS auditoria_id,
        osa.ordem_servico_id,
        osa.status_anterior,
        osa.status_novo,
        osa.data_alteracao,
        LEAD(osa.data_alteracao) OVER (
            PARTITION BY osa.ordem_servico_id
            ORDER BY osa.data_alteracao, osa.id
        ) AS proxima_alteracao
    FROM ordem_servico_status_auditoria osa
),
resumo_status AS (
    SELECT
        hs.ordem_servico_id,
        MIN(hs.data_alteracao)
            FILTER (
                WHERE hs.status_novo = 3
            ) AS data_inicio,
        MAX(hs.data_alteracao)
            FILTER (
                WHERE hs.status_novo = 4
            ) AS ultima_finalizacao,
        COUNT(*)
            FILTER (
                WHERE hs.status_novo = 4
            )::INTEGER AS qtd_finalizacoes,
        COUNT(*)
            FILTER (
                WHERE hs.status_anterior = 4
                  AND hs.status_novo IN (0, 1, 2, 3)
            )::INTEGER AS qtd_reaberturas,
        COALESCE(
            SUM(
                CASE
                    WHEN hs.status_novo = 2
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
    os.status_ordem_servico AS status_id,
    os.categoria_problema AS categoria_problema_id,
    le.unidade_id AS unidade_id,
    p.local_endereco_id AS local_id,
    TO_CHAR(os.data_criacao, 'YYYYMMDD')::INTEGER AS data_criacao_id,
    TO_CHAR(os.data_prevista, 'YYYYMMDD')::INTEGER AS data_prevista_id,
    CASE
        WHEN rs.data_inicio IS NOT NULL
        THEN TO_CHAR(rs.data_inicio, 'YYYYMMDD')::INTEGER
    END AS data_inicio_id,
    CASE
        WHEN os.status_ordem_servico = 4
         AND rs.ultima_finalizacao IS NOT NULL
        THEN TO_CHAR(rs.ultima_finalizacao, 'YYYYMMDD')::INTEGER
    END AS data_conclusao_id,
    os.data_criacao,
    os.data_prevista,
    rs.data_inicio,
    CASE
        WHEN os.status_ordem_servico = 4
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
        WHEN os.status_ordem_servico = 4
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
        WHEN os.status_ordem_servico IN (1, 2, 3)
        THEN TRUE
        ELSE FALSE
    END AS esta_aberta,
    CASE
        WHEN os.status_ordem_servico IN (1, 2, 3)
        AND os.data_prevista < NOW()
        THEN TRUE
        ELSE FALSE
    END AS esta_atrasada,
    CASE
        WHEN os.status_ordem_servico = 4
        THEN TRUE
        ELSE FALSE
    END AS finalizada,
    CASE
        WHEN COALESCE(rs.qtd_finalizacoes, 0) > 0
        THEN TRUE
        ELSE FALSE
    END AS foi_finalizada,
    CASE
        WHEN os.status_ordem_servico = 4
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
LEFT JOIN resumo_status rs
    ON rs.ordem_servico_id = os.id
LEFT JOIN reatribuicoes r
    ON r.ordem_servico_id = os.id
LEFT JOIN tarefas t
    ON t.ordem_servico_id = os.id;