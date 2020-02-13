---
title: Validation as a service overview
titleSuffix: Azure Stack Hub 
description: An overview of Azure Stack Hub validation as a service.
author: mattbriggs
ms.topic: article
ms.date: 11/11/2019
ms.author: mabrigg
ms.reviewer: johnhas
ms.lastreviewed: 11/11/2019
ROBOTS: NOINDEX
---

# Validation as a service for Azure Stack Hub

[!INCLUDE [Azure_Stack_Partner](./includes/azure-stack-partner-appliesto.md)]

Validation as a service (VaaS) is a native Azure service designed for solution partners who are co-engineering Azure Stack Hub offerings with Microsoft. Solution partners can use the service to check that their solutions meet Microsoft's requirements and work as expected with Azure Stack Hub.

The primary uses for VaaS are:

- Validating new Azure Stack Hub solutions.
- Validating changes to the Azure Stack Hub software.
- Digitally signing solution partner packages used during deployment.
- Previewing VaaS test collateral.

## Validate a new Azure Stack Hub solution

Partners use the **Solution Validation** workflow to validate new Azure Stack Hub solutions. The solution must pass the required Hardware Lab Kit (HLK) Azure Stack Hub component tests. To certify a range of hardware configurations, the workflow must be run twice for each new solution: once each for the minimum and maximum configurations.

For more information, see [Validate a new Azure Stack Hub solution](azure-stack-vaas-validate-solution-new.md).

## Validate changes to the Azure Stack Hub software

Partners use the **Package Validation** workflow to check that their solution works with the most recent Azure Stack Hub software updates. The Package Validation workflow must be run on a Microsoft-recommended hardware environment where patch and update (P&U) was used to apply the update. It is recommended to also run the workflow on the baseline build.

For more information, see [Validate software updates from Microsoft](azure-stack-vaas-validate-microsoft-updates.md).

## Get digitally signed solution partner packages

In addition to validating Azure Stack Hub updates, partners use the **Package Validation** workflow to validate updates to OEM customization packages, which include Azure Stack Hub partner-specific drivers, firmware, and other software used during deployment of the Azure Stack Hub software. Deploy the package you are validating on the current version of the Azure Stack Hub software using at least the minimum-sized solution that will be supported. The package is submitted to VaaS before executing tests. If the tests succeed, notify [vaashelp@microsoft.com](mailto:vaashelp@microsoft.com) that the package has completed testing and should be digitally signed with the Azure Stack Hub digital signature. Microsoft signs the package and notifies the Azure Stack Hub partner that the package is available for download in the VaaS portal.

For more information, see [Validate OEM packages](azure-stack-vaas-validate-oem-package.md).

## Preview VaaS test collateral

Microsoft regularly makes new features available in Azure Stack Hub. As part of the development process for delivering these features to market, new test collateral is made available in the **Test Pass** workflow. The Test Pass workflow includes test collateral from the other workflows to allow for unofficial test execution. Do not use the Test Pass workflow to submit results for approval. Use the Solution Validation and Package Validation workflows to get official approval for your solution.

For more information, see [Quickstart: Use the Validation as a Service portal to schedule your first test](azure-stack-vaas-schedule-test-pass.md).

## Validation workflow tests summary

| Validation workflow | Required tests |
|----|------------|
| [New solution validation](azure-stack-vaas-validate-solution-new.md) | Cloud Simulation Engine<br>Compute SDK Operational Suite<br>Disk Identification Test<br>KeyVault Extension SDK Operational Suite<br>KeyVault SDK Operational Suite<br>Network SDK Operational Suite<br>Storage Account SDK Operational Suite<br> |
| [OEM package validation](azure-stack-vaas-validate-oem-package.md) | OEM Extension Package Verification<br>Cloud Simulation Engine |
| [Monthly update validation](azure-stack-vaas-validate-microsoft-updates.md) | Monthly Azure Stack Hub Update Verification<br>Cloud Simulation Engine<br> |

## Next steps

- [Set up your Validation as a Service resources](azure-stack-vaas-set-up-resources.md)
- Learn about [Validation as a Service key concepts](azure-stack-vaas-key-concepts.md)
