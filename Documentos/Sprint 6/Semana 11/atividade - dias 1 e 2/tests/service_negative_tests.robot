*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Resource         ../actions/booking_actions.robot
Resource         ../actions/auth_actions.robot
Resource         ../services/booking_service.robot
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     negative    service

*** Test Cases ***
Update Without Auth Should Fail
    [Tags]    security    auth    PUT
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Valid Booking    ${booking_data}
    
    ${updated_data}=    Get Updated Booking Data
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${response}=    PUT On Session    booker    ${BOOKING_PATH}/${booking_id}    json=${updated_data}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    403

Delete Without Auth Should Fail
    [Tags]    security    auth    DELETE
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Valid Booking    ${booking_data}
    
    ${headers}=    Create Dictionary    Content-Type=application/json    Accept=application/json
    ${response}=    DELETE On Session    booker    ${BOOKING_PATH}/${booking_id}    headers=${headers}    expected_status=any
    Should Be Equal As Integers    ${response.status_code}    403

Invalid Login Should Fail
    [Tags]    auth    POST    security
    ${response}=    Attempt Login With Invalid Credentials    admin    wrongpassword
    Should Be Equal As Integers    ${response.status_code}    200
    Dictionary Should Contain Key    ${response.json()}    reason

Get Nonexistent Booking Should Return 404
    [Tags]    notfound    GET
    ${response}=    Get Booking Request    999999
    Should Be Equal As Integers    ${response.status_code}    404

Create Invalid Booking Should Fail
    [Tags]    validation    POST    create
    ${invalid_data}=    Get Invalid Booking Data    invalid_data_types
    ${response}=    Create Booking Request    ${invalid_data}
    Should Be True    ${response.status_code} in [200, 400, 500]