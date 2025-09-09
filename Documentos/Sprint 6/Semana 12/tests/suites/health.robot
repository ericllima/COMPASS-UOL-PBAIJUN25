*** Settings ***
Resource    ../variables.robot
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Test Cases ***
SRV-health-200-positivo
    [Tags]    smoke    health
    [Documentation]    Verifica se o endpoint de saúde retorna 200
    ${resp}=    GET On Session    booker    ${HEALTH_PATH}
    Should Be Equal As Integers    ${resp.status_code}    200
    # Verificar se tem alguma chave indicativa de saúde
    Run Keyword And Return Status    Dictionary Should Contain Key    ${resp.json()}    status