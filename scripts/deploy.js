const hre = require("hardhat");

async function main() {
  let owner1 = "0x223f48C2536b78b96761a71f0534c1A5eFBaA9D0";
  let owner2 = "0x99EC6A3Df77BC8749Ee1FF915D4f4566A6241C15";
  let owner3 = "0x99EC6A3Df77BC8749Ee1FF915D4f4566A6241C15";
  let owner4 = "0x99EC6A3Df77BC8749Ee1FF915D4f4566A6241C15";

  const SherlockCoin = await hre.ethers.getContractFactory("SherlockCoin");
  const SherlockCoinObj = await SherlockCoin.deploy(owner1, owner2, owner3);
  await SherlockCoinObj.deployed();
  console.log("SherlockCoin (erc20) deployed to:", SherlockCoinObj.address);

  const PriceFeed = await hre.ethers.getContractFactory("PriceFeed");
  const PriceFeedObj = await PriceFeed.deploy(); //Send the address of the SherlockCoin Contract
  await PriceFeedObj.deployed();
  console.log("PriceFeed Module deployed to:", PriceFeedObj.address);

  const ICOcontract = await hre.ethers.getContractFactory("ICOcontract");
  const ICOcontractObj = await ICOcontract.deploy(
    SherlockCoinObj.address,
    PriceFeedObj.address
  ); //Send the address of the SherlockCoin Contract
  await ICOcontractObj.deployed();
  console.log("ICOcontract Module deployed to:", ICOcontractObj.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
