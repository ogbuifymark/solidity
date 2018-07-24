pragma solidity ^0.4.18;
contract owned {
    address public owner;

    function owned() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}


contract Payroll is owned {
    struct Anemployee {
        address Address;
        bytes32 employeeName;
        uint256 salaryAmount;
        uint availableBalance;
        uint bonus;
    }
    struct Organization {
        address companyAccount;
        uint companyAmount;
    }
    mapping(address => Anemployee) public employee;
    mapping(address => Organization) public company;
    mapping(address => uint) public account;
    Anemployee public thisemployee;
    Organization public thiscompany;
    uint public dueDate =now;
    bool check;
    
    function initializeCompanyAccount(address _companyAccount, uint _companyBalance) public{
        Organization storage payer = company[_companyAccount];
        payer.companyAccount = _companyAccount;
        payer.companyAmount = _companyBalance;
        thiscompany = payer;
    }
    
    function InitializePayrole(uint _employeeSalary, bytes32 _employeeName, 
    uint _dueDate) public {
        Anemployee storage receiver = employee[msg.sender];
        receiver.Address = msg.sender;
        receiver.salaryAmount = _employeeSalary;
        receiver.employeeName = _employeeName;
        dueDate = _dueDate;
        thisemployee = receiver;
    }
    
    function receivePayment() public {
        if(dueDate < now){
            if (thiscompany.companyAmount > thisemployee.salaryAmount){
                check =  transfer(thisemployee.salaryAmount);
                if (check){
                   dueDate = now + 30 days;
                }
            }
        }
    }
    function transfer( uint256 _value)public returns(bool) {
        require(thiscompany.companyAmount >= _value);
        thiscompany.companyAmount -= _value;
        thisemployee.availableBalance += _value;
        return true;
    }
    
}