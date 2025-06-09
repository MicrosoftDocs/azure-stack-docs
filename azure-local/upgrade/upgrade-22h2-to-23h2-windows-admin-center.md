---
title: Upgrade Azure Stack HCI OS, version 22H2 to version 23H2 via Windows Admin Center
description: Learn how to upgrade Azure Stack HCI OS, version 22H2 to version 23H2 using Windows Admin Center.
author: alkohli
ms.topic: how-to
ms.date: 06/06/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Upgrade Azure Stack HCI OS, version 22H2 to version 23H2 via Windows Admin Center

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

This article describes how to upgrade the operating system (OS) for Azure Local from version 22H2 to version 23H2 via the Windows Admin Center. This is the first step in the upgrade process, which upgrades only the OS.

While the recommended method is to [Upgrade Azure Stack HCI OS, version 22H2 to version 23H2 via PowerShell](./upgrade-22h2-to-23h2-powershell.md), you can also upgrade via Windows Admin Center or other methods.

Throughout this article, we refer to OS version 23H2 as the *new* version and version 22H2 as the *old* version.

> [!IMPORTANT]
> To keep your Azure Local service in a supported state, you have up to six months to install this new OS version. The update applies to all Azure Local running version 22H2. We strongly recommend that you install this version as soon as it becomes available.

## High-level workflow for the OS upgrade

The Azure Stack HCI operating system update is available via Windows Update and via the media that you can download from the Azure portal.

To upgrade the OS on your Azure Local, follow these high-level steps:

1. [Complete the prerequisites](#complete-prerequisites).
1. [Update registry keys.](#step-0-update-registry-keys)
1. [Connect to the Azure Local, version 22H2](#step-1-connect-to-azure-local-via-windows-admin-center).
1. [Check for the available updates using Windows Admin Center.](#step-2-install-operating-system-and-hardware-updates-using-windows-admin-center)
1. [Install the new OS, hardware and extension updates using Windows Admin Center.](#step-2-install-operating-system-and-hardware-updates-using-windows-admin-center)
1. [Perform post-OS upgrade steps.](#next-steps)

## Complete prerequisites

Before you begin, make sure that:

- You have access to version 23H2 OS software update.
- The system is registered in Azure.
- All the machines in your Azure Local are healthy and show as **Online**.
- You shut down virtual machines (VMs). We recommend shutting down VMs before performing the OS upgrade to prevent unexpected outages and damages to databases.
- You have access to the Azure Stack HCI OS, version 23H2 software update. This update is available via Windows Update or as a downloadable media. The media must be version **2503** ISO that you can download from the [Azure portal](https://portal.azure.com/#view/Microsoft_Azure_HybridCompute/AzureArcCenterBlade/~/hciGetStarted).
- You have access to a client that can connect to your Azure Local instance. This client should have Windows Admin Center installed on it. For more information, see [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).
- You run the `RepairRegistration` cmdlet only if both of the following conditions apply:

   - The *identity* property is either missing or doesn’t contain `type = "SystemAssigned"`.
      - Check this in the Resource JSON in the Azure portal
      - Or run the `Get-AzResource -Name <cluster_name>` PowerShell cmdlet
   - The **Cloud Management** cluster group is not present. Check it by running the `Get-ClusterGroup` PowerShell cmdlet.

   If both these conditions are met, run the `RepairRegistration` cmdlet:

   ```powershell
   Register-AzStackHCI -TenantId "<tenant_ID>" -SubscriptionId "<subscription_ID>" -ComputerName "<computer_name>" -RepairRegistration
   ```

- (Recommended) You enable [Secure Boot](/windows-hardware/design/device-experiences/oem-secure-boot) on Azure Local machines before you upgrade the OS.
   To enable Secure Boot, follow these steps:
   1. Drain the cluster node.
   1. Restart the OS.
   1. Enter the BIOS/UEFI menu.
   1. Review the **Boot** or **Security** section of the UEFI configuration options Locate the Secure Boot option.
   1. Set the option to **Enabled** or **On**.
   1. Save the changes and restart your computer.

   Consult with your hardware vendor for assistance if required.

> [!NOTE]
> The offline **2503** ISO upgrade method is not available when using Windows Admin Center. For these steps, see [Upgrade the operating system on Azure Local via PowerShell](./upgrade-22h2-to-23h2-powershell.md)

## Step 0: Update registry keys

To ensure Resilient File System (ReFS) and live migrations function properly during and after OS upgrade, follow these steps on each machine in the system to update registry keys. Reboot each machine for the changes to take effect.

1. Set `RefsEnableMetadataValidation` to `0`:

   ```powershell
   Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" -Value 0 -Type DWord  -ErrorAction Stop
   ```

1. Create the parameters key if it doesn't exist. If it already exists, the command may fail with an error, which is expected.

   ```powershell
   New-Item -Path HKLM:\SYSTEM\CurrentControlSet\Services\Vid\Parameters
   ```

1. Set `SkipSmallLocalAllocations` to `0`:

   ```powershell
   New-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Services\Vid\Parameters -Name SkipSmallLocalAllocations -Value 0 -PropertyType DWord
   ```

1. Restart the machine for the changes to take effect. On machine restart, if the `RefsEnableMetadataValidation` key gets overridden and ReFS volumes fail to come online, toggle the key by first setting `RefsEnableMetadataValidation` to `1` and then back to `0` again.

1. Update and verify that the registry keys have been applied on each machine in the system before moving to the next step.

## Step 1: Connect to Azure Local via Windows Admin Center

Follow these steps to add and connect to an Azure Local machine via Windows Admin Center.

1. Select **+ Add** under **All Connections**.
1. Scroll down to **Server clusters** and select **Add**.
1. Type the name of the system and, if prompted, the credentials to use.
1. Select **Add** to finish.
1. The system and machines are added to your connection list on the **Overview** page. Select the system to connect to it.

## Step 2: Install operating system and hardware updates using Windows Admin Center

Windows Admin Center makes it easy to update Azure Local and apply quality updates using a simple user interface. If you purchased an integrated system from a Microsoft hardware partner, it's easy to get the latest drivers, firmware, and other updates directly from Windows Admin Center by installing the appropriate partner update extensions. ​If your hardware wasn't purchased as an integrated system, firmware and driver updates would need to be performed separately, following the hardware vendor's recommendations.

   > [!WARNING]
   > If you begin the update process using Windows Admin Center, continue using the wizard until updates complete. Don't attempt to use the Cluster-Aware Updating (CAU) tool or update a system with PowerShell after partially completing the update process in Windows Admin Center. If you wish to use PowerShell to perform the updates instead of Windows Admin Center, see [Upgrade via PowerShell](./upgrade-22h2-to-23h2-powershell.md).

Follow these steps to install updates:

> [!NOTE]
> The following steps use Windows Admin Center version 2311. If you are using a different version, your screens may vary slightly.

1. When you connect to a system, the Windows Admin Center dashboard alerts you if one or more machines have updates ready to be installed and provide a link to update now. Alternatively, select **Updates** from the **Operations** menu at the left.

1. If you're updating your system for the first time, Windows Admin Center checks if the system is properly configured to run CAU. If not, it prompts you to allow Windows Admin Center to configure CAU, which includes installing the CAU cluster role and enabling the required firewall rules. To begin the update process, select **Add Cluster-Aware-Updating role**.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/add-cau-role.png" alt-text="Screenshot of Windows Admin Center automatically configuring the system to run Cluster-Aware Updating." lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/add-cau-role.png":::

   > [!NOTE]
   > To use the CAU tool in Windows Admin Center, you must enable Credential Security Service Provider (CredSSP) and provide explicit credentials. If you are asked if CredSSP should be enabled, select **Yes**. Specify your username and password, and select **Continue**.

1. After the role is installed, Windows Admin Center automatically checks for updates applicable to your system. Ensure the radio button for **Feature update (Recommended)** is selected and the **Feature update for Azure Local, version 23H2** is **Available** for the machines. If the feature update isn't displayed, ensure your system is running the Azure Stack HCI OS and that the machines have direct access to Windows Update, then select **Check for updates**.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/check-for-updates.png" alt-text="Screenshot of the Updates page in Windows Admin Center showing the available updates." lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/check-for-updates.png":::

   > [!IMPORTANT]
   > Feature updates aren't available in Windows Server Update Services (WSUS).

   If you navigate away from the Updates screen while an update is in progress, there could be unexpected behavior, such as the history section of the Updates page not populating correctly until the current run is finished. We recommend opening Windows Admin Center in a new browser tab or window if you wish to continue using the application while the updates are in progress.

1. Select **Install**. Windows Admin Center automatically performs a series of readiness checks to identify issues that could prevent CAU from completing successfully. If any issues are found, select the **Details** link next to the issue, address the issue, and then select **Check again** to run the readiness checks again.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/readiness-checks.png" alt-text="Screenshot of the readiness check during the installation of updates." lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/readiness-checks.png":::

   > [!NOTE]
   > If you're installing updates on a system that has [Kernel Soft Reboot](../manage/kernel-soft-reboot.md) enabled, select **Disable Kernel Soft Reboot for this run** checkbox. This selection disables Kernel Soft Reboot as the upgrade requires a full reboot.

1. Select **Next: Install** to review the list of updates to be installed to each machine. Then, select **Install** to begin installing the operating system updates. One by one, each machine downloads and applies the updates. The update status changes to **Installing updates**. If the updates require a restart, machines are restarted one at a time, moving roles such as VMs between machines to prevent downtime. Depending on the updates being installed, the entire update run can take anywhere from a few minutes to several hours. You would need to sign in to Windows Admin Center multiple times.

   :::image type="content" source="media/upgrade-22h2-to-23h2-windows-admin-center/final-confirmation.png" alt-text="Screenshot of selecting Install to install operating system updates on each machine in the system." lightbox="media/upgrade-22h2-to-23h2-windows-admin-center/final-confirmation.png":::

   > [!NOTE]
   > If the updates fail with a **Couldn't install updates** or **Couldn't check for updates** warning or if one or more machines indicate **couldn't get status** during the run, wait a few minutes, and refresh your browser. You can also use `Get-CauRun` to [check the status of the update run with PowerShell](./upgrade-22h2-to-23h2-powershell.md#step-3-check-the-status-of-an-update).

1. When operating system updates are complete, the update status changes to **Succeeded**. Select **Next: Hardware updates** to proceed to the hardware updates screen.

   > [!IMPORTANT]
   > After applying operating system updates, you may see a message that "storage isn't complete or up-to-date, so we need to sync it with data from other servers in the cluster." This is normal after a machine restarts. **Don't remove any drives or restart any machines in the system until you see a confirmation that the sync is complete.**
   
   > [!NOTE]
   > Hardware updates are only available on systems that have the vendor's hardware extension installed. If your Windows Admin Center does not have this extension, there will not be an option to install hardware updates.

1. Windows Admin Center checks the system for installed extensions that support your specific machine hardware. Select **Next: Install** to install the hardware updates on each machine in the system. If no extensions or updates are found, select **Exit**.

1. As per security best practices, disable CredSSP as soon as you're finished installing the updates:
    - In Windows Admin Center, under **All connections**, select the first machine in your system and then select **Connect**.
    - On the **Overview** page, select **Disable CredSSP**, and then, on the **Disable CredSSP** pop-up window, select **Yes**.

You're now ready to perform the post-upgrade steps for your system.


## Next steps

- [Learn how to perform the post-upgrade steps for your Azure Local.](./post-upgrade-steps.md)
