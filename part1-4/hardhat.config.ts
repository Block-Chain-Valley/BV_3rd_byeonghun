import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const ALCHEMY_API_KEY = process.env.ALCHEMY_API_KEY;
const GOERLI_PRIVATE_KEY = process.env.GOERLI_PRIVATE_KEY;
const BAOBAB_PRIVATE_KEY = process.env.BAOBAB_PRIVATE_KEY;

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  networks: {
    baobab:{
      url: 'https://api.baobab.klaytn.net:8651',
      accounts: [BAOBAB_PRIVATE_KEY],
    },
    goerli:{
      url: `https://eth-goerli.g.alchemy.com/v2/${ALCHEMY_API_KEY}`,
      accounts: [GOERLI_PRIVATE_KEY],
    },
  }
};
export default config;
