/*
 * Tabela: turno
 *
 * Descrição:
 * Define os turnos de funcionamento associados aos endereços
 * das instituições, incluindo horários de início e término.
 *
 * Dependências:
 * - endereco
 */

CREATE TABLE turno(
    id                   SERIAL PRIMARY KEY,
    endereco_id    INTEGER REFERENCES endereco(id) NOT NULL,
    nome                 VARCHAR(100) NOT NULL,
    hora_inicio          INTEGER NOT NULL,
    hora_fim             INTEGER NOT NULL,
    atravessa_meia_noite BOOLEAN NOT NULL DEFAULT FALSE,
    data_criacao         TIMESTAMP NOT NULL DEFAULT NOW(),
    esta_ativo           BOOLEAN NOT NULL DEFAULT TRUE,

    CONSTRAINT ck_hora_inicio_range
        CHECK (hora_inicio >= 0 AND hora_inicio <= 86400),

    CONSTRAINT ck_hora_fim_range
        CHECK (hora_fim >= 0 AND hora_fim <= 86400),

    CONSTRAINT ck_horas_consistentes
        CHECK (
            (atravessa_meia_noite = FALSE AND hora_inicio < hora_fim)
            OR
            (atravessa_meia_noite = TRUE  AND hora_inicio > hora_fim)
        )
);