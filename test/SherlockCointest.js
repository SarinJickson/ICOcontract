const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SherlockCoin", function () {
  let SherlockCoin;
  let owner1;
  let owner2;
  let owner3;
  let owner4;
  let owner5;

  //contract deployment
  before(async () => {
    [owner1, owner2, owner3, owner4, owner5] = await ethers.getSigners();

    SherlockCoin = await ethers.getContractFactory("SherlockCoin");
    contract = await SherlockCoin.deploy(
      owner1.address,
      owner2.address,
      owner3.address
    );
  });
  describe("mint", async () => {
    it("minting tokens for users", async () => {
      await contract.deployed();
      const mint = await contract.connect(owner4).mint(owner4.address, 1000);
      await mint.wait();
      const response = await contract.totalSupply();

      expect(Number(response)).to.equal(Number(301000));
    });
  });
});
