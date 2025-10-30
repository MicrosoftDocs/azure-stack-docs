---
title: Import and Discover Update Packages For Azure Local With Limited Connectivity
description: This article describes how to import and discover update packages for Azure Local with limited connectivity.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: arduppal
ms.date: 10/30/2025
---

# Import and discover update packages with limited connectivity

::: moniker range=">=azloc-24113"

[!INCLUDE [azure-local-banner-23h2](../includes/azure-local-banner-23h2.md)]

This article explains how to discover and import solution update packages for Azure Local deployed in sites with limited bandwidth connections to Azure. Starting with version 2503, you can download Azure Local solution updates as static payloads. Download the payload once, copy or transfer it to multiple instances, and import it using PowerShell. Do these actions before you start an update to reduce the amount of data downloaded during the update.

The static payload for a solution update includes the OS security update, extensions, and core agents, which install during the update process. The update process automatically downloads updated container images required for the Azure Resource Bridge component and Azure Kubernetes Service on Azure Local. These images aren't included in the static payload.

## Prerequisites

- Make sure you run Azure Local 2411.3 or later to use this feature.

- Review [About updates for Azure Local](./about-updates-23h2.md) to learn more about the update process.

- Review [Azure Local release information](../release-information-23h2.md) to check which paths are supported.

## Solution update bundle

The **CombinedSolutionBundle** is a zip file that contains the update package for the Azure Stack HCI OS, core agents and services, and the solution extension. The **CombinedSolutionBundle** is named `CombinedSolutionBundle.<build number>.zip`, where `<build number>` is the build number for the release. Use the SHA256 hash to check the integrity of your download.

The following tables list the **CombinedSolutionBundle** versions and associated SHA256 hashes for existing deployments of Azure Local.

- For 25398.xxxx builds, use the **CombinedSolutionBundle** to update the OS and solution components for Azure Local.
- For 26100.xxxx builds, use the **CombinedSolutionBundle** to install a specific Azure Local version.

For more information on the release cadence, see [Azure Local release information](../release-information-23h2.md).

### [OS build 25398.xxxx](#tab/OS-build-25398-xxxx)

| OS Build | Download URI | SHA256 |
|--|--|--|
| 25398.1849 | [11.2509.1001.21](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2509.1001.21/CombinedSolutionBundle.11.2509.1001.21.zip) <br><br> Availability date: <br><br> 2025-09-22  | D78D0B687E1AB9BE3C7EC0568CFEF2D346CDD421AB00DFE2A484060F0BAE52BF |
| 25398.1791 | [11.2508.1001.51](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2508.1001.51/CombinedSolutionBundle.11.2508.1001.51.zip) <br><br> Availability date: <br><br> 2025-08-29  | DF8578E95D2A0ACBA91AA08266723D44E2B5EE43CDBC26CA8890700F3B6B1158 |
| 25398.1732 | [11.2507.1001.9](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2507.1001.9/CombinedSolutionBundle.11.2507.1001.9.zip) <br><br> Availability date: <br><br> 2025-07-25 | 42AD44EEBD8E063A0FD5A7A41588ABF8F847A661B747ADD050C58CF4B75A6B7E |
| 25398.1665 | [11.2506.1001.28](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2506.1001.28/CombinedSolutionBundle.11.2506.1001.28.zip) <br><br> Availability date: <br><br> 2025-07-02 | 18975A06372192DD7249B5DCF8844EA0A68AD08B1C9F3C554FABF79EA74CB290 |
| 25398.1611 | [11.2505.1001.22](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2505.1001.22/CombinedSolutionBundle.11.2505.1001.22.zip) <br><br> Availability date: <br><br> 2025-05-28 | AB2C7CE74168BF9FD679E7CE644BC57A20A0A3A418C5E8663EBCF53FC0B45113 |
| 25398.1551 | [11.2504.1001.19](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2504.1001.19/CombinedSolutionBundle.11.2504.1001.19.zip) <br><br> Availability date: <br><br> 2025-04-21 | 7658C5CBAE241951C786D06D35E8B09A1160FDC5E9B8CAEDEB374ECC22A2CB68 |
| 25398.1486 | [10.2503.0.13](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/10.2503.0.13/CombinedSolutionBundle.10.2503.0.13.zip) <br><br> Availability date: <br><br> 2025-03-31 | BAA0CEB0CF695CCCF36E39F70BF2E67E0B886B91CDE97F8C2860CE299E2A5126 |

### [OS build 26100.xxxx](#tab/OS-build-26100-xxxx)

| OS Build | Download URI | SHA256 |
|--|--|--|
| 26100.6899 | [12.2510.1002.88](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/12.2510.1002.88/CombinedSolutionBundle.12.2510.1002.88.zip) <br><br> Availability date: <br><br> 2025-10-24  | 5A13A5D01B5B32466883C83C89186B0FED937CAB53E7DF76D46E6275721952D2 |
| 26100.6584 | [12.2509.1001.22](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/12.2509.1001.22/CombinedSolutionBundle.12.2509.1001.22.zip) <br><br> Availability date: <br><br> 2025-09-22  | 15771552A97785B7EE291587FE62EE678EDE850E2250A5407EE6738AFEF729B65B |
| 26100.4946 | [12.2508.1001.52](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/12.2508.1001.52/CombinedSolutionBundle.12.2508.1001.52.zip) <br><br> Availability date: <br><br> 2025-08-29  | 410723EAD2177247932B10AD79978F2E4D8049FBFF70E8F9F94943384B59BB80 |
| 26100.4652 | [12.2507.1001.10](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/12.2507.1001.10/CombinedSolutionBundle.12.2507.1001.10.zip) <br><br> Availability date: <br><br> 2025-07-25 | 8FAC8A7F52C570682407573F7AAAB79BDBA62299C9F50C3497FD0A10FBF73105 |
| 26100.4349 | [12.2506.1001.29](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/12.2506.1001.29/CombinedSolutionBundle.12.2506.1001.29.zip) <br><br> Availability date: <br><br> 2025-07-02 | C8227DF98F97FDE807A2B711206A1FE23531340DC717F89CDA7A324BA0B316C7 |
| 26100.4061 | [12.2505.1001.23](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/12.2505.1001.23/CombinedSolutionBundle.12.2505.1001.23.zip) <br><br> Availability date: <br><br> 2025-05-28 | 29E5F6732D9B1BD4E0C2667F6FB1D7F43ADF78B4AEA8E34486C7F03DD46D155C |

---

> [!NOTE]
> You might need to wait up to 24 hours after the release for the latest version of the CombinedSolutionBundle and its SHA256 hash to be available.

## Step 1: Download Solution update bundle

1. Download the bundle and note the SHA256 hash from the [Solution update bundle](#solution-update-bundle) table. Run this command:

   ```PowerShell
   # Download the CombinedSolutionBundle
   Invoke-WebRequest -Uri "<download URI>" -OutFile "C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\CombinedSolutionBundle.<build number>.zip"
   ```

1. Check the SHA256 hash of the downloaded **CombinedSolutionBundle**. Run this command:

   ```PowerShell
   # Check the SHA256 hash of the downloaded CombinedSolutionBundle
   Get-FileHash -Path "<path to CombinedSolutionBundle.zip>"
   ```

## Step 2: Import the Solution update bundle

1. Create a folder for the update service to discover in the infrastructure volume of your system. Run this command:

   ```PowerShell
   # Create a folder for the update service to discover
   New-Item C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import -ItemType Directory
   ```

1. Copy the CombinedSolutionBundle you downloaded to the folder you created.

1. Extract the contents of the CombinedSolutionBundle to the Solution subfolder. Run this command:

   ```PowerShell
   # Extract the contents of the CombinedSolutionBundle to the Solution subfolder
   Expand-Archive -Path C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\CombinedSolutionBundle.<build number>.zip -DestinationPath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\Solution
   ```

1. Import the package into the update service. Run this command:

   ```PowerShell
   # Import the module
   Add-SolutionUpdate -SourceFolder C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\Solution
   ```

1. Check that the update service discovers the update package and that it's available to start preparation and installation. To discover the updates, run the `Get-SolutionUpdate` command. The update service discovers updates asynchronously, so you might need to run the `Get-SolutionUpdate` command more than once.

1. If the update returns a state of `AdditionalContentRequired`, follow the instructions in [Update Azure Local via PowerShell](./update-via-powershell-23h2.md#step-3-import-and-rediscover-updates) to import the required Solution Builder Extension (SBE) updates. If it doesn't, continue to the next step.

1. Start the update. For more information, see [Update Azure Local via PowerShell](./update-via-powershell-23h2.md#step-5-start-the-update).

## Next steps

- Learn more about [Understanding update phases](./update-phases-23h2.md)

- Review [Troubleshooting updates](./update-troubleshooting-23h2.md)

::: moniker-end

::: moniker range="<=azloc-24112"

This feature is available in Azure Local 2411.3 and later.

::: moniker-end
