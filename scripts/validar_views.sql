-- ===================================================
-- VALIDAÇÃO: views dimensionais e fatos do Data Mart
-- Descrição:
-- Consultas de leitura para validar OS, problemas e ocorrências.
-- Executar após criar as views no banco FIXA:
-- psql -d fixa -f scripts/validar_views.sql
-- Dependências: tabelas operacionais e as doze views de BI
-- ===================================================

\set ON_ERROR_STOP on

-- Mantém as contagens e NOW() consistentes entre consultas.
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ READ ONLY;

SELECT *
FROM dim_tempo
LIMIT 10;


SELECT *
FROM dim_tecnico
LIMIT 10;


SELECT *
FROM dim_categoria_problema;


SELECT *
FROM dim_endereco
LIMIT 20;


SELECT *
FROM dim_local
LIMIT 10;


SELECT *
FROM dim_instituicao
LIMIT 10;


SELECT *
FROM dim_status_ordem_servico;


SELECT *
FROM fato_ordem_servico
LIMIT 20;


-- Verificar se existe duplicidade de OS:

SELECT
    ordem_servico_id,
    COUNT(*)
FROM fato_ordem_servico
GROUP BY ordem_servico_id
HAVING COUNT(*) > 1;


-- Resultado esperado: 0 linhas.


-- Verificar quantidade da fato contra a tabela operacional:

SELECT COUNT(*)
FROM ordem_servico;


SELECT COUNT(*)
FROM fato_ordem_servico;


-- Resultado esperado: as quantidades devem ser iguais.


-- Verificar OS abertas:

SELECT COUNT(*)
FROM fato_ordem_servico
WHERE esta_aberta = TRUE;


-- Verificar OS atrasadas:

SELECT COUNT(*)
FROM fato_ordem_servico
WHERE esta_atrasada = TRUE;


-- Verificar reaberturas:

SELECT
    ordem_servico_id,
    qtd_reaberturas
FROM fato_ordem_servico
WHERE foi_reaberta = TRUE;


-- Verificar reatribuições:

SELECT
    ordem_servico_id,
    qtd_reatribuicoes
FROM fato_ordem_servico
WHERE foi_reatribuida = TRUE;

-- Resultado esperado: 0 linhas (indicadores divergentes do status atual).
SELECT
    f.ordem_servico_id,
    s.nome,
    f.esta_aberta,
    f.esta_atrasada,
    f.finalizada
FROM fato_ordem_servico f
JOIN status_ordem_servico s
    ON s.id = f.status_id
JOIN ordem_servico os
    ON os.id = f.ordem_servico_id
WHERE f.esta_aberta IS DISTINCT FROM (
        s.nome IN ('Em andamento', 'Pausadas')
    )
   OR f.esta_atrasada IS DISTINCT FROM (
        s.nome IN ('Em andamento', 'Pausadas')
        AND os.data_prevista < NOW()
    )
   OR f.finalizada IS DISTINCT FROM (s.nome = 'Finalizadas');

-- Resultado esperado: 0 linhas (reatribuições devem vir apenas da auditoria).
SELECT
    f.ordem_servico_id,
    f.qtd_reatribuicoes,
    COUNT(ota.id) AS qtd_auditoria
FROM fato_ordem_servico f
LEFT JOIN ordem_servico_tecnico_auditoria ota
    ON ota.ordem_servico_id = f.ordem_servico_id
GROUP BY
    f.ordem_servico_id,
    f.qtd_reatribuicoes,
    f.foi_reatribuida
HAVING f.qtd_reatribuicoes <> COUNT(ota.id)
    OR f.foi_reatribuida IS DISTINCT FROM (COUNT(ota.id) > 0);

-- Resultado esperado: 0 linhas (reaberturas e sinalizadores por OS).
SELECT
    f.ordem_servico_id,
    f.qtd_reaberturas,
    COUNT(osa.id) FILTER (
        WHERE anterior.nome = 'Finalizadas'
          AND novo.nome IN ('Em andamento', 'Pausadas')
    ) AS qtd_auditoria
FROM fato_ordem_servico f
LEFT JOIN ordem_servico_status_auditoria osa
    ON osa.ordem_servico_id = f.ordem_servico_id
LEFT JOIN status_ordem_servico anterior
    ON anterior.id = osa.status_anterior_id
LEFT JOIN status_ordem_servico novo
    ON novo.id = osa.status_novo_id
GROUP BY
    f.ordem_servico_id,
    f.qtd_reaberturas,
    f.foi_reaberta
HAVING f.qtd_reaberturas <> COUNT(osa.id) FILTER (
        WHERE anterior.nome = 'Finalizadas'
          AND novo.nome IN ('Em andamento', 'Pausadas')
    )
    OR f.foi_reaberta IS DISTINCT FROM (
        COUNT(osa.id) FILTER (
            WHERE anterior.nome = 'Finalizadas'
              AND novo.nome IN ('Em andamento', 'Pausadas')
        ) > 0
    );

-- Resultado esperado: 0 linhas (a dimensão deve conter somente técnicos).
SELECT d.tecnico_id
FROM dim_tecnico d
JOIN usuario u
    ON u.id = d.tecnico_id
WHERE u.tipo_acesso <> 3;

-- ===================================================
-- PROBLEMAS E OCORRÊNCIAS
-- ===================================================

-- DIMENSÕES

SELECT *
FROM dim_categoria_equipamento
LIMIT 20;


SELECT *
FROM dim_status_problema;


-- FATO PROBLEMA

SELECT *
FROM fato_problema
LIMIT 20;


-- Deve retornar zero linhas.

SELECT
    problema_id,
    COUNT(*)
FROM fato_problema
GROUP BY problema_id
HAVING COUNT(*) > 1;


-- As quantidades devem ser iguais.

SELECT COUNT(*)
FROM problema;

SELECT COUNT(*)
FROM fato_problema;


-- Status

SELECT
    status_problema_id,
    COUNT(*)
FROM fato_problema
GROUP BY status_problema_id
ORDER BY status_problema_id;


-- Problemas que geraram OS

SELECT COUNT(*)
FROM fato_problema
WHERE gerou_ordem_servico = TRUE;


-- Verificar se algum problema gerou mais de uma OS.
-- Pela regra de negócio, o esperado é zero linhas.

SELECT
    problema_id,
    COUNT(*) AS qtd_ordens
FROM ordem_servico
GROUP BY problema_id
HAVING COUNT(*) > 1;


-- FATO OCORRÊNCIA

SELECT *
FROM fato_ocorrencia
LIMIT 20;


-- Deve retornar zero linhas.

SELECT
    ocorrencia_id,
    COUNT(*)
FROM fato_ocorrencia
GROUP BY ocorrencia_id
HAVING COUNT(*) > 1;


-- As quantidades devem ser iguais.

SELECT COUNT(*)
FROM ocorrencia;

SELECT COUNT(*)
FROM fato_ocorrencia;


-- Validar categorias de problema.

SELECT DISTINCT categoria_problema_id
FROM fato_ocorrencia
ORDER BY categoria_problema_id;


-- Todos devem estar entre 1 e 10.

SELECT *
FROM fato_ocorrencia
WHERE categoria_problema_id NOT BETWEEN 1 AND 10;


-- Validar prioridade.

SELECT *
FROM fato_ocorrencia
WHERE prioridade NOT BETWEEN 0 AND 2;


-- Validar técnicos.

SELECT DISTINCT fo.tecnico_id
FROM fato_ocorrencia fo

LEFT JOIN dim_tecnico dt
    ON dt.tecnico_id = fo.tecnico_id

WHERE dt.tecnico_id IS NULL;

-- Resultado esperado da última consulta: 0 linhas.

-- Resultado esperado: 0 linhas por consulta; datas opcionais nulas são válidas.

SELECT f.ordem_servico_id, f.tecnico_id
FROM fato_ordem_servico f
LEFT JOIN dim_tecnico d
    ON d.tecnico_id = f.tecnico_id
WHERE f.tecnico_id IS NOT NULL
  AND d.tecnico_id IS NULL;

SELECT f.ordem_servico_id, f.status_id
FROM fato_ordem_servico f
LEFT JOIN dim_status_ordem_servico d
    ON d.status_id = f.status_id
WHERE f.status_id IS NOT NULL
  AND d.status_id IS NULL;

SELECT f.ordem_servico_id, f.categoria_problema_id
FROM fato_ordem_servico f
LEFT JOIN dim_categoria_problema d
    ON d.categoria_problema_id = f.categoria_problema_id
WHERE f.categoria_problema_id IS NOT NULL
  AND d.categoria_problema_id IS NULL;

SELECT f.ordem_servico_id, f.local_id
FROM fato_ordem_servico f
LEFT JOIN dim_local d
    ON d.local_id = f.local_id
WHERE f.local_id IS NOT NULL
  AND d.local_id IS NULL;

SELECT f.ordem_servico_id, f.endereco_id
FROM fato_ordem_servico f
LEFT JOIN dim_endereco d
    ON d.endereco_id = f.endereco_id
WHERE f.endereco_id IS NOT NULL
  AND d.endereco_id IS NULL;

SELECT f.ordem_servico_id, f.data_criacao_id
FROM fato_ordem_servico f
LEFT JOIN dim_tempo d
    ON d.data_id = f.data_criacao_id
WHERE f.data_criacao_id IS NOT NULL
  AND d.data_id IS NULL;

SELECT f.ordem_servico_id, f.data_prevista_id
FROM fato_ordem_servico f
LEFT JOIN dim_tempo d
    ON d.data_id = f.data_prevista_id
WHERE f.data_prevista_id IS NOT NULL
  AND d.data_id IS NULL;

SELECT f.ordem_servico_id, f.data_inicio_id
FROM fato_ordem_servico f
LEFT JOIN dim_tempo d
    ON d.data_id = f.data_inicio_id
WHERE f.data_inicio_id IS NOT NULL
  AND d.data_id IS NULL;

SELECT f.ordem_servico_id, f.data_conclusao_id
FROM fato_ordem_servico f
LEFT JOIN dim_tempo d
    ON d.data_id = f.data_conclusao_id
WHERE f.data_conclusao_id IS NOT NULL
  AND d.data_id IS NULL;

SELECT f.problema_id, f.local_id
FROM fato_problema f
LEFT JOIN dim_local d
    ON d.local_id = f.local_id
WHERE f.local_id IS NOT NULL
  AND d.local_id IS NULL;

SELECT f.problema_id, f.endereco_id
FROM fato_problema f
LEFT JOIN dim_endereco d
    ON d.endereco_id = f.endereco_id
WHERE f.endereco_id IS NOT NULL
  AND d.endereco_id IS NULL;

SELECT f.problema_id, f.categoria_equipamento_id
FROM fato_problema f
LEFT JOIN dim_categoria_equipamento d
    ON d.categoria_equipamento_id = f.categoria_equipamento_id
WHERE f.categoria_equipamento_id IS NOT NULL
  AND d.categoria_equipamento_id IS NULL;

SELECT f.problema_id, f.status_problema_id
FROM fato_problema f
LEFT JOIN dim_status_problema d
    ON d.status_problema_id = f.status_problema_id
WHERE f.status_problema_id IS NOT NULL
  AND d.status_problema_id IS NULL;

SELECT f.problema_id, f.data_criacao_id
FROM fato_problema f
LEFT JOIN dim_tempo d
    ON d.data_id = f.data_criacao_id
WHERE f.data_criacao_id IS NOT NULL
  AND d.data_id IS NULL;

SELECT f.ocorrencia_id, f.tecnico_id
FROM fato_ocorrencia f
LEFT JOIN dim_tecnico d
    ON d.tecnico_id = f.tecnico_id
WHERE f.tecnico_id IS NOT NULL
  AND d.tecnico_id IS NULL;

SELECT f.ocorrencia_id, f.local_id
FROM fato_ocorrencia f
LEFT JOIN dim_local d
    ON d.local_id = f.local_id
WHERE f.local_id IS NOT NULL
  AND d.local_id IS NULL;

SELECT f.ocorrencia_id, f.endereco_id
FROM fato_ocorrencia f
LEFT JOIN dim_endereco d
    ON d.endereco_id = f.endereco_id
WHERE f.endereco_id IS NOT NULL
  AND d.endereco_id IS NULL;

SELECT f.ocorrencia_id, f.categoria_problema_id
FROM fato_ocorrencia f
LEFT JOIN dim_categoria_problema d
    ON d.categoria_problema_id = f.categoria_problema_id
WHERE f.categoria_problema_id IS NOT NULL
  AND d.categoria_problema_id IS NULL;

SELECT f.ocorrencia_id, f.categoria_equipamento_id
FROM fato_ocorrencia f
LEFT JOIN dim_categoria_equipamento d
    ON d.categoria_equipamento_id = f.categoria_equipamento_id
WHERE f.categoria_equipamento_id IS NOT NULL
  AND d.categoria_equipamento_id IS NULL;

SELECT f.ocorrencia_id, f.data_criacao_id
FROM fato_ocorrencia f
LEFT JOIN dim_tempo d
    ON d.data_id = f.data_criacao_id
WHERE f.data_criacao_id IS NOT NULL
  AND d.data_id IS NULL;

-- Resultado esperado: 0 linhas nas relações da hierarquia.
SELECT de.endereco_id, de.instituicao_id
FROM dim_endereco de
LEFT JOIN dim_instituicao di
    ON di.instituicao_id = de.instituicao_id
WHERE di.instituicao_id IS NULL;

SELECT dl.local_id, dl.endereco_id
FROM dim_local dl
LEFT JOIN dim_endereco de
    ON de.endereco_id = dl.endereco_id
WHERE de.endereco_id IS NULL;

SELECT dt.tecnico_id, dt.endereco_id
FROM dim_tecnico dt
LEFT JOIN dim_endereco de
    ON de.endereco_id = dt.endereco_id
WHERE de.endereco_id IS NULL;

-- Resultado esperado: 0 linhas com endereço diferente do local.
SELECT f.ordem_servico_id, f.endereco_id, f.local_id,
    dl.endereco_id AS endereco_do_local
FROM fato_ordem_servico f
JOIN dim_local dl
    ON dl.local_id = f.local_id
WHERE f.endereco_id IS DISTINCT FROM dl.endereco_id;

-- Amostra do escopo do endereço 1.
SELECT *
FROM fato_ordem_servico
WHERE endereco_id = 1;

-- Resultado esperado: 0 linhas fora do endereço do gestor.
SELECT g.id AS gestor_id, f.ordem_servico_id, f.local_id
FROM usuario g
JOIN fato_ordem_servico f
    ON f.endereco_id = g.endereco_id
JOIN dim_local dl
    ON dl.local_id = f.local_id
WHERE g.tipo_acesso = 2
  AND dl.endereco_id IS DISTINCT FROM g.endereco_id;

-- Resultado esperado: 0 linhas com endereço diferente do local.
SELECT f.problema_id, f.endereco_id, f.local_id,
    dl.endereco_id AS endereco_do_local
FROM fato_problema f
JOIN dim_local dl
    ON dl.local_id = f.local_id
WHERE f.endereco_id IS DISTINCT FROM dl.endereco_id;

-- Amostra do escopo do endereço 1.
SELECT *
FROM fato_problema
WHERE endereco_id = 1;

-- Resultado esperado: 0 linhas fora do endereço do gestor.
SELECT g.id AS gestor_id, f.problema_id, f.local_id
FROM usuario g
JOIN fato_problema f
    ON f.endereco_id = g.endereco_id
JOIN dim_local dl
    ON dl.local_id = f.local_id
WHERE g.tipo_acesso = 2
  AND dl.endereco_id IS DISTINCT FROM g.endereco_id;

-- Resultado esperado: 0 linhas com endereço diferente do local.
SELECT f.ocorrencia_id, f.endereco_id, f.local_id,
    dl.endereco_id AS endereco_do_local
FROM fato_ocorrencia f
JOIN dim_local dl
    ON dl.local_id = f.local_id
WHERE f.endereco_id IS DISTINCT FROM dl.endereco_id;

-- Amostra do escopo do endereço 1.
SELECT *
FROM fato_ocorrencia
WHERE endereco_id = 1;

-- Resultado esperado: 0 linhas fora do endereço do gestor.
SELECT g.id AS gestor_id, f.ocorrencia_id, f.local_id
FROM usuario g
JOIN fato_ocorrencia f
    ON f.endereco_id = g.endereco_id
JOIN dim_local dl
    ON dl.local_id = f.local_id
WHERE g.tipo_acesso = 2
  AND dl.endereco_id IS DISTINCT FROM g.endereco_id;

COMMIT;
