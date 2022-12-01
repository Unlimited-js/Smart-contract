// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./IERC20.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract Spinner {
    using Counters for Counters.Counter;
    using SafeMath for uint256;
    uint8 public SPINID;
    uint8 prevSpinId;

    Counters.Counter private spinId;

    ////////////////////STATE VARIABLES///////////////////
    address admin;
    address immutable tokenAddress;
    uint256 randomResult;
    uint8 currentHighestNumber;
    address winnerAddress;

    struct Spin {
        uint24 spinId;
        address[] players;
        uint8 prize;
        uint8 EntryPrice;
        address winner;
        uint8 randomNumber;
        // bool claimed;
        bool finished;
        uint deadline;
        mapping(address => uint8) numTracker;
    }

    mapping(address => mapping(uint8 => Spin)) spinners;
    mapping(uint256 => uint256) playersCount;
    mapping(uint8 => bool) spincreated;

    ////////////////////EVENTS////////////////
    event Randomness(bytes32, uint256);
    event Winner(bytes32, uint256, address);
    event SpinCreated(
        uint256 ID,
        uint8 Entryprice,
        uint256 prize,
        uint24 deadline
    );

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


    modifier timeElapsed(address adminaddr, uint8 _spinID){
        Spin storage SD = spinners[adminaddr][_spinID];
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

        require(spincreated[prevSpinId] == false, "spin still on");
  
       Spin storage SP = spinners[msg.sender][SPINID];
       SP.EntryPrice = _entryPrice;
       SP.deadline = _deadline + block.timestamp;
       SP.spinId = SPINID;

       prevSpinId = SPINID;

       spincreated[SPINID] = true;

       SPINID++;

        //emit SpinCreated(sp.spinId, sp.EntryPrice, sp.prize, sp.deadline);
    }

    function spin(address adminaddr, uint8 _spinID) external payable  returns(uint256) {
        Spin storage SD = spinners[adminaddr][_spinID];
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

    function claimReward(address adminaddr, uint8 _spinID) external timeElapsed(adminaddr, _spinID){
        Spin storage SD = spinners[adminaddr][_spinID];
        require(msg.sender == winnerAddress, "you are not the winner");
        IERC20(tokenAddress).transfer(msg.sender, 10);
        SD.finished = true;
        spincreated[SPINID] = false;
    }


    function getSpinCount() public view returns (uint256) {
        return spinId.current();
    }

    function checkmyNum(address adminaddr, uint8 _spinID) public view returns(uint8){
        Spin storage SD = spinners[adminaddr][_spinID];
        return SD.numTracker[msg.sender];
    }

    function timeleft(address adminaddr, uint8 _spinID) public view returns(uint){
        Spin storage SD = spinners[adminaddr][_spinID];
        uint24 remainingTime = uint24(SD.deadline - block.timestamp);
        return remainingTime;
    }

    receive() external payable {}
}