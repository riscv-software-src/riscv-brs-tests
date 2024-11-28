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

  EfiSpecVerLvlBBTestMain.c

Abstract:

  Test driver for BRS system environment configuration tests.

--*/

#include "SctLib.h"
#include "EfiSpecVerLvlBBTestFunction.h"
#include "EfiSpecVerLvlBBTestMain.h"

EFI_BB_TEST_PROTOCOL_FIELD gBBTestProtocolField = {
  EFISPECVERLVL_TEST_REVISION,
  EFISPECVERLVL_TEST_GUID,
  L"BRS UEFI Specification Version Level Test",
  L"Check the UEFI Specification Version Level to make sure it conforms to RISC-v BRS."
};

EFI_GUID gSupportProtocolGuid[2] = {
  EFI_STANDARD_TEST_LIBRARY_GUID,
  EFI_NULL_GUID
};

EFI_BB_TEST_ENTRY_FIELD gBBTestEntryField[] = {
  {
    EFISPECVERLVL_GUID,
    L"TestEfiSpecVerLvl",
    L"Check the EFI Specification Version Level.",
    EFI_TEST_LEVEL_DEFAULT,
    gSupportProtocolGuid,
    EFI_TEST_CASE_AUTO,
    BBTestEfiSpecVerLvlTest
  },
  EFI_NULL_GUID
};

EFI_BB_TEST_PROTOCOL *gBBTestProtocolInterface;

/** The driver's Unload function.
 *  @param  ImageHandle The test driver image handle
 *  @return EFI_SUCCESS Indicates the interface was uninstalled
*/
EFI_STATUS
BBTestEfiSpecVerLvlUnload (
  IN EFI_HANDLE       ImageHandle
  )
{
  return EfiUninstallAndFreeBBTestInterface (
           ImageHandle,
           gBBTestProtocolInterface
           );
}

/** Creates/installs the BlackBox Interface and emanating Entry Point node list.
 *  @param  ImageHandle The test driver image handle
 *  @param  SystemTable Pointer to System Table
 *  @return EFI_SUCCESS Indicates the interface was installed
 *  @return EFI_OUT_OF_RESOURCES Indicates space for the new handle could not be allocated
 *  @return EFI_INVALID_PARAMETER One of the parameters has an invalid value.
 */
EFI_STATUS
InitializeBBTestEfiSpecVerLvl (
  IN EFI_HANDLE           ImageHandle,
  IN EFI_SYSTEM_TABLE     *SystemTable
  )
{

  EfiInitializeTestLib (ImageHandle, SystemTable);

  return EfiInitAndInstallBBTestInterface (
           &ImageHandle,
           &gBBTestProtocolField,
           gBBTestEntryField,
           BBTestEfiSpecVerLvlUnload,
           &gBBTestProtocolInterface
           );
}
