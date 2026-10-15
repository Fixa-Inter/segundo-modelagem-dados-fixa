/*
 * Tabela: local_unidade
 *
 * Descrição:
 * Representa locais específicos dentro das unidades.
 *
 * Dependências:
 * - unidade
 */

CREATE TABLE local_unidade (
    id                   BIGSERIAL PRIMARY KEY,
    unidade_id          BIGINT NOT NULL REFERENCES unidade(id),
    nome                 VARCHAR(100) NOT NULL,
    tipo_local_unidade  INTEGER NOT NULL,
    descricao            VARCHAR(255) NOT NULL,
    data_criacao         TIMESTAMP NOT NULL DEFAULT NOW(),
    data_atualizacao     TIMESTAMP DEFAULT NOW(),
    esta_ativo           BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_tipo_local_unidade_1_a_6 CHECK (tipo_local_unidade BETWEEN 1 AND 6)
);
