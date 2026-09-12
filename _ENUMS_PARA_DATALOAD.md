# Mapeamento dos campos ENUM para o prompt do dataload

Este documento mapeia os 12 campos `INTEGER` informados para os enums
encontrados nas duas APIs. Onde não existe enum no código, nenhum valor é
definido por suposição.

## Trecho pronto para o prompt

```text
Use obrigatoriamente os seguintes códigos de enum, conforme implementados na API:

- instituicao.tipo_instituicao:
  1 = Escola
  2 = Faculdade
  3 = Empresa
  4 = Órgão Público

- contrato.status:
  Não há enum correspondente implementado na API. Defina os valores antes de gerar a carga.

- pagamento.status:
  Não há enum correspondente implementado na API. Defina os valores antes de gerar a carga.

- pagamento.metodo_pagamento:
  Não há enum correspondente implementado na API. Defina os valores antes de gerar a carga.

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
  1 = Reprovado
  2 = Aprovado

- ocorrencia.prioridade:
  Não há enum correspondente implementado na API. O esquema apenas restringe o valor ao intervalo de 0 a 2, sem nomear os códigos.

- ordem_servico.prioridade:
  Não há enum correspondente implementado na API. O esquema apenas restringe o valor ao intervalo de 0 a 2, sem nomear os códigos.

Não use outros códigos ou descrições para os campos mapeados.
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

## Origem da varredura

- `segundo-api-app`: `TipoAcesso`.
- `segundo-api-fixa`: `TipoAcesso`, `TipoInstituicao`, `StatusProblema`,
  `TipoLocalEndereco` e `CategoriaProblema`.

`TipoAcesso` aparece nas duas APIs com os mesmos valores. Não foram encontrados
enums para `contrato.status`, `pagamento.status`, `pagamento.metodo_pagamento`
ou as prioridades.
