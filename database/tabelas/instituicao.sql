/*
 * Tabela: instituicao
 *
 * Descrição:
 * Armazena as instituições cadastradas na plataforma.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE instituicao (
    id                 BIGSERIAL PRIMARY KEY,
    nome               VARCHAR(100) NOT NULL,
    tipo_instituicao   INTEGER NOT NULL,
    email_corporativo  VARCHAR(100) UNIQUE,
    dominio_email      VARCHAR(100) NOT NULL UNIQUE,
    data_criacao       TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo         BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_tipo_instituicao_1_a_4 CHECK (tipo_instituicao BETWEEN 1 AND 4)
);
