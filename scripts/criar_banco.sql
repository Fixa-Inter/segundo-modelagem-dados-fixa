\set ON_ERROR_STOP on

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
\ir ../database/tabelas/endereco.sql

-- PLANOS / PAGAMENTOS
\ir ../database/tabelas/plano.sql
\ir ../database/tabelas/contrato.sql
\ir ../database/tabelas/pagamento.sql

-- USUÁRIOS
\ir ../database/tabelas/usuario.sql
\ir ../database/tabelas/aptidao.sql
\ir ../database/tabelas/feedback.sql

-- LOCAIS / EVENTOS
\ir ../database/tabelas/local_endereco.sql
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
\ir ../database/tabelas/status_ordem_servico.sql
\ir ../database/tabelas/ordem_servico.sql

-- AUDITORIAS DA ORDEM DE SERVIÇO
\ir ../database/tabelas/ordem_servico_status_auditoria.sql
\ir ../database/tabelas/ordem_servico_tecnico_auditoria.sql

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

-- Funções independentes serão adicionadas aqui.
-- As funções utilizadas pelas triggers de auditoria
-- estão dentro dos próprios arquivos de trigger.


-- ===================================================
-- 3. PROCEDURES
-- ===================================================

\echo '3. Criando procedures...'

-- \ir ../database/procedures/nome_procedure.sql


-- ===================================================
-- 4. TRIGGERS
-- ===================================================

\echo '4. Criando triggers...'

\ir ../database/triggers/auditoria_status_ordem_servico.sql
\ir ../database/triggers/auditoria_tecnico_ordem_servico.sql


-- ===================================================
-- 5. VIEWS
-- ===================================================

\echo '5. Criando views...'

-- Views analíticas de BI serão adicionadas aqui.
-- \ir ../database/views/nome_view.sql


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