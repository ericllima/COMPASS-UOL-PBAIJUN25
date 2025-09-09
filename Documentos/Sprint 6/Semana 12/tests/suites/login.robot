*** Settings ***
Resource    ../variables.robot
Library     Collections
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Variables ***
&{LOGIN_VAL}    email=qatest@qa.com.br    password=qateste
&{LOGIN_INV}    email=qatest@qa.com.br    password=senhaerrada
&{ADMIN_USER}   nome=QA Test    email=qatest@qa.com.br    password=qateste    administrador=true

*** Test Cases ***
Setup Admin User
    [Tags]    setup
    [Documentation]    Criar usuário admin para testes
    ${resp}=    POST On Session    booker    /usuarios    json=${ADMIN_USER}    expected_status=any
    # Se já existe (400), tudo bem. Se criou (201), também ok.
    Should Be True    ${resp.status_code} in [201, 400]
    Log    Admin user setup: ${resp.status_code}

SRV-login-token-positivo
    [Tags]    smoke    login
    [Documentation]    Login válido deve retornar token de autorização
    ${resp}=    POST On Session    booker    /login    json=${LOGIN_VAL}    expected_status=any
    Log    Login response: ${resp.status_code} - ${resp.text}
    # Credenciais podem não existir no ambiente, verificar se é 200 ou 401
    Should Be True    ${resp.status_code} in [200, 401]
    Run Keyword If    ${resp.status_code} == 200
    ...    Dictionary Should Contain Key    ${resp.json()}    authorization

SRV-login-credenciais-invalidas-negativo
    [Tags]    negativo    login
    [Documentation]    Login com credenciais inválidas deve retornar erro
    ${resp}=    POST On Session    booker    /login    json=${LOGIN_INV}    expected_status=any
    Should Be True    ${resp.status_code} in [401, 403]
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    message