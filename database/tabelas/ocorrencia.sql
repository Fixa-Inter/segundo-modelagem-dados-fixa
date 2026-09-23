/*
 * Tabela: ocorrencia
 *
 * Descrição:
 * Registra as ocorrências, são problemas que não foram registrados na plataforma,
 * mas que já foram resolvidos por um técnico, então ele registra o problema que ele resolveu.
 *
 * Dependências:
 * - usuario
 * - local_endereco
 * - equipamento
 */

CREATE TABLE ocorrencia(
    id                   SERIAL PRIMARY KEY,
    usuario_id           INTEGER NOT NULL REFERENCES usuario(id),
    local_endereco_id    INTEGER NOT NULL REFERENCES local_endereco(id),
    equipamento_id       INTEGER NOT NULL REFERENCES equipamento(id),
    categoria_problema   INTEGER NOT NULL,
    titulo               VARCHAR(100) NOT NULL,
    descricao_ocorrencia VARCHAR(255) NOT NULL,
    descricao_local      VARCHAR(255) NOT NULL,
    prioridade           INTEGER NOT NULL,
    data_criacao         TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT ck_prioridade_ocorrencia_0_a_2 
        CHECK (prioridade >= 0 AND prioridade <= 2)
);