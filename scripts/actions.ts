import { ethers } from "hardhat";


const betGameAddress="0x57ad7b16f84356ee566b0cf3d43d7072b5de0e05"
const betTokenAddress="0x5AB4c09A339C9139B28D6bfE168e45682391F307"


export const startBet = async ()=>{
 const betContract = await ethers.getContractAt("BetGame", betGameAddress)
    // @ts-ignore
// const tokenContract =   await ethers.getContractAt("ERC20Token", betTokenAddress)

//   const tx = await  tokenContract.transferFromContract(betGameAddress, "10000000000000000000")
//  const result =  await tx.wait()
//   console.log(result, "Token transferred to contract successfully\n")

  const currentTime = Date.parse(Date())
  const durationInHours =  2
const timeStarted = (currentTime/1000) + (durationInHours * 3600)
  // const start = await betContract.startBetRound(timeStarted, {
  //   gasLimit:"50000"
  // })
  const start = await betContract.setBetNumber()
  const startResult = await  start.wait()
  console.log(startResult, "Bet round started")      


}


const tokenReceiver="0x1049dCFe27985721Fb103d22076266377381eC7D"
export const sendToken = async ()=>{
       // @ts-ignore
   const tokenContract =   await ethers.getContractAt("ERC20Token", betTokenAddress)
   
     const tx = await  tokenContract.transferFromContract(tokenReceiver, "10000000000000000000")
    const result =  await tx.wait()
     console.log(result, "Token transferred to successfully\n")
     
   
   
   }




const createWallet = ()=>{
    let wallets= []

    for (let index = 0; index < 5; index++) {
        const wallet = ethers.Wallet.createRandom()
wallets.push({
    address:wallet.address,
    mnemonic:wallet.mnemonic.phrase,
    privateKey:wallet.privateKey
})
       
        
    }

    return wallets
}

export const playBet = async ()=>{

    const betContract = await ethers.getContractAt("BetGame", betGameAddress)
       // @ts-ignore
   const tokenContract =   await ethers.getContractAt("ERC20Token", betTokenAddress)
   
     const tx = await  tokenContract.transferFromContract(betGameAddress, "10000000000000000000")
    const result =  await tx.wait()
     console.log(result, "Token transferred to contract successfully\n")
   
     const start = await betContract.startBetRound("1669840077")
     const startResult =await  start.wait()
     console.log(startResult, "Bet round started")
           
   
   
   }