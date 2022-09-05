// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Main{
    function _addExperience(address _account) external;
    function _upgradeTrust(address _account , int256 _newTrust) external;
}

contract Collab {
    address private _owner;
    string private _ghUri;
    address [] private _contributors;
    uint256 private _collateralBase;
    address public mainContract;

    uint256 public constant REASON_BadBehaviour = 1;
    uint256 public constant REASON_Inactivity = 2;
    uint256 public constant REASON_CreatorDidntMeetProposal = 3;

    modifier onlyOwner(){
        require(msg.sender==_owner);
        _;
    }


    function depositCollateral() public payable{
        uint256 collateralForUserLevel;
        require(msg.value>=collateralForUserLevel);
    }
    mapping(address => uint256) _reportCount;

    modifier contributors(){
        require(_isContributor(msg.sender));
        _;
    }
    constructor(string memory githubURI , address[] memory contributors, address owner , address mainContract) {
        _ghUri = githubURI;
        _contributors = contributors;
        _owner = owner;
        mainContract = mainContract;
    }

    function report(address contributor , uint256[] calldata reasons) public contributors{
        require(_isContributor(contributor));
        uint256 _negativeTrustLevel;
        for(uint256 i=0; i<reasons.length ; i++){
            require(reasons[i]<=3);
            _negativeTrustLevel += reasons[i];
        }
        Main(mainContract)._upgradeTrust(contributor , -int256(_negativeTrustLevel));
    }

    function recommend(address contributor) public contributors{
        require(_isContributor(contributor));
        int256 _positiveTrustLevel = 2;
        Main(mainContract)._upgradeTrust(contributor , _positiveTrustLevel);

    }

    function comment(address contributor , string memory text) public contributors{
        require(_isContributor(contributor));
        Main(mainContract)._commentProfile(msg.sender , contributor , text);

    }

    function _isContributor(address account) internal view returns(bool){
        bool found;
        for(uint i; i<_contributors.length;){
            if(_contributors[i]==msg.sender) found = true;
            unchecked {
                i++;
            }
        }
        return found;
    }


}