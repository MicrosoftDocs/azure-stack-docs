---
title: Discover and import update packages offline for Azure Local
description: This article describes how to discover and import update packages offline for Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: arduppal
ms.date: 05/13/2025
---

# Discover and import update packages offline for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

[!INCLUDE [azure-local-end-of-support-banner-23h2](../includes/azure-local-end-of-support-banner-23h2.md)]

This article explains how to discover and import update packages offline for Azure Local. Starting with version 2503, the OS update components for Azure Local are distributed as a static payload. This lets you import the update payload and install updates offline.

## Prerequisites

- You must be running Azure Stack HCI OS version 2503 or later.
- Review [About updates for Azure Local](./about-updates-23h2.md) to understand the update process.
- Review [Azure Local release information](../release-information-23h2.md).

## Step 1: Download Solution update bundle

The following table lists the CombinedSolutionBundle available for Azure Local starting with 2503. The CombinedSolutionBundle contains the update package for the Azure Stack HCI OS, core agents and services, and the solution extension.

Additionally, the CombinedSolutionBundle contains the SHA256 hash of the zip file. You can use this hash to verify the integrity of the downloaded zip.

| OS version | Download | SHA256 |
|------------|----------|--------|
| 2503       | [10.2503.0.13](/dbazure/AzureLocal/CombinedSolutionBundle/10.2503.0.13/CombinedSolutionBundle.10.2503.0.13.zip) | BAA0CEB0CF695CCCF36E39F70BF2E67E0B886B91CDE97F8C2860CE299E2A5126 |
| 2504       | [11.2504.1001.19](/dbazure/AzureLocal/CombinedSolutionBundle/11.2504.1001.19/CombinedSolutionBundle.11.2504.1001.19.zip) | 3A2E5D7F1B8C9F6A2D7E5B8C9F6A2D7E5B8C9F6A2D7E5B8C9F6A2D7E5B8C9F6 |

1. Download the appropriate CombinedSolutionBundle from the link in the table.

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

1. Copy the CombinedSolutionBundle you downloaded to the directory created above.

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

1. Verify that the Update service discovers the update package and that it's available to start preparation and installation. Run the `Get-SolutionUpdate` command to discover the updates. Update discovery is done asynchronously by the update service, so you may need to run `Get-SolutionUpdate` more than once.

1. If the update is returned with a state of `AdditionalContentRequired`, follow the instructions in this article to import the required Solution Builder Extension (SBE) updates: [Update Azure Local, version 23H2 systems via PowerShell - Azure Local](./update-via-powershell-23h2.md#step-3-import-and-rediscover-updates).

## Next steps