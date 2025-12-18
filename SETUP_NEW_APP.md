# 🚀 Criar Novo App com Dockerfile no DigitalOcean

## ✅ Pré-requisitos Checados:
- ✅ Código atualizado no GitHub
- ✅ Dockerfile otimizado com curl
- ✅ App anterior destruído
- ✅ Variáveis de ambiente anotadas

---

## 📋 Passo a Passo COMPLETO

### 1️⃣ Criar Novo App

1. Acesse: https://cloud.digitalocean.com/apps
2. Clique: **Create App**

### 2️⃣ Escolher Source

1. **Service Provider**: GitHub
2. Clique: **Manage Access** (se necessário autorizar)
3. **Repository**: Selecione `PedroNhoura/nist-discord-bot`
4. **Branch**: `main`
5. **Source Directory**: `/` (deixe padrão)
6. ✅ **Autodeploy**: Mantenha marcado
7. Clique: **Next**

### 3️⃣ ⚠️ CRUCIAL - Escolher Build Method

Você verá uma tela assim:

```
╔════════════════════════════════════════╗
║  We detected multiple ways to build    ║
║  your app. Which would you like?       ║
║                                        ║
║  🐳 Dockerfile                         ║
║     Use Dockerfile in root            ║
║     → SELECT THIS! ←                  ║
║                                        ║
║  🐍 Python Buildpack                  ║
║     Automatic Python detection        ║
║                                        ║
╚════════════════════════════════════════╝
```

**⚠️ IMPORTANTE**: Clique em **"Dockerfile"** ou **"Use Dockerfile"**

Se não aparecer esta opção:
- Verifique se o Dockerfile está no root do repositório
- Faça refresh da página
- Reconecte ao GitHub

### 4️⃣ Configurar Resource

**Component Name**:
```
nist-discord-bot
```

**Resource Type**:
```
Web Service  ← DEVE SER WEB SERVICE
```

**Instance Size**:
```
apps-s-1vcpu-1gb-fixed
$10.00/mo
1 GB RAM | 1 Shared vCPU
```

**HTTP Port**:
```
8080  (já deve vir preenchido)
```

**Routes**:
```
/  (já deve vir configurado)
```

Clique: **Next**

### 5️⃣ Configurar Environment Variables

Clique em: **Edit** ao lado de "Environment Variables"

Adicione:

**Variable 1:**
```
Key:   DISCORD_TOKEN
Value: [SEU_TOKEN_DO_DISCORD]
Type:  Secret ← Importante!
```

**Variable 2:**
```
Key:   DISCORD_CHANNEL_ID
Value: 1451316595661209642
Type:  Plain Text
```

**Variable 3 (Opcional):**
```
Key:   NVD_API_KEY
Value: [SUA_CHAVE_NVD]
Type:  Secret
```

**Variable 4 (Automática - se não existir, adicione):**
```
Key:   PORT
Value: 8080
Type:  Plain Text
```

Clique: **Save**

### 6️⃣ Configurar App Info

**App Name** (único, lowercase):
```
nist-discord-bot-v2
ou
brazukas-nist-bot
ou
[escolha_um_nome_unico]
```

**Project**:
```
Bot_Brazukas_HC
```

**Region**:
```
ATL1 - Atlanta
```

### 7️⃣ Review

Verifique:
- ✅ Build method: **Dockerfile**
- ✅ Resource type: **Web Service**
- ✅ Environment variables: 2-3 configuradas
- ✅ HTTP Port: 8080
- ✅ Instance size: $10/mês

**Total Cost**: $10.00/month

### 8️⃣ Create App

Clique: **Create Resources**

---

## 🔍 Monitorando o Deploy

### Build Logs

Você deve ver:

```
✓ git repo clone
✓ Dockerfile detected
  
╭─── app build ───╼
│ Step 1/9 : FROM python:3.11-slim
│ Step 2/9 : RUN apt-get update && apt-get install curl
│ Step 3/9 : WORKDIR /app
│ Step 4/9 : COPY requirements.txt .
│ Step 5/9 : RUN pip install -r requirements.txt
│ Step 6/9 : COPY . .
│ Step 7/9 : RUN touch last_cve.txt
│ Step 8/9 : EXPOSE 8080
│ Step 9/9 : CMD ["python", "-u", "main.py"]
│ Successfully built [image_id]
╰───────────────────╼

✓ build complete
```

### Runtime Logs

Após alguns segundos, deve aparecer:

```
Bot conectado como NIST#0073 (ID: 1226008787442208819)
Servidor HTTP de health check iniciado.
Servidor HTTP rodando na porta 8080
Tarefa de monitoramento de CVEs iniciada.
Verificando novas CVEs...
```

---

## ✅ Verificação Final

### 1. Status do App
- App status: **Healthy** (verde)
- Deployment: **Live**

### 2. Health Check
```bash
curl https://seu-app.ondigitalocean.app/health
# Deve retornar: OK
```

### 3. Logs
Verifique se aparecem as mensagens:
- ✅ Bot conectado
- ✅ Servidor HTTP rodando
- ✅ Tarefa de monitoramento iniciada

### 4. Discord
- Bot deve aparecer online no servidor
- Aguarde CVEs novas para testar notificação

---

## 🆚 Diferença Visível

### Antes (Buildpack):
```
-----> Using Python 3.11 specified in .python-version
-----> Installing dependencies using pip
```

### Agora (Dockerfile):
```
Step 1/9 : FROM python:3.11-slim
Step 2/9 : RUN apt-get update && apt-get install curl
...
Successfully built [image_id]
```

---

## ❌ Troubleshooting

### "Buildpack still being used"
- Destrua o app novamente
- Verifique se o Dockerfile está no root do GitHub
- Ao recriar, certifique-se de clicar em "Use Dockerfile"

### "Build failed"
- Veja build logs para erro específico
- Verifique se todos os arquivos foram commitados
- Confirme que requirements.txt está correto

### "Health check failing"
- Aguarde 1-2 minutos (bot leva tempo para conectar)
- Verifique se PORT=8080 está nas env vars
- Veja runtime logs para erros

### "Bot not connecting to Discord"
- Verifique DISCORD_TOKEN nas env vars
- Confirme que token não expirou
- Regenere token se necessário

---

## 🎯 Próximos Passos

Após deploy bem-sucedido:

1. ✅ Testar health check
2. ✅ Verificar bot online no Discord
3. ✅ Aguardar CVEs novas (ou testar manualmente)
4. ✅ Configurar alertas no DigitalOcean (opcional)
5. ✅ Considerar adicionar NVD_API_KEY

---

## 📞 Suporte

Se algo der errado:
1. Capture screenshot dos logs
2. Verifique se selecionou "Dockerfile" na criação
3. Confirme que variáveis de ambiente estão corretas
4. Me avise para ajudar!

---

**Tempo estimado total**: 5-10 minutos
**Downtime**: Apenas durante o processo de criação
**Custo**: $10/mês (igual ao anterior)
**Benefício**: Controle total via Dockerfile ✅
