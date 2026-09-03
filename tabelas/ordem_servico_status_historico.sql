/*
 * Tabela: ordem_servico_status_historico
 *
 * Descrição:
 * Mantém o histórico das alterações de status das ordens de serviço,
 * permitindo acompanhar sua evolução ao longo do tempo.
 *
 * Dependências:
 * - ordem_servico
 * - status_ordem_servico
 */

CREATE TABLE ordem_servico_status_historico(
    id                      SERIAL PRIMARY KEY,
    ordem_servico_id        INTEGER NOT NULL REFERENCES ordem_servico(id),
    status_ordem_servico_id INTEGER NOT NULL REFERENCES status_ordem_servico(id),
    data_atualizacao        TIMESTAMP NOT NULL DEFAULT NOW()
);
