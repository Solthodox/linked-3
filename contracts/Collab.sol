pragma solidity ^0.8.0;
contract Collab {
    address private _owner;
    string private _ghUri;
    address [] private _contributors;
    uint256 private _collateralBase;
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
        bool found;
        for(uint i; i<_contributors.length;){
            if(_contributors[i]==msg.sender) found = true;
            unchecked {
                i++;
            }
        }
        require(found);
        _;
    }
    constructor(string memory githubURI , address[] memory contributors, address owner) {
        _ghUri = githubURI;
        _contributors = contributors;
        _owner = owner;
    }

    function report(address contributor , uint256[] calldata reasons ) public contributors{}

    function recommend(address contributor) public contributors{}

    
}