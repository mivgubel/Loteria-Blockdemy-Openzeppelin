const { ethers } = require("ethers");
const { DefenderRelaySigner, DefenderRelayProvider } = require('defender-relay-client/lib/ethers');

const ABI = ["function getRandomNumber() public"];
const ADDRESS = "0xEB0032C90E550Fb160f5334F15CE21173A8c14E0";

async function main(signer) {
  
  const lottery = new ethers.Contract(ADDRESS, ABI, signer);
  const tx = await lottery.getRandomNumber();
  
}

exports.handler = async function(params) {
  
  const provider = new DefenderRelayProvider(params);
  const signer = new DefenderRelaySigner(params, provider, {speed: "fast"});
  
  await main(signer);
  
}