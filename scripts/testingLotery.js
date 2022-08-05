const hre = require("hardhat");
const contractJson = require("../artifacts/contracts/Lottery.sol/Lottery.json");

async function getBalances(provider, addressArray) {
	for (const address of addressArray) {
		const bigIntbalance = await provider.getBalance(address);
		console.log(`Balance de ${address}: `, hre.ethers.utils.formatEther(bigIntbalance), " ETH");
	}
}

async function main() {
	const contractAddress = "0x26F334590416458B51Cb761C781AB1b7E1F8024F";
	const contractAbi = contractJson.abi;
	// Obtenemos unas cuentas para testear el contrato
	//const [player1, player2, player3] = await hre.ethers.getSigners();
	const provider = new hre.ethers.providers.AlchemyProvider("rinkeby");
	//const signer = new hre.ethers.Wallet(process.env.PRIVATE_KEY, provider);
	const player1 = new hre.ethers.Wallet(process.env.PRIVATE_KEY, provider);
	const player2 = new hre.ethers.Wallet(process.env.PRIVATE_KEY1, provider);
	//const player3 = new hre.ethers.Wallet(process.env.PRIVATE_KEY2, provider);

	const addresses = [player1.address, player2.address];
	const signers = [player1, player2];

	console.log("Balances de las wallets:");
	await getBalances(provider, addresses);
	//console.log("Owner:", await getBalance(provider, addresses), " ETH");

	const Lotery = new hre.ethers.Contract(contractAddress, contractAbi, player1);
	console.log("Balance del contrato: ", hre.ethers.utils.formatEther(await Lotery.getBalance()), " ETH");

	console.log("\nUniendose al sorteo...");
	for (const signer of signers) {
		//console.log("is signer:", hre.ethers.Signer.isSigner(signer));
		await Lotery.connect(signer).enter({ value: hre.ethers.utils.parseEther("0.011") });
	}
	console.log("Balance del contrato despues de la compra: ", hre.ethers.utils.formatEther(await Lotery.getBalance()), " ETH");
	/*	
     console.log("\nRealizando Rifa...");
	await Lotery.connect(player1).getRandomNumber();
	console.log("\n Obteniendo al ganador...");
	await Lotery.connect(player1).pickWinner(); // funcion que solo puede ser llamda por el owner.
*/
}

main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
