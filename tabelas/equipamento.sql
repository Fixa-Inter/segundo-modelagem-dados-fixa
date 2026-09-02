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
 * - local_endereco
 */

CREATE TABLE equipamento(
    id                    SERIAL PRIMARY KEY,
    usuario_id            INTEGER NOT NULL REFERENCES usuario(id),
    modelo_equipamento_id INTEGER NOT NULL REFERENCES modelo_equipamento(id),
    local_endereco_id     INTEGER NOT NULL REFERENCES local_endereco(id),
    codigo                VARCHAR(100) NOT NULL,
    data_criacao          TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo            BOOLEAN NOT NULL DEFAULT TRUE
);
