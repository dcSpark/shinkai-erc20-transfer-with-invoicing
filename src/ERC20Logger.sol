// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IERC20 {
    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);
}

contract ERC20Logger {
    event MetadataLogged(
        address indexed from,
        address indexed to,
        IERC20 indexed token,
        uint256 amount,
        string metadata
    );

    function transferWithMetadata(
        IERC20 token,
        address recipient,
        uint256 amount,
        string calldata metadata
    ) external {
        emit MetadataLogged(msg.sender, recipient, token, amount, metadata);

        token.transferFrom(msg.sender, recipient, amount);
    }
}
