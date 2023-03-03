*** Settings ***
Documentation   This task logs in to the Portuguese Tax and Customs Authority website.

Library         RPA.Browser.Selenium

*** Variables ***     
${login_url}    https://www.portaldasfinancas.gov.pt/at/html/index.html
${username}    248820648
${password}    IYSMBAKMKMZX

*** Tasks ***
Main
    Login Portal Financas
    
    Log out


*** Keywords ***
Login Portal Financas
    Open Available Browser    ${login_url}
    Maximize Browser Window
    Click Element    //a[@class='btn-default']  
    Click Element    //span[text()='NIF'] 

    Input Text    //*[@id="username"]    ${username}
    Input Password    //*[@id="password-nif"]    ${password}
    Click Button   //*[@id="sbmtLogin"]
    Wait Until Element Is Visible   //li[@class='active'] 

Log out
    Click Element    //li[@id='logout-link'] 
    Close Browser