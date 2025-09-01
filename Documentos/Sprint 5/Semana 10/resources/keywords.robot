*** Settings ***
Library    RequestsLibrary
Library    Collections

*** Keywords ***
Setup Booker Session
    Create Session    booker    ${BOOKER_BASE_URL}    headers=${DEFAULT_HEADERS}    verify=${True}

Get Booker Auth Token
    ${auth_payload}=    Create Dictionary    username=${BOOKER_USERNAME}    password=${BOOKER_PASSWORD}
    ${response}=        POST On Session    booker    ${BOOKER_AUTH}    json=${auth_payload}
    Should Be Equal As Integers    ${response.status_code}    200
    ${token}=           Get From Dictionary    ${response.json()}    token
    Set Suite Variable    ${AUTH_TOKEN}    ${token}
    RETURN    ${token}

Create New Booking
    ${response}=    POST On Session    booker    ${BOOKER_BOOKING}    json=${BOOKING_DATA}
    Should Be Equal As Integers    ${response.status_code}    200
    ${booking_id}=  Get From Dictionary    ${response.json()}    bookingid
    Set Suite Variable    ${CREATED_BOOKING_ID}    ${booking_id}
    RETURN    ${booking_id}

Get Booking By ID
    [Arguments]    ${booking_id}
    ${response}=    GET On Session    booker    ${BOOKER_BOOKING}/${booking_id}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response}

Update Booking (PUT)
    [Arguments]    ${booking_id}    ${token}
    ${headers}=     Create Dictionary    Cookie=token=${token}    Content-Type=application/json    Accept=application/json
    ${response}=    PUT On Session    booker    ${BOOKER_BOOKING}/${booking_id}    json=${UPDATED_BOOKING}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response}

Partial Update Booking (PATCH)
    [Arguments]    ${booking_id}    ${token}    ${partial}
    ${headers}=     Create Dictionary    Cookie=token=${token}    Content-Type=application/json    Accept=application/json
    ${response}=    PATCH On Session    booker    ${BOOKER_BOOKING}/${booking_id}    json=${partial}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    200
    RETURN    ${response}

Delete Booking
    [Arguments]    ${booking_id}    ${token}
    ${headers}=     Create Dictionary    Cookie=token=${token}    Content-Type=application/json    Accept=application/json
    ${response}=    DELETE On Session    booker    ${BOOKER_BOOKING}/${booking_id}    headers=${headers}
    Should Be Equal As Integers    ${response.status_code}    201
    RETURN    ${response}
