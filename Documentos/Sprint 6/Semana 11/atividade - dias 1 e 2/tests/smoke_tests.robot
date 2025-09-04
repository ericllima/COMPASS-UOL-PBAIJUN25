*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     smoke

*** Test Cases ***
# Basic functionality validation
Healthcheck Should Return 201
    [Tags]    healthcheck    GET
    ${resp}=    GET On Session    booker    /ping
    Assert Status And Json Field    ${resp}    201

Authentication Should Return Token
    [Tags]    auth    POST
    ${token}=    Get Auth Token
    Should Not Be Empty    ${token}

Create Booking Should Return Valid ID
    [Tags]    booking    POST    create
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    Should Be True    ${booking_id} > 0

Get Booking Should Return Valid Data
    [Tags]    booking    GET    read
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    ${resp}=    Get Booking By Id    ${booking_id}
    Assert Status And Json Field    ${resp}    200    firstname    ${booking_data['firstname']}