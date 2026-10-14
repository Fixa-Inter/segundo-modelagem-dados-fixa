/*
 * Tabela: tarefa
 *
 * Descrição:
 * Registra as tarefas vinculadas às ordens de serviço, permitindo
 * seu acompanhamento em um kanban próprio.
 *
 * Dependências:
 * - ordem_servico
 */

CREATE TABLE tarefa (
    id                       SERIAL PRIMARY KEY,
    ordem_servico_id         INTEGER NOT NULL REFERENCES ordem_servico(id) ON DELETE CASCADE,
    status_ordem_servico     INTEGER NOT NULL DEFAULT 0,
    titulo                   VARCHAR(100) NOT NULL,
    descricao                VARCHAR(255) NOT NULL,
    data_criacao             TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_status_tarefa CHECK (status_ordem_servico BETWEEN 0 AND 4)
);
