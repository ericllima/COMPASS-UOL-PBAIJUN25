*** Settings ***
Documentation     Cenários de autenticação de usuário

Library    Collections
Resource    ../resources/base.resource

Test Setup    Start Session
Test Teardown    Take Screenshot

*** Test Cases ***
Deve poder logar com um usuário pré-cadastrado

    ${user}    Create Dictionary
        ...    name=TestDic
        ...    email=testdic@email.com
        ...    password=pwd123
        
    Remove User From Database    ${user}[email]
    Insert User Into Database    ${user}

    Submit login form    ${user}
    User Should Be Logged In    ${user}[name]

Não deve logar com senha inválida

    ${user}    Create Dictionary
    ...    name=SteveMine
    ...    email=steve@mine.com
    ...    password=pwd123

    Remove User From Database    ${user}[email]
    Insert User Into Database    ${user}

    Set To Dictionary    ${user}    password=abc123
    Submit login form    ${user}
    Notice Should Be    Ocorreu um erro ao fazer login, verifique suas credenciais.
