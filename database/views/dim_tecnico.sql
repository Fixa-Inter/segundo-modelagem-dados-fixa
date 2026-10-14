/**
 * Tabela: dim_tecnico
 *
 * Descrição:
 * Disponibiliza informações dos técnicos responsáveis
 * pelas ordens de serviço.
 *
 * Dependências:
 * - usuario
 */

CREATE OR REPLACE VIEW dim_tecnico AS
SELECT
    u.id AS tecnico_id,
    u.nome_completo,
    u.email,
    u.cargo,
    u.unidade_id,
    u.esta_ativo
FROM usuario u
WHERE u.tipo_acesso = 3;
