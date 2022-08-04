// importamos las funcionalidades de Hardhat
const hre = require("hardhat");

async function main() {
	const Lottery = await hre.ethers.getContractFactory("Lottery"); // creamos un factory para deployar el contrato
	const lotery = await Lottery.deploy(); // deployamos el contrato.
	await lotery.deployed(); // esperamos a que la operacion se ejecute en la blockchain

	console.log("Contrato deployado en la address: ", lotery.address);
}

// Llamada a main para ejecutar la funcion.
main().catch((error) => {
	console.error(error);
	process.exitCode = 1;
});
