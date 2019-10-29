---
title: Validate software updates from Microsoft in Azure Stack Validation as a Service | Microsoft Docs
description: Learn how to validate software updates from Microsoft with Validation as a Service.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: tutorial
ms.date: 07/23/2019
ms.author: mabrigg
ms.reviewer: johnhas
ms.lastreviewed: 03/11/2019



ROBOTS: NOINDEX

---

# Validate software updates from Microsoft

[!INCLUDE [Azure_Stack_Partner](./includes/azure-stack-partner-appliesto.md)]

Microsoft will periodically release updates to the Azure Stack software. These updates are provided to Azure Stack coengineering partners. The updates are provided in advance of publicly available. You can check the updates against your solution and provide feedback to Microsoft.

Microsoft software updates to Azure Stack are designated using a naming convention, for example, 1803 indicating the update is for March 2018. For information about the Azure Stack update policy, cadence and release notes are available, see [Azure Stack servicing policy](../operator/azure-stack-servicing-policy.md).

## Prerequisites

Before you exercise the monthly update process in VaaS, you should be familiar with the following items:

- [Validation as a Service key concepts](azure-stack-vaas-key-concepts.md)
- [Interactive feature verification testing](azure-stack-vaas-interactive-feature-verification.md)

## Required tests

The following tests should be executed in the following order for monthly software validation:

- Step 1 - Monthly AzureStack Update Verification
- Step 2 - OEM Extension Package Verification
- Step 3 - OEM - Cloud Simulation Engine

## Validating software updates

1. Create a new **Package Validation** workflow.
1. For the required tests above, follow the instructions from [Run Package Validation tests](azure-stack-vaas-validate-oem-package.md#run-package-validation-tests). See the section below for additional instructions on the **Monthly Azure Stack Update Verification** test.

If you have questions or concerns, contact [VaaS Help](mailto:vaashelp@microsoft.com).

## Next steps

- [Monitor and manage tests in the VaaS portal](azure-stack-vaas-monitor-test.md)