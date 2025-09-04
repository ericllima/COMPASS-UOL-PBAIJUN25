*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Resource         ../actions/booking_actions.robot
Resource         ../actions/auth_actions.robot
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     crud    service

*** Test Cases ***
Complete CRUD Workflow
    [Tags]    e2e    chain    auth
    # Authenticate
    Login With Valid Credentials
    
    # Create
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Valid Booking    ${booking_data}
    
    # Read
    ${get_response}=    Get Existing Booking    ${booking_id}
    Should Be Equal    ${get_response.json()['firstname']}    ${booking_data['firstname']}
    
    # Update
    ${updated_data}=    Get Updated Booking Data
    ${put_response}=    Update Existing Booking    ${booking_id}    ${updated_data}
    Should Be Equal    ${put_response.json()['firstname']}    ${updated_data['firstname']}
    
    # Patch
    ${patch_data}=    Create Dictionary    additionalneeds=Room Service
    ${patch_response}=    Patch Existing Booking    ${booking_id}    ${patch_data}
    Should Be Equal    ${patch_response.json()['additionalneeds']}    Room Service
    
    # Delete
    Delete Existing Booking    ${booking_id}
    Verify Booking Not Found    ${booking_id}

Bulk Create Bookings
    [Tags]    create    POST    bulk
    ${booking_data}=    Get Valid Booking Data
    FOR    ${i}    IN RANGE    3
        ${booking_id}    ${payload}=    Create Valid Booking    ${booking_data}
        Should Be True    ${booking_id} > 0
        Log To Console    Bulk created booking ${i+1}: ID ${booking_id}
    END

Search Bookings By Filter
    [Tags]    search    GET    filter
    ${booking_data}=    Get Valid Booking Data
    ${booking_id}    ${payload}=    Create Valid Booking    ${booking_data}
    
    ${filters}=    Create Dictionary    firstname=${booking_data['firstname']}
    ${response}=    Search Bookings    ${filters}
    ${bookings}=    Set Variable    ${response.json()}
    Should Not Be Empty    ${bookings}