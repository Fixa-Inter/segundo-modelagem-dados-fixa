-- Executado após scripts/criar_banco.sql, com a carga inicial disponível.
-- Valida snapshots completos, operações, datas e persistência após DELETE.
-- Todas as alterações são desfeitas ao final.
\set ON_ERROR_STOP on

BEGIN;

CREATE TEMP TABLE auditorias_esperadas (
    entidade TEXT,
    entidade_id INTEGER,
    operacao TEXT,
    dados_anteriores JSONB,
    dados_novos JSONB
) ON COMMIT DROP;

DO $$
DECLARE
    usuario_teste_id INTEGER;
    pagamento_teste_id INTEGER;
    problema_teste_id INTEGER;
    unidade_teste_id INTEGER;
    contrato_teste_id INTEGER;
    categoria_teste_id INTEGER;
    local_teste_id INTEGER;
    dados_inseridos JSONB;
    dados_atualizados JSONB;
    dados_excluidos JSONB;
    esperado RECORD;
    quantidade INTEGER;
BEGIN
    SELECT id INTO unidade_teste_id FROM unidade ORDER BY id LIMIT 1;
    SELECT id INTO contrato_teste_id FROM contrato ORDER BY id LIMIT 1;
    SELECT id INTO categoria_teste_id FROM categoria_equipamento ORDER BY id LIMIT 1;
    SELECT id INTO local_teste_id FROM local_endereco ORDER BY id LIMIT 1;

    IF unidade_teste_id IS NULL OR contrato_teste_id IS NULL
       OR categoria_teste_id IS NULL OR local_teste_id IS NULL THEN
        RAISE EXCEPTION 'Execute a carga inicial antes de validar as auditorias.';
    END IF;

    SELECT LEAST(0, COALESCE(MIN(id), 0)) - 1 INTO usuario_teste_id FROM usuario;
    SELECT LEAST(0, COALESCE(MIN(id), 0)) - 1 INTO pagamento_teste_id FROM pagamento;
    SELECT LEAST(0, COALESCE(MIN(id), 0)) - 1 INTO problema_teste_id FROM problema;

    INSERT INTO usuario (
        id, unidade_id, nome_completo, email, tipo_acesso,
        senha_hash, cargo, data_nascimento
    ) VALUES (
        usuario_teste_id, unidade_teste_id, 'Teste de auditoria',
        'auditoria-' || MD5(CLOCK_TIMESTAMP()::TEXT) || '@teste.invalid',
        4, 'hash-de-teste', 'Solicitante', DATE '2000-01-01'
    ) RETURNING TO_JSONB(usuario) INTO dados_inseridos;

    INSERT INTO auditorias_esperadas
    VALUES ('usuario', usuario_teste_id, 'INSERT', NULL, dados_inseridos);

    UPDATE usuario SET nome_completo = 'Teste de auditoria atualizado'
    WHERE id = usuario_teste_id
    RETURNING TO_JSONB(usuario) INTO dados_atualizados;

    INSERT INTO auditorias_esperadas
    VALUES ('usuario', usuario_teste_id, 'UPDATE', dados_inseridos, dados_atualizados);

    INSERT INTO pagamento (
        id, contrato_id, data_pagamento, valor_pago, status, metodo_pagamento
    ) VALUES (
        pagamento_teste_id, contrato_teste_id, NOW(), 10.00, 1, 3
    ) RETURNING TO_JSONB(pagamento) INTO dados_inseridos;

    INSERT INTO auditorias_esperadas
    VALUES ('pagamento', pagamento_teste_id, 'INSERT', NULL, dados_inseridos);

    UPDATE pagamento SET valor_pago = 20.00, status = 2
    WHERE id = pagamento_teste_id
    RETURNING TO_JSONB(pagamento) INTO dados_atualizados;

    INSERT INTO auditorias_esperadas
    VALUES ('pagamento', pagamento_teste_id, 'UPDATE', dados_inseridos, dados_atualizados);

    DELETE FROM pagamento WHERE id = pagamento_teste_id
    RETURNING TO_JSONB(pagamento) INTO dados_excluidos;

    IF dados_excluidos IS DISTINCT FROM dados_atualizados THEN
        RAISE EXCEPTION 'Snapshot excluído de pagamento incorreto.';
    END IF;

    INSERT INTO auditorias_esperadas
    VALUES ('pagamento', pagamento_teste_id, 'DELETE', dados_excluidos, NULL);

    INSERT INTO problema (
        id, usuario_id, categoria_equipamento_id, local_endereco_id,
        titulo, descricao_problema, descricao_local
    ) VALUES (
        problema_teste_id, usuario_teste_id, categoria_teste_id, local_teste_id,
        'Teste de auditoria', 'Descrição de teste', 'Local de teste'
    ) RETURNING TO_JSONB(problema) INTO dados_inseridos;

    INSERT INTO auditorias_esperadas
    VALUES ('problema', problema_teste_id, 'INSERT', NULL, dados_inseridos);

    UPDATE problema SET status = 2, motivo_recusa = 'Recusa de teste'
    WHERE id = problema_teste_id
    RETURNING TO_JSONB(problema) INTO dados_atualizados;

    INSERT INTO auditorias_esperadas
    VALUES ('problema', problema_teste_id, 'UPDATE', dados_inseridos, dados_atualizados);

    DELETE FROM problema WHERE id = problema_teste_id
    RETURNING TO_JSONB(problema) INTO dados_excluidos;

    IF dados_excluidos IS DISTINCT FROM dados_atualizados THEN
        RAISE EXCEPTION 'Snapshot excluído de problema incorreto.';
    END IF;

    INSERT INTO auditorias_esperadas
    VALUES ('problema', problema_teste_id, 'DELETE', dados_excluidos, NULL);

    DELETE FROM usuario WHERE id = usuario_teste_id
    RETURNING TO_JSONB(usuario) INTO dados_excluidos;

    SELECT dados_novos INTO dados_atualizados
    FROM auditorias_esperadas
    WHERE entidade = 'usuario' AND operacao = 'UPDATE';

    IF dados_excluidos IS DISTINCT FROM dados_atualizados THEN
        RAISE EXCEPTION 'Snapshot excluído de usuario incorreto.';
    END IF;

    INSERT INTO auditorias_esperadas
    VALUES ('usuario', usuario_teste_id, 'DELETE', dados_excluidos, NULL);

    IF EXISTS (SELECT 1 FROM pagamento WHERE id = pagamento_teste_id)
       OR EXISTS (SELECT 1 FROM problema WHERE id = problema_teste_id)
       OR EXISTS (SELECT 1 FROM usuario WHERE id = usuario_teste_id) THEN
        RAISE EXCEPTION 'Um dos registros de teste não foi excluído.';
    END IF;

    FOR esperado IN SELECT * FROM auditorias_esperadas LOOP
        EXECUTE FORMAT(
            'SELECT COUNT(*) FROM %I WHERE %I = $1 AND operacao = $2
             AND dados_anteriores IS NOT DISTINCT FROM $3
             AND dados_novos IS NOT DISTINCT FROM $4
             AND data_alteracao >= CURRENT_TIMESTAMP
             AND data_alteracao <= CLOCK_TIMESTAMP()',
            esperado.entidade || '_auditoria', esperado.entidade || '_id'
        ) INTO quantidade USING esperado.entidade_id, esperado.operacao,
            esperado.dados_anteriores, esperado.dados_novos;

        IF quantidade <> 1 THEN
            RAISE EXCEPTION 'Auditoria inválida: entidade %, operação %.',
                esperado.entidade, esperado.operacao;
        END IF;
    END LOOP;

    FOR esperado IN
        SELECT DISTINCT entidade, entidade_id FROM auditorias_esperadas
    LOOP
        EXECUTE FORMAT(
            'SELECT COUNT(*) FROM %I WHERE %I = $1',
            esperado.entidade || '_auditoria', esperado.entidade || '_id'
        ) INTO quantidade USING esperado.entidade_id;

        IF quantidade <> 3 THEN
            RAISE EXCEPTION 'Esperadas três auditorias para %, encontradas %.',
                esperado.entidade, quantidade;
        END IF;

        RAISE NOTICE '%: INSERT, UPDATE e DELETE validados.', esperado.entidade;
    END LOOP;
END;
$$;

SELECT * FROM pagamento_auditoria
WHERE pagamento_id IN (
    SELECT entidade_id FROM auditorias_esperadas WHERE entidade = 'pagamento'
)
ORDER BY id DESC;

SELECT * FROM problema_auditoria
WHERE problema_id IN (
    SELECT entidade_id FROM auditorias_esperadas WHERE entidade = 'problema'
)
ORDER BY id DESC;

SELECT * FROM usuario_auditoria
WHERE usuario_id IN (
    SELECT entidade_id FROM auditorias_esperadas WHERE entidade = 'usuario'
)
ORDER BY id DESC;

ROLLBACK;
