*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    JSONLibrary
Library    os
Library    String
Resource    ../LoginRequests/LoginWithValidCredential.robot
Resource    ../CreateCustomerRequest/CreateAgent.robot
Resource    ../CreateCustomerRequest/CreateCustomer_1.robot
Resource    ../CreateCustomerRequest/CreateCustomer_2.robot
Resource    ../DepositRequests/DepositToAgent.robot
Resource    ../CheckBalanceRequests/CheckAgentBalance.robot
Resource    ../CheckBalanceRequests/CheckSystemBalance.robot
Resource    ../DepositRequests/DepositToCustomer.robot
Resource    ../CheckBalanceRequests/CustomerBalanceAfterDeposit.robot
Resource    ../WithdrawMoneyRequests/WithdrawMoney.robot
Resource    ../SendMoneyRequests/SendMoney.robot
Resource    ../UpdateUserRequests/UpdateUserInfo.robot
Resource    ../DeleteUserRequests/DeleteUser.robot
Resource    ../SearchUserRequests/SearchUser.robot

*** Test Cases ***
login
    TC: Successful Login with Valid Credential

Create Users
    TC: Create a Customer 1
    TC: Create a Customer 2
    TC: Create an Agent

Search User Info for New Created Users
    TC: Search User

Deposit to Agent
    TC1:Successful Deposit To Agent

Check System Balance After Deposit to agent
    TC: Check System Balance

Check Agent Balance after Deposit From System to Agent
    TC: Check Agent Balance

Deposit to Customer
    TC: Deposit To Customer & Validate Checking Agent Balance After Depositing to Customer


Check Agent Balance after Deposit From Agent to Customer
    TC: Check Agent Balance

Check Customer Balance After Deposit & Before Send Money
    TC: Check Customer Balance After Deposit

Withdraw Money
    TC: Withdraw Money By Customer

Check Customer Balance After Withdraw Money
    TC: Check Customer Balance After Deposit

Send Money From Customer To Another Customer
    TC: Send Money From Customer 1 To Customer 2 & Validate Checking Customer Balance After Send Money to another customer

Update User Info
    TC: Update User

Delete User Info
    TC: Delete User

Search User Info After Deleted the User
    TC: Search User

