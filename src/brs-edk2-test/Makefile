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

BRS_EDK2_TEST_CROSS_COMPILE = riscv64-linux-gnu-
BRS_EDK2_TEST_TARGET = brs-edk2-test
BRS_EDK2_TEST_REPOURL = git@github.com:tianocore/edk2-test.git
BRS_EDK2_TEST_BRANCH = brs-test
BRS_EDK2_TEST_COMMIT = 81dfa8d53d4290366ae41e1f4c2ed6d6c5016c07

BRS_EDK2_TEST_UEFI_BUILD_MODE = RELEASE
BRS_EDK2_TEST_UEFI_TOOLCHAIN = GCC5
BRS_EDK2_TEST_TARGET_ARCH = RISCV64

BRS_EDK2_DIR_PATH = ../../../brs-edk2/edk2

.PHONY: brs-edk2-test
brs-edk2-test:
	@echo "Building BRS EDK2-Test..."
	@if [ ! -d "edk2-test" ]; then
		echo "Cloning BRS edk2-test source..."
		git clone --progress $(BRS_EDK2_TEST_REPOURL) edk2-test

		pushd edk2-test
		git checkout -b $(BRS_EDK2_TEST_BRANCH) $(BRS_EDK2_TEST_COMMIT)

		@echo "Applying patches..."
		@if ! command -v stg &> /dev/null; then
			echo "stg command not found. Please install stgit to apply patches."
			exit 1
		fi

		stg init
		stg import -s ../patches/series

		popd
	fi

	pushd edk2-test
	@echo "Setting up EDK2-Test build environment..."
	@echo "Building BaseTools..."
	if [ ! -d uefi-sct/edk2 ]; then
		ln -s ../../../brs-edk2/edk2 uefi-sct/edk2
	fi
	. uefi-sct/edk2/edksetup.sh || true
	make -C uefi-sct/edk2/BaseTools

	@echo "Copying EDK2-Test testcase.."
	cp -r ../brsi-tests/BrsBootServices             uefi-sct/SctPkg/TestCase/UEFI/EFI/BootServices/
	cp -r ../brsi-tests/BrsiEfiSpecVerLvl           uefi-sct/SctPkg/TestCase/UEFI/EFI/Generic/
	cp -r ../brsi-tests/BrsiRequiredUefiProtocols   uefi-sct/SctPkg/TestCase/UEFI/EFI/Generic/
	cp -r ../brsi-tests/BrsiRuntimeServices         uefi-sct/SctPkg/TestCase/UEFI/EFI/RuntimeServices/
	cp ../brsi-tests/BRS_SCT.dsc                    uefi-sct/SctPkg/UEFI/
	cp ../brsi-tests/build_brs.sh                   uefi-sct/SctPkg/

	@echo "Copying EDK2-Test configs.."
	mkdir -p uefi-sct/SctPkg/BRS
	cp ../config/BRSIStartup.nsh            uefi-sct/SctPkg/BRS/
	cp ../config/BRSI.seq                   uefi-sct/SctPkg/BRS/
	cp ../config/BRSI_manual.seq            uefi-sct/SctPkg/BRS/
	cp ../config/BRSI_extd_run.seq          uefi-sct/SctPkg/BRS/
	cp ../config/EfiCompliant_BRSI.ini      uefi-sct/SctPkg/BRS/

	@echo "Compiling EDK2-Test..."
	pushd uefi-sct

	export EDK2_TOOLCHAIN=GCC5
	export GCC5_RISCV64_PREFIX=$(BRS_EDK2_TEST_CROSS_COMPILE)
	export DSC_EXTRA="ShellPkg/ShellPkg.dsc MdeModulePkg/MdeModulePkg.dsc"
	./SctPkg/build_brs.sh $(BRS_EDK2_TEST_TARGET_ARCH) GCC ${BRS_EDK2_TEST_UEFI_BUILD_MODE} -n $(nproc)

	@echo "Preparing BRSI outputs..."
	mkdir -p RISCV64_SCT/SCT
	mkdir -p RISCV64_SCT/SCT/Dependency/EfiCompliantBBTest
	mkdir -p RISCV64_SCT/SCT/Sequence
	cp -r Build/UefiSct/${BRS_EDK2_TEST_UEFI_BUILD_MODE}_${BRS_EDK2_TEST_UEFI_TOOLCHAIN}/SctPackageRISCV64/RISCV64/* RISCV64_SCT/SCT/
	cp SctPkg/BRS/EfiCompliant_BRSI.ini RISCV64_SCT/SCT/Dependency/EfiCompliantBBTest/EfiCompliant.ini
	cp SctPkg/BRS/BRSI_manual.seq       RISCV64_SCT/SCT/Sequence/BRSI_manual.seq
	cp SctPkg/BRS/BRSI_extd_run.seq     RISCV64_SCT/SCT/Sequence/BRSI_extd_run.seq
	cp SctPkg/BRS/BRSI.seq              RISCV64_SCT/SCT/Sequence/BRSI.seq
	cp SctPkg/BRS/BRSIStartup.nsh       RISCV64_SCT/SctStartup.nsh

	# Is this useless?
	cp SctPkg/BRS/BRSI.seq Build/UefiSct/${BRS_EDK2_TEST_UEFI_BUILD_MODE}_${BRS_EDK2_TEST_UEFI_TOOLCHAIN}/SctPackageRISCV64/RISCV64/Sequence/

	popd
	@echo "BRS EDK2-Test build complete."
	popd

.PHONY: clean
clean:
	@echo "Cleaning EDK2-Test build..."
	@echo "Removing EDK2-Test directory..."
	@rm -rf edk2-test
