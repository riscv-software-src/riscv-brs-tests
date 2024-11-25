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

  BrsBootServicesBBTestMain.h

Abstract:

  Contains definitions for test information and test GUIDs.

--*/

#ifndef _BRSBOOTSERVICES_TEST_MAIN_H_
#define _BRSBOOTSERVICES_TEST_MAIN_H_

#include "Efi.h"
#include "Guid.h"
#include <Library/EfiTestLib.h>

#define BRSBOOTSERVICES_TEST_REVISION 0x00010000

#define BRSBOOTSERVICES_TEST_GUID \
  { 0x236da812, 0x2002, 0x4ad9, {0x88, 0x4d, 0x05, 0x8f, 0xd2, 0xdd, 0x13, 0x86 }}

#define ACPI_TABLE_EXPECTED_LENGTH 36
#define ACPI_TABLE_CHECKSUM_LENGTH 20
#define SMBIOS30_ANCHOR_STRING "_SM3_"
#define RSDP_SIGNATURE_STRING "RSD PTR "

EFI_STATUS
InitializeBBTestBrsBootServices (
  IN EFI_HANDLE           ImageHandle,
  IN EFI_SYSTEM_TABLE     *SystemTable
  );

EFI_STATUS
BBTestBrsBootServicesUnload (
  IN EFI_HANDLE       ImageHandle
  );

//
// Test Case GUIDs
//

#define BRSBOOTSERVICES_MEMORYMAP_GUID \
  { 0x1b610277, 0xcadb, 0x433d, {0xa7, 0xab, 0xa7, 0x7f, 0xe4, 0x26, 0xfb, 0xfd }}

#define BRSBOOTSERVICES_ACPITABLE_GUID \
  { 0xbfc24bf8, 0xe8f8, 0x4c80, {0xb3, 0x30, 0xe6, 0xd6, 0x29, 0xd8, 0x43, 0x24 }}

#define BRSBOOTSERVICES_SMBIOSTABLE_GUID \
  { 0x970c1d8b, 0x17c1, 0x42dd, {0x9b, 0x05, 0x2b, 0x65, 0x37, 0x49, 0x9c, 0xa2 }}

#endif /* _BRSBOOTSERVICES_TEST_MAIN_H_ */
