*** Settings ***
Resource    ../variables.robot
Suite Setup       Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}
Suite Teardown    Delete All Sessions

*** Test Cases ***
H001 - Health check API
    [Tags]    smoke    health    H001
    [Documentation]    Verifica se o endpoint de saúde retorna 200
    ${resp}=    GET On Session    booker    ${HEALTH_PATH}
    Should Be Equal As Integers    ${resp.status_code}    200
    
    # Tentar fazer parse JSON, se falhar, verificar texto
    ${is_json}=    Run Keyword And Return Status    Set Variable    ${resp.json()}
    Run Keyword If    ${is_json}
    ...    Log    Response is JSON: ${resp.json()}
    ...    ELSE
    ...    Log    Response is text: ${resp.text}

H002 - Health check response time
    [Tags]    performance    health    H002
    [Documentation]    Verifica se health check responde em menos de 2 segundos
    ${start_time}=    Get Time    epoch
    ${resp}=    GET On Session    booker    ${HEALTH_PATH}
    ${end_time}=    Get Time    epoch
    ${response_time}=    Evaluate    ${end_time} - ${start_time}
    Should Be Equal As Integers    ${resp.status_code}    200
    Should Be True    ${response_time} < 2    Response time too slow: ${response_time}s
    Log    Response time: ${response_time}s