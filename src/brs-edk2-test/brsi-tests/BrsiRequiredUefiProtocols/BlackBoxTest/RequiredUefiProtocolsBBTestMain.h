/*
*  Copyright 2006 - 2016 Unified EFI, Inc. All
*  Rights Reserved, subject to all existing rights in all
*  matters included within this Test Suite, to which United
*  EFI, Inc. makes no claim of right.
*
*  Copyright (c) 2016, ARM. All rights reserved.
*  Copyright (c) 2024 Intel Corporation
*
*  This program and the accompanying materials
*  are licensed and made available under the terms and conditions of the BSD License
*  which accompanies this distribution.  The full text of the license may be found at
*  http://opensource.org/licenses/bsd-license.php
*
*  THE PROGRAM IS DISTRIBUTED UNDER THE BSD LICENSE ON AN "AS IS" BASIS,
*  WITHOUT WARRANTIES OR REPRESENTATIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED.
*
*/
/*++

Module Name:

  RequiredUefiProtocolsBBTestMain.h

Abstract:

  Contains definitions for test information and test GUIDs.

--*/

#ifndef _REQUIREDUEFIPROTOCOLS_TEST_MAIN_H_
#define _REQUIREDUEFIPROTOCOLS_TEST_MAIN_H_

#include "Efi.h"
#include "Guid.h"
#include <Library/EfiTestLib.h>

#define REQUIREDUEFIPROTOCOLS_TEST_REVISION 0x00010000

#define REQUIREDUEFIPROTOCOLS_TEST_GUID \
{ 0x6b4d5d18, 0xf55f, 0x4fc5, {0x84, 0x96, 0xf1, 0x00, 0x22, 0x37, 0x5c, 0x04 }}

EFI_STATUS
InitializeBBTestRequiredUefiProtocols (
  IN EFI_HANDLE           ImageHandle,
  IN EFI_SYSTEM_TABLE     *SystemTable
  );

EFI_STATUS
BBTestBootRequiredUefiProtocols (
  IN EFI_HANDLE       ImageHandle
  );

//
// Entry GUIDs
//

#define REQUIREDUEFIPROTOCOLS_MEDIAIOPROTOCOLS_GUID \
{ 0x24d52c4c, 0xafeb, 0x49ea, {0xa7, 0x77, 0x8f, 0xe1, 0x9f, 0x32, 0x20, 0x66 }}

#endif /* _REQUIREDUEFIPROTOCOLS_TEST_MAIN_H_ */
