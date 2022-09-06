
const hre = require("hardhat");

async function main() {
  const Main =  await hre.ethers.getContractFactory("Main");
  const Token =  await hre.ethers.getContractFactory("Linked3");
  
  const token = await Token.deploy()
  await token.deployed()
  const main = await Main.deploy(token.address)
  await main.deployed()

  console.log("Deployed")
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
