#!/bin/bash

# Script de Deploy Automatizado para Droplet
# Uso: ./deploy-droplet.sh [IP_DO_DROPLET]

set -e

echo "🚀 Deploy Automatizado - NIST Discord Bot"
echo "=========================================="
echo ""

# Verificar se o IP foi fornecido
if [ -z "$1" ]; then
    echo "❌ Erro: IP do droplet não fornecido"
    echo "Uso: ./deploy-droplet.sh [IP_DO_DROPLET]"
    exit 1
fi

DROPLET_IP=$1
PROJECT_DIR="/opt/nist-discord-bot"

echo "📡 Droplet IP: $DROPLET_IP"
echo ""

# Função para executar comando no droplet
run_remote() {
    ssh root@$DROPLET_IP "$@"
}

echo "1️⃣  Verificando conexão SSH..."
if ! ssh -o ConnectTimeout=5 root@$DROPLET_IP "echo 'Conexão OK'" &> /dev/null; then
    echo "❌ Não foi possível conectar ao droplet"
    echo "Verifique:"
    echo "  - IP está correto"
    echo "  - SSH key configurada"
    echo "  - Firewall permite porta 22"
    exit 1
fi
echo "✅ Conexão SSH estabelecida"
echo ""

echo "2️⃣  Verificando Docker no droplet..."
if ! run_remote "docker --version" &> /dev/null; then
    echo "⚙️  Docker não encontrado. Instalando..."
    run_remote "curl -fsSL https://get.docker.com -o get-docker.sh && sh get-docker.sh"
    run_remote "apt install -y docker-compose"
    echo "✅ Docker instalado"
else
    echo "✅ Docker já instalado"
fi
echo ""

echo "3️⃣  Criando estrutura de diretórios..."
run_remote "mkdir -p $PROJECT_DIR"
echo "✅ Diretórios criados"
echo ""

echo "4️⃣  Enviando arquivos do projeto..."
rsync -avz --exclude='.git' --exclude='__pycache__' --exclude='.env' \
    ./ root@$DROPLET_IP:$PROJECT_DIR/
echo "✅ Arquivos sincronizados"
echo ""

echo "5️⃣  Configurando variáveis de ambiente..."
if [ -f .env ]; then
    scp .env root@$DROPLET_IP:$PROJECT_DIR/.env
    echo "✅ Arquivo .env enviado"
else
    echo "⚠️  Arquivo .env não encontrado localmente"
    echo "📝 Você precisa criar manualmente no droplet:"
    echo "   ssh root@$DROPLET_IP"
    echo "   cd $PROJECT_DIR"
    echo "   nano .env"
fi
echo ""

echo "6️⃣  Build da imagem Docker..."
run_remote "cd $PROJECT_DIR && docker-compose build"
echo "✅ Build concluído"
echo ""

echo "7️⃣  Iniciando containers..."
run_remote "cd $PROJECT_DIR && docker-compose up -d"
echo "✅ Containers iniciados"
echo ""

echo "8️⃣  Verificando status..."
sleep 5
run_remote "cd $PROJECT_DIR && docker-compose ps"
echo ""

echo "9️⃣  Mostrando logs (últimas 20 linhas)..."
run_remote "cd $PROJECT_DIR && docker-compose logs --tail=20"
echo ""

echo "=========================================="
echo "✅ Deploy concluído com sucesso!"
echo ""
echo "📊 Comandos úteis:"
echo "  Ver logs:       ssh root@$DROPLET_IP 'cd $PROJECT_DIR && docker-compose logs -f'"
echo "  Reiniciar:      ssh root@$DROPLET_IP 'cd $PROJECT_DIR && docker-compose restart'"
echo "  Parar:          ssh root@$DROPLET_IP 'cd $PROJECT_DIR && docker-compose down'"
echo "  Status:         ssh root@$DROPLET_IP 'cd $PROJECT_DIR && docker-compose ps'"
echo "  Health check:   curl http://$DROPLET_IP:8080/health"
echo ""
echo "🌐 Acesse: http://$DROPLET_IP:8080"
echo ""
