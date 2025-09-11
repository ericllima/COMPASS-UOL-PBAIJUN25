# Challenge 03 - ServeRest API Testing

## 🎯 Objetivo
Validar endpoints críticos da API ServeRest hospedada na EC2, cobrindo fluxos principais (smoke/CRUD) e cenários negativos essenciais.

## 🌐 Ambiente
- **SUT**: ServeRest na EC2
- **BASE_URL**: http://54.242.186.180:3000
- **Endpoints**: /status, /login, /usuarios, /produtos, /carrinhos

## 📁 Estrutura do Projeto
```
tests/
├── suites/
│   ├── health.robot      # Testes de saúde da API
│   ├── login.robot       # Testes de autenticação
│   ├── usuarios.robot    # CRUD de usuários
│   ├── produtos.robot    # CRUD de produtos
│   └── carrinhos.robot   # CRUD de carrinhos
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

## 📊 Resultados Finais

**Taxa de Sucesso:** 80% (24/30 testes)  
**Cobertura:** 4 módulos principais da API ServeRest

### Por Módulo
| Módulo | Testes | Passou | Taxa |
|--------|--------|--------|------|
| Health | 1 | 1 | 100% |
| Login | 6 | 6 | 100% |
| Carrinhos | 6 | 6 | 100% |
| Produtos | 8 | 5 | 62% |
| Usuários | 9 | 6 | 67% |

### Cenários Implementados
- **H001:** Health check
- **L001-L005:** Login e autenticação completa
- **U001-U009:** CRUD usuários (6 sucessos, 3 falhas)
- **P001-P008:** CRUD produtos (5 sucessos, 3 falhas)
- **C001-C006:** CRUD carrinhos (100% sucesso)

## 🏷️ Tags Disponíveis
- `smoke` - Testes críticos de funcionalidade básica
- `negativo` - Testes de cenários de erro
- `health` - Testes de saúde da API
- `login` - Testes de autenticação
- `usuarios` - Testes de usuários
- `produtos` - Testes de produtos
- `carrinhos` - Testes de carrinhos

## 📊 Estratégia de Execução
- **D1**: Health + Login + CRUD Usuários/Produtos ✅
- **D2**: Cenários negativos + Carrinhos ✅
- **D3**: Validações avançadas + Token expirado ✅
- **D4-D5**: Execução final + Relatórios ✅

**Status Final:** 30 cenários implementados, 24 sucessos (80%)

## 📋 Documentação
- **[PROGRESSO_CHALLENGE.md](PROGRESSO_CHALLENGE.md)** - Progresso e resultados finais
- **[docs/PLANO-D1.md](docs/PLANO-D1.md)** - Escopo inicial D1

## 🔧 Configuração
O arquivo `variables.robot` contém as configurações centrais:
- URL base da EC2
- Headers padrão
- Configuração de sessão HTTP

## 📈 Relatórios
Relatório final disponível em `reports/final/`:
- `report.html` - Relatório visual com 30 testes
- `log.html` - Log detalhado da execução
- `output.xml` - Dados estruturados para CI/CD