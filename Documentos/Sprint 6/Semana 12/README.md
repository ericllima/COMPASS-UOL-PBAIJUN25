# Challenge 03 - ServeRest API Testing

## 🎯 Objetivo
Validar endpoints críticos da API ServeRest hospedada na EC2, cobrindo fluxos principais (smoke/CRUD) e cenários negativos essenciais.

## 🌐 Ambiente
- **SUT**: ServeRest na EC2
- **BASE_URL**: http://54.147.59.9:3000
- **Endpoints**: /status, /login, /usuarios, /produtos

## 📁 Estrutura do Projeto
```
tests/
├── suites/
│   ├── health.robot      # Testes de saúde da API
│   ├── login.robot       # Testes de autenticação
│   ├── usuarios.robot    # CRUD de usuários
│   └── produtos.robot    # CRUD de produtos
├── resources/
│   └── keywords.robot    # Keywords reutilizáveis
└── variables.robot       # Configurações centrais
```

## 🚀 Execução dos Testes

### Pré-requisitos
```bash
pip install robotframework robotframework-requests
```

### Executar todos os testes
```bash
robot -d reports tests/suites
```

### Executar por categoria
```bash
# Smoke tests
robot -d reports -i smoke tests/suites

# Testes negativos
robot -d reports -i negativo tests/suites

# Endpoint específico
robot -d reports tests/suites/login.robot
```

## 📋 Casos de Teste Implementados

### Health/Status
- ✅ SRV-health-200-positivo

### Login
- ✅ SRV-login-token-positivo
- ✅ SRV-login-credenciais-invalidas-negativo

### Usuários
- ✅ SRV-usuarios-criar-positivo
- ✅ SRV-usuarios-obter-por-id-positivo
- ✅ SRV-usuarios-atualizar-positivo
- ✅ SRV-usuarios-deletar-positivo
- ✅ SRV-usuarios-criar-email-duplicado-negativo

### Produtos
- ✅ SRV-produtos-criar-positivo
- ✅ SRV-produtos-listar-positivo
- ✅ SRV-produtos-obter-por-id-positivo
- ✅ SRV-produtos-atualizar-positivo
- ✅ SRV-produtos-deletar-positivo
- ✅ SRV-produtos-criar-nome-duplicado-negativo

## 🏷️ Tags Disponíveis
- `smoke` - Testes críticos de funcionalidade básica
- `negativo` - Testes de cenários de erro
- `health` - Testes de saúde da API
- `login` - Testes de autenticação
- `usuarios` - Testes de usuários
- `produtos` - Testes de produtos

## 📊 Estratégia de Execução
- **D1**: Health + Login + Usuários básico
- **D2**: CRUD completo Usuários + Produtos
- **D3**: Cenários negativos + estabilidade
- **D4-D5**: Refinamentos + relatórios finais

## 🔧 Configuração
O arquivo `variables.robot` contém as configurações centrais:
- URL base da EC2
- Headers padrão
- Configuração de sessão HTTP

## 📈 Relatórios
Os relatórios são gerados na pasta `reports/` com:
- `report.html` - Relatório visual
- `log.html` - Log detalhado
- `output.xml` - Dados estruturados