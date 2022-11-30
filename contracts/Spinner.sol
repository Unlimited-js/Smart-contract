// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./IERC20.sol";
import "./ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract Spinner is VRFConsumerBase{

    using Counters for Counters.Counter;
    using SafeMath for uint256;

    ////////////////////STATE VARIABLES///////////////////

    address admin;

    address immutable tokenAddress;

    bytes32 internal keyHash;

    uint256 internal fee;

    uint256 randomResult;

    struct Spin{
        uint256 spinId;
        address[] players;
        uint256 EntryPrice;
        uint256 prize;
        address winner;
        bool claimed;
        bool isFinished;
        uint256 deadline;
    }

    ////////////////////CONSTRUCTOR/////////////////////
     constructor( address _tokenAddress) VRFConsumerBase(
            0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, // VRF Coordinator
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB  // LINK Token 
          ) 
    {
        admin = msg.sender;
        tokenAddress = _tokenAddress;

        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 0.0001 * 10 ** 18; // 0.0001 LINK

     }

     ///////////////////ERROR MESSAGE///////////////////////
     error NotAdmin();

     error NotSufficientEther(uint amountInputed, uint amountExpected);

     error NotWinner();

     error BalanceNotSufficient();


     //////////////////FUNCTIONS////////////////////////////

     function createSpin() external{

     }

     function spin() external{

     }

     function getRandomNumber() external{
        
     }

     function claimReward() external{

     }

     receive() external payable{}
}