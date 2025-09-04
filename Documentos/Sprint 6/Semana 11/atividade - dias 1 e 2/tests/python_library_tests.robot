*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Library          ../libraries/BookingUtils.py
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     python    library

*** Test Cases ***
Generate Random Booking Data Should Work
    [Tags]    utility    data_generation
    ${random_booking}=    Generate Random Booking Data
    Validate Booking Structure    ${random_booking}
    Should Not Be Empty    ${random_booking['firstname']}
    Should Not Be Empty    ${random_booking['lastname']}
    Should Be True    ${random_booking['totalprice']} > 0

Create Booking With Random Data
    [Tags]    booking    POST    random
    ${random_booking}=    Generate Random Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${random_booking}
    Should Be True    ${booking_id} > 0
    Log To Console    Created booking with random data: ID ${booking_id}

Calculate Booking Duration Should Work
    [Tags]    utility    calculation
    ${duration}=    Calculate Booking Duration    2025-01-15    2025-01-20
    Should Be Equal As Integers    ${duration}    5

Validate Booking Structure Should Pass
    [Tags]    validation    structure
    ${valid_booking}=    Get Valid Booking Data
    ${result}=    Validate Booking Structure    ${valid_booking}
    Should Be True    ${result}

Filter Bookings By Price Range Should Work
    [Tags]    utility    filter
    ${booking1}=    Create Dictionary    totalprice=150    firstname=John
    ${booking2}=    Create Dictionary    totalprice=250    firstname=Jane
    ${booking3}=    Create Dictionary    totalprice=350    firstname=Bob
    ${all_bookings}=    Create List    ${booking1}    ${booking2}    ${booking3}
    
    ${filtered}=    Filter Bookings By Price Range    ${all_bookings}    200    300
    Length Should Be    ${filtered}    1
    Should Be Equal    ${filtered[0]['firstname']}    Jane

Convert JSON String Should Work
    [Tags]    utility    json
    ${json_string}=    Set Variable    {"name": "test", "value": 123}
    ${dict_result}=    Convert JSON String To Dict    ${json_string}
    Should Be Equal    ${dict_result['name']}    test
    Should Be Equal As Integers    ${dict_result['value']}    123

Get Current Timestamp Should Work
    [Tags]    utility    timestamp
    ${timestamp}=    Get Current Timestamp
    Should Not Be Empty    ${timestamp}
    ${custom_format}=    Get Current Timestamp    %Y-%m-%d
    Should Match Regexp    ${custom_format}    \\d{4}-\\d{2}-\\d{2}

Create Booking ID List Should Work
    [Tags]    utility    list
    ${id_list}=    Create Booking ID List    123    456    789
    Length Should Be    ${id_list}    3
    Should Contain    ${id_list}    123
    Should Contain    ${id_list}    456
    Should Contain    ${id_list}    789