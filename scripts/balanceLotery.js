const hre = require("hardhat");
const contractJson = require("../artifacts/contracts/Lottery.sol/Lottery.json");

async function getBalances(provider, addressArray) {
	for (const address of addressArray) {
		const bigIntbalance = await provider.getBalance(address);
		console.log(`Balance de ${address}: `, hre.ethers.utils.formatEther(bigIntbalance), " ETH");
	}
}

async function main() {
	const contractAddress = "0xEB0032C90E550Fb160f5334F15CE21173A8c14E0";
	const contractAbi = contractJson.abi;
	// Obtenemos unas cuentas para testear el contrato
	const provider = new hre.ethers.providers.AlchemyProvider("rinkeby");
	const player1 = new hre.ethers.Wallet(process.env.PRIVATE_KEY, provider);
	const player2 = new hre.ethers.Wallet(process.env.PRIVATE_KEY1, provider);

	const addresses = [player1.address, player2.address];
	const signers = [player1, player2];

	console.log("Balances Actualmente:");
	await getBalances(provider, addresses);
	const Lotery = new hre.ethers.Contract(contractAddress, contractAbi, player1);
	console.log("Balance del contrato: ", hre.ethers.utils.formatEther(await Lotery.getBalance()), " ETH");
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
