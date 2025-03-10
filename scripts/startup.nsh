# Copyright (c) 2021-2023, ARM Limited and Contributors. All rights reserved.
# Copyright (c) 2024 Intel Corporation
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# Redistributions of source code must retain the above copyright notice, this
# list of conditions and the following disclaimer.
#
# Redistributions in binary form must reproduce the above copyright notice,
# this list of conditions and the following disclaimer in the documentation
# and/or other materials provided with the distribution.
#
# Neither the name of ARM nor the names of its contributors may be used
# to endorse or promote products derived from this software without specific
# prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

echo -off
connect -r

for %i in 0 1 2 3 4 5 6 7 8 9 A B C D E F then
    if exist FS%i:\EFI\BOOT\brs\SctStartup.nsh then
        FS%i:\EFI\BOOT\brs\SctStartup.nsh %1
        goto Donebrs
    endif
endfor
:Donebrs

for %e in 0 1 2 3 4 5 6 7 8 9 A B C D E F then
    if exist FS%e:\acs_results then
        FS%e:
        cd FS%e:\acs_results
        if not exist app_output then
            mkdir app_output
        endif
        cd app_output
        for %q in 0 1 2 3 4 5 6 7 8 9 A B C D E F then
            if exist FS%q:\EFI\BOOT\app\CapsuleApp.efi then
                echo "Running CapsuleApp"
                FS%q:\EFI\BOOT\app\CapsuleApp.efi -P > CapsuleApp_FMP_protocol_info.log
                FS%q:\EFI\BOOT\app\CapsuleApp.efi -E > CapsuleApp_ESRT_table_info.log
                goto DoneApp
            endif
        endfor
    endif
endfor
:DoneApp

for %l in 0 1 2 3 4 5 6 7 8 9 A B C D E F then
    if exist FS%l:\Image and exist FS%l:\ramdisk-buildroot.img then
        FS%l:
        cd FS%l:\
        Image initrd=\ramdisk-buildroot.img console=ttyS0 earlycon earlyprintk
    endif
endfor
echo "Image not found"
