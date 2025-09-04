*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/keywords.robot
Resource         ../actions/booking_actions.robot
Resource         ../actions/auth_actions.robot
Library          ../libraries/BookingUtils.py
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     service    python

*** Test Cases ***
Service Actions With Python Utils
    [Tags]    integration    random_data
    # Authenticate
    Login With Valid Credentials
    
    # Generate random booking data using Python library
    ${random_booking}=    Generate Random Booking Data
    Log To Console    Generated random booking: ${random_booking}
    
    # Create booking using service actions
    ${booking_id}    ${payload}=    Create Valid Booking    ${random_booking}
    
    # Validate structure using Python library
    ${get_response}=    Get Existing Booking    ${booking_id}
    Validate Booking Structure    ${get_response.json()}
    
    # Calculate duration using Python library
    ${duration}=    Calculate Booking Duration    
    ...    ${get_response.json()['bookingdates']['checkin']}
    ...    ${get_response.json()['bookingdates']['checkout']}
    Should Be True    ${duration} > 0
    Log To Console    Booking duration: ${duration} days

Bulk Operations With Python Utils
    [Tags]    bulk    python_utils
    Login With Valid Credentials
    
    # Create multiple bookings with random data
    ${booking_ids}=    Create List
    FOR    ${i}    IN RANGE    3
        ${random_booking}=    Generate Random Booking Data
        ${booking_id}    ${payload}=    Create Valid Booking    ${random_booking}
        Append To List    ${booking_ids}    ${booking_id}
    END
    
    # Use Python utility to manage booking IDs
    ${id_list}=    Create Booking ID List    @{booking_ids}
    Length Should Be    ${id_list}    3
    Log To Console    Created bookings with IDs: ${id_list}
    
    # Clean up - delete all created bookings
    FOR    ${booking_id}    IN    @{id_list}
        Delete Existing Booking    ${booking_id}
    END

Test Report Generation With Python
    [Tags]    reporting    python_utils
    # Simulate test results
    ${test_results}=    Create List
    ...    ${{ {"name": "Test1", "status": "PASS"} }}
    ...    ${{ {"name": "Test2", "status": "PASS"} }}
    ...    ${{ {"name": "Test3", "status": "FAIL"} }}
    
    # Generate report using Python library
    ${report}=    Generate Test Report Data    ${test_results}
    
    Should Be Equal As Integers    ${report['total_tests']}    3
    Should Be Equal As Integers    ${report['passed_tests']}    2
    Should Be Equal As Integers    ${report['failed_tests']}    1
    Should Be Equal As Numbers    ${report['success_rate']}    66.67
    
    Log To Console    Test Report: ${report}