# Tarefa Dia 2 - Configuração Ambiente Mark85

## 🎯 Objetivo
Configurar ambiente Mark85 para automação de testes com Robot Framework.

## 📚 Conteúdo Estudado
- **Curso Udemy Robot eXpress**
  - Seção 1: Introdução ✅
  - Seção 2: Configuração ✅
  - Seção 3: Primeiros passos 

## ✅ Atividade Realizada
Configuração completa do ambiente Mark85 incluindo:

### 📁 Estrutura Criada
```
tarefa_dia2/
├── mark85-robot-express/
│   ├── hello.robot       # Primeiro teste
│   ├── mylib.py         # Biblioteca customizada
│   └── logs/            # Resultados execução
└── QAx/App/mark85/
    ├── api/             # Backend API
    └── web/             # Frontend Web
```

## 🔧 Como Configurar o Ambiente

### 1. Pré-requisitos
```bash
# Instalar Node.js e npm
# Instalar Python 3.13
# Instalar Robot Framework
pip install robotframework
pip install robotframework-seleniumlibrary
```

### 2. Configurar API (Backend)
```bash
cd QAx/App/mark85/api
npm install
npm run dev
```

### 3. Configurar Web (Frontend)
```bash
cd QAx/App/mark85/web
npm install
node run dev
```

### 4. Executar Testes Robot
```bash
cd mark85-robot-express
robot hello.robot
```

### 🔧 Componentes Configurados
- **API**: Backend Node.js na porta padrão
- **Web**: Frontend servindo aplicação
- **Robot Framework**: Ambiente de testes funcional
- **Bibliotecas**: SeleniumLibrary e customizadas

## 📊 Status
✅ **CONCLUÍDO** - Ambiente Mark85 configurado e funcional

## 📁 Arquivos
- Configurações de ambiente (.env, package.json)
- Testes iniciais (hello.robot)
- Bibliotecas personalizadas (mylib.py)
- Logs de execução (log.html, report.html)