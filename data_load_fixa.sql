-- ===================================================
-- SCRIPT DE MASSA DE DADOS (SEED) - v3
-- Requisito: carga inicial de pelo menos 500 registros
-- verossímeis para testes de volume.
-- ---------------------------------------------------
-- Total gerado por este script: ~835 registros
-- ---------------------------------------------------
-- OBS 1: Execução sequencial pós-DDL em banco limpo,
--        considerando IDs SERIAL iniciando em 1 sem
--        lacunas (nenhum INSERT/DELETE anterior).
-- OBS 2: Mapeamento de enums/códigos inteiros:
--        • instituicao.tipo_instituicao        -> 1=Escola, 2=Faculdade, 3=Empresa, 4=Órgão Público
--        • contrato.status                     -> 1=Ativo, 2=Inativo, 3=Cancelado
--        • pagamento.status                    -> 1=Pendente, 2=Aprovado, 3=Rejeitado
--        • pagamento.metodo_pagamento          -> 1=Crédito, 2=Débito, 3=Pix
--        • usuario.tipo_acesso                 -> 1=Administrador, 2=Gestor, 3=Técnico, 4=Solicitante
--        • categoria_problema (aptidao/ocorrencia/ordem_servico)
--                                               -> 1=Elétrica, 2=Hidráulica, 3=Mecânica, 4=Informática,
--                                                  5=Mobiliário, 6=Climatização, 7=Rede e Conectividade,
--                                                  8=Segurança, 9=Iluminação, 10=Limpeza e Conservação
--        • local_endereco.tipo_local_endereco  -> 1=Sala de Aula, 2=Laboratório, 3=Depto. Administrativo,
--                                                  4=Auditório, 5=Almoxarifado, 6=Área Comum
--        • problema.status                     -> 0=Pendente, 1=Aprovado, 2=Reprovado
--        • ocorrencia.prioridade / ordem_servico.prioridade
--                                               -> sem enum nomeado nas APIs; apenas CHECK 0 a 2
-- OBS 3: Arco exclusivo em `foto` (`ck_foto_apenas_uma_fk`): exatamente 1 FK preenchida por registro.
-- OBS 4: `turno.hora_inicio`/`hora_fim` em segundos (0 a 86400), respeitando `atravessa_meia_noite`.
-- OBS 5: Mapeamento 1:1 estrito entre `ordem_servico` e `problema`: SOMENTE problemas com
--        status = 1 (Aprovado) geram ordem de serviço.
-- OBS 6: `problema.motivo_recusa` preenchido única e exclusivamente quando status = 2 (Reprovado),
--        respeitando `ck_motivo_recusa_status_recusado`.
-- OBS 7: Modelo v3 NÃO possui hierarquia entre usuários (coluna `gerente_id` foi removida do
--        schema); todos os 60 usuários são gerados sem gestor vinculado.
-- OBS 8: `endereco.cnpj` é único por endereço/franquia (10 CNPJs distintos). `instituicao` não
--        possui mais coluna `cnpj` (migrada para `endereco`), mas ganhou `email_corporativo`
--        (nullable, UNIQUE quando preenchido) e manteve `tipo_instituicao`/`dominio_email`.
-- OBS 9: Integridade referencial garantida via ranges de ID fixos e conhecidos (ver contagens
--        por tabela nos comentários de cada bloco).
-- ===================================================

BEGIN;

-- ===================================================
-- 1) super_admin (3)
-- ===================================================
INSERT INTO super_admin (nome, email, senha_hash, esta_ativo) VALUES
('Rafael Monteiro', 'rafael.monteiro@plataforma.com', 'hash_senha_001', TRUE),
('Juliana Prado',    'juliana.prado@plataforma.com',   'hash_senha_002', TRUE),
('Marcelo Nogueira', 'marcelo.nogueira@plataforma.com','hash_senha_003', FALSE);

-- ===================================================
-- 2) instituicao (5)
-- ===================================================
INSERT INTO instituicao (nome, tipo_instituicao, email_corporativo, dominio_email, esta_ativo)
SELECT
    (ARRAY['Colégio Horizonte','Faculdade Vértice','Indústrias Aurora','Secretaria Municipal de Obras','Instituto Educacional Nova Era'])[n],
    (ARRAY[1,2,3,4,1])[n],
    (ARRAY['contato@colegiohorizonte.edu.br','contato@faculdadevertice.edu.br','contato@industriasaurora.com.br','contato@sec-obras.gov.br','contato@institutonovaera.edu.br'])[n],
    (ARRAY['colegiohorizonte.edu.br','faculdadevertice.edu.br','industriasaurora.com.br','sec-obras.gov.br','institutonovaera.edu.br'])[n],
    TRUE
FROM generate_series(1,5) AS n;

-- ===================================================
-- 3) endereco (10) — 2 por instituição, cnpj único por endereço
-- ===================================================
INSERT INTO endereco (instituicao_id, cnpj, logradouro, numero, complemento, bairro, cidade, estado, cep, esta_ativo)
SELECT
    ((n-1)/2)+1,
    LPAD((10000000000000 + n * 137)::text, 14, '0'),
    (ARRAY['Rua das Acácias','Av. Paulista','Rua Sete de Setembro','Rua dos Andradas','Av. Brasil','Rua XV de Novembro','Rua Marechal Deodoro','Av. Ipiranga','Rua Barão do Rio Branco','Rua Voluntários da Pátria'])[n],
    (100 + n * 10)::text,
    CASE WHEN n % 3 = 0 THEN 'Bloco ' || n ELSE NULL END,
    (ARRAY['Centro','Jardim América','Vila Nova','Boa Vista','Santa Cecília','Cidade Alta','Bela Vista','Alto da Glória','Jardim Europa','Vila Industrial'])[n],
    (ARRAY['São Paulo','Campinas','Curitiba','Porto Alegre','Belo Horizonte','Salvador','Recife','Fortaleza','Brasília','Florianópolis'])[n],
    (ARRAY['SP','SP','PR','RS','MG','BA','PE','CE','DF','SC'])[n],
    LPAD((1000000 + n * 111)::text, 8, '0'),
    TRUE
FROM generate_series(1,10) AS n;

-- ===================================================
-- 4) plano (4)
-- ===================================================
INSERT INTO plano (nome, valor, descricao, duracao_meses, esta_ativo) VALUES
('Plano Básico',      499.90,  'Suporte a chamados essenciais com SLA padrão.', 12, TRUE),
('Plano Intermediário',899.90, 'Inclui gestão de equipamentos e turnos.',        12, TRUE),
('Plano Avançado',    1599.90, 'Recursos completos com relatórios avançados.',   24, TRUE),
('Plano Corporativo', 2999.90, 'Atendimento dedicado para múltiplas unidades.',  36, TRUE);

-- ===================================================
-- 5) contrato (10) — 1 por endereço; status 1/2/3 (Ativo/Inativo/Cancelado)
-- ===================================================
INSERT INTO contrato (plano_id, endereco_id, data_inicio, data_fim, status)
SELECT
    ((n-1) % 4) + 1,
    n,
    (CURRENT_DATE - ((n * 45) || ' days')::interval)::date,
    (CURRENT_DATE - ((n * 45) || ' days')::interval + interval '12 months')::date,
    ((n % 3) + 1)
FROM generate_series(1,10) AS n;

-- ===================================================
-- 6) pagamento (20) — 2 por contrato; status 1/2/3 (Finalizado/Pendente/Cancelado)
-- ===================================================
INSERT INTO pagamento (contrato_id, data_pagamento, valor_pago, status, metodo_pagamento)
SELECT
    ((n-1)/2)+1,
    NOW() - ((n * 15) || ' days')::interval,
    (ARRAY[499.90,899.90,1599.90,2999.90])[(((n-1)/2) % 4) + 1],
    ((n % 3) + 1),
    ((n % 3) + 1)
FROM generate_series(1,20) AS n;

-- ===================================================
-- 7) usuario (60) — SEM hierarquia (gerente_id não existe no schema v3)
--    1-5   Administradores
--    6-15  Gestores
--    16-40 Técnicos
--    41-60 Solicitantes
-- ===================================================
INSERT INTO usuario (endereco_id, nome_completo, email, tipo_acesso, senha_hash, cargo, data_nascimento, esta_ativo, primeiro_acesso)
SELECT
    ((n-1) % 10) + 1 AS endereco_id,
    (ARRAY['Ana','Bruno','Carla','Diego','Elaine','Fábio','Gabriela','Heitor','Iris','João',
           'Karina','Leandro','Marina','Nelson','Otávia','Paulo','Queila','Rodrigo','Sabrina','Tiago'])[((n-1) % 20)+1]
    || ' ' ||
    (ARRAY['Almeida','Barbosa','Cardoso','Dias','Esteves','Farias','Gonçalves','Henriques','Ibrahim','Junqueira',
           'Klein','Lopes','Martins','Nascimento','Oliveira','Pires','Quintana','Ribeiro','Sales','Teixeira'])[((n*7-1) % 20)+1]
    AS nome_completo,
    'usuario' || n || '@plataforma.com',
    CASE
        WHEN n <= 5  THEN 1
        WHEN n <= 15 THEN 2
        WHEN n <= 40 THEN 3
        ELSE               4
    END AS tipo_acesso,
    'hash_senha_' || LPAD(n::text, 3, '0'),
    CASE
        WHEN n <= 5  THEN 'Administrador de Plataforma'
        WHEN n <= 15 THEN 'Gestor de Facilities'
        WHEN n <= 40 THEN 'Técnico de Manutenção'
        ELSE               'Solicitante'
    END AS cargo,
    (DATE '1975-01-01' + ((n * 137) || ' days')::interval)::date,
    (n % 4) <> 0,
    (n % 5) = 0
FROM generate_series(1,60) AS n;

-- ===================================================
-- 8) aptidao (50) — apenas técnicos (usuario_id 16-40), 2 categorias por técnico
-- ===================================================
INSERT INTO aptidao (usuario_id, categoria_problema, nota, esta_ativo)
SELECT
    usuario_id,
    categoria_problema,
    nota,
    TRUE
FROM (
    SELECT
        16 + k AS usuario_id,
        (k % 10) + 1 AS categoria_problema,
        ROUND((5 + (k % 5) * 0.9)::numeric, 2) AS nota
    FROM generate_series(0,24) AS k
    UNION ALL
    SELECT
        16 + k AS usuario_id,
        ((k + 3) % 10) + 1 AS categoria_problema,
        ROUND((6 + (k % 4) * 1.1)::numeric, 2) AS nota
    FROM generate_series(0,24) AS k
) AS aptidoes;

-- ===================================================
-- 9) local_endereco (40) — 4 por endereço
-- ===================================================
INSERT INTO local_endereco (endereco_id, nome, tipo_local_endereco, descricao, esta_ativo)
SELECT
    ((n-1)/4)+1,
    (ARRAY['Sala 101','Laboratório de Informática','Depto. Administrativo','Auditório Principal',
           'Almoxarifado Central','Área de Convivência','Sala 202','Laboratório de Química'])[((n-1) % 8)+1]
    || ' - Bloco ' || (((n-1)/4)+1),
    (ARRAY[1,2,3,4,5,6,1,2])[((n-1) % 8)+1],
    'Local utilizado para atividades cotidianas da unidade.',
    TRUE
FROM generate_series(1,40) AS n;

-- ===================================================
-- 10) evento (30)
-- ===================================================
INSERT INTO evento (usuario_id, local_endereco_id, titulo, descricao, descricao_local, observacao, data_hora_inicio, data_hora_fim)
SELECT
    ((n-1) % 60) + 1,
    ((n-1) % 40) + 1,
    'Manutenção Preventiva ' || n,
    'Evento de manutenção preventiva programada.',
    'Local conforme cadastro do setor.',
    CASE WHEN n % 4 = 0 THEN 'Requer acompanhamento do responsável do setor.' ELSE NULL END,
    NOW() + ((n * 2) || ' days')::interval,
    NOW() + ((n * 2) || ' days')::interval + interval '2 hours'
FROM generate_series(1,30) AS n;

-- ===================================================
-- 11) categoria_equipamento (10)
-- ===================================================
INSERT INTO categoria_equipamento (usuario_id, nome, descricao, esta_ativo)
SELECT
    ((n-1) % 10) + 1,
    (ARRAY['Informática','Elétrica','Mobiliário','Climatização','Iluminação',
           'Hidráulica','Segurança','Rede','Limpeza','Mecânica'])[n],
    'Categoria utilizada para classificação de equipamentos.',
    TRUE
FROM generate_series(1,10) AS n;

-- ===================================================
-- 12) marca_equipamento (8)
-- ===================================================
INSERT INTO marca_equipamento (nome, descricao, esta_ativo) VALUES
('TechLine',   'Fabricante de equipamentos de informática.', TRUE),
('ClimaMax',   'Fabricante de equipamentos de climatização.', TRUE),
('LuxLight',   'Fabricante de equipamentos de iluminação.',   TRUE),
('HidroPro',   'Fabricante de equipamentos hidráulicos.',     TRUE),
('SegurTech',  'Fabricante de equipamentos de segurança.',    TRUE),
('MobiliaBras','Fabricante de mobiliário corporativo.',       TRUE),
('RedeTotal',  'Fabricante de equipamentos de rede.',         TRUE),
('MecanixCo',  'Fabricante de componentes mecânicos.',        TRUE);

-- ===================================================
-- 13) modelo_equipamento (20)
-- ===================================================
INSERT INTO modelo_equipamento (marca_equipamento_id, categoria_equipamento_id, nome, descricao, esta_ativo)
SELECT
    ((n-1) % 8) + 1,
    ((n-1) % 10) + 1,
    'Modelo ' || n,
    'Modelo padrão utilizado nas unidades da instituição.',
    TRUE
FROM generate_series(1,20) AS n;

-- ===================================================
-- 14) equipamento (80)
-- ===================================================
INSERT INTO equipamento (usuario_id, modelo_equipamento_id, local_endereco_id, codigo, esta_ativo)
SELECT
    ((n-1) % 60) + 1,
    ((n-1) % 20) + 1,
    ((n-1) % 40) + 1,
    'EQP-' || LPAD(n::text, 5, '0'),
    (n % 6) <> 0
FROM generate_series(1,80) AS n;

-- ===================================================
-- 15) problema (60)
--     status: n%4 IN (0,1) -> Aprovado(1) [30]; n%4=2 -> Pendente(0) [15]; n%4=3 -> Reprovado(2) [15]
-- ===================================================
INSERT INTO problema (usuario_id, categoria_equipamento_id, local_endereco_id, titulo, descricao_problema, descricao_local, motivo_recusa, status)
SELECT
    40 + ((n-1) % 20) + 1,
    ((n-1) % 10) + 1,
    ((n-1) % 40) + 1,
    'Problema reportado ' || n,
    'Descrição detalhada do problema identificado pelo solicitante.',
    'Local onde o problema foi identificado.',
    CASE WHEN (n % 4) = 3 THEN 'Problema já solucionado anteriormente ou fora do escopo de atendimento.' ELSE NULL END,
    CASE
        WHEN (n % 4) IN (0,1) THEN 1
        WHEN (n % 4) = 2      THEN 0
        ELSE                       2
    END
FROM generate_series(1,60) AS n;

-- ===================================================
-- 16) ocorrencia (40)
-- ===================================================
INSERT INTO ocorrencia (usuario_id, local_endereco_id, equipamento_id, categoria_problema, titulo, descricao_ocorrencia, descricao_local, prioridade, esta_ativo)
SELECT
    16 + ((n-1) % 25),
    ((n-1) % 40) + 1,
    ((n-1) % 80) + 1,
    ((n-1) % 10) + 1,
    'Ocorrência resolvida ' || n,
    'Ocorrência identificada e solucionada diretamente pelo técnico responsável.',
    'Local do equipamento conforme cadastro.',
    (n % 3),
    TRUE
FROM generate_series(1,40) AS n;

-- ===================================================
-- 17) status_ordem_servico (5)
-- ===================================================
INSERT INTO status_ordem_servico (nome, descricao) VALUES
('Aberta',            'Ordem de serviço registrada e aguardando triagem.'),
('Em Andamento',      'Ordem de serviço em execução por um técnico responsável.'),
('Aguardando Peça',   'Execução pausada aguardando peça ou material.'),
('Concluída',         'Ordem de serviço finalizada com sucesso.'),
('Cancelada',         'Ordem de serviço cancelada antes da conclusão.');

-- ===================================================
-- 18) ordem_servico (30) — SOMENTE problemas com status = 1 (Aprovado), 1:1 estrito
-- ===================================================
INSERT INTO ordem_servico (problema_id, usuario_id, status_ordem_servico_id, categoria_problema, data_prevista, prioridade)
SELECT
    p.id,
    16 + ((rn-1) % 25),
    ((rn-1) % 5) + 1,
    ((rn-1) % 10) + 1,
    NOW() + ((rn * 3) || ' days')::interval,
    (rn % 3)
FROM (
    SELECT id, ROW_NUMBER() OVER (ORDER BY id) AS rn
    FROM problema
    WHERE status = 1
) AS p;

-- ===================================================
-- 19) ordem_servico_status_historico (45) — ~1.5 por OS
-- ===================================================
INSERT INTO ordem_servico_status_historico (ordem_servico_id, status_ordem_servico_id, data_atualizacao)
SELECT
    ((n-1) % 30) + 1,
    ((n-1) % 5) + 1,
    NOW() - ((n * 4) || ' hours')::interval
FROM generate_series(1,45) AS n;

-- ===================================================
-- 20) tarefa (80) — distribuídas entre as 30 OS
-- ===================================================
INSERT INTO tarefa (ordem_servico_id, status_ordem_servico_id, titulo, descricao)
SELECT
    ((n-1) % 30) + 1,
    ((n-1) % 5) + 1,
    'Tarefa ' || n,
    'Etapa de execução vinculada à ordem de serviço correspondente.'
FROM generate_series(1,80) AS n;

-- ===================================================
-- 21) tarefa_status_historico (100)
-- ===================================================
INSERT INTO tarefa_status_historico (tarefa_id, status_ordem_servico_id, data_atualizacao)
SELECT
    ((n-1) % 80) + 1,
    ((n-1) % 5) + 1,
    NOW() - ((n * 3) || ' hours')::interval
FROM generate_series(1,100) AS n;

-- ===================================================
-- 22) observacao_conclusao (15) — subconjunto de OS concluídas
-- ===================================================
INSERT INTO observacao_conclusao (ordem_servico_id, observacao)
SELECT
    n,
    'Serviço concluído conforme solicitado, sem pendências adicionais.'
FROM generate_series(1,15) AS n;

-- ===================================================
-- 23) foto (50) — arco exclusivo: 10 registros por tipo de FK
-- ===================================================
INSERT INTO foto (problema_id, ocorrencia_id, ordem_servico_id, observacao_conclusao_id, usuario_id, url, esta_ativo)
SELECT ((n-1) % 60) + 1, NULL::integer, NULL::integer, NULL::integer, NULL::integer,
       'https://storage.plataforma.com/fotos/problema_' || n || '.jpg', TRUE
FROM generate_series(1,10) AS n
UNION ALL
SELECT NULL::integer, ((n-1) % 40) + 1, NULL::integer, NULL::integer, NULL::integer,
       'https://storage.plataforma.com/fotos/ocorrencia_' || n || '.jpg', TRUE
FROM generate_series(1,10) AS n
UNION ALL
SELECT NULL::integer, NULL::integer, ((n-1) % 30) + 1, NULL::integer, NULL::integer,
       'https://storage.plataforma.com/fotos/os_' || n || '.jpg', TRUE
FROM generate_series(1,10) AS n
UNION ALL
SELECT NULL::integer, NULL::integer, NULL::integer, ((n-1) % 15) + 1, NULL::integer,
       'https://storage.plataforma.com/fotos/conclusao_' || n || '.jpg', TRUE
FROM generate_series(1,10) AS n
UNION ALL
SELECT NULL::integer, NULL::integer, NULL::integer, NULL::integer, ((n-1) % 60) + 1,
       'https://storage.plataforma.com/fotos/usuario_' || n || '.jpg', TRUE
FROM generate_series(1,10) AS n;

-- ===================================================
-- 24) turno (20) — 2 por endereço (1 diurno + 1 noturno cruzando meia-noite)
-- ===================================================
INSERT INTO turno (endereco_id, nome, hora_inicio, hora_fim, atravessa_meia_noite, esta_ativo)
SELECT
    ((n-1)/2)+1,
    CASE WHEN n % 2 = 1 THEN 'Turno Diurno' ELSE 'Turno Noturno' END,
    CASE WHEN n % 2 = 1 THEN 21600 ELSE 72000 END,  -- 06:00 ou 20:00
    CASE WHEN n % 2 = 1 THEN 61200 ELSE 21600 END,  -- 17:00 ou 06:00 (dia seguinte)
    CASE WHEN n % 2 = 1 THEN FALSE ELSE TRUE END,
    TRUE
FROM generate_series(1,20) AS n;

-- ===================================================
-- 25) turno_usuario (40) — pares únicos (turno_id, usuario_id)
-- ===================================================
INSERT INTO turno_usuario (turno_id, usuario_id, esta_ativo)
SELECT ((n-1) % 20) + 1, 16 + ((n-1) % 20), TRUE
FROM generate_series(1,20) AS n
UNION ALL
SELECT ((n-1) % 20) + 1, 41 + ((n-1) % 20), TRUE
FROM generate_series(1,20) AS n;

COMMIT;