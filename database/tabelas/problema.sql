/*
 * Tabela: problema
 *
 * Descrição:
 * Registra problemas identificados nas instituições.
 *
 * Dependências:
 * - usuario
 * - categoria_equipamento
 * - local_endereco
 */

CREATE TABLE problema (
    id                       BIGSERIAL PRIMARY KEY,
    usuario_id               BIGINT NOT NULL REFERENCES usuario(id),
    categoria_equipamento_id BIGINT NOT NULL REFERENCES categoria_equipamento(id),
    local_endereco_id        BIGINT NOT NULL REFERENCES local_endereco(id),
    titulo                   VARCHAR(100) NOT NULL,
    descricao_problema       VARCHAR(255) NOT NULL,
    descricao_local          VARCHAR(255) NOT NULL,
    motivo_recusa            VARCHAR(255),
    data_criacao             TIMESTAMP NOT NULL DEFAULT NOW(),
    data_atualizacao         TIMESTAMP DEFAULT NOW(),
    esta_ativo               BOOLEAN NOT NULL DEFAULT TRUE,
    status                   INTEGER NOT NULL DEFAULT 0,
    CONSTRAINT ck_status_problema_0_a_2 CHECK (status BETWEEN 0 AND 2),
    CONSTRAINT ck_motivo_recusa_status_recusado CHECK (
        (status = 2 AND motivo_recusa IS NOT NULL)
        OR
        (status <> 2 AND motivo_recusa IS NULL)
    )
);
