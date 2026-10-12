/**
 * Tabela: dim_local
 *
 * Descrição:
 * Disponibiliza os locais existentes dentro de cada endereço,
 * permitindo análises por sala, laboratório e demais ambientes.
 *
 * Dependências:
 * - local_endereco
 */

CREATE OR REPLACE VIEW dim_local AS
SELECT
    le.id AS local_id,
    le.endereco_id,
    le.nome AS nome_local,
    CASE le.tipo_local_endereco
        WHEN 1 THEN 'Sala de Aula'
        WHEN 2 THEN 'Laboratório'
        WHEN 3 THEN 'Depto. Administrativo'
        WHEN 4 THEN 'Auditório'
        WHEN 5 THEN 'Almoxarifado'
        WHEN 6 THEN 'Área Comum'
    END AS tipo_local,
    le.descricao,
    le.esta_ativo
FROM local_endereco le;
