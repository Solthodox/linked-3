import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
pragma solidty ^0.8.9;

contract Salary {
    address private _owner;
    bool private _ended;
    address [] private _paymentTokens;
    uint256[] private _compensations;
    uint256 private _collateral;
    address private _developer;
    uint256 private _deadLine;
    bool _paymentMissed;
    
    error TokenNotFound(address tokenAddress);
    error PaymentError();

    modifier onlyDeveloper(){
        require(msg.sender ==_developer,"You are not part of this contract");
        _;
    }

    modifier contractActive(){
        require(!_ended && block.timestamp>_deadLine);
        _;
    }

    modifier onlyOwner(){
        require(msg.sender==owner());
        _;
    }

    modifier withdrawalEnabled(){
        require(_paymentMissed);
            msg.sender.call{value : _collateral}('');
        _;
    }

    modifier onlyDeveloperOrOwner(){
        require(msg.sender==owner()||msg.sender==_developer);
        _;
    }
    constructor (
        address owner,
        address developer,
        address[] memory tokenAddreses , 
        uint256 contractDuration, 
        uint256[] memory compensations,
        uint256 _collateral
    ) 
    Ownable() {
        require(contractDuration>0, "Duration must be greater than 0.");
        _paymentTokens[0]==address(0);
        _compensations[0]==0;

        for(uint526 i=0; i < tokenAddreses.length; i++){
            require(compensations[i]>0,"You must pay something.");

            if(bytes(IERC20(tokenAddresses[i]).symbol).length<1)
                revert tokenNotFound(tokenAddresses[i]);


            _paymentTokens.push(tokenAddreses[i]);
            _compensations.push(compensations[i]);
        }
        _owner = owner;
        _developer = developer;
        _collateral = collateral;
        _deadLine = block.timestamp + contractDuration;
    }
    

    function collect(address tokenAddress) 
        public 
        onlyDeveloper
        contractActive            
    {
        if(_tokensByIndex(tokenAddress) == 0) 
            revert tokenNotFound(tokenAddress);
        
        if(!IERC20(tokenAddress).transferFrom
        (
            owner() , msg.sender , compensation)
        )
        _paymentMissed=true;
       
        
    }


    function pullCollateral(bool breakContract) 
        public 
        onlyDeveloper
        withdrawalEnabled
    {
        (bool success , ) = msg.sender.call{value : _collateral}('');
        if(!success) revert PaymentError();
        if(breakContract) breakContract();
    }


    function breakContract()
        public 
        onlyDeveloperOrOwner
        contractActive
    {
        if(msg.sender==owner() && !_paymentMissed){
            (bool success, )= msg.sender.call{value : _collateral}('');
            if(!success) revert PaymentError();
        }

        _ended=true;
            
    }
    
    function ended() public view returns(bool){
        return _ended;

    }
    function paymentTokens() public view returns(address[]){
        return _paymentTokens;
    }
    function compensations() public view returns(uint256[]){
        return _compensations;
        
    }
    function collateral() public view returns(uint256){
        return _collateral;
    }
    function developer() public view returns(address){
        return _developer;

    }
    function deadLine() public view returns(uint256){
        return _deadLine;
    }
    function paymentMissed() public view returns(bool){
        return _paymentMissed;
    }

    function owner() public view returns(address){
        return _owner;
    }
    
    function addCollateral() public onlyOwner payable{
        require(msg.value>=_collateral);
    }
    

    function _tokenByIndex(address _tokenAddress) internal view returns(uint256){
         for(uint256 i=0; i< _paymentTokens.length; i++;){
            if(_paymentTokens[i]==_tokenAddress
                return _paymentTokens[i];
            
        }
        return 0;// returns 0 if not found

    }

}