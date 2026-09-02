/*
 * Tabela: local_endereco
 *
 * Descrição:
 * Representa locais específicos dentro de um endereço institucional,
 * permitindo identificar onde equipamentos, problemas e eventos estão
 * localizados.
 *
 * Dependências:
 * - endereco
 */

CREATE TABLE local_endereco(
    id                  SERIAL PRIMARY KEY,
    endereco_id         INTEGER NOT NULL REFERENCES endereco(id),
    nome                VARCHAR(100) NOT NULL,
    tipo_local_endereco INTEGER NOT NULL,
    descricao           VARCHAR(255) NOT NULL,
    data_criacao        TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo          BOOLEAN NOT NULL DEFAULT TRUE
);