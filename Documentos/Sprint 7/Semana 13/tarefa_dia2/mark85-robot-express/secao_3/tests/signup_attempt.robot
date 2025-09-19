*** Settings ***
Documentation    Cenário de tentatiova de cadastro com senha muito curta

Resource    ../resources/base.resource
Test Template    Short Password

Test Setup    Start Session
Test Teardown    Take Screenshot

*** Test Cases ***

Não deve logar senha com de 1 digito    1

Não deve logar senha com de 2 digitos    12

Não deve logar senha com de 3 digitos    123

Não deve logar senha com de 4 digitos    1234

Não deve logar senha com de 5 digitos    12345

#*** Keywords ***
#Short password
#    [Arguments]    ${short_pass}
#
#    ${user}    Create Dictionary
#        ...    name=${EMPTY}
#        ...    email=${EMPTY}
#        ...    password=${short_pass}
#
#        Go To Signup Page
#        Submit Signup Form    ${user}
#
#       Alert Should Be    Informe uma senha com pelo menos 6 digitos