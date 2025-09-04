*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     crud

*** Test Cases ***
# Complete CRUD operations with authentication
Full CRUD Lifecycle
    [Tags]    e2e    chain    auth
    # Setup
    Get Auth Token
    ${booking_data}=    Get Valid Booking Data
    
    # Create
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    ${get_resp}=    Get Booking By Id    ${booking_id}
    Assert Status And Json Field    ${get_resp}    200
    
    # Update (PUT)
    ${updated_data}=    Get Updated Booking Data
    ${put_resp}=    Update Booking    ${booking_id}    ${updated_data}
    Assert Status And Json Field    ${put_resp}    200
    
    # Partial Update (PATCH)
    ${patch_data}=    Load JSON Test Data    ${TEST_DATA_FILE}    partial_update
    ${patch_resp}=    Partial Update Booking    ${booking_id}    ${patch_data}
    Assert Status And Json Field    ${patch_resp}    200
    
    # Delete
    ${del_resp}=    Delete Booking    ${booking_id}
    Assert Status And Json Field    ${del_resp}    201
    
    # Verify deletion
    ${check_resp}=    Get Booking By Id    ${booking_id}
    Assert Status And Json Field    ${check_resp}    404

Create Multiple Bookings
    [Tags]    create    POST    bulk
    ${booking_data}=    Get Valid Booking Data
    FOR    ${i}    IN RANGE    3
        ${booking_id}    ${payload}=    Create Booking    ${booking_data}
        Should Be True    ${booking_id} > 0
        Log To Console    Created booking ${i+1}: ID ${booking_id}
    END

Update Booking With Full Payload
    [Tags]    update    PUT    auth
    Get Auth Token
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    
    ${updated_data}=    Get Updated Booking Data
    ${resp}=    Update Booking    ${booking_id}    ${updated_data}
    Assert Status And Json Field    ${resp}    200    firstname    ${updated_data['firstname']}

Partial Update Booking
    [Tags]    update    PATCH    auth
    Get Auth Token
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Booking    ${booking_data}
    
    ${patch_data}=    Create Dictionary    additionalneeds=Room service
    ${resp}=    Partial Update Booking    ${booking_id}    ${patch_data}
    Assert Status And Json Field    ${resp}    200