*** Settings ***
Documentation    Keywords reutilizáveis para ServeRest
Library          RequestsLibrary
Library          Collections
Library          String

*** Keywords ***
Generate Unique Email
    [Documentation]    Gera email único usando UUID
    ${uuid}=    Generate Random String    8    [LETTERS][NUMBERS]
    ${email}=    Set Variable    teste${uuid}@qa.com
    RETURN    ${email}

Generate Unique Name
    [Arguments]    ${prefix}=Teste
    [Documentation]    Gera nome único usando UUID
    ${uuid}=    Generate Random String    8    [LETTERS][NUMBERS]
    ${name}=    Set Variable    ${prefix} ${uuid}
    RETURN    ${name}

Get Valid Auth Token
    [Documentation]    Obtém token de autenticação válido
    &{login_data}=    Create Dictionary    email=admin@serverest.com    password=admin
    ${resp}=    POST On Session    booker    /login    json=${login_data}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${token}=    Get From Dictionary    ${resp.json()}    authorization
    RETURN    ${token}

Create Auth Headers
    [Arguments]    ${token}
    [Documentation]    Cria headers com autenticação
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Authorization=${token}
    RETURN    ${headers}

Create Test User
    [Documentation]    Cria usuário para testes e retorna ID
    ${email}=    Generate Unique Email
    ${name}=    Generate Unique Name    Usuario
    
    &{user_data}=    Create Dictionary
    ...    nome=${name}
    ...    email=${email}
    ...    password=teste123
    ...    administrador=false
    
    ${resp}=    POST On Session    booker    /usuarios    json=${user_data}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${user_id}=    Get From Dictionary    ${resp.json()}    _id
    RETURN    ${user_id}

Delete User If Exists
    [Arguments]    ${user_id}
    [Documentation]    Deleta usuário se existir (teardown idempotente)
    ${resp}=    DELETE On Session    booker    /usuarios/${user_id}    expected_status=any
    Log    User deletion status: ${resp.status_code}

Create Test Product
    [Arguments]    ${token}
    [Documentation]    Cria produto para testes e retorna ID
    ${name}=    Generate Unique Name    Produto
    
    &{product_data}=    Create Dictionary
    ...    nome=${name}
    ...    preco=100
    ...    descricao=Produto para teste automatizado
    ...    quantidade=50
    
    ${headers}=    Create Auth Headers    ${token}
    ${resp}=    POST On Session    booker    /produtos    json=${product_data}    headers=${headers}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${product_id}=    Get From Dictionary    ${resp.json()}    _id
    RETURN    ${product_id}

Delete Product If Exists
    [Arguments]    ${product_id}    ${token}
    [Documentation]    Deleta produto se existir (teardown idempotente)
    ${headers}=    Create Auth Headers    ${token}
    ${resp}=    DELETE On Session    booker    /produtos/${product_id}    headers=${headers}    expected_status=any
    Log    Product deletion status: ${resp.status_code}