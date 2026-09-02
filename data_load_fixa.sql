-- ===================================================
-- SCRIPT DE MASSA DE DADOS (SEED)
-- Requisito: carga inicial de pelo menos 500 registros
-- verossímeis para testes de volume.
-- ---------------------------------------------------
-- Total gerado por este script: ~839 registros
-- ---------------------------------------------------
-- OBS 1: Execução sequencial pós-DDL em banco limpo,
--        considerando IDs SERIAL/BIGSERIAL iniciando 
--        em 1 sem lacunas.
-- OBS 2: Mapeamento de enums/códigos inteiros assumido:
--        • instituicao.tipo_instituicao        -> 1=Escola, 2=Faculdade, 3=Empresa, 4=Órgão Público
--        • problema.status                     -> 0=Pendente, 1=Aprovado, 2=Reprovado
--        • usuario.tipo_acesso                 -> 1=Administrador, 2=Gestor, 3=Técnico, 4=Solicitante
--        • pagamento.metodo_pagamento          -> 1=Boleto, 2=Cartão de Crédito, 3=PIX, 4=Transferência
--        • local_endereco.tipo_local_endereco  -> 1=Sala de Aula, 2=Laboratório, 3=Depto. Admin, 4=Auditório, 5=Almoxarifado, 6=Área Comum
--        • categoria_problema                  -> 1=Elétrica, 2=Hidráulica, 3=Mecânica, 4=Informática, 5=Mobiliário, 6=Climatização, 7=Rede, 8=Segurança, 9=Iluminação, 10=Limpeza
-- OBS 3: Arco exclusivo em `foto` (`ck_foto_apenas_uma_fk`): exatamente 1 FK preenchida por registro.
-- OBS 4: `turno.hora_inicio` e `turno.hora_fim` como INTEGER em segundos (0 a 86400), validando `atravessa_meia_noite`.
-- OBS 5: Mapeamento 1:1 estrito entre `ordem_servico` e `problema`.
-- OBS 6: Integridade referencial (FKs) garantida por limites dinâmicos ajustados ao volume das tabelas pai.
-- ===================================================
BEGIN;

-- ---------------------------------------------------
-- TABELAS TEMPORÁRIAS DE APOIO
-- ---------------------------------------------------

DROP TABLE IF EXISTS tmp_nomes, tmp_sobrenomes, tmp_cidades, tmp_ruas, tmp_bairros, tmp_instituicoes;

CREATE TEMP TABLE tmp_nomes(nome varchar);
INSERT INTO tmp_nomes VALUES
('Ana'),('Bruno'),('Carlos'),('Daniela'),('Eduardo'),('Fernanda'),('Gustavo'),('Helena'),
('Igor'),('Juliana'),('Lucas'),('Mariana'),('Nicolas'),('Otávio'),('Patrícia'),('Rafael'),
('Sabrina'),('Thiago'),('Vanessa'),('William'),('Camila'),('Diego'),('Elaine'),('Felipe'),
('Gabriela'),('Henrique'),('Isabela'),('João'),('Karina'),('Leonardo');

CREATE TEMP TABLE tmp_sobrenomes(sobrenome varchar);
INSERT INTO tmp_sobrenomes VALUES
('Silva'),('Santos'),('Oliveira'),('Souza'),('Rodrigues'),('Ferreira'),('Alves'),('Pereira'),
('Lima'),('Gomes'),('Costa'),('Ribeiro'),('Martins'),('Carvalho'),('Almeida'),('Lopes'),
('Soares'),('Fernandes'),('Vieira'),('Barbosa');

CREATE TEMP TABLE tmp_cidades(cidade varchar, estado varchar);
INSERT INTO tmp_cidades VALUES
('São Paulo','SP'),('Rio de Janeiro','RJ'),('Belo Horizonte','MG'),('Curitiba','PR'),
('Porto Alegre','RS'),('Salvador','BA'),('Recife','PE'),('Fortaleza','CE'),
('Brasília','DF'),('Campinas','SP'),('Florianópolis','SC'),('Goiânia','GO'),
('Manaus','AM'),('Belém','PA'),('Vitória','ES');

CREATE TEMP TABLE tmp_ruas(logradouro varchar);
INSERT INTO tmp_ruas VALUES
('Rua das Flores'),('Avenida Brasil'),('Rua XV de Novembro'),('Avenida Paulista'),
('Rua Sete de Setembro'),('Rua dos Andradas'),('Avenida Getúlio Vargas'),('Rua São João'),
('Rua Barão do Rio Branco'),('Avenida Rio Branco');

CREATE TEMP TABLE tmp_bairros(bairro varchar);
INSERT INTO tmp_bairros VALUES
('Centro'),('Jardim América'),('Vila Nova'),('Bela Vista'),('Boa Vista'),
('Santa Cecília'),('Cidade Alta'),('Parque Industrial'),('Vila Mariana'),('Jardim Europa');

CREATE TEMP TABLE tmp_instituicoes(nome varchar);
INSERT INTO tmp_instituicoes VALUES
('Colégio Nova Geração'),('Instituto Educacional Horizonte'),('Faculdade Central do Brasil'),
('Escola Técnica Progresso'),('Universidade Metropolitana'),('Centro Educacional Aurora'),
('Colégio Santa Clara'),('Instituto Tecnológico Vanguarda'),('Escola Municipal Pioneira'),
('Faculdade Integrada do Vale');

-- ===================================================
-- TABELAS BASE (ADMIN / INSTITUIÇÃO)
-- ===================================================

-- super_admin (3)
INSERT INTO super_admin (nome, email, senha, esta_ativo) VALUES
('Rodrigo Almeida Souza','rodrigo.admin@sistema.com','$2a$10$hashfake0001', true),
('Camila Ferreira Lima','camila.admin@sistema.com','$2a$10$hashfake0002', true),
('Bruno Costa Martins','bruno.admin@sistema.com','$2a$10$hashfake0003', true);

-- instituicao (10)
INSERT INTO instituicao (nome, cnpj, tipo_instituicao, dominio_email, data_criacao, esta_ativo)
SELECT
    (SELECT nome FROM tmp_instituicoes ORDER BY random() LIMIT 1) || ' ' || gs,
    '12.345.' || lpad(gs::text,3,'0') || '/0001-' || lpad((gs%90+10)::text,2,'0'),
    floor(random()*4+1)::int,
    'instituicao' || gs || '.com.br',
    NOW() - (random()*3650 || ' days')::interval,
    true
FROM generate_series(1,10) gs;

-- endereco (12)
INSERT INTO endereco (instituicao_id, logradouro, numero, complemento, bairro, cidade, estado, pais, cep, data_criacao, esta_ativo)
SELECT
    floor(random()*10+1)::int,
    (SELECT logradouro FROM tmp_ruas ORDER BY random() LIMIT 1),
    (floor(random()*2000+1))::text,
    CASE WHEN random() < 0.3 THEN 'Sala ' || floor(random()*20+1)::text ELSE NULL END,
    (SELECT bairro FROM tmp_bairros ORDER BY random() LIMIT 1),
    c.cidade,
    c.estado,
    'Brasil',
    lpad(floor(random()*99999999)::text,8,'0'),
    NOW() - (random()*3650 || ' days')::interval,
    true
FROM generate_series(1,12) gs
CROSS JOIN LATERAL (SELECT cidade, estado FROM tmp_cidades ORDER BY random() LIMIT 1) c;

-- ===================================================
-- FLUXO PLANO / PAGAMENTO
-- ===================================================

-- plano (5)
INSERT INTO plano (nome, valor, descricao, duracao_meses, data_criacao, esta_ativo) VALUES
('Plano Básico', 99.90, 'Plano mensal com funcionalidades essenciais', 1, NOW() - interval '365 days', true),
('Plano Padrão', 249.90, 'Plano trimestral com suporte prioritário', 3, NOW() - interval '365 days', true),
('Plano Semestral', 449.90, 'Plano semestral com relatórios avançados', 6, NOW() - interval '365 days', true),
('Plano Anual', 799.90, 'Plano anual com todos os módulos liberados', 12, NOW() - interval '365 days', true),
('Plano Enterprise', 1499.90, 'Plano anual para grandes instituições, com suporte dedicado', 12, NOW() - interval '365 days', true);

-- contrato (15)
INSERT INTO contrato (plano_id, endereco_id, data_inicio, data_fim, status, data_criacao)
SELECT
    pl.id,
    floor(random()*12+1)::int,
    x.d_inicio,
    (x.d_inicio + (pl.duracao_meses || ' months')::interval)::date,
    floor(random()*3)::int,
    NOW() - (random()*365 || ' days')::interval
FROM generate_series(1,15) gs
CROSS JOIN LATERAL (SELECT id, duracao_meses FROM plano ORDER BY random() LIMIT 1) pl
CROSS JOIN LATERAL (SELECT CURRENT_DATE - (floor(random()*730))::int AS d_inicio) x;

-- pagamento (30)
INSERT INTO pagamento (contrato_id, data_pagamento, valor_pago, status, metodo_pagamento, data_criacao)
SELECT
    floor(random()*15+1)::int,
    CURRENT_DATE - floor(random()*365)::int,
    round((random()*1400+49.9)::numeric,2),
    floor(random()*3)::int,
    floor(random()*4+1)::int,
    NOW() - (random()*365 || ' days')::interval
FROM generate_series(1,30);

-- ===================================================
-- USUÁRIOS / APTIDÃO
-- ===================================================

-- usuario (60)
INSERT INTO usuario (nome_completo, email, tipo_acesso, senha_hash, data_nascimento, data_criacao, esta_ativo)
SELECT
    nomes.arr[1 + floor(random()*array_length(nomes.arr,1))::int] || ' ' ||
    sobrenomes.arr[1 + floor(random()*array_length(sobrenomes.arr,1))::int],
    lower(
        nomes.arr[1 + floor(random()*array_length(nomes.arr,1))::int] || '.' ||
        sobrenomes.arr[1 + floor(random()*array_length(sobrenomes.arr,1))::int] || gs || '@email.com'
    ),
    floor(random()*4+1)::int,
    '$2a$10$hashfakeuser' || lpad(gs::text,4,'0'),
    CURRENT_DATE - (floor(random()*365*47)+365*18)::int,
    NOW() - (random()*1000 || ' days')::interval,
    (random() < 0.9)
FROM generate_series(1,60) gs
CROSS JOIN (SELECT array_agg(nome) AS arr FROM tmp_nomes) nomes
CROSS JOIN (SELECT array_agg(sobrenome) AS arr FROM tmp_sobrenomes) sobrenomes;

-- aptidao (60)
INSERT INTO aptidao (usuario_id, categoria_problema, nota, data_criacao, esta_ativo)
SELECT
    floor(random()*60+1)::int,
    floor(random()*10+1)::int,
    round((random()*10)::numeric,2),
    NOW() - (random()*500 || ' days')::interval,
    true
FROM generate_series(1,60);

-- ===================================================
-- LOCAIS / EVENTOS / TURNOS
-- ===================================================

-- local_endereco (30)
INSERT INTO local_endereco (endereco_id, nome, tipo_local_endereco, descricao, data_criacao, esta_ativo)
SELECT
    floor(random()*12+1)::int,
    'Sala ' || gs,
    floor(random()*6+1)::int,
    'Ambiente ' || gs || ' destinado a atividades diversas da instituição',
    NOW() - (random()*400 || ' days')::interval,
    true
FROM generate_series(1,30) gs;

-- evento (25)
INSERT INTO evento (usuario_id, local_endereco_id, titulo, descricao, descricao_local, observacao, data_hora_inicio, data_hora_fim, data_criacao)
SELECT
    floor(random()*60+1)::int,
    floor(random()*30+1)::int,
    'Evento ' || gs,
    'Descrição do evento número ' || gs || ' organizado na instituição',
    'Local reservado para o evento',
    CASE WHEN random() < 0.4 THEN 'Necessário confirmar presença com antecedência' ELSE NULL END,
    t.ts_inicio,
    t.ts_inicio + interval '2 hours',
    NOW() - (random()*300 || ' days')::interval
FROM generate_series(1,25) gs
CROSS JOIN LATERAL (SELECT NOW() + (floor(random()*60-30) || ' days')::interval AS ts_inicio) t;

-- turno (30) -> horário armazenado em segundos
INSERT INTO turno (local_endereco_id, nome, hora_inicio, hora_fim, atravessa_meia_noite, data_criacao, esta_ativo)
SELECT
    floor(random()*30+1)::int,
    t.nome_turno || ' ' || gs,
    t.h_inicio,
    t.h_fim,
    t.meia_noite,
    NOW() - (random()*300 || ' days')::interval,
    true
FROM generate_series(1,30) gs
CROSS JOIN LATERAL (
    SELECT 
        CASE (gs % 3)
            WHEN 1 THEN 'Turno Matutino'
            WHEN 2 THEN 'Turno Vespertino'
            ELSE 'Turno Noturno'
        END AS nome_turno,
        CASE (gs % 3)
            WHEN 1 THEN 25200  -- 07:00
            WHEN 2 THEN 46800  -- 13:00
            ELSE 79200         -- 22:00
        END AS h_inicio,
        CASE (gs % 3)
            WHEN 1 THEN 43200  -- 12:00
            WHEN 2 THEN 64800  -- 18:00
            ELSE 21600         -- 06:00
        END AS h_fim,
        CASE WHEN (gs % 3) = 0 THEN true ELSE false END AS meia_noite
) t;

-- turno_usuario (40)
INSERT INTO turno_usuario (turno_id, usuario_id, data_criacao, esta_ativo)
SELECT
    floor(random()*30+1)::int,
    floor(random()*60+1)::int,
    NOW() - (random()*200 || ' days')::interval,
    true
FROM generate_series(1,40) gs;

-- ===================================================
-- EQUIPAMENTOS / PROBLEMAS / OCORRÊNCIAS
-- ===================================================

-- categoria_equipamento (8)
INSERT INTO categoria_equipamento (usuario_id, nome, descricao, data_criacao, esta_ativo)
SELECT
    floor(random()*60+1)::int,
    cat.nome,
    'Categoria de equipamentos do tipo ' || cat.nome,
    NOW() - (random()*400 || ' days')::interval,
    true
FROM generate_series(1,8) gs
CROSS JOIN LATERAL (
    SELECT (ARRAY['Informática','Mobiliário','Audiovisual','Climatização',
                  'Elétrica','Segurança','Laboratorial','Comunicação'])[gs] AS nome
) cat;

-- marca_equipamento (10)
INSERT INTO marca_equipamento (nome, descricao, data_criacao, esta_ativo) VALUES
('Dell','Fabricante de equipamentos de informática', NOW()-interval '500 days', true),
('HP','Fabricante de equipamentos de informática e impressão', NOW()-interval '490 days', true),
('Lenovo','Fabricante de notebooks e desktops', NOW()-interval '480 days', true),
('Samsung','Fabricante de eletrônicos diversos', NOW()-interval '470 days', true),
('LG','Fabricante de eletrônicos e climatização', NOW()-interval '460 days', true),
('Positivo','Fabricante nacional de equipamentos de informática', NOW()-interval '450 days', true),
('Epson','Fabricante de impressoras e projetores', NOW()-interval '440 days', true),
('Intelbras','Fabricante de equipamentos de segurança e redes', NOW()-interval '430 days', true),
('Consul','Fabricante de eletrodomésticos', NOW()-interval '420 days', true),
('Springer','Fabricante de equipamentos de climatização', NOW()-interval '410 days', true);

-- modelo_equipamento (20)
INSERT INTO modelo_equipamento (marca_equipamento_id, categoria_equipamento_id, nome, descricao, data_criacao, esta_ativo)
SELECT
    floor(random()*10+1)::int,
    floor(random()*8+1)::int,
    'Modelo ' || gs,
    'Modelo de equipamento número ' || gs,
    NOW() - (random()*400 || ' days')::interval,
    true
FROM generate_series(1,20) gs;

-- equipamento (50)
INSERT INTO equipamento (usuario_id, modelo_equipamento_id, local_endereco_id, codigo, data_criacao, esta_ativo)
SELECT
    floor(random()*60+1)::int,
    floor(random()*20+1)::int,
    floor(random()*30+1)::int,
    'EQP-' || lpad(gs::text,5,'0'),
    NOW() - (random()*300 || ' days')::interval,
    true
FROM generate_series(1,50) gs;

-- problema (40)
INSERT INTO problema (usuario_id, categoria_equipamento_id, local_endereco_id, titulo, descricao_problema, descricao_local, data_criacao, status)
SELECT
    floor(random()*60+1)::int,
    floor(random()*8+1)::int,
    floor(random()*30+1)::int,
    'Problema relatado ' || gs,
    'Descrição detalhada do problema número ' || gs || ' identificado no equipamento',
    'Localização informada pelo solicitante',
    NOW() - (random()*300 || ' days')::interval,
    floor(random()*3)::int
FROM generate_series(1,40) gs;

-- ocorrencia (40)
INSERT INTO ocorrencia (usuario_id, local_endereco_id, equipamento_id, categoria_problema, titulo, descricao_ocorrencia, descricao_local, data_criacao, esta_ativo)
SELECT
    floor(random()*60+1)::int,
    floor(random()*30+1)::int,
    floor(random()*50+1)::int,
    floor(random()*10+1)::int,
    'Ocorrência ' || gs,
    'Descrição detalhada da ocorrência número ' || gs,
    'Localização informada no registro da ocorrência',
    NOW() - (random()*300 || ' days')::interval,
    true
FROM generate_series(1,40) gs;

-- ===================================================
-- ORDEM DE SERVIÇO / TAREFAS
-- ===================================================

-- status_ordem_servico (6)
INSERT INTO status_ordem_servico (nome, descricao) VALUES
('Aberta', 'Ordem de serviço registrada e aguardando triagem'),
('Em Análise', 'Ordem de serviço em análise técnica'),
('Em Execução', 'Ordem de serviço sendo executada pela equipe técnica'),
('Aguardando Peça', 'Ordem de serviço pausada aguardando peça ou material'),
('Concluída', 'Ordem de serviço finalizada com sucesso'),
('Cancelada', 'Ordem de serviço cancelada');

-- ordem_servico (40)
INSERT INTO ordem_servico (problema_id, usuario_id, status_ordem_servico_id, categoria_problema, data_prevista, data_criacao)
SELECT
    gs,
    floor(random()*60+1)::int,
    floor(random()*6+1)::int,
    floor(random()*10+1)::int,
    NOW() + (floor(random()*30) || ' days')::interval,
    NOW() - (random()*250 || ' days')::interval
FROM generate_series(1,40) gs;

-- ordem_servico_status_historico (60)
INSERT INTO ordem_servico_status_historico (ordem_servico_id, status_ordem_servico_id, data_atualizacao)
SELECT
    floor(random()*40+1)::int,
    floor(random()*6+1)::int,
    NOW() - (random()*200 || ' days')::interval
FROM generate_series(1,60) gs;

-- tarefa (50)
INSERT INTO tarefa (ordem_servico_id, status_ordem_servico_id, titulo, descricao, data_criacao)
SELECT
    floor(random()*40+1)::int,
    floor(random()*6+1)::int,
    'Tarefa ' || gs,
    'Descrição da tarefa número ' || gs || ' vinculada à ordem de serviço',
    NOW() - (random()*200 || ' days')::interval
FROM generate_series(1,50) gs;

-- tarefa_status_historico (70)
INSERT INTO tarefa_status_historico (tarefa_id, status_ordem_servico_id, data_atualizacao)
SELECT
    floor(random()*50+1)::int,
    floor(random()*6+1)::int,
    NOW() - (random()*180 || ' days')::interval
FROM generate_series(1,70) gs;

-- ===================================================
-- FOTOS (arco exclusivo)
-- ===================================================

-- fotos de perfil de usuário (40)
INSERT INTO foto (usuario_id, url, esta_ativo, data_criacao)
SELECT
    floor(random()*60+1)::int,
    'https://cdn.sistema.com/perfil/usuario_' || gs || '.jpg',
    true,
    NOW() - (random()*200 || ' days')::interval
FROM generate_series(1,40) gs;

-- fotos de problema (30)
INSERT INTO foto (problema_id, url, esta_ativo, data_criacao)
SELECT
    floor(random()*40+1)::int,
    'https://cdn.sistema.com/problemas/foto_' || gs || '.jpg',
    true,
    NOW() - (random()*200 || ' days')::interval
FROM generate_series(1,30) gs;

-- fotos de ocorrência (30)
INSERT INTO foto (ocorrencia_id, url, esta_ativo, data_criacao)
SELECT
    floor(random()*40+1)::int,
    'https://cdn.sistema.com/ocorrencias/foto_' || gs || '.jpg',
    true,
    NOW() - (random()*200 || ' days')::interval
FROM generate_series(1,30) gs;

-- fotos de ordem de serviço (25)
INSERT INTO foto (ordem_servico_id, url, esta_ativo, data_criacao)
SELECT
    floor(random()*40+1)::int,
    'https://cdn.sistema.com/ordens/foto_' || gs || '.jpg',
    true,
    NOW() - (random()*200 || ' days')::interval
FROM generate_series(1,25) gs;

COMMIT;