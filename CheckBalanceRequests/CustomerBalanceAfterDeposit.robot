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
${user_bln_after_deposit_req_url}        /transaction/balance/

*** Keywords ***

TC: Check Customer Balance After Deposit
    create session  mysession   ${base_url}
    ${json_obj}=       load json from file    ${json_file_path}
    ${token}=          get value from json    ${json_obj}   $.token
    ${headers}=        create dictionary    Content-Type=application/json   Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${customer1_phone_number}=  get value from json    ${json_obj}  $.customer_phone_number_1
    ${response}=       get request      mysession  ${user_bln_after_deposit_req_url}${customer1_phone_number[0]}     headers=${headers}
    log to console    ${response.json()}
    ${customer1_balance}=   get value from json    ${response.json()}   balance
    set to dictionary    ${json_obj}    customer1_balance=${customer1_balance[0]}
    dump json to file    ${json_file_path}  ${json_obj}
    #Validations.
    should be equal as strings    ${response.status_code}   200
     #validatins
    ${message}=     get value from json    ${response.json()}   message
    should be equal as strings    ${message[0]}     User balance
    log to console    ${message[0]}