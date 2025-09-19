*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${AMAZON_URL}    https://www.amazon.com.br
${TIMEOUT}       3s

*** Test Cases ***
Estrategia 1 - ID (Mais Estavel)
    [Documentation]    Usando IDs únicos - estratégia mais confiável
    Open Browser    ${AMAZON_URL}    chrome
    
    # Campo busca por ID
    Wait Until Element Is Visible    id:twotabsearchtextbox    ${TIMEOUT}
    Input Text    id:twotabsearchtextbox    smartphone
    
    # Botão por ID  
    Click Element    id:nav-search-submit-button
    Sleep    2s
    
    [Teardown]    Close Browser

Estrategia 2 - CSS Selector com Classes
    [Documentation]    Usando classes CSS - boa performance
    Open Browser    ${AMAZON_URL}    chrome
    
    # Carrinho por ID (mais estável)
    Wait Until Element Is Visible    id:nav-cart    ${TIMEOUT}
    Click Element    id:nav-cart
    Sleep    2s
    
    [Teardown]    Close Browser

Estrategia 3 - XPath com Texto
    [Documentation]    XPath por texto - flexível mas pode quebrar com i18n
    Open Browser    ${AMAZON_URL}    chrome
    
    # Link por texto
    Wait Until Element Is Visible    xpath://a[contains(text(),'Livros')]    ${TIMEOUT}
    Click Element    xpath://a[contains(text(),'Livros')]
    Sleep    2s
    
    [Teardown]    Close Browser

Estrategia 4 - Atributos Data
    [Documentation]    Usando data-attributes - estável para SPAs
    Open Browser    ${AMAZON_URL}    chrome
    Input Text    id:twotabsearchtextbox    notebook
    Click Element    id:nav-search-submit-button
    
    # Produto por data-asin
    Wait Until Element Is Visible    css:[data-asin]:not([data-asin=""])    ${TIMEOUT}
    Click Element    css:[data-asin]:first-child
    Sleep    2s
    
    [Teardown]    Close Browser

Estrategia 5 - CSS Hierarquico
    [Documentation]    Navegação por hierarquia CSS - resiliente
    Open Browser    ${AMAZON_URL}    chrome
    
    # Logo Amazon (hierarquia CSS)
    Wait Until Element Is Visible    css:.nav-logo-base    ${TIMEOUT}
    Click Element    css:.nav-logo-base
    Sleep    2s
    
    [Teardown]    Close Browser