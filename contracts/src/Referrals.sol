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
    function _getReferral(address _user) internal view returns(bytes memory){
        return abi.encodePacked(_user);

    }
    /**
    * @notice Returns the discount % based on the code used
     */
    function _getDiscount(bytes memory  _referralCode) internal view returns(uint256){
        uint256 discount = _totalReferrals * 1000 / _referralBalances[_referralCodes[_referralCode]];
    }
    /**
    * @dev saves the referral code in a mapping
     */
    function _setReferral(address _account) internal{
        _referralCodes[abi.encodePacked(_account)] = _account;
    }

    /**
    *@dev Increase the reward of the referral code owner
     */
    function _useReferral( bytes memory _referralCode , uint256 price) internal returns(uint256){
        require(_referralCodes[_referralCode]!=address(0), "That code isnt valid");
        uint256 rewardAmount = 1000 -_getDiscount(_referralCode) ;
        _referralBalances[_referralCodes[_referralCode]]+= rewardAmount;
        _totalReferrals += rewardAmount;
        
        return 
            _referralCode.length> 1 ?  price - (price *  _getDiscount(_referralCode) / 1000 )
            : price;
    }

    function getReferral(address user) internal view returns(bytes memory){
        return abi.encodePacked(user);

    }

}
