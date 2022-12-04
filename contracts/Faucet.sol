// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;
import "./IERC20.sol";


contract Faucet{


 address public tokenAddress;
   constructor(address _tokenAddress){
      tokenAddress = _tokenAddress;
   }

   function getToken(uint256 _amt) external payable {
        require(
            IERC20(tokenAddress).balanceOf(address(this)) > 0,
            "No more Token to Disburse, Try another time"
        );

        IERC20(tokenAddress).transfer(msg.sender, 10 * 1e18); //mint token to user
            
    }

        function getTokenBal() public view returns (uint256) {
        return IERC20(tokenAddress).balanceOf(address(this));
    }
  

}