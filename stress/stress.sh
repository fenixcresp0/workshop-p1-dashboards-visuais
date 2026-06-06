#!/bin/bash
# stress.sh - Script para simular carga de CPU e disparar alertas no dashboard
# Requer: stress-ng (sudo apt install stress-ng)
#
# Uso: ./stress.sh [percentual] [duração_segundos]
# Exemplo: ./stress.sh 90 60   -> 90% de CPU por 60 segundos

PERCENT=${1:-90}
DURATION=${2:-60}
CORES=$(nproc)

echo "================================================"
echo "  Workshop P1 - Teste de Carga de CPU"
echo "  CPU: ${PERCENT}% | Duração: ${DURATION}s | Cores: ${CORES}"
echo "================================================"
echo ""
echo "Acesse o Grafana em http://localhost:3000"
echo "Login: admin / admin"
echo ""
echo "Iniciando stress em 3 segundos..."
echo "(Pressione Ctrl+C para cancelar)"
sleep 3

stress-ng --cpu ${CORES} --cpu-load ${PERCENT} --timeout ${DURATION}s --metrics-brief

echo ""
echo "Teste finalizado. Verifique os gauges no Grafana!"
