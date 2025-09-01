*** Settings ***
Resource         ../resources/variables.robot
Resource         ../resources/test_data.robot
Resource         ../resources/keywords.robot
Library          Collections
Suite Setup      Setup Booker Session
Suite Teardown   Delete All Sessions
Default Tags     booker

*** Variables ***
# ---- Config da API ----
${BASE_URL}         https://restful-booker.herokuapp.com
${AUTH_PATH}        /auth
${BOOKING_PATH}     /booking
${USERNAME}         admin
${PASSWORD}         password123
&{DEFAULT_HEADERS}  Accept=application/json    Content-Type=application/json

# ---- Dados de teste (booking) ----
&{BOOKING_DATES}              checkin=2025-09-01    checkout=2025-09-05
&{BOOKING_DATA}               firstname=Rillary    lastname=Uchoa
...                           totalprice=350       depositpaid=${True}
...                           bookingdates=${BOOKING_DATES}    additionalneeds=Breakfast

&{UPDATED_BOOKING_DATES}      checkin=2025-09-02    checkout=2025-09-06
&{UPDATED_BOOKING}            firstname=Rillary    lastname=Uchoa
...                           totalprice=420       depositpaid=${False}
...                           bookingdates=${UPDATED_BOOKING_DATES}    additionalneeds=Late checkout

${BOOKING_ID}       ${None}     # Será preenchido em tempo de execução

*** Keywords ***
Setup Booker Session
    Create Session    booker    ${BASE_URL}    headers=${DEFAULT_HEADERS}    verify=${True}

Get Auth Token
    ${payload}=   Create Dictionary    username=${USERNAME}    password=${PASSWORD}
    ${resp}=      POST On Session    booker    ${AUTH_PATH}    json=${payload}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${token}=     Get From Dictionary    ${resp.json()}    token
    RETURN    ${token}

Auth Headers
    [Arguments]    ${token}
    ${headers}=    Create Dictionary    Cookie=token=${token}    Content-Type=application/json    Accept=application/json
    RETURN    ${headers}

Create New Booking
    ${resp}=      POST On Session    booker    ${BOOKING_PATH}    json=${BOOKING_DATA}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${id}=        Get From Dictionary    ${resp.json()}    bookingid
    Set Suite Variable    ${BOOKING_ID}    ${id}
    RETURN    ${id}

Ensure Booking Exists
    Run Keyword If    '${BOOKING_ID}'=='${None}' or not ${BOOKING_ID}    Create New Booking
    RETURN    ${BOOKING_ID}

Get Booking By Id
    [Arguments]    ${id}
    ${resp}=      GET On Session    booker    ${BOOKING_PATH}/${id}
    RETURN    ${resp}

Update Booking (PUT)
    [Arguments]    ${id}    ${token}
    ${headers}=   Auth Headers    ${token}
    ${resp}=      PUT On Session    booker    ${BOOKING_PATH}/${id}    json=${UPDATED_BOOKING}    headers=${headers}
    RETURN    ${resp}

Partial Update Booking (PATCH)
    [Arguments]    ${id}    ${token}    ${partial}
    ${headers}=   Auth Headers    ${token}
    ${resp}=      PATCH On Session    booker    ${BOOKING_PATH}/${id}    json=${partial}    headers=${headers}
    RETURN    ${resp}

Delete Booking
    [Arguments]    ${id}    ${token}
    ${headers}=   Auth Headers    ${token}
    ${resp}=      DELETE On Session    booker    ${BOOKING_PATH}/${id}    headers=${headers}
    RETURN    ${resp}

*** Test Cases ***
CT001 - Healthcheck /ping deve responder 201
    ${resp}=    GET On Session    booker    /ping
    Should Be Equal As Integers    ${resp.status_code}    201

CT002 - Autenticacao com sucesso retorna token
    ${token}=   Get Auth Token
    Should Not Be Empty    ${token}

CT003 - Autenticacao invalida retorna motivo sem token
    ${bad}=     Create Dictionary    username=${USERNAME}    password=wrong
    ${resp}=    POST On Session    booker    ${AUTH_PATH}    json=${bad}
    Should Be Equal As Integers    ${resp.status_code}    200
    ${body}=    Set Variable    ${resp.json()}
    Dictionary Should Contain Key    ${body}    reason
    Run Keyword And Expect Error    *    Get From Dictionary    ${body}    token

CT004 - Listar todas as reservas (GET)
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}
    Should Be Equal As Integers    ${resp.status_code}    200

CT005 - Criar nova reserva (POST) e armazenar ID
    ${id}=      Create New Booking
    Should Be True    ${id} > 0

CT006 - Buscar reserva por ID (GET) e validar estrutura
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
    ${id}=      Ensure Booking Exists
    ${token}=   Get Auth Token
    ${resp}=    Update Booking (PUT)    ${id}    ${token}
    Should Be Equal As Integers    ${resp.status_code}    200

CT008 - Atualizacao parcial (PATCH) com token valido
    [Tags]    crud    auth
    ${id}=      Ensure Booking Exists
    ${token}=   Get Auth Token
    ${partial}=    Create Dictionary    additionalneeds=Dinner
    ${resp}=    Partial Update Booking (PATCH)    ${id}    ${token}    ${partial}
    Should Be Equal As Integers    ${resp.status_code}    200

CT009 - Atualizar SEM token deve negar (PUT)
    [Tags]    negative
    ${id}=      Ensure Booking Exists
    ${resp}=    PUT On Session    booker    ${BOOKING_PATH}/${id}    json=${UPDATED_BOOKING}    expected_status=any
    Should Be True    ${resp.status_code} in [401, 403]

CT010 - PATCH SEM token deve negar
    [Tags]    negative
    ${id}=      Ensure Booking Exists
    ${partial}=    Create Dictionary    additionalneeds=Late dinner
    ${resp}=    PATCH On Session    booker    ${BOOKING_PATH}/${id}    json=${partial}    expected_status=any
    Should Be True    ${resp.status_code} in [401, 403]

CT011 - DELETE SEM token deve negar
    [Tags]    negative
    ${id}=      Ensure Booking Exists
    ${resp}=    DELETE On Session    booker    ${BOOKING_PATH}/${id}    expected_status=any
    Should Be True    ${resp.status_code} in [401, 403]

CT012 - Deletar reserva com token e confirmar remocao
    [Tags]    crud    auth
    ${id}=      Create New Booking
    ${token}=   Get Auth Token
    ${del}=     Delete Booking    ${id}    ${token}
    Should Be Equal As Integers    ${del.status_code}    201
    ${check}=   GET On Session    booker    ${BOOKING_PATH}/${id}    expected_status=any
    Should Be Equal As Integers    ${check.status_code}    404

CT013 - Buscar reservas por filtro (firstname/lastname)
    ${params}=  Create Dictionary    firstname=${BOOKING_DATA['firstname']}    lastname=${BOOKING_DATA['lastname']}
    ${resp}=    GET On Session    booker    url=${BOOKING_PATH}    params=${params}
    Should Be Equal As Integers    ${resp.status_code}    200

CT014 - Buscar reserva inexistente retorna 404
    [Tags]    negative
    ${resp}=    GET On Session    booker    ${BOOKING_PATH}/0    expected_status=any
    Should Be Equal As Integers    ${resp.status_code}    404

CT015 - Criar reserva com payload invalido (negativo)
    [Tags]    negative
    ${bad}=     Create Dictionary    firstname=Only    totalprice=not-a-number
    ${resp}=    POST On Session    booker    ${BOOKING_PATH}    json=${bad}    expected_status=any
    Should Be True    ${resp.status_code} in [400, 500]
