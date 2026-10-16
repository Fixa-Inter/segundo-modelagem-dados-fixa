/*
 * Tabela: pagamento_auditoria
 *
 * Descrição:
 * Armazena o histórico completo das operações em pagamento.
 * O ID histórico não possui FK para preservar a auditoria após exclusões.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE pagamento_auditoria (
    id                BIGSERIAL PRIMARY KEY,
    pagamento_id      BIGINT NOT NULL,
    operacao          TEXT NOT NULL,
    dados_anteriores  JSONB,
    dados_novos       JSONB,
    data_alteracao    TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_operacao_pagamento_auditoria CHECK (
        operacao IN ('INSERT', 'UPDATE', 'DELETE')
    )
);
