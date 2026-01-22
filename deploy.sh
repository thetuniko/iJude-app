#!/bin/bash

echo "🚀 Construindo versão Web..."
dart pub global run peanut --extra-args "--base-href=/iJude-app/"

echo "📤 Enviando para o GitHub..."
git push origin gh-pages

echo "✅ Feito! Em 2 min estará no ar."