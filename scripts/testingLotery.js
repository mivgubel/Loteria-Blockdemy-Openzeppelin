const hre = require("hardhat");
const abi = require("../artifacts/contracts/Lottery.sol/Lottery.json");

async function main() {
     // Obtenemos unas cuentas para testear el contrato
     const [owner, player1, player2, player3] = await hre.ethers.getSigners();
     const Lotery = await 
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
