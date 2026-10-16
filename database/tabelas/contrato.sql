/*
 * Tabela: contrato
 *
 * Descrição:
 * Registra os contratos vinculados às unidades das instituições.
 *
 * Dependências:
 * - plano
 * - unidade
 */

CREATE TABLE contrato (
    id            BIGSERIAL PRIMARY KEY,
    plano_id      BIGINT NOT NULL REFERENCES plano(id),
    unidade_id   BIGINT NOT NULL REFERENCES unidade(id),
    data_inicio   DATE NOT NULL DEFAULT CURRENT_DATE,
    data_fim      DATE NOT NULL,
    status        INTEGER NOT NULL DEFAULT 1,
    data_criacao  TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_status_contrato_1_a_3 CHECK (status BETWEEN 1 AND 3),
    CONSTRAINT ck_data_fim_maior_data_inicio CHECK (data_fim > data_inicio)
);
