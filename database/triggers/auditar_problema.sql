/**
 * Trigger: trg_auditoria_problema
 *
 * Descrição:
 * Registra operações realizadas na tabela problema,
 * armazenando os dados anteriores e novos da operação.
 *
 * Dependências:
 * - problema
 * - problema_auditoria
 */

CREATE OR REPLACE FUNCTION auditar_problema()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO problema_auditoria (
            problema_id,
            operacao,
            dados_novos
        )
        VALUES (
            NEW.id,
            TG_OP,
            TO_JSONB(NEW)
        );

        RETURN NEW;

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO problema_auditoria (
            problema_id,
            operacao,
            dados_anteriores,
            dados_novos
        )
        VALUES (
            NEW.id,
            TG_OP,
            TO_JSONB(OLD),
            TO_JSONB(NEW)
        );

        RETURN NEW;

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO problema_auditoria (
            problema_id,
            operacao,
            dados_anteriores
        )
        VALUES (
            OLD.id,
            TG_OP,
            TO_JSONB(OLD)
        );

        RETURN OLD;
    END IF;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auditoria_problema
ON problema;

CREATE TRIGGER trg_auditoria_problema
AFTER INSERT OR UPDATE OR DELETE
ON problema
FOR EACH ROW
EXECUTE FUNCTION auditar_problema();
