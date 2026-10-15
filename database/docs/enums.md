# Mapeamento dos valores fixos e ENUM

- instituicao.tipo_instituicao:
  1 = Escola
  2 = Faculdade
  3 = Empresa
  4 = Órgão Público

- contrato.status:
  1 = Ativo
  2 = Inativo
  3 = Cancelado

- pagamento.status:
  1 = Pendente
  2 = Aprovado
  3 = Rejeitado

- pagamento.metodo_pagamento:
  1 = Crédito
  2 = Débito
  3 = Pix

- usuario.tipo_acesso:
  1 = Administrador
  2 = Gestor
  3 = Técnico
  4 = Solicitante

- aptidao.categoria_problema, ocorrencia.categoria_problema e ordem_servico.categoria_problema:
  1 = Elétrica
  2 = Hidráulica
  3 = Mecânica
  4 = Informática
  5 = Mobiliário
  6 = Climatização
  7 = Rede e Conectividade
  8 = Segurança
  9 = Iluminação
  10 = Limpeza e Conservação

- local_unidade.tipo_local_unidade:
  1 = Sala de Aula
  2 = Laboratório
  3 = Depto. Administrativo
  4 = Auditório
  5 = Almoxarifado
  6 = Área Comum

- problema.status:
  0 = Pendente
  1 = Reprovado
  2 = Aprovado

- observacao_conclusao.dificuldade:
  1 = Fácil
  2 = Médio
  3 = Difícil

- ocorrencia.prioridade:
  0 = Alta
  1 = Média
  2 = Baixa

- ordem_servico.prioridade:
  0 = Alta
  1 = Média
  2 = Baixa

- ordem_servico.status_ordem_servico e tarefa.status_ordem_servico (independentes):
  0 = Não iniciadas
  1 = Atrasada
  2 = Pausada
  3 = Em Andamento
  4 = Finalizadas