/*
 * Tabela: ocorrencia
 *
 * Descrição:
 * Registra problemas não registrados previamente, mas que já foram
 * resolvidos por um técnico.
 *
 * Dependências:
 * - usuario
 * - local_endereco
 * - categoria_equipamento
 */

CREATE TABLE ocorrencia (
    id                       BIGSERIAL PRIMARY KEY,
    usuario_id               BIGINT NOT NULL REFERENCES usuario(id),
    local_endereco_id        BIGINT NOT NULL REFERENCES local_endereco(id),
    categoria_equipamento_id BIGINT NOT NULL REFERENCES categoria_equipamento(id),
    categoria_problema       INTEGER NOT NULL,
    titulo                   VARCHAR(100) NOT NULL,
    descricao_ocorrencia     VARCHAR(255) NOT NULL,
    descricao_local          VARCHAR(255) NOT NULL,
    prioridade               INTEGER NOT NULL,
    data_criacao             TIMESTAMP NOT NULL DEFAULT NOW(),
    data_atualizacao         TIMESTAMP DEFAULT NOW(),
    esta_ativo               BOOLEAN NOT NULL DEFAULT TRUE,
    CONSTRAINT ck_categoria_problema_ocorrencia_1_a_10 CHECK (categoria_problema BETWEEN 1 AND 10),
    CONSTRAINT ck_prioridade_ocorrencia_0_a_2 CHECK (prioridade BETWEEN 0 AND 2)
);
