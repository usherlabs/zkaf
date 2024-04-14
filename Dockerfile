# build to ghcr.io/nilfoundation/zkllvm-template:latest
FROM ghcr.io/nilfoundation/build-base:1.76.0

ARG ZKLLVM_VERSION=0.1.18

WORKDIR /user/src/zkaf

RUN DEBIAN_FRONTEND=noninteractive \
    echo 'deb [trusted=yes]  http://deb.nil.foundation/ubuntu/ all main' >> /etc/apt/sources.list \
    && apt-get update \
    && apt-get -y --no-install-recommends --no-install-suggests install \
      build-essential \
      cmake \
      git \
      zkllvm=${ZKLLVM_VERSION} \
      proof-producer \
      llvm \
      python3 \
      curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install Rust using rustup
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y && \
  curl --proto '=https' --tlsv1.2 -sSf https://cdn.jsdelivr.net/gh/NilFoundation/zkllvm@master/rslang-installer.py | python3 - --channel nightly && \
  . $HOME/.cargo/env && \
  cargo +zkllvm build --release --target assigner-unknown-unknown --features=zkllvm

