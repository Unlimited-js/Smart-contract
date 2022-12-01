import { ethers } from "hardhat";

async function main() {
  
  ////////DEPLOYING THE TOKEN CONTRACT
  const GameToken = await ethers.getContractFactory("ERC20Token");
  const gtoken = await GameToken.deploy();

  await gtoken.deployed();

  console.log("Bet game token contract is deployed to:", gtoken.address);


   ////////DEPLOYING THE  GAME CONTRACT
   const price = await ethers.utils.parseEther("5");

   const Betgame = await ethers.getContractFactory("BetGame");
   const betgame = await Betgame.deploy(gtoken.address, price);
 
   await betgame.deployed();
 
   console.log("Betgame contract is deployed to:", betgame.address);
   

   ////////////////DEPLOYING THE SPIN CONTRACT////////////////

   const Spinner = await ethers.getContractFactory("Spinner");
   const spinner = await Spinner.deploy();
 
   await spinner.deployed();
 
   console.log("Spin game contract is deployed to:", spinner.address);
 

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
