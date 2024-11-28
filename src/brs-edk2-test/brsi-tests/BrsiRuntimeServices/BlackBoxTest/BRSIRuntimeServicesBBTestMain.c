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

  BRSIRuntimeServicesBBTestMain.c

Abstract:

  Test driver for BRSIRuntimeServices tests.

--*/

#include "SctLib.h"
#include "BRSIRuntimeServicesBBTestFunction.h"
#include "BRSIRuntimeServicesBBTestMain.h"


EFI_TPL TplArray [TPL_ARRAY_SIZE] = {
  TPL_APPLICATION,
  TPL_CALLBACK,
  TPL_NOTIFY
};

EFI_BB_TEST_PROTOCOL_FIELD gBBTestProtocolField = {
  BRSIRUNTIMESERVICES_TEST_REVISION,
  BRSIRUNTIMESERVICES_TEST_GUID,
  L"BRSIRuntimeServices Tests",
  L"Tests to test Runtime Services Exception Level, Memory Map, Real Time Clock , Reset, Shutdown and Set Variable."
};

EFI_GUID gSupportProtocolGuid[2] = {
  EFI_STANDARD_TEST_LIBRARY_GUID,
  EFI_NULL_GUID
};

EFI_BB_TEST_ENTRY_FIELD gBBTestEntryField[] = {
  {
    BRSIRUNTIMESERVICES_TEST_CASE_GUID,
    L"Runtime Services Test",
    L"Test to check runtime services exist or not.",
    EFI_TEST_LEVEL_DEFAULT,
    gSupportProtocolGuid,
    EFI_TEST_CASE_AUTO,
    BBTestRuntimeServices
  },
  {
    BRSIRUNTIMESERVICES_TEST_CASE_RESETSHUTDOWN_GUID,
    L"ResetSystem Shutdown Test",
    L"Manual Test for ResetSystem Shutdown.",
    EFI_TEST_LEVEL_DEFAULT,
    gSupportProtocolGuid,
    EFI_TEST_CASE_MANUAL,
    BBTestResetShutdown
  },
  {
    BRSIRUNTIMESERVICES_TEST_CASE_NONVOLATILEVARIABLE_GUID,
    L"Non-volatile Variable Reset Test",
    L"Ensures that non-volatile UEFI variables can survive cold resets.",
    EFI_TEST_LEVEL_DEFAULT,
    gSupportProtocolGuid,
    EFI_TEST_CASE_AUTO,
    BBTestNonVolatileVariable
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
BBTestBRSIRuntimeServicesUnload (
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
InitializeBBTestBRSIRuntimeServices (
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
           BBTestBRSIRuntimeServicesUnload,
           &gBBTestProtocolInterface
           );
}
