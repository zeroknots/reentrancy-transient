// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.20;

uint256 constant LOCKED = 1;
uint256 constant UNLOCKED = 0;

contract ReentrancyGuard {
    error ReentrancyGuardError(bytes32 key);

    modifier nonReentrant(bytes32 key) {
      require(tload(key) == UNLOCKED);
        tstore(key, LOCKED);
        _;
        tstore(key, UNLOCKED);
    }

    function tstore(bytes32 key, uint256 value) private {
        assembly {
            tstore(key, value)
        }
    }

    function tload(bytes32 key) private view returns (uint256 value) {
        assembly {
            value := tload(key)
        }
    }
}
