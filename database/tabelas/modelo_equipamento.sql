/*
 * Tabela: modelo_equipamento
 *
 * Descrição:
 * Armazena os modelos de equipamentos, relacionando cada modelo
 * à sua marca e categoria.
 *
 * Dependências:
 * - marca_equipamento
 * - categoria_equipamento
 */

CREATE TABLE modelo_equipamento(
    id                       SERIAL PRIMARY KEY,
    marca_equipamento_id     INTEGER NOT NULL REFERENCES marca_equipamento(id),
    categoria_equipamento_id INTEGER NOT NULL REFERENCES categoria_equipamento(id),
    nome                     VARCHAR(100) NOT NULL,
    descricao                VARCHAR(255) NOT NULL,
    data_criacao             TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo               BOOLEAN NOT NULL DEFAULT TRUE
);