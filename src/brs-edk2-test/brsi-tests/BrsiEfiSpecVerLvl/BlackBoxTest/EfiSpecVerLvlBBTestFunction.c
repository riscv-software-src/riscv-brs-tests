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

  EfiSpecVerLvlBBTestFunction.c

Abstract:

  Test case definitions for EfiSpecVerLvl test.

--*/

#include "EfiSpecVerLvlBBTestMain.h"
#include "Guid.h"
#include "SctLib.h"
#include "EfiSpecVerLvlBBTestFunction.h"

/** Entrypoint for EFI Specification Version Level Test.
 *
 *  @param This a pointer of EFI_BB_TEST_PROTOCOL.
 *  @param ClientInterface a pointer to the interface to be tested.
 *  @param TestLevel test "thoroughness" control.
 *  @param SupportHandle a handle containing protocols required.
 *  @return EFI_SUCCESS Finish the test successfully.
 */

//
// BRS 8.1
//

EFI_STATUS
BBTestEfiSpecVerLvlTest (
  IN EFI_BB_TEST_PROTOCOL               *This,
  IN VOID                               *ClientInterface,
  IN EFI_TEST_LEVEL                     TestLevel,
  IN EFI_HANDLE                         SupportHandle
  )
{

  EFI_STANDARD_TEST_LIBRARY_PROTOCOL    *StandardLib;
  EFI_STATUS                            Status;
  UINTN                                 CurHrRev;

  // Get the Standard Library Interface
  Status = gtBS->HandleProtocol (
              SupportHandle,
              &gEfiStandardTestLibraryGuid,
              (VOID **) &StandardLib
              );
  if (EFI_ERROR (Status)) {
    return Status;
  }

  CurHrRev = gtBS->Hdr.Revision; // Reading revision of the EFI Specification.

  // Check if EFI Specification version is less than 2.7
  if (gtBS->Hdr.Revision < EFI_2_70_SYSTEM_TABLE_REVISION){
    StandardLib->RecordAssertion (
                StandardLib,
                EFI_TEST_ASSERTION_FAILED,
                gTestGenericFailureGuid,
                L"EFI Specification Version is below 2.7",
                L"%a:%d:Current EFI Header Rev=0x%X",
                __FILE__,
                __LINE__,
                CurHrRev
                );
    return EFI_INCOMPATIBLE_VERSION;
  } else {
    StandardLib->RecordAssertion (
                StandardLib,
                EFI_TEST_ASSERTION_PASSED,
                gEfiSpecVerLvlAssertion01Guid,
                L"TestEfiSpecVerLvl",
                L"%a:%d:Current EFI Header Rev=0x%X",
                __FILE__,
                __LINE__,
                CurHrRev
                );

    return EFI_SUCCESS;
  }
}
