/*
 * Tabela: status_ordem_servico
 *
 * Descrição:
 * Define os possíveis status utilizados para acompanhar o andamento
 * das ordens de serviço na plataforma.
 * Basicamente, representa as colunas do kanban dos técnicos, onde
 * cada status é uma coluna e as ordens de serviço são os cartões.
 *
 *
 * Dependências:
 * - Nenhuma
 */

CREATE TABLE status_ordem_servico(
    id        SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    descricao VARCHAR(255)
);
