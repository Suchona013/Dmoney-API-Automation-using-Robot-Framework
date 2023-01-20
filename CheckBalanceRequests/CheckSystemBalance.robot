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
${system_bln_req_url}          /transaction/balance/SYSTEM

*** Keywords ***

TC: Check System Balance
    create session  mysession   ${base_url}
    ${json_obj}=       load json from file    ${json_file_path}
    ${token}=          get value from json    ${json_obj}   $.token
    ${headers}=        create dictionary    Content-Type=application/json   Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${response}=       get request      mysession   ${system_bln_req_url}       headers=${headers}
    log to console    ${response.json()}
    should be equal as strings    ${response.status_code}   200
    ${system_balance}=      get value from json    ${response.json()}   balance

