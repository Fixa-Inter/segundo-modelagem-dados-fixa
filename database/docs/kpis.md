# Catálogo de KPIs do banco dimensional FIXA

Data de referência: 17/10/2026.

## 1. Objetivo e alinhamento à solicitação de BI

Este catálogo define os indicadores que orientarão a construção do dashboard e do relatório gerencial de Business Intelligence do projeto FIXA. O objetivo é transformar os dados gerados pelo uso da aplicação em informações organizadas sobre o fluxo de manutenção: o registro das solicitações, sua análise, o encaminhamento para ordens de serviço, o acompanhamento da execução e os registros de ocorrências resolvidas diretamente pelos técnicos.

A análise deve permitir que gestores identifiquem onde a demanda está concentrada, acompanhem a evolução dos registros, reconheçam solicitações pendentes, observem atrasos e prazos de conclusão e comparem a distribuição dos atendimentos entre unidades, locais, categorias e técnicos. A taxa de recorrência complementa esse acompanhamento ao identificar novos episódios de demanda próximos aos anteriores, sem tratar cada solicitação feita durante o mesmo episódio como uma recorrência independente.

Os indicadores devem apoiar decisões de priorização e acompanhamento da operação. Contagens e taxas precisam ser interpretadas considerando o perfil da demanda, a qualidade do histórico e os critérios de cada cálculo; um resultado maior ou menor, isoladamente, não comprova melhor desempenho.

### 1.1 Aplicação na entrega de Business Intelligence

A seção de Business Intelligence do documento de requisitos, nas páginas 10 e 11, solicita um dashboard conectado aos dados produzidos pela aplicação e um relatório gerencial que apresente a base, o problema analisado, o tratamento dos dados e os KPIs. O catálogo orienta a seleção das medidas e visualizações dessa entrega:

| Elemento solicitado | Aplicação aos dados e indicadores do FIXA |
|---|---|
| Conectividade com dados | Conectar a ferramenta de BI à camada dimensional que expõe os dados produzidos pela aplicação. A análise deve preservar a granularidade de cada fato e os relacionamentos com suas dimensões. |
| Gráficos de barras | Comparar o volume de OS, solicitações e ocorrências por status, unidade, local, técnico ou categoria, respeitando os campos disponíveis em cada fato. |
| Gráficos de linhas | Mostrar a evolução temporal dos registros e das conclusões, usando a data correspondente ao evento analisado. |
| Cards de KPIs e desvios | Apresentar totais, taxas e tempos definidos neste catálogo. Desvios em relação a metas só devem ser exibidos quando houver uma referência de negócio definida; este documento não inventa metas. |
| Histogramas e boxplots | Explorar a distribuição dos tempos de espera, resolução e pausas já disponíveis, evidenciando dispersão e valores extremos com as ressalvas de histórico. |
| Mapas, quando aplicáveis | Analisar a distribuição geográfica usando cidade e estado da dimensão de unidades, desde que a localização seja reconhecida e validada pela ferramenta. Não pressupor coordenadas inexistentes. |
| Filtros interativos | Permitir recortes por período, unidade, local, técnico, categoria, prioridade e status quando esses atributos estiverem disponíveis na fato analisada. |
| Relatório gerencial | Explicar a base utilizada, a questão gerencial, as estratégias de tratamento, as fórmulas dos KPIs e os limites que afetam sua interpretação. |

Se a entrega incluir o extra de jobs e pipelines, os requisitos também pedem tratamento e cálculo no Databricks, geração de uma base final usada pelo dashboard e evidências de execução do job. O catálogo fornece as definições das medidas; o fluxo do pipeline e sua comprovação precisam de documentação própria.

### 1.2 Escopo dos indicadores

O catálogo mantém os **36 indicadores básicos** já discutidos: 15 de ordens de serviço, 11 de solicitações registradas como problemas e 10 de ocorrências. O único indicador acrescentado é a **taxa de recorrência de demanda por local e categoria**, calculada por episódios sobre as solicitações.

No contexto deste documento, “solicitação” corresponde ao registro da `fato_problema`. Uma OS representa o encaminhamento e acompanhamento de uma dessas solicitações; não deve ser somada a ela como se fosse uma nova demanda.

A recorrência usa a consolidação em episódios descrita na seção 5. Essa consolidação modifica apenas a unidade de análise da taxa de recorrência. Os indicadores de volume continuam contando todas as solicitações originais.

É uma especificação para consultas SQL e medidas de BI. A presença de uma fórmula não significa que a medida já foi implementada. A disponibilidade foi verificada nos scripts do repositório, sem consultar o banco em funcionamento.

### 1.3 Situações de disponibilidade

| Situação | Significado |
|---|---|
| Disponível | Os campos necessários estão nas fatos e dimensões atuais; falta criar a consulta ou medida caso ela ainda não exista no BI. |
| Disponível com ressalva | Há campos suficientes, mas existem limitações de histórico, atribuição ou interpretação. |
| Regra pendente | Os dados existem, mas a definição de negócio ou um parâmetro precisa ser validado. |
| Ajuste na view | O dado já existe no banco operacional, mas não é exposto no dimensional. |

A especificação distingue o comportamento atual das views das convenções propostas. Ela não altera automaticamente o SQL existente.

## 2. Fontes e granularidade

| Fonte | Uma linha representa | Identificador |
|---|---|---|
| `fato_ordem_servico` | Uma OS, com estado atual e resumos de seu histórico | `ordem_servico_id` |
| `fato_problema` | Um problema registrado | `problema_id` |
| `fato_ocorrencia` | Uma ocorrência registrada como resolvida diretamente | `ocorrencia_id` |

Dimensões disponíveis: `dim_tempo`, `dim_tecnico`, `dim_unidade`, `dim_instituicao`, `dim_local`, `dim_categoria_problema`, `dim_categoria_equipamento`, `dim_status_problema` e `dim_status_ordem_servico`.

Neste documento:

- `OS` significa `fato_ordem_servico`.
- `P` significa `fato_problema`.
- `O` significa `fato_ocorrencia`.
- `T` é o instante de referência da consulta.
- `N(condição)` é a quantidade de registros que atendem à condição, dentro da população especificada.
- `N(total)` é a quantidade total de registros da mesma população.
- Tempos são medidos em minutos corridos; horas e dias são conversões para apresentação. Não representam horas úteis nem horas efetivamente trabalhadas.

## 3. Convenções gerais de cálculo

### 3.1 Status e prioridade

| Domínio | Códigos |
|---|---|
| OS e tarefa | `0 = Não iniciadas; 1 = Atrasada; 2 = Pausada; 3 = Em Andamento; 4 = Finalizadas` |
| Problema | `0 = Pendente; 1 = Reprovado; 2 = Aprovado` |
| Prioridade | `0 = Alta; 1 = Média; 2 = Baixa` |

As categorias de problema e de equipamento são dimensões diferentes. Não devem ser tratadas como intercambiáveis.

### 3.2 OS abertas e atraso

Para este catálogo, a convenção proposta para **OS abertas** é `status_id IN (1, 2, 3)`, igual ao campo atual `esta_aberta`. A lista original mencionava somente andamento e pausa; a inclusão de Atrasada precisa ser preservada explicitamente na definição publicada.

Distinguir os dois conceitos abaixo ao calcular OS-03 e OS-04:

| Medida | Condição |
|---|---|
| OS com status Atrasada | `status_id = 1` |
| OS abertas com prazo vencido | `esta_atrasada = true`: status em `1, 2, 3` e `data_prevista < T` |

Uma OS pode estar pausada e com prazo vencido. Outra pode ter status Atrasada, mesmo que o prazo cadastrado não esteja vencido. Não usar esses conceitos como sinônimos.

### 3.3 Períodos e população

- Usar intervalos semiabertos: `[início, fim)`. O instante inicial entra; o final não.
- Volume de entrada usa `data_criacao`.
- Conclusões e produtividade no período usam `data_conclusao` e exigem estado atual finalizado.
- OS abertas e carga ativa são fotografias em `T`; não aplicar um filtro de criação que remova OS antigas ainda abertas, a menos que a análise seja explicitamente por coorte.
- Aprovação, reprovação e conversão de problemas medem o estado atual dos problemas criados na coorte selecionada. Não há data de aprovação/reprovação nas fatos para contar essas decisões no momento em que aconteceram.
- Indicadores de reabertura e reatribuição da lista básica usam uma coorte de criação de OS e o histórico acumulado até `T`. Não representam somente mudanças ocorridas dentro do período filtrado.
- Usar o horário de referência de negócio, `America/Sao_Paulo`, de maneira consistente. Os scripts usam `TIMESTAMP` sem fuso; não presumir que os valores estejam em UTC.
- Uma janela de 24 horas representa duração transcorrida, não mudança de dia no calendário.

### 3.4 Nulos, zero e agregações

- Divisão por zero retorna `NULL`, apresentado como “Sem base para cálculo”.
- Contagens sem eventos retornam zero.
- Médias desconsideram valores desconhecidos ou cronologicamente inválidos e devem informar a quantidade de observações válidas.
- Não transformar um tempo desconhecido em zero.
- Não calcular a taxa consolidada como média simples das taxas dos grupos. Somar os numeradores e denominadores e depois dividir.
- `COUNT(campo_booleano)` conta valores verdadeiros e falsos não nulos. Para contar uma condição, usar `COUNT(*) FILTER (WHERE condição)` ou expressão equivalente.
- Os KPIs básicos não aplicam exclusão por `esta_ativo` implicitamente. Qualquer filtro de atividade deve ser explícito. A fato de OS e a de problemas não expõem esse campo.
- A consolidação em episódios aplica-se às métricas de recorrência. Não substitui a contagem bruta nos indicadores de volume.

### 3.5 Relacionamentos e comparações

- Contar cada fato em sua granularidade original.
- Relacionar P e OS por `problema_id` para análises do atendimento do mesmo problema.
- Não juntar fatos detalhadas somente por unidade, local ou data: isso pode multiplicar linhas e inflar contagens.
- Comparações entre problemas e ocorrências devem agregar cada fato primeiro, ou reunir os registros com `UNION ALL` e uma coluna de origem.
- Não somar OS ao total de problemas para representar solicitações distintas: a OS decorre de um problema já contado.
- As dimensões refletem os cadastros atuais. Não existe versionamento dimensional para reconstruir cargo, unidade ou atividade do técnico no passado.
- Volume por local ou unidade não é taxa de falhas por equipamento instalado. Não há denominador de exposição no dimensional, como quantidade de equipamentos ou usuários atendidos.

## 4. KPIs básicos

### 4.1 Ordem de serviço — 15 indicadores

Base principal: `fato_ordem_servico`.

| ID | KPI | Fórmula / regra | Unidade | Situação |
|---|---|---|---|---|
| OS-01 | Total de OS | `N(total)`, por criação no período | OS | Disponível |
| OS-02 | OS abertas | `N(esta_aberta = true)`, fotografia em T | OS | Disponível; convenção de status na seção 3.2 |
| OS-03 | OS atrasadas por status | `N(status_id = 1)`, fotografia em T | OS | Disponível; diferente de prazo vencido |
| OS-04 | Taxa de atraso por status | `100 × N(status_id = 1) / N(esta_aberta = true)` | % | Regra de abertas precisa seguir a seção 3.2 |
| OS-05 | OS finalizadas | `N(finalizada = true)`, por conclusão no período | OS | Disponível com ressalva temporal |
| OS-06 | Taxa de conclusão no prazo entre conclusões documentadas | `100 × N(concluida_no_prazo = true, dentro da população elegível) / N(finalizadas com conclusão válida no período)` | % | Disponível com ressalva; divulgar cobertura do histórico |
| OS-07 | Tempo médio de espera | Média de `tempo_espera_minutos` válido entre OS criadas no período que possuem início conhecido | Minutos | Disponível com ressalva |
| OS-08 | Tempo médio de resolução calculado pela view | Média de `tempo_resolucao_minutos` válido entre OS finalizadas no período | Minutos | Disponível com ressalva; não equivale a trabalho efetivo |
| OS-09 | Tempo médio pausado registrado | Média de `tempo_pausado_minutos` na coorte de criação selecionada, incluindo zeros conforme a view | Minutos | Disponível com ressalva; ausência de auditoria não prova ausência de pausa |
| OS-10 | Taxa de reabertura | `100 × N(foi_reaberta = true) / N(total)` na mesma coorte de criação | % | Disponível; histórico acumulado |
| OS-11 | Taxa de reatribuição | `100 × N(foi_reatribuida = true) / N(total)` na mesma coorte de criação | % | Disponível; histórico acumulado |
| OS-12 | Carga ativa por técnico | `N(esta_aberta = true)` por `tecnico_id` em T | OS/técnico | Disponível; não mede capacidade nem horas disponíveis |
| OS-13 | Produtividade por técnico | `N(finalizada = true)` por `tecnico_id` e conclusão no período | OS/técnico | Disponível com ressalva de atribuição |
| OS-14 | Média de tarefas por OS | Média de `qtd_tarefas` nas OS da coorte de criação selecionada | Tarefas/OS | Disponível; conta tarefas vinculadas, inclusive inativas |
| OS-15 | Taxa de tarefas concluídas | Por OS: `100 × qtd_tarefas_concluidas / qtd_tarefas` | % | Ajuste na view: falta `qtd_tarefas_concluidas` |

Observações específicas:

- OS-05 pode contar finalizadas sem conclusão conhecida em uma fotografia atual, mas essas linhas não podem ser posicionadas corretamente em um período de conclusão.
- OS-06 usa um denominador observável. Tratar finalizadas sem data como atrasadas seria uma inferência sem evidência. Ao apresentar a taxa, informar quantas OS finalizadas ficaram fora do cálculo por ausência de uma conclusão válida.
- OS-07 ignora OS que ainda não iniciaram. Isoladamente, pode melhorar enquanto a fila envelhece; verificar também os registros que permanecem sem início conhecido.
- OS-08 usa primeiro início e última finalização, descontando pausas registradas. Em OS reabertas, pode incluir o intervalo em que a OS esteve finalizada. Pausas anteriores ao primeiro início também exigem validação. O valor não é uma medição confiável de esforço efetivo.
- OS-09 permite uma variante “média entre OS com pausa registrada”, filtrando valores maiores que zero. Essa variante deve ter nome e denominador próprios.
- OS-10 conta OS que reabriram ao menos uma vez; não divide a quantidade de eventos de reabertura pelo total de OS. Uma alternativa seria usar `foi_finalizada = true` no denominador, mas isso define outro indicador.
- OS-11 segue a mesma distinção entre quantidade de OS e quantidade de mudanças.
- OS-13 atribui a conclusão ao responsável atual. Alterações posteriores na atribuição podem alterar o resultado retrospectivo. Não representa necessariamente todos os técnicos que trabalharam no atendimento.
- OS-15: a tabela operacional `tarefa` já tem o status; é possível agregar `status_ordem_servico = 4` por OS. Definir se tarefas inativas entram antes da implementação.
- Para consolidar OS-15 em um percentual de tarefas, usar `100 × SUM(qtd_tarefas_concluidas) / SUM(qtd_tarefas)`. A média dos percentuais por OS representa outra pergunta, com peso igual por OS.

### 4.2 Solicitações (problemas) — 11 indicadores

Base principal: `fato_problema`. Todos usam a coorte de problemas criados no período; status e conversão refletem a posição atual.

| ID | KPI | Fórmula / regra | Unidade | Situação |
|---|---|---|---|---|
| PR-01 | Total de problemas | `N(total)` | Problemas | Disponível |
| PR-02 | Problemas pendentes | `N(esta_pendente = true)` | Problemas | Disponível |
| PR-03 | Problemas aprovados | `N(esta_aprovado = true)` | Problemas | Disponível |
| PR-04 | Problemas reprovados | `N(esta_reprovado = true)` | Problemas | Disponível |
| PR-05 | Taxa de aprovação | `100 × N(esta_aprovado = true) / N(total)` | % | Disponível |
| PR-06 | Taxa de reprovação | `100 × N(esta_reprovado = true) / N(total)` | % | Disponível |
| PR-07 | Taxa de conversão em OS | `100 × N(gerou_ordem_servico = true) / N(total)` | % | Disponível |
| PR-08 | Problemas por unidade | `N(total)` por `unidade_id` | Problemas/unidade | Disponível |
| PR-09 | Problemas por local | `N(total)` por `local_id`; nomes e tipos em `dim_local` | Problemas/local | Disponível |
| PR-10 | Problemas por categoria de equipamento | `N(total)` por `categoria_equipamento_id` | Problemas/categoria | Disponível |
| PR-11 | Problemas por período | `N(total)` por dia, mês ou ano de `data_criacao` | Problemas/período | Disponível |

Taxas PR-05 e PR-06 incluem pendentes no denominador, conforme a lista original. Uma taxa “entre problemas analisados” excluiria pendentes e deve ser publicada separadamente.

Uma taxa alta de aprovação ou conversão não é, por si só, evidência de bom desempenho. Pode refletir o perfil da demanda ou critérios mais permissivos de análise.

### 4.3 Ocorrências — 10 indicadores

Base principal: `fato_ocorrencia`. Usar a data de registro `data_criacao`.

| ID | KPI | Fórmula / regra | Unidade | Situação |
|---|---|---|---|---|
| OC-01 | Total de ocorrências | `N(total)` | Ocorrências | Disponível |
| OC-02 | Ocorrências por técnico | `N(total)` por `tecnico_id` | Ocorrências/técnico | Disponível |
| OC-03 | Ocorrências por unidade | `N(total)` por `unidade_id` | Ocorrências/unidade | Disponível |
| OC-04 | Ocorrências por local | `N(total)` por `local_id` | Ocorrências/local | Disponível |
| OC-05 | Ocorrências por categoria de problema | `N(total)` por `categoria_problema_id` | Ocorrências/categoria | Disponível |
| OC-06 | Ocorrências por categoria de equipamento | `N(total)` por `categoria_equipamento_id` | Ocorrências/categoria | Disponível |
| OC-07 | Ocorrências por prioridade | `N(total)` por `prioridade` ou `prioridade_nome` | Ocorrências/prioridade | Disponível |
| OC-08 | Ocorrências ativas | `N(esta_ativo = true)` | Ocorrências | Disponível |
| OC-09 | Taxa de ocorrências de alta prioridade | `100 × N(prioridade = 0) / N(total)` | % | Disponível |
| OC-10 | Ocorrências por período | `N(total)` por dia, mês ou ano de `data_criacao` | Ocorrências/período | Disponível |

`esta_ativo` indica atividade cadastral. Não representa serviço ainda aberto: a ocorrência é registrada como situação já resolvida. Volume registrado por técnico também depende da disciplina de registro e da distribuição dos atendimentos.

## 5. Taxa de recorrência de demanda por local e categoria

| ID | KPI | Fórmula | Unidade | Situação |
|---|---|---|---|---|
| RC-01 | Taxa de recorrência de demanda por local e categoria | `100 × episódios recorrentes iniciados no período / total de episódios iniciados no período` | % | Calculável com as views atuais; consulta de consolidação ainda não implementada |

Este é o único indicador adicional ao conjunto básico. A fonte é a `fato_problema`, com chave `local_id + categoria_equipamento_id`. As janelas iniciais propostas são 24 horas para consolidação e 30 dias para recorrência; seus valores ainda precisam de validação com o processo de manutenção.

### 5.1 Por que contar episódios

Várias solicitações próximas sobre o mesmo local e categoria podem refletir uma concentração de demanda. Contá-las individualmente como recorrências aumentaria a taxa em função da quantidade de registros, e não necessariamente de novos episódios.

Por outro lado, solicitações com a mesma chave podem corresponder a equipamentos e falhas distintos. A consolidação é uma aproximação analítica; não autoriza apagar registros nem afirmar que eram duplicados.

### 5.2 Fonte e relação com as demais fatos

A taxa é calculada sobre as solicitações da `fato_problema`. As OS vinculadas podem ser usadas para detalhar o atendimento desses problemas, mas não entram como novas solicitações na consolidação.

Os registros da `fato_ocorrencia` continuam contemplados pelos seus dez indicadores básicos. Não fazem parte da população de RC-01, para que a taxa tenha uma fonte e um denominador únicos.

### 5.3 Algoritmo de consolidação

Para cada chave `local_id + categoria_equipamento_id`:

1. Ordenar as solicitações por `data_criacao` e `problema_id`, usando o identificador para desempatar registros com a mesma data.
2. O primeiro registro inicia o primeiro episódio em `inicio_episodio`.
3. Pertencem ao episódio os registros no intervalo `[inicio_episodio, inicio_episodio + 24h)`.
4. O primeiro registro no limite de 24h ou depois dele inicia o próximo episódio.
5. Repetir até consumir o histórico.

A janela não é renovada a cada novo registro. Comparar somente a distância entre registros consecutivos não implementa essa regra: uma sequência contínua poderia formar um episódio sem limite de duração.

Não usar simplesmente o dia do calendário. Por exemplo, registros às 23h50 e às 00h10 do dia seguinte podem pertencer ao mesmo episódio.

### 5.4 Critério de recorrência e período

Para dois episódios consecutivos da mesma chave:

`recorrente = inicio_atual > inicio_anterior AND inicio_atual <= inicio_anterior + 30 dias`.

O primeiro episódio conhecido não é classificado como recorrente. “Conhecido” significa dentro do histórico disponível; ausência de dados anteriores não prova que nunca houve demanda anterior.

Calcular episódios e seus predecessores antes de filtrar o período do dashboard. Filtrar a origem primeiro pode dividir episódios e perder o predecessor.

A janela é comparada ao início do episódio anterior, não ao último registro dele nem à data de resolução. Essa escolha deve ser mantida na versão publicada.

### 5.5 Fórmula e exemplo

`Taxa = 100 × N(episódios recorrentes iniciados em [início, fim)) / N(episódios iniciados em [início, fim))`.

Exemplo da mesma chave, sem episódios anteriores, em que os registros de cada linha cabem na respectiva janela de 24h:

| Início do episódio | Solicitações | Episódio | Recorrente |
|---|---:|---:|---|
| 01/10/2026 às 08h | 8 | 1 | Não |
| 04/10/2026 às 10h | 3 | 2 | Sim |
| 20/10/2026 às 09h | 5 | 3 | Sim |

Resultado: 16 solicitações, 3 episódios e 2 episódios recorrentes. Taxa de recorrência: aproximadamente 66,7%.

Publicar as contagens de solicitações, episódios e episódios recorrentes junto da taxa. Um local com dois episódios pode ter percentual alto, mas evidência muito limitada.

### 5.6 Riscos e parâmetros a validar

- 24h e 30 dias são parâmetros iniciais para documentação, não limites comprovados empiricamente.
- Uma mesma falha não resolvida por vários dias pode gerar vários episódios classificados como recorrentes.
- Falhas independentes no mesmo local e categoria podem ser agrupadas em um episódio.
- A regra não mede recorrência por equipamento físico, pois falta `equipamento_id` nas fatos.
- Mudanças na categoria ou no local cadastrado podem separar registros relacionados.
- O histórico completo disponível deve orientar a ancoragem. Na atualização incremental, preservar o estado do episódio anterior ou recalcular com contexto suficiente; não reiniciar a consolidação arbitrariamente no mês filtrado.
- Comparar sensibilidade a janelas diferentes antes de fixar os valores como regra definitiva.
- A consolidação não altera o cadastro nem a existência das solicitações.

## 6. Limitações transversais e cuidados de interpretação

### 6.1 Estado atual versus eventos históricos

A fato de OS contém estado atual e resumos de auditoria, não uma linha por transição nem snapshots diários.

Não é possível usar apenas essa fato para reconstruir com precisão:

- backlog de qualquer dia passado;
- todas as finalizações ocorridas no mês, incluindo OS reabertas depois;
- técnico responsável em cada instante passado;
- esforço efetivo por ciclo de execução;
- datas de cada reabertura e reatribuição.

A auditoria operacional contém parte dos eventos, mas expô-los exige outra consulta ou evolução do dimensional. Não confundir a existência no operacional com disponibilidade nas fatos atuais.

### 6.2 Completude do histórico

As triggers registram alterações; se uma OS for inserida diretamente em um estado avançado ou houver importação sem histórico correspondente, datas de início e finalização podem faltar.

As flags e os tempos resumidos não substituem a verificação de cobertura. Em especial, `tempo_pausado_minutos = 0` pode significar ausência de pausa registrada, não comprovação de que nunca houve pausa.

### 6.3 Viés de comparações entre técnicos e unidades

Comparar produtividade, prazo ou reabertura exige observar prioridade, categoria, volume e perfil dos atendimentos.

Mais atendimentos não implica melhor qualidade; menos atraso não implica maior eficiência se a equipe recebe casos mais simples. Não construir ranking de desempenho individual apenas com uma contagem.

### 6.4 Amostra e mudanças nos indicadores

Exibir numerador, denominador e quantidade de observações nas taxas e médias.

Não criar automaticamente uma meta universal ou um limite mínimo de amostra sem justificativa. Parâmetros devem ser revisados com os responsáveis pelo processo e com os dados reais.

Por usarem estado atual e dimensões sem versionamento, alguns indicadores históricos podem mudar quando há reabertura, reatribuição ou alteração cadastral.

## 7. Decisões registradas e pendências

| Assunto | Registro |
|---|---|
| Solicitações | Correspondem aos problemas da `fato_problema`; manter os 11 indicadores básicos dessa fato |
| Status de problema | Seguir API: 0 Pendente, 1 Reprovado, 2 Aprovado |
| OS e ocorrências | Manter, respectivamente, os 15 e os 10 indicadores básicos |
| Único indicador adicional | RC-01: taxa de recorrência de demanda por local e categoria |
| Fonte da recorrência | Somente solicitações da `fato_problema` |
| Unidade de recorrência | Episódios analíticos, em vez de classificar cada solicitação como recorrência |
| Consolidação | Janela fixa ancorada no primeiro registro; 24h é parâmetro inicial proposto |
| Janela de recorrência | 30 dias entre inícios de episódios consecutivos; parâmetro inicial proposto |
| Volume bruto | Preservar todas as solicitações e suas contagens nos indicadores básicos |
| OS abertas | Convenção proposta 1, 2, 3; registrar diferença em relação à descrição original “andamento ou pausa” |
| Atraso | Separar status Atrasada de prazo vencido; não usar a flag de prazo como substituta de OS-03 |
| Tarefas concluídas | OS-15 permanece no catálogo original, mas falta expor a contagem na fato; decidir tratamento de tarefas inativas |
| Metas e parâmetros | Não definir metas de desempenho sem referência de negócio; validar as janelas de recorrência |
| Implementação | Este documento especifica consultas e medidas; não implementa mudanças nas views |

## 8. Fontes verificadas

Os links abaixo apontam aos arquivos locais usados na conferência:

- [Fato de ordens de serviço](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/views/fato_ordem_servico.sql>)
- [Fato de problemas](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/views/fato_problema.sql>)
- [Fato de ocorrências](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/views/fato_ocorrencia.sql>)
- [Dimensão de técnicos](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/views/dim_tecnico.sql>)
- [Dimensão de locais](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/views/dim_local.sql>)
- [Dimensão de tempo](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/views/dim_tempo.sql>)
- [Dimensão de status de OS](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/views/dim_status_ordem_servico.sql>)
- [Mapeamento de enums](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/docs/enums.md>)
- [Tabela de tarefas](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/tabelas/tarefa.sql>)
- [Auditoria de status de OS](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/triggers/auditar_status_ordem_servico.sql>)
- [Auditoria de atribuição de técnico](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/segundo-modelagem-dados-fixa/database/triggers/auditar_tecnico_ordem_servico.sql>)

- [Requisitos por disciplina - Interdisciplinar - Maio2026.pdf](<C:/Users/nicolaspaz-ieg/OneDrive - Instituto J&F/Área de Trabalho/TECH/Interdisciplinar/Requisitos por disciplina - Interdisciplinar - Maio2026.pdf>) — seção Business Intelligence, páginas 10 e 11.
