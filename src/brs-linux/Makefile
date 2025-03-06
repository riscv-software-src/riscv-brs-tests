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

BRS_LINUX_CROSS_COMPILE = riscv64-linux-gnu-
BRS_LINUX_TARGET = brs-linux
BRS_LINUX_REPOURL = git@github.com:torvalds/linux.git
BRS_LINUX_BRANCH = brs-test
BRS_LINUX_BRANCH_REMOTE = v6.12
# BRS_LINUX_COMMIT = ac5e19d018afa8a37761510bd233ca319a763c42

.PHONY: brs-linux
brs-linux:
	@echo "Building BRS Linux..."
	@if [ ! -d "linux" ]; then
		echo "Cloning BRS linux source..."
		git clone --progress $(BRS_LINUX_REPOURL) linux

		pushd linux
		git checkout -b $(BRS_LINUX_BRANCH) $(BRS_LINUX_BRANCH_REMOTE)
		popd
	fi

	@pushd linux
	@echo "Compiling Linux kernel..."
	@make ARCH=riscv CROSS_COMPILE=$(BRS_LINUX_CROSS_COMPILE) defconfig
	@make ARCH=riscv CROSS_COMPILE=$(BRS_LINUX_CROSS_COMPILE) -j$(nproc)

	@echo "BRS Linux build complete."
	popd

.PHONY: clean
clean:
	@echo "Cleaning Linux build..."
	@echo "Removing Linux directory..."
	@rm -rf linux
	@echo "BRS Linux clean complete."
