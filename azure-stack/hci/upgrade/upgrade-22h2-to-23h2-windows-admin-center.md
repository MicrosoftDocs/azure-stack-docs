---
title: Upgrade Azure Stack HCI, version 22H2 OS to version 23H2 via Windows Admin Center
description: Learn how to upgrade from Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 using Windows Admin Center.
author: alkohli
ms.topic: how-to
ms.date: 08/12/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Upgrade Azure Stack HCI, version 22H2 operating system to Azure Stack HCI, version 23H2 via Windows Admin Center

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to upgrade the Azure Stack HCI, version 22H2 Operating System (OS) to version 23H2, which is the latest generally available software via the Windows Admin Center.

While the recommended method to [Upgrade the OS is via PowerShell](./upgrade-22h2-to-23h2-powershell.md), you can also upgrade via the Windows Admin Center or other methods.


> [!IMPORTANT]
> To keep your Azure Stack HCI service in a supported state, you have up to six months to install this new OS version. The update is applicable to all the Azure Stack HCI, version 22H2 clusters. We strongly recommend that you install this version as soon as it becomes available.

## High-level workflow for the OS upgrade

The Azure Stack HCI operating system update is available via the Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your cluster, follow these high-level steps:

1. [Complete the prerequisites](#complete-prerequisites).
1. [Connect to the Azure Stack HCI, version 22H2 cluster](#step-1-connect-to-azure-stack-hci-cluster-via-windows-admin-center).
1. Check for the available updates using Windows Admin Center.
1. Install hardware and new OS using Windows Admin Center.
1. Install feature and quality updates using Windows Admin Center.
1. Perform post-upgrade steps, after the OS is upgraded.

## Complete prerequisites

Before you begin, make sure that:

- You have access to an Azure Stack HCI, version 22H2 cluster.
- The cluster should be registered in Azure.
- Make sure that all the nodes in your Azure Stack HCI, version 22H2 cluster are healthy and show as **Online**.
- You have access to the Azure Stack HCI, version 23H2 OS software update. This update is available via Windows Update or as a downloadable media. The media is an ISO file that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- You have access to a client that can connect to your Azure Stack HCI cluster. This client should have Windows Admin Center installed on it. For more information, see [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).

## Step 1: Connect to Azure Stack HCI cluster via Windows Admin Center

Follow these steps to add and connect to an Azure Stack HCI server via Windows Admin Center.

1. Select **+ Add** under **All Connections**.
1. Choose to **Add Servers**.
1. Type the name of the server and, if prompted, the credentials to use.
1. Select **Add** to finish.
1. The server is added to your connection list on the **Overview** page. Select the server to connect to it.

## Step 2: Install operating system and hardware updates using Windows Admin Center

Windows Admin Center makes it easy to update a cluster and apply quality updates using a simple user interface. If you've purchased an integrated system from a Microsoft hardware partner, it's easy to get the latest drivers, firmware, and other updates directly from Windows Admin Center by installing the appropriate partner update extension(s). ​If your hardware wasn't purchased as an integrated system, firmware and driver updates would need to be performed separately, following the hardware vendor's recommendations.

   > [!WARNING]
   > If you begin the update process using Windows Admin Center, continue using the wizard until updates complete. Do not attempt to use the Cluster-Aware Updating tool or update a cluster with PowerShell after partially completing the update process in Windows Admin Center. If you wish to use PowerShell to perform the updates instead of Windows Admin Center, see [Update a cluster using PowerShell](./upgrade-22h2-to-23h2-powershell.md).

Follow these steps to install updates:

1. When you connect to a cluster, the Windows Admin Center dashboard alerts you if one or more servers have updates ready to be installed and provide a link to update now. Alternatively, select **Updates** from the **Tools** menu at the left.

1. If you're updating your cluster for the first time, Windows Admin Center checks if the cluster is properly configured to run Cluster-Aware Updating and, if needed, ask if you'd like Windows Admin Center to configure CAU for you, including installing the CAU cluster role and enabling the required firewall rules. To begin the update process, select **Get Started**.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/add-cau-role.png" alt-text="Windows Admin Center will automatically configure the cluster to run Cluster-Aware Updating" lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/add-cau-role.png":::

   > [!NOTE]
   > To use the Cluster-Aware updating tool in Windows Admin Center, you must enable Credential Security Service Provider (CredSSP) and provide explicit credentials. If you are asked if CredSSP should be enabled, select **Yes**. Specify your username and password, and select **Continue**.

1. The cluster's update status is displayed. Select **Check for updates** to get a list of the operating system updates available for each server in the cluster. You might need to supply administrator credentials. If no operating system updates are available, select **Next: hardware updates** and proceed to step 8.


   If you navigate away from the Updates screen while an update is in progress, there could be unexpected behavior, such as the history section of the Updates page not populating correctly until the current run is finished. We recommend opening Windows Admin Center in a new browser tab or window if you wish to continue using the application while the updates are in progress.

1. Select **Next: Install** to proceed to install the operating system updates, or select **Skip** to exclude them.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/operating-system-updates.png" alt-text="Select Next: Install to proceed to installing operating system updates, or select Skip to exclude them" lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/operating-system-updates.png":::

   > [!NOTE]
   > If you're installing updates on a cluster that has [Kernel Soft Reboot](../manage/kernel-soft-reboot.md) enabled, select **Disable Kernel Soft Reboot for this run** checkbox. This selection disables Kernel Soft Reboot as the upgrade requires a full reboot.

1. Select **Install** to install the operating system updates. One by one, each server downloads and applies the updates. The update status changes to **Installing updates**. If the updates require a restart, servers are restarted one at a time, moving cluster roles such as virtual machines between servers to prevent downtime. Depending on the updates being installed, the entire update run can take anywhere from a few minutes to several hours. You would need to sign into the Windows Admin Center multiple times.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/install-os-updates.png" alt-text="select Install to install operating system updates on each server in the cluster" lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/install-os-updates.png":::

   > [!NOTE]
   > If the updates fail with a **Couldn't install updates** or **Couldn't check for updates** warning or if one or more servers indicate **couldn't get status** during the run, wait a few minutes, and refresh your browser. You can also use `Get-CauRun` to [check the status of the update run with PowerShell](./upgrade-22h2-to-23h2-powershell.md#step-3-check-the-status-of-an-update).

1. When operating system updates are complete, the update status changes to **Succeeded**. Select **Next: hardware updates** to proceed to the hardware updates screen.

   > [!IMPORTANT]
   > After applying operating system updates, you may see a message that "storage isn't complete or up-to-date, so we need to sync it with data from other servers in the cluster." This is normal after a server restarts. **Don't remove any drives or restart any servers in the cluster until you see a confirmation that the sync is complete.**

1. If the cluster isn't connected to Windows Update and the Azure Stack HCI install media is available on a local share, CAU can also be used to upgrade the cluster:

   When the cluster nodes aren't connected to Windows Update after installing the latest quality updates and the setup media is copied to a share that is accessible to the cluster nodes:

   ```powershell
   Invoke-CauRun –ClusterName <cluster_name> -CauPluginName Microsoft.RollingUpgradePlugin -CauPluginArguments @{ 'WuConnected'='false';'PathToSetupMedia'='\some\path\'; 'UpdateClusterFunctionalLevel'='true'; } -Force
   ```

1. Windows Admin Center checks the cluster for installed extensions that support your specific server hardware. Select **Next: install** to install the hardware updates on each server in the cluster. If no extensions or updates are found, select **Exit**.

1. As per security best practices, disable CredSSP as soon as you're finished installing the updates:
    - In Windows Admin Center, under **All connections**, select the first server in your cluster and then select **Connect**.
    - On the **Overview** page, select **Disable CredSSP**, and then, on the **Disable CredSSP** pop-up window, select **Yes**.

You're now ready to perform the post-upgrade steps for your cluster.

## Next steps

- [Learn how to perform the post-upgrade steps for your Azure Stack HCI cluster.](./post-upgrade-steps.md)