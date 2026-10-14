/**
 * Procedure: registrar_observacao_conclusao
 *
 * Descrição:
 * Registra uma observação apenas para uma ordem de serviço finalizada,
 * com dificuldade entre os valores oficiais de 1 a 3
 * e fotos opcionais por URL.
 *
 * Dependências:
 * - ordem_servico
 * - observacao_conclusao
 * - foto
 */

CREATE OR REPLACE PROCEDURE registrar_observacao_conclusao(
    p_ordem_servico_id INTEGER,
    p_dificuldade INTEGER,
    p_observacao VARCHAR,
    p_fotos_urls VARCHAR[] DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_observacao_conclusao_id INTEGER;
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM ordem_servico
        WHERE id = p_ordem_servico_id
        FOR SHARE
    ) THEN
        RAISE EXCEPTION 'Ordem de serviço não encontrada.';
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM ordem_servico
        WHERE id = p_ordem_servico_id AND status_ordem_servico = 4
    ) THEN
        RAISE EXCEPTION 'A ordem de serviço ainda não foi finalizada.';
    END IF;

    IF p_dificuldade IS NULL OR p_dificuldade NOT BETWEEN 1 AND 3 THEN
        RAISE EXCEPTION 'Dificuldade inválida.';
    END IF;

    IF EXISTS (
        SELECT 1
        FROM UNNEST(p_fotos_urls) AS fotos(url)
        WHERE url IS NULL OR BTRIM(url) = ''
    ) THEN
        RAISE EXCEPTION 'As URLs das fotos não podem ser nulas ou vazias.';
    END IF;

    INSERT INTO observacao_conclusao (
        ordem_servico_id,
        dificuldade,
        observacao
    )
    VALUES (
        p_ordem_servico_id,
        p_dificuldade,
        p_observacao
    )
    RETURNING id INTO v_observacao_conclusao_id;

    INSERT INTO foto (observacao_conclusao_id, url)
    SELECT v_observacao_conclusao_id, url
    FROM UNNEST(p_fotos_urls) AS fotos(url);
END;
$$;

