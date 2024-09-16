# ERC20 Logger

This is a simple proxy contract that allows to log metadata when transferring ERC20 tokens.

## Usage

Install foundry [here](https://book.getfoundry.sh/getting-started/installation).

### Rust library

Regenerate bindings:

```shell
$ forge bind --bindings-path logger-lib/src/bindings --module
```

### Build

```shell
$ forge build
```

### Test

```shell
$ cargo test
$ forge test
```

### Deploy

```shell
$ forge script script/ERC20Logger.s.sol:LoggerScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```
