/*
 * Tabela: pagamento
 *
 * Descrição:
 * Registra os pagamentos realizados ou pendentes relacionados
 * aos contratos das instituições.
 *
 * Dependências:
 * - contrato
 */

CREATE TABLE pagamento(
    id               SERIAL PRIMARY KEY,
    contrato_id      INTEGER NOT NULL REFERENCES contrato(id),
    data_pagamento   DATE NOT NULL,
    valor_pago       DECIMAL(10,2) NOT NULL,
    status           INTEGER DEFAULT 0, -- 0 = Pendente, 1 = Aprovado, 2 = Rejeitado
    metodo_pagamento INTEGER NOT NULL,
    data_criacao     TIMESTAMP NOT NULL DEFAULT NOW()
);