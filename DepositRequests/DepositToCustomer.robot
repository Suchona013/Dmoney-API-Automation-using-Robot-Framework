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

TC: Deposit To Customer & Validate Checking Agent Balance After Depositing to Customer
    create session    mysession     ${base_url}
    ${json_obj}=       load json from file    ${json_file_path}
    ${token}=          get value from json    ${json_obj}   $.token
    ${agent_phone_number}=      get value from json    ${json_obj}      $.agent_phone_number
    ${customer1_phone_number}=   get value from json    ${json_obj}     $.customer_phone_number_1
    log to console    Value saved as a list:${customer1_phone_number}
    ${agent_bln_before_deposit}=   get value from json    ${json_obj}     $.agent_balance
    log to console    before deposit:${agent_bln_before_deposit[0]}

    ${amount}=  convert to integer    50

    log to console     deposit amount:${amount}
    ${agent_bln_after_deposit}=     evaluate    ${agent_bln_before_deposit[0]}-${amount}+1.25
    log to console    after deposit:${agent_bln_after_deposit}
    ${user_info}=   create dictionary    from_account=${agent_phone_number[0]}    to_account=${customer1_phone_number[0]}     amount=${amount}
    #Converting dictionary to json
    ${user_info_json}=      evaluate    json.dumps(${user_info},indent=4)
    log to console    ${user_info_json}
    ${header}=  create dictionary    Content-Type=application/json      Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${response}=    POST On Session    mysession        ${req_url}        data=${user_info_json}  headers=${header}
    log to console    ${response.json()}
    #validatins
    ${message}=     get value from json    ${response.json()}   message
    ${agent_current_bln}=     get value from json    ${response.json()}   currentBalance
    should be equal as strings    ${message[0]}     Deposit successful
    should be equal as strings    ${response.status_code}   201
    should be equal     ${agent_bln_after_deposit}   ${agent_current_bln[0]}
    #log to console    TT:${agent_bln_after_deposit}   OK:${agent_current_bln[0]}

