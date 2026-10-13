/*
 * Tabela: plano
 *
 * Descrição:
 * Define os planos disponíveis para contratação na plataforma.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE plano(
    id            SERIAL PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    valor         DECIMAL(10,2) NOT NULL,
    descricao     VARCHAR(255),
    duracao_meses INTEGER NOT NULL,
    data_criacao  TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo    BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT ck_duracao_meses_positiva
        CHECK (duracao_meses > 0)
);