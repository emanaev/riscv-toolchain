# Toolchain to build, run and debug RISC-V programs in Docker

The repository is based on marvelous John Winans's [RISC-V toolchain install guide repo](https://github.com/johnwinans/riscv-toolchain-install-guide) and his video [QEMU RV32I Installation & Setup video](https://www.youtube.com/watch?v=iWQRV-KJ7tQ)

To make things easier I packed everything into Docker. Now you don't have to reproduce all John's steps to prepare environment, hack sources, wait for long builds. You just need a [Docker](https://docs.docker.com/engine/install/) on your machine.

Pull the <2Gb image with QEMU and RISC-V GNU toolchain binaries
```
docker pull emanaev/riscv-toolchain
```

Now you can build and run your code, see example project [test-freestanding](https://github.com/emanaev/riscv-toolchain/tree/main/test-freestanding).
