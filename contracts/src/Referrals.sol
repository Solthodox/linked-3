// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
/**
* @notice A simple integration of a referrals program to incentivate the use of the platform
 */
contract Referrals{
    mapping(address => uint256) private _referralBalances; 
    mapping(bytes => address) private _referralCodes;
    uint256 private _totalReferrals;
    /**
    * @dev Returns the referral code of a certain address as a bytes
     */
    function _getReferral(address _user) internal view returns(bytes){
        return abi.encodePacked(_user);

    }
    /**
    * @notice Returns the discount % based on the code used
     */
    function _getDiscount(bytes _referralCode) internal view returns(uint256){
        uint256 discount = _totalReferrals
    }
    /**
    * @dev saves the referral code in a mapping
     */
    function _setReferral(address _account) internal{
        _referralCodes[_account] = abi.encodePacked(_account);
    }

    /**
    *@dev Increase the reward of the referral code owner
     */
    function _useReferral(address _account , bytes _referralCode , uint256 price) internal{
        require(_referralCodes[_referralCode]!=address(0), "That code isnt valid");
        uint256 rewardAmount = price * (1000 -_getDiscount(_referralCode) );
        _referralBalances[_referralCodes[_referralCode]]+= rewardAmount;
        _totalReferrals += rewardAmount;
        
    }

}
