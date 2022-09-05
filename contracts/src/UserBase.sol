// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract userBase{
    uint256 private _userCount;
    user[] private _accounts;
    mapping(address=> uint256) private _addressToUser;

    struct user{
        address account;
        string  githubURI;
        uint256 experience;
        int256 trustLevel;
        string[] comments;
        address [] projects;
        address[] contracts;
    }

    modifier onlyUsers(){
        require(_accounts[_addressToUser[msg.sender]].account!=address(0) ,"Account not found.");
        _;
    }

    function _addUser(string memory _githubURI, address _account) internal{
        _accounts[_userCount].account = _account;
        _accounts[_userCount].githubURI = _githubURI;
        _addressToUser[msg.sender] = _userCount;
        _userCount++;
    }

    function _commentProfile(address _from , address _to ,string memory _comment) external{
        _beforeUserUpdate(msg.sender);
        require(bytes(_accounts[_addressToUser[msg.sender]].githubURI).length>0);
        string memory text = string(bytes.concat(abi.encodePacked(_from), "  : ", bytes(_comment)));

        _addressToUser[_to].comments.push(text);
    }

    function _addExperience(address _account) external{
        _beforeUserUpdate(msg.sender);
        _addressToUser[_account].experience++;
    }

    function _getHired(address _account , address _newSalary) internal{
        _accounts[_addressToUser[_account]].contracts.push(_newSalary);
    }
    function _upgradeTrust(address _account , int256 _newTrust) external{
        require(_newTrust!=int256(0));
        _beforeUserUpdate(msg.sender);
        _addressToUser[_account].trustLevel += _newTrust;
    }
    
    function _isContract(address _addr) internal returns (bool isContract){
        uint32 size;
        assembly {
          size := extcodesize(_addr)
        }
        return (size > 0);
    }

    function users() internal view returns(user[]  memory){
        return _accounts;
    }

    function getUser(address account) public view returns(
        address ,
        string  memory ,
        uint256 ,
        int256 ,
        string[] memory ,
        address[] memory ,
        address [] memory
    ){
        user memory u = _accounts[_addressToUser[account]];
        
        return(
            u.account,
            u.githubURI,
            u.experience,
            u.trustLevel,
            u.comments,
            u.projects,
            u.contracts
        );
    }

    function _beforeUserUpdate(address msgSender) internal virtual{}
  
}