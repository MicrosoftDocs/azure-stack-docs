---
title: Upgrade Azure Stack HCI, version 22H2 OS to version 23H2 via Windows Admin Center
description: Learn how to upgrade from Azure Stack HCI, version 22H2 OS to Azure Stack HCI, version 23H2 using Windows Admin Center.
author: alkohli
ms.topic: how-to
ms.date: 08/23/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Upgrade Azure Stack HCI, version 22H2 operating system to Azure Stack HCI, version 23H2 via Windows Admin Center

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to upgrade the Azure Stack HCI, version 22H2 operating system (OS) to version 23H2, which is the latest generally available software via Windows Admin Center.

While the recommended method to [Upgrade the OS is via PowerShell](./upgrade-22h2-to-23h2-powershell.md), you can also upgrade via Windows Admin Center or other methods.

Throughout this article, we refer to Azure Stack HCI, version 23H2 as the *new* version and Azure Stack HCI, version 22H2 as the *old* version.

> [!IMPORTANT]
> To keep your Azure Stack HCI service in a supported state, you have up to six months to install this new OS version. The update is applicable to all Azure Stack HCI, version 22H2 clusters. We strongly recommend that you install this version as soon as it becomes available.

## High-level workflow for the OS upgrade

The Azure Stack HCI operating system update is available via Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your cluster, follow these high-level steps:

1. [Complete the prerequisites](#complete-prerequisites).
1. [Connect to the Azure Stack HCI, version 22H2 cluster](#step-1-connect-to-azure-stack-hci-cluster-via-windows-admin-center).
1. [Check for the available updates using Windows Admin Center.](#step-2-install-operating-system-and-hardware-updates-using-windows-admin-center)
1. [Install the new OS, hardware and extension updates using Windows Admin Center.](#step-2-install-operating-system-and-hardware-updates-using-windows-admin-center)
1. [Perform post-OS upgrade steps.](#next-steps)

## Complete prerequisites

Before you begin, make sure that:

- You have access to an Azure Stack HCI, version 22H2 cluster.
- The cluster should be registered in Azure.
- Make sure that all the nodes in your Azure Stack HCI, version 22H2 cluster are healthy and show as **Online**.
- You have access to the Azure Stack HCI, version 23H2 OS software update. This update is available via Windows Update or as a downloadable media. The media is an ISO file that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- You have access to a client that can connect to your Azure Stack HCI cluster. This client should have Windows Admin Center installed on it. For more information, see [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).

> [!NOTE]
> The offline ISO upgrade method is not available when using Windows Admin Center. For these steps, see [Upgrade Azure Stack HCI operating system via PowerShell](./upgrade-22h2-to-23h2-powershell.md)

## Step 1: Connect to Azure Stack HCI cluster via Windows Admin Center

Follow these steps to add and connect to an Azure Stack HCI server via Windows Admin Center.

1. Select **+ Add** under **All Connections**.
1. Scroll down to **Server clusters** and select **Add**.
1. Type the name of the cluster and, if prompted, the credentials to use.
1. Select **Add** to finish.
1. The cluster and nodes are added to your connection list on the **Overview** page. Select the cluster to connect to it.

## Step 2: Install operating system and hardware updates using Windows Admin Center

Windows Admin Center makes it easy to update a cluster and apply quality updates using a simple user interface. If you purchased an integrated system from a Microsoft hardware partner, it's easy to get the latest drivers, firmware, and other updates directly from Windows Admin Center by installing the appropriate partner update extensions. ​If your hardware wasn't purchased as an integrated system, firmware and driver updates would need to be performed separately, following the hardware vendor's recommendations.

   > [!WARNING]
   > If you begin the update process using Windows Admin Center, continue using the wizard until updates complete. Don't attempt to use the Cluster-Aware Updating (CAU) tool or update a cluster with PowerShell after partially completing the update process in Windows Admin Center. If you wish to use PowerShell to perform the updates instead of Windows Admin Center, see [Update a cluster using PowerShell](./upgrade-22h2-to-23h2-powershell.md).

Follow these steps to install updates:

> [!NOTE]
> The following steps use Windows Admin Center version 2311. If you are using a different version, your screens may vary slightly.

1. When you connect to a cluster, the Windows Admin Center dashboard alerts you if one or more servers have updates ready to be installed and provide a link to update now. Alternatively, select **Updates** from the **Operations** menu at the left.

1. If you're updating your cluster for the first time, Windows Admin Center checks if the cluster is properly configured to run CAU. If not, it prompts you to allow Windows Admin Center to configure CAU, which includes installing the CAU cluster role and enabling the required firewall rules. To begin the update process, select **Add Cluster-Aware-Updating role**.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/add-cau-role.png" alt-text="Screenshot of Windows Admin Center automatically configuring the cluster to run Cluster-Aware Updating." lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/add-cau-role.png":::

   > [!NOTE]
   > To use the CAU tool in Windows Admin Center, you must enable Credential Security Service Provider (CredSSP) and provide explicit credentials. If you are asked if CredSSP should be enabled, select **Yes**. Specify your username and password, and select **Continue**.

1. After the role is installed, Windows Admin Center automatically checks for updates applicable to your cluster. Ensure the radio button for **Feature update (Recommended)** is selected and the **Feature update for Azure Stack HCI, version 23H2** is **Available** for the cluster nodes. If the feature update isn't displayed, ensure your cluster is running the Azure Stack HCI OS and that the nodes have direct access to Windows Update, then select **Check for updates**.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/check-for-updates.png" alt-text="Screenshot of the Updates page in Windows Admin Center showing the available updates." lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/check-for-updates.png":::

   > [!IMPORTANT]
   > Feature updates aren't available in Windows Server Update Services (WSUS).

   If you navigate away from the Updates screen while an update is in progress, there could be unexpected behavior, such as the history section of the Updates page not populating correctly until the current run is finished. We recommend opening Windows Admin Center in a new browser tab or window if you wish to continue using the application while the updates are in progress.

1. Select **Install**. Windows Admin Center automatically performs a series of readiness checks to identify issues that could prevent CAU from completing successfully. If any issues are found, select the **Details** link next to the issue, address the issue, and then select **Check again** to run the readiness checks again.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/readiness-checks.png" alt-text="Screenshot of the readiness check during the installation of updates." lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/readiness-checks.png":::

   > [!NOTE]
   > If you're installing updates on a cluster that has [Kernel Soft Reboot](../manage/kernel-soft-reboot.md) enabled, select **Disable Kernel Soft Reboot for this run** checkbox. This selection disables Kernel Soft Reboot as the upgrade requires a full reboot.

1. Select **Next: Install** to review the list of updates to be installed to each cluster node. Then, select **Install** to begin installing the operating system updates. One by one, each server downloads and applies the updates. The update status changes to **Installing updates**. If the updates require a restart, servers are restarted one at a time, moving cluster roles such as virtual machines between servers to prevent downtime. Depending on the updates being installed, the entire update run can take anywhere from a few minutes to several hours. You would need to sign in to Windows Admin Center multiple times.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/final-confirmation.png" alt-text="Screenshot of selecting Install to install operating system updates on each server in the cluster." lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/final-confirmation.png":::

   > [!NOTE]
   > If the updates fail with a **Couldn't install updates** or **Couldn't check for updates** warning or if one or more servers indicate **couldn't get status** during the run, wait a few minutes, and refresh your browser. You can also use `Get-CauRun` to [check the status of the update run with PowerShell](./upgrade-22h2-to-23h2-powershell.md#step-3-check-the-status-of-an-update).

1. When operating system updates are complete, the update status changes to **Succeeded**. Select **Next: Hardware updates** to proceed to the hardware updates screen.

   > [!IMPORTANT]
   > After applying operating system updates, you may see a message that "storage isn't complete or up-to-date, so we need to sync it with data from other servers in the cluster." This is normal after a server restarts. **Don't remove any drives or restart any servers in the cluster until you see a confirmation that the sync is complete.**
   
   > [!NOTE]
   > Hardware updates are only available on clusters that have the vendor's hardware extension installed. If your Windows Admin Center does not have this extension, there will not be an option to install hardware updates. 

1. Windows Admin Center checks the cluster for installed extensions that support your specific server hardware. Select **Next: Install** to install the hardware updates on each server in the cluster. If no extensions or updates are found, select **Exit**.

1. As per security best practices, disable CredSSP as soon as you're finished installing the updates:
    - In Windows Admin Center, under **All connections**, select the first server in your cluster and then select **Connect**.
    - On the **Overview** page, select **Disable CredSSP**, and then, on the **Disable CredSSP** pop-up window, select **Yes**.

You're now ready to perform the post-upgrade steps for your cluster.

## Next steps

- [Learn how to perform the post-upgrade steps for your Azure Stack HCI cluster.](./post-upgrade-steps.md)
