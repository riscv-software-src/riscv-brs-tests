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

  RequiredUefiProtocolsBBTestFunction.h

Abstract:

  Contains definitions and prototypes for test case functions.

--*/

#ifndef _REQUIREDUEFIPROTOCOLS_BB_TEST_FUNCTION_H_
#define _REQUIREDUEFIPROTOCOLS_BB_TEST_FUNCTION_H_

/*
 * GUIDs of protocols we're looking for are here as to avoid
 * compilation errors in the case that they do not exist in the
 * system.
 */

#define EFI_LOAD_FILE_PROTOCOL_GUID \
{0x56EC3091, 0x954C, 0x11d2, {0x8E, 0x3F, 0x00, 0xA0, 0xC9, 0x69, 0x72, 0x3B}}

#define EFI_LOAD_FILE2_PROTOCOL_GUID \
{0x4006C0C1, 0xFCB3, 0x403E, {0x99, 0x6D, 0x4A, 0x6C, 0x87, 0x24, 0xE0, 0x6D}}

typedef struct {
  EFI_GUID guid;
  UINT16 *name;
} BRS_REQUIRED_PROTOCOL;

EFI_STATUS
BBTestMediaIoProtocolsTest (
  IN EFI_BB_TEST_PROTOCOL       *This,
  IN VOID                       *ClientInterface,
  IN EFI_TEST_LEVEL             TestLevel,
  IN EFI_HANDLE                 SupportHandle
  );

#endif /* _REQUIREDUEFIPROTOCOLS_BB_TEST_FUNCTION_H_ */
