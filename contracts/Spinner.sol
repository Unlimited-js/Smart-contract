// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./IERC20.sol";

contract Spinner {

    ////////////////////STATE VARIABLES///////////////////
    address admin;
    address immutable tokenAddress;
    uint256 randomResult;
    uint8 currentHighestNumber;
    address winnerAddress;
    uint8 public SPINID;
    uint8 public prevSpin;

    struct Spin {
        uint24 spinId;
        address[] players;
        uint8 prize;
        uint8 EntryPrice;
        address winner;
        uint8 randomNumber;
        bool finished;
        uint deadline;
        mapping(address => uint8) numTracker;
    }

    mapping(uint8 => Spin) spinners;
    mapping(uint256 => uint256) playersCount;


    ////////////////////CONSTRUCTOR/////////////////////
    constructor(address _tokenAddress) {
        admin = msg.sender;
        tokenAddress = _tokenAddress;    
    }

    ///////////////////ERROR MESSAGE///////////////////////
    error NotAdmin();
    error NotSufficientEther(uint256 amountInputed, uint256 amountExpected);
    error NotWinner();
    error BalanceNotSufficient();

    //////////////////FUNCTIONS////////////////////////////

    modifier timeElapsed(uint8 _spinID){
        Spin storage SD = spinners[_spinID];
        require(SD.deadline > block.timestamp, "Time has elapsed");
        _;
    }

    function createSpin(uint8 _entryPrice, uint24 _deadline) external {
        if (msg.sender != admin) {
            revert NotAdmin();
        }
        require(
            _entryPrice > 0,
            "entry price should be greater than 0"
        );

       prevSpin = SPINID;
       Spin storage SP = spinners[SPINID];
       SP.EntryPrice = _entryPrice;
       SP.deadline = _deadline + block.timestamp;
       SP.spinId = SPINID;

       SPINID++;
    }

    function spin(uint8 _spinID) external payable  returns(uint256) {
        Spin storage SD = spinners[_spinID];
        require(msg.value >= SD.EntryPrice, "insufficient balance");

        if(block.timestamp > SD.deadline){

        }

        uint256 randNumber = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % 20;

        SD.players.push(msg.sender);
        SD.numTracker[msg.sender] = uint8(randNumber);


        if (randNumber >= currentHighestNumber) {
            winnerAddress = msg.sender;
            currentHighestNumber = uint8(randNumber);
        }

        return randNumber;
    }

    function claimReward( uint8 _spinID) external timeElapsed(_spinID){
        Spin storage SD = spinners[_spinID];
        require(msg.sender == winnerAddress, "you are not the winner");
        IERC20(tokenAddress).transfer(msg.sender, 10);
        SD.finished = true;
        
    }

    function checkmyNum(uint8 _spinID) public view returns(uint8){
        Spin storage SD = spinners[_spinID];
        return SD.numTracker[msg.sender];
    }

    function timeleft(uint8 _spinID) public view returns(uint){
        Spin storage SD = spinners[_spinID];
        uint24 remainingTime = uint24(SD.deadline - block.timestamp);
        return remainingTime;
    }

    receive() external payable {}
}