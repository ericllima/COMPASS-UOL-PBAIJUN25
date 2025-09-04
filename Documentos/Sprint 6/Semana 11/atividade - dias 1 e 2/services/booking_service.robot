*** Settings ***
Resource    ../resources/variables.robot
Resource    auth_service.robot
Library     RequestsLibrary
Library     Collections

*** Keywords ***
# Booking Service Actions
Create Booking Request
    [Arguments]    ${payload}
    ${response}=    POST On Session    booker    ${BOOKING_PATH}    json=${payload}    expected_status=any
    Log To Console    Create booking: POST ${BOOKING_PATH} - Status: ${response.status_code}
    RETURN    ${response}

Get Booking Request
    [Arguments]    ${booking_id}
    ${response}=    GET On Session    booker    ${BOOKING_PATH}/${booking_id}    expected_status=any
    Log To Console    Get booking: GET ${BOOKING_PATH}/${booking_id} - Status: ${response.status_code} - ID: ${booking_id}
    RETURN    ${response}

Update Booking Request
    [Arguments]    ${booking_id}    ${payload}
    ${headers}=    Build Auth Headers
    ${response}=    PUT On Session    booker    ${BOOKING_PATH}/${booking_id}    json=${payload}    headers=${headers}    expected_status=any
    Log To Console    Update booking: PUT ${BOOKING_PATH}/${booking_id} - Status: ${response.status_code} - ID: ${booking_id}
    RETURN    ${response}

Patch Booking Request
    [Arguments]    ${booking_id}    ${payload}
    ${headers}=    Build Auth Headers
    ${response}=    PATCH On Session    booker    ${BOOKING_PATH}/${booking_id}    json=${payload}    headers=${headers}    expected_status=any
    Log To Console    Partial update booking: PATCH ${BOOKING_PATH}/${booking_id} - Status: ${response.status_code} - ID: ${booking_id}
    RETURN    ${response}

Delete Booking Request
    [Arguments]    ${booking_id}
    ${headers}=    Build Auth Headers
    ${response}=    DELETE On Session    booker    ${BOOKING_PATH}/${booking_id}    headers=${headers}    expected_status=any
    Log To Console    Delete booking: DELETE ${BOOKING_PATH}/${booking_id} - Status: ${response.status_code} - ID: ${booking_id}
    RETURN    ${response}

List Bookings Request
    [Arguments]    ${params}=${None}
    ${response}=    Run Keyword If    ${params}
    ...    GET On Session    booker    ${BOOKING_PATH}    params=${params}    expected_status=any
    ...    ELSE
    ...    GET On Session    booker    ${BOOKING_PATH}    expected_status=any
    Log To Console    List bookings: GET ${BOOKING_PATH} - Status: ${response.status_code}
    RETURN    ${response}

Build Auth Headers
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json    Cookie=token=${AUTH_TOKEN}
    RETURN    ${headers}