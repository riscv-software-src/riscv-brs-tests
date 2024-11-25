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

set -e

REALEASE_TYPE=RELEASE

SRC_DIR=`pwd`/src
TARGET_DIR=`pwd`/target
SCRIPTS_DIR=`pwd`/scripts

BRS_IMAGE=brs_live_image.img
BRS_IMAGE_XZ=$BRS_IMAGE.xz
BRS_IMAGE_DIR=$TARGET_DIR/brs-image

BRS_GRUB_RISCV64_EFI_FILE=$SRC_DIR/brs-grub/grub/output/grubriscv64.efi
BRS_UEFI_SHELL_EFI_FILE=$SRC_DIR/brs-edk2-test/edk2-test/uefi-sct/Build/Shell/DEBUG_GCC5/RISCV64/ShellPkg/Application/Shell/Shell/OUTPUT/Shell.efi
BRS_LINUX_IMAGE=$SRC_DIR/brs-linux/linux/arch/riscv/boot/Image
BRS_RAMDISK_BUILDROOT_IMAGE=$SRC_DIR/brs-buildroot/buildroot/output/images/rootfs.cpio

BRS_UEFI_SCT_PATH=$SRC_DIR/brs-edk2-test/edk2-test/uefi-sct/RISCV64_SCT

BRS_GRUB_BUILDROOT_CFG_FILE=$SRC_DIR/brs-grub/config/grub-buildroot.cfg
BRS_EFI_CONFIG_SCRIPT=$SCRIPTS_DIR/BRSIStartup.nsh
BRS_EFI_SCT_STARTUP_SCRIPT=$SCRIPTS_DIR/startup.nsh
BRS_EFI_DEBUG_CONFIG_SCRIPT=$SCRIPTS_DIR/debug_dump.nsh

BRS_BLOCK_SIZE=512
BRS_SEC_PER_MB=$((1024*2))

brs_init()
{
    rm -rf $TARGET_DIR
}

brs_compile()
{
    # 1. compile linux
    echo "Compiling linux..."
    pushd $SRC_DIR/brs-linux
    make
    popd

    # 2. compile grub
    echo "Compiling grub..."
    pushd $SRC_DIR/brs-grub
    make
    popd

    # 3. compile edk2
    echo "Compiling edk2..."
    pushd $SRC_DIR/brs-edk2
    make
    popd

    # 4. compile edk2-test
    echo "Compiling edk2-test..."
    pushd $SRC_DIR/brs-edk2-test
    make
    popd

    # 5. compile edk2-test-parser
    echo "Compiling edk2-test-parser..."
    pushd $SRC_DIR/brs-edk2-test-parser
    make
    popd

    # 6. compile buildroot
    echo "Compiling buildroot..."
    pushd $SRC_DIR/brs-buildroot
    make
    popd

    # 7. compile opensbi
    echo "Compiling opensbi..."
    pushd $SRC_DIR/brs-opensbi
    make
    popd

    # 8. compile sbi-test
    echo "Compiling sbi-test..."
    pushd $SRC_DIR/brs-sbi-test
    make
    popd

    # 9. compile qemu
    echo "Compiling Qemu..."
    pushd $SRC_DIR/brs-qemu
    make
    popd
}

brs_buildimage()
{
    echo
    echo "-------------------------------------"
    echo "Preparing disk image for busybox boot"
    echo "-------------------------------------"
    local FAT_SIZE_MB=512
    local FAT2_SIZE_MB=128
    local PART_START=$((1*BRS_SEC_PER_MB))
    local FAT_SIZE=$((FAT_SIZE_MB*BRS_SEC_PER_MB))
    local FAT2_SIZE=$((FAT2_SIZE_MB*BRS_SEC_PER_MB))

    rm -rf $BRS_IMAGE_DIR
    mkdir -p $BRS_IMAGE_DIR
    pushd $BRS_IMAGE_DIR

    cp $BRS_GRUB_RISCV64_EFI_FILE bootriscv64.efi
    cp $BRS_UEFI_SHELL_EFI_FILE Shell.efi
    cp $BRS_LINUX_IMAGE Image
    cp $BRS_RAMDISK_BUILDROOT_IMAGE ramdisk-buildroot.img

    cp -Tr $BRS_UEFI_SCT_PATH SCT
    grep -q -F 'mtools_skip_check=1' ~/.mtoolsrc || echo "mtools_skip_check=1" >> ~/.mtoolsrc

    #Package images for Busybox
    dd if=/dev/zero of=part_table bs=$BRS_BLOCK_SIZE count=$PART_START

    #Space for partition table at the top
    cat part_table > $BRS_IMAGE

    #Create fat partition
    local fatpart_name="BOOT"  #Name of the FAT partition disk image
    local fatpart_size=$FAT_SIZE  #FAT partition size (in 512-byte blocks)

    dd if=/dev/zero of=$fatpart_name bs=$BRS_BLOCK_SIZE count=$fatpart_size
    mkfs.vfat $fatpart_name -n $fatpart_name
    mmd -i $fatpart_name ::/EFI
    mmd -i $fatpart_name ::/EFI/BOOT
    mmd -i $fatpart_name ::/grub

    mmd -i $fatpart_name ::/EFI/BOOT/brs
    mmd -i $fatpart_name ::/EFI/BOOT/debug
    mmd -i $fatpart_name ::/EFI/BOOT/app

    mcopy -i $fatpart_name bootriscv64.efi        ::/EFI/BOOT
    mcopy -i $fatpart_name Shell.efi              ::/EFI/BOOT
    mcopy -i $fatpart_name Image                  ::/
    mcopy -i $fatpart_name ramdisk-buildroot.img  ::/

    mcopy -s -i $fatpart_name SCT/* ::/EFI/BOOT/brs
    # mcopy -i $fatpart_name ${UEFI_APPS_PATH}/CapsuleApp.efi ::/EFI/BOOT/app
    echo "FAT partition image created"

    mcopy -i  $fatpart_name -o ${BRS_GRUB_BUILDROOT_CFG_FILE}     ::/grub.cfg
    mcopy -i  $fatpart_name -o ${BRS_EFI_SCT_STARTUP_SCRIPT}      ::/EFI/BOOT/brs/
    mcopy -i  $fatpart_name -o ${BRS_EFI_CONFIG_SCRIPT}           ::/EFI/BOOT/
    mcopy -i  $fatpart_name -o ${BRS_EFI_DEBUG_CONFIG_SCRIPT}     ::/EFI/BOOT/debug/
    cat BOOT >> $BRS_IMAGE

    #Result partition
    local fatpart2_name="RESULT"  #Name of the FAT partition disk image
    local fatpart2_size=$FAT2_SIZE  #FAT partition size (in 512-byte blocks)

    dd if=/dev/zero of=$fatpart2_name bs=$BRS_BLOCK_SIZE count=$fatpart2_size
    mkfs.vfat $fatpart2_name -n $fatpart2_name
    mmd -i $fatpart2_name ::/acs_results
    echo "FAT partition 2 image created"
    cat RESULT >> $BRS_IMAGE

    # Space for backup partition table at the bottom (1M)
    cat part_table >> $BRS_IMAGE

    # create disk image and copy into output folder
    local image_name=$BRS_IMAGE
    local part_start=$PART_START

    (echo n; echo 1; echo $part_start; echo +$((fatpart_size-1));\
    echo 0700; echo w; echo y) | gdisk $image_name
    (echo n; echo 2; echo $((part_start+fatpart_size)); echo +$((fatpart2_size-1));\
    echo 0700; echo w; echo y) | gdisk $image_name

    #remove intermediate files
    rm -f part_table
    rm -f BOOT
    rm -f RESULT

    echo "Compressing the image : $BRS_IMAGE"
    xz -z $BRS_IMAGE

    if [ -f $PLATDIR/$IMG_BB.xz ]; then
        echo "Completed preparation of disk image for busybox boot"
        echo "Image path : $PLATDIR/$IMG_BB.xz"
    fi
    echo "----------------------------------------------------"

    popd
}

brs_install()
{
    # install qemu
    mkdir -p $TARGET_DIR/qemu
    cp -r $SRC_DIR/brs-qemu/qemu/build $TARGET_DIR/qemu/

    # install bios
    cp $SRC_DIR/brs-opensbi/opensbi/build/platform/generic/firmware/fw_dynamic.bin $TARGET_DIR/

    # install sct test
    cp $SRC_DIR/brs-edk2/edk2/Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_CODE.fd $TARGET_DIR/
    cp $SRC_DIR/brs-edk2/edk2/Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_VARS.fd $TARGET_DIR/

    # install image xz file
    cp $BRS_IMAGE_DIR/$BRS_IMAGE_XZ $TARGET_DIR/

    # install scripts
    cp $SCRIPTS_DIR/start_uefi_sct.sh $TARGET_DIR/
}

brs_clean()
{
    # remove tmp dir for brs image build
    rm -rf $BRS_IMAGE_DIR
}

main()
{
    brs_init

    brs_compile

    brs_buildimage

    brs_install

    brs_clean
}


main
