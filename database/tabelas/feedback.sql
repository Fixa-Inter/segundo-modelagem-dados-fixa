/*
 * Tabela: feedback
 *
 * Descrição:
 * Registra o feedback do usuário em relação ao aplicativo.
 *
 * Dependências:
 * - usuario
 */

CREATE TABLE feedback (
    id             BIGSERIAL PRIMARY KEY,
    usuario_id     BIGINT NOT NULL REFERENCES usuario(id),
    comentario     VARCHAR(255),
    ideia_central  VARCHAR(255),
    data_criacao   TIMESTAMP NOT NULL DEFAULT NOW()
);
