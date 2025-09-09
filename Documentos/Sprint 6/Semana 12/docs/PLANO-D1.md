# PLANO D1 - Challenge 03 ServeRest

## Escopo Mínimo do Dia 1
- Planejamento revisado (curto)
- QAlity criado (Plano + Ciclo D1 + 8–12 casos base)
- Robot "de pé" com 2 testes: health e login (feliz)

## Endpoints Foco
- **Login**: `/login` (POST)
- **Usuários**: `/usuarios` (GET, POST, PUT, DELETE)
- **Produtos**: `/produtos` (GET, POST, PUT, DELETE)
- **Health**: `/status` (GET)

## Riscos/Lacunas Conhecidas
- Dependência do ServeRest rodando (localhost:3000)
- Dados de seed podem variar
- Necessidade de token válido para operações autenticadas
- Possível instabilidade de ambiente local

## Critérios do Smoke (Automação)
- Health check deve retornar 200
- Login válido deve retornar token
- Criação de usuário deve funcionar
- Listagem de produtos deve retornar dados
- Operações básicas CRUD funcionais

## Casos Base (8-12)
1. Health check - status 200
2. Login válido - retorna token
3. Login inválido - retorna erro
4. Criar usuário - sucesso
5. Listar usuários - retorna lista
6. Obter usuário por ID - retorna dados
7. Criar produto - sucesso (com auth)
8. Listar produtos - retorna lista
9. Obter produto por ID - retorna dados
10. Atualizar usuário - sucesso (com auth)
11. Deletar usuário - sucesso (com auth)
12. Deletar produto - sucesso (com auth)