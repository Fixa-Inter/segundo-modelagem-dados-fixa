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
    id                SERIAL PRIMARY KEY,
    ordem_servico_id  INTEGER NOT NULL REFERENCES ordem_servico(id),
    dificuldade       INTEGER NOT NULL,
    observacao        VARCHAR(255) NOT NULL,
    data_criacao      TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_dificuldade_observacao_1_a_3 CHECK (dificuldade BETWEEN 1 AND 3)
);
