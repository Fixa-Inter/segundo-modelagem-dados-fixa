/*
 * Tabela: evento
 *
 * Descrição:
 * Armazena eventos agendados na instituição, incluindo informações
 * sobre período, localização e descrição.
 *
 * Dependências:
 * - usuario
 * - local_endereco
 */

CREATE TABLE evento(
    id                SERIAL PRIMARY KEY,
    usuario_id        INTEGER NOT NULL REFERENCES usuario(id),
    local_endereco_id INTEGER NOT NULL REFERENCES local_endereco(id),
    titulo            VARCHAR(100) NOT NULL,
    descricao         VARCHAR(255) NOT NULL,
    descricao_local   VARCHAR(255) NOT NULL,
    observacao        VARCHAR(255),
    data_hora_inicio  TIMESTAMP NOT NULL,
    data_hora_fim     TIMESTAMP NOT NULL,
    data_criacao      TIMESTAMP NOT NULL DEFAULT NOW()
);