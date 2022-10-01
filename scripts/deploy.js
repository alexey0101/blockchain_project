const hre = require("hardhat");


async function main() {
	
	const initialSupply = ethers.utils.parseEther('10000.0');
	const [deployer] = await ethers.getSigners();
	console.log(`Address deploying the contract --> ${deployer.address}`);

	const tokenFactory = await ethers.getContractFactory("SampleERC20");
	const contract = await tokenFactory.deploy(initialSupply);
	await contract.deployed();
	
	console.log(`Token Contract address --> ${contract.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
