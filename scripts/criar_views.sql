\set ON_ERROR_STOP on
\encoding UTF8

-- ===================================================
-- 5. VIEWS
-- ===================================================

\echo 'Criando views...'

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

\echo 'Views criadas com sucesso!'