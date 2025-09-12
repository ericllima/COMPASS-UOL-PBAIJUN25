*** Settings ***
Resource    ../variables.robot
Resource    ../resources/keywords.robot
Resource    ../data/test_data.robot
Library     Collections
Library     String
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Test Cases ***
DD001 - Criar usuários com dados parametrizados
    [Tags]    data-driven    usuarios    DD001
    [Documentation]    Testa criação de usuários usando dados parametrizados
    [Template]    Create User With Template
    FOR    ${user_data}    IN    @{USUARIOS_VALIDOS}
        ${user_data}
    END

DD002 - Criar produtos com dados parametrizados
    [Tags]    data-driven    produtos    DD002
    [Documentation]    Testa criação de produtos usando dados parametrizados
    [Template]    Create Product With Template
    FOR    ${product_data}    IN    @{PRODUTOS_VALIDOS}
        ${product_data}
    END

DD003 - Teste de performance múltiplas requisições
    [Tags]    performance    DD003
    [Documentation]    Testa performance com múltiplas requisições simultâneas
    ${token}=    Get Valid Auth Token
    
    FOR    ${i}    IN RANGE    5
        ${response_time}=    Measure Response Time    GET    /usuarios
        Should Be True    ${response_time} < ${MAX_RESPONSE_TIME}
        Log    Request ${i+1} response time: ${response_time}s
    END

*** Keywords ***
Create User With Template
    [Arguments]    ${user_data_string}
    @{user_parts}=    Split String    ${user_data_string}    |
    ${email}=    Generate Unique Email
    
    &{user_data}=    Create Dictionary
    ...    nome=${user_parts}[0]
    ...    email=${email}
    ...    password=${user_parts}[2]
    ...    administrador=${user_parts}[3]
    
    ${resp}=    POST On Session    booker    /usuarios    json=${user_data}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    _id
    Dictionary Should Contain Key    ${body}    message
    
    # Cleanup
    ${user_id}=    Get From Dictionary    ${resp.json()}    _id
    DELETE On Session    booker    /usuarios/${user_id}    expected_status=any

Create Product With Template
    [Arguments]    ${product_data_string}
    ${token}=    Get Valid Auth Token
    @{product_parts}=    Split String    ${product_data_string}    |
    ${nome}=    Generate Unique Name    ${product_parts}[0]
    
    &{product_data}=    Create Dictionary
    ...    nome=${nome}
    ...    preco=${product_parts}[1]
    ...    descricao=${product_parts}[2]
    ...    quantidade=${product_parts}[3]
    
    ${headers}=    Create Auth Headers    ${token}
    ${resp}=    POST On Session    booker    /produtos    json=${product_data}    headers=${headers}
    Should Be Equal As Integers    ${resp.status_code}    201
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    _id
    Dictionary Should Contain Key    ${body}    message
    
    # Cleanup
    ${product_id}=    Get From Dictionary    ${resp.json()}    _id
    DELETE On Session    booker    /produtos/${product_id}    headers=${headers}    expected_status=any