/*
 * Tabela: ordem_servico
 *
 * Descrição:
 * Quando o problema é aceito pela plataforma ele se torna uma Ordem de Serviço, 
 * que é o registro do problema que será resolvido por um técnico.
 *
 * Dependências:
 * - problema
 * - usuario
 * - status_ordem_servico
 */

CREATE TABLE ordem_servico(
    id                      SERIAL PRIMARY KEY,
    problema_id             INTEGER NOT NULL REFERENCES problema(id),
    usuario_id              INTEGER NOT NULL REFERENCES usuario(id),
    status_ordem_servico_id INTEGER NOT NULL REFERENCES status_ordem_servico(id),
    categoria_problema      INTEGER NOT NULL,
    data_prevista           TIMESTAMP NOT NULL,
    prioridade              INTEGER NOT NULL,
    data_criacao            TIMESTAMP NOT NULL DEFAULT NOW(),

    CONSTRAINT ck_prioridade_os_0_a_2 
        CHECK (prioridade >= 0 AND prioridade <= 2)
);