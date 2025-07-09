// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IDexTwo {
    function token1() external view returns (address);
    function token2() external view returns (address);
    function balanceOf(address token, address account) external view returns (uint);
    function swap(address from, address to, uint amount) external;
    function approve(address spender, uint amount) external;
}