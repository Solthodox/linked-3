import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
pragma solidity ^0.8.0;

contract Linked3 is ERC20{
    constructor() ERC20("Linked3" , "LKDN"){
        _mint(msg.sender , 500000 * 10 **18);
    }

}


