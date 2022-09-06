// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./Referrals.sol";
import "../Salary.sol";
import "./UserBase.sol";
import "./CompanyBase.sol";

/**
* The core of the job searching and hiring functionalities
 */

contract JobSearch is userBase , CompanyBase , Referrals{

    uint256 private _offerCount; 
    address public tokenAddress; 
    mapping(address => bool) private _isSalaryVerified;
    jobOffer[] _offers; // list of the all job offers available
    constructor (address _tokenAddress){
        tokenAddress = _tokenAddress;
    }
    // modifier that makes a payment necessary to call functions
    modifier payLinked3(uint256 amount){
        _;
        require(IERC20(tokenAddress).transferFrom(msg.sender , address(this), amount),
        "You need to pay for this service");
    }

    // Job offer struct obejct
    struct jobOffer{
        uint256 id;
        address company;
        string role;
        uint256 experience;
        int256 trustLevel;
        address[] appliants;
        bool closed;

    }

    /**
    * @notice Function to register a new developer to the platform
    * @ dev Should include : 
        - Users Github url => if its fake it will be reported later
        - ReferralCode(optional)
    */
    function registerUser(string memory githubURI , bytes memory referralCode)
        public  
        payLinked3(_useReferral(referralCode, newUserPrice()))
    {
        require(!_isContract(msg.sender) , "Sorry, only EOAs can call this function");
        _addUser(githubURI, msg.sender);
        _setReferral(msg.sender);
    }

    /**
    * @notice Function to register a new company to the platform
    * @ dev Should include : 
        - Name
        - Company website url
        - Referral Code(optional)
    */
    function registerCompany(string memory name , string memory mainPageURI , bytes memory referralCode) 
        public 
        payLinked3(_useReferral(referralCode, newCompanyPrice()))
    {
        require(!_isContract(msg.sender) , "Sorry, only EOAs can call this function");
        _addCompany(name, mainPageURI , msg.sender);

    }
    /**
    * @notice Function that the companies use to post new job offers 
    * @dev params :
        - Role name(string)
        - Required experience level
        - Required trustLevel
    * Companies must pay for posting the offer
     */
    function newJobOffer
    (
        string memory role, 
        uint256 experience,
        int256 trustLevel 
    )public 
    onlyCompanies
    payLinked3(newJobOfferPrice())   
    {
        _offers[_offerCount].id = _offerCount;
        _offers[_offerCount].company = msg.sender;
        _offers[_offerCount].role = role;
        _offers[_offerCount].experience = experience;
        _offers[_offerCount].trustLevel = trustLevel;
        _offerCount++;
    }

    /**
    * @notice Function to apply for a offer
    * @dev It reverts if : 
        - Offer doesnt exist
        - Offer is closed already
        - User doesn't meet the trust and experience requirements
     */


    function applyForJob(uint256 offerId) public onlyUsers{
        require(_offers[offerId].company!=address(0), "Offer not found");
        require(!_offers[offerId].closed, "Offer not available anymore");
        require(
            _offers[offerId].experience <= users()[addressToUser(msg.sender)].experience
            && _offers[offerId].trustLevel <= users()[addressToUser(msg.sender)].trustLevel ,
            "Sorry , you don't meet the requirements"
        );
        _offers[offerId].appliants.push(msg.sender);
    }

    /**
    * @notice Function for companies to hire new devlopers
    * @dev Should hava as input :
        - Developer address
        - Token(s) to pay with
        - The duration of the contract
        - Compensations of different tokens
        - Collateral(it will be liquidated in case of missing payment)
    * @dev It adds the developer to the company's team and also the salary to the devloper's profile
     */
    function hire(
        address developer,
        address[] memory tokenAddresses , 
        uint256 contractDuration, 
        uint256[] memory compensations,
        uint256 _collateral
    ) public onlyCompanies{
        require(users()[addressToUser(developer)].account!=address(0),"Developer not found");
        Salary newSalaryContract = new Salary(
            msg.sender,
            developer,
            tokenAddresses,
            contractDuration,
            compensations,
            _collateral
        );
        _isSalaryVerified[address(newSalaryContract)]=true;
        _hire(addressToCompany(msg.sender) , developer);
        _getHired(developer , address(newSalaryContract));

    }

    function closeOffer(uint256 offerId) public onlyCompanies{
        require(_offers[offerId].company==msg.sender);
        _offers[offerId].closed = true;
        
    }

    ///GETTERS

    // Prices
    function newUserPrice() public view returns(uint256){
        return newJobOfferPrice() * 2;
    }

    function newCompanyPrice() public view returns(uint256){
        return newJobOfferPrice() * 3;
    }

    function newJobOfferPrice() public view returns(uint256){
        uint256 price = (100 *10**18)  + users().length;

    }
    // All offers
    function getAllOffers() public view returns(jobOffer [] memory){
        return _offers;
    }

    // Check if a salary contract has been created from the main contract
    function _salaryVerified(address contractAddress) internal view returns(bool){
        return _isSalaryVerified[contractAddress];
    }


}