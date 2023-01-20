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
${search_user_req_url}        /user/search?id=

*** Keywords ***

TC: Search User
    create session  mysession   ${base_url}
    ${json_obj}=       load json from file    ${json_file_path}
    ${token}=          get value from json    ${json_obj}   $.token
    ${customer_1_id}=          get value from json    ${json_obj}   $.customerId_1
    ${headers}=        create dictionary    Content-Type=application/json   Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${response}=       get request      mysession   ${search_user_req_url}${customer_1_id}       headers=${headers}
    log to console    ${response.json()}
    should be equal as strings    ${response.status_code}   200


