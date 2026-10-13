/*
 * Tabela: marca_equipamento
 *
 * Descrição:
 * Armazena as marcas dos equipamentos cadastrados na plataforma.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE marca_equipamento(
    id           SERIAL PRIMARY KEY,
    nome         VARCHAR(100) NOT NULL,
    descricao    VARCHAR(255) NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo   BOOLEAN NOT NULL DEFAULT TRUE
);