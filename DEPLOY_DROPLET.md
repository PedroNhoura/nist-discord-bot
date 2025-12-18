# 🐳 Deploy com Docker no DigitalOcean Droplet

## Para Controle Total de Containers

Se você quer gerenciar múltiplos bots com Docker Compose em uma máquina dedicada.

---

## 📋 Pré-requisitos

- Conta DigitalOcean
- SSH Key configurado
- GitHub com repositório atualizado

---

## 🖥️ Criar Droplet no DigitalOcean

### 1. Criar o Droplet

1. Acesse: https://cloud.digitalocean.com/droplets/new
2. Escolha:
   - **Image**: Ubuntu 22.04 LTS
   - **Plan**: Basic ($6/mês - 1GB RAM suficiente para 2-3 bots)
   - **Datacenter**: Atlanta (ATL1)
   - **Authentication**: SSH Key (mais seguro)
   - **Hostname**: `discord-bots-server`
3. Marque: ✅ Install Docker (One-Click Apps)
4. Clique em **Create Droplet**

### 2. Conectar ao Droplet

```bash
ssh root@seu_ip_do_droplet
```

### 3. Instalar Dependências (se não marcou Docker)

```bash
# Atualizar sistema
apt update && apt upgrade -y

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

# Instalar Docker Compose
apt install docker-compose -y

# Verificar instalação
docker --version
docker-compose --version
```

---

## 🚀 Deploy do Bot

### 1. Clonar Repositório

```bash
cd /opt
git clone https://github.com/PedroNhoura/nist-discord-bot.git
cd nist-discord-bot
```

### 2. Configurar Variáveis de Ambiente

```bash
# Criar arquivo .env
nano .env
```

Adicione:
```env
DISCORD_TOKEN=seu_token_aqui
DISCORD_CHANNEL_ID=1451316595661209642
NVD_API_KEY=sua_chave_opcional
```

Salve: `Ctrl+X`, `Y`, `Enter`

### 3. Build e Start

```bash
# Build da imagem
docker-compose build

# Iniciar em background
docker-compose up -d

# Ver logs
docker-compose logs -f nist-bot
```

Deve ver:
```
Bot conectado como NIST#0073 (ID: xxx)
Servidor HTTP rodando na porta 8080
Tarefa de monitoramento de CVEs iniciada.
```

---

## 📊 Gerenciamento

### Comandos Úteis

```bash
# Ver status dos containers
docker-compose ps

# Ver logs em tempo real
docker-compose logs -f

# Parar todos os bots
docker-compose down

# Reiniciar bot específico
docker-compose restart nist-bot

# Atualizar código do GitHub
git pull
docker-compose up -d --build

# Ver uso de recursos
docker stats
```

### Logs e Monitoramento

```bash
# Ver últimas 100 linhas
docker-compose logs --tail=100 nist-bot

# Entrar no container (debug)
docker exec -it nist-discord-bot bash

# Ver health check
curl http://localhost:8080/health
```

---

## 🔒 Segurança

### Configurar Firewall

```bash
# Permitir SSH, HTTP e HTTPS
ufw allow 22/tcp
ufw allow 80/tcp
ufw allow 443/tcp
ufw allow 8080/tcp
ufw enable
```

### Auto-restart

Os containers já estão configurados com `restart: unless-stopped`

### Backup Automático

```bash
# Criar script de backup
nano /root/backup-bots.sh
```

Adicione:
```bash
#!/bin/bash
cd /opt/nist-discord-bot
docker-compose exec -T nist-bot cat /app/last_cve.txt > /root/backups/last_cve_$(date +%Y%m%d).txt
```

```bash
chmod +x /root/backup-bots.sh
crontab -e
```

Adicione:
```
0 2 * * * /root/backup-bots.sh
```

---

## 🎯 Adicionar Novos Bots

### 1. Editar docker-compose.yml

```bash
nano docker-compose.yml
```

Adicione:
```yaml
  outro-bot:
    build: ../outro-bot
    container_name: outro-bot
    restart: unless-stopped
    environment:
      - DISCORD_TOKEN=${OUTRO_TOKEN}
    ports:
      - "8081:8080"
    networks:
      - discord-bots-network
```

### 2. Atualizar .env

```bash
nano .env
```

Adicione:
```env
OUTRO_TOKEN=token_do_outro_bot
```

### 3. Reiniciar

```bash
docker-compose up -d
```

---

## 🆚 Comparação: App Platform vs Droplet

| Feature | App Platform | Droplet + Docker |
|---------|--------------|------------------|
| **Preço** | $10/mês por app | $6/mês para múltiplos bots |
| **Gerenciamento** | Automático | Manual |
| **Controle** | Limitado | Total |
| **Deploy** | Auto do GitHub | Manual ou CI/CD |
| **Escalabilidade** | Fácil | Requer configuração |
| **Backup** | Automático | Manual |
| **SSL/Domain** | Incluído | Configurar manualmente |

---

## 💡 Recomendação

- **1-2 bots simples**: App Platform (mais fácil)
- **3+ bots ou controle total**: Droplet + Docker Compose
- **Produção crítica**: Kubernetes (mais complexo)

---

## 📞 Troubleshooting

### Bot não inicia
```bash
docker-compose logs nist-bot
# Verificar se variáveis estão corretas
docker-compose exec nist-bot env
```

### Erro de memória
```bash
# Ver uso
docker stats
# Aumentar droplet ou otimizar código
```

### Atualizar após mudanças
```bash
git pull
docker-compose down
docker-compose up -d --build
```

---

**Custo estimado**: $6-12/mês (vs $10/mês por bot no App Platform)
**Complexidade**: Média
**Controle**: Total
