/*
 * Tabela: pagamento
 *
 * Descrição:
 * Registra os pagamentos relacionados aos contratos.
 *
 * Dependências:
 * - contrato
 */

CREATE TABLE pagamento (
    id                SERIAL PRIMARY KEY,
    contrato_id       INTEGER NOT NULL REFERENCES contrato(id),
    data_pagamento    TIMESTAMP NOT NULL,
    valor_pago        DECIMAL(10, 2) NOT NULL,
    status            INTEGER DEFAULT 1,
    metodo_pagamento  INTEGER NOT NULL,
    data_criacao      TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_status_pagamento_1_a_3 CHECK (status BETWEEN 1 AND 3),
    CONSTRAINT ck_metodo_pagamento_1_a_3 CHECK (metodo_pagamento BETWEEN 1 AND 3)
);
