import { ethers } from "hardhat";

async function main() {
  const tokenAddress="0x5AB4c09A339C9139B28D6bfE168e45682391F307"
  ////////DEPLOYING THE TOKEN CONTRACT
  // const GameToken = await ethers.getContractFactory("ERC20Token");
  // const gtoken = await GameToken.deploy();

  // await gtoken.deployed();

  // console.log("Bet game token contract is deployed to:", gtoken.address);
  // const gTokenAddress= "0x5AB4c09A339C9139B28D6bfE168e45682391F307"
  // const gTokenAddress=gtoken.address


  //  ////////DEPLOYING THE  GAME CONTRACT
   const price = await ethers.utils.parseEther("5");

   const Betgame = await ethers.getContractFactory("BetGame");
   const betgame = await Betgame.deploy(tokenAddress, price);
 
   await betgame.deployed();
 
   console.log("Betgame contract is deployed to:", betgame.address);


   ////////////////DEPLOYING THE SPIN CONTRACT////////////////

   const Spinner = await ethers.getContractFactory("Spinner");
   const spinner = await Spinner.deploy(tokenAddress);
 
   await spinner.deployed();
 
   console.log("Spin game contract is deployed to:", spinner.address);
 


  
   ////////DEPLOYING THE  FAUCET CONTRACT  
  //  const Faucet = await ethers.getContractFactory("Faucet");
  //  const faucet = await Faucet.deploy("0x5AB4c09A339C9139B28D6bfE168e45682391F307");
 
  //  await faucet.deployed();
 
  //  console.log("Faucet contract is deployed to:", faucet.address);



}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
