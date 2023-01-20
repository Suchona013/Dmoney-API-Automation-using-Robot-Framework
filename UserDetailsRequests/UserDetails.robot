*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String

*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ..//VariableJsonFile/Variable.json
${secret_key}       ROADTOSDET
${req_url}          user/search?

*** Test Cases ***
TC:1 Get Customer_1_Details
    create session  mysession   ${base_url}
    ${json_obj}=       load json from file    ${json_file_path}
    ${token}=          get value from json    ${json_obj}   $.token
    ${id}=             get value from json    ${json_obj}   $.customerId_1
    ${headers}=        create dictionary    Content-Type=application/json   Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${param}=          create dictionary    id=${id[0]}
    ${response}=       get request      mysession  ${req_url}   params=${param}     headers=${headers}
    #Extracting Values from json response.
    ${customer1_id}=    get value from json    ${response.json()}   user.id
    log to console    ${response.json()}
    #Validations.
    should be equal as strings    ${response.status_code}   200
    should be equal as strings    ${customer1_id[0]}    ${id[0]}
