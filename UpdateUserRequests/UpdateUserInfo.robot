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
${user_update_req_url}          /user/update

*** Keywords ***

TC: Update User
    create session    mysession     ${base_url}
        ${random_number}=   Generate Random String  8   [NUMBERS]
        ${randomName}=      generate random string    8-15
        ${nid}=             convert to string    614353${random_number}
        ${role}=            convert to string    Customer
        ${user_data}=       create dictionary    name=tk    email=abc@gmail.com       password=TestPass    phone_number=013${random_number}    nid=${nid}      role=${role}

        ${user_info_json}=  evaluate    json.dumps(${user_data},indent=4)
        log to console    ${user_info_json}
        ${json_obj}=    load json from file    ${json_file_path}
        ${customer1_id}=   get value from json    ${json_obj}     $.customerId_1
        ${token}=   get value from json    ${json_obj}      token
        ${header}=  create dictionary    Content-Type=application/json      Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
        ${response}=    put request    mysession    ${user_update_req_url}/${customer1_id[0]}    data=${user_info_json}   headers=${header}
        log to console    ${response.content}
        ${message}=     get value from json    ${response.json()}   message

        ${customer_phone_number}=   get value from json    ${response.json()}   user.phone_number
        set to dictionary    ${json_obj}    customer_1_phone_number=${customer_phone_number[0]}
        dump json to file    ${json_file_path}      ${json_obj}
       should contain    ${message[0]}     successfully
       should be equal as strings    ${response.status_code}   200
