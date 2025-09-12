*** Settings ***
Documentation     Variáveis centrais e configuração HTTP para ServeRest EC2
Library           RequestsLibrary

*** Variables ***
${BASE_URL}       http://98.88.16.61:3000
${HEALTH_PATH}    /status
&{BASE_HEADERS}   Content-Type=application/json    Accept=application/json
