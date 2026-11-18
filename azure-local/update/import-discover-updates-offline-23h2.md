---
title: Import and Discover Update Packages For Azure Local With Limited Connectivity
description: This article describes how to import and discover update packages for Azure Local with limited connectivity.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: arduppal
ms.date: 11/16/2026
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Import and discover update packages with limited connectivity

::: moniker range=">=azloc-24113"

This article explains how to discover and import solution update packages for Azure Local deployed in sites with limited bandwidth connections to Azure. You can download the Azure Local solution update as a static payload by using the Azure portal or PowerShell. Then, copy or transfer it to multiple instances and import it by using PowerShell. To reduce the amount of data downloaded during the update, complete these steps before you start an update.

> [!NOTE]
> The limited-connectivity update workflow in this article doesn't apply to Azure Local disconnected operations. To update an Azure Local instance running on disconnected operations, follow [Update an Azure Local instance running on disconnected operations](../manage/disconnected-operations-update-azure-local-instance.md).

The static payload for a solution update includes the OS security update, extensions, and core agents, which install during the update process. The update process automatically downloads updated container images required for the Azure Arc resource bridge component and Azure Kubernetes Service on Azure Local. These images aren't included in the static payload.

## Prerequisites

- Make sure you run Azure Local 2411.3 or later to use this feature.

- Review [About updates for Azure Local](./about-updates-23h2.md) to learn more about the update process.

- Review [Azure Local release information](../release-information-23h2.md) to check which paths are supported.

## Solution update bundle

The **CombinedSolutionBundle** is a zip file that contains the update package for the Azure Stack HCI OS, core agents and services, and the solution extension. The **CombinedSolutionBundle** is named `CombinedSolutionBundle.<build number>.zip`, where `<build number>` is the build number for the release. Use the SHA256 hash to check the integrity of your download.

::: moniker-end

::: moniker range=">=azloc-2610"

The following table lists the **CombinedSolutionBundle** versions and associated SHA256 hashes for existing deployments of Azure Local. For 26100.xxxx builds, use the **CombinedSolutionBundle** to install a specific Azure Local version.

For more information about the release cadence, see [Azure Local release information](../release-information-23h2.md).

### OS build 26100.xxxx

[!INCLUDE [solution-update-bundles-2610-later](../includes/azure-local-solution-update-bundles-2610-later.md)]

::: moniker-end

::: moniker range=">=azloc-24113 <azloc-2610"

The following tables list the **CombinedSolutionBundle** versions and associated SHA256 hashes for existing deployments of Azure Local.

- For 25398.xxxx builds, use the **CombinedSolutionBundle** to update the OS and solution components for Azure Local.
- For 26100.xxxx builds, use the **CombinedSolutionBundle** to install a specific Azure Local version.

For more information on the release cadence, see [Azure Local release information](../release-information-23h2.md).

### [OS build 26100.xxxx](#tab/OS-build-26100-xxxx)

[!INCLUDE [solution-update-bundles-2610-later](../includes/azure-local-solution-update-bundles-2610-later.md)]

### [OS build 25398.xxxx](#tab/OS-build-25398-xxxx)

| OS Build | Download URI | Notes / SHA256 |
| -- | -- | -- |
| 25398.1913 | [11.2510.1002.93](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2510.1002.93/CombinedSolutionBundle.11.2510.1002.93.zip) <br><br> Availability date: 2025-11-05 | E1B0B205A90A93827E14643927767DD2675710844FCA56EE3DF2C8FFD60622F9 |
| 25398.1849 | [11.2509.1001.21](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2509.1001.21/CombinedSolutionBundle.11.2509.1001.21.zip) <br><br> Availability date: 2025-09-22 | D78D0B687E1AB9BE3C7EC0568CFEF2D346CDD421AB00DFE2A484060F0BAE52BF |
| 25398.1791 | [11.2508.1001.51](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2508.1001.51/CombinedSolutionBundle.11.2508.1001.51.zip) <br><br> Availability date: 2025-08-29 | DF8578E95D2A0ACBA91AA08266723D44E2B5EE43CDBC26CA8890700F3B6B1158 |
| 25398.1732 | [11.2507.1001.9](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2507.1001.9/CombinedSolutionBundle.11.2507.1001.9.zip) <br><br> Availability date: 2025-07-25 | 42AD44EEBD8E063A0FD5A7A41588ABF8F847A661B747ADD050C58CF4B75A6B7E |
| 25398.1665 | [11.2506.1001.28](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2506.1001.28/CombinedSolutionBundle.11.2506.1001.28.zip) <br><br> Availability date: 2025-07-02 | 18975A06372192DD7249B5DCF8844EA0A68AD08B1C9F3C554FABF79EA74CB290 |
| 25398.1611 | [11.2505.1001.22](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2505.1001.22/CombinedSolutionBundle.11.2505.1001.22.zip) <br><br> Availability date: 2025-05-28 | AB2C7CE74168BF9FD679E7CE644BC57A20A0A3A418C5E8663EBCF53FC0B45113 |
| 25398.1551 | [11.2504.1001.21](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/11.2504.1001.21/CombinedSolutionBundle.11.2504.1001.21.zip) <br><br> Availability date: 2026-01-22 | 55FC9EC3018D6A58D88438EED18A12DDED1409B46D50F462943FB2FC2FCED56F |
| 25398.1486 | [10.2503.0.13](https://azurestackreleases.download.prss.microsoft.com/dbazure/AzureLocal/CombinedSolutionBundle/10.2503.0.13/CombinedSolutionBundle.10.2503.0.13.zip) <br><br> Availability date: 2025-03-31 | BAA0CEB0CF695CCCF36E39F70BF2E67E0B886B91CDE97F8C2860CE299E2A5126 |

---

::: moniker-end

::: moniker range=">=azloc-24113"

> [!NOTE]
> You might need to wait up to 24 hours after the release for the latest version of the CombinedSolutionBundle and its SHA256 hash to be available.

## Download solution update bundle (Azure portal)

Follow these steps to download the solution update bundle directly from the Azure portal.

1. Sign in to the [Azure portal](https://portal.azure.com/) with your Azure account credentials.

1. In the Azure portal search bar at the top, enter **Azure Local**. As you type, the portal suggests related resources and services. Select **Azure Local** under the **Services** category.

   :::image type="content" source="./media/import-discover-updates-offline-23h2/search-azure-local.png" alt-text="Screenshot that shows how to search for Azure Local in the Azure portal." lightbox="./media/import-discover-updates-offline-23h2/search-azure-local.png":::

   After you select **Azure Local**, you're directed to the Azure Local **Get started** page, with the **Get started** tab selected by default.

1. On the **Get started** tab, under the **Download software** tile, select **Download**, and then select **Download Azure Local update**.

   :::image type="content" source="./media/import-discover-updates-offline-23h2/download-azure-local-update.png" alt-text="Screenshot that shows the Download Azure Local update option under the Download software tile." lightbox="./media/import-discover-updates-offline-23h2/download-azure-local-update.png":::

1. On the **Azure Local package** page, select your current solution version.

   :::image type="content" source="./media/import-discover-updates-offline-23h2/select-solution-version.png" alt-text="Screenshot that shows the Azure Local package page with the option to select a solution version." lightbox="./media/import-discover-updates-offline-23h2/select-solution-version.png":::

1. Select an eligible update, and then select **Download package**.

1. Accept the notice, and then select **Download package**.

## Download solution update bundle (PowerShell)

Download the bundle from the [Solution update bundle](#solution-update-bundle) table. Run this command:

   ```PowerShell
   # Download the CombinedSolutionBundle
   Invoke-WebRequest -Uri "<download URI>" -OutFile "C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import\CombinedSolutionBundle.<build number>.zip"
   ```

## Import the solution update bundle

> [!NOTE]
> Complete these steps regardless of whether you downloaded the **CombinedSolutionBundle** by using the Azure portal or PowerShell.

1. Note the SHA256 hash from the [Solution update bundle](#solution-update-bundle) table and check the SHA256 hash of the downloaded **CombinedSolutionBundle**. Run this command:

   ```PowerShell
   # Check the SHA256 hash of the downloaded CombinedSolutionBundle
   Get-FileHash -Path "<path to CombinedSolutionBundle.zip>"
   ```

1. Create a folder for the update service to discover in the infrastructure volume of your system. Run this command:

   ```PowerShell
   # Create a folder for the update service to discover
   New-Item C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\import -ItemType Directory
   ```

1. Copy the **CombinedSolutionBundle** you downloaded to the folder you created.

1. Extract the contents of the **CombinedSolutionBundle** to the **Solution** subfolder. Run this command:

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

- Learn more about [Understanding update phases](./update-phases-23h2.md).

- Review [Troubleshooting updates](./update-troubleshooting-23h2.md).

::: moniker-end

::: moniker range="<=azloc-24112"

This feature is available in Azure Local 2411.3 and later.

::: moniker-end