# WIP: ZK Attestation Framework - by [Usher Labs](https://www.usher.so)

## Supported platforms

- **Linux x86-64**

Docker must operate on a compatible OS to work.
**Apple Silicon:** Is not compatible even with `--platform linux/amd64`.

## Installation

### Docker

#### Build the Image

```shell
docker build . -t zkaf
```

#### Test the Image

```shell
docker run --rm -t zkaf:latest cargo --version
```

*This should respond with something like `cargo 1.77.2 (e52e36006 2024-03-26)`*

#### SSH into Image

```shell
docker run -v ./:/opt/zkaf/ -it zkaf:latest /bin/bash
```

#### Command Prefixing

To continue operating all of the circuit build and generation instructions, simply prefix the commands with: 

```shell
docker run -v ./:/opt/zkaf/ -t zkaf:latest <insert zkllvm circuit command>
```

### Base OS (Ubuntu)

#### Prerequisites

Dependencies:

- Python 3.10+
- Git
- Curl

On most of the modern Linux-based platforms you will already have these installed.

#### Install

Reference: [https://github.com/NilFoundation/zkllvm-rust-template](https://github.com/NilFoundation/zkllvm-rust-template)

```bash
# Install zkLLVM
sudo bash -c "echo 'deb [trusted=yes]  http://deb.nil.foundation/ubuntu/ all main' >>/etc/apt/sources.list"
sudo apt update
sudo apt install -y zkllvm proof-producer

# Install LLVM - requires llvm-symbolizer in PATH
sudo apt install llvm

# Install zkLLVM rslang-toolchain -- NOTE: Use Python3 on latest Ubuntu versions.
curl --proto '=https' --tlsv1.2 -sSf https://cdn.jsdelivr.net/gh/NilFoundation/zkllvm@master/rslang-installer.py | python3 - --channel nightly
```

## Build

```bash
cargo +zkllvm build --release --target assigner-unknown-unknown --features=zkllvm
```

Tells Rust to use zkllvm libraries which uses forks of arkworks and other crypto libs for more efficient circuits.

Compiles to a `.ll` format, which is an intermediate LLVM assembly representation of our code.

This is used to produce the **circuit and assignment table.**

<aside>
💡 Do not use `assert` methods from native Rust. 
Instead return a boolean, or some value, or `nil`.
</aside>

## Circuit Generation

Here we use the `assigner` CLI tool.

This takes two inputs:

1. the `.ll` assembly code
2. an input file in a JSON format, which contains input values for your circuit function.

```bash
assigner -b target/assigner-unknown-unknown/release/zkaf.ll -i inputs/example.json -t output/assignment.tbl -c output/circuit.crct -e pallas
```

However, the default Rust circuit logic within the `zkLLVM-rust-tempate` , will not compile. Changing this may indeed work.

<aside>
💡 To write to an `output` directory, be sure to `mkdir` prior to the `assigner` execution
</aside>

## Transpile to EVM Proof Verifier

From within the `output` dir,

For Test Proof that is locally verified:

```bash
transpiler -m gen-test-proof -i inputs/example.json -c output/circuit.crct -t output/assignment.tbl -e pallas -o ./output/proof
```

Unsure what the difference here is with using:

```bash
proof-generator-multi-threaded --circuit output/circuit.crct --assignment output/assignment.tbl --proof output/proof-2/proof.bin
```

For EVM Verifier:

```bash
transpiler -m gen-evm-verifier -i inputs/example.json -c output/circuit.crct -t output/assignment.tbl -e pallas -o ./output/verifier
```

The `modular_verifier.sol` is the entrypoint.

**Solidity files require a rewrite to use [`evm-placeholder-verification`](https://github.com/NilFoundation/evm-placeholder-verification) dependency.**

```bash
pnpm use-sol-deps
```

## Notes

### Public vs Private Inputs

- Public Inputs are provided all the way through to verification on-chain.
- Private Inputs are passed only into the assignment step

Both inputs are passed as files — therefore there needs to be an automation of process creation for the ZK Prover — unless we fork the `proof-market`.

<aside>
💡 Examples if Inputs — https://github.com/NilFoundation/zkLLVM/tree/master/examples/inputs
</aside>