/*
 * Tabela: status_ordem_servico
 *
 * Descrição:
 * Define os status utilizados nas ordens de serviço e nas tarefas.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE status_ordem_servico (
    id         SERIAL PRIMARY KEY,
    nome       VARCHAR(100) NOT NULL,
    descricao  VARCHAR(255)
);
