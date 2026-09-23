# Mapeamento dos campos ENUM

Este documento mapeia os 12 campos `INTEGER` informados para os enums.

```text
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

- local_endereco.tipo_local_endereco:
  1 = Sala de Aula
  2 = Laboratório
  3 = Depto. Administrativo
  4 = Auditório
  5 = Almoxarifado
  6 = Área Comum

- problema.status:
  0 = Pendente
  1 = Aprovado
  2 = Reprovado

- observacao_conclusao.dificuldade:
  1 = Fácil
  2 = Médio
  3 = Difícil

- ocorrencia.prioridade:
  Não há enum correspondente implementado na API. O esquema apenas restringe o valor ao intervalo de 0 a 2, sem nomear os códigos.

- ordem_servico.prioridade:
  Não há enum correspondente implementado na API. O esquema apenas restringe o valor ao intervalo de 0 a 2, sem nomear os códigos.

```

## Resumo do mapeamento

| Campo | Enum da API | Resultado |
| --- | --- | --- |
| `instituicao.tipo_instituicao` | `TipoInstituicao` | Mapeado. |
| `contrato.status` | — | Sem enum. |
| `pagamento.status` | — | Sem enum. |
| `pagamento.metodo_pagamento` | — | Sem enum. |
| `usuario.tipo_acesso` | `TipoAcesso` | Mapeado. |
| `aptidao.categoria_problema` | `CategoriaProblema` | Mapeado. |
| `local_endereco.tipo_local_endereco` | `TipoLocalEndereco` | Mapeado. |
| `problema.status` | `StatusProblema` | Mapeado. |
| `ocorrencia.categoria_problema` | `CategoriaProblema` | Mapeado. |
| `ocorrencia.prioridade` | — | Sem enum; `CHECK` aceita 0 a 2. |
| `ordem_servico.categoria_problema` | `CategoriaProblema` | Mapeado. |
| `ordem_servico.prioridade` | — | Sem enum; `CHECK` aceita 0 a 2. |