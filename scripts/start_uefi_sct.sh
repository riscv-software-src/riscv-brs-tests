#!/bin/bash
# Copyright 2024, ISCAS. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Enable debug ouput for script
set -e

BRS_QEMU_RISCV64=./qemu/build/qemu-system-riscv64
BRS_BIOS=./fw_dynamic.bin
BRS_IMAGE=./brs_live_image.img
BRS_IMAGE_XZ=./brs_live_image.img.xz
BRS_RISCV_VIRT_CODE_FD=./RISCV_VIRT_CODE.fd
BRS_RISCV_VIRT_VARS_FD=./RISCV_VIRT_VARS.fd


# Decompress brs image
if [ -e $BRS_IMAGE ]; then
    echo "Find image: $BRS_IMAGE"
elif [ -e $BRS_IMAGE_XZ ]; then
    echo "Decompresing $BRS_IMAGE_XZ "
    xz -d $BRS_IMAGE_XZ
else
    echo "Firmware test suite image: $BRS_IMAGE_XZ does not exist!"
    exit 1
fi

echo "Starting rv64 qemu... press Ctrl+A, X to exit qemu"
sleep 2
$BRS_QEMU_RISCV64 -nographic \
    -machine virt,aia=aplic-imsic,pflash0=pflash0,pflash1=pflash1 \
    -cpu rv64 -m 4G -smp 2   \
    -bios $BRS_BIOS \
    -drive file=$BRS_IMAGE,if=none,format=raw,id=drv1 -device virtio-blk-device,drive=drv1  \
    -blockdev node-name=pflash0,driver=file,read-only=on,filename=$BRS_RISCV_VIRT_CODE_FD \
    -blockdev node-name=pflash1,driver=file,filename=$BRS_RISCV_VIRT_VARS_FD \
    -device e1000,netdev=net0 \
    -device virtio-gpu-pci \
    -netdev type=user,id=net0 \
    -device qemu-xhci \
    -device usb-mouse \
    -device usb-kbd
