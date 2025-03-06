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

BRS_OPENSBI_CROSS_COMPILE = riscv64-linux-gnu-
BRS_OPENSBI_TARGET = brs-opensbi
BRS_OPENSBI_REPOURL = git@github.com:riscv-software-src/opensbi.git
BRS_OPENSBI_BRANCH = brs-test
BRS_OPENSBI_TAG = v1.4
# BRS_OPENSBI_COMMIT = 057eb10b6d523540012e6947d5c9f63e95244e94

.PHONY: brs-opensbi
brs-opensbi:
	@echo "Building BRS OpenSBI..."
	@if [ ! -d "opensbi" ]; then
		echo "Cloning BRS opensbi source..."
		git clone --progress $(BRS_OPENSBI_REPOURL) opensbi

		pushd opensbi
		@git checkout -b $(BRS_OPENSBI_BRANCH) $(BRS_OPENSBI_TAG)
		popd
	fi

	pushd opensbi
	@echo "Compiling OpenSBI..."
	make ARCH=riscv CROSS_COMPILE=$(BRS_OPENSBI_CROSS_COMPILE) PLATFORM=generic -j$(nproc)

	@echo "BRS OpenSBI build complete."
	popd

.PHONY: clean
clean:
	@echo "Cleaning OpenSBI build..."
	@echo "Removing OpenSBI directory..."
	@rm -rf opensbi
