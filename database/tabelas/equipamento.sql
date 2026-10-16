/*
 * Tabela: equipamento
 *
 * Descrição:
 * Representa os equipamentos cadastrados no sistema, identificando
 * seu modelo e localização.
 *
 * Dependências:
 * - usuario
 * - modelo_equipamento
 * - local_unidade
 */

CREATE TABLE equipamento(
    id                    BIGSERIAL PRIMARY KEY,
    usuario_id            BIGINT NOT NULL REFERENCES usuario(id),
    modelo_equipamento_id BIGINT NOT NULL REFERENCES modelo_equipamento(id),
    local_unidade_id     BIGINT NOT NULL REFERENCES local_unidade(id),
    codigo                VARCHAR(100) NOT NULL,
    data_criacao          TIMESTAMP NOT NULL DEFAULT NOW(),
    data_atualizacao      TIMESTAMP DEFAULT NOW(),
    esta_ativo            BOOLEAN NOT NULL DEFAULT TRUE
);
