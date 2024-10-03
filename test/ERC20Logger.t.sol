// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ERC20Logger} from "../src/ERC20Logger.sol";
import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ExampleToken is ERC20 {
    constructor() ERC20("Example Token", "ET") {
        _mint(msg.sender, 1000000e18);
    }
}

contract CounterTest is Test {
    ERC20Logger public logger;
    ExampleToken public token;

    function setUp() public {
        logger = new ERC20Logger();
        token = new ExampleToken();
    }

    function test_Transfer(uint64 amount, address recipient) public {
        token.approve(address(logger), amount);

        vm.expectEmit(true, true, true, true);
        emit ERC20Logger.MetadataLogged(address(this), recipient, token, amount, "test metadata");

        bool success = logger.transferWithMetadata(token, recipient, amount, "test metadata");

        assertTrue(success);
    }
}
