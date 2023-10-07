/** @type import('hardhat/config').HardhatUserConfig */
require("@nomiclabs/hardhat-waffle")

const ALCHEMY_API_KEY = "cATlseqDWFMBe4ZTNegPSTGS7vneR2S8";
const ROPSTEN_PRIVATE_KEY = "25c6d865a4c9a8c6fee8954417d0ede9b0dfa8568b3d9dcfb1f53a835081e65a";

module.exports = {
  solidity: "0.8.19",
  networks:{
    goerli:{
      url: `https://eth-ropsten.alchemyapi.io/v2/${ALCHEMY_API_KEY}`,
      accounts: [`0x${ROPSTEN_PRIVATE_KEY}`],
    }
  }
};
