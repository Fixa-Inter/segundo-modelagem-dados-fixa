/**
 * Tabela: dim_endereco
 *
 * Descrição:
 * Disponibiliza os endereços das instituições para análise,
 * representando a unidade de atuação dos gestores.
 *
 * Dependências:
 * - endereco
 */

CREATE OR REPLACE VIEW dim_endereco AS
SELECT
    e.id AS endereco_id,
    e.instituicao_id,
    e.cnpj,
    e.logradouro,
    e.numero,
    e.complemento,
    e.bairro,
    e.cidade,
    e.estado,
    e.cep,
    e.esta_ativo
FROM endereco e;
