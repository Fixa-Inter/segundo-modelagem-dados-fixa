-- ===================================================
-- TRIGGER: historico_status_ordem_servico
-- Descrição:
-- Registra automaticamente alterações de status
-- da ordem de serviço na tabela de histórico.
-- ===================================================


-- ===================================================
-- FUNÇÃO DA TRIGGER
-- ===================================================

CREATE OR REPLACE FUNCTION registrar_historico_ordem_servico()
RETURNS TRIGGER AS $$
BEGIN

    IF TG_OP = 'INSERT'
        OR OLD.status_ordem_servico_id IS DISTINCT FROM NEW.status_ordem_servico_id THEN

        INSERT INTO ordem_servico_status_historico (
            ordem_servico_id,
            status_ordem_servico_id
        )
        VALUES (
            NEW.id,
            NEW.status_ordem_servico_id
        );

    END IF;

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;


-- ===================================================
-- TRIGGER
-- ===================================================

CREATE TRIGGER trg_historico_status_ordem_servico
AFTER INSERT OR UPDATE OF status_ordem_servico_id
ON ordem_servico
FOR EACH ROW
EXECUTE FUNCTION registrar_historico_ordem_servico();