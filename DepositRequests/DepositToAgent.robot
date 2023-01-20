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
${req_url}          /transaction/deposit

*** Keywords ***

TC1:Successful Deposit To Agent
    create session    mysession     ${base_url}
    ${json_obj}=       load json from file    ${json_file_path}
    ${token}=          get value from json    ${json_obj}   $.token
    ${agent_phone_number}=      get value from json    ${json_obj}  $.agent_phone_number
    ${amount}=  convert to integer    100
    ${user_info}=   create dictionary    from_account=SYSTEM    to_account=${agent_phone_number[0]}     amount=${amount}

    ${user_info_json}=      evaluate    json.dumps(${user_info},indent=4)
    log to console    ${user_info_json}
    ${header}=  create dictionary    Content-Type=application/json  Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${response}=    POST On Session    mysession    ${req_url}    data=${user_info_json}  headers=${header}
    log to console    ${response.json()}

    ${message}=     get value from json    ${response.json()}   message
    should be equal as strings    ${message[0]}     Deposit successful
    should be equal as strings    ${response.status_code}   201


