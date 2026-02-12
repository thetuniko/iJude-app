#!/bin/bash

# Para o script se der erro em qualquer comando
set -e

echo "🚀 Construindo versão Web..."
# Constrói o site (Ajuste o base-href se necessário)
flutter build web --release --base-href "/iJude-app/"

# Pega o link do repositório atual automaticamente
REPO_URL=$(git remote get-url origin)

echo "📂 Preparando pasta de upload..."
cd build/web

# Cria um repositório temporário apenas para enviar essa pasta
git init
git branch -M main
git remote add origin $REPO_URL

echo "📤 Enviando para o GitHub (Branch gh-pages)..."
git add .
git commit -m "Deploy automático via Script"

# Força o envio para a branch gh-pages
git push -f origin main:gh-pages

# Volta para a pasta raiz
cd ../..

echo "✅ Feito! Em 2 minutos acesse: https://SEU_USUARIO.github.io/iJude-app/"