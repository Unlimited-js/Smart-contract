import { ethers } from "hardhat";

const spinnerAddress="0x83164EaA55e083AA8fEEF58C3Cd03a051BeF2e2e"


export const createSpin = async ()=>{
 const spinnerContract = await ethers.getContractAt("Spinner", spinnerAddress) 

  const currentTime = Date.now()
  const durationInHours =  2
const timeStarted = Math.ceil((currentTime/1000000) + (durationInHours * 3600))
const timeToClaim = Math.ceil((currentTime/1000000) + ((durationInHours + 1 )* 3600))
console.log(timeStarted, "Time started","\n", timeToClaim)
 

  //  function createSpin(uint8 _entryPrice, uint24 _deadline, uint8 rewardPrice, uint _claimdeadline) external {

     const price = await ethers.utils.parseEther("1");
     const rewardPrice = await ethers.utils.parseEther("3");
  const start = await spinnerContract.createSpin("1",timeStarted, "3",timeToClaim  )
  const startResult = await  start.wait()
  console.log(startResult, "Spinner Opened")      

}


async function main(){
    await createSpin()
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });
  



