---
title: Opt-in update from Azure Local solution version 11.25xx to 12.25xx
description: Learn about the opt-in update workflow to update from Azure Local solution version 11.25xx to 12.25xx.
author: alkohli
ms.author: alkohl
ms.topic: article
ms.date: 09/15/2025
---

# Opt-in update to Azure Local solution version 12.25xx

::: moniker range=">=azloc-2508"

This article describes the opt-in update workflow for updating Azure Local systems from solution version `11.25xx` (running OS `25398.xxxx`) to solution version `12.25xx` (running OS `26100.xxxx`). For the release information for Azure Local, including the release build and OS build information, see [Azure Local release information](../release-information-23h2.md).

## About the Azure Local opt-in update

Starting with Azure Local 2508, you can opt-in to update your Azure Local systems from solution version `11.25xx` (running OS `25398.xxxx`) to solution version `12.25xx` (running OS `26100.xxxx`). This update requires enabling a feature flag, as it is not available by default. This update is supported in production and is not a preview. This early access gives customers the opportunity to try out ahead of its mandatory rollout with the Azure Local 2510 release.

## Prerequisites

- Systems with [OEM license](../oem-license.md) should wait for the Azure Local 2509 release due to a known compatibility issue with OS 26100.xxxx.

- Ensure your system is running Azure Local 2508 or later, with OS build version `25398.xxxx`. The *SolutionUpdate* version should start with **11** followed by **2508** or later.

    To ensure that the system is running Azure Local 2508 or later, run the `Get-SolutionUpdateEnvironment` cmdlet on one of the machines of your system:

    ```powershell
    PS C:\Users\lcmuser> Get-SolutionUpdateEnvironment
    CurrentVersion    : 11.2508.1001.51
    ```

- You must install driver and firmware compatible with Azure Stack HCI OS, 26100.xxxx (24H2) before proceeding with the update. Depending on your hardware vendor and model, a specific Solution Builder Extension (SBE) version might be required either before or with the 12.25xx update. Refer to the following table for minimum version requirements and installation timing:

    | Hardware Vendor | SBE Family | Minimum Version Required | Required to be installed before or after 12.xx  |
    |--|--|--|--|
    | HPE | ProLiant-Minimal | 4.2.2507.1 | Either |
    | HPE | ProLiant-Standard | 4.2.2506.14 | Either |
    | Dell | AX-14G, AX-15G, or AX-16G | 4.2.2506.xx | Before |
    | Lenovo | ThinkAgileMXPremier or ThinkAgileMXStandard | 4.1.2505.10xx | Before (this will in turn require 4.2.2508.x SBE to be installed with 12.xx)  |
    | DataON | AZS1 or AZS6000 | 4.2.2504.x | Before (this will in turn require 4.2.2507.x SBE to be installed with 12.xx) |

## Opt-in update workflow

1. Connect to a machine on your Azure Local system using a user account that is part of the local administrator group, such as the deployment user.

1. Enable the solution package update flag by running the following command:

    ```powershell
    Enable-SolutionFeature -Name "24H2Ready"
    ```

1. Discover the update by running the following command a few times until you see `12.25xx.x.x` listed:

    ```powershell
    Get-SolutionUpdate | Where-Object {$_.State -like "Ready*" -or $_.State -like "Additional*" -or $_.State -like "HasPrereq*"} | FL DisplayName, Description, ResourceId, State, PackageType, Prerequisites
    ```

    > [!NOTE]
    > If the 12.25xx update lists prerequisites, it typically indicates a specific SBE version (for example, 4.2.xx SBE) that must be installed first. The prerequisite update will also appear in the list of update options with `Ready` or `AdditionalContent` required. Follow the normal process to install the required prerequisite update, and then return to install the 12.25xx.x.x solution update.

1. Perform the update using the [Azure Local update flow](./update-via-powershell-23h2.md) making sure to select the `12.25xx.x.x` package. Begin with [Step 2: Discover the updates](./update-via-powershell-23h2.md#step-2-discover-the-updates).

1. Once the update is finished, verify the OS build number is updated to `26100` by using `Get-ComputerInfo | select OsBuildNumber`.

## Known issues

If you encounter issues with the opt-in workflow, review the [Troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Update/Manually-retry-after-failed-at-CauPostVersionCheck.md).

## Next step

Learn more about how to [Troubleshoot updates](./update-troubleshooting-23h2.md).

::: moniker-end

::: moniker range="<=azloc-2507"

This feature is available only in Azure Local 2508 or later.

::: moniker-end