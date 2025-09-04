*** Settings ***
Resource    ../resources/variables.robot
Library     RequestsLibrary

*** Keywords ***
# Health Check Service Actions
Ping Service
    ${response}=    GET On Session    booker    /ping    expected_status=any
    Log To Console    Health check: GET /ping - Status: ${response.status_code}
    RETURN    ${response}

Validate Service Health
    [Arguments]    ${response}
    Should Be Equal As Integers    ${response.status_code}    201