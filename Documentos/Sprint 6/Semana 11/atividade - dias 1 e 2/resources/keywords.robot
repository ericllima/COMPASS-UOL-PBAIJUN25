*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem

*** Keywords ***
Setup Booker Session
    Create Session    booker    ${BASE_URL}    headers=${BASE_HEADERS}    verify=${True}

Get Auth Token
    ${auth_payload}=    Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${response}=        POST On Session    booker    ${AUTH_PATH}    json=${auth_payload}
    Log To Console    Auth request: POST ${AUTH_PATH} - Status: ${response.status_code}
    Should Be Equal As Integers    ${response.status_code}    200
    ${token}=           Get From Dictionary    ${response.json()}    token
    Set Suite Variable    ${AUTH_TOKEN}    ${token}
    RETURN    ${token}

Build Auth Headers
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json    Cookie=token=${AUTH_TOKEN}
    RETURN    ${headers}

Create Booking
    [Arguments]    ${payload}
    ${response}=    POST On Session    booker    ${BOOKING_PATH}    json=${payload}
    Log To Console    Create booking: POST ${BOOKING_PATH} - Status: ${response.status_code}
    ${booking_id}=    Get From Dictionary    ${response.json()}    bookingid
    Log To Console    Created booking ID: ${booking_id}
    RETURN    ${booking_id}    ${payload}

Get Booking By Id
    [Arguments]    ${booking_id}
    ${response}=    GET On Session    booker    ${BOOKING_PATH}/${booking_id}    expected_status=any
    Log To Console    Get booking: GET ${BOOKING_PATH}/${booking_id} - Status: ${response.status_code} - ID: ${booking_id}
    RETURN    ${response}

Update Booking
    [Arguments]    ${booking_id}    ${new_payload}
    ${headers}=    Build Auth Headers
    ${response}=    PUT On Session    booker    ${BOOKING_PATH}/${booking_id}    json=${new_payload}    headers=${headers}    expected_status=any
    Log To Console    Update booking: PUT ${BOOKING_PATH}/${booking_id} - Status: ${response.status_code} - ID: ${booking_id}
    RETURN    ${response}

Partial Update Booking
    [Arguments]    ${booking_id}    ${patch_payload}
    ${headers}=    Build Auth Headers
    ${response}=    PATCH On Session    booker    ${BOOKING_PATH}/${booking_id}    json=${patch_payload}    headers=${headers}    expected_status=any
    Log To Console    Partial update booking: PATCH ${BOOKING_PATH}/${booking_id} - Status: ${response.status_code} - ID: ${booking_id}
    RETURN    ${response}

Delete Booking
    [Arguments]    ${booking_id}
    ${headers}=    Build Auth Headers
    ${response}=    DELETE On Session    booker    ${BOOKING_PATH}/${booking_id}    headers=${headers}    expected_status=any
    Log To Console    Delete booking: DELETE ${BOOKING_PATH}/${booking_id} - Status: ${response.status_code} - ID: ${booking_id}
    RETURN    ${response}

Assert Status And Json Field
    [Arguments]    ${resp}    ${expected_status}    ${json_path}=${None}    ${expected_value}=${None}
    Should Be Equal As Integers    ${resp.status_code}    ${expected_status}
    IF    '${json_path}' != '${None}'
        ${actual_value}=    Get From Dictionary    ${resp.json()}    ${json_path}
        IF    '${expected_value}' != '${None}'
            Should Be Equal    ${actual_value}    ${expected_value}
        END
    END

Load JSON Test Data
    [Arguments]    ${file_path}    ${data_key}
    ${json_content}=    Get File    ${file_path}
    ${test_data}=    Evaluate    json.loads('''${json_content}''')    json
    ${data}=    Get From Dictionary    ${test_data}    ${data_key}
    RETURN    ${data}

Get Valid Booking Data
    ${data}=    Load JSON Test Data    ${TEST_DATA_FILE}    valid_booking
    RETURN    ${data}

Get Updated Booking Data
    ${data}=    Load JSON Test Data    ${TEST_DATA_FILE}    updated_booking
    RETURN    ${data}

Get Invalid Booking Data
    [Arguments]    ${scenario}=invalid_booking
    ${data}=    Load JSON Test Data    ${NEGATIVE_DATA_FILE}    ${scenario}
    RETURN    ${data}

Get Search Filter Data
    [Arguments]    ${filter_type}
    ${data}=    Load JSON Test Data    ${SEARCH_DATA_FILE}    ${filter_type}
    RETURN    ${data}
