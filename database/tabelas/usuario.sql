/*
 * Tabela: usuario
 *
 * Descrição:
 * Armazena os usuários e suas informações de acesso.
 *
 * Dependências:
 * - unidade
 */

CREATE TABLE usuario (
    id               BIGSERIAL PRIMARY KEY,
    unidade_id      BIGINT NOT NULL REFERENCES unidade(id),
    nome_completo    VARCHAR(100) NOT NULL,
    email            VARCHAR(100) NOT NULL UNIQUE,
    tipo_acesso      INTEGER NOT NULL,
    senha_hash       VARCHAR(255) NOT NULL,
    cargo            VARCHAR(100) NOT NULL,
    data_nascimento  DATE NOT NULL,
    data_criacao     TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo       BOOLEAN NOT NULL DEFAULT FALSE,
    primeiro_acesso  BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uk_usuario_id_unidade UNIQUE (id, unidade_id),
    CONSTRAINT ck_tipo_acesso_usuario_1_a_4 CHECK (tipo_acesso BETWEEN 1 AND 4)
);
