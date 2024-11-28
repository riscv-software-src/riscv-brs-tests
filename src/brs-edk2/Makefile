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

.ONESHELL:
SHELL = /bin/bash
.SHELLFLAGS += -e

BRS_EDK2_CROSS_COMPILE = riscv64-linux-gnu-
BRS_EDK2_TARGET = brs-edk2
BRS_EDK2_REPOURL = git@github.com:tianocore/edk2.git
BRS_EDK2_BRANCH = brs-test
BRS_EDK2_TAG = edk2-stable202308

UEFI_BUILD_MODE=RELEASE
UEFI_TOOLCHAIN=GCC5

.PHONY: brs-edk2
brs-edk2:
	@echo "Building BRS EDK2..."
	@if [ ! -d "edk2" ]; then
		echo "Cloning BRS edk2 source..."
		git clone --progress $(BRS_EDK2_REPOURL) edk2

		pushd edk2
		git checkout -b $(BRS_EDK2_BRANCH) $(BRS_EDK2_TAG)

		@echo "Applying patches..."
		@if ! command -v stg &> /dev/null; then
			echo "stg command not found. Please install stgit to apply patches."
			exit 1
		fi

		stg init
		stg import -s ../patches/series
		popd
	fi

	pushd edk2
	@echo "Initializing EDK2 submodules..."
	@git submodule update --init --progress

	@echo "Setting up EDK2 build environment..."
	@export GCC5_RISCV64_PREFIX=riscv64-linux-gnu-
	@export PACKAGES_PATH=`pwd`
	@export EDK_TOOLS_PATH=`pwd`/BaseTools
	@source edksetup.sh

	@echo "Building BaseTools..."
	@make -C BaseTools clean
	@make -C BaseTools
	@make -C BaseTools/Source/C

	@echo "Compiling EDK2..."
	@source edksetup.sh BaseTools
	@build -a RISCV64 --buildtarget ${UEFI_BUILD_MODE} -p OvmfPkg/RiscVVirt/RiscVVirtQemu.dsc -t ${UEFI_TOOLCHAIN}
	@truncate -s 32M Build/RiscVVirtQemu/${UEFI_BUILD_MODE}_${UEFI_TOOLCHAIN}/FV/RISCV_VIRT_CODE.fd
	@truncate -s 32M Build/RiscVVirtQemu/${UEFI_BUILD_MODE}_${UEFI_TOOLCHAIN}/FV/RISCV_VIRT_VARS.fd

	@echo "BRS EDK2 build complete."
	popd

.PHONY: clean
clean:
	@echo "Cleaning EDK2 build..."
	@echo "Removing EDK2 directory..."
	@rm -rf edk2
