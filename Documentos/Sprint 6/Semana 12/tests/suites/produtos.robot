*** Settings ***
Resource    ../variables.robot
Library     Collections
Library     String
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Variables ***
${PRODUTO_ID}    ${EMPTY}
${AUTH_TOKEN}    ${EMPTY}

*** Keywords ***
Setup Admin User
    &{admin_user}=    Create Dictionary    nome=QA Test    email=qatest@qa.com.br    password=qateste    administrador=true
    ${resp}=    POST On Session    booker    /usuarios    json=${admin_user}    expected_status=any
    Should Be True    ${resp.status_code} in [201, 400]
    Log    Admin user setup: ${resp.status_code}

Get Auth Token
    Setup Admin User
    &{login_data}=    Create Dictionary    email=qatest@qa.com.br    password=qateste
    ${resp}=    POST On Session    booker    /login    json=${login_data}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${token}=    Get From Dictionary    ${resp.json()}    authorization
    Set Suite Variable    ${AUTH_TOKEN}    ${token}
    RETURN    ${token}

*** Test Cases ***
SRV-produtos-criar-positivo
    [Tags]    smoke    produtos
    [Documentation]    Criar produto com nome único deve retornar 201
    ${token}=    Get Auth Token
    ${uuid}=    Generate Random String    8    [LETTERS][NUMBERS]
    
    &{produto_data}=    Create Dictionary
    ...    nome=Produto Teste ${uuid}
    ...    preco=100
    ...    descricao=Produto para teste automatizado
    ...    quantidade=50
    
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Authorization=${token}
    
    ${resp}=    POST On Session    booker    /produtos    json=${produto_data}    headers=${headers}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    _id
    Set Suite Variable    ${PRODUTO_ID}    ${body['_id']}

SRV-produtos-listar-positivo
    [Tags]    smoke    produtos
    [Documentation]    Listar produtos deve retornar 200 e lista
    ${resp}=    GET On Session    booker    /produtos
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    produtos
    Should Be True    len($body['produtos']) >= 1

SRV-produtos-obter-por-id-positivo
    [Tags]    smoke    produtos
    [Documentation]    Obter produto por ID deve retornar 200
    Skip If    '${PRODUTO_ID}' == '${EMPTY}'    Produto não foi criado
    
    ${resp}=    GET On Session    booker    /produtos/${PRODUTO_ID}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    nome
    Dictionary Should Contain Key    ${body}    preco

SRV-produtos-atualizar-positivo
    [Tags]    smoke    produtos
    [Documentation]    Atualizar produto deve retornar 200
    Skip If    '${PRODUTO_ID}' == '${EMPTY}'    Produto não foi criado
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    ${uuid}=    Generate Random String    8    [LETTERS][NUMBERS]
    &{produto_update}=    Create Dictionary
    ...    nome=Produto Atualizado ${uuid}
    ...    preco=150
    ...    descricao=Produto atualizado por teste
    ...    quantidade=30
    
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Authorization=${AUTH_TOKEN}
    
    ${resp}=    PUT On Session    booker    /produtos/${PRODUTO_ID}    json=${produto_update}    headers=${headers}
    Should Be Equal As Integers    ${resp.status_code}    200

SRV-produtos-deletar-positivo
    [Tags]    smoke    produtos
    [Documentation]    Deletar produto deve retornar 200
    Skip If    '${PRODUTO_ID}' == '${EMPTY}'    Produto não foi criado
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Authorization=${AUTH_TOKEN}
    
    ${resp}=    DELETE On Session    booker    /produtos/${PRODUTO_ID}    headers=${headers}
    Should Be True    ${resp.status_code} in [200, 204]

SRV-produtos-criar-nome-duplicado-negativo
    [Tags]    negativo    produtos
    [Documentation]    Criar produto com nome duplicado deve retornar erro
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    &{produto_dup}=    Create Dictionary
    ...    nome=Produto Duplicado Teste
    ...    preco=200
    ...    descricao=Produto para teste de duplicidade
    ...    quantidade=10
    
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Authorization=${AUTH_TOKEN}
    
    # Criar primeiro produto
    ${resp1}=    POST On Session    booker    /produtos    json=${produto_dup}    headers=${headers}
    Should Be Equal As Integers    ${resp1.status_code}    201
    
    # Tentar criar segundo com mesmo nome
    ${resp2}=    POST On Session    booker    /produtos    json=${produto_dup}    headers=${headers}    expected_status=any
    Should Be True    ${resp2.status_code} in [400, 409]
    ${body}=    Set Variable    ${resp2.json()}
    Dictionary Should Contain Key    ${body}    message
    
    # Cleanup - deletar produto criado
    ${produto_id}=    Get From Dictionary    ${resp1.json()}    _id
    DELETE On Session    booker    /produtos/${produto_id}    headers=${headers}