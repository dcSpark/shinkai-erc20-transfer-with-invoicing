// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ERC20Logger} from "../src/ERC20Logger.sol";

contract CounterTest is Test {
    ERC20Logger public logger;

    function setUp() public {
        logger = new ERC20Logger();
    }

    function test_Transfer() public {}
}
