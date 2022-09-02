pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./Referrals.sol";
import "./Salary.sol";
import "./UserBase.sol";
import "./CompanyBase.sol";
contract JobSearch is userBase , CompanyBase , Referrals{

    uint256 private _offerCount;
    address public tokenAddress;
    constructor (address _tokenAddress){
        tokenAddress = _tokenAddress;
    }

    modifier payLinked3(uint256 amount){
        _;
        require(IERC20(tokenAddress).transferFrom(msg.sender , address(this), amount),
        "You need to pay for this service");
    }

    jobOffer[] _offers;
    struct jobOffer{
        uint256 id;
        address company;
        string role;
        uint256 experience;
        uint256 trustLevel;
        address[] appliants;
        bool closed;

    }

    function registerUser(string memory githubURI , bytes referralCode)
        public  
        payLinked3(newUserPrice() - _getDiscount(referralCode))
    {
        require(!_isContract(msg.sender) , "Sorry, only EOAs can call this function");
        if(referralCode!=""){
            _useReferral(msg.sender , referralCode , newUserPrice());
        }
        _addUser(githubURI, msg.sender);
        _setReferral(msg.sener);
    }


    function registerCompany(string memory name , string memory mainPageURI , bytes referralCode) 
        public 
        payLinked3(newCompanyPrice() - _getDiscount(referralCode))
    {
        require(!_isContract(msg.sender) , "Sorry, only EOAs can call this function");
        if(referralCode!=""){
            _useReferral(msg.sender , referralCode , newCompaniesPrice());
        }

        _addCompany(name, mainPageURI , msg.sender);

    }

    function newJobOffer
    (
        string memory role, 
        uint256 experience,
        uint256 trustLevel 
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

    function applyForJob(uint256 offerId) public onlyUsers{
        require(_offers[offerId].company!=address(0), "Offer not found");
        require(!_offers[offerId].closed, "Offer not available anymore");
        require(
            _offers[offerId].experience<=_addressToUser[msg.sender].experience
            && !_offers[offerId].trustLevel <= _addressToUser[msg.sender].trustLevel,
            "Sorry , you don't meet the requirements"
        );
        _offers[offerId].appliants.push[msg.sender];
    }

    function hire(
        address developer,
        address[] memory tokenAddreses , 
        uint256 contractDuration, 
        uint256[] memory compensations,
        uint256 _collateral
    ) public onlyCompanies{
        require(_addressToUser[developer].account!=address(0),"Developer not found");
        Salary newSalaryContract = new Salary(
            msg.sender,
            developer,
            tokenAddresses,
            contractDuration,
            compensations,
            collateral
        );
        _hire(_addressToCompany[msg.sender]);
        _getHired(developer , address(newSalaryContract));

    }

    function closeOffer(uint256 offerId) public onlyCompanies{
        require()
    }
    function newUserPrice() public view returns(uint256){
        return newJobOfferPrice() * 2;
    }

    function newCompanyPrice() public view returns(uint256){
        return newJobOfferPrice() * 3;
    }

    function newJobOfferPrice() public view returns(uint256){
        uint526 price = (100 *10**18)  + users().length;

    }



}