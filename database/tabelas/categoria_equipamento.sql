/*
 * Tabela: categoria_equipamento
 *
 * Descrição:
 * Armazena as categorias utilizadas para classificar os equipamentos
 * cadastrados na instituição.
 *
 * Dependências:
 * - usuario
 */

CREATE TABLE categoria_equipamento(
    id           SERIAL PRIMARY KEY,
    usuario_id   INTEGER NOT NULL REFERENCES usuario(id),
    nome         VARCHAR(100) NOT NULL,
    descricao    VARCHAR(255) NOT NULL,
    data_criacao TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo   BOOLEAN NOT NULL DEFAULT TRUE
);