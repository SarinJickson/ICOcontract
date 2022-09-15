//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface PriceFeedInterface {
    function getLatestPrice(address aggregator_Address) external;

    function getDecimals(address aggregator_Address) external;
}
