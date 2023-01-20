*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os

*** Variables ***
${base_url}     http://dmoney.roadtocareer.net
${json_file_path}   ..//VariableJsonFile/Variable.json

*** Keywords ***

TC: Successful Login with Valid Credential
    create session    mysession     ${base_url}
    ${body}=    create dictionary    email=salman@roadtocareer.net      password=1234
    ${header}=  create dictionary    Content-Type=application/json
    ${response}=    post on session    mysession    /user/login     json=${body}    headers=${header}
    log to console    response:\n ${response.content}
    ${message}=     get value from json    ${response.json()}   message
    log to console    message:\n ${message[0]}
    ${token}=   get value from json    ${response.json()}   token
    ${json_obj}=    load json from file    ${json_file_path}
    set to dictionary    ${json_obj}    token=${token[0]}
    dump json to file    ${json_file_path}      ${json_obj}
    should be equal  ${message[0]}  Login successfully
    should be equal as strings    ${response.status_code}   200