*** Comments ***
Add more scenarios to validate other fields like id, category, tags

*** Settings ***
Library    Collections
Library    RequestsLibrary

Suite Setup    Create Session    petstoresession    https://petstore.swagger.io/v2    verify=${True}

*** Test Cases ***
Should be able to add a new pet with minimum required fields
    @{photoUrls}=    Create List    string
    &{data}=    Create Dictionary    name=doggie    photoUrls=${photoUrls}

    ${response}=    POST On Session    petstoresession    /pet    json=${data}

    Status Should Be    200    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${responseDict}    id
    Should Not Be Equal    ${responseDict}[id]    ${None}
    Dictionary Should Contain Key    ${responseDict}    tags
    Should Be Empty    ${responseDict}[tags]
    Keep In Dictionary    ${responseDict}    name    photoUrls
    Dictionaries Should Be Equal    ${data}    ${responseDict}

Should be able to add a new pet with status
    @{photoUrls}=    Create List    string
    &{data}=    Create Dictionary    name=doggie    photoUrls=${photoUrls}    status=available

    ${response}=    POST On Session    petstoresession    /pet    json=${data}

    Status Should Be    200    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${responseDict}    id
    Should Not Be Equal    ${responseDict}[id]    ${None}
    Dictionary Should Contain Key    ${responseDict}    tags
    Should Be Empty    ${responseDict}[tags]
    Keep In Dictionary    ${responseDict}    name    photoUrls    status
    Dictionaries Should Be Equal    ${data}    ${responseDict}

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `name` is a required field.
Should not be able to add a new pet without name
    @{photoUrls}=    Create List    string
    &{data}=    Create Dictionary    photoUrls=${photoUrls}

    ${response}=    POST On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${responseDict}    code
    Should Be Equal As Numbers    ${responseDict}[code]    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `name` should be a string.
Should not be able to add a new pet with non-string name
    @{photoUrls}=    Create List    string
    &{data}=    Create Dictionary    name=${1}    photoUrls=${photoUrls}

    ${response}=    POST On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${responseDict}    code
    Should Be Equal As Numbers    ${responseDict}[code]    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `photoUrls` is required.
Should not be able to add a new pet without photo URLs
    &{data}=    Create Dictionary    name=doggie

    ${response}=    POST On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${responseDict}    code
    Should Be Equal As Numbers    ${responseDict}[code]    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

# This test currently fails because the endpoint still returns 200, contrary to what the API spec says that `photoUrls` should be a list of strings.
Should not be able to add a new pet with non-string list photo URLs
    @{photoUrls}=    Create List    ${1}
    &{data}=    Create Dictionary    name=doggie    photoUrls=${photoUrls}

    ${response}=    POST On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${responseDict}    code
    Should Be Equal As Numbers    ${responseDict}[code]    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message

Should not be able to add a new pet with invalid status
    @{photoUrls}=    Create List    string
    &{data}=    Create Dictionary    name=doggie    photoUrls=${photoUrls}    status=invalid

    ${response}=    POST On Session    petstoresession    /pet    json=${data}

    Status Should Be    405    ${response}
    &{responseDict}=    Set Variable    ${response.json()}
    Dictionary Should Contain Key    ${responseDict}    code
    Should Be Equal As Numbers    ${responseDict}[code]    ${405}
    Dictionary Should Contain Key    ${responseDict}    type
    Dictionary Should Contain Key    ${responseDict}    message