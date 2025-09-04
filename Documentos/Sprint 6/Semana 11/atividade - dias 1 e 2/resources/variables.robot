# Central variables and configuration for Restful Booker API testing
# Defines base URLs, authentication paths, and common headers

*** Variables ***
${BASE_URL}             https://restful-booker.herokuapp.com
${AUTH_PATH}            /auth
${BOOKING_PATH}         /booking
${USERNAME}             admin
${PASSWORD}             password123

&{BASE_HEADERS}         Content-Type=application/json    Accept=application/json

# JSON Test Data Files
${TEST_DATA_FILE}       ${CURDIR}/test_data.json
${NEGATIVE_DATA_FILE}   ${CURDIR}/negative_test_data.json
${SEARCH_DATA_FILE}     ${CURDIR}/search_filters.json
