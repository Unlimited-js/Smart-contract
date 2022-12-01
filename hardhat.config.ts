import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require("dotenv").config();


const config: HardhatUserConfig = {
  solidity: {
    compilers: [
      {
        version: "0.8.4"
      },
      {
        version: "0.8.13"
      }
    ]
  },
  networks: {
    mumbai: {
      url: process.env.MUMBAI,
      // @ts-ignore
      accounts: [process.env.PRIVATE_KEY_1]
    }
  },
  etherscan: {
    apiKey: process.env.API_TOKEN
  }
};

export default config;