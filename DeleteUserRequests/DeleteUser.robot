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
${user_del_req_url}          /user/delete

*** Keywords ***

TC: Delete User
    create session  mysession   ${base_url}
    ${json_obj}=       load json from file    ${json_file_path}
    ${token}=          get value from json    ${json_obj}   $.token

    ${headers}=        create dictionary    Content-Type=application/json   Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${customer1_id}=    get value from json    ${json_obj}   $.customerId_1
    ${response}=       delete request       mysession    ${user_del_req_url}/${customer1_id[0]}        headers=${headers}

    log to console    ${response.json()}

    should be equal as strings    ${response.status_code}   200
    ${message}=     get value from json    ${response.json()}   message
    should be equal as strings    ${message[0]}     User deleted successfully