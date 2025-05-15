---
title: Import and Discover Update Packages Offline for Azure Local
description: This article describes how to import and discover update packages offline for Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: arduppal
ms.date: 05/13/2025
---

# Import and discover update packages offline for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-2503-later.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

[!INCLUDE [azure-local-end-of-support-banner-23h2](../includes/azure-local-end-of-support-banner-23h2.md)]

This article explains how to discover and import update packages offline for Azure Local. Starting with version 2503, the OS update components for Azure Local are distributed as a static payload, which allows you to import the update payload and install updates offline.

## Prerequisites

- You must be running Azure Local 2411.3 or later.

- Review [About updates for Azure Local](./about-updates-23h2.md) to understand the update process.

- Review [Azure Local release information](../release-information-23h2.md).

## Step 1: Download Solution update bundle

The CombinedSolutionBundle is a zip file that contains the update package for the Azure Stack HCI OS, core agents and services, and the solution extension. Additionally, the CombinedSolutionBundle contains the SHA256 hash of the zip file. You can use this hash to verify the integrity of the downloaded zip. Follow these steps:

1. Download the appropriate CombinedSolutionBundle and make note of the associated SHA256, see [Azure Local release information summary](../release-information-23h2.md#supported-versions-of-azure-local).

   - The CombinedSolutionBundle is named `CombinedSolutionBundle.<build number>.zip`, where `<build number>` is the build number of the release.

   - The SHA256 hash is provided in the release notes. You need this to verify the integrity of the downloaded zip file.

1. Verify the SHA256 hash of the downloaded CombinedSolutionBundle.

   ```PowerShell
   # Verify the SHA256 hash of the downloaded CombinedSolutionBundle
   Get-FileHash -Path "<path to CombinedSolutionBundle.zip>"
   ```

## Step 2: Import the Solution update bundle

1. Create a folder for discovery by the update service at the following location in the infrastructure volume of your system.

   ```PowerShell
   # Create a directory for the update service to discover
   New-Item C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import -ItemType Directory
   ```

1. Copy the CombinedSolutionBundle you downloaded to the directory you created.

1. Extract the contents to the Solution subdirectory.

   ```PowerShell
   # Extract the contents of the CombinedSolutionBundle to the Solution subdirectory
   Expand-Archive -Path C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\CombinedSolutionBundle.<build number>.zip -DestinationPath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\Solution
   ```

1. Import the package to the update service.

   ```PowerShell
   # Import the module
   Add-SolutionUpdate -SourceFolder C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\Solution
   ```

1. Verify that the Update service discovers the update package and that it's available to start preparation and installation. To discover the updates, run the `Get-SolutionUpdate` command. Update discovery is done asynchronously by the update service, so you may need to run `Get-SolutionUpdate` more than once.

1. If the update is returned with a state of `AdditionalContentRequired`, follow the instructions in this article to import the required Solution Builder Extension (SBE) updates: [Update Azure Local via PowerShell](./update-via-powershell-23h2.md#step-3-import-and-rediscover-updates).

## Next steps

- Learn more about [Understanding update phases](./update-phases-23h2.md).

- Review [Troubleshooting updates](./update-troubleshooting-23h2.md).