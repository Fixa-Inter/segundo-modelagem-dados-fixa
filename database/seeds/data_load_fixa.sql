-- ===================================================
-- DATALOAD / MASSA DE TESTE - FIXA
-- Requisito: carga inicial de pelo menos 500 registros
--            verossímeis para testes de volume.
--
-- Total aproximado gerado: 2.394 registros.
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
--   0=Pendente, 1=Reprovado, 2=Aprovado
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
-- 2. INSTITUIÇÃO (3)
-- ===================================================
INSERT INTO instituicao (id, nome, tipo_instituicao, email_corporativo, dominio_email, data_criacao, esta_ativo) VALUES
(1, 'Colégio Horizonte', 1, 'contato@horizonte.example', 'horizonte.example', NOW() - INTERVAL '420 days', TRUE),
(2, 'Faculdade Vértice', 2, 'contato@vertice.example', 'vertice.example', NOW() - INTERVAL '420 days', TRUE),
(3, 'Indústrias Aurora', 3, 'contato@aurora.example', 'aurora.example', NOW() - INTERVAL '420 days', TRUE);

-- ===================================================
-- 3. UNIDADE (9) - 3 unidades por instituição
-- ===================================================
-- Endereços e identificadores sintéticos, exclusivamente para teste.
INSERT INTO unidade (id, instituicao_id, nome, cnpj, logradouro, numero, complemento, bairro, cidade, estado, cep, data_criacao, esta_ativo) VALUES
(1, 1, 'Unidade Escolar Centro', '12000000007919', 'Rua das Acácias', '107', NULL, 'Centro', 'São Paulo', 'SP', '06000173', NOW() - INTERVAL '300 days', TRUE),
(2, 1, 'Unidade Escolar Bela Vista', '12000000015838', 'Rua dos Ipês', '114', NULL, 'Bela Vista', 'São Paulo', 'SP', '06000346', NOW() - INTERVAL '300 days', TRUE),
(3, 1, 'Unidade Escolar Campinas', '12000000023757', 'Rua das Palmeiras', '121', NULL, 'Cambuí', 'Campinas', 'SP', '06000519', NOW() - INTERVAL '300 days', TRUE),
(4, 2, 'Campus Centro', '12000000071271', 'Rua das Acácias', '163', NULL, 'Centro', 'São Paulo', 'SP', '06001557', NOW() - INTERVAL '300 days', TRUE),
(5, 2, 'Campus Bela Vista', '12000000079190', 'Rua dos Ipês', '170', NULL, 'Bela Vista', 'São Paulo', 'SP', '06001730', NOW() - INTERVAL '300 days', TRUE),
(6, 2, 'Campus Campinas', '12000000087109', 'Rua das Palmeiras', '177', NULL, 'Cambuí', 'Campinas', 'SP', '06001903', NOW() - INTERVAL '300 days', TRUE),
(7, 3, 'Complexo Industrial Centro', '12000000134623', 'Rua das Acácias', '219', NULL, 'Centro', 'São Paulo', 'SP', '06002941', NOW() - INTERVAL '300 days', TRUE),
(8, 3, 'Complexo Industrial Bela Vista', '12000000142542', 'Rua dos Ipês', '226', NULL, 'Bela Vista', 'São Paulo', 'SP', '06003114', NOW() - INTERVAL '300 days', TRUE),
(9, 3, 'Complexo Industrial Campinas', '12000000150461', 'Rua das Palmeiras', '233', NULL, 'Cambuí', 'Campinas', 'SP', '06003287', NOW() - INTERVAL '300 days', TRUE);


-- ===================================================
-- 4. PLANOS (4)
-- ===================================================
INSERT INTO plano (id, nome, valor, descricao, duracao_meses, data_criacao, esta_ativo) VALUES
(1, 'Essencial',    1490.00, 'Gestão essencial de chamados de manutenção.', 12, NOW() - INTERVAL '400 days', TRUE),
(2, 'Profissional', 2490.00, 'Gestão de manutenção, equipes e equipamentos.', 12, NOW() - INTERVAL '400 days', TRUE),
(3, 'Corporativo',  3990.00, 'Recursos avançados para múltiplas unidades.', 24, NOW() - INTERVAL '400 days', TRUE),
(4, 'Enterprise',   6490.00, 'Operação completa com maior escala e suporte.', 24, NOW() - INTERVAL '400 days', TRUE);

-- ===================================================
-- 5. CONTRATOS (9) - 1 por unidade
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
FROM generate_series(1, 9) AS n
JOIN plano p ON p.id = ((n - 1) % 4) + 1;

-- ===================================================
-- 6. PAGAMENTOS (27) - 3 por contrato
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
-- 7. USUÁRIOS (54) - 6 por unidade
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
    'usuario' || n || '@' || (SELECT dominio_email FROM instituicao WHERE id = e.instituicao_id),
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
FROM generate_series(1, 54) AS n
JOIN unidade e ON e.id = ((n - 1) / 6) + 1;

-- ===================================================
-- 8. APTIDÕES (54) - 3 por técnico
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
    ((n * 7 - 1) % 54) + 1,
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
-- 10. LOCAIS DAS UNIDADES (180) - 20 por unidade
-- ===================================================
-- Locais explícitos por unidade; sem generate_series para instituições, unidades ou ambientes.
INSERT INTO local_unidade (id, unidade_id, nome, tipo_local_unidade, descricao, data_criacao, esta_ativo) VALUES
-- Sala de Matemática — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de álgebra, geometria e resolução de problemas, com quadro e mesas para exercícios em grupo.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(1, 1, 'Sala de Matemática — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de álgebra, geometria e resolução de problemas, com quadro e mesas para exercícios em grupo.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Língua Portuguesa — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de leitura, interpretação de textos e produção escrita; realização de oficinas de redação.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(2, 1, 'Sala de Língua Portuguesa — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de leitura, interpretação de textos e produção escrita; realização de oficinas de redação.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de História e Geografia — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas sobre processos históricos, cartografia e sociedade; análise de mapas e trabalhos de pesquisa.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(3, 1, 'Sala de História e Geografia — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas sobre processos históricos, cartografia e sociedade; análise de mapas e trabalhos de pesquisa.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Língua Inglesa — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de conversação, compreensão oral e escrita em inglês, com recursos de áudio e projeção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(4, 1, 'Sala de Língua Inglesa — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de conversação, compreensão oral e escrita em inglês, com recursos de áudio e projeção.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Artes — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de desenho, pintura e produção artística; bancadas para trabalhos manuais e guarda de materiais.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(5, 1, 'Sala de Artes — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de desenho, pintura e produção artística; bancadas para trabalhos manuais e guarda de materiais.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Ciências — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de biologia, química e física; experimentos didáticos supervisionados em bancadas com pia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(6, 1, 'Laboratório de Ciências — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de biologia, química e física; experimentos didáticos supervisionados em bancadas com pia.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Informática — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas de programação e letramento digital; uso de computadores para pesquisa e projetos escolares.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(7, 1, 'Laboratório de Informática — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas de programação e letramento digital; uso de computadores para pesquisa e projetos escolares.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório Maker — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Oficinas de robótica e prototipagem; montagem de circuitos e construção de projetos com orientação docente.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(8, 1, 'Laboratório Maker — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Oficinas de robótica e prototipagem; montagem de circuitos e construção de projetos com orientação docente.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Música — Centro
-- Local: Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de percepção musical e prática instrumental; ensaios dos alunos e preparação de apresentações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(9, 1, 'Sala de Música — Centro', 1, 'Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de percepção musical e prática instrumental; ensaios dos alunos e preparação de apresentações.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Apoio Pedagógico — Centro
-- Local: Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Reforço de leitura e matemática; atendimento de pequenos grupos com atividades adaptadas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(10, 1, 'Sala de Apoio Pedagógico — Centro', 1, 'Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção. Uso: Reforço de leitura e matemática; atendimento de pequenos grupos com atividades adaptadas.', NOW() - INTERVAL '170 days', TRUE),
-- Secretaria Escolar — Centro
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Matrículas, emissão de documentos e atendimento às famílias; guarda dos registros acadêmicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(11, 1, 'Secretaria Escolar — Centro', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Matrículas, emissão de documentos e atendimento às famílias; guarda dos registros acadêmicos.', NOW() - INTERVAL '170 days', TRUE),
-- Coordenação Pedagógica — Centro
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento de aulas e acompanhamento de aprendizagem; reuniões com professores e responsáveis.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(12, 1, 'Coordenação Pedagógica — Centro', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento de aulas e acompanhamento de aprendizagem; reuniões com professores e responsáveis.', NOW() - INTERVAL '170 days', TRUE),
-- Sala dos Professores — Centro
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Preparação de aulas, correção de atividades e reuniões de equipe durante os intervalos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(13, 1, 'Sala dos Professores — Centro', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Preparação de aulas, correção de atividades e reuniões de equipe durante os intervalos.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório Escolar — Centro
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Apresentações artísticas, palestras e reuniões de pais; espaço com palco e sistema de som.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(14, 1, 'Auditório Escolar — Centro', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Apresentações artísticas, palestras e reuniões de pais; espaço com palco e sistema de som.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado Didático — Centro
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda e distribuição de livros, papelaria e kits de aula; conferência dos materiais usados pelos professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(15, 1, 'Almoxarifado Didático — Centro', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Guarda e distribuição de livros, papelaria e kits de aula; conferência dos materiais usados pelos professores.', NOW() - INTERVAL '170 days', TRUE),
-- Depósito de Educação Física — Centro
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento de bolas, redes e colchonetes para as aulas práticas e atividades esportivas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(16, 1, 'Depósito de Educação Física — Centro', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento de bolas, redes e colchonetes para as aulas práticas e atividades esportivas.', NOW() - INTERVAL '170 days', TRUE),
-- Biblioteca Escolar — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Leitura orientada, empréstimo de livros e pesquisa para trabalhos; mesas para estudo individual.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(17, 1, 'Biblioteca Escolar — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Leitura orientada, empréstimo de livros e pesquisa para trabalhos; mesas para estudo individual.', NOW() - INTERVAL '170 days', TRUE),
-- Pátio Coberto — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Recreio, acolhimento dos alunos e atividades coletivas; circulação entre salas e cantina.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(18, 1, 'Pátio Coberto — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Recreio, acolhimento dos alunos e atividades coletivas; circulação entre salas e cantina.', NOW() - INTERVAL '170 days', TRUE),
-- Quadra Poliesportiva — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Aulas de educação física, treinos e jogos escolares; atividades de vôlei, basquete e futsal.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(19, 1, 'Quadra Poliesportiva — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Aulas de educação física, treinos e jogos escolares; atividades de vôlei, basquete e futsal.', NOW() - INTERVAL '170 days', TRUE),
-- Refeitório Escolar — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Distribuição e consumo das refeições dos alunos; mesas coletivas e área de circulação supervisionada.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(20, 1, 'Refeitório Escolar — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Distribuição e consumo das refeições dos alunos; mesas coletivas e área de circulação supervisionada.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Matemática — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de álgebra, geometria e resolução de problemas, com quadro e mesas para exercícios em grupo.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(21, 2, 'Sala de Matemática — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de álgebra, geometria e resolução de problemas, com quadro e mesas para exercícios em grupo.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Língua Portuguesa — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de leitura, interpretação de textos e produção escrita; realização de oficinas de redação.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(22, 2, 'Sala de Língua Portuguesa — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de leitura, interpretação de textos e produção escrita; realização de oficinas de redação.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de História e Geografia — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas sobre processos históricos, cartografia e sociedade; análise de mapas e trabalhos de pesquisa.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(23, 2, 'Sala de História e Geografia — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas sobre processos históricos, cartografia e sociedade; análise de mapas e trabalhos de pesquisa.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Língua Inglesa — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de conversação, compreensão oral e escrita em inglês, com recursos de áudio e projeção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(24, 2, 'Sala de Língua Inglesa — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de conversação, compreensão oral e escrita em inglês, com recursos de áudio e projeção.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Artes — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de desenho, pintura e produção artística; bancadas para trabalhos manuais e guarda de materiais.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(25, 2, 'Sala de Artes — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de desenho, pintura e produção artística; bancadas para trabalhos manuais e guarda de materiais.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Ciências — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de biologia, química e física; experimentos didáticos supervisionados em bancadas com pia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(26, 2, 'Laboratório de Ciências — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de biologia, química e física; experimentos didáticos supervisionados em bancadas com pia.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Informática — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas de programação e letramento digital; uso de computadores para pesquisa e projetos escolares.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(27, 2, 'Laboratório de Informática — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas de programação e letramento digital; uso de computadores para pesquisa e projetos escolares.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório Maker — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Oficinas de robótica e prototipagem; montagem de circuitos e construção de projetos com orientação docente.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(28, 2, 'Laboratório Maker — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Oficinas de robótica e prototipagem; montagem de circuitos e construção de projetos com orientação docente.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Música — Bela Vista
-- Local: Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de percepção musical e prática instrumental; ensaios dos alunos e preparação de apresentações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(29, 2, 'Sala de Música — Bela Vista', 1, 'Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de percepção musical e prática instrumental; ensaios dos alunos e preparação de apresentações.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Apoio Pedagógico — Bela Vista
-- Local: Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Reforço de leitura e matemática; atendimento de pequenos grupos com atividades adaptadas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(30, 2, 'Sala de Apoio Pedagógico — Bela Vista', 1, 'Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção. Uso: Reforço de leitura e matemática; atendimento de pequenos grupos com atividades adaptadas.', NOW() - INTERVAL '170 days', TRUE),
-- Secretaria Escolar — Bela Vista
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Matrículas, emissão de documentos e atendimento às famílias; guarda dos registros acadêmicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(31, 2, 'Secretaria Escolar — Bela Vista', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Matrículas, emissão de documentos e atendimento às famílias; guarda dos registros acadêmicos.', NOW() - INTERVAL '170 days', TRUE),
-- Coordenação Pedagógica — Bela Vista
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento de aulas e acompanhamento de aprendizagem; reuniões com professores e responsáveis.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(32, 2, 'Coordenação Pedagógica — Bela Vista', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento de aulas e acompanhamento de aprendizagem; reuniões com professores e responsáveis.', NOW() - INTERVAL '170 days', TRUE),
-- Sala dos Professores — Bela Vista
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Preparação de aulas, correção de atividades e reuniões de equipe durante os intervalos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(33, 2, 'Sala dos Professores — Bela Vista', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Preparação de aulas, correção de atividades e reuniões de equipe durante os intervalos.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório Escolar — Bela Vista
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Apresentações artísticas, palestras e reuniões de pais; espaço com palco e sistema de som.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(34, 2, 'Auditório Escolar — Bela Vista', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Apresentações artísticas, palestras e reuniões de pais; espaço com palco e sistema de som.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado Didático — Bela Vista
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda e distribuição de livros, papelaria e kits de aula; conferência dos materiais usados pelos professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(35, 2, 'Almoxarifado Didático — Bela Vista', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Guarda e distribuição de livros, papelaria e kits de aula; conferência dos materiais usados pelos professores.', NOW() - INTERVAL '170 days', TRUE),
-- Depósito de Educação Física — Bela Vista
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento de bolas, redes e colchonetes para as aulas práticas e atividades esportivas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(36, 2, 'Depósito de Educação Física — Bela Vista', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento de bolas, redes e colchonetes para as aulas práticas e atividades esportivas.', NOW() - INTERVAL '170 days', TRUE),
-- Biblioteca Escolar — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Leitura orientada, empréstimo de livros e pesquisa para trabalhos; mesas para estudo individual.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(37, 2, 'Biblioteca Escolar — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Leitura orientada, empréstimo de livros e pesquisa para trabalhos; mesas para estudo individual.', NOW() - INTERVAL '170 days', TRUE),
-- Pátio Coberto — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Recreio, acolhimento dos alunos e atividades coletivas; circulação entre salas e cantina.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(38, 2, 'Pátio Coberto — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Recreio, acolhimento dos alunos e atividades coletivas; circulação entre salas e cantina.', NOW() - INTERVAL '170 days', TRUE),
-- Quadra Poliesportiva — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Aulas de educação física, treinos e jogos escolares; atividades de vôlei, basquete e futsal.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(39, 2, 'Quadra Poliesportiva — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Aulas de educação física, treinos e jogos escolares; atividades de vôlei, basquete e futsal.', NOW() - INTERVAL '170 days', TRUE),
-- Refeitório Escolar — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Distribuição e consumo das refeições dos alunos; mesas coletivas e área de circulação supervisionada.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(40, 2, 'Refeitório Escolar — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Distribuição e consumo das refeições dos alunos; mesas coletivas e área de circulação supervisionada.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Matemática — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de álgebra, geometria e resolução de problemas, com quadro e mesas para exercícios em grupo.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(41, 3, 'Sala de Matemática — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de álgebra, geometria e resolução de problemas, com quadro e mesas para exercícios em grupo.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Língua Portuguesa — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de leitura, interpretação de textos e produção escrita; realização de oficinas de redação.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(42, 3, 'Sala de Língua Portuguesa — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de leitura, interpretação de textos e produção escrita; realização de oficinas de redação.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de História e Geografia — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas sobre processos históricos, cartografia e sociedade; análise de mapas e trabalhos de pesquisa.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(43, 3, 'Sala de História e Geografia — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas sobre processos históricos, cartografia e sociedade; análise de mapas e trabalhos de pesquisa.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Língua Inglesa — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de conversação, compreensão oral e escrita em inglês, com recursos de áudio e projeção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(44, 3, 'Sala de Língua Inglesa — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de conversação, compreensão oral e escrita em inglês, com recursos de áudio e projeção.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Artes — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de desenho, pintura e produção artística; bancadas para trabalhos manuais e guarda de materiais.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(45, 3, 'Sala de Artes — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de desenho, pintura e produção artística; bancadas para trabalhos manuais e guarda de materiais.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Ciências — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de biologia, química e física; experimentos didáticos supervisionados em bancadas com pia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(46, 3, 'Laboratório de Ciências — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de biologia, química e física; experimentos didáticos supervisionados em bancadas com pia.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Informática — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas de programação e letramento digital; uso de computadores para pesquisa e projetos escolares.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(47, 3, 'Laboratório de Informática — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas de programação e letramento digital; uso de computadores para pesquisa e projetos escolares.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório Maker — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Oficinas de robótica e prototipagem; montagem de circuitos e construção de projetos com orientação docente.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(48, 3, 'Laboratório Maker — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Oficinas de robótica e prototipagem; montagem de circuitos e construção de projetos com orientação docente.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Música — Campinas
-- Local: Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de percepção musical e prática instrumental; ensaios dos alunos e preparação de apresentações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(49, 3, 'Sala de Música — Campinas', 1, 'Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de percepção musical e prática instrumental; ensaios dos alunos e preparação de apresentações.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Apoio Pedagógico — Campinas
-- Local: Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Reforço de leitura e matemática; atendimento de pequenos grupos com atividades adaptadas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(50, 3, 'Sala de Apoio Pedagógico — Campinas', 1, 'Bloco A, 1º pavimento. Sala com mesas, quadro e recursos de projeção. Uso: Reforço de leitura e matemática; atendimento de pequenos grupos com atividades adaptadas.', NOW() - INTERVAL '170 days', TRUE),
-- Secretaria Escolar — Campinas
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Matrículas, emissão de documentos e atendimento às famílias; guarda dos registros acadêmicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(51, 3, 'Secretaria Escolar — Campinas', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Matrículas, emissão de documentos e atendimento às famílias; guarda dos registros acadêmicos.', NOW() - INTERVAL '170 days', TRUE),
-- Coordenação Pedagógica — Campinas
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento de aulas e acompanhamento de aprendizagem; reuniões com professores e responsáveis.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(52, 3, 'Coordenação Pedagógica — Campinas', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento de aulas e acompanhamento de aprendizagem; reuniões com professores e responsáveis.', NOW() - INTERVAL '170 days', TRUE),
-- Sala dos Professores — Campinas
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Preparação de aulas, correção de atividades e reuniões de equipe durante os intervalos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(53, 3, 'Sala dos Professores — Campinas', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Preparação de aulas, correção de atividades e reuniões de equipe durante os intervalos.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório Escolar — Campinas
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Apresentações artísticas, palestras e reuniões de pais; espaço com palco e sistema de som.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(54, 3, 'Auditório Escolar — Campinas', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Apresentações artísticas, palestras e reuniões de pais; espaço com palco e sistema de som.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado Didático — Campinas
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda e distribuição de livros, papelaria e kits de aula; conferência dos materiais usados pelos professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(55, 3, 'Almoxarifado Didático — Campinas', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Guarda e distribuição de livros, papelaria e kits de aula; conferência dos materiais usados pelos professores.', NOW() - INTERVAL '170 days', TRUE),
-- Depósito de Educação Física — Campinas
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento de bolas, redes e colchonetes para as aulas práticas e atividades esportivas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(56, 3, 'Depósito de Educação Física — Campinas', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento de bolas, redes e colchonetes para as aulas práticas e atividades esportivas.', NOW() - INTERVAL '170 days', TRUE),
-- Biblioteca Escolar — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Leitura orientada, empréstimo de livros e pesquisa para trabalhos; mesas para estudo individual.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(57, 3, 'Biblioteca Escolar — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Leitura orientada, empréstimo de livros e pesquisa para trabalhos; mesas para estudo individual.', NOW() - INTERVAL '170 days', TRUE),
-- Pátio Coberto — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Recreio, acolhimento dos alunos e atividades coletivas; circulação entre salas e cantina.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(58, 3, 'Pátio Coberto — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Recreio, acolhimento dos alunos e atividades coletivas; circulação entre salas e cantina.', NOW() - INTERVAL '170 days', TRUE),
-- Quadra Poliesportiva — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Aulas de educação física, treinos e jogos escolares; atividades de vôlei, basquete e futsal.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(59, 3, 'Quadra Poliesportiva — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Aulas de educação física, treinos e jogos escolares; atividades de vôlei, basquete e futsal.', NOW() - INTERVAL '170 days', TRUE),
-- Refeitório Escolar — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Distribuição e consumo das refeições dos alunos; mesas coletivas e área de circulação supervisionada.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(60, 3, 'Refeitório Escolar — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Distribuição e consumo das refeições dos alunos; mesas coletivas e área de circulação supervisionada.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Cálculo — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de cálculo diferencial, integral e álgebra linear; resolução de exercícios e avaliações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(61, 4, 'Sala de Cálculo — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de cálculo diferencial, integral e álgebra linear; resolução de exercícios e avaliações.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Gestão — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de administração, gestão de projetos e empreendedorismo; análise de casos em grupos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(62, 4, 'Sala de Gestão — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de administração, gestão de projetos e empreendedorismo; análise de casos em grupos.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Projetos Integradores — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Desenvolvimento de projetos interdisciplinares; reuniões de equipes e orientação com professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(63, 4, 'Sala de Projetos Integradores — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Desenvolvimento de projetos interdisciplinares; reuniões de equipes e orientação com professores.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Metodologia Científica — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de pesquisa acadêmica e escrita científica; elaboração de projetos e artigos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(64, 4, 'Sala de Metodologia Científica — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de pesquisa acadêmica e escrita científica; elaboração de projetos e artigos.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Programação — Centro
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de algoritmos e desenvolvimento de software; implementação e teste de aplicações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(65, 4, 'Laboratório de Programação — Centro', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de algoritmos e desenvolvimento de software; implementação e teste de aplicações.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Redes — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Montagem e configuração de redes de computadores; práticas de roteamento, cabeamento e diagnóstico.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(66, 4, 'Laboratório de Redes — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Montagem e configuração de redes de computadores; práticas de roteamento, cabeamento e diagnóstico.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Eletrônica — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de circuitos analógicos e digitais; medições em bancadas com fontes e osciloscópios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(67, 4, 'Laboratório de Eletrônica — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de circuitos analógicos e digitais; medições em bancadas com fontes e osciloscópios.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Física — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Experimentos de mecânica, óptica e eletricidade; coleta de dados e elaboração de relatórios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(68, 4, 'Laboratório de Física — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Experimentos de mecânica, óptica e eletricidade; coleta de dados e elaboração de relatórios.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Química — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Práticas supervisionadas de preparo de soluções e análise de materiais; uso de bancadas com pia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(69, 4, 'Laboratório de Química — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Práticas supervisionadas de preparo de soluções e análise de materiais; uso de bancadas com pia.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Prototipagem — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Construção de protótipos para projetos acadêmicos; atividades de fabricação digital e montagem.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(70, 4, 'Laboratório de Prototipagem — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Construção de protótipos para projetos acadêmicos; atividades de fabricação digital e montagem.', NOW() - INTERVAL '170 days', TRUE),
-- Secretaria Acadêmica — Centro
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Matrículas, solicitações de documentos e registro da vida acadêmica dos estudantes.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(71, 4, 'Secretaria Acadêmica — Centro', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Matrículas, solicitações de documentos e registro da vida acadêmica dos estudantes.', NOW() - INTERVAL '170 days', TRUE),
-- Coordenação de Cursos — Centro
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Organização das disciplinas e orientação de estudantes; reuniões de colegiado e atendimento docente.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(72, 4, 'Coordenação de Cursos — Centro', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Organização das disciplinas e orientação de estudantes; reuniões de colegiado e atendimento docente.', NOW() - INTERVAL '170 days', TRUE),
-- Sala dos Docentes — Centro
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento das aulas, preparação de avaliações e encontros de trabalho dos professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(73, 4, 'Sala dos Docentes — Centro', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento das aulas, preparação de avaliações e encontros de trabalho dos professores.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório de Defesas — Centro
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Bancas de trabalhos de conclusão de curso, seminários e palestras; projeção e sonorização das apresentações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(74, 4, 'Auditório de Defesas — Centro', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Bancas de trabalhos de conclusão de curso, seminários e palestras; projeção e sonorização das apresentações.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de Laboratórios — Centro
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda e distribuição de cabos, componentes e ferramentas utilizados nas aulas práticas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(75, 4, 'Almoxarifado de Laboratórios — Centro', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Guarda e distribuição de cabos, componentes e ferramentas utilizados nas aulas práticas.', NOW() - INTERVAL '170 days', TRUE),
-- Arquivo Acadêmico — Centro
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento e consulta controlada de documentos e processos acadêmicos físicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(76, 4, 'Arquivo Acadêmico — Centro', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento e consulta controlada de documentos e processos acadêmicos físicos.', NOW() - INTERVAL '170 days', TRUE),
-- Biblioteca Universitária — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Pesquisa bibliográfica, empréstimo de acervo e estudo; apoio à elaboração de trabalhos científicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(77, 4, 'Biblioteca Universitária — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Pesquisa bibliográfica, empréstimo de acervo e estudo; apoio à elaboração de trabalhos científicos.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Estudos Colaborativos — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Estudo em grupo e preparação de apresentações; mesas compartilhadas e pontos de energia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(78, 4, 'Sala de Estudos Colaborativos — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Estudo em grupo e preparação de apresentações; mesas compartilhadas e pontos de energia.', NOW() - INTERVAL '170 days', TRUE),
-- Praça de Convivência — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Intervalos e encontros entre estudantes; circulação entre os blocos acadêmicos e serviços.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(79, 4, 'Praça de Convivência — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Intervalos e encontros entre estudantes; circulação entre os blocos acadêmicos e serviços.', NOW() - INTERVAL '170 days', TRUE),
-- Centro de Atendimento ao Estudante — Centro
-- Local: Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Orientação sobre serviços do campus, bolsas e encaminhamentos para apoio acadêmico.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(80, 4, 'Centro de Atendimento ao Estudante — Centro', 3, 'Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Orientação sobre serviços do campus, bolsas e encaminhamentos para apoio acadêmico.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Cálculo — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de cálculo diferencial, integral e álgebra linear; resolução de exercícios e avaliações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(81, 5, 'Sala de Cálculo — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de cálculo diferencial, integral e álgebra linear; resolução de exercícios e avaliações.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Gestão — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de administração, gestão de projetos e empreendedorismo; análise de casos em grupos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(82, 5, 'Sala de Gestão — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de administração, gestão de projetos e empreendedorismo; análise de casos em grupos.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Projetos Integradores — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Desenvolvimento de projetos interdisciplinares; reuniões de equipes e orientação com professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(83, 5, 'Sala de Projetos Integradores — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Desenvolvimento de projetos interdisciplinares; reuniões de equipes e orientação com professores.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Metodologia Científica — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de pesquisa acadêmica e escrita científica; elaboração de projetos e artigos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(84, 5, 'Sala de Metodologia Científica — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de pesquisa acadêmica e escrita científica; elaboração de projetos e artigos.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Programação — Bela Vista
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de algoritmos e desenvolvimento de software; implementação e teste de aplicações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(85, 5, 'Laboratório de Programação — Bela Vista', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de algoritmos e desenvolvimento de software; implementação e teste de aplicações.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Redes — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Montagem e configuração de redes de computadores; práticas de roteamento, cabeamento e diagnóstico.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(86, 5, 'Laboratório de Redes — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Montagem e configuração de redes de computadores; práticas de roteamento, cabeamento e diagnóstico.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Eletrônica — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de circuitos analógicos e digitais; medições em bancadas com fontes e osciloscópios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(87, 5, 'Laboratório de Eletrônica — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de circuitos analógicos e digitais; medições em bancadas com fontes e osciloscópios.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Física — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Experimentos de mecânica, óptica e eletricidade; coleta de dados e elaboração de relatórios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(88, 5, 'Laboratório de Física — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Experimentos de mecânica, óptica e eletricidade; coleta de dados e elaboração de relatórios.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Química — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Práticas supervisionadas de preparo de soluções e análise de materiais; uso de bancadas com pia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(89, 5, 'Laboratório de Química — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Práticas supervisionadas de preparo de soluções e análise de materiais; uso de bancadas com pia.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Prototipagem — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Construção de protótipos para projetos acadêmicos; atividades de fabricação digital e montagem.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(90, 5, 'Laboratório de Prototipagem — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Construção de protótipos para projetos acadêmicos; atividades de fabricação digital e montagem.', NOW() - INTERVAL '170 days', TRUE),
-- Secretaria Acadêmica — Bela Vista
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Matrículas, solicitações de documentos e registro da vida acadêmica dos estudantes.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(91, 5, 'Secretaria Acadêmica — Bela Vista', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Matrículas, solicitações de documentos e registro da vida acadêmica dos estudantes.', NOW() - INTERVAL '170 days', TRUE),
-- Coordenação de Cursos — Bela Vista
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Organização das disciplinas e orientação de estudantes; reuniões de colegiado e atendimento docente.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(92, 5, 'Coordenação de Cursos — Bela Vista', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Organização das disciplinas e orientação de estudantes; reuniões de colegiado e atendimento docente.', NOW() - INTERVAL '170 days', TRUE),
-- Sala dos Docentes — Bela Vista
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento das aulas, preparação de avaliações e encontros de trabalho dos professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(93, 5, 'Sala dos Docentes — Bela Vista', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento das aulas, preparação de avaliações e encontros de trabalho dos professores.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório de Defesas — Bela Vista
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Bancas de trabalhos de conclusão de curso, seminários e palestras; projeção e sonorização das apresentações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(94, 5, 'Auditório de Defesas — Bela Vista', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Bancas de trabalhos de conclusão de curso, seminários e palestras; projeção e sonorização das apresentações.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de Laboratórios — Bela Vista
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda e distribuição de cabos, componentes e ferramentas utilizados nas aulas práticas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(95, 5, 'Almoxarifado de Laboratórios — Bela Vista', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Guarda e distribuição de cabos, componentes e ferramentas utilizados nas aulas práticas.', NOW() - INTERVAL '170 days', TRUE),
-- Arquivo Acadêmico — Bela Vista
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento e consulta controlada de documentos e processos acadêmicos físicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(96, 5, 'Arquivo Acadêmico — Bela Vista', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento e consulta controlada de documentos e processos acadêmicos físicos.', NOW() - INTERVAL '170 days', TRUE),
-- Biblioteca Universitária — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Pesquisa bibliográfica, empréstimo de acervo e estudo; apoio à elaboração de trabalhos científicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(97, 5, 'Biblioteca Universitária — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Pesquisa bibliográfica, empréstimo de acervo e estudo; apoio à elaboração de trabalhos científicos.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Estudos Colaborativos — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Estudo em grupo e preparação de apresentações; mesas compartilhadas e pontos de energia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(98, 5, 'Sala de Estudos Colaborativos — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Estudo em grupo e preparação de apresentações; mesas compartilhadas e pontos de energia.', NOW() - INTERVAL '170 days', TRUE),
-- Praça de Convivência — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Intervalos e encontros entre estudantes; circulação entre os blocos acadêmicos e serviços.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(99, 5, 'Praça de Convivência — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Intervalos e encontros entre estudantes; circulação entre os blocos acadêmicos e serviços.', NOW() - INTERVAL '170 days', TRUE),
-- Centro de Atendimento ao Estudante — Bela Vista
-- Local: Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Orientação sobre serviços do campus, bolsas e encaminhamentos para apoio acadêmico.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(100, 5, 'Centro de Atendimento ao Estudante — Bela Vista', 3, 'Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Orientação sobre serviços do campus, bolsas e encaminhamentos para apoio acadêmico.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Cálculo — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de cálculo diferencial, integral e álgebra linear; resolução de exercícios e avaliações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(101, 6, 'Sala de Cálculo — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de cálculo diferencial, integral e álgebra linear; resolução de exercícios e avaliações.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Gestão — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de administração, gestão de projetos e empreendedorismo; análise de casos em grupos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(102, 6, 'Sala de Gestão — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de administração, gestão de projetos e empreendedorismo; análise de casos em grupos.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Projetos Integradores — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Desenvolvimento de projetos interdisciplinares; reuniões de equipes e orientação com professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(103, 6, 'Sala de Projetos Integradores — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Desenvolvimento de projetos interdisciplinares; reuniões de equipes e orientação com professores.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Metodologia Científica — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas de pesquisa acadêmica e escrita científica; elaboração de projetos e artigos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(104, 6, 'Sala de Metodologia Científica — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas de pesquisa acadêmica e escrita científica; elaboração de projetos e artigos.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Programação — Campinas
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de algoritmos e desenvolvimento de software; implementação e teste de aplicações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(105, 6, 'Laboratório de Programação — Campinas', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de algoritmos e desenvolvimento de software; implementação e teste de aplicações.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Redes — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Montagem e configuração de redes de computadores; práticas de roteamento, cabeamento e diagnóstico.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(106, 6, 'Laboratório de Redes — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Montagem e configuração de redes de computadores; práticas de roteamento, cabeamento e diagnóstico.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Eletrônica — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Aulas práticas de circuitos analógicos e digitais; medições em bancadas com fontes e osciloscópios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(107, 6, 'Laboratório de Eletrônica — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Aulas práticas de circuitos analógicos e digitais; medições em bancadas com fontes e osciloscópios.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Física — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Experimentos de mecânica, óptica e eletricidade; coleta de dados e elaboração de relatórios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(108, 6, 'Laboratório de Física — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Experimentos de mecânica, óptica e eletricidade; coleta de dados e elaboração de relatórios.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Química — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Práticas supervisionadas de preparo de soluções e análise de materiais; uso de bancadas com pia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(109, 6, 'Laboratório de Química — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Práticas supervisionadas de preparo de soluções e análise de materiais; uso de bancadas com pia.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Prototipagem — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Construção de protótipos para projetos acadêmicos; atividades de fabricação digital e montagem.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(110, 6, 'Laboratório de Prototipagem — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Construção de protótipos para projetos acadêmicos; atividades de fabricação digital e montagem.', NOW() - INTERVAL '170 days', TRUE),
-- Secretaria Acadêmica — Campinas
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Matrículas, solicitações de documentos e registro da vida acadêmica dos estudantes.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(111, 6, 'Secretaria Acadêmica — Campinas', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Matrículas, solicitações de documentos e registro da vida acadêmica dos estudantes.', NOW() - INTERVAL '170 days', TRUE),
-- Coordenação de Cursos — Campinas
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Organização das disciplinas e orientação de estudantes; reuniões de colegiado e atendimento docente.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(112, 6, 'Coordenação de Cursos — Campinas', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Organização das disciplinas e orientação de estudantes; reuniões de colegiado e atendimento docente.', NOW() - INTERVAL '170 days', TRUE),
-- Sala dos Docentes — Campinas
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento das aulas, preparação de avaliações e encontros de trabalho dos professores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(113, 6, 'Sala dos Docentes — Campinas', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento das aulas, preparação de avaliações e encontros de trabalho dos professores.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório de Defesas — Campinas
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Bancas de trabalhos de conclusão de curso, seminários e palestras; projeção e sonorização das apresentações.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(114, 6, 'Auditório de Defesas — Campinas', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Bancas de trabalhos de conclusão de curso, seminários e palestras; projeção e sonorização das apresentações.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de Laboratórios — Campinas
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda e distribuição de cabos, componentes e ferramentas utilizados nas aulas práticas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(115, 6, 'Almoxarifado de Laboratórios — Campinas', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Guarda e distribuição de cabos, componentes e ferramentas utilizados nas aulas práticas.', NOW() - INTERVAL '170 days', TRUE),
-- Arquivo Acadêmico — Campinas
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento e consulta controlada de documentos e processos acadêmicos físicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(116, 6, 'Arquivo Acadêmico — Campinas', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento e consulta controlada de documentos e processos acadêmicos físicos.', NOW() - INTERVAL '170 days', TRUE),
-- Biblioteca Universitária — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Pesquisa bibliográfica, empréstimo de acervo e estudo; apoio à elaboração de trabalhos científicos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(117, 6, 'Biblioteca Universitária — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Pesquisa bibliográfica, empréstimo de acervo e estudo; apoio à elaboração de trabalhos científicos.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Estudos Colaborativos — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Estudo em grupo e preparação de apresentações; mesas compartilhadas e pontos de energia.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(118, 6, 'Sala de Estudos Colaborativos — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Estudo em grupo e preparação de apresentações; mesas compartilhadas e pontos de energia.', NOW() - INTERVAL '170 days', TRUE),
-- Praça de Convivência — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Intervalos e encontros entre estudantes; circulação entre os blocos acadêmicos e serviços.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(119, 6, 'Praça de Convivência — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Intervalos e encontros entre estudantes; circulação entre os blocos acadêmicos e serviços.', NOW() - INTERVAL '170 days', TRUE),
-- Centro de Atendimento ao Estudante — Campinas
-- Local: Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Orientação sobre serviços do campus, bolsas e encaminhamentos para apoio acadêmico.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(120, 6, 'Centro de Atendimento ao Estudante — Campinas', 3, 'Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Orientação sobre serviços do campus, bolsas e encaminhamentos para apoio acadêmico.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Capacitação Operacional — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Treinamento de operadores e integração de novos colaboradores; aulas sobre procedimentos de produção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(121, 7, 'Sala de Capacitação Operacional — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Treinamento de operadores e integração de novos colaboradores; aulas sobre procedimentos de produção.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Treinamento de Segurança — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas sobre prevenção de acidentes, uso de EPI e procedimentos de emergência.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(122, 7, 'Sala de Treinamento de Segurança — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas sobre prevenção de acidentes, uso de EPI e procedimentos de emergência.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Treinamento de Qualidade — Centro
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Capacitação em inspeção de peças, critérios de aceitação e registro de não conformidades.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(123, 7, 'Sala de Treinamento de Qualidade — Centro', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Capacitação em inspeção de peças, critérios de aceitação e registro de não conformidades.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Controle de Qualidade — Centro
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Inspeção e avaliação de amostras de peças produzidas; registro de resultados e liberação de lotes.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(124, 7, 'Laboratório de Controle de Qualidade — Centro', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Inspeção e avaliação de amostras de peças produzidas; registro de resultados e liberação de lotes.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Metrologia — Centro
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Medição dimensional de peças e verificação de instrumentos; uso de paquímetros e micrômetros.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(125, 7, 'Laboratório de Metrologia — Centro', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Medição dimensional de peças e verificação de instrumentos; uso de paquímetros e micrômetros.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Ensaios — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Ensaios técnicos de materiais e componentes; análise de desempenho e elaboração de relatórios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(126, 7, 'Laboratório de Ensaios — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Ensaios técnicos de materiais e componentes; análise de desempenho e elaboração de relatórios.', NOW() - INTERVAL '170 days', TRUE),
-- Oficina de Manutenção Mecânica — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Diagnóstico e reparo de conjuntos mecânicos; desmontagem, ajuste e montagem em bancadas técnicas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(127, 7, 'Oficina de Manutenção Mecânica — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Diagnóstico e reparo de conjuntos mecânicos; desmontagem, ajuste e montagem em bancadas técnicas.', NOW() - INTERVAL '170 days', TRUE),
-- Oficina de Manutenção Elétrica — Centro
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Testes e reparos de componentes elétricos; montagem de painéis de treinamento e diagnóstico de circuitos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(128, 7, 'Oficina de Manutenção Elétrica — Centro', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Testes e reparos de componentes elétricos; montagem de painéis de treinamento e diagnóstico de circuitos.', NOW() - INTERVAL '170 days', TRUE),
-- Planejamento da Produção — Centro
-- Local: Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Programação das ordens de fabricação, distribuição da capacidade e acompanhamento dos turnos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(129, 7, 'Planejamento da Produção — Centro', 3, 'Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Programação das ordens de fabricação, distribuição da capacidade e acompanhamento dos turnos.', NOW() - INTERVAL '170 days', TRUE),
-- Engenharia de Processos — Centro
-- Local: Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Revisão de métodos de fabricação e projetos de melhoria; análise de indicadores de produtividade.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(130, 7, 'Engenharia de Processos — Centro', 3, 'Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Revisão de métodos de fabricação e projetos de melhoria; análise de indicadores de produtividade.', NOW() - INTERVAL '170 days', TRUE),
-- Escritório de Recursos Humanos — Centro
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Atendimento aos colaboradores, organização de admissões e administração de documentos funcionais.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(131, 7, 'Escritório de Recursos Humanos — Centro', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Atendimento aos colaboradores, organização de admissões e administração de documentos funcionais.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Gestão da Manutenção — Centro
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento de intervenções preventivas e corretivas; priorização e acompanhamento das ordens de serviço.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(132, 7, 'Sala de Gestão da Manutenção — Centro', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento de intervenções preventivas e corretivas; priorização e acompanhamento das ordens de serviço.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório de Segurança do Trabalho — Centro
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Palestras, campanhas de prevenção e reuniões ampliadas de segurança dos colaboradores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(133, 7, 'Auditório de Segurança do Trabalho — Centro', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Palestras, campanhas de prevenção e reuniões ampliadas de segurança dos colaboradores.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de Peças — Centro
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Recebimento, guarda e separação de peças de reposição para as intervenções de manutenção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(134, 7, 'Almoxarifado de Peças — Centro', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Recebimento, guarda e separação de peças de reposição para as intervenções de manutenção.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de EPI — Centro
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento e distribuição de equipamentos de proteção individual; conferência de estoque.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(135, 7, 'Almoxarifado de EPI — Centro', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento e distribuição de equipamentos de proteção individual; conferência de estoque.', NOW() - INTERVAL '170 days', TRUE),
-- Depósito de Ferramentas — Centro
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda, empréstimo e devolução de ferramentas utilizadas pelas equipes de manutenção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(136, 7, 'Depósito de Ferramentas — Centro', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Guarda, empréstimo e devolução de ferramentas utilizadas pelas equipes de manutenção.', NOW() - INTERVAL '170 days', TRUE),
-- Refeitório dos Colaboradores — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Consumo das refeições nos intervalos dos turnos; mesas coletivas e pontos de água potável.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(137, 7, 'Refeitório dos Colaboradores — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Consumo das refeições nos intervalos dos turnos; mesas coletivas e pontos de água potável.', NOW() - INTERVAL '170 days', TRUE),
-- Área de Descanso — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Pausas dos colaboradores entre atividades; espaço de convivência separado das áreas técnicas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(138, 7, 'Área de Descanso — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Pausas dos colaboradores entre atividades; espaço de convivência separado das áreas técnicas.', NOW() - INTERVAL '170 days', TRUE),
-- Recepção e Controle de Acesso — Centro
-- Local: Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Registro de visitantes e orientação de entrada; encaminhamento para os setores autorizados.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(139, 7, 'Recepção e Controle de Acesso — Centro', 3, 'Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Registro de visitantes e orientação de entrada; encaminhamento para os setores autorizados.', NOW() - INTERVAL '170 days', TRUE),
-- Pátio de Circulação — Centro
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Deslocamento entre prédios e organização dos acessos; apoio à sinalização e segurança da circulação.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(140, 7, 'Pátio de Circulação — Centro', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Deslocamento entre prédios e organização dos acessos; apoio à sinalização e segurança da circulação.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Capacitação Operacional — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Treinamento de operadores e integração de novos colaboradores; aulas sobre procedimentos de produção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(141, 8, 'Sala de Capacitação Operacional — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Treinamento de operadores e integração de novos colaboradores; aulas sobre procedimentos de produção.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Treinamento de Segurança — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas sobre prevenção de acidentes, uso de EPI e procedimentos de emergência.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(142, 8, 'Sala de Treinamento de Segurança — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas sobre prevenção de acidentes, uso de EPI e procedimentos de emergência.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Treinamento de Qualidade — Bela Vista
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Capacitação em inspeção de peças, critérios de aceitação e registro de não conformidades.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(143, 8, 'Sala de Treinamento de Qualidade — Bela Vista', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Capacitação em inspeção de peças, critérios de aceitação e registro de não conformidades.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Controle de Qualidade — Bela Vista
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Inspeção e avaliação de amostras de peças produzidas; registro de resultados e liberação de lotes.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(144, 8, 'Laboratório de Controle de Qualidade — Bela Vista', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Inspeção e avaliação de amostras de peças produzidas; registro de resultados e liberação de lotes.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Metrologia — Bela Vista
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Medição dimensional de peças e verificação de instrumentos; uso de paquímetros e micrômetros.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(145, 8, 'Laboratório de Metrologia — Bela Vista', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Medição dimensional de peças e verificação de instrumentos; uso de paquímetros e micrômetros.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Ensaios — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Ensaios técnicos de materiais e componentes; análise de desempenho e elaboração de relatórios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(146, 8, 'Laboratório de Ensaios — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Ensaios técnicos de materiais e componentes; análise de desempenho e elaboração de relatórios.', NOW() - INTERVAL '170 days', TRUE),
-- Oficina de Manutenção Mecânica — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Diagnóstico e reparo de conjuntos mecânicos; desmontagem, ajuste e montagem em bancadas técnicas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(147, 8, 'Oficina de Manutenção Mecânica — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Diagnóstico e reparo de conjuntos mecânicos; desmontagem, ajuste e montagem em bancadas técnicas.', NOW() - INTERVAL '170 days', TRUE),
-- Oficina de Manutenção Elétrica — Bela Vista
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Testes e reparos de componentes elétricos; montagem de painéis de treinamento e diagnóstico de circuitos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(148, 8, 'Oficina de Manutenção Elétrica — Bela Vista', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Testes e reparos de componentes elétricos; montagem de painéis de treinamento e diagnóstico de circuitos.', NOW() - INTERVAL '170 days', TRUE),
-- Planejamento da Produção — Bela Vista
-- Local: Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Programação das ordens de fabricação, distribuição da capacidade e acompanhamento dos turnos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(149, 8, 'Planejamento da Produção — Bela Vista', 3, 'Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Programação das ordens de fabricação, distribuição da capacidade e acompanhamento dos turnos.', NOW() - INTERVAL '170 days', TRUE),
-- Engenharia de Processos — Bela Vista
-- Local: Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Revisão de métodos de fabricação e projetos de melhoria; análise de indicadores de produtividade.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(150, 8, 'Engenharia de Processos — Bela Vista', 3, 'Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Revisão de métodos de fabricação e projetos de melhoria; análise de indicadores de produtividade.', NOW() - INTERVAL '170 days', TRUE),
-- Escritório de Recursos Humanos — Bela Vista
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Atendimento aos colaboradores, organização de admissões e administração de documentos funcionais.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(151, 8, 'Escritório de Recursos Humanos — Bela Vista', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Atendimento aos colaboradores, organização de admissões e administração de documentos funcionais.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Gestão da Manutenção — Bela Vista
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento de intervenções preventivas e corretivas; priorização e acompanhamento das ordens de serviço.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(152, 8, 'Sala de Gestão da Manutenção — Bela Vista', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento de intervenções preventivas e corretivas; priorização e acompanhamento das ordens de serviço.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório de Segurança do Trabalho — Bela Vista
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Palestras, campanhas de prevenção e reuniões ampliadas de segurança dos colaboradores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(153, 8, 'Auditório de Segurança do Trabalho — Bela Vista', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Palestras, campanhas de prevenção e reuniões ampliadas de segurança dos colaboradores.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de Peças — Bela Vista
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Recebimento, guarda e separação de peças de reposição para as intervenções de manutenção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(154, 8, 'Almoxarifado de Peças — Bela Vista', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Recebimento, guarda e separação de peças de reposição para as intervenções de manutenção.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de EPI — Bela Vista
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento e distribuição de equipamentos de proteção individual; conferência de estoque.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(155, 8, 'Almoxarifado de EPI — Bela Vista', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento e distribuição de equipamentos de proteção individual; conferência de estoque.', NOW() - INTERVAL '170 days', TRUE),
-- Depósito de Ferramentas — Bela Vista
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda, empréstimo e devolução de ferramentas utilizadas pelas equipes de manutenção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(156, 8, 'Depósito de Ferramentas — Bela Vista', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Guarda, empréstimo e devolução de ferramentas utilizadas pelas equipes de manutenção.', NOW() - INTERVAL '170 days', TRUE),
-- Refeitório dos Colaboradores — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Consumo das refeições nos intervalos dos turnos; mesas coletivas e pontos de água potável.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(157, 8, 'Refeitório dos Colaboradores — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Consumo das refeições nos intervalos dos turnos; mesas coletivas e pontos de água potável.', NOW() - INTERVAL '170 days', TRUE),
-- Área de Descanso — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Pausas dos colaboradores entre atividades; espaço de convivência separado das áreas técnicas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(158, 8, 'Área de Descanso — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Pausas dos colaboradores entre atividades; espaço de convivência separado das áreas técnicas.', NOW() - INTERVAL '170 days', TRUE),
-- Recepção e Controle de Acesso — Bela Vista
-- Local: Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Registro de visitantes e orientação de entrada; encaminhamento para os setores autorizados.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(159, 8, 'Recepção e Controle de Acesso — Bela Vista', 3, 'Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Registro de visitantes e orientação de entrada; encaminhamento para os setores autorizados.', NOW() - INTERVAL '170 days', TRUE),
-- Pátio de Circulação — Bela Vista
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Deslocamento entre prédios e organização dos acessos; apoio à sinalização e segurança da circulação.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(160, 8, 'Pátio de Circulação — Bela Vista', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Deslocamento entre prédios e organização dos acessos; apoio à sinalização e segurança da circulação.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Capacitação Operacional — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Treinamento de operadores e integração de novos colaboradores; aulas sobre procedimentos de produção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(161, 9, 'Sala de Capacitação Operacional — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Treinamento de operadores e integração de novos colaboradores; aulas sobre procedimentos de produção.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Treinamento de Segurança — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Aulas sobre prevenção de acidentes, uso de EPI e procedimentos de emergência.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(162, 9, 'Sala de Treinamento de Segurança — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Aulas sobre prevenção de acidentes, uso de EPI e procedimentos de emergência.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Treinamento de Qualidade — Campinas
-- Local: Bloco A, térreo. Sala com mesas, quadro e recursos de projeção.
-- Finalidade e utilização: Capacitação em inspeção de peças, critérios de aceitação e registro de não conformidades.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(163, 9, 'Sala de Treinamento de Qualidade — Campinas', 1, 'Bloco A, térreo. Sala com mesas, quadro e recursos de projeção. Uso: Capacitação em inspeção de peças, critérios de aceitação e registro de não conformidades.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Controle de Qualidade — Campinas
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Inspeção e avaliação de amostras de peças produzidas; registro de resultados e liberação de lotes.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(164, 9, 'Laboratório de Controle de Qualidade — Campinas', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Inspeção e avaliação de amostras de peças produzidas; registro de resultados e liberação de lotes.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Metrologia — Campinas
-- Local: Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Medição dimensional de peças e verificação de instrumentos; uso de paquímetros e micrômetros.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(165, 9, 'Laboratório de Metrologia — Campinas', 2, 'Bloco A, térreo. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Medição dimensional de peças e verificação de instrumentos; uso de paquímetros e micrômetros.', NOW() - INTERVAL '170 days', TRUE),
-- Laboratório de Ensaios — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Ensaios técnicos de materiais e componentes; análise de desempenho e elaboração de relatórios.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(166, 9, 'Laboratório de Ensaios — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Ensaios técnicos de materiais e componentes; análise de desempenho e elaboração de relatórios.', NOW() - INTERVAL '170 days', TRUE),
-- Oficina de Manutenção Mecânica — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Diagnóstico e reparo de conjuntos mecânicos; desmontagem, ajuste e montagem em bancadas técnicas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(167, 9, 'Oficina de Manutenção Mecânica — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Diagnóstico e reparo de conjuntos mecânicos; desmontagem, ajuste e montagem em bancadas técnicas.', NOW() - INTERVAL '170 days', TRUE),
-- Oficina de Manutenção Elétrica — Campinas
-- Local: Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários.
-- Finalidade e utilização: Testes e reparos de componentes elétricos; montagem de painéis de treinamento e diagnóstico de circuitos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(168, 9, 'Oficina de Manutenção Elétrica — Campinas', 2, 'Bloco A, 1º pavimento. Ambiente técnico com bancadas, pontos de energia e armários. Uso: Testes e reparos de componentes elétricos; montagem de painéis de treinamento e diagnóstico de circuitos.', NOW() - INTERVAL '170 days', TRUE),
-- Planejamento da Produção — Campinas
-- Local: Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Programação das ordens de fabricação, distribuição da capacidade e acompanhamento dos turnos.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(169, 9, 'Planejamento da Produção — Campinas', 3, 'Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Programação das ordens de fabricação, distribuição da capacidade e acompanhamento dos turnos.', NOW() - INTERVAL '170 days', TRUE),
-- Engenharia de Processos — Campinas
-- Local: Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Revisão de métodos de fabricação e projetos de melhoria; análise de indicadores de produtividade.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(170, 9, 'Engenharia de Processos — Campinas', 3, 'Bloco A, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Revisão de métodos de fabricação e projetos de melhoria; análise de indicadores de produtividade.', NOW() - INTERVAL '170 days', TRUE),
-- Escritório de Recursos Humanos — Campinas
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Atendimento aos colaboradores, organização de admissões e administração de documentos funcionais.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(171, 9, 'Escritório de Recursos Humanos — Campinas', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Atendimento aos colaboradores, organização de admissões e administração de documentos funcionais.', NOW() - INTERVAL '170 days', TRUE),
-- Sala de Gestão da Manutenção — Campinas
-- Local: Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Planejamento de intervenções preventivas e corretivas; priorização e acompanhamento das ordens de serviço.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(172, 9, 'Sala de Gestão da Manutenção — Campinas', 3, 'Bloco B, térreo. Sala de atendimento com estações de trabalho e arquivo. Uso: Planejamento de intervenções preventivas e corretivas; priorização e acompanhamento das ordens de serviço.', NOW() - INTERVAL '170 days', TRUE),
-- Auditório de Segurança do Trabalho — Campinas
-- Local: Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção.
-- Finalidade e utilização: Palestras, campanhas de prevenção e reuniões ampliadas de segurança dos colaboradores.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(173, 9, 'Auditório de Segurança do Trabalho — Campinas', 4, 'Bloco B, térreo. Espaço de apresentações com assentos, palco e projeção. Uso: Palestras, campanhas de prevenção e reuniões ampliadas de segurança dos colaboradores.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de Peças — Campinas
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Recebimento, guarda e separação de peças de reposição para as intervenções de manutenção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(174, 9, 'Almoxarifado de Peças — Campinas', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Recebimento, guarda e separação de peças de reposição para as intervenções de manutenção.', NOW() - INTERVAL '170 days', TRUE),
-- Almoxarifado de EPI — Campinas
-- Local: Bloco B, térreo. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Armazenamento e distribuição de equipamentos de proteção individual; conferência de estoque.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(175, 9, 'Almoxarifado de EPI — Campinas', 5, 'Bloco B, térreo. Depósito com estantes e áreas para separação de materiais. Uso: Armazenamento e distribuição de equipamentos de proteção individual; conferência de estoque.', NOW() - INTERVAL '170 days', TRUE),
-- Depósito de Ferramentas — Campinas
-- Local: Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais.
-- Finalidade e utilização: Guarda, empréstimo e devolução de ferramentas utilizadas pelas equipes de manutenção.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(176, 9, 'Depósito de Ferramentas — Campinas', 5, 'Bloco B, 1º pavimento. Depósito com estantes e áreas para separação de materiais. Uso: Guarda, empréstimo e devolução de ferramentas utilizadas pelas equipes de manutenção.', NOW() - INTERVAL '170 days', TRUE),
-- Refeitório dos Colaboradores — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Consumo das refeições nos intervalos dos turnos; mesas coletivas e pontos de água potável.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(177, 9, 'Refeitório dos Colaboradores — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Consumo das refeições nos intervalos dos turnos; mesas coletivas e pontos de água potável.', NOW() - INTERVAL '170 days', TRUE),
-- Área de Descanso — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Pausas dos colaboradores entre atividades; espaço de convivência separado das áreas técnicas.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(178, 9, 'Área de Descanso — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Pausas dos colaboradores entre atividades; espaço de convivência separado das áreas técnicas.', NOW() - INTERVAL '170 days', TRUE),
-- Recepção e Controle de Acesso — Campinas
-- Local: Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo.
-- Finalidade e utilização: Registro de visitantes e orientação de entrada; encaminhamento para os setores autorizados.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(179, 9, 'Recepção e Controle de Acesso — Campinas', 3, 'Bloco B, 1º pavimento. Sala de atendimento com estações de trabalho e arquivo. Uso: Registro de visitantes e orientação de entrada; encaminhamento para os setores autorizados.', NOW() - INTERVAL '170 days', TRUE),
-- Pátio de Circulação — Campinas
-- Local: Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada.
-- Finalidade e utilização: Deslocamento entre prédios e organização dos acessos; apoio à sinalização e segurança da circulação.
-- Cenário fictício para teste; localização e infraestrutura propostas para este ambiente.
(180, 9, 'Pátio de Circulação — Campinas', 6, 'Bloco B, 1º pavimento. Área de uso compartilhado com circulação sinalizada. Uso: Deslocamento entre prédios e organização dos acessos; apoio à sinalização e segurança da circulação.', NOW() - INTERVAL '170 days', TRUE);


-- ===================================================
-- 11. EVENTOS (72)
-- ===================================================
INSERT INTO evento (
    id, usuario_id, local_unidade_id, titulo, descricao,
    descricao_local, observacao, data_hora_inicio, data_hora_fim, data_criacao
)
SELECT
    n,
    ((l.unidade_id - 1) * 6) + 2,
    l.id,
    'Inspeção preventiva: ' || l.nome,
    'Verificar iluminação, tomadas e condições de uso de ' || l.nome || '; registrar itens que precisem de intervenção.',
    l.descricao,
    CASE WHEN n % 4 = 0 THEN 'Necessário acesso acompanhado pelo gestor.' ELSE NULL END,
    NOW() + ((n % 45) || ' days')::INTERVAL + INTERVAL '08 hours',
    NOW() + ((n % 45) || ' days')::INTERVAL + INTERVAL '10 hours',
    NOW() - ((n % 40) || ' days')::INTERVAL
FROM generate_series(1, 72) AS n
JOIN local_unidade l ON l.id = ((n - 1) % 180) + 1;

-- ===================================================
-- 12. CATEGORIAS DE EQUIPAMENTO (10)
-- ===================================================
INSERT INTO categoria_equipamento (
    id, usuario_id, nome, descricao, data_criacao, esta_ativo
)
SELECT
    n,
    (((n - 1) % 9) * 6) + 2,
    (ARRAY[
        'Computadores', 'Ar-condicionado', 'Iluminação', 'Bombas Hidráulicas',
        'Câmeras de Segurança', 'Roteadores', 'Mobiliário', 'Quadros Elétricos',
        'Bebedouros', 'Equipamentos Mecânicos'
    ])[n],
    (ARRAY['Estações de trabalho e notebooks usados em aulas e rotinas administrativas.', 'Condicionadores de ar para controle de temperatura dos ambientes.', 'Luminárias e componentes de iluminação dos ambientes internos e externos.', 'Bombas para circulação e pressurização de água nas instalações.', 'Câmeras para acompanhamento dos acessos e áreas de circulação.', 'Roteadores e switches responsáveis pela conectividade dos ambientes.', 'Mesas, cadeiras e armários utilizados nas atividades da unidade.', 'Quadros de distribuição e dispositivos de proteção dos circuitos elétricos.', 'Bebedouros e purificadores disponíveis para alunos e colaboradores.', 'Motores e conjuntos mecânicos utilizados no apoio à operação e manutenção.'])[n],
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
    (ARRAY[1,2,3,4,5,7,6,3,4,8])[((n - 1) % 10) + 1],
    ((n - 1) % 10) + 1,
    (ARRAY['Estação de trabalho', 'Condicionador de ar split', 'Luminária LED', 'Bomba de pressurização', 'Câmera de monitoramento', 'Roteador de acesso', 'Cadeira de trabalho', 'Quadro de distribuição', 'Bebedouro de coluna', 'Motor de acionamento'])[((n - 1) % 10) + 1] || ' - série ' || (((n - 1) / 10) + 1),
    (ARRAY['Estações de trabalho e notebooks usados em aulas e rotinas administrativas.', 'Condicionadores de ar para controle de temperatura dos ambientes.', 'Luminárias e componentes de iluminação dos ambientes internos e externos.', 'Bombas para circulação e pressurização de água nas instalações.', 'Câmeras para acompanhamento dos acessos e áreas de circulação.', 'Roteadores e switches responsáveis pela conectividade dos ambientes.', 'Mesas, cadeiras e armários utilizados nas atividades da unidade.', 'Quadros de distribuição e dispositivos de proteção dos circuitos elétricos.', 'Bebedouros e purificadores disponíveis para alunos e colaboradores.', 'Motores e conjuntos mecânicos utilizados no apoio à operação e manutenção.'])[((n - 1) % 10) + 1],
    NOW() - ((150 - n) || ' days')::INTERVAL,
    TRUE
FROM generate_series(1, 30) AS n;

-- ===================================================
-- 15. EQUIPAMENTOS (180) - 1 por local
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
FROM generate_series(1, 180) AS n
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
        'Computador desligando', 'Gotejamento no ar-condicionado', 'Luminária com fixação solta',
        'Bomba sem acionamento', 'Suporte da câmera solto', 'Roteador superaquecendo',
        'Ponto de rede sem conexão', 'Quadro elétrico com trava danificada', 'Indicador do bebedouro apagado', 'Motor necessita limpeza técnica'
    ])[((n - 1) % 10) + 1] || ' #' || n,
    (ARRAY['Computador desliga durante o uso; verificar fonte e alimentação elétrica.', 'Condicionador apresenta gotejamento; verificar dreno e escoamento.', 'Luminária apresenta vibração na fixação; verificar suporte antes de liberar o uso.', 'Bomba não responde ao comando do painel; verificar acionamento e controle.', 'Suporte da câmera está solto e desloca o enquadramento; revisar fixação.', 'Roteador aquece e interrompe a conexão; verificar ventilação e dissipação.', 'Ponto de rede junto à mesa não estabelece conexão; testar cabo e tomada.', 'Fechamento do quadro elétrico está danificado; restringir acesso e revisar trava.', 'Indicador luminoso do bebedouro não acende; verificar sinalização e alimentação.', 'Motor acumula resíduos na carenagem; programar limpeza técnica com isolamento.'])[((n - 1) % 10) + 1] || ' Ambiente: ' || l.nome,
    l.descricao,
    CASE WHEN n > 208 THEN 'Solicitação recusada após análise por não se enquadrar no fluxo de manutenção.' ELSE NULL END,
    GREATEST(
        NOW() - ((15 + (n * 7) % 150) || ' days')::INTERVAL,
        l.data_criacao + INTERVAL '1 day',
        u.data_criacao + INTERVAL '1 day'
    ),
    CASE
        WHEN n <= 160 THEN 2
        WHEN n <= 208 THEN 0
        ELSE 1
    END
FROM generate_series(1, 240) AS n
JOIN local_unidade l ON l.id = ((n - 1) % 180) + 1
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
    (ARRAY['Fonte do computador reapertada e alimentação testada.', 'Dreno do ar-condicionado desobstruído; teste sem gotejamento.', 'Suporte da luminária reapertado; fixação conferida.', 'Comando da bomba restabelecido após revisão da conexão.', 'Suporte da câmera reajustado e enquadramento conferido.', 'Ventilação do roteador desobstruída; conectividade restabelecida.', 'Cabo de rede da mesa substituído; conexão validada.', 'Trava do quadro substituída e fechamento conferido.', 'Indicador do bebedouro substituído e testado.', 'Carenagem do motor limpa com equipamento isolado; funcionamento conferido.'])[((n - 1) % 10) + 1] || ' Ambiente: ' || l.nome,
    l.descricao,
    (n - 1) % 3,
    GREATEST(
        NOW() - ((5 + (n * 3) % 110) || ' days')::INTERVAL,
        l.data_criacao + INTERVAL '1 day',
        u.data_criacao + INTERVAL '1 day'
    ),
    TRUE
FROM generate_series(1, 100) AS n
JOIN local_unidade l ON l.id = ((n - 1) % 180) + 1
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
    WHERE p.id <= 160 AND p.status = 2
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
        WHEN 1 THEN 'Diagnosticar: ' || p.descricao_problema
        WHEN 2 THEN 'Corrigir a falha registrada em ' || l.nome || ': ' || p.titulo
        ELSE 'Validar o funcionamento após o reparo em ' || l.nome || ' e registrar o resultado para ' || p.titulo
    END,
    os.data_criacao + (etapa || ' hours')::INTERVAL
FROM ordem_servico os
JOIN problema p ON p.id = os.problema_id
JOIN local_unidade l ON l.id = p.local_unidade_id
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
-- 25. TURNOS (18) - manhã e tarde por unidade
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
-- 26. TURNO_USUARIO (54) - 1 turno por usuário
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

    IF EXISTS (
        SELECT 1 FROM evento ev
        JOIN usuario u ON u.id = ev.usuario_id
        JOIN local_unidade l ON l.id = ev.local_unidade_id
        WHERE u.unidade_id <> l.unidade_id
    ) THEN
        RAISE EXCEPTION 'Evento com responsável de outra unidade.';
    END IF;

    IF EXISTS (
        SELECT i.id FROM instituicao i
        LEFT JOIN unidade un ON un.instituicao_id = i.id
        GROUP BY i.id HAVING COUNT(un.id) <> 3
    ) THEN
        RAISE EXCEPTION 'Cada instituição deve possuir exatamente três unidades.';
    END IF;

    IF EXISTS (
        SELECT un.id FROM unidade un
        LEFT JOIN local_unidade l ON l.unidade_id = un.id
        GROUP BY un.id HAVING COUNT(l.id) <> 20
    ) THEN
        RAISE EXCEPTION 'Cada unidade deve possuir 20 locais na massa de teste.';
    END IF;

    -- Confere a massa planejada para detectar perda de dados por JOINs.
    FOR verificacao IN
        SELECT * FROM (VALUES
            ('super_admin', 3), ('instituicao', 3), ('unidade', 9),
            ('plano', 4), ('contrato', 9), ('pagamento', 27),
            ('usuario', 54), ('aptidao', 54), ('feedback', 60),
            ('local_unidade', 180), ('evento', 72),
            ('categoria_equipamento', 10), ('marca_equipamento', 8),
            ('modelo_equipamento', 30), ('equipamento', 180),
            ('problema', 240), ('ocorrencia', 100),
            ('ordem_servico', 160), ('ordem_servico_status_auditoria', 249),
            ('ordem_servico_tecnico_auditoria', 40), ('tarefa', 480),
            ('observacao_conclusao', 50), ('foto', 300),
            ('turno', 18), ('turno_usuario', 54)
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
        WHERE (status = 1 AND motivo_recusa IS NULL)
           OR (status <> 1 AND motivo_recusa IS NOT NULL)
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
        WHERE p.status <> 2
    ) OR EXISTS (
        SELECT 1 FROM problema p
        WHERE p.status = 2
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
