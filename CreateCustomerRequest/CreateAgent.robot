*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String

*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ..//VariableJsonFile/Variable.json
${secret_key}   ROADTOSDET

*** Keywords ***

TC: Create an Agent
    create session    mysession     ${base_url}
    ${random_number}=   generate random string    8     [NUMBERS]
    ${randomName}=      generate random string    8-15
    ${randomEmail}=     convert to string       EmailTest${randomName}@gmail.com
    ${password}=        convert to string       TestPassword${randomName}
    ${phoneNumber}=     convert to string       015${random_number}
    ${nid}=             convert to string       65777${random_number}
    ${role}=            convert to string       Agent
    ${user_data}=       create dictionary    name=${randomName}     email=${randomEmail}    password=${password}    phone_number=${phoneNumber}     nid=${nid}      role=${role}
    ${user_info_json}=  evaluate    json.dumps(${user_data},indent=4)
    log to console    ${user_info_json}
    ${json_obj}=    load json from file    ${json_file_path}
    ${token}=       get value from json    ${json_obj}  token
    ${header}=     create dictionary    Content-Type=application/json   Authorization=${token[0]}   X-AUTH-SECRET-KEY=${secret_key}
    ${response}=    post on session    mysession    /user/create    data=${user_info_json}   headers=${header}
    log to console    ${response.content}
    ${message}=     get value from json    ${response.json()}       message
    ${customer_id}=     get value from json    ${response.json()}       user.id
    set to dictionary    ${json_obj}    agent=${customer_id[0]}
    ${customer_phone_number}=   get value from json    ${response.json()}   user.phone_number
    set to dictionary    ${json_obj}    agent_phone_number=${customer_phone_number[0]}
    dump json to file    ${json_file_path}      ${json_obj}
    should be equal    ${message[0]}        User created successfully
    should be equal as strings     ${response.status_code}   201
