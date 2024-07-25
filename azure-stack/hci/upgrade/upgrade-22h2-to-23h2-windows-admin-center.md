---
title: Upgrade Azure Stack HCI, version 22H2 OS to version 23H2 via Windows Admin Center
description: Learn how to upgrade from Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 using Windows Admin Center.
author: alkohli
ms.topic: how-to
ms.date: 07/25/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Upgrade Azure Stack HCI, version 22H2 operating system to Azure Stack HCI, version 23H2 via Windows Admin Center

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to upgrade the Azure Stack HCI, version 22H2 Operating System (OS) to version 23H2 which is the latest generally available software.

The upgrade from Azure Stack HCI 22H2 to version 23H2 occurs in the following steps:

1. Upgrade the OS.
1. Prepare for the solution update.
1. Apply the solution update.

This article only covers the first step, which is how to upgrade the Azure Stack HCI OS using the Windows Admin Center. While the recommended method to [Upgrade the OS is via PowerShell](./upgrade-22h2-to-23h2-powershell.md), you can also upgrade via the Windowds Admin Center or other methods.


> [!IMPORTANT]
> To keep your Azure Stack HCI service in a supported state, you have up to six months to install this new OS version. The update is applicable to all the Azure Stack HCI, version 22H2 clusters. We strongly recommend that you install this version as soon as it becomes available.

## High-level workflow for the OS upgrade

The Azure Stack HCI operating system update is available via the Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your cluster, follow these high-level steps:

1. Complete the prerequisites inculding downloading the Azure Stack HCI, version 23H2 OS software update.
1. Connect to the Azure Stack HCI, version 22H2 cluster.
1. Check for the available updates using Windows Admin Center.
1. Install new OS using Windows Admin Center.
1. Check the status of the updates.
1. After the OS is upgraded, perform post-upgrade steps.

## Complete prerequisites

Before you begin, make sure that:

- You have access to an Azure Stack HCI, version 22H2 cluster.
- The cluster should be registered in Azure.
- Make sure that all the nodes in your Azure Stack HCI, version 22H2 cluster are healthy and show as **Online**.
- You have access to the Azure Stack HCI, version 23H2 OS software update. This update is available via Windows Update or as a downloadable media. The media is an ISO file that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- You have access to a client that can connect to your Azure Stack HCI cluster. This client should have Windows Admin Center installed on it. For more information, see [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).

## Step 1: Connect to Azure Stack HCI cluster via Windows Admin Center

To add a server to Windows Admin Center:

1. Select **+ Add** under **All Connections**.
1. Choose to **Add Servers**.
1. Type the name of the server and, if prompted, the credentials to use.
1. Select **Add** to finish.
1. The server is added to your connection list on the **Overview** page. Select the server to connect to it.

## Step 2: Install operating system and hardware updates using Windows Admin Center

Windows Admin Center makes it easy to update a cluster and apply quality updates using a simple user interface. If you've purchased an integrated system from a Microsoft hardware partner, it's easy to get the latest drivers, firmware, and other updates directly from Windows Admin Center by installing the appropriate partner update extension(s). ​If your hardware wasn't purchased as an integrated system, firmware and driver updates may need to be performed separately, following the hardware vendor's recommendations.

   > [!WARNING]
   > If you begin the update process using Windows Admin Center, continue using the wizard until updates complete. Do not attempt to use the Cluster-Aware Updating tool or update a cluster with PowerShell after partially completing the update process in Windows Admin Center. If you wish to use PowerShell to perform the updates instead of Windows Admin Center, skip ahead to [Update a cluster using PowerShell](#update-a-cluster-using-powershell).

Follow these steps to install updates:

1. When you connect to a cluster, the Windows Admin Center dashboard will alert you if one or more servers have updates ready to be installed and provide a link to update now. Alternatively, you can select **Updates** from the **Tools** menu at the left.

2. If you are updating your cluster for the first time, Windows Admin Center will check if the cluster is properly configured to run Cluster-Aware Updating and, if needed, ask if you'd like Windows Admin Center to configure CAU for you, including installing the CAU cluster role and enabling the required firewall rules. To begin the update process, click **Get Started**.

   :::image type="content" source="media/update-cluster/add-cau-role.png" alt-text="Windows Admin Center will automatically configure the cluster to run Cluster-Aware Updating" lightbox="media/update-cluster/add-cau-role.png":::

   > [!NOTE]
   > To use the Cluster-Aware updating tool in Windows Admin Center, you must enable Credential Security Service Provider (CredSSP) and provide explicit credentials. If you are asked if CredSSP should be enabled, click **Yes**. Specify your username and password, and click **Continue**.

3. The cluster's update status will be displayed; click **Check for updates** to get a list of the operating system updates available for each server in the cluster. You may need to supply administrator credentials. If no operating system updates are available, click **Next: hardware updates** and proceed to step 8.

   > [!IMPORTANT]
   > Feature updates require additional steps. If Windows Admin Center indicates that a feature update is available for your cluster, see [Install feature updates using Windows Admin Center](#install-feature-updates-using-windows-admin-center).

   If you navigate away from the Updates screen while an update is in progress, there may be unexpected behavior, such as the history section of the Updates page not populating correctly until the current run is finished. We recommend opening Windows Admin Center in a new browser tab or window if you wish to continue using the application while the updates are in progress.

4. Select **Next: Install** to proceed to install the operating system updates, or click **Skip** to exclude them.

   :::image type="content" source="media/update-cluster/operating-system-updates.png" alt-text="Click Next: Install to proceed to installing operating system updates, or click Skip to exclude them" lightbox="media/update-cluster/operating-system-updates.png":::

   > [!NOTE]
   > If you're installing updates on a cluster that has [Kernel Soft Reboot](kernel-soft-reboot.md) enabled, you'll see a **Disable Kernel Soft Reboot for this run** checkbox. Checking the box disables Kernel Soft Reboot only for that particular updating run. This makes it possible to disable Kernel Soft Reboot when an updating run requires a full reboot, such as BIOS updates.

5. Select **Install** to install the operating system updates. One by one, each server will download and apply the updates. You'll see the update status change to "installing updates." If any of the updates requires a restart, servers will be restarted one at a time, moving cluster roles such as virtual machines between servers to prevent downtime. Depending on the updates being installed, the entire updating run can take anywhere from a few minutes to several hours. You may be asked to supply your login credentials to Windows Admin Center multiple times.

   :::image type="content" source="media/update-cluster/install-os-updates.png" alt-text="Click Install to install operating system updates on each server in the cluster" lightbox="media/update-cluster/install-os-updates.png":::

   > [!NOTE]
   > If the updates appear to fail with a **Couldn't install updates** or **Couldn't check for updates** warning or if one or more servers indicates **couldn't get status** during the updating run, try waiting a few minutes and refreshing your browser. You can also use `Get-CauRun` to [check the status of the updating run with PowerShell](#check-on-the-status-of-an-updating-run).

6. When operating system updates are complete, the update status will change to "succeeded." Click **Next: hardware updates** to proceed to the hardware updates screen.

   > [!IMPORTANT]
   > After applying operating system updates, you may see a message that "storage isn't complete or up-to-date, so we need to sync it with data from other servers in the cluster." This is normal after a server restarts. **Don't remove any drives or restart any servers in the cluster until you see a confirmation that the sync is complete.**

7. If the cluster is not connected to Windows Update and the Azure Stack HCI install media is available on a local share, CAU can also be used to upgrade the cluster:

   When the cluster nodes are not connected to Windows Update after installing the latest quality updates and the setup media has been copied to a share that is accessible to the cluster nodes:

   ```powershell
   Invoke-CauRun –ClusterName <cluster_name> -CauPluginName Microsoft.RollingUpgradePlugin -CauPluginArguments @{ 'WuConnected'='false';'PathToSetupMedia'='\some\path\'; 'UpdateClusterFunctionalLevel'='true'; } -Force
   ```

8. Windows Admin Center will check the cluster for installed extensions that support your specific server hardware. Click **Next: install** to install the hardware updates on each server in the cluster. If no extensions or updates are found, click **Exit**.

9. To improve security, disable CredSSP as soon as you're finished installing the updates:
    - In Windows Admin Center, under **All connections**, select the first server in your cluster and then select **Connect**.
    - On the **Overview** page, select **Disable CredSSP**, and then, on the **Disable CredSSP** pop-up window, select **Yes**.

## Step 2: Install feature updates using Windows Admin Center

Microsoft recommends installing new feature updates as soon as possible, using the following steps.

> [!IMPORTANT]
> There are known issues in Windows Admin Center when upgrading a cluster from Azure Stack HCI, version 20H2 to version 21H2. See [Known issues](#known-issues) at the end of this article.

1. In Windows Admin Center, select **Updates** from the **Tools** pane at the left. Any new feature updates will be displayed.

   :::image type="content" source="media/preview-channel/feature-updates.png" alt-text="Feature updates will be displayed" lightbox="media/preview-channel/feature-updates.png":::

2. Select **Install**. A readiness check will be displayed. If any of the condition checks fail, resolve them before proceeding.

   :::image type="content" source="media/preview-channel/readiness-check.png" alt-text="A readiness check will be displayed" lightbox="media/preview-channel/readiness-check.png":::

3. When the readiness check is complete, you're ready to install the updates. Unless you want the ability to roll back the updates, check the optional **Update the cluster functional level to enable new features** checkbox; otherwise, you can update the cluster functional level post-installation using PowerShell. Review the updates listed and select **Install** to start the update.

   :::image type="content" source="media/preview-channel/install-updates.png" alt-text="Review the updates and install them" lightbox="media/preview-channel/install-updates.png":::

4. You'll be able to see the installation progress as in the screenshot below. Because you're updating the operating system with new features, the updates may take a while to complete. You may be asked to supply your login credentials to Windows Admin Center multiple times.

   :::image type="content" source="media/preview-channel/updates-in-progress.png" alt-text="You'll be able to see the installation progress as updates are installed" lightbox="media/preview-channel/updates-in-progress.png":::

   > [!NOTE]
   > If the updates appear to fail with a **Couldn't install updates** or **Couldn't check for updates** warning or if one or more servers indicates **couldn't get status** during the updating run, try waiting a few minutes and refreshing your browser. You can also use `Get-CauRun` to [check the status of the updating run with PowerShell](#check-on-the-status-of-an-updating-run).

5. When the feature updates are complete, check if any further updates are available and install them.

6. Perform [post-installation steps](#post-installation-steps-for-feature-updates) using PowerShell. These steps are critical to the stability of your cluster.

You're now ready to perform the [Post-installation steps](#step-4-perform-the-post-install-steps).

## Step 3: Perform the post-install steps

Once the new OS is installed, you'll need to update the cluster functional level and update the storage pool version using PowerShell in order to enable new features.

1. Update the cluster functional level.

   We recommend that you update the cluster functional level as soon as possible. Skip this step if you installed the feature updates with Windows Admin Center and checked the optional **Update the cluster functional level to enable new features** checkbox.

   1. Run the following cmdlet on any server in the cluster:

       ```PowerShell
       Update-ClusterFunctionalLevel

   1. You'll see a warning that you can't undo this operation. Confirm **Y** that you want to continue.

       > [!WARNING]
       > After you update the cluster functional level, you can't roll back to the previous operating system version.

1. Update the storage pool.

   1. After the cluster functional level has been updated, use the following cmdlet to identify the `FriendlyName` of the storage pool representing your cluster.

      ```PowerShell
       Get-StoragePool
      ```

      In this example, the FriendlyName is **S2D on hci-cluster1**.

   1. Run the `Update-StoragePool` cmdlet to update the storage pool version.

      ```PowerShell
       Update-StoragePool -FriendlyName "S2D on hci-cluster1"
      ```

   1. Confirm the action when prompted. At this point, new cmdlets will be fully operational on any server in the cluster.

1. (Optional) Upgrade VM configuration levels. You can optionally upgrade VM configuration levels by stopping each VM using the `Update-VMVersion` cmdlet and then starting the VMs again.

   1. Verify that the upgraded cluster functions as expected.

       Roles should fail over correctly and, if VM live migration is used on the cluster, VMs should successfully live migrate.

   1. Validate the cluster.

       Run the `Test-Cluster` cmdlet on one of the servers in the cluster and examine the cluster validation report.

You're now ready to [Prepare to apply the solution update](./prepare-to-apply-23h2-solution-update.md).

## Next steps

- [Learn how to prepare to apply the solution update.](./prepare-to-apply-23h2-solution-update.md)