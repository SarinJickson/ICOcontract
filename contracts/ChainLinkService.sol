// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "contracts/PriceFeed.sol";

contract ChainlinkService {
    ///@dev provides the latest price of the token
    ///@param aggregator_Address, address of the price feed chainlink contract
    function getLatestPrice(address aggregator_Address)
        public
        view
        returns (uint256)
    {
        (, int256 price, , , ) = AggregatorV3Interface(aggregator_Address)
            .latestRoundData();
        return (uint256(price));
    }

    function getDecimals(address aggregator_Address)
        public
        view
        returns (uint256)
    {
        return (AggregatorV3Interface(aggregator_Address).decimals());
    }
}
