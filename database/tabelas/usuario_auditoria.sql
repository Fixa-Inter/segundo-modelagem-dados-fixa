/*
 * Tabela: usuario_auditoria
 *
 * Descrição:
 * Armazena o histórico completo das operações em usuario.
 * O ID histórico não possui FK para preservar a auditoria após exclusões.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE usuario_auditoria (
    id                SERIAL PRIMARY KEY,
    usuario_id        INTEGER NOT NULL,
    operacao          TEXT NOT NULL,
    dados_anteriores  JSONB,
    dados_novos       JSONB,
    data_alteracao    TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_operacao_usuario_auditoria CHECK (
        operacao IN ('INSERT', 'UPDATE', 'DELETE')
    )
);
