\set ON_ERROR_STOP on

\echo '=============================='
\echo 'CRIANDO BANCO FIXA'
\echo '=============================='


\echo '1. Criando tabelas...'

\ir ../database/tabelas/super_admin.sql
\ir ../database/tabelas/instituicao.sql
\ir ../database/tabelas/endereco.sql

\ir ../database/tabelas/plano.sql
\ir ../database/tabelas/contrato.sql
\ir ../database/tabelas/pagamento.sql

\ir ../database/tabelas/usuario.sql
\ir ../database/tabelas/aptidao.sql
\ir ../database/tabelas/feedback.sql

\ir ../database/tabelas/local_endereco.sql
\ir ../database/tabelas/evento.sql

\ir ../database/tabelas/categoria_equipamento.sql
\ir ../database/tabelas/marca_equipamento.sql
\ir ../database/tabelas/modelo_equipamento.sql
\ir ../database/tabelas/equipamento.sql

\ir ../database/tabelas/problema.sql
\ir ../database/tabelas/ocorrencia.sql

\ir ../database/tabelas/status_ordem_servico.sql
\ir ../database/tabelas/ordem_servico.sql
\ir ../database/tabelas/ordem_servico_status_historico.sql

\ir ../database/tabelas/tarefa.sql
\ir ../database/tabelas/tarefa_status_historico.sql

\ir ../database/tabelas/observacao_conclusao.sql
\ir ../database/tabelas/foto.sql

\ir ../database/tabelas/turno.sql
\ir ../database/tabelas/turno_usuario.sql


\echo '2. Criando funcoes...'

\ir ../database/funcoes/criar_ordem_servico_ao_aprovar_problema.sql


\echo '3. Criando procedures...'

-- \ir


\echo '4. Criando triggers...'

-- \ir


\echo '5. Criando views...'

-- \ir


\echo '6. Criando indices...'

-- \ir


\echo '7. Carregando dados iniciais...'

\ir ../database/seeds/data_load_fixa.sql


\echo '=============================='
\echo 'BANCO CRIADO COM SUCESSO'
\echo '=============================='