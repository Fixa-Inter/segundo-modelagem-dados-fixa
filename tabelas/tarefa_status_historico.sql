/*
 * Tabela: tarefa_status_historico
 *
 * Descrição:
 * Mantém o histórico das alterações de status das tarefas,
 * permitindo acompanhar sua evolução durante a execução.
 *
 * Dependências:
 * - tarefa
 * - status_ordem_servico
 */

CREATE TABLE tarefa_status_historico(
    id                      SERIAL PRIMARY KEY,
    tarefa_id               INTEGER NOT NULL REFERENCES tarefa(id),
    status_ordem_servico_id INTEGER NOT NULL REFERENCES status_ordem_servico(id),
    data_atualizacao        TIMESTAMP NOT NULL DEFAULT NOW()
);