/*
 * Tabela: aptidao
 *
 * Descrição:
 * Registra a aptidão dos técnicos para categorias de problemas.
 *
 * Dependências:
 * - usuario
 */

CREATE TABLE aptidao (
    id                  BIGSERIAL PRIMARY KEY,
    usuario_id          BIGINT NOT NULL REFERENCES usuario(id),
    categoria_problema  INTEGER NOT NULL,
    nota                DECIMAL(4, 2) NOT NULL,
    data_criacao        TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo          BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT uk_usuario_categoria_aptidao UNIQUE (usuario_id, categoria_problema),
    CONSTRAINT ck_categoria_problema_aptidao_1_a_10 CHECK (categoria_problema BETWEEN 1 AND 10)
);
