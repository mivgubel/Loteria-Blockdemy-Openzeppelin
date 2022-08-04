require("@nomicfoundation/hardhat-toolbox");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
	solidity: "0.8.9",
	networks: {
		rinkeby: {
			url: process.env.URL_RINKEBY_APIKEY,
			accounts: [process.env.PRIVATE_KEY],
		},
	},
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY
  }
};
