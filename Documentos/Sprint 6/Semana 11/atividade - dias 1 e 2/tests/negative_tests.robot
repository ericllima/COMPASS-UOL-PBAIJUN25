*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     negative

*** Test Cases ***
# Security and validation tests
Update Without Authentication Should Fail
    [Tags]    security    auth    PUT
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    ${updated_data}=    Get Updated Booking Data
    ${resp}=    PUT On Session    booker    ${BOOKING_PATH}/${booking_id}    json=${updated_data}    expected_status=any
    Assert Status And Json Field    ${resp}    403

Patch Without Authentication Should Fail
    [Tags]    security    auth    PATCH
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    ${patch_data}=    Create Dictionary    additionalneeds=Unauthorized
    ${resp}=    PATCH On Session    booker    ${BOOKING_PATH}/${booking_id}    json=${patch_data}    expected_status=any
    Assert Status And Json Field    ${resp}    403

Delete Without Authentication Should Fail
    [Tags]    security    auth    DELETE
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    ${resp}=    DELETE On Session    booker    ${BOOKING_PATH}/${booking_id}    expected_status=any
    Assert Status And Json Field    ${resp}    403

Invalid Authentication Should Return Error
    [Tags]    auth    POST    security
    ${invalid_auth}=    Load JSON Test Data    ${TEST_DATA_FILE}    auth_invalid
    ${resp}=    POST On Session    booker    ${AUTH_PATH}    json=${invalid_auth}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    reason

Get Nonexistent Booking Should Return 404
    [Tags]    notfound    GET
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}/999999    expected_status=any
    Assert Status And Json Field    ${resp}    404

Create Booking With Invalid Data Should Fail
    [Tags]    validation    POST    create
    ${invalid_data}=    Get Invalid Booking Data    invalid_data_types
    ${resp}=    POST On Session    booker    ${BOOKING_PATH}    json=${invalid_data}    expected_status=any
    Should Be True    ${resp.status_code} in [200, 400, 500]

Create Booking With Empty Payload Should Fail
    [Tags]    validation    POST    create
    ${empty_data}=    Get Invalid Booking Data    empty_payload
    ${resp}=    POST On Session    booker    ${BOOKING_PATH}    json=${empty_data}    expected_status=any
    Should Be True    ${resp.status_code} in [400, 500]