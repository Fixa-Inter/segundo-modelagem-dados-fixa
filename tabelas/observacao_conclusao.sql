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
    ordem_servico_id INTEGER NOT NULL REFERENCES ordem_servico(id),
    observacao       VARCHAR(255) NOT NULL,
    data_criacao     TIMESTAMP NOT NULL DEFAULT NOW()
);