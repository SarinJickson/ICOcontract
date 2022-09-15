// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "contracts/SherlockCoin.sol";
//import "contracts/PriceConverter.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "./ChainLinkService.sol";
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "contracts/PriceFeed.sol";

//import "./PriceFeedInterface.sol";

contract ICOcontract is Ownable {
    SherlockCoin public token;
    //importing the PriceConverter library
    //using PriceConverter for uint256;

    // How many token units a buyer gets per Eth
    uint256 public rate;

    address public AddressOfPricefeed;

    bool public Sale;

    uint256 public ethprice;

    mapping(address => uint256) public balance;

    constructor(address tokenAddress, address _AddressOfPricefeed) {
        token = SherlockCoin(tokenAddress);
        AddressOfPricefeed = _AddressOfPricefeed;
    }

    function buy() public payable {
        ethprice = msg.value;
        require(Sale == true, "Sale is True");
        rate = getConversionRate(msg.value);
        token.mint(msg.sender, rate);
        balance[msg.sender] = rate;
    }

    function balanceof(address customer) public view returns (uint256) {
        return balance[customer];
    }

    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    function withdraw() public payable onlyOwner {
        require(Sale == true, "Sale is false");

        (bool callSuccess, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(callSuccess, "Call failed");
    }

    function toggle() public onlyOwner {
        if (Sale == false) {
            Sale = true;
        } else {
            Sale = false;
        }
    }

    function GetConvertedPrice() public view returns (uint256) {
        uint256 ethPrice = getLatestPrice(AddressOfPricefeed);
        return ethPrice;
    }

    // function GetDecimals() public view returns(uint256) {
    //     decimals = getDecimals(AddressOfPricefeed);
    //     return decimals;
    // }

    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        //this is the function that takes the ethAmount and returns the amount in terms of USD
        uint256 ethPrice = getLatestPrice(AddressOfPricefeed);
        uint256 decimals = getDecimals(AddressOfPricefeed);
        uint256 ethAmountInUSD = (ethPrice * ethAmount) /
            ((10**18) * (10**decimals));
        return ethAmountInUSD;
    }

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
