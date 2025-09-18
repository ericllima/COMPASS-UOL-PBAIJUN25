*** Settings ***
Documentation    Cenários de testes do cadastro de usuários

#Library    FakerLibrary

Resource    ../resources/base.robot

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

    #Start Session

    Go To    http://localhost:3000/signup

    #Checkpoint
    #Wait For Elements State    xpath=//h1    visible    5
    #Get Text    xpath=//h1    equal    Faça seu cadastro

    Wait For Elements State    css=h1    visible    5
    Get Text    css=h1    equal    Faça seu cadastro
    
    #Alternativa com id:
    #Fill Text    id=name    TestQA
    #Fill Text    id=email    testqa@email.com
    #Fill Text    id=password    pwd123
    
    #Fill Text    css=#name    ${name}
    #Fill Text    css=#email    ${email}
    #Fill Text    css=#password    ${password}
    
    Fill Text    css=#name    ${user}[name]
    Fill Text    css=#email    ${user}[email]
    Fill Text    css=#password    ${user}[password]

    Click    id=buttonSignup

    Wait For Elements State    css=.notice p    visible    5
    Get Text    css=.notice p    equal    Boas vindas ao Mark85, o seu gerenciador de tarefas.

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

    #Start Session

    Go To    http://localhost:3000/signup

    #Checkpoint
    Wait For Elements State    css=h1    visible    5
    Get Text    css=h1    equal    Faça seu cadastro

    Fill Text    css=#name    ${user}[name]
    Fill Text    css=#email    ${user}[email]
    Fill Text    css=#password    ${user}[password]

    Click    id=buttonSignup

    Wait For Elements State    css=.notice p    visible    5
    Get Text    css=.notice p    equal    Oops! Já existe uma conta com o e-mail informado.

    #Take Screenshot