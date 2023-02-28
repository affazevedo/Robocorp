*** Settings ***
Documentation     Insert the sales data for the week and export it as a PDF.
Library           RPA.Browser.Selenium    auto_close=${FALSE}
Library           RPA.Excel.Files
Library           RPA.HTTP
Library           RPA.PDF


*** Variables ***
${_url}     https://robotsparebinindustries.com/
${_user}    maria
${_pw}    thoushallnotpass
${_excelFileName}    SalesData.xlsx


*** Tasks ***
Main
    Log To console    --------------------------------------- INICIO -----------------------------------------
    LogIn       ${_url}    ${_user}    ${_pw}
    DownloadExcelFile    ${_url}    ${_excelFileName}
    FillFormUsingExcelFile
    GetResults
    ExportTableAsPDF
     [Teardown]    LogOut
    Log To console    --------------------------------------- FIM -----------------------------------------

*** Keywords ***

LogIn     [Arguments]    ${url}    ${user}    ${pw}
    Log To console    A efetuar Login
    Open Available Browser   ${url}
    Maximize Browser Window
    Input Text    id:username     ${user}
    Input Password    id:password     ${pw}
    Submit Form
    Wait Until Page Contains Element    id:sales-form
    Log To console    Login efetuado com sucesso

DownloadExcelFile    [Arguments]    ${url}    ${fileName}    
    Download    ${url}${fileName}     overwrite=True
    Log To console    Download do Ficheiro com sucesso
    

FillFormUsingExcelFile
    Open Workbook    SalesData.xlsx
    ${sales}=    Read Worksheet As Table    header=True
    Close Workbook

    Log To console    Lido Ficheiro com sucesso

    FOR    ${sale}    IN    @{sales}
        FillOnePerson    ${sale}
    END


FillOnePerson    [Arguments]    ${sale}
    
    Input Text    id:firstname    ${sale}[First Name]
    Input Text    id:lastname    ${sale}[Last Name]
    Input Text    id:salesresult    ${sale}[Sales]
    Select From List By Value    id:salestarget    ${sale}[Sales Target]
    Click Button    Submit
    
    Log To console     Preenchida com sucesso

GetResults
    Screenshot    css:div.sales-summary    ${OUTPUT_DIR}${/}sales_summary.png
    
    Log To console    Resultados obtidos e gravados com sucesso

ExportTableAsPDF
    Wait Until Element Is Visible    id:sales-results
    ${sales_results_html}=    Get Element Attribute    id:sales-results    outerHTML
    Html To Pdf    ${sales_results_html}    ${OUTPUT_DIR}${/}sales_results.pdf

LogOut
    Click Button    id:logout
    Close Browser
    Log To console    Logout efetuado com sucesso e browser fechado