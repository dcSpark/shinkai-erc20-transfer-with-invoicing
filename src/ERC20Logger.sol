// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

error TransferFailed();

contract ERC20Logger {
    event MetadataLogged(
        address indexed from, address indexed to, IERC20 indexed token, uint256 amount, string metadata
    );

    function transferWithMetadata(IERC20 token, address recipient, uint256 amount, string calldata metadata)
        external
        returns (bool)
    {
        emit MetadataLogged(msg.sender, recipient, token, amount, metadata);

        bool success = token.transferFrom(msg.sender, recipient, amount);

        if (!success) {
            revert TransferFailed();
        }

        return success;
    }
}
