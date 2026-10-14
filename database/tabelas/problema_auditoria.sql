/*
 * Tabela: problema_auditoria
 *
 * Descrição:
 * Armazena o histórico completo das operações em problema.
 * O ID histórico não possui FK para preservar a auditoria após exclusões.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE problema_auditoria (
    id                SERIAL PRIMARY KEY,
    problema_id       INTEGER NOT NULL,
    operacao          TEXT NOT NULL,
    dados_anteriores  JSONB,
    dados_novos       JSONB,
    data_alteracao    TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_operacao_problema_auditoria CHECK (
        operacao IN ('INSERT', 'UPDATE', 'DELETE')
    )
);
