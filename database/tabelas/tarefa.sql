/*
 * Tabela: tarefa
 *
 * Descrição:
 * Registra as tarefas que compõem uma ordem de serviço, incluindo
 * sua descrição e status atual.
 *
 * Dependências:
 * - ordem_servico
 */

CREATE TABLE tarefa(
    id                       SERIAL PRIMARY KEY,
    ordem_servico_id         INTEGER NOT NULL REFERENCES ordem_servico(id) ON DELETE CASCADE,
    titulo                   VARCHAR(100) NOT NULL,
    descricao                VARCHAR(255) NOT NULL,
    data_criacao             TIMESTAMP NOT NULL DEFAULT NOW()
);
