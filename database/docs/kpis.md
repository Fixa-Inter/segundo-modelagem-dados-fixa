# KPIs de Business Intelligence — FIXA

## Objetivo

Os indicadores de Business Intelligence descrevem a demanda e o atendimento de manutenção do FIXA, desde o registro e a análise das solicitações até a execução das ordens de serviço e os registros de ocorrências resolvidas diretamente. A análise apoia a identificação de concentração de demanda, pendências, atrasos, cumprimento de prazos e repetição de solicitações por local e categoria.

O dashboard utiliza os dados da aplicação expostos pela camada dimensional. Cards apresentam totais, taxas e tempos; gráficos de barras comparam unidades, locais, categorias e técnicos; linhas mostram a evolução temporal; histogramas e boxplots descrevem a distribuição dos tempos. Mapas dependem da localização disponível e validada. Os filtros abrangem período e atributos presentes em cada fato.

O relatório gerencial contextualiza a base, o problema de gestão, o tratamento dos dados e a interpretação dos KPIs. Desvios em relação a metas dependem de referências de negócio formalizadas.

## Fontes e escopo

O catálogo contém 37 indicadores: 15 de OS, 11 de solicitações, 10 de ocorrências e a taxa de recorrência das solicitações.

| Fato | Unidade de análise |
|---|---|
| `fato_ordem_servico` | Uma OS com seu estado atual e resumos de auditoria. |
| `fato_problema` | Uma solicitação registrada como problema. |
| `fato_ocorrencia` | Uma situação registrada como resolvida diretamente. |

Tempo, técnico, unidade, instituição, local, categorias e status fornecem os recortes dimensionais, conforme os vínculos disponíveis em cada fato.

## Regras gerais

- **Período:** intervalos `[início, fim)`. Volumes de entrada e estados das solicitações usam a data de criação; conclusões, resolução e produtividade usam a data de conclusão.
- **População de OS:** médias de espera, pausa e tarefas e taxas de reabertura e reatribuição usam as OS criadas no período. Abertas e carga ativa representam a situação atual, incluindo OS antigas ainda abertas.
- **Status:** OS abertas são 1 (Atrasada), 2 (Pausada) e 3 (Em Andamento); finalizadas são 4. Solicitações: 0 Pendente, 1 Reprovado e 2 Aprovado. Prioridades: 0 Alta, 1 Média e 2 Baixa.
- **Atraso:** OS atrasadas e taxa de atraso usam o status 1. A flag `esta_atrasada` verifica prazo vencido entre abertas e representa outro conceito.
- **Percentuais e nulos:** denominador zero resulta em “Sem base para cálculo”. Médias excluem tempos desconhecidos ou inválidos. Contagens sem registros são zero; tempo desconhecido não equivale a zero.
- **Agregação:** taxas consolidadas usam a soma dos numeradores dividida pela soma dos denominadores. OS e sua solicitação não representam duas demandas independentes.
- **Recorrência:** a população é de episódios iniciados no período, com consulta ao histórico anterior. Os demais volumes continuam contando todos os registros originais.

## Ordens de serviço — fato_ordem_servico

| KPI | Regra | Descrição |
|---|---|---|
| Total de OS | Contar OS criadas no período. | Volume de atendimentos gerados. |
| OS abertas | Contar status 1, 2 ou 3. | OS atrasadas, pausadas ou em andamento. |
| OS atrasadas | Contar status 1. | OS classificadas como Atrasada. |
| Taxa de atraso | Atrasadas ÷ abertas × 100. | Participação das atrasadas entre as abertas. |
| OS finalizadas | Contar finalizadas com conclusão no período. | Atendimentos atualmente encerrados no período. |
| Taxa de conclusão no prazo | No prazo ÷ finalizadas com datas válidas × 100. | Cumprimento dos prazos documentados. |
| Tempo médio de espera | Média de início − criação, com datas válidas. | Espera até o primeiro início registrado. |
| Tempo médio de resolução | Média de `tempo_resolucao_minutos` válido. | Duração calculada, descontando pausas registradas. |
| Tempo médio pausado | Média de `tempo_pausado_minutos`, incluindo zeros. | Pausa registrada média por OS. |
| Taxa de reabertura | OS reabertas ao menos uma vez ÷ total × 100. | OS que retornaram ao atendimento após finalizar. |
| Taxa de reatribuição | OS com troca de técnico ÷ total × 100. | Frequência de mudança do responsável. |
| Carga ativa por técnico | Contar abertas por técnico atual. | Distribuição dos atendimentos abertos. |
| Produtividade por técnico | Contar finalizadas no período por técnico atual. | Conclusões atribuídas a cada responsável. |
| Média de tarefas por OS | Média de `qtd_tarefas`. | Quantidade média de tarefas vinculadas. |
| Taxa de tarefas concluídas | Concluídas ÷ total de tarefas × 100; falta contagem na view. | Percentual de tarefas finalizadas. |

## Solicitações — fato_problema

Aprovação, reprovação e conversão representam o estado atual das solicitações criadas no período. As taxas de aprovação e reprovação incluem pendentes no denominador.

| KPI | Regra | Descrição |
|---|---|---|
| Total de solicitações | Contar problemas criados no período. | Volume de demanda registrada. |
| Solicitações pendentes | Contar status 0. | Demanda aguardando decisão de análise. |
| Solicitações aprovadas | Contar status 2. | Demanda aceita na análise. |
| Solicitações reprovadas | Contar status 1. | Demanda recusada na análise. |
| Taxa de aprovação | Aprovadas ÷ total de solicitações × 100. | Participação das aprovações, incluindo pendentes na base. |
| Taxa de reprovação | Reprovadas ÷ total de solicitações × 100. | Participação das reprovações, incluindo pendentes na base. |
| Taxa de conversão em OS | Solicitações com OS ÷ total × 100. | Demanda que originou ordem de serviço. |
| Solicitações por unidade | Contar por `unidade_id`. | Distribuição da demanda entre unidades. |
| Solicitações por local | Contar por `local_id`. | Ambientes com maior volume de demanda. |
| Solicitações por categoria de equipamento | Contar por `categoria_equipamento_id`. | Categorias mais citadas nas solicitações. |
| Solicitações por período | Contar por dia, mês ou ano de criação. | Evolução temporal da demanda. |
| Taxa de recorrência por local e categoria | Consolidar episódios de 24h; recorrente se sucede outro em até 30 dias. Recorrentes ÷ episódios × 100. | Repetição de demanda por local e categoria, sem inflar por solicitações do mesmo episódio. |

### Recorrência por episódios

A chave de agrupamento é `local_id + categoria_equipamento_id`. As solicitações são ordenadas por `data_criacao` e `problema_id`. O primeiro registro inicia um episódio que abrange o intervalo `[início, início + 24h)`; o primeiro registro fora dele inicia o episódio seguinte. A janela é fixa e não se renova a cada solicitação.

Um episódio é recorrente quando seu início ocorre depois e até 30 dias após o início do episódio anterior da mesma chave. A taxa corresponde ao percentual de episódios recorrentes entre todos os episódios iniciados no período. A formação dos episódios e a identificação do predecessor consideram o histórico anterior ao filtro temporal.

As janelas de 24h e 30 dias são parâmetros iniciais sujeitos a validação. A taxa depende de uma consolidação analítica dos registros da `fato_problema`; OS e ocorrências não integram sua população. Repetição de demanda não comprova duplicidade, reincidência da mesma falha ou defeito no mesmo equipamento.

## Ocorrências — fato_ocorrencia

As métricas usam a data de criação do registro. A atividade cadastral não representa serviço ainda aberto.

| KPI | Regra | Descrição |
|---|---|---|
| Total de ocorrências | Contar ocorrências criadas no período. | Volume de situações registradas como resolvidas diretamente. |
| Ocorrências por técnico | Contar por `tecnico_id`. | Distribuição dos registros entre técnicos. |
| Ocorrências por unidade | Contar por `unidade_id`. | Unidades com mais registros de resolução direta. |
| Ocorrências por local | Contar por `local_id`. | Ambientes com maior volume de ocorrências. |
| Ocorrências por categoria de problema | Contar por `categoria_problema_id`. | Natureza dos problemas atendidos. |
| Ocorrências por categoria de equipamento | Contar por `categoria_equipamento_id`. | Categorias de equipamentos associadas aos registros. |
| Ocorrências por prioridade | Contar por `prioridade`. | Distribuição entre Alta, Média e Baixa. |
| Ocorrências ativas | Contar `esta_ativo = true`. | Registros ativos no cadastro, não serviços abertos. |
| Taxa de alta prioridade | Ocorrências com prioridade 0 ÷ total × 100. | Participação das situações de alta prioridade. |
| Ocorrências por período | Contar por dia, mês ou ano de criação. | Evolução dos registros de resolução direta. |

## Limitações de interpretação

- Os tempos dependem da auditoria. A resolução usa primeiro início e última conclusão, descontando pausas registradas; reaberturas podem incluir intervalos em que a OS esteve finalizada. Os valores não representam trabalho efetivo.
- A média pausada inclui zeros da view, que indicam ausência de pausa registrada e não comprovam histórico completo. Na espera, OS sem início conhecido ficam fora da média.
- Conclusões sem datas válidas ficam fora das análises por data de conclusão e de cumprimento do prazo. A atribuição por técnico considera o responsável atual.
- A quantidade de tarefas concluídas ainda não é exposta na fato. A contagem atual de tarefas inclui inativas; a taxa requer tratamento consistente desse filtro. No consolidado, a razão entre somas representa o percentual de tarefas, não a média dos percentuais por OS.
- As fatos refletem o estado atual e resumos históricos. Não permitem reconstruir integralmente filas passadas, todas as transições de finalização ou o responsável em cada instante.
- Concentração de registros pode refletir tamanho da unidade, quantidade de equipamentos ou adesão ao sistema. Volume, aprovação ou produtividade isolados não comprovam qualidade de atendimento.
- Relações entre fatos detalhadas somente por local, unidade ou data podem multiplicar registros. As comparações utilizam agregações na granularidade de cada fato.