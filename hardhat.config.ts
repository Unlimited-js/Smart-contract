import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

require("dotenv").config();

const PRIVATE_KEY_1 = "41ad816e06a2a284c03a7c9c43e34ab4cb6a76dfc81a56aa43ad97de175115c2";


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
      //url: process.env.MUMBAI,
      url: "https://polygon-mumbai.g.alchemy.com/v2/7U29KpDk-lyM_Ka_BylhTELu3XcsR9RJ",
      // @ts-ignore
      //accounts: [process.env.PRIVATE_KEY_1]
      accounts: [PRIVATE_KEY_1]
    }
  },
  etherscan: {
    //apiKey: process.env.API_TOKEN
    apiKey: "WPSFJ5S9EVIJUYSSVW1G14AJQ578YJ3MCP"
  }
};

export default config;