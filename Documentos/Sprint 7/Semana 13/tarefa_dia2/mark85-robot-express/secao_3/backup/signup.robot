*** Settings ***
Documentation    Cenários de testes do cadastro de usuários

#Library    FakerLibrary

Resource    ../resources/base.resource

#Suite Setup    Log    Tudo aqui ocorre antes da Suite (antes de todos os testes)
#Suite Teardown    Log    Tudo aqui ocorre depois da Suite (depois de todos os testes)

Test Setup    Start Session
Test Teardown    Take Screenshot 

*** Variables ***

${name}    TestQA
${email}    testqa@email.com
${password}    pwd123

*** Test Cases ***
Deve poder cadastrar um novo usuário

    ${user}    Create Dictionary    
    ...    name=TestDic
    ...    email=testdic@email.com
    ...    password=pwd123

    #${name}    FakerLibrary.Name
    #${email}    FakerLibrary.Free Email
    #${password}    Set Variable    pwd123
    
    #${name}    Set Variable     TestQA
    #${email}    Set Variable     testqa@email.com
    #${password}    Set Variable     pwd123

    Remove User From Database    ${user}[email]

    Go To Signup Page
    Submit Signup Form    ${user}
    Notice Should Be    Boas vindas ao Mark85, o seu gerenciador de tarefas.

    #Start Session

    #Go To    ${BASE_URL}/signup

    #Checkpoint
    #Wait For Elements State    xpath=//h1    visible    5
    #Get Text    xpath=//h1    equal    Faça seu cadastro

    #Wait For Elements State    css=h1    visible    5
    #Get Text    css=h1    equal    Faça seu cadastro
    
    #Alternativa com id:
    #Fill Text    id=name    TestQA
    #Fill Text    id=email    testqa@email.com
    #Fill Text    id=password    pwd123
    
    #Fill Text    css=#name    ${name}
    #Fill Text    css=#email    ${email}
    #Fill Text    css=#password    ${password}
    
    #Fill Text    css=#name    ${user}[name]
    #Fill Text    css=#email    ${user}[email]
    #Fill Text    css=#password    ${user}[password]

    #Fill Text    css=input[name=name]   ${user}[name]
    #Fill Text    css=input[name=email]   ${user}[email]
    #Fill Text    css=input[name=password]    ${user}[password]

    #Click    id=buttonSignup
    #Click    css=button[type=submit] >> text=Cadastrar

    #Wait For Elements State    css=.notice p    visible    5
    #Get Text    css=.notice p    equal    Boas vindas ao Mark85, o seu gerenciador de tarefas.

    #Take Screenshot

Não deve permitir o cadastro com email duplicado
    [Tags]    dupli

    ${user}    Create Dictionary
        ...    name=TestQAA
        ...    email=testqaa@email.com
        ...    password=pwd123

    #${name}    Set Variable     TestQAA
    #${email}    Set Variable     testqaa@email.com
    #${password}    Set Variable     pwd123

    Remove User From Database    ${user}[email]
    Insert User Into Database    ${user}

    Go To Signup Page
    Submit Signup Form    ${user}
    Notice Should Be    Oops! Já existe uma conta com o e-mail informado.

    #Start Session

    #Go To    ${BASE_URL}/signup

    #Checkpoint
    #Wait For Elements State    css=h1    visible    5
    #Get Text    css=h1    equal    Faça seu cadastro

    #Fill Text    css=input[name=name]   ${user}[name]
    #Fill Text    css=input[name=email]   ${user}[email]
    #Fill Text    css=input[name=password]    ${user}[password]

    #Click    id=buttonSignup
    #Click    css=button[type=submit] >> text=Cadastrar

    #Wait For Elements State    css=.notice p    visible    5
    #Get Text    css=.notice p    equal    Oops! Já existe uma conta com o e-mail informado.

    #Take Screenshot

Campos obrigatórios
    [Tags]    required

    ${user}    Create Dictionary    
    ...    name=${EMPTY}
    ...    email=${EMPTY}
    ...    password=${EMPTY}

    Go To Signup Page
    Submit Signup Form    ${user}

    Alert Should Be    Informe seu nome completo
    Alert Should Be    Informe seu e-email
    Alert Should Be    Informe uma senha com pelo menos 6 digitos

    #Wait For Elements State    css=.alert-error >> text=Informe seu nome completo
    #...    visible    5
    #Wait For Elements State    css=.alert-error >> text=Informe seu e-email
    #...    visible    5
    #Wait For Elements State    css=.alert-error >> text=Informe uma senha com pelo menos 6 digitos
    #...    visible    5

Não deve cadastrar com email incorreto
    [Tags]    inv_email
    
    ${user}    Create Dictionary
    ...    name=Email Invalido
    ...    email=email#invalido.com
    ...    password=pwd123

    Go To Signup Page
    Submit Signup Form    ${user}
    Alert Should Be    Digite um e-mail válido

Não deve cadastrar com senhas muito curta
    [Tags]    temp
    
    @{password_list}    Create List    1    12    123    1234    12345

    FOR    ${password}    IN     @{password_list}
        ${user}    Create Dictionary
        ...    name=Teste Sehha Curta
        ...    email=senhacurta@email.com
        ...    password=${password}

        Go To Signup Page
        Submit Signup Form    ${user}

        Alert Should Be    Informe uma senha com pelo menos 6 digitos
    END

Não deve cadastrar com senha de 1 dígito
    [Tags]    short_pass
    [Template]    
    Short password    1

Não deve cadastrar com senha de 2 dígitos
    [Tags]    short_pass
    [Template]
    Short password    12

Não deve cadastrar com senha de 3 dígitos
    [Tags]    short_pass
    [Template]
    Short password    123

Não deve cadastrar com senha de 4 dígitos
    [Tags]    short_pass
    [Template]
    Short password    1234

Não deve cadastrar com senha de 5 dígitos
    [Tags]    short_pass
    [Template]
    Short password    12345

#*** Keywords ***
#Short password
#    [Arguments]    ${short_pass}
#
#    ${user}    Create Dictionary
#       ...    name=${EMPTY}
#        ...    email=${EMPTY}
#        ...    password=${short_pass}
#
#        Go To Signup Page
#        Submit Signup Form    ${user}
#
#        Alert Should Be    Informe uma senha com pelo menos 6 digitos
#Não deve cadastrar com senha de 2 dígitos
#    [Tags]    short_pass

#   ${user}    Create Dictionary
#    ...    name=${EMPTY}
#    ...    email=${EMPTY}
#    ...    password=12

#    Go To Signup Page
#    Submit Signup Form    ${user}

#    Alert Should Be    Informe uma senha com pelo menos 6 digitos