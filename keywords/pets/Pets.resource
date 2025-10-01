*** Settings ***
Library    RequestsLibrary

*** Keywords ***
Add Pet
    [Arguments]    ${session}
    @{photoUrls}=    Create List    string
    &{data}=    Create Dictionary    name=doggie    photoUrls=${photoUrls}
    Set Test Variable    ${data}

    ${response}=    POST On Session    ${session}    /pet    json=${data}
    Set Test Variable    ${petId}    ${response.json()}[id]