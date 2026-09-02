/*
 * Tabela: contrato
 *
 * Descrição:
 * Registra os contratos firmados com as instituições,
 * vinculando o plano contratado ao endereço correspondente.
 *
 * Dependências:
 * - plano
 * - endereco
 */

CREATE TABLE contrato(
    id           SERIAL PRIMARY KEY,
    plano_id     INTEGER NOT NULL REFERENCES plano(id),
    endereco_id  INTEGER NOT NULL REFERENCES endereco(id),
    data_inicio  DATE NOT NULL,
    data_fim     DATE NOT NULL,
    status       INTEGER NOT NULL DEFAULT 0, -- 0 = Ativo, 1 = Inativo, 2 = Cancelado
    data_criacao TIMESTAMP NOT NULL DEFAULT NOW()
);
