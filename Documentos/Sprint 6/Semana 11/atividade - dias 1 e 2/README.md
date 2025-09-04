# Semana 11 — Testes de API (Restful-Booker + Robot Framework)

Suíte de testes automatizados de **API REST** usando **Robot Framework** e **RequestsLibrary** contra a API pública **Restful-Booker**.

## 🏗️ Estrutura do Projeto (Service Actions Pattern)
```
atividade - dias 1 e 2/
├─ services/                   # Camada de Serviços (API calls)
│  ├─ auth_service.robot       # Serviços de autenticação
│  ├─ booking_service.robot    # Serviços de booking
│  └─ health_service.robot     # Serviços de health check
├─ actions/                    # Camada de Ações (Business Logic)
│  ├─ auth_actions.robot       # Ações de autenticação
│  └─ booking_actions.robot    # Ações de booking
├─ libraries/                  # Bibliotecas Python Customizadas
│  └─ BookingUtils.py          # Utilitários para booking
├─ resources/
│  ├─ variables.robot          # Variáveis centralizadas
│  ├─ test_data.robot          # Dados de teste em Robot
│  ├─ keywords.robot           # Keywords reutilizáveis
│  ├─ test_data.json           # Dados válidos em JSON
│  ├─ negative_test_data.json  # Cenários negativos
│  └─ search_filters.json      # Filtros de busca
├─ tests/
│  ├─ service_smoke_tests.robot    # Testes básicos (Service Actions)
│  ├─ service_crud_tests.robot     # CRUD (Service Actions)
│  ├─ service_negative_tests.robot # Negativos (Service Actions)
│  ├─ service_python_tests.robot   # Service Actions + Python
│  ├─ python_library_tests.robot   # Testes da biblioteca Python
│  ├─ smoke_tests.robot        # Testes básicos (Legacy)
│  ├─ crud_tests.robot         # Operações CRUD (Legacy)
│  ├─ negative_tests.robot     # Testes negativos (Legacy)
│  ├─ search_tests.robot       # Testes de busca (Legacy)
│  └─ restful_booker_tests.robot # Suite completa (Legacy)
├─ run_tests.bat              # Script de execução
└─ README.md
```

## 🎯 Arquitetura Service Actions

**Services Layer (Camada de Serviços):**
- Responsável pelas chamadas diretas à API
- Contém apenas requisições HTTP e logs básicos
- Não contém lógica de negócio ou validações

**Actions Layer (Camada de Ações):**
- Contém a lógica de negócio de alto nível
- Combina múltiplas chamadas de serviço quando necessário
- Inclui validações e tratamento de dados

**Tests Layer (Camada de Testes):**
- Utiliza Actions para cenários de negócio
- Foca na validação de comportamentos esperados
- Mantém testes limpos e legíveis

**Libraries Layer (Bibliotecas Python):**
- Extensões customizadas para Robot Framework
- Utilitários específicos do domínio de negócio
- Funções complexas em Python para reutilização

## 🚀 Configuração e Execução

### 1) Ambiente Virtual
```bash
python -m venv .venv
.venv\Scripts\Activate
```

### 2) Dependências
```bash
pip install robotframework robotframework-requests
```

### 3) Execução dos Testes

**Executar todos os testes:**
```bash
robot -d results tests
```

**Executar por categoria:**
```bash
# Service Actions Tests
robot -d results -i service tests

# Testes básicos
robot -d results -i smoke tests

# Operações CRUD
robot -d results -i crud tests

# Testes negativos
robot -d results -i negative tests

# Testes de busca
robot -d results -i search tests

# Testes com biblioteca Python
robot -d results -i python tests
```

**Usar script automatizado:**
```bash
run_tests.bat
```

## 🏷️ Tags Disponíveis

**Por Funcionalidade:**
- `smoke` - Testes básicos
- `crud` - Operações CRUD
- `auth` - Autenticação
- `search` - Funcionalidades de busca
- `python` - Testes com biblioteca Python
- `library` - Testes de biblioteca customizada

**Por Método HTTP:**
- `GET`, `POST`, `PUT`, `PATCH`, `DELETE`

**Por Tipo:**
- `positive` - Cenários de sucesso
- `negative` - Cenários de erro
- `security` - Testes de segurança
- `validation` - Validação de dados

## 📊 Relatórios
Os relatórios são gerados na pasta `results/` com:
- `report.html` - Relatório detalhado
- `log.html` - Log de execução
- `output.xml` - Dados estruturados
