#!/bin/bash
# Copyright 2024, ISCAS. All rights reserved.
# Copyright (c) 2024, Academy of Intelligent Innovation, Shandong Universiy, China.P.R. All rights reserved.<BR>
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

#!/bin/bash  
set -e  

# Variables  
SRC_DIR="$(pwd)/src"  
TARGET_DIR="$(pwd)/target"  
SCRIPTS_DIR="$(pwd)/scripts"  

BRS_IMAGE="brs_live_image.img"  
BRS_IMAGE_XZ="$BRS_IMAGE.xz"  
BRS_IMAGE_DIR="$TARGET_DIR/brs-image"  

BRS_GRUB_RISCV64_EFI_FILE="$SRC_DIR/brs-grub/grub/output/grubriscv64.efi"  
BRS_UEFI_SHELL_EFI_FILE="$SRC_DIR/brs-edk2-test/edk2-test/uefi-sct/Build/Shell/RELEASE_GCC5/RISCV64/ShellPkg/Application/Shell/Shell/OUTPUT/Shell.efi"  
BRS_LINUX_IMAGE="$SRC_DIR/brs-linux/linux/arch/riscv/boot/Image"  
BRS_RAMDISK_BUILDROOT_IMAGE="$SRC_DIR/brs-buildroot/buildroot/output/images/rootfs.cpio"  

BRS_UEFI_SCT_PATH="$SRC_DIR/brs-edk2-test/edk2-test/uefi-sct/RISCV64_SCT"  

BRS_GRUB_BUILDROOT_CFG_FILE="$SRC_DIR/brs-grub/config/grub-buildroot.cfg"  
BRS_EFI_CONFIG_SCRIPT="$SCRIPTS_DIR/startup.nsh"  
BRS_EFI_SCT_STARTUP_SCRIPT="$SCRIPTS_DIR/BRSIStartup.nsh"  
BRS_EFI_DEBUG_CONFIG_SCRIPT="$SCRIPTS_DIR/debug_dump.nsh"  

BRS_BLOCK_SIZE=512  

# Functions  
brs_init() {  
    echo "Initializing the target directory..."  
    rm -rf "$TARGET_DIR"  
}  

brs_compile_component() {  
    local components=("linux" "grub" "edk2" "edk2-test" "edk2-test-parser" "buildroot" "opensbi" "sbi-test" "qemu")  
    
    echo "Select a component to compile:"  
    for i in "${!components[@]}"; do  
        echo "$((i + 1)). ${components[$i]}"  
    done  
    echo "C. Compile All Components"  
    echo "0. Back to main menu"  
    
    read -rp "Please choose an option (0-C): " selection  
    if [[ $selection == '0' ]]; then  
        return  
    elif [[ $selection == 'C' ]]; then  
        for component in "${components[@]}"; do  
            echo "Compiling $component..."  
            pushd "$SRC_DIR/brs-$component" > /dev/null  
            if make; then  
                echo "$component compiled successfully."  
            else  
                echo "Failed to compile $component."  
            fi  
            popd > /dev/null  
        done  
        return  
    elif [[ $selection -ge 1 && $selection -le ${#components[@]} ]]; then  
        local component=${components[$((selection - 1))]}  
        echo "Compiling $component..."  
        pushd "$SRC_DIR/brs-$component" > /dev/null  
        if make; then  
            echo "$component compiled successfully."  
        else  
            echo "Failed to compile $component."  
        fi  
        popd > /dev/null  
    else  
        echo "Invalid selection. Returning to main menu."  
    fi  
}  

brs_compile() {  
    while true; do  
        brs_compile_component  
        read -rp "Compile another component? (y/n): " choice  
        if [[ "$choice" != "y" ]]; then  
            break  
        fi  
    done  
}  

brs_buildimage() {  
    echo  
    echo "-------------------------------------"  
    echo "Preparing disk image for busybox boot"  
    echo "-------------------------------------"  
    
    local FAT_SIZE_MB=512  
    local FAT2_SIZE_MB=128  
    local PART_START=$((1 * 2048))  # Assuming 2048 sectors for 1MB  
    local FAT_SIZE=$((FAT_SIZE_MB * 2048))  
    local FAT2_SIZE=$((FAT2_SIZE_MB * 2048))  

    rm -rf "$BRS_IMAGE_DIR"  
    mkdir -p "$BRS_IMAGE_DIR"  
    pushd "$BRS_IMAGE_DIR" > /dev/null  

    echo "Creating disk image..."  
    dd if=/dev/zero of="$BRS_IMAGE" bs=$BRS_BLOCK_SIZE count=$((PART_START + FAT_SIZE + FAT2_SIZE + 2048))  

    echo "Creating FAT partitions..."  
    mkfs.vfat -n "BOOT" "$BRS_IMAGE" # Create first FAT partition  
    mkfs.vfat -n "RESULT" "$BRS_IMAGE" # Create second FAT partition  

    echo "Disk image created: $BRS_IMAGE"  
    popd > /dev/null  
}  

brs_install() {  
    echo "Installing components..."  
    mkdir -p "$TARGET_DIR/qemu"  
    cp -r "$SRC_DIR/brs-qemu/qemu/build" "$TARGET_DIR/qemu/"  
    cp "$SRC_DIR/brs-opensbi/opensbi/build/platform/generic/firmware/fw_dynamic.bin" "$TARGET_DIR/"  
    cp "$SRC_DIR/brs-edk2/edk2/Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_CODE.fd" "$TARGET_DIR/"  
    cp "$SRC_DIR/brs-edk2/edk2/Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_VARS.fd" "$TARGET_DIR/"  
    cp "$BRS_IMAGE_DIR/$BRS_IMAGE_XZ" "$TARGET_DIR/"  
    cp "$SCRIPTS_DIR/start_uefi_sct.sh" "$TARGET_DIR/"  
    echo "Installation complete."  
}  

brs_clean() {  
    echo "Cleaning up temporary files..."  
    rm -rf "$BRS_IMAGE_DIR"  
}  

# Menu function  
show_menu() {  
    echo "------------------------"  
    echo " BRS Build Menu"  
    echo "------------------------"  
    echo "1. Initialize Target Directory"  
    echo "2. Compile Components"  
    echo "3. Build Disk Image"  
    echo "4. Install Components"  
    echo "5. Clean Up"  
    echo "6. Exit"  
    echo "------------------------"  
}  

# Main loop  
while true; do  
    show_menu  
    read -rp "Please choose an option (1-6): " choice  
    case "$choice" in  
        1)  
            brs_init  
            ;;  
        2)  
            brs_compile  
            ;;  
        3)  
            brs_buildimage  
            ;;  
        4)  
            brs_install  
            ;;  
        5)  
            brs_clean  
            ;;  
        6)  
            echo "Exiting... Returning to terminal."  
            break  
            ;;  
        *)  
            echo "Invalid option, please try again."  
            ;;  
    esac  
done
