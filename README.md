# Workshop P1 — Dashboards Visuais (Tema 3)
**Disciplina:** Redes de Computadores — UCDB  
**Prof.:** Renato Gil Arruda Vieira  
**Stack:** Docker · Prometheus · Grafana · Node Exporter

---

## Visão Geral

Este projeto implementa um ambiente completo de observabilidade de servidor usando:

| Serviço | Porta | Função |
|---|---|---|
| **Node Exporter** | 9100 | Coleta métricas do host (CPU, RAM, disco, rede) |
| **Prometheus** | 9090 | Banco de séries temporais — modelo *pull/scraping* |
| **Grafana** | 3000 | Dashboard visual com gauges, gráficos e alertas |

---

## Pré-requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) instalado e em execução
- Git (para clonar o repositório)
- Sistema operacional: Linux, macOS ou Windows com WSL2

---

## Como Executar

### 1. Clone o repositório
```bash
git clone https://github.com/fenixcresp0/workshop-p1-dashboards-visuais.git
cd workshop-dashboards-visuais
```

### 2. Suba os containers
```bash
docker compose up -d
```

### 3. Acesse os serviços

| Serviço | URL | Credenciais |
|---|---|---|
| Grafana | http://localhost:3000 | admin / admin |
| Prometheus | http://localhost:9090 | — |
| Node Exporter (métricas brutas) | http://localhost:9100/metrics | — |

### 4. Verifique o dashboard

No Grafana, navegue até **Dashboards → Workshop → Workshop P1 - Dashboards Visuais**.

O dashboard é provisionado automaticamente com:
- **Gauge de CPU** (vermelho ao ultrapassar 80%)
- **Gauge de Memória RAM** (vermelho ao ultrapassar 80%)
- **Gauge de Disco** (vermelho ao ultrapassar 85%)
- **Gráfico de linha — CPU ao longo do tempo** (com linha de alerta em 80%)
- **Gráfico de linha — Memória ao longo do tempo**
- **Gráfico de tráfego de rede**

---

## Simulando Carga de CPU (para disparar alertas)

```bash
# Instale stress-ng (Linux/WSL)
sudo apt install stress-ng

# Execute o script de teste (90% de CPU por 60 segundos)
chmod +x stress/stress.sh
./stress/stress.sh 90 60
```

Observe os gauges ficarem **vermelhos** e o gráfico de linha ultrapassar a linha de alerta em 80%.

---

## Parando o Ambiente

```bash
docker compose down
```

Para remover também os volumes (dados do Prometheus e Grafana):
```bash
docker compose down -v
```

---

## Estrutura do Projeto

```
.
├── docker-compose.yml                          # Orquestração dos serviços
├── README.md
├── prometheus/
│   └── prometheus.yml                          # Configuração de scraping
├── grafana/
│   └── provisioning/
│       ├── datasources/
│       │   └── datasource.yml                  # Fonte de dados Prometheus
│       └── dashboards/
│           ├── dashboard.yml                   # Provisionamento automático
│           └── server-dashboard.json           # Dashboard pré-configurado
└── stress/
    └── stress.sh                               # Script de teste de carga
```

---

## Queries PromQL Utilizadas

| Métrica | Query |
|---|---|
| CPU total | `(1 - avg(irate(node_cpu_seconds_total{mode="idle"}[5m]))) * 100` |
| RAM usada | `(1 - (node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes)) * 100` |
| Disco | `(1 - (node_filesystem_avail_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})) * 100` |
| Rede RX | `irate(node_network_receive_bytes_total{device!="lo"}[5m])` |
| Uptime | `node_time_seconds - node_boot_time_seconds` |

---

## Referências

1. PROMETHEUS. *Prometheus Documentation*. Disponível em: https://prometheus.io/docs
2. GRAFANA LABS. *Grafana Documentation*. Disponível em: https://grafana.com/docs
3. TANENBAUM, A. S.; WETHERALL, D. *Redes de Computadores*. 5. ed. Pearson, 2011.
4. IEEE Std 802.3-2022 — *IEEE Standard for Ethernet*.
5. TURNBULL, J. *The Art of Monitoring*. Turnbull Press, 2016.
