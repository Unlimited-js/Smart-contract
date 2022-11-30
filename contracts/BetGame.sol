// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "./IERC20.sol";
import "./ERC20Burnable.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
//import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/extensions/ERC20Burnable.sol";

import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract BetGame is VRFConsumerBase{
    /////////////////////EVENTS//////////////////////////
    event PayFee(address indexed player, uint256 indexed amount);
    event ClaimPrice(address indexed winner, uint256 indexed amountGotten);
    event Withdraw(address indexed receiver, uint256 indexed amount);
    event TimeStarted(uint256 time);

     address public admin; //bet admin

     address immutable tokenAddress; //bet token address

     address[] participants; //array of bet players

     uint256 public betPrice;//amount to pay to participate in the bet game
     
     uint256 public deadline; //bet deadline

     uint256 request;
     
     address[] betWinners; //array of bet game winners
     
     uint256 public betNumber;  // set bet number

     bytes32 internal keyHash;

     uint256 internal fee;
    
     uint256 randomResult;

     uint256 totalDeposit;

     uint8 TotalClaim;

     uint8 public totalWinners;
    
     bool betStarted;
     
     bool betEnded;

     bool response;

    
     enum LotteryStatus{
        Start,
        End
     }
    
     mapping(address => bool) played; //to keep if user has played before
     mapping(address => bool) claimed;
     mapping (address => bool) public Winners;

    
     constructor( address _tokenAddress, uint256 _price) VRFConsumerBase(
            0x8C7382F9D8f56b33781fE506E897a4F1e2d17255, // VRF Coordinator
            0x326C977E6efc84E512bB9C30f76E30c160eD06FB  // LINK Token 
          ) 
    {
        admin = msg.sender;
        tokenAddress = _tokenAddress;
        betPrice = _price * 1e16;

        keyHash = 0x6e75b569a01ef56d18cab6a8e71e6600d6ce853834d4a5748b720d06f878b3a4;
        fee = 0.0001 * 10 ** 18; // 0.0001 LINK

     }


     /////////////ERROR MESSAGE////////////
     error NotAdmin();

     error NotSufficientEther(uint amountInputed, uint amountExpected);

     error TimeElapsed();

     error NotWinner();

     error BetInProgress();

     error BetNotStarted();

     error BalanceNotSufficient();

    
    /** 
     * @dev  here is the function to requests randomness using chainlink VRF
     * The contract should be funded with enough Link for the function to run successfully
     */
    function getRandomNumber() public returns (bytes32 requestId) {
        if(msg.sender != admin){
            revert NotAdmin();
        }

        require(LINK.balanceOf(address(this)) > fee, "Not enough LINK - fill contract with faucet");
        return requestRandomness(keyHash, fee);
    }

     /// @dev function to buy token to participate in the bet game
     function buyToken() external payable{
        require(IERC20(tokenAddress).balanceOf(address(this)) > 0, "No more Token to Disburse, Try another time");
        
        if(block.timestamp > deadline){
            revert TimeElapsed();
        }
        
        if(msg.value < betPrice){
            revert NotSufficientEther({
                amountInputed: msg.value,
                amountExpected: betPrice
            });
        }
        participants.push(msg.sender); //push participant into an array of participants
        IERC20(tokenAddress).transfer(msg.sender, 10*1e18); //mint token to user

        totalDeposit += msg.value;

        emit PayFee(msg.sender, msg.value);
     }

   /// @dev function for the admin to start bet game
   /// @param _deadline is the duration for which the game exist 
     function startBetRound(uint256 _deadline) public {
        require(randomResult != 0, "Random number still fetching from chainlink");
        require(IERC20(tokenAddress).balanceOf(address(this)) > 0, "Contract not funded");
        if( betStarted == true ){
            revert BetInProgress();
        }
        if(msg.sender != admin){
            revert NotAdmin();
        }

        deadline = block.timestamp + _deadline; //indicate in days

        //Admin to set the bet deadline
        require(block.timestamp < deadline, "bet time should be in the future");
        betStarted = true;
        emit TimeStarted(block.timestamp);
     }

     /// @dev function to set the bet number calls the getRandomNumber function
     function setBetNumber() public {
        require(randomResult != 0, "Random number still fetching from chainlink");
        if(msg.sender != admin){
            revert NotAdmin();
        }
        if( betStarted == true ){
            revert BetInProgress();
        }

        // transform the 0xd9145CCE52D386f254917e481eB44e9943F39138result to a number between 1 and 50 inclusively
        betNumber = (randomResult % 50) + 1;     
     }
     
     /** @dev function for players to play bet which requires the player approving the contract to spend 
      * his token to player the bet game, then the token gets burnt
      * returns the address of the winner*/ 
     /// @param num: players are required to input a number to bet
     function play(uint256 num) external returns(address winner){
        require(betStarted == true, "Bet hasn't began"); 

        if(block.timestamp > deadline){
            revert TimeElapsed();
        }

        require(played[msg.sender] != true, "Already played"); 
        if(IERC20(tokenAddress).balanceOf(msg.sender) < 10*1e18){
            revert BalanceNotSufficient();
        }
       

       if(num == betNumber){
         betWinners.push(msg.sender);
         Winners[msg.sender] = true;
         totalWinners += 1;
         ERC20Burnable(tokenAddress).burnFrom(msg.sender, 10*1e18);
         return msg.sender;
       }

       played[msg.sender] = true;
       ERC20Burnable(tokenAddress).burnFrom(msg.sender, 10*1e18);
        
     }
    
    /// @dev function to see the time left to play the bet game
     function seeTimeLeft() public view returns(uint256){
         if(deadline == 0){
             return 0;
         }else{
             return deadline - block.timestamp; 
         }
        
     }

    /// @dev function to calculate percentage for both the winner and the owner of the game
    function calcProfit() private view returns(uint percentage){
       uint256 winnersReward = (totalDeposit * 80) /100;
        percentage = winnersReward / betWinners.length;
    }

    /// @dev function for winner to claim their price
    function claimPrize() external payable {
        require(claimed[msg.sender]== false, "already claimed");
        require(block.timestamp > deadline, "still in progress");

        if(Winners[msg.sender] == true){     
            uint amountTowithdraw = calcProfit();
            payable(msg.sender).transfer(amountTowithdraw);
        }else{
            revert NotWinner();
        }
        claimed[msg.sender]= true;

        TotalClaim++;

     }

      function viewWinner() public view returns(address[] memory ) {
  
        if(block.timestamp > deadline){
            return betWinners;
        }

    }

    function showLuckyNumber() public view returns(uint256){

        if(block.timestamp > deadline){
            return betNumber;
        }else{
            return 0;
        }
  
     }

    function withdrawProfit(address to) public {
        require(block.timestamp > deadline, "lottery not ended");
        if(msg.sender != admin){
            revert NotAdmin();
        }
 
        if(TotalClaim == betWinners.length){
            payable(to).transfer(address(this).balance);
        }else{
            uint amount = (totalDeposit * 20) /100;
            payable(to).transfer(amount);
        }

     }

    function getContractBal() public view returns(uint256){
        return address(this).balance;
     }

    function getTokenBal() public view returns(uint256){
        return IERC20(tokenAddress).balanceOf(address(this));
    }

    function getParticipants() public view returns(uint256){
        return participants.length;
     }

    function withdrawLockFunds(address to) public {
        if(msg.sender != admin){
            revert NotAdmin();
        }
        require(block.timestamp > deadline + 5 days, "Still in withdrawal period");
        payable(to).transfer(address(this).balance);
    }

    function withdrawTokenBalance(address to) public{
        if(msg.sender != admin){
            revert NotAdmin();
        }
        require(block.timestamp > deadline, "Lottery is still on" );
         IERC20(tokenAddress).transfer(to, address(this).balance); 
    }

     /**
     * Callback function used by VRF Coordinator
     */
    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        randomResult = randomness;
    }

     receive() external payable{}

    
    
}