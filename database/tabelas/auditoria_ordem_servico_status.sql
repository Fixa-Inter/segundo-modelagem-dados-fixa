/*
 * Tabela: ordem_servico_status_auditoria
 *
 * Descrição:
 * Registra as alterações de status das ordens de serviço,
 * armazenando o valor anterior e o novo valor.
 *
 * Dependências:
 * - ordem_servico
 */

CREATE TABLE ordem_servico_status_auditoria (
    id BIGSERIAL PRIMARY KEY,
    ordem_servico_id   BIGINT NOT NULL REFERENCES ordem_servico(id) ON DELETE CASCADE,
    status_anterior    INTEGER NOT NULL,
    status_novo        INTEGER NOT NULL,
    data_alteracao     TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_status_anterior_ordem_servico CHECK (status_anterior BETWEEN 0 AND 4),
    CONSTRAINT ck_status_novo_ordem_servico CHECK (status_novo BETWEEN 0 AND 4)
);