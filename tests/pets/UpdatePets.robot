*** Comments ***
Add more scenarios to validate other fields like category, tags

*** Settings ***
Library    Collections
Library    RequestsLibrary
Resource    ../../keywords/pets/Pets.resource

Suite Setup    Create Session    petstoresession    https://petstore.swagger.io/v2    verify=${True}
Test Setup    Add Pet    petstoresession

*** Test Cases ***
Should be able to update existing pet
    &{category}=    Create Dictionary    id=${1}    name=dogs
    @{photoUrls}=    Create List    updatedUrl
    &{tag}=    Create Dictionary    id=${1}    name=show-dog
    @{tags}=    Create List    ${tag}
    &{data}=    Create Dictionary    id=${petId}    category=${category}    name=barky    photoUrls=${photoUrls}    tags=${tags}    status=pending

    ${response}=    PUT On Session    petstoresession    /pet    json=${data}

    Status Should Be    200    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionaries Should Be Equal    ${data}    ${responseDict}

    # This test fails here because the GET /pet/{petId} endpoint returns the old data instead of the updated data.
    ${response}=    GET On Session    petstoresession    /pet/${petId}    expected_status=any
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionaries Should Be Equal    ${data}    ${responseDict}

# This test currently fails because the endpoint still returns 200.
Should not be able to update non-existent pet
    &{category}=    Create Dictionary    id=${1}    name=dogs
    @{photoUrls}=    Create List    updatedUrl
    &{tag}=    Create Dictionary    id=${1}    name=show-dog
    @{tags}=    Create List    ${tag}
    &{data}=    Create Dictionary    id=${-1}    category=${category}    name=barky    photoUrls=${photoUrls}    tags=${tags}    status=pending

    ${response}=    PUT On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `name` is a required field.
Should not be able to update existing pet without name
    &{category}=    Create Dictionary    id=${1}    name=dogs
    @{photoUrls}=    Create List    updatedUrl
    &{tag}=    Create Dictionary    id=${1}    name=show-dog
    @{tags}=    Create List    ${tag}
    &{data}=    Create Dictionary    id=${petId}    category=${category}    photoUrls=${photoUrls}    tags=${tags}    status=pending

    ${response}=    PUT On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `name` should be a string.
Should not be able to add a new pet with non-string name
    &{category}=    Create Dictionary    id=${1}    name=dogs
    @{photoUrls}=    Create List    updatedUrl
    &{tag}=    Create Dictionary    id=${1}    name=show-dog
    @{tags}=    Create List    ${tag}
    &{data}=    Create Dictionary    id=${petId}    category=${category}    name=${1}    photoUrls=${photoUrls}    tags=${tags}    status=pending

    ${response}=    PUT On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `photoUrls` is required.
Should not be able to add a new pet without photo URLs
    &{category}=    Create Dictionary    id=${1}    name=dogs
    &{tag}=    Create Dictionary    id=${1}    name=show-dog
    @{tags}=    Create List    ${tag}
    &{data}=    Create Dictionary    id=${petId}    category=${category}    name=barky    tags=${tags}    status=pending

    ${response}=    PUT On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `photoUrls` should be a list of strings.
Should not be able to add a new pet with non-string list photo URLs
    &{category}=    Create Dictionary    id=${1}    name=dogs
    @{photoUrls}=    Create List    ${1}
    &{tag}=    Create Dictionary    id=${1}    name=show-dog
    @{tags}=    Create List    ${tag}
    &{data}=    Create Dictionary    id=${petId}    category=${category}    name=barky    photoUrls=${photoUrls}    tags=${tags}    status=pending

    ${response}=    PUT On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `status` should be one of the defined enum values.
Should not be able to add a new pet with invalid status
    &{category}=    Create Dictionary    id=${1}    name=dogs
    @{photoUrls}=    Create List    updatedUrl
    &{tag}=    Create Dictionary    id=${1}    name=show-dog
    @{tags}=    Create List    ${tag}
    &{data}=    Create Dictionary    id=${petId}    category=${category}    name=barky    photoUrls=${photoUrls}    tags=${tags}    status=invalid

    ${response}=    PUT On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Item    ${responseDict}    code    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message