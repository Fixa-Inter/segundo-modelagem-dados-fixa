/*
 * Marca o problema como concluído (3) quando sua OS passa para finalizada (4).
 * Dependências: public.ordem_servico e public.problema.
 */
CREATE OR REPLACE FUNCTION public.atualizar_problema_conclusao_os()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE public.problema
    SET status = 3
    WHERE id = NEW.problema_id
    AND status IS DISTINCT FROM 3;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_atualizar_problema_conclusao_os
AFTER UPDATE OF status_ordem_servico ON public.ordem_servico
FOR EACH ROW
WHEN (
    NEW.status_ordem_servico = 4
    AND OLD.status_ordem_servico IS DISTINCT FROM NEW.status_ordem_servico
)
EXECUTE FUNCTION public.atualizar_problema_conclusao_os();