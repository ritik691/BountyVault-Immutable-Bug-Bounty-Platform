const hre = require("hardhat");

async function main() {
  const BountyVault = await hre.ethers.getContractFactory("BountyVault");
  const bountyVault = await BountyVault.deploy();

  await bountyVault.deployed();
  console.log("BountyVault deployed to:", bountyVault.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
