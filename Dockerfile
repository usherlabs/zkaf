# FROM rust:1-bookworm as boost_builder
# RUN DEBIAN_FRONTEND=noninteractive \
#     set -xe \
#     && apt-get update \
#     && apt-get -y --no-install-recommends --no-install-suggests install \
#         autoconf \
#         automake \
#         build-essential \
#         wget \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# # using global args with their default versions
# ARG BOOST_VERSION
# ARG BOOST_VERSION_UNDERSCORED
# ARG BOOST_SETUP_DIR
# ARG BOOST_BUILD_DIRECTORY

# WORKDIR /tmp
# RUN set -xe \
#     && wget -q --no-check-certificate \
#       https://boostorg.jfrog.io/artifactory/main/release/${BOOST_VERSION}/source/boost_${BOOST_VERSION_UNDERSCORED}.tar.gz \
#     && mkdir ${BOOST_BUILD_DIRECTORY} \
#     && tar -xvf boost_${BOOST_VERSION_UNDERSCORED}.tar.gz \
#     && rm boost_${BOOST_VERSION_UNDERSCORED}.tar.gz

# WORKDIR ${BOOST_BUILD_DIRECTORY}
# RUN set -xe \
#     && sh ./bootstrap.sh --prefix=${BOOST_SETUP_DIR} \
#     && ./b2 --prefix=${BOOST_SETUP_DIR} \
#     && ./b2 install --prefix=${BOOST_SETUP_DIR}


# FROM rust:1-bookworm
# LABEL Name=build-base Version=1.76.0
# # using global args with their default versions
# ARG BOOST_SETUP_DIR

# COPY --from=boost_builder ${BOOST_SETUP_DIR} ${BOOST_SETUP_DIR}
# ENV BOOST_ROOT=${BOOST_SETUP_DIR}

# build to ghcr.io/nilfoundation/zkllvm-template:latest
# FROM ghcr.io/nilfoundation/build-base:1.76.0

# LABEL maintainer="Usher Labs <ryan@usher.so>"

# ARG ZKLLVM_VERSION=0.1.18

# ENV RUST_VERSION=1.77.2 \
# 	PATH=/root/.cargo/bin:$PATH

# RUN DEBIAN_FRONTEND=noninteractive \
#     echo 'deb [trusted=yes]  http://deb.nil.foundation/ubuntu/ all main' >> /etc/apt/sources.list \
#     && apt-get update \
#     && apt-get -y --no-install-recommends --no-install-suggests install \
#       build-essential \
#       cmake \
#       git \
#       zkllvm=${ZKLLVM_VERSION} \
#       proof-producer \
#       llvm \
#       python3 \
#       curl \
#     && apt-get clean \
#     && rm -rf /var/lib/apt/lists/*

# RUN [[ $(uname -m) == "x86_64" ]] && ARCH="x86_64" || ARCH="aarch64" && \
# RUN curl -O https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init && \
#     chmod +x rustup-init && \
#     ./rustup-init -y --no-modify-path --default-toolchain $RUST_VERSION && \
#     rm rustup-init && \
#     rustc --version && \
#     cargo --version

# RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
# ENV PATH="/root/.cargo/bin:${PATH}"

# RUN curl --proto '=https' --tlsv1.2 -sSf https://cdn.jsdelivr.net/gh/NilFoundation/zkllvm@master/rslang-installer.py | python3 - --channel nightly

# WORKDIR /user/src/zkaf

# # Copy the current directory contents into the container at /usr/src/app
# COPY . .

# # Build the Rust app using Cargo
# RUN cargo +zkllvm build --release --target assigner-unknown-unknown --features=zkllvm

FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y --no-install-recommends --no-install-suggests install \
      build-essential \
      cmake \
      git \
      ca-certificates \
      # zkllvm=${ZKLLVM_VERSION} \
      # proof-producer \
      # llvm \
      python3 \
      curl \
      wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.77.2

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='a3d541a5484c8fa2f1c21478a6f6c505a778d473c21d60a18a4df5185d320ef8' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='7cff34808434a28d5a697593cd7a46cefdf59c4670021debccd4c86afde0ff76' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='76cd420cb8a82e540025c5f97bda3c65ceb0b0661d5843e6ef177479813b0367' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='cacdd10eb5ec58498cd95dbb7191fdab5fa4343e05daaf0fb7cdcae63be0a272' ;; \
        ppc64el) rustArch='powerpc64le-unknown-linux-gnu'; rustupSha256='b152711fb15fd629f0d4c2731cbf9167e6352da0ffcb2210447d80c010180f96' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.27.0/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;