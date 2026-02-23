riscv-brs-tests
=======================
RISC-V Boot and Runtime Services Test Suite

## Overview

Used for simplifying the construction process of related test projects. There are two menu in build.sh.

## Environments

Before running, make sure that you have installed these packages:

acpica-tools automake autopoint autotools-dev bc bison bzip2 cpio curl dosfstools flex gawk gcc gcc-riscv64-linux-gnu gdisk gettext g++ iasl libglib2.0-dev libpixman-1-dev libssl-dev libtool make mtools ninja-build openssl patch python3 python3-venv rsync stgit unzip uuid-dev vim wget

At the same time, please build on Ubuntu 24.04 and ensure at least 30GB of free disk space.

## Structure

The structure of this repository is listed below:

        .
        ├── Scripts
        ¦      ├── BRSIStartup.nsh
        ¦      ├── debug_dump.nsh
        ¦      ├── start_uefi_sct.sh
        ¦      └── startup.nsh
        ├── src
        ¦    ├── brs-buildroot
        ¦    ├── brs-edk2-test
        ¦    ├── brs-edk2
        ¦    ├── brs-grub
        ¦    ├── brs-linux
        ¦    ├── brs-opensbi
        ¦    ├── brs-qemu
        ¦    ├── brs-sbi-test
        ├── .gitgnore
        ├── LICENSE
        ├── NOTICE
        ├── README.md
        └── build.sh

## How To Run

Download and enter riscv-brs-tests repository.

        cd riscv-brs-tests

Run build.sh, firstly you will see start menu. There are 6 options in this menu:

        1. Initialize Target Directory
        2. Compile Components
        3. Build Disk Image
        4. Install Components
    	5. Clean Up
        6. Exit

If you don't make any choice within 10 seconds, the script will execute all choices.

Specially, if you choose "Compile Components",
you will see a menu which contains 10 options:

        1. linux
        2. grub
        3. edk2
        4. edk2-test
        5. buildroot
        6. opensbi
        7. sbi-test
        8. qemu
        C. Compile All Components
        0. Back to main menu

Similar with last menu, if you don't make any choice within 10 seconds, all components will be compiled. The sources of these components are as follows:
| project   | source                                               | tag/branch                               |
| --------- | ---------------------------------------------------- | ---------------------------------------- |
| buildroot | https://github.com/buildroot/buildroot.git           | 2025.11                                  |
| edk2-test | https://github.com/tianocore/edk2-test.git           | 2b2a16ac239cd89d778cb79ae6e42c533fc4c25a |
| edk2      | https://github.com/tianocore/edk2.git                | edk2-stable202508                        |
| grub      | https://git.savannah.gnu.org/git/grub.git            | grub-2.12                                |
| linux     | https://github.com/torvalds/linux.git                | v6.19                                    |
| opensbi   | https://github.com/riscv-software-src/opensbi.git    | v1.8.1                                   |
| qemu      | https://github.com/qemu/qemu.git                     | v10.2.0                                  |
| SBI-test  | https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git | v2025-07-3                               |
|           |                                                      |                                          |

After executing the build.sh, you will see a directory named 'target'. Enter this directory and run start_uefi_sct.sh.

Supports two parameters, allowing the edk2-test(1) and sbi-test(2) test projects to run.

        cd target
        . start_uefi_sct.sh [1/2]



Brs test will be executed.
