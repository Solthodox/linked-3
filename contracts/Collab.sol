// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

// Interface of the main contract
interface Main{
    function _addExperience(address _account) external;
    function _upgradeTrust(address _account , int256 _newTrust) external;
    function _commentProfile(address _from , address _to ,string memory _comment) external;
     function getUser(address account) external view returns(
        address ,
        string  memory ,
        uint256 ,
        int256 ,
        string[] memory ,
        address[] memory ,
        address [] memory
    );
}

// Contract that will be created if a collaboration starts

contract Collab {
    address private _owner;
    string private _ghUri;
    address [] private _contributors;
    uint256 private _collateralBase;
    address public mainContract;

    // All the reasons to report a contributor

    uint256 public constant REASON_BadBehaviour = 1;
    uint256 public constant REASON_Inactivity = 2;
    uint256 public constant REASON_CreatorDidntMeetProposal = 3;
    uint256 public constant REASON_IdentityFraud = 5;

    modifier onlyOwner(){
        require(msg.sender==_owner);
        _;
    }

    // Contributors must deposit a collateral first as a incentive to play fair
    function depositCollateral() public payable{
        (,,, int256 trustLevel,,,) = Main(mainContract).getUser(msg.sender);
        uint256 factor = trustLevel > 1 ? uint256(trustLevel) : 1;
        uint256 collateralForUserLevel = (1 ether / 1000) / factor;
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
    /**
    * @notice Negative valoration, reduces trust level
     */

    function report(address contributor , uint256[] calldata reasons) public contributors{
        require(contributor!=msg.sender);
        require(_isContributor(contributor));
        require(reasons.length>0);

        uint256 _negativeTrustLevel;
        for(uint256 i=0; i<reasons.length ; i++){
            require(reasons[i]<=5);
            if(reasons[i]==3){require(contributor!=_owner);}
            _negativeTrustLevel += reasons[i];
        }

        Main(mainContract)._upgradeTrust(contributor , -int256(_negativeTrustLevel));
    }

    /**
    * @notice Positive valoration , increases trust level
     */

    function recommend(address contributor) public contributors{
        require(_isContributor(contributor));
        int256 _positiveTrustLevel = 2;
        Main(mainContract)._upgradeTrust(contributor , _positiveTrustLevel);

    }

    /**
    * @notice Users can comment their valorations in other users' profiles
     */
    function comment(address contributor , string memory text) public contributors{
        require(_isContributor(contributor));
        Main(mainContract)._commentProfile(msg.sender , contributor , text);

    }

    // Check if a certain account is part of the project

    function _isContributor(address account) internal view returns(bool){
        bool found;
        for(uint i; i<_contributors.length; i++){
            if(_contributors[i]==account) found = true;
            
        }
        return found;
    }


}