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

  RequiredUefiProtocolsBBTestFunction.c

Abstract:

  Test case function definitions for RequiredUefiProtocols.

--*/

#include "RequiredUefiProtocolsBBTestMain.h"
#include "RequiredUefiProtocolsBBTestFunction.h"
#include "SctLib.h"
#include "Guid.h"

/**
 *  Entrypoint for MediaIoProtocols Test.
 *  @param This a pointer of EFI_BB_TEST_PROTOCOL.
 *  @param ClientInterface a pointer to the interface to be tested.
 *  @param TestLevel test "thoroughness" control.
 *  @param SupportHandle a handle containing protocols required.
 *  @return EFI_SUCCESS Finish the test successfully.
 */

EFI_STATUS
BBTestMediaIoProtocolsTest (
  IN EFI_BB_TEST_PROTOCOL             *This,
  IN VOID                             *ClientInterface,
  IN EFI_TEST_LEVEL                   TestLevel,
  IN EFI_HANDLE                       SupportHandle
  )
{

  EFI_STANDARD_TEST_LIBRARY_PROTOCOL  *StandardLib;
  EFI_STATUS                          Status;
  EFI_TEST_ASSERTION                  AssertionType;
  EFI_HANDLE                          *HandleBuffer;
  UINTN                               NumberOfHandles;
  BRS_REQUIRED_PROTOCOL             Protocol[] = {
                                        {EFI_LOAD_FILE_PROTOCOL_GUID, L"EFI_LOAD_FILE_PROTOCOL"},
                                        {gEfiNullGuid, 0}
                                      };
  UINT32                              i;

  //
  // Get the Standard Library Interface
  //
  Status = gtBS->HandleProtocol (
              SupportHandle,
              &gEfiStandardTestLibraryGuid,
              (VOID **) &StandardLib
              );
  if (EFI_ERROR (Status)) {
    return Status;
  }

  //
  // Looking for Protocols
  //
  i = 0;
  while (SctCompareGuid (&Protocol[i].guid, &gEfiNullGuid) != 0){
    Status = gBS->LocateHandleBuffer (
                ByProtocol,
                &Protocol[i].guid,
                NULL,
                &NumberOfHandles,
                &HandleBuffer
                );

    if ((Status == EFI_NOT_FOUND) && (NumberOfHandles == 0)){
      // Protocol not found
      StandardLib->RecordAssertion (
                  StandardLib,
                  EFI_TEST_ASSERTION_FAILED,
                  gRequiredUefiProtocolsAssertion001Guid,
                  L"MediaIoProtocols",
                  L"%a:%d:%s Not Found",
                  __FILE__,
                  __LINE__,
                  Protocol[i].name
                  );
    }
    else {
      // Protocol found
      StandardLib->RecordAssertion (
                  StandardLib,
                  EFI_TEST_ASSERTION_PASSED,
                  gRequiredUefiProtocolsAssertion001Guid,
                  L"MediaIoProtocols",
                  L"%a:%d:%s Found",
                  __FILE__,
                  __LINE__,
                  Protocol[i].name
                  );
    }

    i++;
  }

  return EFI_SUCCESS;
}
