/**
 * Trigger: trg_auditoria_status_ordem_servico
 *
 * Descrição:
 * Registra alterações do status numérico da ordem de serviço,
 * armazenando o valor anterior e o novo valor.
 *
 * Dependências:
 * - ordem_servico
 * - ordem_servico_status_auditoria
 */

CREATE OR REPLACE FUNCTION auditar_status_ordem_servico()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO ordem_servico_status_auditoria (
        ordem_servico_id, status_anterior, status_novo
    )
    VALUES (NEW.id, OLD.status_ordem_servico, NEW.status_ordem_servico);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auditoria_status_ordem_servico ON ordem_servico;

CREATE TRIGGER trg_auditoria_status_ordem_servico
AFTER UPDATE OF status_ordem_servico ON ordem_servico
FOR EACH ROW
WHEN (OLD.status_ordem_servico IS DISTINCT FROM NEW.status_ordem_servico)
EXECUTE FUNCTION auditar_status_ordem_servico();
