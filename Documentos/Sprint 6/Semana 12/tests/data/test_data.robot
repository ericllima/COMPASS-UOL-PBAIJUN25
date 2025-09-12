*** Variables ***
# Data-driven test data

# Usuários válidos para testes parametrizados
@{USUARIOS_VALIDOS}
...    João Silva|joao@teste.com|senha123|false
...    Maria Santos|maria@teste.com|senha456|true
...    Pedro Costa|pedro@teste.com|senha789|false

# Produtos válidos para testes parametrizados
@{PRODUTOS_VALIDOS}
...    Notebook Dell|2500|Notebook para trabalho|5
...    Mouse Logitech|50|Mouse sem fio|20
...    Teclado Mecânico|200|Teclado para gaming|10

# Configurações de performance
${TIMEOUT_DEFAULT}    10s
${MAX_RESPONSE_TIME}  2.0