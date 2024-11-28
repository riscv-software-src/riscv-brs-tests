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

  Guid.h

Abstract:

  Definitions for GUIDs used in test assertions.

--*/

#ifndef _BRSBOOTSERVICES_GUID_H_
#define _BRSBOOTSERVICES_GUID_H_

#define BRSBOOTSERVICES_ASSERTION_001_GUID \
{ 0x9e212ddd, 0x1218, 0x45a3, {0x8b, 0x30, 0xaa, 0x80, 0x5e, 0xa3, 0x6f, 0x5e }}

extern EFI_GUID gBrsBootServicesAssertion001Guid;

#define BRSBOOTSERVICES_ASSERTION_002_GUID \
{ 0xf89d0d28, 0xcd1f, 0x4557, {0x8d, 0xae, 0x32, 0xdd, 0xab, 0x7e, 0xe3, 0x92 }}

extern EFI_GUID gBrsBootServicesAssertion002Guid;

#define BRSBOOTSERVICES_ASSERTION_003_GUID \
{ 0x37704acb, 0x0e42, 0x46e0, {0xa3, 0xb8, 0xb4, 0x07, 0x5d, 0xaa, 0xfa, 0x60 }}

extern EFI_GUID gBrsBootServicesAssertion003Guid;

#endif /* _BRSBOOTSERVICES_GUID_H_ */
