/**
 * Trigger: trg_atualizar_data_atualizacao
 *
 * Descrição:
 * Atualiza data_atualizacao com NOW() em cada registro afetado por UPDATE.
 * Uma função compartilhada atende uma trigger BEFORE UPDATE por tabela.
 * O DEFAULT NOW() das colunas continua responsável pelos INSERTs.
 *
 * Dependências:
 * - problema
 * - ocorrencia
 * - ordem_servico
 * - tarefa
 * - observacao_conclusao
 * - evento
 * - equipamento
 * - modelo_equipamento
 * - categoria_equipamento
 * - marca_equipamento
 * - local_unidade
 * - usuario
 */

CREATE OR REPLACE FUNCTION public.atualizar_data_atualizacao()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.data_atualizacao := NOW();
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.problema
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.ocorrencia
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.ordem_servico
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.tarefa
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.observacao_conclusao
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.evento
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.equipamento
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.modelo_equipamento
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.categoria_equipamento
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.marca_equipamento
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.local_unidade
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();

CREATE OR REPLACE TRIGGER trg_atualizar_data_atualizacao
BEFORE UPDATE ON public.usuario
FOR EACH ROW
EXECUTE FUNCTION public.atualizar_data_atualizacao();
