// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PuzzleWallet {
    address public owner;
    mapping(address => bool) public whitelisted;
    mapping(address => uint256) public balances;
    uint256 public maxBalance;

    function init(address _owner, uint256 _maxBalance) external {
        require(owner == address(0), "Already initialized");
        owner = _owner;
        maxBalance = _maxBalance;
    }

    function addToWhitelist(address addr) external {
        require(msg.sender == owner, "Not owner");
        whitelisted[addr] = true;
    }

    function deposit() external payable {
        require(whitelisted[msg.sender], "Not whitelisted");
        require(msg.value > 0, "No value");
        balances[msg.sender] += msg.value;
    }

    function multicall(bytes[] calldata data) external payable {
        bool depositCalled = false;
        for (uint i = 0; i < data.length; i++) {
            bytes memory _data = data[i];
            bytes4 selector;
            assembly {
                selector := mload(add(_data, 32))
            }
            if (selector == this.deposit.selector) {
                require(!depositCalled, "Deposit can only be called once");
                depositCalled = true;
            }
            (bool success, ) = address(this).delegatecall(_data);
            require(success, "delegatecall failed");
        }
    }

    function execute(address to, uint256 value, bytes calldata data) external {
        require(whitelisted[msg.sender], "Not whitelisted");
        require(balances[msg.sender] >= value, "Insufficient balance");
        balances[msg.sender] -= value;
        (bool success, ) = to.call{value: value}(data);
        require(success, "call failed");
    }

    function setMaxBalance(uint256 _maxBalance) external {
        require(address(this).balance == 0, "Balance not zero");
        maxBalance = _maxBalance;
    }
}
