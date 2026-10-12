/**
 * Tabela: dim_categoria_problema
 *
 * Descrição:
 * Disponibiliza as categorias de problema utilizadas
 * nas ordens de serviço e análises do BI.
 *
 * Dependências:
 * - Nenhuma
 */

CREATE OR REPLACE VIEW dim_categoria_problema AS
SELECT *
FROM (
    VALUES
        (1,  'Elétrica'),
        (2,  'Hidráulica'),
        (3,  'Mecânica'),
        (4,  'Informática'),
        (5,  'Mobiliário'),
        (6,  'Climatização'),
        (7,  'Rede e Conectividade'),
        (8,  'Segurança'),
        (9,  'Iluminação'),
        (10, 'Limpeza e Conservação')
) AS categoria (
    categoria_problema_id,
    nome
);
