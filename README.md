# RISC-V Boot and Runtime Services Test Suite.

For more information on The Boot and Runtime Services(BRS) please see：[RISC-V Boot and Runtime Services (BRS) Specification](https://github.com/riscv-non-isa/riscv-brs).

This project is an automated detection suite designed to simplify the construction process of related test projects. Currently, the included test projects are [edk2-test](https://github.com/tianocore/edk2-test) and [SBI-test](https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git).

To prevent potential issues, please build on Ubuntu 22.04 and ensure at least 30GB of free disk space. At the same time, make sure that the following software is installed：curl mtools gdisk gcc openssl automake autotools-dev libtool bison flex bc uuid-dev python3 libglib2.0-dev libssl-dev autopoint gcc-riscv64-unknown-elf gcc g++

## Construct

```
git clone https://github.com/riscv-software-src/riscv-brs-tests.git

cd riscv-brs-tests && ./build.sh
```

The build.sh script will execute the Makefiles in each directory under /src one by one and build the image. The sources of these components are as follows：

| project   | source                                                 | tag/branch                               |
| --------- | -------------------------------------------------      | ---------------------------------------- |
| buildroot | https://github.com/buildroot/buildroot.git             | 2023.11                                  |
| edk2-test | https://github.com/tianocore/edk2-test.git             | 81dfa8d53d4290366ae41e1f4c2ed6d6c5016c07 |
| edk2      | https://github.com/tianocore/edk2.git                  | edk2-stable202308                        |
| grub      | https://git.savannah.gnu.org/git/grub.git              | grub-2.12                                |
| linux     | https://github.com/torvalds/linux.git                  | v6.12                                    |
| opensbi   | https://github.com/riscv-software-src/opensbi.git      | v1.4                                     |
| qemu      | https://github.com/qemu/qemu.git                       | v9.0.0                                   |
| SBI-test  | https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git   | v2024-01-08                              |
|           |                                                        |                                          |

The built image is located at /target/brs_live_image.img.

```
./target/start_uefi_sct.sh
```
This script starts qemu and automatically performs edk2-test and sbi-test tests.

## License
Licensed under the Apache License v2.0.

