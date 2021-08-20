ARG INSTALL_DIR=/opt/rv32i
ARG QEMU_TAG=v5.2.0
ARG RISCV_GNU_TOOLCHAIN_TAG=2021.06.26

#
# Stage-0: Build QEMU and RISC-V GNU toolchain from sources
#
FROM ubuntu:20.04
RUN apt-get update -yqq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        sudo git \
        autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev \
        gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \
        python-dev \
        ninja-build libglib2.0-dev libpixman-1-dev \
        device-tree-compiler && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /root/rv32i
ARG INSTALL_DIR

#
# Build QEMU
#
ARG QEMU_TAG
RUN git clone --depth 1 --branch ${QEMU_TAG} https://git.qemu.org/git/qemu.git qemu
RUN cd qemu && \
    ./configure --target-list=riscv32-softmmu --prefix=$INSTALL_DIR && \
   make && \
   make install

#
# Build RISC-V GNU toolchain
#
ARG RISCV_GNU_TOOLCHAIN_TAG
RUN git clone --depth 1 --branch ${RISCV_GNU_TOOLCHAIN_TAG} https://github.com/riscv/riscv-gnu-toolchain.git riscv-gnu-toolchain
RUN cd riscv-gnu-toolchain && \
    ./configure --prefix=$INSTALL_DIR --with-arch=rv32i --with-multilib-generator="rv32i-ilp32--;rv32ima-ilp32--;rv32imafd-ilp32--" && \
    make

#
# Stage-1: Lightweighter image with QEMU and RISC-V GNU toolchain binaries
#
FROM ubuntu:20.04
RUN apt-get update -yqq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
        sudo git \
        autoconf automake autotools-dev curl python3 libmpc-dev libmpfr-dev libgmp-dev \
        gawk build-essential bison flex texinfo gperf libtool patchutils bc zlib1g-dev libexpat-dev \
        python-dev \
        ninja-build libglib2.0-dev libpixman-1-dev \
        device-tree-compiler && \
    rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash riscv
USER riscv
WORKDIR /home/riscv
ARG INSTALL_DIR
COPY --from=0 ${INSTALL_DIR} ${INSTALL_DIR}

ENV PATH ${INSTALL_DIR}/bin:${PATH}

#
# Patched .gdbinit with fixes for QEMU v5.2.0, see https://github.com/johnwinans/riscv-toolchain-install-guide
#
COPY --chown=riscv .gdbinit .

