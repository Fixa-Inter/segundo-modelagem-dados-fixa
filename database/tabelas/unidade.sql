/*
 * Tabela: unidade
 *
 * Descrição:
 * Armazena as unidades e seus endereços físicos associados às instituições cadastradas.
 *
 * Dependências:
 * - instituicao
 */

CREATE TABLE unidade(
    id             BIGSERIAL PRIMARY KEY,
    instituicao_id BIGINT NOT NULL REFERENCES instituicao(id),
    nome           VARCHAR(100) NOT NULL,
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
