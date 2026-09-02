/*
 * Tabela: problema
 *
 * Descrição:
 * Registra problemas identificados na instituição, incluindo sua
 * categoria, localização, descrição e situação de aprovação.
 *
 * Dependências:
 * - usuario
 * - categoria_equipamento
 * - local_endereco
 */

CREATE TABLE problema(
    id                       SERIAL PRIMARY KEY,
    usuario_id               INTEGER NOT NULL REFERENCES usuario(id),
    categoria_equipamento_id INTEGER NOT NULL REFERENCES categoria_equipamento(id),
    local_endereco_id        INTEGER NOT NULL REFERENCES local_endereco(id),
    titulo                   VARCHAR(100) NOT NULL,
    descricao_problema       VARCHAR(255) NOT NULL,
    descricao_local          VARCHAR(255) NOT NULL,
    data_criacao             TIMESTAMP NOT NULL DEFAULT NOW(),
    status                   INTEGER NOT NULL DEFAULT 0 -- 0 = Pendente, 1 = Aprovado, 2 = Reprovado
);