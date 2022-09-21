import { HardhatUserConfig } from "hardhat/config";
import "dotenv/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-etherscan";

// Template
const { ROPSTEN_RPC, PRIVATE_KEY, ETHERSCAN_API, RINKEBY_RPC , POLYGON_RPC, MUMBAI_RPC} = process.env;

const config: HardhatUserConfig = {
  networks: {
    ropsten: {
      url: ROPSTEN_RPC,
      accounts: [PRIVATE_KEY as string],
    },
    rinkeby: {
      url: RINKEBY_RPC,
      accounts: [PRIVATE_KEY as string],
    },
    polygon: {
      url: POLYGON_RPC,
      accounts: [PRIVATE_KEY as string],
    },
    mumbai: {
      url: MUMBAI_RPC,
      accounts: [PRIVATE_KEY as string],
    }
  },
  etherscan: {
    apiKey: ETHERSCAN_API,
  },
  solidity: {
    compilers: [
      {
        version: "0.8.15",
        settings: {
          optimizer: {
            enabled: true,
            runs: 200,
          },
        },
      },
    ],
  },
};

export default config;
