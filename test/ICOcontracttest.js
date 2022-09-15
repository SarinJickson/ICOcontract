const { expect } = require("chai");
const { ethers } = require("hardhat");
const {
  TASK_COMPILE_SOLIDITY_LOG_NOTHING_TO_COMPILE,
} = require("hardhat/builtin-tasks/task-names");
const { assertHardhatInvariant } = require("hardhat/internal/core/errors");
const { boolean } = require("hardhat/internal/core/params/argumentTypes");

describe("ICOcontract", function () {
  let ICOcontract;
  let SherlockCoin;
  let PriceFeed;
  let owner1;
  let owner2;
  let owner3;
  let owner4;
  let owner5;

  //contract deployment
  before(async () => {
    [owner1, owner2, owner3, owner4, owner5] = await ethers.getSigners();

    SherlockCoin = await ethers.getContractFactory("SherlockCoin");
    SherlockCoinContract = await SherlockCoin.deploy(
      owner4.address,
      owner2.address,
      owner3.address
    );
    PriceFeed = await ethers.getContractFactory("PriceFeed");
    PriceFeedContract = await PriceFeed.deploy();

    ICOcontract = await ethers.getContractFactory("ICOcontract");
    contract = await ICOcontract.deploy(
      SherlockCoinContract.address,
      PriceFeedContract.address
    );
  });

  describe("toggle", async () => {
    it("toggle function", async () => {
      await contract.deployed();
      const toggle = await contract.connect(owner1).toggle();
      await toggle.wait();
      expect(await contract.Sale()).to.be.equal(true);
    });
  });

  describe("buy", async () => {
    it("user buy a token", async () => {
      const beforeBuy = await contract
        .connect(owner5)
        .balanceof(owner5.address);
      const priceusd = await PriceFeedContract.connect(owner1).setTokenPrice(
        10000000
      );
      await priceusd.wait();
      const decimal = await PriceFeedContract.connect(owner1).setDecimals(6);
      await decimal.wait();
      const buy = await contract
        .connect(owner5)
        .buy({ value: "1000000000000000000" });
      await buy.wait();
      const afterBuy = await contract.connect(owner5).balanceof(owner5.address);
      const expectation = await (afterBuy - beforeBuy);
      expect(expectation).to.equal(10);
    });
  });

  describe("withdraw", async () => {
    it("withdraw money admin", async () => {
      // const beforebalanceofContract = await contract
      //   .connect(owner1)
      //   .address(this).balance;

      const StartingDeployerBalance = Number(
        await SherlockCoinContract.balanceOf(owner1.address)
      );

      const withdraw = await contract.connect(owner1).withdraw();
      await withdraw.wait();
      const transactionResponse = Number(await contract.getBalance());

      const EndingDeployerBalance = Number(
        await SherlockCoinContract.balanceOf(owner1.address)
      );
      expect(EndingDeployerBalance).to.equal(
        StartingDeployerBalance + transactionResponse
      );
    });
  });
});
