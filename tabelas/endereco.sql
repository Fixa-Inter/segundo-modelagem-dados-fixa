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
    logradouro     VARCHAR(100) NOT NULL,
    numero         VARCHAR(10) NOT NULL,
    complemento    VARCHAR(100),
    bairro         VARCHAR(100) NOT NULL,
    cidade         VARCHAR(100) NOT NULL,
    estado         VARCHAR(2) NOT NULL,
    pais           VARCHAR(100) NOT NULL,
    cep            VARCHAR(10) NOT NULL,
    data_criacao   TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo     BOOLEAN NOT NULL DEFAULT TRUE
);
