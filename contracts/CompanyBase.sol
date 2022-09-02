pragma solidity ^0.8.0;

contract CompanyBase{
    modifier onlyCompanies(){
        require(_companies[_addressToCompany[msg.sender]].owner!=address(0), "Company not found");
        _;
    }

    struct Company{
        address owner;
        string name;
        string  mainPageURI;
        address[] team;
    }

    uint256 private _companyCount;
    Company[] private _companies;
    mapping(address=> uint256) private _addressToCompany;

    function _addCompany(string memory _name, string memory _mainPageURI , address account) internal{
       _companies[_companyCount].name = _name;
       _companies[_companyCount].mainPageURI = _mainPageURI;
       _companies[_companyCount].owner = account;
       _companies[_companyCount].team.push(account);
       _addressToCompany[account] = _companyCount;
        _companyCount++;
    }

    function _hire(uint256 _companyId , address _account) internal{
        _companies[_companyId].team.push(_account);
    }

}