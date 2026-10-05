-- ===================================================
-- TRIGGER: trg_auditoria_status_ordem_servico
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

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;


-- ===================================================
-- TRIGGER
-- ===================================================

DROP TRIGGER IF EXISTS trg_auditoria_status_ordem_servico
ON ordem_servico;


CREATE TRIGGER trg_auditoria_status_ordem_servico
AFTER UPDATE OF status_ordem_servico_id
ON ordem_servico
FOR EACH ROW

WHEN (
    OLD.status_ordem_servico_id
    IS DISTINCT FROM
    NEW.status_ordem_servico_id
)

EXECUTE FUNCTION auditar_status_ordem_servico();