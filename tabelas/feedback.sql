/*
 * Tabela: feedback
 *
 * Descrição:
 * Registra feedbacks fornecidos pelos usuários, permitindo a coleta de opiniões e sugestões para melhoria do aplicativo.
 *
 * Dependências:
 * - usuario
 */

CREATE TABLE feedback(
    id                 SERIAL PRIMARY KEY,
    usuario_id         INTEGER NOT NULL REFERENCES usuario(id),
    comentario         VARCHAR(255),
    ideia_central      VARCHAR(255),
    data_criacao       TIMESTAMP NOT NULL DEFAULT NOW(),
);