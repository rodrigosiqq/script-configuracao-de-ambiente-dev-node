#!/bin/bash

# Este script automatiza a criação de um novo projeto Node.js com TypeScript e Express.

# Função para exibir mensagens de erro e sair
function error_exit {
  echo "$1" 1>&2
  exit 1
}

# Pergunta ao usuário o nome do projeto
read -p "Qual é o nome do seu projeto? (padrão: my-typescript-project): " PROJECT_NAME

# Define o nome do projeto, usando um padrão se o usuário não digitar nada
PROJECT_NAME=${PROJECT_NAME:-my-typescript-project}

# Converte o nome do projeto para kebab-case para o package.json
KEBAB_CASE_PROJECT_NAME=$(echo "$PROJECT_NAME" | tr '[:upper:]' '[:lower:]' | sed 's/[^a-zA-Z0-9]/-/g' | sed 's/^-*//;s/-*$//')

echo "Criando projeto '$PROJECT_NAME' em '$KEBAB_CASE_PROJECT_NAME'..."

# Cria o diretório raiz do projeto
mkdir -p "$KEBAB_CASE_PROJECT_NAME" || error_exit "Falha ao criar o diretório do projeto."
cd "$KEBAB_CASE_PROJECT_NAME" || error_exit "Falha ao entrar no diretório do projeto."

# Cria a estrutura de diretórios
echo "Criando estrutura de diretórios..."
mkdir -p src/Controllers \
         src/Routes \
         src/Controllers \
         src/Services \
         src/Models \
         src/Repositories || error_exit "Falha ao criar diretórios."

# Cria o arquivo package.json
echo "Criando package.json..."
cat << EOF > package.json
{
  "name": "$KEBAB_CASE_PROJECT_NAME",
  "version": "1.0.0",
  "main": "index.js",
  "license": "MIT",
  "scripts": {
    "dist": "tsup src",
    "start:dev": "tsx src/index.ts",
    "start:watch": "tsx watch src/index.ts",
    "start:dist": "yarn run dist && node dist/index.js"
  },
  "dependencies": {
    "express": "^4.19.2"
  },
  "devDependencies": {
    "@types/express": "^4.17.21",
    "tsup": "^8.5.0",
    "tsx": "^4.16.2",
    "typescript": "^5.5.3"
  }
}
EOF
echo "package.json criado."

# Cria o arquivo tsconfig.json
echo "Criando tsconfig.json..."
cat << EOF > tsconfig.json
{
  "compilerOptions": {
    "target": "es2016",
    "module": "commonjs",
    "esModuleInterop": true,
    "forceConsistentCasingInFileNames": true,
    "strict": true,
    "skipLibCheck": true,
    "outDir": "dist"
  }
}
EOF
echo "tsconfig.json criado."

# Cria o arquivo src/index.ts
echo "Criando src/index.ts..."
cat << EOF > src/index.ts
// src/index.ts
// Este é o ponto de entrada principal da sua aplicação Express com TypeScript.

import express from 'express';

const app = express();
const PORT = process.env.PORT || 3000; // Define a porta do servidor, padrão 3000

// Middleware para parsear JSON no corpo das requisições
app.use(express.json());

// Rota de exemplo
app.get('/', (req, res) => {
  res.send('Hello from your TypeScript Express project!');
});

// Inicia o servidor
app.listen(PORT, () => {
  console.log(\`Server is running on http://localhost:\${PORT}\`);
});
EOF
echo "src/index.ts criado."

# Instala as dependências
echo "Instalando dependências (pode levar alguns minutos)..."
npm install || error_exit "Falha ao instalar dependências. Verifique sua conexão com a internet ou se o npm está instalado."

echo "Projeto '$PROJECT_NAME' criado e configurado com sucesso!"
echo "Para iniciar o projeto, entre no diretório '$KEBAB_CASE_PROJECT_NAME' e execute:"
echo "  npm run start:dev"
