# Roteiro de Apresentação — Workshop P1
## Tema 3: Dashboards Visuais | Redes de Computadores — UCDB 2026

---

### Integrantes e papéis na apresentação

| RA       | Nome                        | Bloco                          | Tempo aprox. |
|----------|-----------------------------|--------------------------------|--------------|
| [199366] | Pedro Woicolesko Crespo     | Abertura + Conclusão + **Demo (controla o dashboard)** | ~5 min |
| [197818] | Henrique Leal Meneghetti    | Fundamentação Teórica + **Demo (narra)** | ~5 min |
| [200641] | Marcos Mantovanni Feltran   | Arquitetura + Docker           | ~4 min       |
| [199558] | João Gabriel Balbuena Brito | PromQL + Resultados            | ~3 min       |
| **Todos**| —                           | P&R                            | ~4 min       |

**Tempo total estimado: 20–22 minutos**

---

> 💡 **Antes de começar:** o ambiente já está rodando no servidor do Pedro. Confirmar que o Grafana está acessível (endereço IP do servidor na porta 3000), o dashboard carregado, e o terminal SSH aberto com o script de stress pronto para rodar — sem necessidade de `docker compose up -d`.

---

## ⏱ 00:00 — SLIDE 1 · Capa
**Fala: PEDRO**

> "Bom dia/boa tarde a todos. Somos o grupo do Tema 3 — Dashboards Visuais. Nosso trabalho responde a uma pergunta prática que qualquer equipe de TI enfrenta: como saber se o servidor está com problema *antes* que o usuário reclame?
>
> Para isso, implementamos um ambiente completo de monitoramento usando três ferramentas open-source muito usadas na indústria: Node Exporter, Prometheus e Grafana — tudo rodando em Docker. Vou apresentar o grupo e passamos direto para o conteúdo."

*(apresentar os nomes brevemente — sem ler os RAs)*

---

## ⏱ 00:45 — SLIDE 2 · Agenda
**Fala: PEDRO**

> "Nossa apresentação está dividida em quatro blocos. Vamos começar pelo contexto do problema, depois a teoria que fundamenta as ferramentas, em seguida a metodologia — o passo a passo do que fizemos — e por fim a demo ao vivo do dashboard funcionando, com um teste de estresse para vocês verem o alerta disparando na prática. Perguntas ao final."

*(avançar slide rapidamente — agenda é só orientação)*

---

## ⏱ 01:15 — SLIDE 3 · Introdução — O Problema
**Fala: PEDRO**

> "O problema é simples de enunciar: servidores falham silenciosamente. A CPU satura, a memória esgota, a rede entra em colapso — e a equipe só descobre quando o usuário liga reclamando.
>
> Isso acontece por falta de *visibilidade*. Sem um painel que mostre o estado do servidor em tempo real, operação vira bombeiro — só apaga incêndio quando já está pegando fogo.
>
> O resultado esperado pelo professor foi exatamente este: um dashboard com alertas visuais — gauges e gráficos de linha — que dispara quando o uso de CPU ultrapassa 80%. É o que vamos mostrar hoje."

---

## ⏱ 02:15 — SLIDE 4 · Observabilidade
**Fala: HENRIQUE**

> "Para entender como chegamos à solução, preciso passar rapidamente pela teoria. O conceito que une tudo isso é *observabilidade* — a capacidade de entender o estado interno de um sistema a partir do que ele produz para fora.
>
> Na prática, observabilidade tem três pilares: métricas, logs e traces. Nosso projeto foca em *métricas* — dados numéricos coletados periodicamente, como percentual de CPU e bytes de rede. São elas que alimentam o dashboard."

---

## ⏱ 03:00 — SLIDE 5 · Prometheus
**Fala: HENRIQUE**

> "O Prometheus é o nosso banco de dados de séries temporais — ele é quem coleta e armazena as métricas. O diferencial dele é o modelo *pull*: ao invés de esperar os servidores enviarem dados, o Prometheus vai até eles buscar — a cada 15 segundos, no nosso caso.
>
> Ele tem uma linguagem de consulta própria chamada PromQL. Por exemplo, essa query aqui calcula o percentual de CPU em uso: você pega 100% menos o tempo que a CPU ficou ociosa. O resultado é um número entre 0 e 100 que alimenta o gauge no Grafana."

*(apontar para a query na tela — slide 5, bloco de código)*

---

## ⏱ 04:00 — SLIDE 6 · Grafana e NOC
**Fala: HENRIQUE**

> "O Grafana é a interface visual. Ele se conecta ao Prometheus via PromQL e transforma os dados em painéis. O conceito importante aqui é o de NOC — Network Operations Center. É a sala de controle onde operadores monitoram a infraestrutura em tempo real. O Grafana vira o *painel central* desse NOC, o que o professor chamou de *single pane of glass* — um lugar só pra ver tudo.
>
> Os componentes que usamos são: gauges pra valor instantâneo, gráficos de linha pra ver evolução no tempo, e a escala de cores pra alertar — verde, amarelo, laranja, vermelho."

---

## ⏱ 05:00 — SLIDE 7 · Node Exporter
**Fala: MARCOS**

> "O elo que conecta o servidor ao Prometheus é o Node Exporter. Ele é um agente que lê as métricas diretamente do kernel Linux — dos diretórios /proc e /sys — e as expõe num endpoint HTTP na porta 9100.
>
> A tabela mostra as principais categorias: CPU, memória, disco, rede e uptime. Cada métrica tem um nome específico no formato Prometheus. Por exemplo, *node_cpu_seconds_total* é um contador cumulativo de quanto tempo cada núcleo passou em cada modo — idle, user, system. O Prometheus divide esse contador pelo tempo e transforma em taxa, que é o que a gente usa no dashboard."

---

## ⏱ 05:45 — SLIDE 8 · Arquitetura da Solução
**Fala: MARCOS**

> "Agora que vocês conhecem as três ferramentas, a arquitetura fica clara. O fluxo é linear: o Node Exporter expõe as métricas, o Prometheus faz scraping a cada 15 segundos e armazena no TSDB, e o Grafana consulta o Prometheus via PromQL e renderiza o dashboard com atualização a cada 10 segundos.
>
> O detalhe importante é que tudo isso roda em contêineres Docker na mesma rede interna bridge — por isso os contêineres se enxergam pelo nome, como *node-exporter:9100* em vez de um IP. Nenhuma instalação manual de dependência."

---

## ⏱ 06:30 — SLIDE 9 · Docker Compose
**Fala: MARCOS**

> "Para subir tudo isso, o professor pediu que o ambiente fosse reproduzível. A solução foi o Docker Compose — um único arquivo YAML que define os três serviços. Com um comando — *docker compose up -d* — o ambiente inteiro sobe em menos de um minuto.
>
> Os três serviços são: Node Exporter na porta 9100, Prometheus na 9090 e Grafana na 3000. O Grafana já sobe com o dashboard pré-carregado, sem precisar configurar nada manualmente — isso é o *provisioning*, que o Grafana faz via arquivos JSON que incluímos no projeto."

---

## ⏱ 07:30 — SLIDE 10 · prometheus.yml
**Fala: JOÃO GABRIEL**

> "O arquivo de configuração do Prometheus é simples mas precisa ser bem entendido. O *scrape_interval* de 15 segundos é o coração do sistema — é o ritmo de coleta. O *evaluation_interval* é para regras de alerta, que a gente deixou igual ao de coleta.
>
> Os dois jobs definem os targets: o Prometheus se auto-monitora — ele mesmo é um alvo — e o segundo job aponta pro Node Exporter. O *relabel_config* ali no final é só pra trocar o endereço técnico por um nome legível no dashboard: 'servidor-linux'."

*(apontar as seções do código no slide)*

---

## ⏱ 08:30 — SLIDE 11 · Queries PromQL
**Fala: JOÃO GABRIEL**

> "Essas são as quatro queries que alimentam os painéis. Vou destacar a lógica da CPU porque ela é a mais importante pro nosso resultado esperado.
>
> O node_cpu_seconds_total é um contador que só cresce. O irate calcula a taxa de crescimento nos últimos dois pontos dentro da janela de 5 minutos — isso dá a taxa instantânea. A gente pega o modo *idle* — CPU ociosa — e subtrai de 1. Multiplica por 100 e tem o percentual em uso. A lógica de memória e disco é análoga: disponível dividido pelo total, subtraído de 1."

---

## ⏱ 09:30 — SLIDE 12 · O Dashboard
**Fala: JOÃO GABRIEL**

> "O dashboard que provisionamos tem sete painéis no total. Três gauges na linha de cima — CPU, RAM e Disco — com a mesma escala de cores que o professor pediu: vermelho acima de 80%. O uptime como stat. E três gráficos de linha na parte de baixo, incluindo tráfego de rede.
>
> Tudo isso atualiza automaticamente a cada 10 segundos, com janela padrão de 30 minutos. Mas o melhor é ver funcionando — que é o que a gente vai fazer agora."

---

## ⏱ 10:15 — SLIDE 13 · Alertas Visuais
**Fala: JOÃO GABRIEL**

> "Antes da demo, uma visão rápida dos limiares. A escala é: verde até 60%, amarelo de 60 a 75%, laranja de 75 a 80%, e vermelho acima de 80%. Esses valores são configurados diretamente no JSON do dashboard e aplicados tanto nos gauges quanto como linha horizontal nos gráficos de linha.
>
> Para disparar isso na prática, usamos o stress-ng — uma ferramenta de teste de carga. O script que incluímos no projeto força 90% de CPU por 60 segundos. Vamos executar isso ao vivo agora."

---

## ⏱ 11:00 — SLIDES 14 e 15 · Referências e Conclusão
**Fala: PEDRO**

> "Antes da demo, rapidamente: nossa fundamentação está apoiada em sete referências — documentação oficial do Prometheus e do Grafana, o clássico do Tanenbaum sobre Redes de Computadores, a norma IEEE 802.3, o livro *The Art of Monitoring* do Turnbull, o *Systems Performance* do Brendan Gregg, e a documentação do Docker. Todas citadas no artigo do Overleaf.
>
> Para concluir: os três objetivos foram cumpridos. Dashboard funcionando com gauges e gráficos de linha. Alertas visuais em 80%. Ambiente reproduzível com um comando. Vamos mostrar isso agora."

---

## ⏱ 12:00 — 🖥️ DEMO AO VIVO
### Responsável pela tela: PEDRO (compartilha a tela — acesso ao servidor)
### Narração: HENRIQUE

---

**Passo 1 — Dashboard em estado de repouso** *(~30 s)*

> *(Pedro já está com o navegador aberto no Grafana do servidor)*
>
> **Henrique:** "O ambiente de monitoramento já está rodando no servidor do Pedro. Aqui vocês veem o dashboard em estado de repouso — todos os gauges estão verdes: CPU baixa, memória e disco dentro do normal. Os gráficos de linha mostram o histórico dos últimos 30 minutos."
>
> *(Pedro navega brevemente pelos painéis para o professor visualizar)*
>
> **Henrique:** "Isso é o modelo pull do Prometheus funcionando — os dados chegam automaticamente a cada 15 segundos, sem nenhuma ação manual."

---

**Passo 2 — Interface do Prometheus (opcional, se o tempo permitir)** *(~30 s)*

> *(Pedro abre uma aba com o Prometheus: IP_DO_SERVIDOR:9090/targets)*
>
> **Henrique:** "No Prometheus, em *Status > Targets*, os dois jobs estão com estado *UP* — o Node Exporter e o auto-monitoramento. Isso confirma que o scraping está funcionando normalmente."

---

**Passo 3 — Executar o teste de estresse** *(~60 s)*

> *(Pedro abre o terminal SSH conectado ao servidor e executa:)*

```bash
./stress/stress.sh 90 60
```

> **Henrique:** "Estamos executando o script de stress — 90% de CPU por 60 segundos. Fiquem de olho nos gauges..."
>
> *(Pedro alterna para a aba do Grafana. Aguardar 10–15 segundos para o próximo scrape)*
>
> **Henrique:** "O gauge de CPU começa a subir... entrando na zona amarela... laranja... e agora *vermelho* — 80% ultrapassado. O gráfico de linha cruza a linha de alerta. Esse é exatamente o resultado esperado pelo professor: alerta visual disparado em tempo real."
>
> *(após ~60 s o script termina)*
>
> **Henrique:** "O stress terminou — e em menos de 30 segundos o dashboard já mostra a CPU voltando à zona verde. O sistema reflete o estado real do servidor com precisão."

---

**Passo 4 — Mostrar o repositório no GitHub** *(~30 s)*

> *(Pedro abre o GitHub do projeto)*
>
> **Henrique:** "O projeto completo está no GitHub — docker-compose, configuração do Prometheus, dashboard JSON pré-configurado e o script de stress. Qualquer pessoa com Docker instalado reproduz esse mesmo ambiente com um único comando: *docker compose up -d*."

---

## ⏱ 16:00 — ❓ PERGUNTAS E RESPOSTAS
**Todos respondem. Distribuição sugerida por área:**

| Área provável da pergunta        | Quem responde primariamente |
|----------------------------------|-----------------------------|
| Teoria de observabilidade        | Henrique                    |
| Funcionamento do Prometheus/Pull | Henrique ou João Gabriel    |
| PromQL / queries                 | João Gabriel                |
| Docker / reprodutibilidade       | Marcos                      |
| Dashboard / Grafana / Demo       | Pedro ou Henrique           |
| Contexto geral / NOC             | Pedro                       |

---

### Perguntas esperadas e respostas preparadas

**"Por que vocês escolheram o modelo pull do Prometheus em vez de push?"**
> O pull centraliza o controle no servidor de monitoramento — ele decide quando e com que frequência coletar. Isso facilita gerenciar muitos targets sem precisar configurar cada servidor para enviar dados. No push, se um agente parar de enviar, pode ser difícil detectar se é falha ou silêncio intencional.

---

**"O que acontece se o Prometheus cair? Os dados são perdidos?"**
> Os dados já coletados ficam no volume do Docker (*prometheus_data*). Ao reiniciar o contêiner, o TSDB é carregado e o histórico é preservado. O único dado perdido seria o do período em que o Prometheus ficou offline.

---

**"Por que usar irate() em vez de rate()?"**
> O irate() calcula a taxa com base nos dois pontos mais recentes da janela, sendo mais sensível a picos súbitos. O rate() usa todos os pontos da janela e faz uma média, o que suaviza variações rápidas. Para monitoramento de CPU, onde picos são importantes, o irate() é mais adequado.

---

**"O Grafana poderia se conectar a outra fonte de dados além do Prometheus?"**
> Sim. O Grafana suporta nativamente InfluxDB, Elasticsearch, MySQL, PostgreSQL, CloudWatch, entre outras. A configuração de datasource que fizemos é específica para Prometheus, mas o mecanismo de provisioning funciona igual para qualquer fonte.

---

**"Como vocês fariam para monitorar múltiplos servidores?"**
> Bastaria adicionar mais entradas em *static_configs* no prometheus.yml, ou usar *file_sd_configs* para descoberta dinâmica. Cada servidor precisaria ter o Node Exporter instalado e acessível. No dashboard, o label *instance* diferenciaria as séries temporais de cada máquina.

---

**"O ambiente funciona no Windows sem WSL?"**
> O Node Exporter é específico para Linux — ele lê /proc e /sys que não existem no Windows nativo. Com o Docker Desktop no Windows usando WSL2, o contêiner do Node Exporter roda no ambiente Linux embutido e coleta as métricas dele. Para monitorar o host Windows, existiria o *windows_exporter*, mas não foi escopo deste trabalho.

---

**"O que seria o próximo passo para levar isso a produção?"**
> Adicionaríamos o *Alertmanager* — componente do ecossistema Prometheus — para enviar notificações por e-mail, Slack ou PagerDuty quando os limiares forem atingidos. Também habilitaríamos autenticação no Grafana, HTTPS, e retenção de dados configurada para a necessidade do negócio.

---

## ⏱ 20:00 — Encerramento
**Fala: PEDRO**

> "Muito obrigado, professor e colegas. O repositório GitHub com o projeto completo, o artigo no Overleaf e os slides estão todos linkados no formulário de entrega. Qualquer dúvida adicional estamos à disposição."

---

## Checklist pré-apresentação

- [ ] Servidor do Pedro acessível — confirmar IP e porta 3000 (Grafana) e 9090 (Prometheus)
- [ ] Grafana acessível com o dashboard Workshop P1 carregado
- [ ] Prometheus acessível em `/targets` com ambos os jobs *UP*
- [ ] Terminal SSH aberto no servidor com `./stress/stress.sh` pronto para executar
- [ ] Slides abertos no slide 1
- [ ] Tela do Pedro compartilhada e testada (resolução, visibilidade do terminal e browser)
- [ ] Cronômetro visível para o grupo (ex.: celular)
- [ ] GitHub do projeto aberto numa aba

---

## Distribuição de tempo — resumo

| Bloco                        | Responsável                   | Tempo   |
|------------------------------|-------------------------------|---------|
| Slides 1–3 (Abertura)        | Pedro                         | ~3 min  |
| Slides 4–6 (Teoria)          | Henrique                      | ~3 min  |
| Slides 7–9 (Arq. + Docker)   | Marcos                        | ~3 min  |
| Slides 10–13 (PromQL + Res.) | João Gabriel                  | ~3 min  |
| Slides 14–15 (Ref. + Conc.)  | Pedro                         | ~1 min  |
| Demo ao vivo                 | Pedro (tela) + Henrique (narra) | ~4 min  |
| Perguntas e Respostas        | Todos                         | ~4 min  |
| **Total**                    |                               | **~21 min** |
