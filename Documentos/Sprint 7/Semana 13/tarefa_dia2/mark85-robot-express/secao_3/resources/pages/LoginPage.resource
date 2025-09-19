*** Settings ***
Documentation    Ações e elementos da página de login

#Library    String
Library    Browser

*** Keywords ***
Submit login form
    [Arguments]    ${user}

    Fill Text    css=input[placeholder$=mail]    ${user}[email]
    #Fill Text    css=input[placeholder="E-mail"]    ${email}
    Fill Text    css=input[placeholder=Senha]    ${user}[password]

    #Click    xpath=//button[text()="Entrar"]
    Click    css=button >> text=Entrar

#User should be logged In
#    [Arguments]    ${name}
#
#    @{splited_name}    Split String    ${name}
#    ${element}    Set Variable    css=header .right small
#
#    Wait For Elements State    ${element}
#    ...    visible    5
#
#    Get Text    ${element}    equal    Olá, ${splited_name}[0]

#Notice should be
#    [Arguments]    ${expected_text}
#
#    ${element}    Set Variable    css=.notice p
#
#    Wait For Elements State    ${element}
#    ...    visible    5
#
#    Get Text    ${element}    equal    ${expected_text}