*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/test_data.robot
Resource         ../resources/keywords.robot
Library          Collections
Library          RequestsLibrary
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     booker

*** Variables ***
${BOOKING_ID}       ${None}

*** Keywords ***
# Backward compatibility keywords
Create New Booking
    ${booking_id}    ${payload}=    Create Booking    ${BOOKING_DATA}
    Set Suite Variable    ${BOOKING_ID}    ${booking_id}
    RETURN    ${booking_id}

Ensure Booking Exists
    Run Keyword If    '${BOOKING_ID}'=='${None}' or not ${BOOKING_ID}    Create New Booking
    RETURN    ${BOOKING_ID}

Update Booking (PUT)
    [Arguments]    ${booking_id}    ${token}
    ${resp}=    Update Booking    ${booking_id}    ${UPDATED_BOOKING}
    RETURN    ${resp}

Partial Update Booking (PATCH)
    [Arguments]    ${booking_id}    ${token}    ${partial}
    ${resp}=    Partial Update Booking    ${booking_id}    ${partial}
    RETURN    ${resp}

*** Test Cases ***
# Smoke test - Create booking and validate basic functionality
TC01_Smoke_Create_And_Get
    [Tags]    smoke    dynamic
    ${booking_id}    ${payload}=    Create Booking    ${BOOKING_DATA}
    ${resp}=    Get Booking By Id    ${booking_id}
    Assert Status And Json Field    ${resp}    200    firstname    ${BOOKING_DATA['firstname']}

# E2E test - Complete booking lifecycle with authentication
TC02_E2E_Auth_Create_Get_Update_Patch_Delete
    [Tags]    e2e    chain
    Get Auth Token
    ${booking_id}    ${payload}=    Create Booking    ${BOOKING_DATA}
    ${get_resp}=    Get Booking By Id    ${booking_id}
    Assert Status And Json Field    ${get_resp}    200
    ${put_resp}=    Update Booking    ${booking_id}    ${UPDATED_BOOKING}
    Assert Status And Json Field    ${put_resp}    200
    ${patch_payload}=    Create Dictionary    additionalneeds=WiFi
    ${patch_resp}=    Partial Update Booking    ${booking_id}    ${patch_payload}
    Assert Status And Json Field    ${patch_resp}    200
    ${del_resp}=    Delete Booking    ${booking_id}
    Assert Status And Json Field    ${del_resp}    201
    ${check_resp}=    Get Booking By Id    ${booking_id}
    Assert Status And Json Field    ${check_resp}    404

# Negative test - Update without authentication token
TC03_Negative_Update_Without_Token
    [Tags]    negative    security
    ${booking_id}    ${payload}=    Create Booking    ${BOOKING_DATA}
    ${resp}=    PUT On Session    booker    ${BOOKING_PATH}/${booking_id}    json=${UPDATED_BOOKING}    expected_status=any
    Assert Status And Json Field    ${resp}    403

*** Test Cases ***
CT001 - Healthcheck /ping deve responder 201
    [Tags]    healthcheck    GET    smoke
    ${resp}=    GET On Session    booker    /ping
    Should Be Equal As Integers    ${resp.status_code}    201

CT002 - Autenticacao com sucesso retorna token
    [Tags]    auth    POST    positive
    ${token}=   Get Auth Token
    Should Not Be Empty    ${token}

CT003 - Autenticacao invalida retorna motivo sem token
    [Tags]    auth    POST    negative    security
    ${bad}=     Create Dictionary    username=${USERNAME}    password=wrong
    ${resp}=    POST On Session    booker    ${AUTH_PATH}    json=${bad}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    reason
    Run Keyword And Expect Error    *    Get From Dictionary    ${body}    token

CT004 - Listar todas as reservas (GET)
    [Tags]    booking    GET    list    positive
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}
    Should Be Equal As Integers    ${resp.status_code}    200

CT005 - Criar nova reserva (POST) e armazenar ID
    [Tags]    booking    POST    create    crud    positive
    ${id}=      Create New Booking
    Should Be True    ${id} > 0

CT006 - Buscar reserva por ID (GET) e validar estrutura
    [Tags]    booking    GET    read    crud    positive    validation
    ${id}=      Ensure Booking Exists
    ${resp}=    Get Booking By Id    ${id}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${data}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${data}                       firstname
    Dictionary Should Contain Key    ${data}                       lastname
    Dictionary Should Contain Key    ${data}                       bookingdates
    Dictionary Should Contain Key    ${data['bookingdates']}       checkin
    Dictionary Should Contain Key    ${data['bookingdates']}       checkout

CT007 - Atualizar reserva (PUT) com token valido
    [Tags]    booking    PUT    update    crud    auth    positive
    ${id}=      Ensure Booking Exists
    ${token}=   Get Auth Token
    ${resp}=    Update Booking (PUT)    ${id}    ${token}
    Should Be Equal As Integers    ${resp.status_code}    200

CT008 - Atualizacao parcial (PATCH) com token valido
    [Tags]    booking    PATCH    update    crud    auth    positive
    ${id}=      Ensure Booking Exists
    ${token}=   Get Auth Token
    ${partial}=    Create Dictionary    additionalneeds=Dinner
    ${resp}=    Partial Update Booking (PATCH)    ${id}    ${token}    ${partial}
    Should Be Equal As Integers    ${resp.status_code}    200

CT009 - Atualizar SEM token deve negar (PUT)
    [Tags]    booking    PUT    update    negative    security    auth
    ${id}=      Ensure Booking Exists
    ${resp}=    PUT On Session    booker    ${BOOKING_PATH}/${id}    json=${UPDATED_BOOKING}    expected_status=any
    Should Be True    ${resp.status_code} in [401, 403]

CT010 - PATCH SEM token deve negar
    [Tags]    booking    PATCH    update    negative    security    auth
    ${id}=      Ensure Booking Exists
    ${partial}=    Create Dictionary    additionalneeds=Late dinner
    ${resp}=    PATCH On Session    booker    ${BOOKING_PATH}/${id}    json=${partial}    expected_status=any
    Should Be True    ${resp.status_code} in [401, 403]

CT011 - DELETE SEM token deve negar
    [Tags]    booking    DELETE    delete    negative    security    auth
    ${id}=      Ensure Booking Exists
    ${resp}=    DELETE On Session    booker    ${BOOKING_PATH}/${id}    expected_status=any
    Should Be True    ${resp.status_code} in [401, 403]

CT012 - Deletar reserva com token e confirmar remocao
    [Tags]    booking    DELETE    delete    crud    auth    positive
    ${id}=      Create New Booking
    ${token}=   Get Auth Token
    ${del}=     Delete Booking    ${id}
    Should Be Equal As Integers    ${del.status_code}    201
    ${check}=   GET On Session    booker    ${BOOKING_PATH}/${id}    expected_status=any
    Should Be Equal As Integers    ${check.status_code}    404

CT013 - Buscar reservas por filtro (firstname/lastname)
    [Tags]    booking    GET    filter    search    positive
    ${params}=  Create Dictionary    firstname=${BOOKING_DATA['firstname']}    lastname=${BOOKING_DATA['lastname']}
    ${resp}=    GET On Session    booker    url=${BOOKING_PATH}    params=${params}
    Should Be Equal As Integers    ${resp.status_code}    200

CT014 - Buscar reserva inexistente retorna 404
    [Tags]    booking    GET    read    negative    notfound
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}/0    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    404

CT015 - Criar reserva com payload invalido (negativo)
    [Tags]    booking    POST    create    negative    validation
    ${bad}=     Create Dictionary    firstname=Only    totalprice=not-a-number
    ${resp}=    POST On Session    booker    ${BOOKING_PATH}    json=${bad}    expected_status=any
    Should Be True    ${resp.status_code} in [400, 500]
