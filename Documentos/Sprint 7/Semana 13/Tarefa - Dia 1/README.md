# Mapeamento de Elementos - Amazon Brasil

## 🎯 Estratégias de Mapeamento Implementadas

### 1. **ID Selector** (Mais Estável)
**Elemento**: Campo de busca  
**Locator**: `id:twotabsearchtextbox`  
**Por quê**: IDs são únicos e raramente mudam

### 2. **CSS com Classes**
**Elemento**: Carrinho  
**Locator**: `id:nav-cart`  
**Por quê**: Classes específicas são performáticas

### 3. **XPath por Texto**
**Elemento**: Link "Livros"  
**Locator**: `xpath://a[contains(text(),'Livros')]`  
**Por quê**: Flexível mas sensível a mudanças de idioma

### 4. **Data Attributes**
**Elemento**: Cards de produto  
**Locator**: `css:[data-asin]:not([data-asin=""])`  
**Por quê**: Atributos data são estáveis em SPAs

### 5. **CSS Hierárquico**
**Elemento**: Logo no header  
**Locator**: `css:.nav-logo-base`  
**Por quê**: Navegação por estrutura é resiliente

## 🔧 Implementação
Ver arquivo: `mapeamento.robot`

## 📊 Resultados dos Testes
- **Total**: 5 testes
- **Passou**: 4 ✅
- **Falhou**: 1 ❌
- **Taxa de Sucesso**: 80%

### Estratégias Validadas
1. ✅ **ID Selector** - Campo de busca
2. ✅ **CSS Classes** - Carrinho
3. ✅ **XPath Texto** - Link "Livros"
4. ✅ **Data Attributes** - Cards de produto
5. ❌ **CSS Hierárquico** - Logo (seletor precisa ajuste)

### Arquivos de Resultado
- `resultados/log.html` - Log detalhado
- `resultados/report.html` - Relatório visual
- `resultados/output.xml` - Dados estruturados