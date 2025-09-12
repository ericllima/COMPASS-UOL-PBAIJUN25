*** Settings ***
Resource    ../variables.robot
Resource    ../resources/keywords.robot
Library     Collections
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Variables ***
&{LOGIN_VAL}    email=qatest@qa.com.br    password=qateste
&{LOGIN_INV}    email=qatest@qa.com.br    password=senhaerrada
&{ADMIN_USER}   nome=QA Test    email=qatest@qa.com.br    password=qateste    administrador=true
${AUTH_TOKEN}   ${EMPTY}

*** Test Cases ***
Setup Admin User
    [Tags]    setup
    [Documentation]    Criar usuário admin para testes
    ${resp}=    POST On Session    booker    /usuarios    json=${ADMIN_USER}    expected_status=any
    # Se já existe (400), tudo bem. Se criou (201), também ok.
    Should Be True    ${resp.status_code} in [201, 400]
    Log    Admin user setup: ${resp.status_code}

L001 - Autenticar com credenciais válidas
    [Tags]    smoke    login    L001
    [Documentation]    Login válido deve retornar token Bearer com validade 10 min
    ${resp}=    POST On Session    booker    /login    json=${LOGIN_VAL}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    authorization
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    Login realizado com sucesso
    # Verificar formato do token Bearer
    Should Start With    ${body['authorization']}    Bearer
    Set Suite Variable    ${AUTH_TOKEN}    ${body['authorization']}

L002 - Recusar usuário não cadastrado
    [Tags]    negativo    login    L002
    [Documentation]    Login com email inexistente deve retornar 401
    &{login_inexistente}=    Create Dictionary
    ...    email=inexistente@qa.com
    ...    password=qualquersenha
    
    ${resp}=    POST On Session    booker    /login    json=${login_inexistente}    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    401
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    Email e/ou senha inválidos

L003 - Recusar senha inválida
    [Tags]    negativo    login    L003
    [Documentation]    Login com senha errada deve retornar 401
    ${resp}=    POST On Session    booker    /login    json=${LOGIN_INV}    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    401
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    Email e/ou senha inválidos

L004 - Usar token em rota protegida
    [Tags]    smoke    login    L004
    [Documentation]    Token válido deve permitir acesso a rotas protegidas
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não foi gerado
    
    ${nome}=    Generate Unique Name    Produto Auth Test
    &{produto_data}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=100
    ...    descricao=Teste de autenticação
    ...    quantidade=10
    
    ${headers}=    Create Auth Headers    ${AUTH_TOKEN}
    ${resp}=    POST On Session    booker    /produtos    json=${produto_data}    headers=${headers}
    Should Be Equal As Integers    ${resp.status_code}    201
    
    # Cleanup
    ${produto_id}=    Get From Dictionary    ${resp.json()}    _id
    DELETE On Session    booker    /produtos/${produto_id}    headers=${headers}

L005 - Token expirado
    [Tags]    negativo    login    L005
    [Documentation]    Token expirado deve retornar 401 (simulação)
    # Nota: Teste de expiração real requer aguardar 10 minutos
    # Este teste simula com token inválido
    ${token_invalido}=    Set Variable    Bearer tokeninvalidoparateste
    
    ${nome}=    Generate Unique Name    Produto Token Expirado
    &{produto_data}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=100
    ...    descricao=Teste token expirado
    ...    quantidade=10
    
    &{headers}=    Create Dictionary
    ...    Content-Type=application/json
    ...    Accept=application/json
    ...    Authorization=${token_invalido}
    
    ${resp}=    POST On Session    booker    /produtos    json=${produto_data}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    401
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    Token de acesso ausente, inválido, expirado ou usuário do token não existe mais