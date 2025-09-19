*** Settings ***

Library    libs/database.py
Library    Browser

#*** Variables ***
#${BASE_URL}    http://localhost:3000

Resource    env.resource

Resource    pages/components/Notice.resource
Resource    pages/components/Alert.resource
Resource    pages/components/Header.resource

Resource    pages/SignupPage.resource
Resource    pages/LoginPage.resource

*** Keywords ***
Start Session
    New Browser    browser=chromium    headless=False
    New Page    ${BASE_URL}

Short password
    [Arguments]    ${short_pass}

    ${user}    Create Dictionary
        ...    name=${EMPTY}
        ...    email=${EMPTY}
        ...    password=${short_pass}

        Go To Signup Page
        Submit Signup Form    ${user}

        Alert Should Be    Informe uma senha com pelo menos 6 digitos