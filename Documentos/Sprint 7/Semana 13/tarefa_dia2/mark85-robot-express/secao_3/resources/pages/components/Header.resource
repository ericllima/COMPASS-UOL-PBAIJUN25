*** Settings ***
Documentation    Ações e elementos do cabeçalho

Library    String
Library    Browser

*** Keywords ***
User should be logged In
    [Arguments]    ${name}

    @{splited_name}    Split String    ${name}
    ${element}    Set Variable    css=header .right small

    Wait For Elements State    ${element}
    ...    visible    5

    Get Text    ${element}    equal    Olá, ${splited_name}[0]