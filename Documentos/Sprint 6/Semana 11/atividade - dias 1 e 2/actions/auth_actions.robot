*** Settings ***
Resource    ../services/auth_service.robot
Resource    ../resources/variables.robot

*** Keywords ***
# High-level Authentication Actions
Login With Valid Credentials
    ${token}=    Get Valid Auth Token
    RETURN    ${token}

Attempt Login With Invalid Credentials
    [Arguments]    ${username}    ${password}
    ${response}=    Authenticate User    ${username}    ${password}
    Validate Auth Response    ${response}    ${False}
    RETURN    ${response}

Ensure User Is Authenticated
    Run Keyword If    '${AUTH_TOKEN}' == '${None}' or '${AUTH_TOKEN}' == ''
    ...    Login With Valid Credentials