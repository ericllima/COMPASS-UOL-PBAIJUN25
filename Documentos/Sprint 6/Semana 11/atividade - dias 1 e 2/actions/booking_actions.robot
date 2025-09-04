*** Settings ***
Resource    ../services/booking_service.robot
Resource    ../services/auth_service.robot
Resource    ../resources/variables.robot
Library     Collections

*** Keywords ***
# High-level Booking Actions
Create Valid Booking
    [Arguments]    ${payload}
    ${response}=    Create Booking Request    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    ${booking_id}=    Get From Dictionary    ${response.json()}    bookingid
    Log To Console    Created booking ID: ${booking_id}
    RETURN    ${booking_id}    ${payload}

Get Existing Booking
    [Arguments]    ${booking_id}
    ${response}=    Get Booking Request    ${booking_id}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response}

Update Existing Booking
    [Arguments]    ${booking_id}    ${payload}
    ${response}=    Update Booking Request    ${booking_id}    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response}

Patch Existing Booking
    [Arguments]    ${booking_id}    ${payload}
    ${response}=    Patch Booking Request    ${booking_id}    ${payload}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response}

Delete Existing Booking
    [Arguments]    ${booking_id}
    ${response}=    Delete Booking Request    ${booking_id}
    Should Be Equal As Integers    ${response.status_code}    201
    RETURN    ${response}

Search Bookings
    [Arguments]    ${filters}
    ${response}=    List Bookings Request    ${filters}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response}

Verify Booking Not Found
    [Arguments]    ${booking_id}
    ${response}=    Get Booking Request    ${booking_id}
    Should Be Equal As Integers    ${response.status_code}    404
    RETURN    ${response}