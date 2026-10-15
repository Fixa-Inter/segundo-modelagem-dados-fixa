/*
 * Tabela: observacao_conclusao
 *
 * Descrição:
 * Armazena observações relacionadas à conclusão das ordens de serviço.
 *
 * Dependências:
 * - ordem_servico
 */

CREATE TABLE observacao_conclusao (
    id                BIGSERIAL PRIMARY KEY,
    ordem_servico_id  BIGINT NOT NULL REFERENCES ordem_servico(id),
    dificuldade       INTEGER NOT NULL,
    observacao        VARCHAR(255) NOT NULL,
    data_criacao      TIMESTAMP NOT NULL DEFAULT NOW(),
    data_atualizacao  TIMESTAMP,
    esta_ativo        BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_dificuldade_observacao_1_a_3 CHECK (dificuldade BETWEEN 1 AND 3)
);
