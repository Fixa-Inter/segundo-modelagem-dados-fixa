/*
 * Tabela: instituicao
 *
 * Descrição:
 * Armazena as instituições cadastradas na plataforma, como escolas, universidades, empresas, etc.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE instituicao(
    id               SERIAL PRIMARY KEY,
    nome             VARCHAR(100) NOT NULL,
    cnpj             VARCHAR(20) NOT NULL UNIQUE,
    tipo_instituicao INTEGER NOT NULL,
    dominio_email    VARCHAR(100) NOT NULL UNIQUE,
    data_criacao     TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo       BOOLEAN NOT NULL DEFAULT TRUE
);
