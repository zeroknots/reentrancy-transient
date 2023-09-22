// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import "src/ReentrancyGuard.sol";

interface ICallback {
    function callback() external;
}

interface IImpl {
    function i() external returns (uint256);
    function run(uint256 _i) external;
}

contract Impl is ReentrancyGuard, IImpl {
    uint256 public i;

    function run(uint256 _i) public nonReentrant("run") {
        ICallback(msg.sender).callback();
        i = _i;
    }
}

contract ImplNoGuard is IImpl {
    uint256 public i;

    function run(uint256 _i) public {
        ICallback(msg.sender).callback();
        i = _i;
    }
}

contract ReentrancyGuardTest is Test, ICallback {
    Impl impl;
    ImplNoGuard implNoGuard;

    uint256 _reentering;

    function setUp() public {
        impl = new Impl();
        implNoGuard = new ImplNoGuard();
    }

    function callback() public override {
        if (_reentering == 0) {
            _reentering = 1;

            IImpl(msg.sender).run(1337);
        }
    }

    function test_reentrancy_guard() public {
        vm.expectRevert();
        impl.run(42);
    }

    function test_no_reentrancy_guard() public {
        implNoGuard.run(42);
    }
}
