// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
contract Referrals{

    mapping(address => uint256) private _referralBalances;
    mapping(bytes => address) private _referralCodes;
    uint256 private _totalReferrals;

    function _getReferral(address _user) internal view returns(bytes){
        return abi.encodePacked(_user);

    }

    function _getDiscount(bytes _referralCode) internal view returns(uint256){
        uint256 discount = _
    }

    function _setReferral(address _account) internal{
        _referralCodes[_account] = abi.encodePacked(_account);
    }

    function _useReferral(address _account , bytes _referralCode , uint256 price) internal{
        require(_referralCodes[_referralCode]!=address(0), "That code isnt valid");
        _referralBalances[_referralCodes[_referralCode]]+= price * (1000 -_getDiscount(_referralCode) ) ;
    }


   
}
