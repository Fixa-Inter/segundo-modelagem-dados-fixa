\set ON_ERROR_STOP on
\encoding UTF8

\echo '=============================='
\echo 'CRIANDO BANCO FIXA'
\echo '=============================='


-- ===================================================
-- 1. TABELAS
-- ===================================================

\echo '1. Criando tabelas...'

-- ADMIN / INSTITUIÇÃO
\ir ../database/tabelas/super_admin.sql
\ir ../database/tabelas/instituicao.sql
\ir ../database/tabelas/unidade.sql

-- PLANOS / PAGAMENTOS
\ir ../database/tabelas/plano.sql
\ir ../database/tabelas/contrato.sql
\ir ../database/tabelas/pagamento.sql

-- USUÁRIOS
\ir ../database/tabelas/usuario.sql
\ir ../database/tabelas/aptidao.sql
\ir ../database/tabelas/feedback.sql

-- LOCAIS / EVENTOS
\ir ../database/tabelas/local_unidade.sql
\ir ../database/tabelas/evento.sql

-- EQUIPAMENTOS
\ir ../database/tabelas/categoria_equipamento.sql
\ir ../database/tabelas/marca_equipamento.sql
\ir ../database/tabelas/modelo_equipamento.sql
\ir ../database/tabelas/equipamento.sql

-- PROBLEMAS / OCORRÊNCIAS
\ir ../database/tabelas/problema.sql
\ir ../database/tabelas/ocorrencia.sql

-- ORDEM DE SERVIÇO
\ir ../database/tabelas/ordem_servico.sql

-- AUDITORIAS DA ORDEM DE SERVIÇO
\ir ../database/tabelas/ordem_servico_status_auditoria.sql
\ir ../database/tabelas/ordem_servico_tecnico_auditoria.sql

-- AUDITORIAS COMPLETAS
\ir ../database/tabelas/pagamento_auditoria.sql
\ir ../database/tabelas/problema_auditoria.sql
\ir ../database/tabelas/usuario_auditoria.sql

-- TAREFAS
\ir ../database/tabelas/tarefa.sql

-- CONCLUSÃO / FOTOS
\ir ../database/tabelas/observacao_conclusao.sql
\ir ../database/tabelas/foto.sql

-- TURNOS
\ir ../database/tabelas/turno.sql
\ir ../database/tabelas/turno_usuario.sql


-- ===================================================
-- 2. FUNÇÕES
-- ===================================================

\echo '2. Criando funcoes...'

\ir ../database/functions/traduzir_enums.sql

-- As funções utilizadas pelas triggers de auditoria
-- estão dentro dos próprios arquivos de trigger.


-- ===================================================
-- 3. PROCEDURES
-- ===================================================

\echo '3. Criando procedures...'

\ir ../database/procedures/cadastrar_problema.sql
\ir ../database/procedures/cadastrar_ocorrencia.sql
\ir ../database/procedures/cadastrar_observacao_conclusao.sql


-- ===================================================
-- 4. TRIGGERS
-- ===================================================

\echo '4. Criando triggers...'

\ir ../database/triggers/atualizar_data_atualizacao.sql
\ir ../database/triggers/auditar_status_ordem_servico.sql
\ir ../database/triggers/auditar_tecnico_ordem_servico.sql
\ir ../database/triggers/auditar_pagamento.sql
\ir ../database/triggers/auditar_problema.sql
\ir ../database/triggers/auditar_usuario.sql


-- ===================================================
-- 5. VIEWS
-- ===================================================

\echo '5. Criando views...'

-- DIMENSÕES

\ir ../database/views/dim_tempo.sql
\ir ../database/views/dim_tecnico.sql
\ir ../database/views/dim_categoria_problema.sql
\ir ../database/views/dim_categoria_equipamento.sql
\ir ../database/views/dim_instituicao.sql
\ir ../database/views/dim_unidade.sql
\ir ../database/views/dim_local.sql
\ir ../database/views/dim_status_ordem_servico.sql
\ir ../database/views/dim_status_problema.sql

-- FATOS

\ir ../database/views/fato_ordem_servico.sql
\ir ../database/views/fato_problema.sql
\ir ../database/views/fato_ocorrencia.sql


-- ===================================================
-- 6. ÍNDICES
-- ===================================================

\echo '6. Criando indices...'

-- Índices de otimização serão adicionados aqui.
-- \ir ../database/indices/nome_indice.sql


-- ===================================================
-- 7. CARGA INICIAL
-- ===================================================

\echo '7. Carregando dados iniciais...'

\ir ../database/seeds/data_load_fixa.sql


\echo '=============================='
\echo 'BANCO CRIADO COM SUCESSO'
\echo '=============================='
