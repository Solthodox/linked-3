// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

/**
 * This contract manages the salary of a developer hired by a company
 * The company must deposit a collateral to cover a missed payment
 * Both parts of the contract can break it in any moment
 * It can contain multiple payment methods
 */
interface IERC20 {
    function symbol() external view returns (string memory);

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract Salary {
    address private _owner;
    bool private _ended;
    address[] private _paymentTokens;
    uint256[] private _compensations;
    uint256 private _collateral;
    address private _developer;
    uint256 private _deadLine;
    bool _paymentMissed;
    uint256 _lastCollected;
    error TokenNotFound(address tokenAddress);
    error PaymentError();

    modifier onlyDeveloper() {
        require(msg.sender == _developer, "You are not part of this contract");
        _;
    }

    modifier contractActive() {
        require(!_ended && block.timestamp > _deadLine);
        _;
    }

    modifier onlyOwner() {
        require(msg.sender == owner());
        _;
    }

    modifier withdrawalEnabled() {
        require(_paymentMissed);
        msg.sender.call{value: _collateral}("");
        _;
    }

    modifier onlyDeveloperOrOwner() {
        require(msg.sender == owner() || msg.sender == _developer);
        _;
    }

    constructor(
        address owner,
        address developer,
        address[] memory tokenAddresses,
        uint256 contractDuration,
        uint256[] memory compensations,
        uint256 _collateral
    ) {
        require(contractDuration > 0, "Duration must be greater than 0.");
        _paymentTokens[0] == address(0);
        _compensations[0] == 0;

        for (uint256 i = 0; i < tokenAddresses.length; i++) {
            require(compensations[i] > 0, "You must pay something.");

            if (bytes(IERC20(tokenAddresses[i]).symbol()).length < 1)
                revert TokenNotFound(tokenAddresses[i]);

            _paymentTokens.push(tokenAddresses[i]);
            _compensations.push(compensations[i]);
        }
        _owner = owner;
        _developer = developer;
        _collateral = _collateral;
        _deadLine = block.timestamp + contractDuration;
    }

    /**
     * @notice Function to collect the payment monthly
     */
    function collect(address tokenAddress) public onlyDeveloper contractActive {
        require(block.timestamp >= _lastCollected + 30 days);
        if (_tokenByIndex(tokenAddress) == 0)
            revert TokenNotFound(tokenAddress);

        if (
            !IERC20(tokenAddress).transferFrom(
                owner(),
                msg.sender,
                _compensations[_tokenByIndex(tokenAddress)]
            )
        ) _paymentMissed = true;

        _lastCollected = block.timestamp;
    }

    /**
     * @ notice in case of a missed payment , the developer can claim the collateral to cover the missed payment
     */
    function pullCollateral(bool _breakContract)
        public
        onlyDeveloper
        withdrawalEnabled
    {
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        if (!success) revert PaymentError();
        if (_breakContract == true) {
            breakContract();
        }
    }

    /**
     * This function ends the contract
     */
    function breakContract() public onlyDeveloperOrOwner contractActive {
        if (msg.sender == owner() && !_paymentMissed) {
            (bool success, ) = msg.sender.call{value: address(this).balance}(
                ""
            );
            if (!success) revert PaymentError();
        }

        _ended = true;
    }

    ///GETTERS
    function ended() public view returns (bool) {
        return _ended;
    }

    function paymentTokens() public view returns (address[] memory) {
        return _paymentTokens;
    }

    function compensations() public view returns (uint256[] memory) {
        return _compensations;
    }

    function collateral() public view returns (uint256) {
        return _collateral;
    }

    function developer() public view returns (address) {
        return _developer;
    }

    function deadLine() public view returns (uint256) {
        return _deadLine;
    }

    function paymentMissed() public view returns (bool) {
        return _paymentMissed;
    }

    function owner() public view returns (address) {
        return _owner;
    }

    function _tokenByIndex(address _tokenAddress)
        internal
        view
        returns (uint256)
    {
        for (uint256 i = 0; i < _paymentTokens.length; i++) {
            if (_paymentTokens[i] == _tokenAddress) return i;
        }
        return 0; // returns 0 if not found
    }
}
