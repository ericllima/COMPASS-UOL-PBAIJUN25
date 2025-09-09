*** Settings ***
Resource    ../variables.robot
Library     Collections
Library     String
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Variables ***
${USUARIO_ID}    ${EMPTY}

*** Test Cases ***
SRV-usuarios-criar-positivo
    [Tags]    smoke    usuarios
    [Documentation]    Criar usuário com email único deve retornar 201
    ${uuid}=    Generate Random String    8    [LETTERS][NUMBERS]
    &{usuario_data}=    Create Dictionary
    ...    nome=Usuario Teste ${uuid}
    ...    email=teste${uuid}@qa.com
    ...    password=teste123
    ...    administrador=true
    
    ${resp}=    POST On Session    booker    /usuarios    json=${usuario_data}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    _id
    Set Suite Variable    ${USUARIO_ID}    ${body['_id']}

SRV-usuarios-obter-por-id-positivo
    [Tags]    smoke    usuarios
    [Documentation]    Obter usuário por ID deve retornar 200
    Skip If    '${USUARIO_ID}' == '${EMPTY}'    Usuário não foi criado
    
    ${resp}=    GET On Session    booker    /usuarios/${USUARIO_ID}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    nome
    Dictionary Should Contain Key    ${body}    email

SRV-usuarios-atualizar-positivo
    [Tags]    smoke    usuarios
    [Documentation]    Atualizar usuário deve retornar 200
    Skip If    '${USUARIO_ID}' == '${EMPTY}'    Usuário não foi criado
    
    ${uuid}=    Generate Random String    8    [LETTERS][NUMBERS]
    &{usuario_update}=    Create Dictionary
    ...    nome=Usuario Atualizado ${uuid}
    ...    email=atualizado${uuid}@qa.com
    ...    password=nova123
    ...    administrador=true
    
    ${resp}=    PUT On Session    booker    /usuarios/${USUARIO_ID}    json=${usuario_update}
    Should Be Equal As Integers    ${resp.status_code}    200

SRV-usuarios-deletar-positivo
    [Tags]    smoke    usuarios
    [Documentation]    Deletar usuário deve retornar 200
    Skip If    '${USUARIO_ID}' == '${EMPTY}'    Usuário não foi criado
    
    ${resp}=    DELETE On Session    booker    /usuarios/${USUARIO_ID}
    Should Be True    ${resp.status_code} in [200, 204]

SRV-usuarios-criar-email-duplicado-negativo
    [Tags]    negativo    usuarios
    [Documentation]    Criar usuário com email duplicado deve retornar erro
    &{usuario_dup1}=    Create Dictionary
    ...    nome=Usuario Duplicado 1
    ...    email=duplicado@qa.com
    ...    password=teste123
    ...    administrador=false
    
    # Criar primeiro usuário
    ${resp1}=    POST On Session    booker    /usuarios    json=${usuario_dup1}
    Should Be Equal As Integers    ${resp1.status_code}    201
    
    # Tentar criar segundo com mesmo email
    &{usuario_dup2}=    Create Dictionary
    ...    nome=Usuario Duplicado 2
    ...    email=duplicado@qa.com
    ...    password=outra123
    ...    administrador=false
    
    ${resp2}=    POST On Session    booker    /usuarios    json=${usuario_dup2}    expected_status=any
    Should Be True    ${resp2.status_code} in [400, 409]
    ${body}=    Set Variable    ${resp2.json()}
    Dictionary Should Contain Key    ${body}    message
    
    # Cleanup - deletar usuário criado
    ${user_id}=    Get From Dictionary    ${resp1.json()}    _id
    DELETE On Session    booker    /usuarios/${user_id}