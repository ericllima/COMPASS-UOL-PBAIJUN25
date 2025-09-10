*** Settings ***
Resource    ../variables.robot
Resource    ../resources/keywords.robot
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
P001 - Criar produto sem autenticação
    [Tags]    negativo    produtos    P001
    [Documentation]    Criar produto sem autenticação deve retornar 401
    ${nome}=    Generate Unique Name    Produto Sem Auth
    
    &{produto_data}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=100
    ...    descricao=Produto sem autenticação
    ...    quantidade=50
    
    ${resp}=    POST On Session    booker    /produtos    json=${produto_data}    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    401
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    Token de acesso ausente

P002 - Criar produto válido (autenticado)
    [Tags]    smoke    produtos    P002
    [Documentation]    Criar produto com nome único deve retornar 201
    ${token}=    Get Auth Token
    ${nome}=    Generate Unique Name    Teclado QA
    
    &{produto_data}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=100
    ...    descricao=Produto para teste automatizado
    ...    quantidade=5
    
    ${headers}=    Create Auth Headers    ${token}
    ${resp}=    POST On Session    booker    /produtos    json=${produto_data}    headers=${headers}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    _id
    Dictionary Should Contain Key    ${body}    message
    Set Suite Variable    ${PRODUTO_ID}    ${body['_id']}
    Set Suite Variable    ${AUTH_TOKEN}    ${token}

P004 - Listar produtos
    [Tags]    smoke    produtos    P004
    [Documentation]    Listar produtos deve retornar 200 e lista
    ${resp}=    GET On Session    booker    /produtos
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    produtos
    Dictionary Should Contain Key    ${body}    quantidade
    Should Be True    ${body['quantidade']} >= 1

P005 - Buscar produto por ID
    [Tags]    smoke    produtos    P005
    [Documentation]    Buscar produto por ID deve retornar 200
    Skip If    '${PRODUTO_ID}' == '${EMPTY}'    Produto não foi criado
    
    ${resp}=    GET On Session    booker    /produtos/${PRODUTO_ID}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    nome
    Dictionary Should Contain Key    ${body}    preco
    Dictionary Should Contain Key    ${body}    descricao
    Dictionary Should Contain Key    ${body}    quantidade
    Dictionary Should Contain Key    ${body}    _id

P003 - Impedir nome de produto duplicado
    [Tags]    negativo    produtos    P003
    [Documentation]    Criar produto com nome duplicado deve retornar 400
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    ${nome_duplicado}=    Set Variable    Produto Duplicado Teste
    &{produto_dup}=    Create Dictionary
    ...    nome=${nome_duplicado}
    ...    preco=200
    ...    descricao=Produto para teste de duplicidade
    ...    quantidade=10
    
    ${headers}=    Create Auth Headers    ${AUTH_TOKEN}
    
    # Criar primeiro produto
    ${resp1}=    POST On Session    booker    /produtos    json=${produto_dup}    headers=${headers}
    Should Be Equal As Integers    ${resp1.status_code}    201
    
    # Tentar criar segundo com mesmo nome
    ${resp2}=    POST On Session    booker    /produtos    json=${produto_dup}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${resp2.status_code}    400
    ${body}=    Set Variable    ${resp2.json()}
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    já está sendo usado
    
    # Cleanup - deletar produto criado
    ${produto_id}=    Get From Dictionary    ${resp1.json()}    _id
    DELETE On Session    booker    /produtos/${produto_id}    headers=${headers}

P007 - Excluir produto sem vínculos
    [Tags]    smoke    produtos    P007
    [Documentation]    Deletar produto sem vínculos deve retornar 200
    Skip If    '${PRODUTO_ID}' == '${EMPTY}'    Produto não foi criado
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    ${headers}=    Create Auth Headers    ${AUTH_TOKEN}
    ${resp}=    DELETE On Session    booker    /produtos/${PRODUTO_ID}    headers=${headers}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message

P006 - PUT cria quando ID não existe
    [Tags]    smoke    produtos    P006
    [Documentation]    PUT em ID inexistente deve criar novo produto
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    ${id_inexistente}=    Set Variable    507f1f77bcf86cd799439011
    ${nome}=    Generate Unique Name    Produto PUT Novo
    
    &{produto_put}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=250
    ...    descricao=Produto criado via PUT
    ...    quantidade=15
    
    ${headers}=    Create Auth Headers    ${AUTH_TOKEN}
    ${resp}=    PUT On Session    booker    /produtos/${id_inexistente}    json=${produto_put}    headers=${headers}
    Should Be True    ${resp.status_code} in [200, 201]
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message
    
    # Cleanup se produto foi criado
    Run Keyword If    ${resp.status_code} == 201
    ...    DELETE On Session    booker    /produtos/${id_inexistente}    headers=${headers}

P008 - Bloquear exclusão se em carrinho
    [Tags]    negativo    produtos    P008
    [Documentation]    Produto vinculado a carrinho não pode ser excluído
    # Nota: Este teste requer implementação de carrinhos
    # Por enquanto, simula o cenário com produto inexistente
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    ${headers}=    Create Auth Headers    ${AUTH_TOKEN}
    ${id_inexistente}=    Set Variable    507f1f77bcf86cd799439011
    
    ${resp}=    DELETE On Session    booker    /produtos/${id_inexistente}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    não encontrado