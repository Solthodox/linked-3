// SPDX-License-Identifier: MIT
import "./src/JobSearch.sol";
import "./Collab.sol";
pragma solidity ^0.8.0;
contract Main is JobSearch{
    uint256 _collabCount;
    mapping(address => bool) private _isCollabVerified; 

    struct Project{
        uint256 id;
        string gitHubURI;
        address creator;
        uint256 participants;
        address[] candidates;
        uint256 deadLine;
    }

    Project[] private _projects;

    modifier onlyUsers(){
        (address a , , , , , ,) = getUser(msg.sender);
        require(a!=address(0), "User not registered");  
        _;
    }

    constructor(address tokenAddress) JobSearch(tokenAddress){

    }

    function collabProposal(string memory gitHubURI ,uint256 participants , uint256 waitTime) public onlyUsers{
        require(
            bytes(gitHubURI).length>0 
            && participants>=2 
            && waitTime>0,
             "The settings aren't correct.");
        _projects[_collabCount].id = _collabCount;
        _projects[_collabCount].gitHubURI = gitHubURI;
        _projects[_collabCount].creator = msg.sender;
        _projects[_collabCount].participants = participants;
        _projects[_collabCount].deadLine = block.timestamp + waitTime;
        _collabCount ++;
    }

    
    function joinCollab(uint256 collabId) public onlyUsers{
        require(_collabCount>collabId , "Collab not found.");
        _projects[collabId].candidates.push(msg.sender);
    }

    function submit(uint256 collabId , address [] memory selectedCandidates) public onlyUsers{
        Project memory collab = _projects[collabId];
        require(collab.creator==msg.sender , "You are not the creator of this project.");
        uint256 found;
        Collab newCollab = new Collab(collab.githubURI , selectedCandidates, msg.sender);
        for(uint256 i=0 ; i<collab.candidates.length; i++){
            for(uint256 j=0; i<selectedCandidates.length ; i++){
                if(collab.candidates[i] == selectedCandidates[j]){
                    found++;
                    selectedCandidates[j].projects.push(
                        address(newCollab)
                    );
                }

            }
        }
        require(found==selectedCandidates.length , "You didnt select candidates correctly");

    }


    function _collabVerified(address contractAddress) internal view returns(bool){
        return _isCollabVerified[contractAddress];
    }

    function _beforeUserUpdate(address msgSender) internal virtual override{
        require(_salaryVerified(msgSender));
    }
}