/**
 * Validação: status da OS, tarefa e auditoria
 *
 * Descrição:
 * Exercita defaults, os cinco valores oficiais, a trigger e rejeições.
 * As alterações de dados são revertidas ao final da transação.
 *
 * Dependências:
 * - ordem_servico
 * - tarefa
 * - ordem_servico_status_auditoria
 */

\set ON_ERROR_STOP on
BEGIN;

DO $$
DECLARE
    os_teste INTEGER;
    tarefa_teste INTEGER;
    auditoria_teste INTEGER;
    valor INTEGER;
    anterior INTEGER;
    antes BIGINT;
    depois BIGINT;
    total_checks INTEGER := 0;
BEGIN
    SELECT id, status_ordem_servico INTO os_teste, anterior FROM ordem_servico ORDER BY id LIMIT 1;
    SELECT id INTO tarefa_teste FROM tarefa WHERE ordem_servico_id = os_teste ORDER BY id LIMIT 1;
    SELECT id INTO auditoria_teste FROM ordem_servico_status_auditoria ORDER BY id LIMIT 1;
    IF os_teste IS NULL OR tarefa_teste IS NULL OR auditoria_teste IS NULL THEN
        RAISE EXCEPTION 'Execute a carga antes de validar os status.';
    END IF;

    -- A tarefa aceita todos os estados, independentemente do estado da OS.
    FOR valor IN 0..4 LOOP
        UPDATE tarefa SET status_ordem_servico = valor WHERE id = tarefa_teste;
        IF (SELECT status_ordem_servico FROM ordem_servico WHERE id = os_teste) <> anterior THEN
            RAISE EXCEPTION 'A tarefa alterou indevidamente o status da OS.';
        END IF;
    END LOOP;
    UPDATE tarefa SET status_ordem_servico = DEFAULT WHERE id = tarefa_teste;
    IF (SELECT status_ordem_servico FROM tarefa WHERE id = tarefa_teste) <> 0 THEN
        RAISE EXCEPTION 'Default da tarefa deve ser 0.';
    END IF;

    FOR valor IN 0..4 LOOP
        SELECT COUNT(*) INTO antes FROM ordem_servico_status_auditoria WHERE ordem_servico_id = os_teste;
        UPDATE ordem_servico SET status_ordem_servico = valor WHERE id = os_teste;
        SELECT COUNT(*) INTO depois FROM ordem_servico_status_auditoria WHERE ordem_servico_id = os_teste;
        IF anterior IS DISTINCT FROM valor THEN
            IF depois <> antes + 1 OR NOT EXISTS (
                SELECT 1 FROM ordem_servico_status_auditoria
                WHERE id = (SELECT MAX(id) FROM ordem_servico_status_auditoria WHERE ordem_servico_id = os_teste)
                  AND status_anterior = anterior AND status_novo = valor
            ) THEN
                RAISE EXCEPTION 'A trigger não registrou corretamente % -> %.', anterior, valor;
            END IF;
        ELSIF depois <> antes THEN
            RAISE EXCEPTION 'Atualização sem mudança de status gerou auditoria.';
        END IF;
        anterior := valor;
    END LOOP;

    UPDATE ordem_servico SET status_ordem_servico = DEFAULT WHERE id = os_teste;
    IF (SELECT status_ordem_servico FROM ordem_servico WHERE id = os_teste) <> 0 THEN
        RAISE EXCEPTION 'Default da OS deve ser 0.';
    END IF;
    IF (SELECT status_ordem_servico FROM tarefa WHERE id = tarefa_teste) <> 0 THEN
        RAISE EXCEPTION 'Atualizar OS modificou o estado da tarefa.';
    END IF;
    UPDATE tarefa SET status_ordem_servico = 2 WHERE id = tarefa_teste;
    UPDATE ordem_servico SET status_ordem_servico = 4 WHERE id = os_teste;
    IF (SELECT status_ordem_servico FROM tarefa WHERE id = tarefa_teste) <> 2 THEN
        RAISE EXCEPTION 'Status da tarefa deve continuar independente da OS.';
    END IF;

    FOREACH valor IN ARRAY ARRAY[-1, 5] LOOP
        BEGIN
            UPDATE ordem_servico SET status_ordem_servico = valor WHERE id = os_teste;
            RAISE EXCEPTION 'OS aceitou status inválido %.', valor;
        EXCEPTION WHEN check_violation THEN total_checks := total_checks + 1;
        END;
        BEGIN
            UPDATE tarefa SET status_ordem_servico = valor WHERE id = tarefa_teste;
            RAISE EXCEPTION 'Tarefa aceitou status inválido %.', valor;
        EXCEPTION WHEN check_violation THEN total_checks := total_checks + 1;
        END;
        BEGIN
            UPDATE ordem_servico_status_auditoria SET status_anterior = valor WHERE id = auditoria_teste;
            RAISE EXCEPTION 'Auditoria aceitou status anterior inválido %.', valor;
        EXCEPTION WHEN check_violation THEN total_checks := total_checks + 1;
        END;
        BEGIN
            UPDATE ordem_servico_status_auditoria SET status_novo = valor WHERE id = auditoria_teste;
            RAISE EXCEPTION 'Auditoria aceitou status novo inválido %.', valor;
        EXCEPTION WHEN check_violation THEN total_checks := total_checks + 1;
        END;
    END LOOP;
    IF total_checks <> 8 THEN
        RAISE EXCEPTION 'Nem todas as oito rejeições por CHECK foram verificadas.';
    END IF;

    BEGIN
        UPDATE ordem_servico SET status_ordem_servico = NULL WHERE id = os_teste;
        RAISE EXCEPTION 'OS aceitou status NULL.';
    EXCEPTION WHEN not_null_violation THEN NULL;
    END;
    BEGIN
        UPDATE tarefa SET status_ordem_servico = NULL WHERE id = tarefa_teste;
        RAISE EXCEPTION 'Tarefa aceitou status NULL.';
    EXCEPTION WHEN not_null_violation THEN NULL;
    END;
    BEGIN
        UPDATE ordem_servico_status_auditoria SET status_anterior = NULL WHERE id = auditoria_teste;
        RAISE EXCEPTION 'Auditoria aceitou status anterior NULL.';
    EXCEPTION WHEN not_null_violation THEN NULL;
    END;
    BEGIN
        UPDATE ordem_servico_status_auditoria SET status_novo = NULL WHERE id = auditoria_teste;
        RAISE EXCEPTION 'Auditoria aceitou status novo NULL.';
    EXCEPTION WHEN not_null_violation THEN NULL;
    END;
    RAISE NOTICE 'Status validados: 0..4, defaults, independência, auditoria, oito CHECKs e quatro NOT NULL.';
END;
$$;

-- Sequences SERIAL podem avançar durante testes, como em qualquer rollback.
ROLLBACK;

