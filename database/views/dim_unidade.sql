/**
 * Tabela: dim_unidade
 *
 * Descrição:
 * Disponibiliza as unidades das instituições para análise,
 * representando a unidade de atuação dos gestores.
 *
 * Dependências:
 * - unidade
 */

CREATE OR REPLACE VIEW dim_unidade AS
SELECT
    e.id AS unidade_id,
    e.instituicao_id,
    e.cnpj,
    e.logradouro,
    e.numero,
    e.complemento,
    e.bairro,
    e.cidade,
    e.estado,
    e.cep,
    e.esta_ativo,
    e.nome
FROM unidade e;
