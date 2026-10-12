/*
 * Tabela: ordem_servico_status_auditoria
 *
 * Descrição:
 * Registra as alterações de status das ordens de serviço,
 * armazenando o valor anterior e o novo valor.
 *
 * Dependências:
 * - ordem_servico
 * - status_ordem_servico
 */

CREATE TABLE ordem_servico_status_auditoria (
    id SERIAL PRIMARY KEY,
    ordem_servico_id   INTEGER NOT NULL REFERENCES ordem_servico(id) ON DELETE CASCADE,
    status_anterior_id INTEGER NOT NULL REFERENCES status_ordem_servico(id),
    status_novo_id     INTEGER NOT NULL REFERENCES status_ordem_servico(id),
    data_alteracao     TIMESTAMP NOT NULL DEFAULT NOW()
);