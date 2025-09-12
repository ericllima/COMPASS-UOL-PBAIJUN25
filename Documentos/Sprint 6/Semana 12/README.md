# Challenge 03 - ServeRest API Testing
## Sprint 6 - Semana 12 - Robot Framework Automation

## 🎯 Objetivo
Validar endpoints críticos da API ServeRest através de automação completa com Robot Framework, cobrindo fluxos principais (CRUD), cenários negativos, integração end-to-end e testes data-driven.

## 🌐 Ambiente de Testes
- **SUT Principal**: ServeRest na EC2 AWS (usado durante desenvolvimento)
- **BASE_URL Atual**: http://98.88.16.61:3000
- **Alternativa Pública**: https://serverest.dev/ (sempre disponível)
- **Endpoints**: /status, /login, /usuarios, /produtos, /carrinhos

> **Nota:** Os testes foram desenvolvidos e executados contra uma instância EC2 AWS dedicada. Para execução contínua, recomenda-se usar https://serverest.dev/ alterando apenas a variável `${BASE_URL}` no arquivo `variables.robot`.

## 📁 Estrutura do Projeto
```
tests/
├── suites/
│   ├── health.robot        # Health checks e performance (2 cenários)
│   ├── login.robot         # Autenticação e tokens (6 cenários)
│   ├── usuarios.robot      # CRUD usuários completo (9 cenários)
│   ├── produtos.robot      # CRUD produtos com auth (8 cenários)
│   ├── carrinhos.robot     # CRUD carrinhos e estoque (6 cenários)
│   ├── integracao.robot    # Fluxos end-to-end (3 cenários)
│   └── data_driven.robot   # Testes parametrizados (3 cenários)
├── resources/
│   └── keywords.robot      # 20+ keywords reutilizáveis
├── data/
│   └── test_data.robot     # Datasets para testes data-driven
├── variables.robot         # Configurações centrais
└── reports/                # Relatórios HTML/XML gerados
```

## 🚀 Execução dos Testes

### Pré-requisitos
```bash
pip install robotframework robotframework-requests
```

### Execução Local
```bash
# Todos os testes (37 cenários)
robot --outputdir reports tests/

# Por suíte específica
robot tests/suites/usuarios.robot
robot tests/suites/carrinhos.robot

# Com relatório customizado
robot --outputdir reports --name "ServeRest_API_Tests" tests/
```

### Execução Remota (EC2)
```bash
# Clonar repositório
git clone https://github.com/ericllima/COMPASS-UOL-PBAIJUN25.git
cd COMPASS-UOL-PBAIJUN25/Documentos/Sprint\ 6/Semana\ 12/tests/

# Executar
robot .
```

## 📊 Resultados Finais

**Taxa de Sucesso:** 89% (33/37 testes) ✅  
**Cobertura:** 7 módulos completos da API ServeRest  
**Status:** Challenge 03 concluído com excelência

### Por Módulo
| Módulo | Testes | Passou | Taxa | Status |
|--------|--------|--------|------|--------|
| **Health** | 2 | 2 | 100% | ✅ Completo |
| **Login** | 6 | 6 | 100% | ✅ Completo |
| **Carrinhos** | 6 | 6 | 100% | ✅ Completo |
| **Integração** | 3 | 3 | 100% | ✅ Completo |
| **Data-driven** | 3 | 3 | 100% | ✅ Completo |
| **Produtos** | 8 | 6 | 75% | ⚠️ 2 falhas API |
| **Usuários** | 9 | 7 | 78% | ⚠️ 2 falhas API |

### Cenários Implementados (37 total)
- **H001-H002:** Health check e performance
- **L001-L006:** Login, autenticação e tokens completo
- **U001-U009:** CRUD usuários com validações (7 sucessos, 2 falhas)
- **P001-P008:** CRUD produtos com autenticação (6 sucessos, 2 falhas)
- **C001-C006:** CRUD carrinhos e gestão de estoque (100% sucesso)
- **I001-I003:** Testes de integração end-to-end (100% sucesso)
- **DD001-DD003:** Testes data-driven parametrizados (100% sucesso)

## 🏷️ Tags e Execução Seletiva
```bash
# Por módulo
robot -i health tests/          # Health checks
robot -i login tests/           # Autenticação
robot -i usuarios tests/        # CRUD usuários
robot -i produtos tests/        # CRUD produtos
robot -i carrinhos tests/       # CRUD carrinhos
robot -i integracao tests/      # Fluxos end-to-end
robot -i datadriven tests/      # Testes parametrizados

# Por tipo
robot -i smoke tests/           # Testes críticos
robot -i negativo tests/        # Cenários de erro
robot -i crud tests/            # Operações CRUD
```

## 📊 Cronograma de Execução (Concluído)
- **D1 (09/12)**: Setup + CRUD base → 23 cenários (100%) ✅
- **D2 (10/12)**: Carrinhos implementado → 29 cenários (83%) ✅
- **D3 (11/12)**: Correções + Keywords → 29 cenários (86%) ✅
- **D4 (12/12)**: Integração + Data-driven → 37 cenários (89%) ✅
- **D5 (13/12)**: Documentação final → 37 cenários (89%) ✅

**Status Final:** 37 cenários implementados, 33 sucessos (89%) - **Challenge concluído!**

## 📋 Documentação
- **[docs/PROGRESSO_CHALLENGE.md](docs/PROGRESSO_CHALLENGE.md)** - Progresso completo do Challenge 03
- **[docs/Plano de Teste - Serverest - Sprint 6.pdf](docs/Plano%20de%20Teste%20-%20Serverest%20-%20Sprint%206.pdf)** - Plano de testes em PDF

## 🔧 Configuração Flexível
### Para usar instância EC2:
```robot
${BASE_URL}    http://98.88.16.61:3000
```

### Para usar ServeRest público:
```robot
${BASE_URL}    https://serverest.dev
```

## 📈 Relatórios e Evidências
Relatórios disponíveis em `reports/`:
- **`report.html`** - Relatório visual interativo (37 testes)
- **`log.html`** - Log detalhado com requests/responses
- **`output.xml`** - Dados estruturados para integração CI/CD

## 🏆 Conquistas do Challenge
- ✅ **115% do planejado** (37/32 cenários)
- ✅ **89% taxa de sucesso** alcançada
- ✅ **7 módulos funcionais** implementados
- ✅ **20+ keywords reutilizáveis** desenvolvidas
- ✅ **Documentação completa** entregue
- ✅ **Execução remota** configurada (EC2)

**Challenge 03 - Sprint 6 - Semana 12: CONCLUÍDO COM EXCELÊNCIA! 🎯**