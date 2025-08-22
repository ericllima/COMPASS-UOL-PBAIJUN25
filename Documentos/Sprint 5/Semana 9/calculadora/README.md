# Calculadora – Python + TDD

Projeto de uma calculadora em **Python** desenvolvida com **TDD**.

## 🚀 Funcionalidades
- `soma(a,b)` → soma dois números
- `sub(a,b)` → subtrai
- `mult(a,b)` → multiplica
- `div(a,b)` → divide (erro se `b == 0`)
- `potencia(a,b)` → `a ** b`
- `resto(a,b)` → `a % b` (erro se `b == 0`)

## 🧪 Cenários de Teste
- **Identidades**: `soma(a,0)=a`, `mult(a,1)=a`, `mult(a,0)=0`
- **Negativos**: divisão e resto com sinais
- **Floats**: `div(1,3) ≈ 0.333...`
- **Propriedades**: soma/mult comutativas; sub/div não comutativas
- **Potência**: expoente zero e negativo; `0**0 = 1` (Python)
- **Erros esperados**: divisão/resto por zero → `ValueError`
- **Grandes números**: `10**6 * 10**6 = 10**12`

## ▶️ Executar testes
```bash
pip install pytest
pytest -q
