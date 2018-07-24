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
        uint employeeId;
        uint256 salaryAmount;
        uint availableBalance;
        uint bonus;
        address OrganizationAddress;
        address employeeAddress;
    }
    struct Organization {
        address companyAccount;
        uint companyAmount;
        uint ID;
        uint paymentDay;
    }
    
    mapping(address => Anemployee) public employee;
    mapping(address => Organization) public company;
    mapping(address => uint) public account;
    
    Anemployee[] public thisemployee;
    Organization[] public thiscompany;
    uint public dueDate =now;
    bool check;
    bytes32 errorMessage;
    
    function Payroll(){
        
    }
    function initializeCompanyAccount(address _companyAccount, uint _companyBalance, uint _id) onlyOwner {
        Organization storage payer = company[_companyAccount];
        payer.companyAccount = _companyAccount;
        payer.companyAmount = _companyBalance;
        payer.ID = _id;
        payer.paymentDay = 3 seconds;
        thiscompany.push(payer);
    }
    
    //function displayError
    
    function addEmployee(uint _employeeSalary, uint _employeeId, 
    uint _dueDate, address _companyAddress, address _employeeAddress, uint _bonus) onlyOwner {
        Anemployee storage receiver = employee[msg.sender];
        receiver.Address = msg.sender;
        receiver.salaryAmount = _employeeSalary;
        receiver.employeeId = _employeeId;
        receiver.employeeAddress = _employeeAddress;
        receiver.OrganizationAddress = _companyAddress;
        receiver.bonus = _bonus;
        thisemployee.push(receiver);
    }
    
    function editOrganisationInfo(uint _amount, address _companyAddress, uint _id)  public {
        for (uint i=0; i<thiscompany.length; i++){
            Organization storage payer = company[thiscompany[i].companyAccount];
            if (payer.ID == _id) {
                payer.companyAmount = _amount; 
            }
        }
    }
    function editEmployeeInfo(uint _amount, address _employeeAddress, uint _id, uint _bonus)  public {
        for (uint i=0; i<thisemployee.length; i++){ 
            Anemployee storage receiver = employee[thisemployee[i].Address];
            if (receiver.employeeId == _id) {
                receiver.salaryAmount = _amount; 
                receiver.bonus = _bonus; 
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