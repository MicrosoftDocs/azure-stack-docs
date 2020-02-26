---
title: Validate software updates from Microsoft
titleSuffix: Azure Stack Hub
description: Learn how to validate software updates from Microsoft with Azure Stack Hub validation as a service.
author: mattbriggs
ms.topic: tutorial
ms.date: 10/29/2019
ms.author: mabrigg
ms.reviewer: johnhas
ms.lastreviewed: 10/29/2019
ROBOTS: NOINDEX

---

# Validate software updates from Microsoft

[!INCLUDE [Azure_Stack_Partner](./includes/azure-stack-partner-appliesto.md)]

Microsoft will periodically release updates to the Azure Stack Hub software. These updates are provided to Azure Stack Hub co-engineering partners. The updates are provided in advance of publicly available updates. You can check the updates against your solution and provide feedback to Microsoft.

Microsoft software updates to Azure Stack Hub are designated using a naming convention. For example, the name 1803 indicates the update is for March 2018. For information about the Azure Stack Hub servicing policy and release notes, see [Azure Stack Hub servicing policy](../operator/azure-stack-servicing-policy.md).

## Prerequisites

Before you exercise the monthly update process in validation as a service (VaaS), you should be familiar with the following items:

- [Validation as a service key concepts](azure-stack-vaas-key-concepts.md)

## Required tests

The following tests must be executed in the following order for monthly software validation:

- OEM Validation Workflow

## Validating software updates

1. Create a new **Package Validation** workflow.
1. For the required tests above, follow the instructions from [Run Package Validation tests](azure-stack-vaas-validate-oem-package.md#run-package-validation-tests). See the section below for additional instructions on the **Monthly Azure Stack Hub Update Verification** test.

If you have questions or concerns, contact [VaaS Help](mailto:vaashelp@microsoft.com).

## Next steps

- [Monitor and manage tests in the VaaS portal](azure-stack-vaas-monitor-test.md)