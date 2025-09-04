*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Resource         ../actions/booking_actions.robot
Resource         ../actions/auth_actions.robot
Resource         ../services/health_service.robot
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     smoke    service

*** Test Cases ***
Health Check Should Pass
    [Tags]    health    GET
    ${response}=    Ping Service
    Validate Service Health    ${response}

Authentication Should Work
    [Tags]    auth    POST
    ${token}=    Login With Valid Credentials
    Should Not Be Empty    ${token}

Create Booking Should Return ID
    [Tags]    booking    POST    create
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Valid Booking    ${booking_data}
    Should Be True    ${booking_id} > 0

Get Booking Should Return Data
    [Tags]    booking    GET    read
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Valid Booking    ${booking_data}
    ${response}=    Get Existing Booking    ${booking_id}
    Should Be Equal    ${response.json()['firstname']}    ${booking_data['firstname']}