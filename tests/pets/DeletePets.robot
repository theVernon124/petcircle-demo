*** Settings ***
Library    Collections
Library    RequestsLibrary
Resource    ../../keywords/pets/Pets.resource

Suite Setup    Create Session    petstoresession    https://petstore.swagger.io/v2    verify=${True}
Test Setup    Add Pet    petstoresession

*** Test Cases ***
Should be able to delete existing pet
    ${response}=    DELETE On Session    petstoresession    /pet/${petId}

    Status Should Be    200    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${200}
    Dictionary Should Contain Key    ${responseDict}    type
    ${stringId}=    Convert To String    ${petId}
    Dictionary Should Contain Item    ${responseDict}    message    ${stringId}

    # This test fails here because the GET /pet/{petId} endpoint still returns the data.
    ${response}=    GET On Session    petstoresession    /pet/${petId}    expected_status=any
    Status Should Be    404    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${1}
    Dictionary Should Contain Item    ${responseDict}    type    error
    Dictionary Should Contain Item    ${responseDict}    message    Pet not found

Should not be able to delete non-existent pet
    ${response}=    DELETE On Session    petstoresession    /pet/${-1}    expected_status=any

    Status Should Be    404    ${response}

# This test currently fails because the endpoint returns 404, contrary to what the API spec says that it should return 400 for invalid pet IDs.
Should not be able to delete pet with non-string ID
    ${response}=    DELETE On Session    petstoresession    /pet/a    expected_status=any

    Status Should Be    400    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${responseDict}    code
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message