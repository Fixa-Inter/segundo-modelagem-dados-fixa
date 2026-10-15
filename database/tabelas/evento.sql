/*
 * Tabela: evento
 *
 * Descrição:
 * Armazena eventos agendados na instituição, incluindo informações
 * sobre período, localização e descrição.
 *
 * Dependências:
 * - usuario
 * - local_unidade
 */

CREATE TABLE evento(
    id                BIGSERIAL PRIMARY KEY,
    usuario_id        BIGINT NOT NULL REFERENCES usuario(id),
    local_unidade_id BIGINT NOT NULL REFERENCES local_unidade(id),
    titulo            VARCHAR(100) NOT NULL,
    descricao         VARCHAR(255) NOT NULL,
    descricao_local   VARCHAR(255) NOT NULL,
    observacao        VARCHAR(255),
    data_hora_inicio  TIMESTAMP NOT NULL,
    data_hora_fim     TIMESTAMP NOT NULL,
    data_criacao      TIMESTAMP NOT NULL DEFAULT NOW(),
    data_atualizacao  TIMESTAMP DEFAULT NOW(),
    esta_ativo        BOOLEAN NOT NULL DEFAULT TRUE
);