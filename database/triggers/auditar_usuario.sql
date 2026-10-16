/**
 * Trigger: trg_auditoria_usuario
 *
 * Descrição:
 * Registra operações realizadas na tabela usuario,
 * armazenando os dados anteriores e novos da operação.
 *
 * Dependências:
 * - usuario
 * - usuario_auditoria
 */

CREATE OR REPLACE FUNCTION auditar_usuario()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO usuario_auditoria (
            usuario_id,
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
        INSERT INTO usuario_auditoria (
            usuario_id,
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
        INSERT INTO usuario_auditoria (
            usuario_id,
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

DROP TRIGGER IF EXISTS trg_auditoria_usuario
ON usuario;

CREATE TRIGGER trg_auditoria_usuario
AFTER INSERT OR UPDATE OR DELETE
ON usuario
FOR EACH ROW
EXECUTE FUNCTION auditar_usuario();
