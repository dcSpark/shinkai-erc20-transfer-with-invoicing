// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC20Logger} from "../src/ERC20Logger.sol";

contract LoggerScript is Script {
    ERC20Logger public logger;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        logger = new ERC20Logger();

        vm.stopBroadcast();
    }
}
