/*
 * Tabela: observacao_conclusao
 *
 * Descrição:
 * Armazena observações registradas durante a conclusão de uma
 * ordem de serviço.
 *
 * Dependências:
 * - ordem_servico
 */

CREATE TABLE observacao_conclusao(
    id               SERIAL PRIMARY KEY,
    ordem_servico_id INTEGER NOT NULL REFERENCES ordem_servico(id) ON DELETE CASCADE,
    dificuldade      INTEGER NOT NULL, -- 1 = Fácil, 2 = Médio, 3 = Difícil
    observacao       VARCHAR(255) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL DEFAULT NOW()

    CONSTRAINT ck_dificuldade_observacao
        CHECK (dificuldade >= 1 AND dificuldade <= 3)
);