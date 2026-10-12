/**
 * Tabela: fato_ocorrencia
 *
 * Descrição:
 * Centraliza as informações das ocorrências registradas
 * para indicadores e análises por endereço e local.
 * Uma linha representa uma ocorrência registrada.
 *
 * Dependências:
 * - ocorrencia
 * - local_endereco
 */

CREATE OR REPLACE VIEW fato_ocorrencia AS
SELECT
    o.id AS ocorrencia_id,
    o.usuario_id AS tecnico_id,
    le.endereco_id AS endereco_id,
    o.local_endereco_id AS local_id,
    o.categoria_problema AS categoria_problema_id,
    o.categoria_equipamento_id AS categoria_equipamento_id,
    TO_CHAR(o.data_criacao, 'YYYYMMDD')::INTEGER AS data_criacao_id,
    o.data_criacao,
    o.prioridade,
    o.esta_ativo,
    1::INTEGER AS quantidade_ocorrencia,
    CASE o.prioridade
        WHEN 0 THEN 'Alta'
        WHEN 1 THEN 'Média'
        WHEN 2 THEN 'Baixa'
    END AS prioridade_nome
FROM ocorrencia o
JOIN local_endereco le
    ON le.id = o.local_endereco_id;