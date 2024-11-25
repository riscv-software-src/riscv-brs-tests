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

  EfiSpecVerLvlBBTestFunction.h

Abstract:

  Contains definitions and prototypes used in the test functions.

--*/

#ifndef _EFISPECVERLVL_BB_TEST_FUNCTION_H_
#define _EFISPECVERLVL_BB_TEST_FUNCTION_H_

#include <Library/EfiTestLib.h>

EFI_STATUS
BBTestEfiSpecVerLvlTest (
  IN EFI_BB_TEST_PROTOCOL       *This,
  IN VOID                       *ClientInterface,
  IN EFI_TEST_LEVEL             TestLevel,
  IN EFI_HANDLE                 SupportHandle
  );

#endif /* _EFISPECVERLVL_BB_TEST_FUNCTION_H_ */
