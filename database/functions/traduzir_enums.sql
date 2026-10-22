/**
 * Funções: tradução dos enums numéricos para seus nomes em português.
 *
 * Recebem o código INTEGER e retornam TEXT.
 * NULL e códigos fora do domínio retornam NULL.
 * Não consultam nem alteram tabelas.
 */

-- instituicao.tipo_instituicao
CREATE OR REPLACE FUNCTION public.traduzir_tipo_instituicao(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 1 THEN 'Escola'
        WHEN 2 THEN 'Faculdade'
        WHEN 3 THEN 'Empresa'
        WHEN 4 THEN 'Órgão Público'
        ELSE NULL
    END;
$$;

-- contrato.status
CREATE OR REPLACE FUNCTION public.traduzir_status_contrato(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 1 THEN 'Ativo'
        WHEN 2 THEN 'Inativo'
        WHEN 3 THEN 'Cancelado'
        ELSE NULL
    END;
$$;

-- pagamento.status
CREATE OR REPLACE FUNCTION public.traduzir_status_pagamento(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 1 THEN 'Pendente'
        WHEN 2 THEN 'Aprovado'
        WHEN 3 THEN 'Rejeitado'
        ELSE NULL
    END;
$$;

-- pagamento.metodo_pagamento
CREATE OR REPLACE FUNCTION public.traduzir_metodo_pagamento(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 1 THEN 'Crédito'
        WHEN 2 THEN 'Débito'
        WHEN 3 THEN 'Pix'
        ELSE NULL
    END;
$$;

-- usuario.tipo_acesso
CREATE OR REPLACE FUNCTION public.traduzir_tipo_acesso(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 1 THEN 'Administrador'
        WHEN 2 THEN 'Gestor'
        WHEN 3 THEN 'Técnico'
        WHEN 4 THEN 'Solicitante'
        ELSE NULL
    END;
$$;

-- aptidao, ocorrencia e ordem_servico: categoria_problema
CREATE OR REPLACE FUNCTION public.traduzir_categoria_problema(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 1 THEN 'Elétrica'
        WHEN 2 THEN 'Hidráulica'
        WHEN 3 THEN 'Mecânica'
        WHEN 4 THEN 'Informática'
        WHEN 5 THEN 'Mobiliário'
        WHEN 6 THEN 'Climatização'
        WHEN 7 THEN 'Rede e Conectividade'
        WHEN 8 THEN 'Segurança'
        WHEN 9 THEN 'Iluminação'
        WHEN 10 THEN 'Limpeza e Conservação'
        ELSE NULL
    END;
$$;

-- local_unidade.tipo_local_unidade
CREATE OR REPLACE FUNCTION public.traduzir_tipo_local_unidade(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 1 THEN 'Sala de Aula'
        WHEN 2 THEN 'Laboratório'
        WHEN 3 THEN 'Depto. Administrativo'
        WHEN 4 THEN 'Auditório'
        WHEN 5 THEN 'Almoxarifado'
        WHEN 6 THEN 'Área Comum'
        ELSE NULL
    END;
$$;

-- problema.status (mesmos códigos da API)
CREATE OR REPLACE FUNCTION public.traduzir_status_problema(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 0 THEN 'Pendente'
        WHEN 1 THEN 'Reprovado'
        WHEN 2 THEN 'Aprovado'
        WHEN 3 THEN 'Concluído'
        ELSE NULL
    END;
$$;

-- observacao_conclusao.dificuldade
CREATE OR REPLACE FUNCTION public.traduzir_dificuldade(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 1 THEN 'Fácil'
        WHEN 2 THEN 'Médio'
        WHEN 3 THEN 'Difícil'
        ELSE NULL
    END;
$$;

-- ocorrencia.prioridade e ordem_servico.prioridade
CREATE OR REPLACE FUNCTION public.traduzir_prioridade(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 0 THEN 'Alta'
        WHEN 1 THEN 'Média'
        WHEN 2 THEN 'Baixa'
        ELSE NULL
    END;
$$;

-- ordem_servico, tarefa e auditoria: status da ordem de serviço
CREATE OR REPLACE FUNCTION public.traduzir_status_ordem_servico(p_codigo INTEGER)
RETURNS TEXT
LANGUAGE sql
IMMUTABLE
STRICT
PARALLEL SAFE
AS $$
    SELECT CASE p_codigo
        WHEN 0 THEN 'Não iniciadas'
        WHEN 1 THEN 'Atrasada'
        WHEN 2 THEN 'Pausada'
        WHEN 3 THEN 'Em Andamento'
        WHEN 4 THEN 'Finalizadas'
        ELSE NULL
    END;
$$;
