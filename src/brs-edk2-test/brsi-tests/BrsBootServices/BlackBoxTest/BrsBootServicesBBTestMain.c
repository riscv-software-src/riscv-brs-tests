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

  BrsBootServicesBBTestMain.c

Abstract:

  Test driver for BrsBootServices tests.

--*/

#include "SctLib.h"
#include "BrsBootServicesBBTestMain.h"
#include "BrsBootServicesBBTestFunction.h"

EFI_BB_TEST_PROTOCOL_FIELD gBBTestProtocolField = {
  BRSBOOTSERVICES_TEST_REVISION,
  BRSBOOTSERVICES_TEST_GUID,
  L"BrsBootServices Tests",
  L"Tests BRS boot services requirements."
};

EFI_GUID gSupportProtocolGuid[2] = {
  EFI_STANDARD_TEST_LIBRARY_GUID,
  EFI_NULL_GUID
};

EFI_BB_TEST_ENTRY_FIELD gBBTestEntryField[] = {
  {
    BRSBOOTSERVICES_MEMORYMAP_GUID,
    L"MemoryMap",
    L"Checks memory map provided by UEFI.",
    EFI_TEST_LEVEL_DEFAULT,
    gSupportProtocolGuid,
    EFI_TEST_CASE_AUTO,
    BBTestMemoryMapTest
  },
  {
    BRSBOOTSERVICES_SMBIOSTABLE_GUID,
    L"SmbiosTable",
    L"Checks that SMBIOS3 table is provided by UEFI.",
    EFI_TEST_LEVEL_DEFAULT,
    gSupportProtocolGuid,
    EFI_TEST_CASE_AUTO,
    BBTestSmbiosTableTest
  },
  {
    BRSBOOTSERVICES_ACPITABLE_GUID,
    L"AcpiTable",
    L"Checks that ACPI table is provided by UEFI.",
    EFI_TEST_LEVEL_DEFAULT,
    gSupportProtocolGuid,
    EFI_TEST_CASE_AUTO,
    BBTestAcpiTableTest
  },
  EFI_NULL_GUID
};

EFI_BB_TEST_PROTOCOL *gBBTestProtocolInterface;

/**
 *  The driver's Unload function
 *  @param  ImageHandle The test driver image handle
 *  @return EFI_SUCCESS Indicates the interface was Uninstalled
*/
EFI_STATUS
BBTestBrsBootServicesUnload (
  IN EFI_HANDLE       ImageHandle
  )
{
  return EfiUninstallAndFreeBBTestInterface (
           ImageHandle,
           gBBTestProtocolInterface
           );
}

/**
 *  Creates/installs the BlackBox Interface and eminating Entry Point
 *  node list.
 *  @param  ImageHandle The test driver image handle
 *  @param  SystemTable Pointer to System Table
 *  @return EFI_SUCCESS Indicates the interface was installed
 *  @return EFI_OUT_OF_RESOURCES Indicates space for the new handle could not be allocated
 *  @return EFI_INVALID_PARAMETER: One of the parameters has an invalid value.
 */
EFI_STATUS
InitializeBBTestBrsBootServices (
  IN EFI_HANDLE           ImageHandle,
  IN EFI_SYSTEM_TABLE     *SystemTable
  )
{

  EfiInitializeTestLib (ImageHandle, SystemTable);
  SctInitializeLib (ImageHandle, SystemTable);

  return EfiInitAndInstallBBTestInterface (
           &ImageHandle,
           &gBBTestProtocolField,
           gBBTestEntryField,
           BBTestBrsBootServicesUnload,
           &gBBTestProtocolInterface
           );
}
