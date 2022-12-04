import { ethers } from "hardhat";


const betGameAddress="0x8D1558961a1c49D7C933c32d5EfCf9EFF5105A74"
const betTokenAddress="0x5AB4c09A339C9139B28D6bfE168e45682391F307"


const wait =async(time:number)=>{

  return new Promise(res =>setTimeout(()=>{}, time * 60 *1000))
}

export const startBet = async ()=>{
 const betContract = await ethers.getContractAt("BetGame", betGameAddress)
//  const randomNumber = await betContract.getRandomNumber()
//  console.log(" Random Number ++++++++++++++++++++++\n")
//  console.log(randomNumber)
//  console.log("Random Number ++++++++++++++++++++++\n")

//  console.log("++++++++++++ waitin for vrf number")
//  await wait(4)

    // @ts-ignore
// const tokenContract =   await ethers.getContractAt("ERC20Token", betTokenAddress)

//   const tx = await  tokenContract.transferFromContract(betGameAddress, "10000000000000000000")
//  const result =  await tx.wait()
//   console.log(result, "Token transferred to contract successfully\n")


  const currentTime = Date.now()
  const durationInHours =  2

const timeStarted =   Math.ceil((currentTime/1000000) - (durationInHours * 3600))


  // const setNumber = await betContract.setBetNumber()
  //  await  setNumber.wait()

    const start = await betContract.startBetRound(timeStarted, {
    gasLimit:"5000000"
  })
const startBet =  await start.wait()
  console.log(startBet, "Bet round started")      


}

// 0x51B757F621ea9C7d06A7705170E5E82B1ec161d9 faucet address
const tokenReceiver="0xC0c96bb9Faba64D794EF9790EB0904597E6C6F60"
export const sendToken = async ()=>{
       // @ts-ignore
   const tokenContract =   await ethers.getContractAt("ERC20Token", betTokenAddress)
   
     const tx = await  tokenContract.transferFromContract(tokenReceiver, "10000000000000000000000")
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