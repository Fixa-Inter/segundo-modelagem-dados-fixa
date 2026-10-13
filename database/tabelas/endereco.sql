/*
 * Tabela: endereco
 *
 * Descrição:
 * Armazena os endereços/franquias associados às instituições cadastradas.
 *
 * Dependências:
 * - instituicao
 */

CREATE TABLE endereco(
    id             SERIAL PRIMARY KEY,
    instituicao_id INTEGER NOT NULL REFERENCES instituicao(id),
    cnpj           CHAR(14) NOT NULL UNIQUE,
    logradouro     VARCHAR(100) NOT NULL,
    numero         VARCHAR(10) NOT NULL,
    complemento    VARCHAR(100),
    bairro         VARCHAR(100) NOT NULL,
    cidade         VARCHAR(100) NOT NULL,
    estado         CHAR(2) NOT NULL,
    cep            CHAR(8) NOT NULL,
    data_criacao   TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo     BOOLEAN NOT NULL DEFAULT TRUE
);