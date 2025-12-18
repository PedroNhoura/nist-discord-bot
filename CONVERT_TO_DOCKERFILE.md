# 🔧 Converter App Platform para Usar Dockerfile

## Situação Atual
- ✅ App rodando com **buildpack** (cria container automaticamente)
- 🎯 Objetivo: Usar **Dockerfile customizado**

---

## 📋 Opção 1: Destroy e Recriar (RECOMENDADO)

### Vantagens:
- ✅ Mais simples
- ✅ Interface visual
- ✅ Limpo e claro

### Passos:

#### 1. Salvar Configurações Atuais
```
DISCORD_TOKEN = [seu_token]
DISCORD_CHANNEL_ID = 1451316595661209642
```

#### 2. Destruir App Atual
1. Settings (aba lateral)
2. Scroll até o final
3. **Destroy Component** → Confirmar

#### 3. Criar Novo App
1. Apps → **Create App**
2. Choose Source → **GitHub**
3. Selecione: `PedroNhoura/nist-discord-bot`
4. Branch: `main`

#### 4. ⚠️ IMPORTANTE - Escolher Build Strategy
Quando o DigitalOcean detectar o repo, você verá:

```
🐳 Dockerfile detected
🐍 Python buildpack detected

Which would you like to use?
[ ] Dockerfile  ← SELECIONE ESTA
[ ] Buildpack
```

**Clique em: Use Dockerfile**

#### 5. Configurar Resources
- Name: `nist-discord-bot`
- Type: **Web Service**
- Instance Size: `apps-s-1vcpu-1gb-fixed` ($10/mo)
- HTTP Port: `8080`

#### 6. Environment Variables
Adicione novamente:
```
DISCORD_TOKEN = [seu_token]
DISCORD_CHANNEL_ID = 1451316595661209642
NVD_API_KEY = [opcional]
```

#### 7. Deploy
- Clique **Create App**
- Aguarde build e deploy

#### 8. Verificar
Logs devem mostrar:
```
Step 1/8 : FROM python:3.11-slim
Step 2/8 : WORKDIR /app
...
Successfully built [image_id]
Bot conectado como NIST#0073
Servidor HTTP rodando na porta 8080
```

---

## 📋 Opção 2: Usar App Spec (Sem Destruir)

### Vantagens:
- ✅ Não perde histórico
- ✅ Sem downtime longo

### Passos:

#### 1. Criar App Spec
Arquivo já criado em: `.do/app.yaml`

#### 2. Commit e Push
```bash
git add .do/app.yaml
git commit -m "Add app spec to force Dockerfile usage"
git push origin main
```

#### 3. Aplicar App Spec
No DigitalOcean:
1. Settings → General
2. Scroll até **App Spec**
3. Clique **Edit**
4. Cole o conteúdo de `.do/app.yaml`
5. Salve

#### 4. Forçar Redeploy
1. Actions → **Force Rebuild and Deploy**

**PROBLEMA**: Nem sempre funciona, pode continuar usando buildpack. Por isso **Opção 1 é mais garantida**.

---

## 📋 Opção 3: Usar Droplet + Docker (Controle Total)

### Para múltiplos bots no futuro:

Já criei:
- ✅ `docker-compose.yml`
- ✅ `DEPLOY_DROPLET.md`
- ✅ `deploy-droplet.sh`

### Custo:
- **Droplet**: $6/mês (pode rodar 3-5 bots)
- **App Platform**: $10/mês por app

### Criar Droplet:
1. DigitalOcean → Droplets → **Create Droplet**
2. Ubuntu 22.04 + Docker
3. Basic $6/mês
4. Adicione SSH key
5. Crie

### Deploy:
```bash
./deploy-droplet.sh [IP_DO_DROPLET]
```

Ou manual (veja `DEPLOY_DROPLET.md`)

---

## 🆚 Comparação Final

| Feature | App Platform (Buildpack) | App Platform (Dockerfile) | Droplet + Docker |
|---------|--------------------------|---------------------------|------------------|
| **Usa Container** | ✅ Sim (automático) | ✅ Sim (seu Dockerfile) | ✅ Sim (controle total) |
| **Controle** | ⚠️ Limitado | ⭐ Médio | 🎯 Total |
| **Custo** | $10/bot | $10/bot | $6 para vários |
| **Complexidade** | Fácil | Fácil | Médio |
| **Setup** | Automático | Automático | Manual |
| **Múltiplos bots** | $10 cada | $10 cada | Incluídos |

---

## 💡 Minha Recomendação

### Cenário 1: Apenas este bot
- ✅ **App Platform com Dockerfile** (Opção 1)
- Motivo: Simples, gerenciado, usa seu Dockerfile

### Cenário 2: 2+ bots planejados
- ✅ **Droplet + Docker Compose**
- Motivo: Mais barato, controle total, escalável

### Cenário 3: Funciona bem como está
- ✅ **Deixar buildpack atual**
- Motivo: JÁ está em container, funcionando perfeitamente

---

## ❓ FAQ

**P: O buildpack usa container?**
R: SIM! Buildpack cria um container automaticamente. Você já está containerizado.

**P: Por que usar Dockerfile então?**
R: Controle total: versão exata do Python, dependências de sistema, otimizações.

**P: Preciso destruir?**
R: Para garantir que use Dockerfile: SIM. App Spec pode não funcionar sempre.

**P: Vou perder dados?**
R: Não se reconfigurar as env vars. O `last_cve.txt` recomeça (normal).

---

## 🚀 Próximo Passo

Escolha sua opção e me avise! Posso ajudar com:
- ✅ Destruir e recriar com Dockerfile
- ✅ Setup de Droplet com Docker Compose
- ✅ Manter atual (já funciona!)
