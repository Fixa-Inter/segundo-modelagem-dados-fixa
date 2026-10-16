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
    id                       BIGSERIAL PRIMARY KEY,
    ordem_servico_id         BIGINT NOT NULL REFERENCES ordem_servico(id) ON DELETE CASCADE,
    status_ordem_servico     INTEGER NOT NULL DEFAULT 0,
    titulo                   VARCHAR(100) NOT NULL,
    descricao                VARCHAR(255) NOT NULL,
    data_criacao             TIMESTAMP NOT NULL DEFAULT NOW(),
    data_atualizacao         TIMESTAMP DEFAULT NOW(),
    esta_ativo               BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_status_tarefa CHECK (status_ordem_servico BETWEEN 0 AND 4)
);
