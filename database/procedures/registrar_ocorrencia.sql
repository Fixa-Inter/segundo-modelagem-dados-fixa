/**
 * Procedure: registrar_ocorrencia
 *
 * Descrição:
 * Registra uma ocorrência realizada por um técnico ativo,
 * respeitando o local, a unidade e os códigos oficiais,
 * com fotos opcionais por URL.
 *
 * Dependências:
 * - usuario
 * - unidade
 * - local_unidade
 * - categoria_equipamento
 * - ocorrencia
 * - foto
 */

CREATE OR REPLACE PROCEDURE registrar_ocorrencia(
    p_usuario_id BIGINT,
    p_local_id BIGINT,
    p_categoria_equipamento_id BIGINT,
    p_categoria_problema INTEGER,
    p_prioridade INTEGER,
    p_titulo VARCHAR,
    p_descricao_ocorrencia VARCHAR,
    p_descricao_local VARCHAR,
    p_fotos_urls VARCHAR[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_ocorrencia_id BIGINT;
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM usuario
        WHERE id = p_usuario_id
    ) THEN
        RAISE EXCEPTION 'Usuário não encontrado.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM usuario
        WHERE id = p_usuario_id AND tipo_acesso = 3
    ) THEN
        RAISE EXCEPTION 'O usuário informado não é um técnico.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM usuario
        WHERE id = p_usuario_id AND esta_ativo = TRUE
    ) THEN
        RAISE EXCEPTION 'O técnico informado está inativo.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM local_unidade le
        JOIN unidade u ON u.id = le.unidade_id
        WHERE le.id = p_local_id
    ) THEN
        RAISE EXCEPTION 'Local não encontrado ou unidade inválida.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM categoria_equipamento
        WHERE id = p_categoria_equipamento_id
    ) THEN
        RAISE EXCEPTION 'Categoria de equipamento não encontrada.';
    END IF;

    IF p_categoria_problema IS NULL OR p_categoria_problema NOT BETWEEN 1 AND 10 THEN
        RAISE EXCEPTION 'Categoria de problema inválida.';
    END IF;

    IF p_prioridade IS NULL OR p_prioridade NOT BETWEEN 0 AND 2 THEN
        RAISE EXCEPTION 'Prioridade inválida.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM UNNEST(p_fotos_urls) AS fotos(url)
        WHERE url IS NULL OR BTRIM(url) = ''
    ) THEN
        RAISE EXCEPTION 'As URLs das fotos não podem ser nulas ou vazias.';
    END IF;

    INSERT INTO ocorrencia (
        usuario_id,
        local_unidade_id,
        categoria_equipamento_id,
        categoria_problema,
        prioridade,
        titulo,
        descricao_ocorrencia,
        descricao_local
    )
    VALUES (
        p_usuario_id,
        p_local_id,
        p_categoria_equipamento_id,
        p_categoria_problema,
        p_prioridade,
        p_titulo,
        p_descricao_ocorrencia,
        p_descricao_local
    )
    RETURNING id INTO v_ocorrencia_id;

    INSERT INTO foto (ocorrencia_id, url)
    SELECT v_ocorrencia_id, url
    FROM UNNEST(p_fotos_urls) AS fotos(url);
END;
$$;

