/*
 * Tabela: usuario
 *
 * Descrição:
 * Armazena os usuários da plataforma, seus dados de identificação,
 * acesso e relacionamento hierárquico com outros usuários.
 *
 * Dependências:
 * - usuario (auto-relacionamento)
 */

CREATE TABLE usuario (
    id                 SERIAL PRIMARY KEY,
    endereco_id        INTEGER NOT NULL REFERENCES endereco(id),
    nome_completo      VARCHAR(100) NOT NULL,
    email              VARCHAR(100) NOT NULL UNIQUE,
    tipo_acesso        INTEGER NOT NULL,
    senha_hash         VARCHAR(255) NOT NULL,
    cargo              VARCHAR(100) NOT NULL,
    data_nascimento    DATE NOT NULL,
    data_criacao       TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo         BOOLEAN NOT NULL DEFAULT FALSE,
    primeiro_acesso    BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT uk_usuario_id_endereco
        UNIQUE (id, endereco_id)
);