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
   const spinner = await Spinner.deploy(gtoken.address);
 
   await spinner.deployed();
 
   console.log("Spin game contract is deployed to:", spinner.address);
   
   //Bet game token contract is deployed to: 0xf30D5e453895Ca4181A21246445FCc8dF1B48426
   //Betgame contract is deployed to: 0xf49Ac7fE4B33eAf5Cd7f6Eb1b97427626fbe673A
   //Spin game contract is deployed to: 0x51425b6b3A7617C2f2FCC245Ef8276b55Dc9698D
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
