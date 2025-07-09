// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FakeToken is ERC20 {
    constructor(uint256 _supply) ERC20("HAX", "HAX") {
        _mint(msg.sender, _supply);
    }
}