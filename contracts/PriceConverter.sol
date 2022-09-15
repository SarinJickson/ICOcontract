// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getPrice() public view returns (uint256) {
        //the function that we take the price in terms of USD
        //ABI
        //Adress
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        (, int256 price, , , ) = priceFeed.latestRoundData();

        return uint256(price * 1e18);
    }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        //this is the function that takes the ethAmount and returns the amount in terms of USD
        uint ethPrice = getPrice();
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }

    function getVersion() public view returns (uint256) {
        // an AggregatorV3Interface variable called priceFeed
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        );
        return priceFeed.version();
    }
}
