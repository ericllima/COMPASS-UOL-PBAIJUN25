*** Settings ***
Resource    ../resources/variables.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
# Authentication Service Actions
Authenticate User
    [Arguments]    ${username}=${USERNAME}    ${password}=${PASSWORD}
    ${auth_payload}=    Create Dictionary    username=${username}    password=${password}
    ${response}=        POST On Session    booker    ${AUTH_PATH}    json=${auth_payload}    expected_status=any
    Log To Console    Auth request: POST ${AUTH_PATH} - Status: ${response.status_code}
    RETURN    ${response}

Get Valid Auth Token
    ${response}=    Authenticate User
    Should Be Equal As Integers    ${response.status_code}    200
    ${token}=       Get From Dictionary    ${response.json()}    token
    Set Suite Variable    ${AUTH_TOKEN}    ${token}
    RETURN    ${token}

Validate Auth Response
    [Arguments]    ${response}    ${should_succeed}=${True}
    IF    ${should_succeed}
        Should Be Equal As Integers    ${response.status_code}    200
        ${token}=    Get From Dictionary    ${response.json()}    token
        Should Not Be Empty    ${token}
        RETURN    ${token}
    ELSE
        Should Be Equal As Integers    ${response.status_code}    200
        ${body}=    Set Variable    ${response.json()}
        Dictionary Should Contain Key    ${body}    reason
        Run Keyword And Expect Error    *    Get From Dictionary    ${body}    token
    END