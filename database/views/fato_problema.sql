/**
 * Tabela: fato_problema
 *
 * Descrição:
 * Centraliza as informações dos problemas registrados
 * para indicadores e análises por endereço e local.
 * Uma linha representa um problema registrado.
 *
 * Dependências:
 * - problema
 * - local_endereco
 * - ordem_servico
 */

CREATE OR REPLACE VIEW fato_problema AS
SELECT
    p.id AS problema_id,
    p.usuario_id AS solicitante_id,
    le.endereco_id AS endereco_id,
    p.local_endereco_id AS local_id,
    p.categoria_equipamento_id AS categoria_equipamento_id,
    p.status AS status_problema_id,
    TO_CHAR(p.data_criacao, 'YYYYMMDD')::INTEGER AS data_criacao_id,
    p.data_criacao,
    1::INTEGER AS quantidade_problema,
    CASE
        WHEN p.status = 0
        THEN TRUE
        ELSE FALSE
    END AS esta_pendente,
    CASE
        WHEN p.status = 1
        THEN TRUE
        ELSE FALSE
    END AS esta_aprovado,
    CASE
        WHEN p.status = 2
        THEN TRUE
        ELSE FALSE
    END AS esta_reprovado,
    EXISTS (
        SELECT 1
        FROM ordem_servico os
        WHERE os.problema_id = p.id
    ) AS gerou_ordem_servico
FROM problema p
JOIN local_endereco le
    ON le.id = p.local_endereco_id;
