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

BRS_FWTS_CROSS_COMPILE = riscv64-linux-gnu-
BRS_FWTS_TARGET = brs-fwts
BRS_FWTS_REPOURL = https://github.com/fwts/fwts.git
BRS_FWTS_BRANCH = brs-test
BRS_FWTS_TAG = V24.11.00

UEFI_BUILD_MODE=RELEASE
UEFI_TOOLCHAIN=GCC5

.PHONY: brs-fwts
brs-fwts:
	@echo "Building BRS fwts..."
	@if [ ! -d "fwts" ]; then
		echo "Cloning BRS fwts source..."
		git clone --progress $(BRS_FWTS_REPOURL) fwts

		pushd fwts

		git checkout -b $(BRS_FWTS_BRANCH) $(BRS_FWTS_TAG)

		popd

	fi

	pushd fwts

	@echo "Setting up fwts build environment..."
	@autoreconf -ivf
	@./configure
	@make
	@sudo make install
	@echo "BRS fwts build complete."

	popd

.PHONY: clean
clean:
	@echo "Cleaning fwts build..."
	@echo "Removing fwts directory..."
	@rm -rf fwts
