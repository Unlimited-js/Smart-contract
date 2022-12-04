// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.4;

import "./IERC20.sol";
contract Spinner {

    ////////////////////STATE VARIABLES///////////////////
    address admin;
    address immutable tokenAddress;
    uint8 public SPINID = 1;
    uint8 public prevSpinId = 1;

    struct Spin {
        uint24 spinId;
        address[] players;
        uint64 prize;
        uint8 EntryPrice;
        address winner;
        uint8 currentHighestNumber;
        bool created;
        uint deadline;
        mapping(address => bool) spinned;
        bool prizeClaimed;
        uint claimDeadline;
        mapping(address => uint8) numTracker;
    }

    mapping(uint8 => Spin) spinners;
    mapping(uint8 => bool) rounds;


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
    error AlreadyClaimed();


   /////////////MODIFIER///////////////////////////////////
    modifier spinCreated(uint8 _spinID){
        Spin storage SD = spinners[_spinID];
        require(SD.created == true, "spin not avialable, contact admin");
        _;
    }


     //////////////////FUNCTIONS////////////////////////////
    function createSpin(uint8 _entryPrice, uint24 _deadline, uint8 rewardPrice, uint _claimdeadline) external {
        if (msg.sender != admin) {
            revert NotAdmin();
        }
        require(
            _entryPrice > 0,
            "entry price should be greater than 0"
        );

        uint64 roundReward = (rewardPrice * 1 ether) * prevSpinId;

        require(IERC20(tokenAddress).balanceOf(address(this)) > roundReward, "contract doesn't have enough fund");

        require(rounds[prevSpinId] == false, "spin on");

       prevSpinId = SPINID;
       Spin storage SP = spinners[SPINID];
       SP.EntryPrice = _entryPrice;
       SP.deadline = _deadline + block.timestamp;
       SP.spinId = SPINID;
       SP.created = true;
       SP.prize = roundReward;
       SP.claimDeadline = _claimdeadline + block.timestamp;

       rounds[prevSpinId] = true;

       SPINID++;
    }

    function spin(uint8 _spinID) external payable spinCreated(_spinID) returns(uint256) {
        Spin storage SD = spinners[_spinID];
        require(SD.deadline > block.timestamp, "Time has elapsed");
        require(msg.value >= SD.EntryPrice, "insufficient balance");
        require(SD.spinned[msg.sender] == false, "already spinned");

        uint256 randNumber = uint256(
            keccak256(
                abi.encodePacked(block.timestamp, block.difficulty, msg.sender)
            )
        ) % 20;

        SD.players.push(msg.sender);
        SD.numTracker[msg.sender] = uint8(randNumber);

        if (randNumber >= SD.currentHighestNumber) {
            SD.winner = msg.sender;
            SD.currentHighestNumber = uint8(randNumber);
        }

       SD.spinned[msg.sender]  = true;

        return randNumber;
    }

    function claimReward(uint8 _spinID) external spinCreated(_spinID){
        Spin storage SD = spinners[_spinID];
        uint amount = SD.prize;
        require(block.timestamp > SD.deadline, "spin still on");
        require(SD.claimDeadline > block.timestamp, "deadline for claim has passed");
        if(msg.sender != SD.winner){
            revert NotWinner();
        }
        if(SD.prizeClaimed == true){
            revert AlreadyClaimed();
        }
        
        SD.prizeClaimed = true;
        IERC20(tokenAddress).transfer(msg.sender, amount);

          
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

    function closeRound(uint8 _spinID) public spinCreated(_spinID) returns(string memory){
        Spin storage SD = spinners[_spinID];
        require(block.timestamp > SD.deadline, "spin still on");
        if (msg.sender != admin) {
            revert NotAdmin();
        }

        if(SD.prizeClaimed == true){
            rounds[prevSpinId] = false; 
            return "round closed1";
        }else if(block.timestamp > SD.claimDeadline) {
            rounds[prevSpinId] = false; 
            return "round closed2";
        } else{
            return "claim deadline is yet to elapsed";
        }
    
    }

    function playersCount(uint8 _spinID) public view spinCreated(_spinID) returns(uint256){
        Spin storage SD = spinners[_spinID];
        return SD.players.length;
    }

    function spinWinner(uint8 _spinID) public view spinCreated(_spinID) returns(address){
        Spin storage SD = spinners[_spinID];
        return SD.winner;
    }

    function currentRound() public view returns(uint8){
        return prevSpinId;
    }

    function winningNumber(uint8 _spinID) public view spinCreated(_spinID) returns(uint8) {
        Spin storage SD = spinners[_spinID];
        return SD.currentHighestNumber;
    }

    receive() external payable {}
}