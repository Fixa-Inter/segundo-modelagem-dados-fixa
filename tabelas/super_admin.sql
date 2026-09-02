/*
 * Tabela: super_admin
 *
 * Descrição:
 * Armazena os usuários responsáveis pela administração
 * global da plataforma.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE super_admin(
    id         SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    email      VARCHAR(100) NOT NULL UNIQUE,
    senha      VARCHAR(255) NOT NULL,
    esta_ativo BOOLEAN NOT NULL DEFAULT TRUE
);