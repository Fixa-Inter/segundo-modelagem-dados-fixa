/**
 * Trigger: trg_auditoria_pagamento
 *
 * Descrição:
 * Registra operações realizadas na tabela pagamento,
 * armazenando os dados anteriores e novos da operação.
 *
 * Dependências:
 * - pagamento
 * - pagamento_auditoria
 */

CREATE OR REPLACE FUNCTION auditar_pagamento()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO pagamento_auditoria (
            pagamento_id,
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
        INSERT INTO pagamento_auditoria (
            pagamento_id,
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
        INSERT INTO pagamento_auditoria (
            pagamento_id,
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

DROP TRIGGER IF EXISTS trg_auditoria_pagamento
ON pagamento;

CREATE TRIGGER trg_auditoria_pagamento
AFTER INSERT OR UPDATE OR DELETE
ON pagamento
FOR EACH ROW
EXECUTE FUNCTION auditar_pagamento();
