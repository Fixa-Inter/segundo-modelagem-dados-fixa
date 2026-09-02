/*
 * Tabela: aptidao
 *
 * Descrição:
 * Registra o nível de aptidão de um técnico para cada categoria
 * de problema, permitindo avaliar sua capacidade de atendimento.
 *
 * Dependências:
 * - usuario
 */

CREATE TABLE aptidao(
    id                 SERIAL PRIMARY KEY,
    usuario_id         INTEGER NOT NULL REFERENCES usuario(id),
    categoria_problema INTEGER NOT NULL,
    nota               DECIMAL(4,2) NOT NULL, -- As notas vão de 0.00 a 10.00
    data_criacao       TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo         BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT uk_usuario_categoria_aptidao UNIQUE (usuario_id, categoria_problema)
);