/*
 * Tabela: ordem_servico
 *
 * Descrição:
 * Registra as ordens de serviço e seu acompanhamento.
 *
 * Dependências:
 * - problema
 * - usuario
 */

CREATE TABLE ordem_servico (
    id                       SERIAL PRIMARY KEY,
    problema_id              INTEGER NOT NULL UNIQUE REFERENCES problema(id),
    usuario_id               INTEGER NOT NULL REFERENCES usuario(id),
    status_ordem_servico     INTEGER NOT NULL DEFAULT 0,
    categoria_problema       INTEGER NOT NULL,
    data_prevista            TIMESTAMP NOT NULL,
    prioridade               INTEGER NOT NULL,
    data_criacao             TIMESTAMP NOT NULL DEFAULT NOW(),
    CONSTRAINT ck_status_ordem_servico CHECK (status_ordem_servico BETWEEN 0 AND 4),
    CONSTRAINT ck_categoria_problema_os_1_a_10 CHECK (categoria_problema BETWEEN 1 AND 10),
    CONSTRAINT ck_prioridade_os_0_a_2 CHECK (prioridade BETWEEN 0 AND 2)
);
