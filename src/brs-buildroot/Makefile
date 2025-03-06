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

# BRS_BUILDROOT_CROSS_COMPILE = riscv64-linux-gnu-
BRS_BUILDROOT_TARGET = brs-buildroot
BRS_BUILDROOT_REPOURL = git@github.com:buildroot/buildroot.git
BRS_BUILDROOT_TAG = 2023.11
BRS_BUILDROOT_BRANCH = brs-test
BRS_BUILDROOT_OUPUT_PATH = output

.PHONY: brs-buildroot
brs-buildroot:
	@echo "Building BRS Buildroot..."
	@if [ ! -d "buildroot" ]; then
		echo "Cloning BRS Buildroot source..."
		git clone --progress $(BRS_BUILDROOT_REPOURL) buildroot

		pushd buildroot
		git checkout -b $(BRS_BUILDROOT_BRANCH) $(BRS_BUILDROOT_TAG)

		@echo "Applying patches..."
		@if ! command -v stg &> /dev/null; then
			echo "stg command not found. Please install stgit to apply patches."
			exit 1
		fi

		popd
	fi

	pushd buildroot

	@echo "Configuring Buildroot..."
	cp ../config/buildroot_defconfig configs/
	mkdir -p `pwd`/$(BRS_BUILDROOT_OUPUT_PATH)

	@echo "Compiling Buildroot..."
	make O=`pwd`/$(BRS_BUILDROOT_OUPUT_PATH) buildroot_defconfig
	make O=`pwd`/$(BRS_BUILDROOT_OUPUT_PATH) -j$(nproc)
	rm `pwd`/configs/buildroot_defconfig

	@echo "BRS Buildroot build complete."
	popd

.PHONY: clean
clean:
	@echo "Cleaning Buildroot build..."
	@echo "Removing Buildroot directory..."
	@rm -rf buildroot
