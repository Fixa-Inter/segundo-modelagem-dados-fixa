-- ===================================================
-- TRIGGER: trg_auditoria_tecnico_ordem_servico
-- Descrição:
-- Registra alterações no técnico responsável por uma
-- ordem de serviço, permitindo identificar reatribuições.
-- ===================================================


-- ===================================================
-- FUNÇÃO DA TRIGGER
-- ===================================================

CREATE OR REPLACE FUNCTION auditar_tecnico_ordem_servico()
RETURNS TRIGGER AS $$
BEGIN

    INSERT INTO ordem_servico_tecnico_auditoria (
        ordem_servico_id,
        tecnico_anterior_id,
        tecnico_novo_id
    )
    VALUES (
        NEW.id,
        OLD.usuario_id,
        NEW.usuario_id
    );

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;


-- ===================================================
-- TRIGGER
-- ===================================================

DROP TRIGGER IF EXISTS trg_auditoria_tecnico_ordem_servico
ON ordem_servico;


CREATE TRIGGER trg_auditoria_tecnico_ordem_servico
AFTER UPDATE OF usuario_id
ON ordem_servico
FOR EACH ROW

WHEN (
    OLD.usuario_id
    IS DISTINCT FROM
    NEW.usuario_id
)

EXECUTE FUNCTION auditar_tecnico_ordem_servico();