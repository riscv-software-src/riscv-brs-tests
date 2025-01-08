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

brs_compile() {  
    local components=("linux" "grub" "edk2" "edk2-test" "edk2-test-parser" "buildroot" "opensbi" "sbi-test" "qemu")  
    
    echo "Select a component to compile:"  
    for i in "${!components[@]}"; do  
        echo "$((i + 1)). ${components[$i]}"  
    done  
    echo "C. Compile All Components"  
    echo "0. Back to main menu"  
    
    # Controlled countdown function  
    countdown() {  
        local remaining=10  
        local selection=""  
        
        # Use stty to disable input buffering  
        stty -icanon -echo min 0 time 10  
        
        while [ $remaining -gt 0 ]; do  
            # Output countdown to stderr to ensure visibility  
            printf "\r\033[K" >&2  
            printf "Time remaining: %2d seconds | Select option (1-9, C, 0): " "$remaining" >&2  
            
            # Non-blocking read  
            read -t 1 input  
            
            # Process input immediately  
            if [[ -n "$input" ]]; then  
                if [[ "$input" =~ ^[1-9Cc0]$ ]]; then  
                    selection="$input"  
                    break  
                fi  
            fi  
            
            ((remaining--))  
        done  
        
        # Restore terminal settings  
        stty icanon echo  
        
        # Return selection or default to 'C'  
        if [[ -z "$selection" ]]; then  
            echo "C"  
        else  
            echo "$selection"  
        fi  
    }  

    # Get selection from countdown  
    selection=$(countdown)  

    # Compilation logic  
    if [[ $selection == '0' ]]; then  
        return  
    elif [[ $selection == 'C' || $selection == 'c' || -z "$selection" ]]; then  
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

brs_buildimage() {  
    echo  
    echo "-------------------------------------"  
    echo "Preparing disk image for busybox boot"  
    echo "-------------------------------------"  
    
    local FAT_SIZE_MB=512  
    local FAT2_SIZE_MB=128  
    
    # Assuming 2048 sectors for 1MB
    local PART_START=$((1 * 2048)) 
    local FAT_SIZE=$((FAT_SIZE_MB * 2048))  
    local FAT2_SIZE=$((FAT2_SIZE_MB * 2048))  

    rm -rf "$BRS_IMAGE_DIR"  
    mkdir -p "$BRS_IMAGE_DIR"  
    pushd "$BRS_IMAGE_DIR" > /dev/null  

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

    if [ -f $PLATDIR/$BRS_IMAGE.xz ]; then
        echo "Completed preparation of disk image for busybox boot"
        echo "Image path : $PLATDIR/$BRS_IMAGE.xz"
    fi
    echo "----------------------------------------------------"

    popd 
}  

brs_install() {  
    # install qemu
    echo "Installing components..."  
    mkdir -p "$TARGET_DIR/qemu"  
    cp -r "$SRC_DIR/brs-qemu/qemu/build" "$TARGET_DIR/qemu/"  
    
    # install bios
    cp "$SRC_DIR/brs-opensbi/opensbi/build/platform/generic/firmware/fw_dynamic.bin" "$TARGET_DIR/"  
    
    # install sct test
    cp "$SRC_DIR/brs-edk2/edk2/Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_CODE.fd" "$TARGET_DIR/"  
    cp "$SRC_DIR/brs-edk2/edk2/Build/RiscVVirtQemu/RELEASE_GCC5/FV/RISCV_VIRT_VARS.fd" "$TARGET_DIR/"  
    
    # install image xz file
    cp "$BRS_IMAGE_DIR/$BRS_IMAGE_XZ" "$TARGET_DIR/"  
    
    # install scripts
    cp "$SCRIPTS_DIR/start_uefi_sct.sh" "$TARGET_DIR/"  
    echo "Installation complete."  
}  

brs_clean() {  
    # remove tmp dir for brs image build
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

show_menu_with_countdown() {
    local options=("Initialize" "Compile" "Build Image" "Install" "Clean" "Exit")

    while true; do
        show_menu

        countdown() {  
            local remaining=10  
            local selection=""  
        
            # Use stty to disable input buffering  
            stty -icanon -echo min 0 time 10  
        
            while [ $remaining -gt 0 ]; do  
                # Output countdown to stderr to ensure visibility  
                printf "\r\033[K" >&2  
                printf "Time remaining: %2d seconds | Select option (1-6): " "$remaining" >&2  
            
                # Non-blocking read  
                read -t 1 input  
            
                # Process input immediately  
                if [[ -n "$input" ]]; then  
                    if [[ "$input" =~ ^[1-6]$ ]]; then  
                        selection="$input"  
                        break  
                    fi  
                fi  
            
                ((remaining--))  
            done  
        
            # Restore terminal settings  
            stty icanon echo  
        
            # Return selection or default to 'C'  
            if [[ -z "$selection" ]]; then  
                echo "C"  
            else  
                echo "$selection"  
            fi  
        }  
    
        # Get selection from countdown  
        selection=$(countdown)  

        if [[ $selection == 'C' || -z "$selection" ]]; then 
            for i in {1..6}; do
                case $i in
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
                        break  # exit function
                        ;;
                esac
            done
            break
        else
            case "$selection" in
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
                    break  # exit function
                    ;;
                *)
                    # Invalid option
                    echo "Invalid option, please try again"
                    ;;
            esac
        fi
    done
}

# Start execute  
show_menu_with_countdown