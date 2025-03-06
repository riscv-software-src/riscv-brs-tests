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

BRS_SBI_TEST_CROSS_COMPILE = riscv64-linux-gnu-
BRS_SBI_TEST_TARGET = brs-sbi-test
BRS_SBI_TEST_REPOURL = https://gitlab.com/kvm-unit-tests/kvm-unit-tests.git
BRS_SBI_TEST_BRANCH = brs-test
# BRS_SBI_TEST_BRANCH_REMOTE = riscv/x-tests
BRS_SBI_TEST_COMMIT = 0ed2cdf3c80ee803b9150898e687e77e4d6f5db2

.PHONY: brs-sbi-test
brs-sbi-test:
	@echo "Building BRS SBI TEST..."
	@if [ ! -d "sbi-test" ]; then \
		git clone --progress $(BRS_SBI_TEST_REPOURL) sbi-test;
		pushd sbi-test
		@git checkout -b $(BRS_SBI_TEST_BRANCH) $(BRS_SBI_TEST_COMMIT)
		@git pull --rebase

		popd
	fi

	pushd sbi-test
	@git submodule update --init --recursive --progress

	@echo "Configuring SBI TEST..."
	@./configure --arch=riscv64 --cross-prefix=$(BRS_SBI_TEST_CROSS_COMPILE)

	@echo "Compiling SBI TEST..."
	@make -j$(nproc)

	@echo "BRS SBI TEST build complete."
	popd


.PHONY: clean
clean:
	@echo "Cleaning SBI Test build..."
	@rm -f sbi-test
