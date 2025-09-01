# Semana 10 — Testes de API (Restful-Booker + Robot Framework)

Suíte de testes automatizados de **API REST** usando **Robot Framework** e **RequestsLibrary** contra a API pública **Restful-Booker**.


---

## Estrutura do projeto
```
Documentos/
└─ Sprint 5/
    └─ Semana 10/
        ├─ resources/
        │ ├─ variables.robot
        │ ├─ test_data.robot
        │ └─ keywords.robot
        └─ tests/
            └─ restful_booker_suite.robot
```

---

1) Criar e ativar a virtualenv
```
python -m venv .venv
```
```
.venv\Scripts\Activate
```

2) Instalar dependências
```
python -m pip install -U pip
```
```
pip install robotframework robotframework-requests
```

3) Entrar na pasta do projeto

```powershell
cd "Documentos/Sprint 5/Semana 10"
```

4) Executar os testes

```
robot -d results tests
```
