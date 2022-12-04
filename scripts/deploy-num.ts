


import { ethers } from "hardhat";

async function main() {
  
  ////////DEPLOYING THE TOKEN CONTRACT
  const GameToken = await ethers.getContractFactory("Sample");
  const gtoken = await GameToken.deploy();

  await gtoken.deployed();

  console.log("Sample contract is deployed to:", gtoken.address);


 

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
