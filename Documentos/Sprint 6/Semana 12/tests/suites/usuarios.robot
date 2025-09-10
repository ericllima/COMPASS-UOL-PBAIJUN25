*** Settings ***
Resource    ../variables.robot
Resource    ../resources/keywords.robot
Library     Collections
Library     String
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Variables ***
${USUARIO_ID}    ${EMPTY}

*** Test Cases ***
U001 - Criar usuário válido
    [Tags]    smoke    usuarios    U001
    [Documentation]    Criar usuário com dados válidos deve retornar 201
    ${email}=    Generate Unique Email
    ${nome}=    Generate Unique Name    QA Test
    
    &{usuario_data}=    Create Dictionary
    ...    nome=${nome}
    ...    email=${email}
    ...    password=qateste
    ...    administrador=true
    
    ${resp}=    POST On Session    booker    /usuarios    json=${usuario_data}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    _id
    Dictionary Should Contain Key    ${body}    message
    Set Suite Variable    ${USUARIO_ID}    ${body['_id']}

U006 - Buscar usuário por ID existente
    [Tags]    smoke    usuarios    U006
    [Documentation]    Buscar usuário por ID existente deve retornar 200
    Skip If    '${USUARIO_ID}' == '${EMPTY}'    Usuário não foi criado
    
    ${resp}=    GET On Session    booker    /usuarios/${USUARIO_ID}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    nome
    Dictionary Should Contain Key    ${body}    email
    Dictionary Should Contain Key    ${body}    administrador
    Dictionary Should Contain Key    ${body}    _id

U008 - Listar usuários
    [Tags]    smoke    usuarios    U008
    [Documentation]    Listar usuários deve retornar 200 e lista não vazia
    ${resp}=    GET On Session    booker    /usuarios
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    usuarios
    Dictionary Should Contain Key    ${body}    quantidade
    Should Be True    ${body['quantidade']} >= 1

U009 - Deletar usuário existente
    [Tags]    smoke    usuarios    U009
    [Documentation]    Deletar usuário existente deve retornar 200
    Skip If    '${USUARIO_ID}' == '${EMPTY}'    Usuário não foi criado
    
    ${resp}=    DELETE On Session    booker    /usuarios/${USUARIO_ID}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message

U002 - Impedir e-mail duplicado
    [Tags]    negativo    usuarios    U002
    [Documentation]    Criar usuário com email duplicado deve retornar 400
    ${email}=    Set Variable    duplicado@qa.com
    
    &{usuario_dup1}=    Create Dictionary
    ...    nome=Usuario Duplicado 1
    ...    email=${email}
    ...    password=teste123
    ...    administrador=false
    
    # Criar primeiro usuário
    ${resp1}=    POST On Session    booker    /usuarios    json=${usuario_dup1}
    Should Be Equal As Integers    ${resp1.status_code}    201
    
    # Tentar criar segundo com mesmo email
    &{usuario_dup2}=    Create Dictionary
    ...    nome=Usuario Duplicado 2
    ...    email=${email}
    ...    password=outra123
    ...    administrador=false
    
    ${resp2}=    POST On Session    booker    /usuarios    json=${usuario_dup2}    expected_status=any
    Should Be Equal As Integers    ${resp2.status_code}    400
    ${body}=    Set Variable    ${resp2.json()}
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    já está sendo usado
    
    # Cleanup - deletar usuário criado
    ${user_id}=    Get From Dictionary    ${resp1.json()}    _id
    DELETE On Session    booker    /usuarios/${user_id}

U003 - Bloquear provedores proibidos
    [Tags]    negativo    usuarios    U003
    [Documentation]    Bloquear cadastro com provedores gmail.com e hotmail.com
    # Teste Gmail
    &{usuario_gmail}=    Create Dictionary
    ...    nome=Usuario Gmail
    ...    email=teste@gmail.com
    ...    password=teste123
    ...    administrador=false
    
    ${resp_gmail}=    POST On Session    booker    /usuarios    json=${usuario_gmail}    expected_status=any
    Should Be Equal As Integers    ${resp_gmail.status_code}    400
    ${body_gmail}=    Set Variable    ${resp_gmail.json()}
    Dictionary Should Contain Key    ${body_gmail}    message
    
    # Teste Hotmail
    &{usuario_hotmail}=    Create Dictionary
    ...    nome=Usuario Hotmail
    ...    email=teste@hotmail.com
    ...    password=teste123
    ...    administrador=false
    
    ${resp_hotmail}=    POST On Session    booker    /usuarios    json=${usuario_hotmail}    expected_status=any
    Should Be Equal As Integers    ${resp_hotmail.status_code}    400
    ${body_hotmail}=    Set Variable    ${resp_hotmail.json()}
    Dictionary Should Contain Key    ${body_hotmail}    message

U004 - Validar limites de senha
    [Tags]    negativo    usuarios    U004
    [Documentation]    Validar senha com menos de 5 e mais de 10 caracteres
    ${email}=    Generate Unique Email
    
    # Senha muito curta (4 caracteres)
    &{usuario_senha_curta}=    Create Dictionary
    ...    nome=Usuario Senha Curta
    ...    email=${email}
    ...    password=abcd
    ...    administrador=false
    
    ${resp_curta}=    POST On Session    booker    /usuarios    json=${usuario_senha_curta}    expected_status=any
    Should Be Equal As Integers    ${resp_curta.status_code}    400
    ${body_curta}=    Set Variable    ${resp_curta.json()}
    Dictionary Should Contain Key    ${body_curta}    password
    
    # Senha muito longa (11 caracteres)
    ${email2}=    Generate Unique Email
    &{usuario_senha_longa}=    Create Dictionary
    ...    nome=Usuario Senha Longa
    ...    email=${email2}
    ...    password=abcdefghijk
    ...    administrador=false
    
    ${resp_longa}=    POST On Session    booker    /usuarios    json=${usuario_senha_longa}    expected_status=any
    Should Be Equal As Integers    ${resp_longa.status_code}    400
    ${body_longa}=    Set Variable    ${resp_longa.json()}
    Dictionary Should Contain Key    ${body_longa}    password

U007 - Impedir operações com usuário inexistente
    [Tags]    negativo    usuarios    U007
    [Documentation]    Operações com ID inexistente devem retornar 400
    ${id_inexistente}=    Set Variable    507f1f77bcf86cd799439011
    
    # GET com ID inexistente
    ${resp_get}=    GET On Session    booker    /usuarios/${id_inexistente}    expected_status=any
    Should Be Equal As Integers    ${resp_get.status_code}    400
    ${body_get}=    Set Variable    ${resp_get.json()}
    Dictionary Should Contain Key    ${body_get}    message
    Should Contain    ${body_get['message']}    não encontrado
    
    # DELETE com ID inexistente
    ${resp_del}=    DELETE On Session    booker    /usuarios/${id_inexistente}    expected_status=any
    Should Be Equal As Integers    ${resp_del.status_code}    200
    ${body_del}=    Set Variable    ${resp_del.json()}
    Dictionary Should Contain Key    ${body_del}    message
    Should Contain    ${body_del['message']}    não encontrado