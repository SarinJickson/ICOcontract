// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SherlockCoin is ERC20, Ownable {
    uint256 public maxSupply;

    constructor(
        address owner1,
        address owner2,
        address owner3
    ) ERC20("SherlockCoin", "SLC") {
        _mint(owner1, 100000);
        _mint(owner2, 100000);
        _mint(owner3, 100000);
        maxSupply = 1000000;
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}
