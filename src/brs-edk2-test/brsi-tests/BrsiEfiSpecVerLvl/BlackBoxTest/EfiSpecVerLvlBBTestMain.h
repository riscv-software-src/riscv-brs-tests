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

  EfiSpecVerLvlBBTestMain.h

Abstract:

  Contains definitions for test information and test GUIDs.

--*/

#ifndef _EFISPECVERLVL_TEST_MAIN_H_
#define _EFISPECVERLVL_TEST_MAIN_H_

#include "Efi.h"
#include <Library/EfiTestLib.h>


#define EFISPECVERLVL_TEST_REVISION 0x00010000

#define EFISPECVERLVL_TEST_GUID     \
  {0xd6e40d12, 0x7a51, 0x4454, {0xb4, 0xfd, 0x4c, 0x93, 0x88, 0x7e, 0xd6, 0xcf}}

EFI_STATUS
InitializeBBTestEfiSpecVerLvl (
  IN EFI_HANDLE           ImageHandle,
  IN EFI_SYSTEM_TABLE     *SystemTable
  );

//
// Entry GUIDs
//

#define EFISPECVERLVL_GUID \
  {0x6e46b2e2, 0x2535, 0x4c8e, {0x82, 0x5a, 0x84, 0x5d, 0xc2, 0xbe, 0xed, 0xdf}}


#endif /* _EFISPECVERLVL_TEST_MAIN_H_ */
