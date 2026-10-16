/*
 * Tabela: ordem_servico_tecnico_auditoria
 *
 * Descrição:
 * Registra as alterações de técnico responsável por uma ordem de serviço.
 *
 * Dependências:
 * - ordem_servico
 * - usuario
 */

CREATE TABLE ordem_servico_tecnico_auditoria (
    id                  BIGSERIAL PRIMARY KEY,
    ordem_servico_id    BIGINT NOT NULL REFERENCES ordem_servico(id),
    tecnico_anterior_id BIGINT NOT NULL REFERENCES usuario(id),
    tecnico_novo_id     BIGINT NOT NULL REFERENCES usuario(id),
    data_alteracao      TIMESTAMP NOT NULL DEFAULT NOW()
);