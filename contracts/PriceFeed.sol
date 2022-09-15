// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

//import "../interfaces/IModusRegistry.sol";
//import "../utils/Utility.sol";

contract PriceFeed {
    int256 public Price;
    uint8 decimal;

    function setTokenPrice(int256 price) public {
        Price = price;
    }

    function setDecimals(uint8 _decimal) public {
        decimal = _decimal;
    }

    function latestRoundData()
        external
        view
        returns (
            uint80,
            int256,
            uint256,
            uint256,
            uint80
        )
    {
        return (uint80(0), Price, uint256(0), uint256(0), uint80(0));
    }

    /**
     * @notice represents the number of decimals the aggregator responses represent.
     */
    function decimals()
        external
        view
        returns (
            // override
            uint8
        )
    {
        return decimal;
    }
}
