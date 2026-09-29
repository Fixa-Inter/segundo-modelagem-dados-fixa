-- ===================================================
-- TRIGGER: auditoria_status_ordem_servico
-- Descrição:
-- Registra alterações no status de uma ordem de serviço,
-- armazenando o status anterior e o novo status.
-- ===================================================


-- ===================================================
-- FUNÇÃO DA TRIGGER
-- ===================================================

CREATE OR REPLACE FUNCTION auditar_status_ordem_servico()
RETURNS TRIGGER AS $$
BEGIN

    IF OLD.status_ordem_servico_id IS DISTINCT FROM NEW.status_ordem_servico_id THEN

        INSERT INTO ordem_servico_status_auditoria (
            ordem_servico_id,
            status_anterior_id,
            status_novo_id
        )
        VALUES (
            NEW.id,
            OLD.status_ordem_servico_id,
            NEW.status_ordem_servico_id
        );

    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;