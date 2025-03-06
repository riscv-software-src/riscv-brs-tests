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

# BRS_QEMU_CROSS_COMPILE = riscv64-linux-gnu-
BRS_QEMU_TARGET = brs-qemu
BRS_QEMU_REPOURL = git@github.com:qemu/qemu.git
BRS_QEMU_BRANCH = brs-test
BRS_QEMU_BRANCH_REMOTE = v9.0.0
# BRS_QEMU_COMMIT = 15ecd5f3774b63a5893adb0c0ff657a9b316cb56

.PHONY: brs-qemu
brs-qemu:
	@echo "Building BRS QEMU..."
	@if [ ! -d "qemu" ]; then
		echo "Cloning BRS qemu source..."
		git clone --progress $(BRS_QEMU_REPOURL) qemu

		pushd qemu
		@git checkout -b $(BRS_QEMU_BRANCH) $(BRS_QEMU_BRANCH_REMOTE)

		@echo "Applying patches..."
		@if ! command -v stg &> /dev/null; then
			echo "stg command not found. Please install stgit to apply patches."
			exit 1
		fi

		popd
	fi

	pushd qemu

	@if [ ! -d "roms/edk2" ]; then
		echo "Copying edk2 source..."
		cp -r ../../brs-edk2/edk2 roms/edk2
	fi

	@echo "Configuring QEMU..."
	./configure --enable-slirp --enable-debug --target-list=riscv64-softmmu

	@echo "Compiling QEMU..."
	make -j$(nproc)

	@echo "BRS QEMU build complete."
	popd

.PHONY: clean
clean:
	@echo "Cleaning QEMU build..."
	@echo "Removing QEMU directory..."
	@rm -rf qemu
