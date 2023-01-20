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
${send_money_req_url}       /transaction/sendmoney

*** Keywords ***

TC: Send Money From Customer 1 To Customer 2 & Validate Checking Customer Balance After Send Money to another customer
    create session    mysession     ${base_url}
    ${json_obj}=       load json from file    ${json_file_path}
    ${token}=          get value from json    ${json_obj}   $.token
    ${customer1_phone_number}=   get value from json    ${json_obj}     $.customer_phone_number_1
    ${customer2_phone_number}=   get value from json    ${json_obj}     $.customer_phone_number_2
    ${customer_1_bln_before_send_money}=   get value from json    ${json_obj}     $.customer1_balance
    log to console    customer 1 balance:${customer_1_bln_before_send_money}
    ${amount}=  convert to integer    20
    ${bln_after_send_money}=     evaluate    ${customer_1_bln_before_send_money[0]}-${amount}-5
    log to console    customer 1 balance after deposit:${bln_after_send_money}
    ${user_info}=   create dictionary    from_account=${customer1_phone_number[0]}    to_account=${customer2_phone_number[0]}     amount=${amount}

    ${user_info_json}=      evaluate    json.dumps(${user_info},indent=4)
    log to console    ${user_info_json}
    ${header}=  create dictionary    Content-Type=application/json  Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${response}=    POST On Session    mysession    ${send_money_req_url}  data=${user_info_json}  headers=${header}
    log to console    ${response.json()}

    ${message}=     get value from json    ${response.json()}   message
    ${current_bln_after_send_money}=     get value from json    ${response.json()}   currentBalance
    should be equal as strings    ${message[0]}     Send money successful
    should be equal as strings    ${response.status_code}   201
    should be equal    ${current_bln_after_send_money[0]}   ${bln_after_send_money}
