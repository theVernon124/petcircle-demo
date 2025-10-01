*** Comments ***
Add more scenarios to validate other fields like category, tags

*** Settings ***
Library    Collections
Library    RequestsLibrary
Resource    ../../keywords/pets/Pets.resource

Suite Setup    Create Session    petstoresession    https://petstore.swagger.io/v2    verify=${True}
Test Setup    Add Pet    petstoresession

*** Test Cases ***
Should be able to find existing pet by ID
    ${response}=    GET On Session    petstoresession    /pet/${petId}

    Status Should Be    200    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    id    ${petId}
    Keep In Dictionary    ${responseDict}    name    photoUrls
    Dictionaries Should Be Equal    ${responseDict}    ${data}

# The actual value for `message` in the response is a Java error, which may pose security risks
Should not be able to find pet with non-numeric ID
    ${response}=    GET On Session    petstoresession    /pet/a    expected_status=any

    Status Should Be    404    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${404}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

Should not be able to find pet with non-existent ID
    ${response}=    GET On Session    petstoresession    /pet/${-1}    expected_status=any

    Status Should Be    404    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${1}
    Dictionary Should Contain Item    ${responseDict}    type    error
    Dictionary Should Contain Item    ${responseDict}    message    Pet not found