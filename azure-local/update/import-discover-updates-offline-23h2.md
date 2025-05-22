---
title: Import and Discover Update Packages For Azure Local With Limited Connectivity
description: This article describes how to import and discover update packages for Azure Local with limited connectivity.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: arduppal
ms.date: 05/16/2025
---

# Import and discover update packages with limited connectivity

::: moniker range=">=azloc-24113"

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

[!INCLUDE [azure-local-end-of-support-banner-23h2](../includes/azure-local-end-of-support-banner-23h2.md)]

This article explains how to discover and import update packages for Azure Local with limited connectivity. Starting with version 2503, the OS update components for Azure Local are distributed as a static payload, so you can import the update payload and install updates with limited connectivity to Azure.

<!--To install updates online via PowerShell, see [Update Azure Local via PowerShell](./update-via-powershell-23h2.md).-->

## Prerequisites

- Make sure you're running Azure Local 2411.3 or later to use this feature.

- Review [About updates for Azure Local](./about-updates-23h2.md) to understand the update process.

- Review [Azure Local release information](../release-information-23h2.md).

## Step 1: Download Solution update bundle

The **CombinedSolutionBundle** is a zip file that contains the update package for the Azure Stack HCI OS, core agents and services, and the solution extension. The associated SHA256 hash helps verify the integrity of the downloaded zip.

| Download URI | SHA256                          |
|--------------|---------------------------------|
| 11.0.2411.3 | |
| 11.0.2411.4 | |
| 11.0.2411.5 | |

Follow these steps:

1. To download the bundle and note the SHA256 hash, see the **Download URI** column in [Azure Local release information summary](../release-information-23h2.md#supported-versions-of-azure-local).

   - The **CombinedSolutionBundle** is named `CombinedSolutionBundle.<build number>.zip`, where `<build number>` is the build number for the release.

   - The SHA256 hash is also in the release notes. Use the hash to check the integrity of your download.

1. Verify the SHA256 hash of the downloaded **CombinedSolutionBundle**.

   ```PowerShell
   # Verify the SHA256 hash of the downloaded CombinedSolutionBundle
   Get-FileHash -Path "<path to CombinedSolutionBundle.zip>"
   ```

## Step 2: Import the Solution update bundle

1. Create a folder for the update service to discover at the following location in the infrastructure volume of your system.

   ```PowerShell
   # Create a folder for the update service to discover
   New-Item C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import -ItemType Directory
   ```

1. Copy the CombinedSolutionBundle you downloaded to the folder you created.

1. Extract the contents to the Solution subfolder.

   ```PowerShell
   # Extract the contents of the CombinedSolutionBundle to the Solution subfolder
   Expand-Archive -Path C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\CombinedSolutionBundle.<build number>.zip -DestinationPath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\Solution
   ```

1. Import the package to the update service.

   ```PowerShell
   # Import the module
   Add-SolutionUpdate -SourceFolder C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\Solution
   ```

1. Verify that the Update service discovers the update package and that it's available to start preparation and installation. To discover the updates, run the `Get-SolutionUpdate` command. The update service discovers updates asynchronously, so you may need to run `Get-SolutionUpdate` more than once.

1. If the update returns a state of `AdditionalContentRequired`, follow the instructions in [Update Azure Local via PowerShell](./update-via-powershell-23h2.md#step-3-import-and-rediscover-updates) to import the required Solution Builder Extension (SBE) updates.

## Next steps

- Learn more about [Understanding update phases](./update-phases-23h2.md).

- Review [Troubleshooting updates](./update-troubleshooting-23h2.md).

::: moniker-end

::: moniker range="<=azloc-24112"

This feature is available in Azure Local 2411.3 and later.

::: moniker-end
