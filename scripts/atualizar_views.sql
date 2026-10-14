\set ON_ERROR_STOP on

BEGIN;

DROP VIEW IF EXISTS fato_ordem_servico;
DROP VIEW IF EXISTS fato_problema;
DROP VIEW IF EXISTS fato_ocorrencia;

DROP VIEW IF EXISTS dim_tempo;
DROP VIEW IF EXISTS dim_tecnico;
DROP VIEW IF EXISTS dim_categoria_problema;
DROP VIEW IF EXISTS dim_categoria_equipamento;
DROP VIEW IF EXISTS dim_local;
DROP VIEW IF EXISTS dim_unidade;
DROP VIEW IF EXISTS dim_instituicao;
DROP VIEW IF EXISTS dim_status_ordem_servico;
DROP VIEW IF EXISTS dim_status_problema;

\ir ../database/views/dim_tempo.sql
\ir ../database/views/dim_tecnico.sql
\ir ../database/views/dim_categoria_problema.sql
\ir ../database/views/dim_categoria_equipamento.sql
\ir ../database/views/dim_instituicao.sql
\ir ../database/views/dim_unidade.sql
\ir ../database/views/dim_local.sql
\ir ../database/views/dim_status_ordem_servico.sql
\ir ../database/views/dim_status_problema.sql

\ir ../database/views/fato_ordem_servico.sql
\ir ../database/views/fato_problema.sql
\ir ../database/views/fato_ocorrencia.sql

COMMIT;