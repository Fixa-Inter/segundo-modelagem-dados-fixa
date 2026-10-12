/*
 * Tabela: local_endereco
 *
 * Descrição:
 * Representa locais específicos dentro dos endereços.
 *
 * Dependências:
 * - endereco
 */

CREATE TABLE local_endereco (
    id                   SERIAL PRIMARY KEY,
    endereco_id          INTEGER NOT NULL REFERENCES endereco(id),
    nome                 VARCHAR(100) NOT NULL,
    tipo_local_endereco  INTEGER NOT NULL,
    descricao            VARCHAR(255) NOT NULL,
    data_criacao         TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo           BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_tipo_local_endereco_1_a_6 CHECK (tipo_local_endereco BETWEEN 1 AND 6)
);
