/**
 * Procedure: cadastrar_problema
 *
 * Descrição:
 * Registra um problema pendente enviado por um usuário ativo,
 * com local e categoria válidos e fotos opcionais por URL,
 * sem criar ordem de serviço.
 *
 * Dependências:
 * - usuario
 * - unidade
 * - local_endereco
 * - categoria_equipamento
 * - problema
 * - foto
 */

CREATE OR REPLACE PROCEDURE cadastrar_problema(
    p_usuario_id INTEGER,
    p_local_id INTEGER,
    p_categoria_equipamento_id INTEGER,
    p_titulo VARCHAR,
    p_descricao_problema VARCHAR,
    p_descricao_local VARCHAR,
    p_fotos_urls VARCHAR[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_problema_id INTEGER;
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
        WHERE id = p_usuario_id AND esta_ativo = TRUE
    ) THEN
        RAISE EXCEPTION 'O usuário informado está inativo.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM local_endereco le
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

    IF EXISTS (
        SELECT 1
        FROM UNNEST(p_fotos_urls) AS fotos(url)
        WHERE url IS NULL OR BTRIM(url) = ''
    ) THEN
        RAISE EXCEPTION 'As URLs das fotos não podem ser nulas ou vazias.';
    END IF;

    INSERT INTO problema (
        usuario_id,
        local_endereco_id,
        categoria_equipamento_id,
        titulo,
        descricao_problema,
        descricao_local,
        status,
        motivo_recusa
    )
    VALUES (
        p_usuario_id,
        p_local_id,
        p_categoria_equipamento_id,
        p_titulo,
        p_descricao_problema,
        p_descricao_local,
        0,
        NULL
    )
    RETURNING id INTO v_problema_id;

    INSERT INTO foto (problema_id, url)
    SELECT v_problema_id, url
    FROM UNNEST(p_fotos_urls) AS fotos(url);
END;
$$;

