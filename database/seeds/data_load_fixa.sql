-- ===================================================
-- DATALOAD / MASSA DE TESTE - FIXA
-- Requisito: carga inicial de pelo menos 500 registros
--            verossímeis para testes de volume.
--
-- Total aproximado gerado: 2.706 registros.
-- Execução esperada: banco recém-criado e vazio.
--
-- Senha padrão de TODOS os usuários e super admins: 1234
-- Hash BCrypt (cost 12): $2b$12$vo9ehiXYWpE2DoTvSHyVme8BuS2zh8nO5z9O5VfqeRZ5DoEfzhlIe
--
-- Valores fixos / enums utilizados:
-- instituicao.tipo_instituicao:
--   1=Escola, 2=Faculdade, 3=Empresa, 4=Órgão Público
-- contrato.status:
--   1=Ativo, 2=Inativo, 3=Cancelado
-- pagamento.status:
--   1=Pendente, 2=Aprovado, 3=Rejeitado
-- pagamento.metodo_pagamento:
--   1=Crédito, 2=Débito, 3=Pix
-- usuario.tipo_acesso:
--   1=Administrador, 2=Gestor, 3=Técnico, 4=Solicitante
-- categoria_problema:
--   1=Elétrica, 2=Hidráulica, 3=Mecânica, 4=Informática,
--   5=Mobiliário, 6=Climatização, 7=Rede e Conectividade,
--   8=Segurança, 9=Iluminação, 10=Limpeza e Conservação
-- local_unidade.tipo_local_unidade:
--   1=Sala de Aula, 2=Laboratório, 3=Depto. Administrativo,
--   4=Auditório, 5=Almoxarifado, 6=Área Comum
-- problema.status:
--   0=Pendente, 1=Aprovado, 2=Reprovado
-- observacao_conclusao.dificuldade:
--   1=Fácil, 2=Médio, 3=Difícil
-- ocorrencia.prioridade / ordem_servico.prioridade:
--   0=Alta, 1=Média, 2=Baixa
-- ordem_servico.status_ordem_servico e tarefa.status_ordem_servico (independentes):
--   0=Não iniciadas, 1=Atrasada, 2=Pausada, 3=Em Andamento, 4=Finalizadas
-- Os IDs e as distribuições são determinísticos; as datas são relativas
-- ao início da transação, preservando cenários atuais para os KPIs.
-- ===================================================

BEGIN;

-- ===================================================
-- 1. SUPER ADMIN (3)
-- ===================================================
INSERT INTO super_admin (id, nome, email, senha_hash, esta_ativo) VALUES
(1, 'Rafael Monteiro', 'rafael.monteiro@fixa.com.br', '$2b$12$vo9ehiXYWpE2DoTvSHyVme8BuS2zh8nO5z9O5VfqeRZ5DoEfzhlIe', TRUE),
(2, 'Juliana Prado', 'juliana.prado@fixa.com.br', '$2b$12$vo9ehiXYWpE2DoTvSHyVme8BuS2zh8nO5z9O5VfqeRZ5DoEfzhlIe', TRUE),
(3, 'Marcelo Nogueira', 'marcelo.nogueira@fixa.com.br', '$2b$12$vo9ehiXYWpE2DoTvSHyVme8BuS2zh8nO5z9O5VfqeRZ5DoEfzhlIe', TRUE);

-- ===================================================
-- 2. INSTITUIÇÃO (12)
-- ===================================================
INSERT INTO instituicao (
    id, nome, tipo_instituicao, email_corporativo,
    dominio_email, data_criacao, esta_ativo
)
SELECT
    n,
    (ARRAY[
        'Colégio Horizonte', 'Faculdade Vértice', 'Indústrias Aurora',
        'Secretaria Municipal de Obras', 'Escola Nova Geração', 'Universidade Integra',
        'Grupo Logística Sul', 'Prefeitura de Vila Serena', 'Colégio Monte Azul',
        'Centro Universitário Alpha', 'TechParts Brasil', 'Instituto Municipal de Educação'
    ])[n],
    ((n - 1) % 4) + 1,
    'contato' || n || '@instituicao' || n || '.com.br',
    'instituicao' || n || '.com.br',
    NOW() - ((420 - n * 12) || ' days')::INTERVAL,
    TRUE
FROM generate_series(1, 12) AS n;

-- ===================================================
-- 3. UNIDADE (24) - 2 unidades por instituição
-- ===================================================
INSERT INTO unidade (
    id, instituicao_id, nome, cnpj, logradouro, numero, complemento,
    bairro, cidade, estado, cep, data_criacao, esta_ativo
)
SELECT
    n,
    ((n - 1) / 2) + 1,
    'Unidade ' || n,
    LPAD((12000000000000 + n * 7919)::TEXT, 14, '0'),
    (ARRAY[
        'Rua das Acácias', 'Avenida Paulista', 'Rua Sete de Setembro',
        'Avenida Brasil', 'Rua XV de Novembro', 'Rua das Palmeiras',
        'Avenida Ipiranga', 'Rua Marechal Deodoro'
    ])[((n - 1) % 8) + 1],
    (100 + n * 7)::TEXT,
    CASE WHEN n % 3 = 0 THEN 'Bloco ' || CHR(64 + ((n - 1) % 5) + 1) ELSE NULL END,
    (ARRAY['Centro', 'Jardim América', 'Vila Nova', 'Bela Vista', 'Boa Vista', 'Vila Industrial'])[((n - 1) % 6) + 1],
    (ARRAY['São Paulo', 'Campinas', 'Osasco', 'Barueri', 'Santo André', 'Guarulhos'])[((n - 1) % 6) + 1],
    'SP',
    LPAD((6000000 + n * 173)::TEXT, 8, '0'),
    NOW() - ((360 - n * 8) || ' days')::INTERVAL,
    TRUE
FROM generate_series(1, 24) AS n;

-- ===================================================
-- 4. PLANOS (4)
-- ===================================================
INSERT INTO plano (id, nome, valor, descricao, duracao_meses, data_criacao, esta_ativo) VALUES
(1, 'Essencial',    1490.00, 'Gestão essencial de chamados de manutenção.', 12, NOW() - INTERVAL '400 days', TRUE),
(2, 'Profissional', 2490.00, 'Gestão de manutenção, equipes e equipamentos.', 12, NOW() - INTERVAL '400 days', TRUE),
(3, 'Corporativo',  3990.00, 'Recursos avançados para múltiplas unidades.', 24, NOW() - INTERVAL '400 days', TRUE),
(4, 'Enterprise',   6490.00, 'Operação completa com maior escala e suporte.', 24, NOW() - INTERVAL '400 days', TRUE);

-- ===================================================
-- 5. CONTRATOS (24) - 1 por unidade
-- ===================================================
INSERT INTO contrato (
    id, plano_id, unidade_id, data_inicio, data_fim, status, data_criacao
)
SELECT
    n,
    ((n - 1) % 4) + 1,
    n,
    (CURRENT_DATE - (220 - n * 3))::DATE,
    ((CURRENT_DATE - (220 - n * 3)) + (INTERVAL '1 month' * p.duracao_meses))::DATE,
    CASE
        WHEN n % 8 = 0 THEN 3
        WHEN n % 6 = 0 THEN 2
        ELSE 1
    END,
    NOW() - ((220 - n * 3) || ' days')::INTERVAL
FROM generate_series(1, 24) AS n
JOIN plano p ON p.id = ((n - 1) % 4) + 1;

-- ===================================================
-- 6. PAGAMENTOS (72) - 3 por contrato
-- ===================================================
INSERT INTO pagamento (
    id, contrato_id, data_pagamento, valor_pago,
    status, metodo_pagamento, data_criacao
)
SELECT
    ((c.id - 1) * 3) + parcela,
    c.id,
    c.data_inicio::TIMESTAMP + (INTERVAL '30 days' * parcela),
    p.valor,
    CASE
        WHEN (((c.id - 1) * 3) + parcela) % 11 = 0 THEN 3
        WHEN (((c.id - 1) * 3) + parcela) % 7 = 0 THEN 1
        ELSE 2
    END,
    ((((c.id - 1) * 3) + parcela - 1) % 3) + 1,
    c.data_inicio::TIMESTAMP + (INTERVAL '30 days' * parcela)
FROM contrato c
JOIN plano p ON p.id = c.plano_id
CROSS JOIN generate_series(1, 3) AS parcela;

-- ===================================================
-- 7. USUÁRIOS (144) - 6 por unidade
-- 1 Administrador, 1 Gestor, 2 Técnicos e 2 Solicitantes
-- ===================================================
INSERT INTO usuario (
    id, unidade_id, nome_completo, email, tipo_acesso, senha_hash,
    cargo, data_nascimento, data_criacao, esta_ativo, primeiro_acesso
)
SELECT
    n,
    ((n - 1) / 6) + 1,
    (ARRAY[
        'Ana', 'Bruno', 'Carla', 'Diego', 'Elaine', 'Fábio',
        'Gabriela', 'Heitor', 'Iris', 'João', 'Karina', 'Leandro',
        'Marina', 'Nelson', 'Otávia', 'Paulo', 'Renata', 'Rodrigo',
        'Sabrina', 'Tiago', 'Vanessa', 'William', 'Yasmin', 'Lucas'
    ])[((n - 1) % 24) + 1]
    || ' ' ||
    (ARRAY[
        'Almeida', 'Barbosa', 'Cardoso', 'Dias', 'Esteves', 'Farias',
        'Gonçalves', 'Henriques', 'Lopes', 'Martins', 'Nascimento', 'Oliveira'
    ])[((n * 5 - 1) % 12) + 1],
    'usuario' || n || '@instituicao' || ((((n - 1) / 6) / 2) + 1) || '.com.br',
    CASE ((n - 1) % 6) + 1
        WHEN 1 THEN 1
        WHEN 2 THEN 2
        WHEN 3 THEN 3
        WHEN 4 THEN 3
        ELSE 4
    END,
    '$2b$12$vo9ehiXYWpE2DoTvSHyVme8BuS2zh8nO5z9O5VfqeRZ5DoEfzhlIe',
    CASE ((n - 1) % 6) + 1
        WHEN 1 THEN 'Administrador da Unidade'
        WHEN 2 THEN 'Gestor de Facilities'
        WHEN 3 THEN 'Técnico de Manutenção'
        WHEN 4 THEN 'Técnico de Manutenção'
        ELSE 'Colaborador Solicitante'
    END,
    DATE '1972-01-01' + ((n * 97) % 10500),
    GREATEST(
        NOW() - ((190 - (n % 120)) || ' days')::INTERVAL,
        e.data_criacao + INTERVAL '1 day'
    ),
    TRUE,
    FALSE
FROM generate_series(1, 144) AS n
JOIN unidade e ON e.id = ((n - 1) / 6) + 1;

-- ===================================================
-- 8. APTIDÕES (144) - 3 por técnico
-- ===================================================
INSERT INTO aptidao (
    id, usuario_id, categoria_problema, nota, data_criacao, esta_ativo
)
SELECT
    ROW_NUMBER() OVER (ORDER BY u.id, g)::BIGINT,
    u.id,
    ((u.id + g * 3 - 1) % 10) + 1,
    ROUND((6.0 + ((u.id + g) % 5) * 0.8)::NUMERIC, 2),
    u.data_criacao + INTERVAL '1 day',
    TRUE
FROM usuario u
CROSS JOIN generate_series(1, 3) AS g
WHERE u.tipo_acesso = 3;

-- ===================================================
-- 9. FEEDBACKS (60)
-- ===================================================
INSERT INTO feedback (id, usuario_id, comentario, ideia_central, data_criacao)
SELECT
    n,
    ((n * 7 - 1) % 144) + 1,
    (ARRAY[
        'O acompanhamento das ordens de serviço está mais simples.',
        'Seria útil receber avisos quando uma OS mudar de status.',
        'A tela de equipamentos facilita encontrar o patrimônio correto.',
        'O fluxo para registrar um problema está rápido e claro.',
        'Gostaria de filtros adicionais por local e prioridade.',
        'O histórico de manutenção ajuda no acompanhamento da unidade.'
    ])[((n - 1) % 6) + 1],
    (ARRAY[
        'Acompanhamento de OS', 'Notificações', 'Equipamentos',
        'Registro de problemas', 'Filtros', 'Histórico de manutenção'
    ])[((n - 1) % 6) + 1],
    NOW() - ((n % 90) || ' days')::INTERVAL
FROM generate_series(1, 60) AS n;

-- ===================================================
-- 10. LOCAIS DAS UNIDADES (144) - 6 por unidade
-- ===================================================
INSERT INTO local_unidade (
    id, unidade_id, nome, tipo_local_unidade,
    descricao, data_criacao, esta_ativo
)
SELECT
    n,
    ((n - 1) / 6) + 1,
    CASE ((n - 1) % 6) + 1
        WHEN 1 THEN 'Sala de Aula ' || ((((n - 1) / 6) + 1)::TEXT)
        WHEN 2 THEN 'Laboratório ' || ((((n - 1) / 6) + 1)::TEXT)
        WHEN 3 THEN 'Administrativo ' || ((((n - 1) / 6) + 1)::TEXT)
        WHEN 4 THEN 'Auditório ' || ((((n - 1) / 6) + 1)::TEXT)
        WHEN 5 THEN 'Almoxarifado ' || ((((n - 1) / 6) + 1)::TEXT)
        ELSE 'Área Comum ' || ((((n - 1) / 6) + 1)::TEXT)
    END,
    ((n - 1) % 6) + 1,
    'Local cadastrado para controle de manutenção da unidade.',
    NOW() - ((170 - (n % 100)) || ' days')::INTERVAL,
    TRUE
FROM generate_series(1, 144) AS n;

-- ===================================================
-- 11. EVENTOS (72)
-- ===================================================
INSERT INTO evento (
    id, usuario_id, local_unidade_id, titulo, descricao,
    descricao_local, observacao, data_hora_inicio, data_hora_fim, data_criacao
)
SELECT
    n,
    (((( ((n - 1) % 24) + 1) - 1) * 6) + 2),
    (((n - 1) % 144) + 1),
    'Manutenção Preventiva ' || n,
    'Evento programado para inspeção e manutenção preventiva.',
    'Local definido no cadastro da unidade.',
    CASE WHEN n % 4 = 0 THEN 'Necessário acesso acompanhado pelo gestor.' ELSE NULL END,
    NOW() + ((n % 45) || ' days')::INTERVAL + INTERVAL '08 hours',
    NOW() + ((n % 45) || ' days')::INTERVAL + INTERVAL '10 hours',
    NOW() - ((n % 40) || ' days')::INTERVAL
FROM generate_series(1, 72) AS n;

-- ===================================================
-- 12. CATEGORIAS DE EQUIPAMENTO (10)
-- ===================================================
INSERT INTO categoria_equipamento (
    id, usuario_id, nome, descricao, data_criacao, esta_ativo
)
SELECT
    n,
    ((n - 1) * 6) + 2,
    (ARRAY[
        'Computadores', 'Ar-condicionado', 'Iluminação', 'Bombas Hidráulicas',
        'Câmeras de Segurança', 'Roteadores', 'Mobiliário', 'Quadros Elétricos',
        'Bebedouros', 'Equipamentos Mecânicos'
    ])[n],
    'Categoria de equipamentos utilizada pela manutenção.',
    NOW() - INTERVAL '160 days',
    TRUE
FROM generate_series(1, 10) AS n;

-- ===================================================
-- 13. MARCAS DE EQUIPAMENTO (8)
-- ===================================================
INSERT INTO marca_equipamento (id, nome, descricao, data_criacao, esta_ativo) VALUES
(1, 'TechLine',    'Equipamentos de informática.', NOW() - INTERVAL '160 days', TRUE),
(2, 'ClimaMax',    'Equipamentos de climatização.', NOW() - INTERVAL '160 days', TRUE),
(3, 'LuxLight',    'Equipamentos de iluminação.', NOW() - INTERVAL '160 days', TRUE),
(4, 'HidroPro',    'Equipamentos hidráulicos.', NOW() - INTERVAL '160 days', TRUE),
(5, 'SegurTech',   'Equipamentos de segurança.', NOW() - INTERVAL '160 days', TRUE),
(6, 'MobiliaBras', 'Mobiliário institucional.', NOW() - INTERVAL '160 days', TRUE),
(7, 'RedeTotal',   'Equipamentos de rede.', NOW() - INTERVAL '160 days', TRUE),
(8, 'Mecanix',     'Componentes e equipamentos mecânicos.', NOW() - INTERVAL '160 days', TRUE);

-- ===================================================
-- 14. MODELOS DE EQUIPAMENTO (30)
-- ===================================================
INSERT INTO modelo_equipamento (
    id, marca_equipamento_id, categoria_equipamento_id,
    nome, descricao, data_criacao, esta_ativo
)
SELECT
    n,
    ((n - 1) % 8) + 1,
    ((n - 1) % 10) + 1,
    'Modelo ' || LPAD(n::TEXT, 2, '0'),
    'Modelo de equipamento utilizado nas unidades da instituição.',
    NOW() - ((150 - n) || ' days')::INTERVAL,
    TRUE
FROM generate_series(1, 30) AS n;

-- ===================================================
-- 15. EQUIPAMENTOS (144) - 1 por local
-- ===================================================
INSERT INTO equipamento (
    id, usuario_id, modelo_equipamento_id, local_unidade_id,
    codigo, data_criacao, esta_ativo
)
SELECT
    n,
    ((((l.unidade_id - 1) * 6) + 2)),
    ((n - 1) % 30) + 1,
    l.id,
    'EQP-' || LPAD(n::TEXT, 5, '0'),
    NOW() - ((140 - (n % 100)) || ' days')::INTERVAL,
    TRUE
FROM generate_series(1, 144) AS n
JOIN local_unidade l ON l.id = n;

-- ===================================================
-- 16. PROBLEMAS (240)
-- 160 aprovados, 48 pendentes e 32 reprovados
-- ===================================================
INSERT INTO problema (
    id, usuario_id, categoria_equipamento_id, local_unidade_id,
    titulo, descricao_problema, descricao_local, motivo_recusa,
    data_criacao, status
)
SELECT
    n,
    ((l.unidade_id - 1) * 6) + CASE WHEN n % 2 = 0 THEN 5 ELSE 6 END,
    ((n - 1) % 10) + 1,
    l.id,
    (ARRAY[
        'Falha elétrica', 'Vazamento identificado', 'Equipamento com ruído',
        'Computador sem acesso', 'Móvel danificado', 'Ambiente sem climatização',
        'Rede instável', 'Câmera sem sinal', 'Luminária apagada', 'Necessidade de limpeza técnica'
    ])[((n - 1) % 10) + 1] || ' #' || n,
    'Problema relatado por colaborador da unidade e encaminhado para análise da manutenção.',
    l.nome,
    CASE WHEN n > 208 THEN 'Solicitação recusada após análise por não se enquadrar no fluxo de manutenção.' ELSE NULL END,
    GREATEST(
        NOW() - ((15 + (n * 7) % 150) || ' days')::INTERVAL,
        l.data_criacao + INTERVAL '1 day',
        u.data_criacao + INTERVAL '1 day'
    ),
    CASE
        WHEN n <= 160 THEN 1
        WHEN n <= 208 THEN 0
        ELSE 2
    END
FROM generate_series(1, 240) AS n
JOIN local_unidade l ON l.id = ((n - 1) % 144) + 1
JOIN usuario u ON u.id = ((l.unidade_id - 1) * 6) + CASE WHEN n % 2 = 0 THEN 5 ELSE 6 END;

-- ===================================================
-- 17. OCORRÊNCIAS (100)
-- ===================================================
INSERT INTO ocorrencia (
    id, usuario_id, local_unidade_id, categoria_equipamento_id,
    categoria_problema, titulo, descricao_ocorrencia,
    descricao_local, prioridade, data_criacao, esta_ativo
)
SELECT
    n,
    ((l.unidade_id - 1) * 6) + CASE WHEN n % 2 = 0 THEN 3 ELSE 4 END,
    l.id,
    ((n - 1) % 10) + 1,
    ((n - 1) % 10) + 1,
    'Ocorrência resolvida #' || n,
    'Ocorrência identificada e solucionada diretamente pelo técnico durante a rotina da unidade.',
    l.nome,
    (n - 1) % 3,
    GREATEST(
        NOW() - ((5 + (n * 3) % 110) || ' days')::INTERVAL,
        l.data_criacao + INTERVAL '1 day',
        u.data_criacao + INTERVAL '1 day'
    ),
    TRUE
FROM generate_series(1, 100) AS n
JOIN local_unidade l ON l.id = ((n - 1) % 144) + 1
JOIN usuario u ON u.id = ((l.unidade_id - 1) * 6) + CASE WHEN n % 2 = 0 THEN 3 ELSE 4 END;

-- ===================================================
-- 19. ORDENS DE SERVIÇO (160)
-- Somente problemas aprovados geram OS.
-- Distribuição de status:
-- 40 Não iniciadas | 10 Atrasada | 15 Pausada | 45 Em Andamento | 50 Finalizadas
-- ===================================================
WITH base AS (
    SELECT
        p.id AS n,
        p.id AS problema_id,
        l.unidade_id,
        CASE
            WHEN p.id <= 40 THEN 0
            WHEN p.id <= 85 THEN 3
            WHEN p.id <= 100 THEN 2
            WHEN p.id <= 110 THEN 1
            ELSE 4
        END AS status_id,
        GREATEST(
            CASE
                WHEN p.id <= 40 THEN NOW() - ((1 + ((p.id - 1) % 14)) || ' days')::INTERVAL
                WHEN p.id <= 85 THEN NOW() - ((1 + ((p.id - 41) % 25)) || ' days')::INTERVAL
                WHEN p.id <= 110 THEN NOW() - ((5 + ((p.id - 86) % 30)) || ' days')::INTERVAL
                ELSE NOW() - ((20 + ((p.id - 111) % 90)) || ' days')::INTERVAL
            END,
            p.data_criacao + INTERVAL '1 hour'
        ) AS criada_em
    FROM problema p
    JOIN local_unidade l ON l.id = p.local_unidade_id
    WHERE p.id <= 160 AND p.status = 1
)
INSERT INTO ordem_servico (
    id, problema_id, usuario_id, status_ordem_servico,
    categoria_problema, data_prevista, prioridade, data_criacao
)
SELECT
    n,
    problema_id,
    CASE
        WHEN n BETWEEN 41 AND 64 THEN ((unidade_id - 1) * 6) + 4
        WHEN n BETWEEN 65 AND 72 THEN ((unidade_id - 1) * 6) + 3
        WHEN n % 2 = 0 THEN ((unidade_id - 1) * 6) + 3
        ELSE ((unidade_id - 1) * 6) + 4
    END,
    status_id,
    ((n - 1) % 10) + 1,
    criada_em + CASE
        WHEN status_id = 0 THEN INTERVAL '7 days'
        WHEN status_id = 3 THEN INTERVAL '12 days'
        WHEN status_id IN (1, 2) THEN INTERVAL '15 days'
        ELSE INTERVAL '8 days'
    END,
    (n - 1) % 3,
    criada_em
FROM base;

-- ===================================================
-- 20. AUDITORIA DE STATUS DA OS (~249)
-- Histórico coerente com o status atual de cada OS.
-- As triggers existentes auditam UPDATE, não INSERT. Os estados atuais
-- e os históricos são inseridos diretamente, sem duplicar a auditoria.
-- ===================================================

-- Entrada em andamento.
INSERT INTO ordem_servico_status_auditoria (
    ordem_servico_id, status_anterior, status_novo, data_alteracao
)
SELECT
    os.id,
    0,
    3,
    os.data_criacao + ((4 + (os.id % 8)) || ' hours')::INTERVAL
FROM ordem_servico os
WHERE os.status_ordem_servico IN (1, 2, 3, 4);

-- Transição para Pausada ou Atrasada; mantém o volume histórico.
INSERT INTO ordem_servico_status_auditoria (
    ordem_servico_id, status_anterior, status_novo, data_alteracao
)
SELECT
    os.id,
    3,
    os.status_ordem_servico,
    CASE
        WHEN os.status_ordem_servico = 1 THEN os.data_prevista + INTERVAL '1 hour'
        ELSE os.data_criacao + INTERVAL '2 days'
    END
FROM ordem_servico os
WHERE os.status_ordem_servico IN (1, 2);

-- Pausas históricas em parte das OS finalizadas.
INSERT INTO ordem_servico_status_auditoria (
    ordem_servico_id, status_anterior, status_novo, data_alteracao
)
SELECT
    os.id,
    3,
    2,
    os.data_criacao + INTERVAL '2 days'
FROM ordem_servico os
WHERE os.status_ordem_servico = 4
  AND os.id % 3 = 0;

-- Retorno das pausas históricas.
INSERT INTO ordem_servico_status_auditoria (
    ordem_servico_id, status_anterior, status_novo, data_alteracao
)
SELECT
    os.id,
    2,
    3,
    os.data_criacao + INTERVAL '2 days 6 hours'
FROM ordem_servico os
WHERE os.status_ordem_servico = 4
  AND os.id % 3 = 0;

-- Primeira conclusão das OS finalizadas.
INSERT INTO ordem_servico_status_auditoria (
    ordem_servico_id, status_anterior, status_novo, data_alteracao
)
SELECT
    os.id,
    3,
    4,
    os.data_criacao + ((4 + (os.id % 8)) || ' days')::INTERVAL
FROM ordem_servico os
WHERE os.status_ordem_servico = 4;

-- Reabertura de 10 OS finalizadas.
INSERT INTO ordem_servico_status_auditoria (
    ordem_servico_id, status_anterior, status_novo, data_alteracao
)
SELECT
    os.id,
    4,
    3,
    os.data_criacao + ((5 + (os.id % 8)) || ' days')::INTERVAL
FROM ordem_servico os
WHERE os.id BETWEEN 111 AND 120;

-- Nova finalização após reabertura.
INSERT INTO ordem_servico_status_auditoria (
    ordem_servico_id, status_anterior, status_novo, data_alteracao
)
SELECT
    os.id,
    3,
    4,
    os.data_criacao + ((6 + (os.id % 8)) || ' days')::INTERVAL
FROM ordem_servico os
WHERE os.id BETWEEN 111 AND 120;

-- ===================================================
-- 21. AUDITORIA DE REATRIBUIÇÃO DE TÉCNICO (40)
-- Pressupõe a tabela ordem_servico_tecnico_auditoria já criada.
-- ===================================================

-- 24 OS com uma reatribuição.
INSERT INTO ordem_servico_tecnico_auditoria (
    ordem_servico_id, tecnico_anterior_id, tecnico_novo_id, data_alteracao
)
SELECT
    os.id,
    ((l.unidade_id - 1) * 6) + 3,
    ((l.unidade_id - 1) * 6) + 4,
    os.data_criacao + INTERVAL '6 hours'
FROM ordem_servico os
JOIN problema p ON p.id = os.problema_id
JOIN local_unidade l ON l.id = p.local_unidade_id
WHERE os.id BETWEEN 41 AND 64;

-- 8 OS que foram reatribuídas e depois retornaram ao técnico inicial.
INSERT INTO ordem_servico_tecnico_auditoria (
    ordem_servico_id, tecnico_anterior_id, tecnico_novo_id, data_alteracao
)
SELECT
    os.id,
    ((l.unidade_id - 1) * 6) + 3,
    ((l.unidade_id - 1) * 6) + 4,
    os.data_criacao + INTERVAL '4 hours'
FROM ordem_servico os
JOIN problema p ON p.id = os.problema_id
JOIN local_unidade l ON l.id = p.local_unidade_id
WHERE os.id BETWEEN 65 AND 72;

INSERT INTO ordem_servico_tecnico_auditoria (
    ordem_servico_id, tecnico_anterior_id, tecnico_novo_id, data_alteracao
)
SELECT
    os.id,
    ((l.unidade_id - 1) * 6) + 4,
    ((l.unidade_id - 1) * 6) + 3,
    os.data_criacao + INTERVAL '10 hours'
FROM ordem_servico os
JOIN problema p ON p.id = os.problema_id
JOIN local_unidade l ON l.id = p.local_unidade_id
WHERE os.id BETWEEN 65 AND 72;

-- ===================================================
-- 22. TAREFAS (480) - 3 por OS
-- Kanban próprio: diagnóstico, execução e validação têm estados distintos.
-- OS não iniciadas: 0/0/0; Em Andamento: 4/3/0; Pausada: 4/2/0;
-- Atrasada: 4/1/0; Finalizadas: 4/4/4. Estados próprios em cada tarefa.
-- ===================================================
INSERT INTO tarefa (
    id, ordem_servico_id, status_ordem_servico,
    titulo, descricao, data_criacao
)
SELECT
    ((os.id - 1) * 3) + etapa,
    os.id,
    CASE
        WHEN os.status_ordem_servico = 0 THEN 0
        WHEN os.status_ordem_servico = 4 THEN 4
        WHEN etapa = 1 THEN 4
        WHEN etapa = 2 THEN os.status_ordem_servico
        ELSE 0
    END,
    CASE etapa
        WHEN 1 THEN 'Diagnosticar problema'
        WHEN 2 THEN 'Executar manutenção'
        ELSE 'Validar funcionamento'
    END,
    CASE etapa
        WHEN 1 THEN 'Realizar diagnóstico inicial e identificar a causa do problema.'
        WHEN 2 THEN 'Executar a atividade necessária para correção do problema.'
        ELSE 'Testar o local ou equipamento após a execução da manutenção.'
    END,
    os.data_criacao + (etapa || ' hours')::INTERVAL
FROM ordem_servico os
CROSS JOIN generate_series(1, 3) AS etapa;

-- ===================================================
-- 23. OBSERVAÇÕES DE CONCLUSÃO (50)
-- Uma para cada OS atualmente finalizada.
-- ===================================================
INSERT INTO observacao_conclusao (
    id, ordem_servico_id, dificuldade, observacao, data_criacao
)
SELECT
    ROW_NUMBER() OVER (ORDER BY os.id)::BIGINT,
    os.id,
    ((os.id - 1) % 3) + 1,
    (ARRAY[
        'Serviço concluído sem intercorrências e funcionamento validado.',
        'Manutenção concluída após ajuste e testes no local.',
        'Problema resolvido e operação normalizada após validação técnica.'
    ])[((os.id - 1) % 3) + 1],
    MAX(a.data_alteracao) + INTERVAL '30 minutes'
FROM ordem_servico os
JOIN ordem_servico_status_auditoria a
    ON a.ordem_servico_id = os.id
   AND a.status_novo = 4
WHERE os.status_ordem_servico = 4
GROUP BY os.id;

-- ===================================================
-- 24. FOTOS (300)
-- Regra do arco exclusivo respeitada: exatamente uma FK preenchida.
-- ===================================================

-- 50 fotos de usuários.
INSERT INTO foto (
    id, problema_id, ocorrencia_id, ordem_servico_id,
    observacao_conclusao_id, usuario_id, url, esta_ativo, data_criacao
)
SELECT
    n, NULL, NULL, NULL, NULL, n,
    'https://storage.fixa.local/usuarios/' || n || '.jpg',
    TRUE,
    NOW() - ((n % 100) || ' days')::INTERVAL
FROM generate_series(1, 50) AS n;

-- 100 fotos de problemas.
INSERT INTO foto (
    id, problema_id, ocorrencia_id, ordem_servico_id,
    observacao_conclusao_id, usuario_id, url, esta_ativo, data_criacao
)
SELECT
    50 + n, n, NULL, NULL, NULL, NULL,
    'https://storage.fixa.local/problemas/' || n || '.jpg',
    TRUE,
    p.data_criacao + INTERVAL '15 minutes'
FROM generate_series(1, 100) AS n
JOIN problema p ON p.id = n;

-- 60 fotos de OS.
INSERT INTO foto (
    id, problema_id, ocorrencia_id, ordem_servico_id,
    observacao_conclusao_id, usuario_id, url, esta_ativo, data_criacao
)
SELECT
    150 + n, NULL, NULL, n, NULL, NULL,
    'https://storage.fixa.local/ordens/' || n || '.jpg',
    TRUE,
    os.data_criacao + INTERVAL '2 hours'
FROM generate_series(1, 60) AS n
JOIN ordem_servico os ON os.id = n;

-- 40 fotos de ocorrências.
INSERT INTO foto (
    id, problema_id, ocorrencia_id, ordem_servico_id,
    observacao_conclusao_id, usuario_id, url, esta_ativo, data_criacao
)
SELECT
    210 + n, NULL, n, NULL, NULL, NULL,
    'https://storage.fixa.local/ocorrencias/' || n || '.jpg',
    TRUE,
    o.data_criacao
FROM generate_series(1, 40) AS n
JOIN ocorrencia o ON o.id = n;

-- 50 fotos das observações de conclusão.
INSERT INTO foto (
    id, problema_id, ocorrencia_id, ordem_servico_id,
    observacao_conclusao_id, usuario_id, url, esta_ativo, data_criacao
)
SELECT
    250 + n, NULL, NULL, NULL, n, NULL,
    'https://storage.fixa.local/conclusoes/' || n || '.jpg',
    TRUE,
    oc.data_criacao
FROM generate_series(1, 50) AS n
JOIN observacao_conclusao oc ON oc.id = n;

-- ===================================================
-- 25. TURNOS (48) - manhã e tarde por unidade
-- ===================================================
INSERT INTO turno (
    id, unidade_id, nome, hora_inicio, hora_fim,
    atravessa_meia_noite, data_criacao, esta_ativo
)
SELECT
    ((e.id - 1) * 2) + g,
    e.id,
    CASE WHEN g = 1 THEN 'Manhã' ELSE 'Tarde' END,
    CASE WHEN g = 1 THEN 28800 ELSE 46800 END,
    CASE WHEN g = 1 THEN 43200 ELSE 64800 END,
    FALSE,
    e.data_criacao + INTERVAL '1 day',
    TRUE
FROM unidade e
CROSS JOIN generate_series(1, 2) AS g;

-- ===================================================
-- 26. TURNO_USUARIO (144) - 1 turno por usuário
-- ===================================================
INSERT INTO turno_usuario (
    id, turno_id, usuario_id, data_criacao, esta_ativo
)
SELECT
    u.id,
    ((u.unidade_id - 1) * 2) + CASE WHEN ((u.id - 1) % 6) IN (0, 2, 4) THEN 1 ELSE 2 END,
    u.id,
    u.data_criacao + INTERVAL '2 days',
    TRUE
FROM usuario u;

-- ===================================================
-- AJUSTE DAS SEQUENCES
-- Como os IDs foram definidos de forma determinística,
-- as sequences precisam ser posicionadas no maior ID.
-- ===================================================
SELECT setval(pg_get_serial_sequence('super_admin', 'id'), MAX(id), TRUE) FROM super_admin;
SELECT setval(pg_get_serial_sequence('instituicao', 'id'), MAX(id), TRUE) FROM instituicao;
SELECT setval(pg_get_serial_sequence('unidade', 'id'), MAX(id), TRUE) FROM unidade;
SELECT setval(pg_get_serial_sequence('plano', 'id'), MAX(id), TRUE) FROM plano;
SELECT setval(pg_get_serial_sequence('contrato', 'id'), MAX(id), TRUE) FROM contrato;
SELECT setval(pg_get_serial_sequence('pagamento', 'id'), MAX(id), TRUE) FROM pagamento;
SELECT setval(pg_get_serial_sequence('usuario', 'id'), MAX(id), TRUE) FROM usuario;
SELECT setval(pg_get_serial_sequence('aptidao', 'id'), MAX(id), TRUE) FROM aptidao;
SELECT setval(pg_get_serial_sequence('feedback', 'id'), MAX(id), TRUE) FROM feedback;
SELECT setval(pg_get_serial_sequence('local_unidade', 'id'), MAX(id), TRUE) FROM local_unidade;
SELECT setval(pg_get_serial_sequence('evento', 'id'), MAX(id), TRUE) FROM evento;
SELECT setval(pg_get_serial_sequence('categoria_equipamento', 'id'), MAX(id), TRUE) FROM categoria_equipamento;
SELECT setval(pg_get_serial_sequence('marca_equipamento', 'id'), MAX(id), TRUE) FROM marca_equipamento;
SELECT setval(pg_get_serial_sequence('modelo_equipamento', 'id'), MAX(id), TRUE) FROM modelo_equipamento;
SELECT setval(pg_get_serial_sequence('equipamento', 'id'), MAX(id), TRUE) FROM equipamento;
SELECT setval(pg_get_serial_sequence('problema', 'id'), MAX(id), TRUE) FROM problema;
SELECT setval(pg_get_serial_sequence('ocorrencia', 'id'), MAX(id), TRUE) FROM ocorrencia;
SELECT setval(pg_get_serial_sequence('ordem_servico', 'id'), MAX(id), TRUE) FROM ordem_servico;
SELECT setval(pg_get_serial_sequence('ordem_servico_status_auditoria', 'id'), MAX(id), TRUE) FROM ordem_servico_status_auditoria;
SELECT setval(pg_get_serial_sequence('ordem_servico_tecnico_auditoria', 'id'), MAX(id), TRUE) FROM ordem_servico_tecnico_auditoria;
SELECT setval(pg_get_serial_sequence('tarefa', 'id'), MAX(id), TRUE) FROM tarefa;
SELECT setval(pg_get_serial_sequence('observacao_conclusao', 'id'), MAX(id), TRUE) FROM observacao_conclusao;
SELECT setval(pg_get_serial_sequence('foto', 'id'), MAX(id), TRUE) FROM foto;
SELECT setval(pg_get_serial_sequence('turno', 'id'), MAX(id), TRUE) FROM turno;
SELECT setval(pg_get_serial_sequence('turno_usuario', 'id'), MAX(id), TRUE) FROM turno_usuario;

-- ===================================================
-- VALIDAÇÕES DA CARGA
-- ===================================================
DO $$
DECLARE
    total_registros INTEGER;
    verificacao RECORD;
    quantidade BIGINT;
    ultimo_id BIGINT;
    sequence_id TEXT;
    sequence_ultimo_id BIGINT;
    sequence_chamada BOOLEAN;
BEGIN
    SELECT
        (SELECT COUNT(*) FROM super_admin) +
        (SELECT COUNT(*) FROM instituicao) +
        (SELECT COUNT(*) FROM unidade) +
        (SELECT COUNT(*) FROM plano) +
        (SELECT COUNT(*) FROM contrato) +
        (SELECT COUNT(*) FROM pagamento) +
        (SELECT COUNT(*) FROM usuario) +
        (SELECT COUNT(*) FROM aptidao) +
        (SELECT COUNT(*) FROM feedback) +
        (SELECT COUNT(*) FROM local_unidade) +
        (SELECT COUNT(*) FROM evento) +
        (SELECT COUNT(*) FROM categoria_equipamento) +
        (SELECT COUNT(*) FROM marca_equipamento) +
        (SELECT COUNT(*) FROM modelo_equipamento) +
        (SELECT COUNT(*) FROM equipamento) +
        (SELECT COUNT(*) FROM problema) +
        (SELECT COUNT(*) FROM ocorrencia) +
        (SELECT COUNT(*) FROM ordem_servico) +
        (SELECT COUNT(*) FROM ordem_servico_status_auditoria) +
        (SELECT COUNT(*) FROM ordem_servico_tecnico_auditoria) +
        (SELECT COUNT(*) FROM tarefa) +
        (SELECT COUNT(*) FROM observacao_conclusao) +
        (SELECT COUNT(*) FROM foto) +
        (SELECT COUNT(*) FROM turno) +
        (SELECT COUNT(*) FROM turno_usuario)
    INTO total_registros;

    IF total_registros < 500 THEN
        RAISE EXCEPTION 'Carga insuficiente: % registros. Mínimo exigido: 500.', total_registros;
    END IF;

    IF EXISTS (SELECT 1 FROM instituicao WHERE tipo_instituicao NOT BETWEEN 1 AND 4) THEN
        RAISE EXCEPTION 'Valor inválido em instituicao.tipo_instituicao.';
    END IF;

    IF EXISTS (SELECT 1 FROM contrato WHERE status NOT BETWEEN 1 AND 3) THEN
        RAISE EXCEPTION 'Valor inválido em contrato.status.';
    END IF;

    IF EXISTS (SELECT 1 FROM pagamento WHERE status IS NULL OR status NOT BETWEEN 1 AND 3 OR metodo_pagamento NOT BETWEEN 1 AND 3) THEN
        RAISE EXCEPTION 'Valor inválido em pagamento.';
    END IF;

    IF EXISTS (SELECT 1 FROM usuario WHERE tipo_acesso NOT BETWEEN 1 AND 4) THEN
        RAISE EXCEPTION 'Valor inválido em usuario.tipo_acesso.';
    END IF;

    IF EXISTS (SELECT 1 FROM aptidao WHERE categoria_problema NOT BETWEEN 1 AND 10) OR
       EXISTS (SELECT 1 FROM ocorrencia WHERE categoria_problema NOT BETWEEN 1 AND 10) OR
       EXISTS (SELECT 1 FROM ordem_servico WHERE categoria_problema NOT BETWEEN 1 AND 10) THEN
        RAISE EXCEPTION 'Valor inválido em categoria_problema.';
    END IF;

    IF EXISTS (SELECT 1 FROM local_unidade WHERE tipo_local_unidade NOT BETWEEN 1 AND 6) THEN
        RAISE EXCEPTION 'Valor inválido em local_unidade.tipo_local_unidade.';
    END IF;

    IF EXISTS (SELECT 1 FROM problema WHERE status NOT BETWEEN 0 AND 2) THEN
        RAISE EXCEPTION 'Valor inválido em problema.status.';
    END IF;

    IF EXISTS (SELECT 1 FROM observacao_conclusao WHERE dificuldade NOT BETWEEN 1 AND 3) THEN
        RAISE EXCEPTION 'Valor inválido em observacao_conclusao.dificuldade.';
    END IF;

    IF EXISTS (SELECT 1 FROM ordem_servico WHERE status_ordem_servico NOT BETWEEN 0 AND 4)
       OR EXISTS (SELECT 1 FROM tarefa WHERE status_ordem_servico NOT BETWEEN 0 AND 4)
       OR EXISTS (SELECT 1 FROM ordem_servico_status_auditoria
                  WHERE status_anterior NOT BETWEEN 0 AND 4
                     OR status_novo NOT BETWEEN 0 AND 4) THEN
        RAISE EXCEPTION 'Status fora do intervalo oficial 0..4.';
    END IF;
    IF (SELECT COUNT(DISTINCT status_ordem_servico) FROM ordem_servico) <> 5
       OR (SELECT COUNT(DISTINCT status_ordem_servico) FROM tarefa) <> 5 THEN
        RAISE EXCEPTION 'A massa deve representar todos os cinco status oficiais.';
    END IF;
    IF EXISTS (
        SELECT 1 FROM ordem_servico_status_auditoria a
        JOIN ordem_servico os ON os.id = a.ordem_servico_id
        WHERE a.status_novo = 1 AND a.data_alteracao <= os.data_prevista
    ) THEN
        RAISE EXCEPTION 'A massa não deve registrar Atrasada antes do prazo previsto.';
    END IF;

    -- Confere a massa planejada para detectar perda de dados por JOINs.
    FOR verificacao IN
        SELECT * FROM (VALUES
            ('super_admin', 3), ('instituicao', 12), ('unidade', 24),
            ('plano', 4), ('contrato', 24), ('pagamento', 72),
            ('usuario', 144), ('aptidao', 144), ('feedback', 60),
            ('local_unidade', 144), ('evento', 72),
            ('categoria_equipamento', 10), ('marca_equipamento', 8),
            ('modelo_equipamento', 30), ('equipamento', 144),
            ('problema', 240), ('ocorrencia', 100),
            ('ordem_servico', 160), ('ordem_servico_status_auditoria', 249),
            ('ordem_servico_tecnico_auditoria', 40), ('tarefa', 480),
            ('observacao_conclusao', 50), ('foto', 300),
            ('turno', 48), ('turno_usuario', 144)
        ) AS massa(tabela, esperado)
    LOOP
        EXECUTE format('SELECT COUNT(*), MAX(id) FROM %I', verificacao.tabela)
            INTO quantidade, ultimo_id;
        IF quantidade <> verificacao.esperado THEN
            RAISE EXCEPTION 'Quantidade inesperada em %: %, esperado %.',
                verificacao.tabela, quantidade, verificacao.esperado;
        END IF;

        sequence_id := pg_get_serial_sequence(verificacao.tabela, 'id');
        IF sequence_id IS NULL THEN
            RAISE EXCEPTION 'Sequence BIGSERIAL não encontrada para %.', verificacao.tabela;
        END IF;
        EXECUTE format('SELECT last_value, is_called FROM %s', sequence_id::REGCLASS)
            INTO sequence_ultimo_id, sequence_chamada;
        IF sequence_ultimo_id <> ultimo_id OR NOT sequence_chamada THEN
            RAISE EXCEPTION 'Sequence não ajustada para %.', verificacao.tabela;
        END IF;
    END LOOP;

    IF EXISTS (SELECT 1 FROM ocorrencia WHERE prioridade NOT BETWEEN 0 AND 2) OR
       EXISTS (SELECT 1 FROM ordem_servico WHERE prioridade NOT BETWEEN 0 AND 2) THEN
        RAISE EXCEPTION 'Prioridade inválida: esperado 0=Alta, 1=Média ou 2=Baixa.';
    END IF;

    IF EXISTS (SELECT 1 FROM contrato WHERE data_fim <= data_inicio) THEN
        RAISE EXCEPTION 'Contrato com data de fim anterior ou igual à data de início.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM problema
        WHERE (status = 2 AND motivo_recusa IS NULL)
           OR (status <> 2 AND motivo_recusa IS NOT NULL)
    ) THEN
        RAISE EXCEPTION 'Motivo de recusa incompatível com o status do problema.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM ordem_servico GROUP BY problema_id HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Um problema não pode gerar mais de uma ordem de serviço.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM ordem_servico os
        JOIN problema p ON p.id = os.problema_id
        WHERE p.status <> 1
    ) OR EXISTS (
        SELECT 1 FROM problema p
        WHERE p.status = 1
          AND NOT EXISTS (SELECT 1 FROM ordem_servico os WHERE os.problema_id = p.id)
    ) THEN
        RAISE EXCEPTION 'A massa deve conter uma OS para cada problema aprovado, e apenas para aprovados.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM ordem_servico os JOIN usuario u ON u.id = os.usuario_id
        WHERE u.tipo_acesso <> 3
    ) OR EXISTS (
        SELECT 1 FROM ocorrencia o JOIN usuario u ON u.id = o.usuario_id
        WHERE u.tipo_acesso <> 3
    ) OR EXISTS (
        SELECT 1 FROM aptidao a JOIN usuario u ON u.id = a.usuario_id
        WHERE u.tipo_acesso <> 3 OR a.nota NOT BETWEEN 0.00 AND 10.00
    ) THEN
        RAISE EXCEPTION 'Responsáveis por OS, ocorrências e aptidões devem ser técnicos; notas entre 0 e 10.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM aptidao
        GROUP BY usuario_id, categoria_problema HAVING COUNT(*) > 1
    ) THEN
        RAISE EXCEPTION 'Aptidão duplicada para o mesmo técnico e categoria.';
    END IF;

    -- As tarefas têm estados próprios, respeitando a situação geral da OS.
    IF EXISTS (
        SELECT 1 FROM tarefa t
        WHERE t.status_ordem_servico NOT BETWEEN 0 AND 4
    ) THEN
        RAISE EXCEPTION 'Tarefa com status fora do intervalo 0..4.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM tarefa t JOIN ordem_servico os ON os.id = t.ordem_servico_id
        WHERE (os.status_ordem_servico = 4 AND t.status_ordem_servico <> 4)
           OR (os.status_ordem_servico = 0 AND t.status_ordem_servico <> 0)
    ) THEN
        RAISE EXCEPTION 'Tarefa incompatível com OS finalizada ou não iniciada.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM ordem_servico os
        LEFT JOIN tarefa t ON t.ordem_servico_id = os.id
        GROUP BY os.id, os.status_ordem_servico
        HAVING COUNT(t.id) <> 3
            OR (os.status_ordem_servico = 3 AND COUNT(*) FILTER (WHERE t.status_ordem_servico = 3) = 0)
            OR (os.status_ordem_servico IN (1, 2, 3) AND COUNT(*) FILTER (WHERE t.status_ordem_servico <> 4) = 0)
            OR (os.status_ordem_servico IN (1, 2) AND COUNT(*) FILTER (WHERE t.status_ordem_servico = os.status_ordem_servico) = 0)
    ) THEN
        RAISE EXCEPTION 'Cada OS deve possuir três tarefas e um kanban coerente com seu andamento.';
    END IF;

    -- Confere a sequência de transições e a correspondência com o estado atual.
    IF EXISTS (
        SELECT 1 FROM ordem_servico_status_auditoria a
        JOIN ordem_servico os ON os.id = a.ordem_servico_id
        WHERE a.status_anterior NOT BETWEEN 0 AND 4 OR a.status_novo NOT BETWEEN 0 AND 4
           OR a.status_anterior = a.status_novo
           OR a.data_alteracao < os.data_criacao OR a.data_alteracao > NOW()
    ) THEN
        RAISE EXCEPTION 'Auditoria de status com referências ou datas inválidas.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM (
            SELECT a.*,
                ROW_NUMBER() OVER (PARTITION BY ordem_servico_id ORDER BY data_alteracao, id) AS posicao,
                LAG(status_novo) OVER (PARTITION BY ordem_servico_id ORDER BY data_alteracao, id) AS status_previo,
                LAG(data_alteracao) OVER (PARTITION BY ordem_servico_id ORDER BY data_alteracao, id) AS data_previa
            FROM ordem_servico_status_auditoria a
        ) historico
        WHERE (posicao = 1 AND status_anterior <> 0)
           OR (posicao > 1 AND status_anterior <> status_previo)
           OR (posicao > 1 AND data_alteracao <= data_previa)
    ) THEN
        RAISE EXCEPTION 'Histórico de status descontínuo ou com transições simultâneas.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM ordem_servico os
        LEFT JOIN LATERAL (
            SELECT a.status_novo FROM ordem_servico_status_auditoria a
            WHERE a.ordem_servico_id = os.id ORDER BY a.data_alteracao DESC, a.id DESC LIMIT 1
        ) ultima ON TRUE
        WHERE os.status_ordem_servico <> COALESCE(ultima.status_novo, 0)
    ) THEN
        RAISE EXCEPTION 'O status atual da OS diverge da última transição da auditoria.';
    END IF;

    IF (SELECT COUNT(DISTINCT ordem_servico_id) FROM ordem_servico_status_auditoria
        WHERE status_anterior = 4 AND status_novo IN (0, 1, 2, 3)) <> 10 THEN
        RAISE EXCEPTION 'A massa deve preservar dez OS reabertas.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM ordem_servico_tecnico_auditoria a
        JOIN ordem_servico os ON os.id = a.ordem_servico_id
        JOIN usuario anterior ON anterior.id = a.tecnico_anterior_id
        JOIN usuario novo ON novo.id = a.tecnico_novo_id
        WHERE anterior.tipo_acesso <> 3 OR novo.tipo_acesso <> 3
           OR anterior.id = novo.id
           OR a.data_alteracao < os.data_criacao OR a.data_alteracao > NOW()
    ) THEN
        RAISE EXCEPTION 'Reatribuição com responsável não técnico ou data inválida.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM (
            SELECT a.*,
                LAG(tecnico_novo_id) OVER (PARTITION BY ordem_servico_id ORDER BY data_alteracao, id) AS tecnico_previo,
                LAG(data_alteracao) OVER (PARTITION BY ordem_servico_id ORDER BY data_alteracao, id) AS data_previa
            FROM ordem_servico_tecnico_auditoria a
        ) historico
        WHERE (tecnico_previo IS NOT NULL AND tecnico_anterior_id <> tecnico_previo)
           OR (data_previa IS NOT NULL AND data_alteracao <= data_previa)
    ) OR EXISTS (
        SELECT 1 FROM ordem_servico os
        JOIN LATERAL (
            SELECT a.tecnico_novo_id FROM ordem_servico_tecnico_auditoria a
            WHERE a.ordem_servico_id = os.id ORDER BY a.data_alteracao DESC, a.id DESC LIMIT 1
        ) ultima ON TRUE
        WHERE os.usuario_id <> ultima.tecnico_novo_id
    ) THEN
        RAISE EXCEPTION 'Histórico de reatribuição descontínuo ou divergente do técnico atual.';
    END IF;

    IF (SELECT COUNT(DISTINCT ordem_servico_id) FROM ordem_servico_tecnico_auditoria) <> 32 THEN
        RAISE EXCEPTION 'A massa deve preservar 32 OS reatribuídas.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM observacao_conclusao oc
        JOIN ordem_servico os ON os.id = oc.ordem_servico_id
        LEFT JOIN LATERAL (
            SELECT MAX(data_alteracao) AS data_finalizacao
            FROM ordem_servico_status_auditoria a
            WHERE a.ordem_servico_id = os.id AND a.status_novo = 4
        ) ultima ON TRUE
        WHERE os.status_ordem_servico <> 4 OR ultima.data_finalizacao IS NULL
           OR oc.data_criacao <= ultima.data_finalizacao OR oc.data_criacao > NOW()
    ) OR EXISTS (
        SELECT 1 FROM ordem_servico os
        LEFT JOIN observacao_conclusao oc ON oc.ordem_servico_id = os.id
        WHERE os.status_ordem_servico = 4 GROUP BY os.id HAVING COUNT(oc.id) <> 1
    ) THEN
        RAISE EXCEPTION 'Cada OS finalizada deve ter uma observação posterior à última finalização.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM foto
        WHERE num_nonnulls(problema_id, ocorrencia_id, ordem_servico_id, observacao_conclusao_id, usuario_id) <> 1
    ) THEN
        RAISE EXCEPTION 'Cada foto deve possuir exatamente uma FK associativa preenchida.';
    END IF;

    -- Datas das relações diretas e dos registros operacionais.
    IF EXISTS (
        SELECT 1 FROM unidade e JOIN instituicao i ON i.id = e.instituicao_id
        WHERE e.data_criacao < i.data_criacao
    ) OR EXISTS (
        SELECT 1 FROM usuario u JOIN unidade e ON e.id = u.unidade_id
        WHERE u.data_criacao < e.data_criacao
    ) OR EXISTS (
        SELECT 1 FROM problema p
        JOIN usuario u ON u.id = p.usuario_id
        JOIN local_unidade l ON l.id = p.local_unidade_id
        WHERE p.data_criacao < GREATEST(u.data_criacao, l.data_criacao) OR p.data_criacao > NOW()
    ) OR EXISTS (
        SELECT 1 FROM ocorrencia o
        JOIN usuario u ON u.id = o.usuario_id
        JOIN local_unidade l ON l.id = o.local_unidade_id
        WHERE o.data_criacao < GREATEST(u.data_criacao, l.data_criacao) OR o.data_criacao > NOW()
    ) OR EXISTS (
        SELECT 1 FROM ordem_servico os JOIN problema p ON p.id = os.problema_id
        WHERE os.data_criacao < p.data_criacao OR os.data_prevista <= os.data_criacao OR os.data_criacao > NOW()
    ) OR EXISTS (
        SELECT 1 FROM tarefa t JOIN ordem_servico os ON os.id = t.ordem_servico_id
        WHERE t.data_criacao < os.data_criacao OR t.data_criacao > NOW()
    ) THEN
        RAISE EXCEPTION 'Datas incoerentes entre instituição, unidade, usuário, problema, ocorrência, OS ou tarefa.';
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM ordem_servico
        WHERE status_ordem_servico IN (1, 2, 3) AND data_prevista < NOW()
    ) OR NOT EXISTS (
        SELECT 1 FROM ordem_servico
        WHERE status_ordem_servico IN (1, 2, 3) AND data_prevista >= NOW()
    ) THEN
        RAISE EXCEPTION 'Os KPIs precisam de OS abertas atrasadas e dentro do prazo.';
    END IF;

    IF EXISTS (
        SELECT 1 FROM usuario
        WHERE senha_hash <> '$2b$12$vo9ehiXYWpE2DoTvSHyVme8BuS2zh8nO5z9O5VfqeRZ5DoEfzhlIe'
    ) OR EXISTS (
        SELECT 1 FROM super_admin
        WHERE senha_hash <> '$2b$12$vo9ehiXYWpE2DoTvSHyVme8BuS2zh8nO5z9O5VfqeRZ5DoEfzhlIe'
    ) THEN
        RAISE EXCEPTION 'Todos os usuários e super administradores devem utilizar o BCrypt padrão de 1234.';
    END IF;

    RAISE NOTICE 'Carga concluída com % registros.', total_registros;
END;
$$;

COMMIT;

-- ===================================================
-- RESUMO DE REGISTROS POR TABELA
-- ===================================================
SELECT 'super_admin' AS tabela, COUNT(*) AS registros FROM super_admin
UNION ALL SELECT 'instituicao', COUNT(*) FROM instituicao
UNION ALL SELECT 'unidade', COUNT(*) FROM unidade
UNION ALL SELECT 'plano', COUNT(*) FROM plano
UNION ALL SELECT 'contrato', COUNT(*) FROM contrato
UNION ALL SELECT 'pagamento', COUNT(*) FROM pagamento
UNION ALL SELECT 'usuario', COUNT(*) FROM usuario
UNION ALL SELECT 'aptidao', COUNT(*) FROM aptidao
UNION ALL SELECT 'feedback', COUNT(*) FROM feedback
UNION ALL SELECT 'local_unidade', COUNT(*) FROM local_unidade
UNION ALL SELECT 'evento', COUNT(*) FROM evento
UNION ALL SELECT 'categoria_equipamento', COUNT(*) FROM categoria_equipamento
UNION ALL SELECT 'marca_equipamento', COUNT(*) FROM marca_equipamento
UNION ALL SELECT 'modelo_equipamento', COUNT(*) FROM modelo_equipamento
UNION ALL SELECT 'equipamento', COUNT(*) FROM equipamento
UNION ALL SELECT 'problema', COUNT(*) FROM problema
UNION ALL SELECT 'ocorrencia', COUNT(*) FROM ocorrencia
UNION ALL SELECT 'ordem_servico', COUNT(*) FROM ordem_servico
UNION ALL SELECT 'ordem_servico_status_auditoria', COUNT(*) FROM ordem_servico_status_auditoria
UNION ALL SELECT 'ordem_servico_tecnico_auditoria', COUNT(*) FROM ordem_servico_tecnico_auditoria
UNION ALL SELECT 'tarefa', COUNT(*) FROM tarefa
UNION ALL SELECT 'observacao_conclusao', COUNT(*) FROM observacao_conclusao
UNION ALL SELECT 'foto', COUNT(*) FROM foto
UNION ALL SELECT 'turno', COUNT(*) FROM turno
UNION ALL SELECT 'turno_usuario', COUNT(*) FROM turno_usuario
ORDER BY tabela;
