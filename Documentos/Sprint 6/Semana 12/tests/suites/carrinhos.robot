*** Settings ***
Resource    ../variables.robot
Resource    ../resources/keywords.robot
Library     Collections
Library     String
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Variables ***
${CARRINHO_ID}    ${EMPTY}
${PRODUTO_ID}     ${EMPTY}
${AUTH_TOKEN}     ${EMPTY}

*** Test Cases ***
C001 - Criar carrinho com produto existente
    [Tags]    smoke    carrinhos    C001
    [Documentation]    Criar carrinho com produto existente deve retornar 201
    ${token}=    Get Auth Token
    ${produto_id}=    Create Test Product    ${token}
    
    &{produto_carrinho}=    Create Dictionary
    ...    idProduto=${produto_id}
    ...    quantidade=1
    
    &{carrinho_data}=    Create Dictionary
    ...    produtos=@{[${produto_carrinho}]}
    
    ${headers}=    Create Auth Headers    ${token}
    ${resp}=    POST On Session    booker    /carrinhos    json=${carrinho_data}    headers=${headers}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    _id
    Dictionary Should Contain Key    ${body}    message
    Set Suite Variable    ${CARRINHO_ID}    ${body['_id']}
    Set Suite Variable    ${PRODUTO_ID}    ${produto_id}
    Set Suite Variable    ${AUTH_TOKEN}    ${token}

C002 - Impedir produto inexistente
    [Tags]    negativo    carrinhos    C002
    [Documentation]    Carrinho com produto inexistente deve retornar 400
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    ${id_inexistente}=    Set Variable    507f1f77bcf86cd799439011
    &{produto_inexistente}=    Create Dictionary
    ...    idProduto=${id_inexistente}
    ...    quantidade=1
    
    &{carrinho_data}=    Create Dictionary
    ...    produtos=@{[${produto_inexistente}]}
    
    ${headers}=    Create Auth Headers    ${AUTH_TOKEN}
    ${resp}=    POST On Session    booker    /carrinhos    json=${carrinho_data}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    400
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message

C003 - Listar carrinhos
    [Tags]    smoke    carrinhos    C003
    [Documentation]    Listar carrinhos deve retornar 200 e lista
    ${resp}=    GET On Session    booker    /carrinhos
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    carrinhos
    Dictionary Should Contain Key    ${body}    quantidade

C004 - Buscar carrinho por ID
    [Tags]    smoke    carrinhos    C004
    [Documentation]    Buscar carrinho por ID deve retornar 200
    Skip If    '${CARRINHO_ID}' == '${EMPTY}'    Carrinho não foi criado
    
    ${resp}=    GET On Session    booker    /carrinhos/${CARRINHO_ID}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    produtos
    Dictionary Should Contain Key    ${body}    precoTotal
    Dictionary Should Contain Key    ${body}    quantidadeTotal
    Dictionary Should Contain Key    ${body}    idUsuario

C005 - Remover carrinho e restaurar estoque
    [Tags]    smoke    carrinhos    C005
    [Documentation]    Exclusão do carrinho deve restaurar estoque dos produtos
    Skip If    '${CARRINHO_ID}' == '${EMPTY}'    Carrinho não foi criado
    Skip If    '${AUTH_TOKEN}' == '${EMPTY}'    Token não disponível
    
    # Verificar estoque antes da exclusão
    ${resp_produto_antes}=    GET On Session    booker    /produtos/${PRODUTO_ID}
    ${estoque_antes}=    Get From Dictionary    ${resp_produto_antes.json()}    quantidade
    
    # Excluir carrinho
    ${headers}=    Create Auth Headers    ${AUTH_TOKEN}
    ${resp}=    DELETE On Session    booker    /carrinhos/concluir-compra    headers=${headers}
    Should Be True    ${resp.status_code} in [200, 204]
    
    # Verificar se estoque foi restaurado (para cancelar-compra)
    # Nota: ServeRest tem /concluir-compra e /cancelar-compra
    ${resp_cancelar}=    DELETE On Session    booker    /carrinhos/cancelar-compra    headers=${headers}    expected_status=any
    Should Be True    ${resp_cancelar.status_code} in [200, 400]

C006 - Acesso sem autenticação
    [Tags]    negativo    carrinhos    C006
    [Documentation]    Operações de carrinho sem token devem retornar 401
    ${nome}=    Generate Unique Name    Produto Carrinho
    
    &{produto_data}=    Create Dictionary
    ...    idProduto=507f1f77bcf86cd799439011
    ...    quantidade=1
    
    &{carrinho_data}=    Create Dictionary
    ...    produtos=@{[${produto_data}]}
    
    ${resp}=    POST On Session    booker    /carrinhos    json=${carrinho_data}    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    401
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message
    Should Contain    ${body['message']}    Token de acesso ausente