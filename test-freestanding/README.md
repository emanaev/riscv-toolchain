A super simple freestanding RV32I app that is suitable for verifying a toolchain & qemu installation.

## Build
```
docker build -t test-freestanding .
```


## Run with one hart

```
docker run --rm -it --name=test test-freestanding \
qemu-system-riscv32 -machine virt -m 128M -bios none -device loader,file=./prog -nographic -s
```

Note that qemu will set the PC register to the load address of 'prog'.
To stop qemu: ^A x

## Run with GDB

Run qemu with -S to make it wait for gdb to attach before it starts running:

```
docker run --rm -it --name=test test-freestanding \
qemu-system-riscv32 -machine virt -m 128M -bios none -device loader,file=./prog -nographic -s -S
```

Then run GDB in separate terminal like this:
```
docker exec -it test \
riscv32-unknown-elf-gdb ./prog
```

When GDB starts enter:
```
target remote :1234
```

If QEMU hangs you can stop it with
```
docker stop test
```
