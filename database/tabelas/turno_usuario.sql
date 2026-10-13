/*
 * Tabela: turno_usuario
 *
 * Descrição:
 * Representa a associação entre usuários e turnos, permitindo
 * definir quais usuários estão vinculados a cada turno.
 *
 * Dependências:
 * - turno
 * - usuario
 */

CREATE TABLE turno_usuario(
    id           SERIAL PRIMARY KEY,
    turno_id     INTEGER NOT NULL REFERENCES turno(id),
    usuario_id   INTEGER NOT NULL REFERENCES usuario(id),
    data_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo   BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT uk_turno_usuario UNIQUE (turno_id, usuario_id)
);