*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     search

*** Test Cases ***
# Search and filter functionality
List All Bookings Should Return 200
    [Tags]    list    GET
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}
    Assert Status And Json Field    ${resp}    200

Search By Firstname Should Work
    [Tags]    filter    GET
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    
    ${filter_data}=    Get Search Filter Data    by_firstname
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}    params=${filter_data}
    Assert Status And Json Field    ${resp}    200

Search By Lastname Should Work
    [Tags]    filter    GET
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    
    ${filter_data}=    Get Search Filter Data    by_lastname
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}    params=${filter_data}
    Assert Status And Json Field    ${resp}    200

Search By Full Name Should Work
    [Tags]    filter    GET
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    
    ${filter_data}=    Get Search Filter Data    by_name
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}    params=${filter_data}
    Assert Status And Json Field    ${resp}    200

Search By Date Range Should Work
    [Tags]    filter    GET    dates
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    
    ${filter_data}=    Get Search Filter Data    by_date_range
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}    params=${filter_data}
    Assert Status And Json Field    ${resp}    200

Search Nonexistent User Should Return Empty
    [Tags]    filter    GET    empty
    ${filter_data}=    Get Search Filter Data    nonexistent_user
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}    params=${filter_data}
    Assert Status And Json Field    ${resp}    200
    ${bookings}=    Set Variable    ${resp.json()}
    Should Be Empty    ${bookings}