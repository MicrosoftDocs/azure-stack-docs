---
title: Install Azure Stack HCI, version 23H2 operating system
description: Learn how to install the Azure Stack HCI, version 23H2 operating system on each server of your cluster.
author: alkohli
ms.topic: how-to
ms.date: 06/13/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Install the Azure Stack HCI, version 23H2 operating system

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the steps needed to install the Azure Stack HCI, version 23H2 operating system locally on each server in your cluster.

## Prerequisites

Before you begin, make sure you do the following steps:

- Satisfy the [prerequisites](./deployment-prerequisites.md).
- Prepare your [Active Directory](./deployment-prep-active-directory.md) environment.
- Make sure to keep a password handy to use to sign in to the operating system. This password must conform to the length and complexity requirements. Use a password that is at least 12 characters long and contains a lowercase character, an uppercase character, a numeral, and a special character.

## Boot and install the operating system

To install the Azure Stack HCI, version 23H2 operating system, follow these steps:

1. [Download the Azure Stack HCI operating system from the Azure portal](./download-azure-stack-hci-23h2-software.md).

1. Start the **Install Azure Stack HCI** wizard on the system drive of the server where you want to install the operating system.

1. Choose the language to install or accept the default language settings, select **Next**, and then on next page of the wizard, select **Install now**.

   :::image type="content" source="media/deployment-install-os/azure-stack-hci-install-language.png" alt-text="Screenshot of the language page of the Install Azure Stack HCI wizard." lightbox="media/deployment-install-os/azure-stack-hci-install-language.png":::

1. On the **Applicable notices and license terms** page, review the license terms, select the **I accept the license terms** checkbox, and then select **Next**.

1. On the **Which type of installation do you want?** page, select **Custom: Install the newer version of Azure Stack HCI only (advanced)**.

    > [!NOTE]
    > Upgrade installations are not supported in this release of the operating system.

   :::image type="content" source="media/deployment-install-os/azure-stack-hci-install-which-type.png" alt-text="Screenshot of the language page of the Install Type Azure Stack HCI wizard." lightbox="media/deployment-install-os/azure-stack-hci-install-language.png":::

1. On the **Where do you want to install Azure Stack HCI?** page, confirm the drive on which the operating system is installed, and then select **Next**.

   :::image type="content" source="media/deployment-install-os/azure-stack-hci-install-where.png" alt-text="Screenshot of the installation type page of the Install Azure Stack HCI wizard." lightbox="media/deployment-install-os/azure-stack-hci-install-where.png":::

    > [!NOTE]
    > If the hardware was used before, run `diskpart` to clean the OS drive. For more information, see [how to use diskpart](/windows-server/administration/windows-commands/diskpart). Also see the instructions in [Clean drives](/windows-server/storage/storage-spaces/deploy-storage-spaces-direct#step-31-clean-drives).

1. The **Installing Azure Stack HCI** page displays to show status on the process.

   :::image type="content" source="media/deployment-install-os/azure-stack-hci-installing.png" alt-text="Screenshot of the status page of the Install Azure Stack HCI wizard." lightbox="media/deployment-install-os/azure-stack-hci-installing.png":::

    > [!NOTE]
    > The installation process restarts the operating system twice to complete the process, and displays notices on starting services before opening an Administrator command prompt.

1. At the Administrator command prompt, select **Ok** to change the user's password before signing in to the operating system, then press **Enter**.

   :::image type="content" source="media/deployment-install-os/azure-stack-hci-change-admin-password.png" alt-text="Screenshot of the change password prompt." lightbox="media/deployment-install-os/azure-stack-hci-change-admin-password.png":::

1. At the **Enter new credential** for Administrator prompt, enter a new password.

    > [!IMPORTANT]
    > Make sure that the local administrator password follows Azure password length and complexity requirements. Use a password that is at least 12 characters long and contains a lowercase character, an uppercase character, a numeral, and a special character.

    Enter the password again to confirm it, then press **Enter**.

1. At the **Your password has been changed** confirmation prompt, press **Enter**.

   :::image type="content" source="media/deployment-install-os/azure-stack-hci-admin-password-changed.png" alt-text="Screenshot of the changed password confirmation prompt." lightbox="media/deployment-install-os/azure-stack-hci-admin-password-changed.png":::

Now you're ready to use the Server Configuration tool (SConfig) to perform important tasks.

## Configure the operating system using SConfig

You can use [*SConfig*](https://www.powershellgallery.com/packages/SCONFIG/2.0.1) to configure Azure Stack HCI, version 23H2 after installation.

To use SConfig, sign in to the server running the Azure Stack HCI operating system. This could be locally via a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. The SConfig tool opens automatically when you sign in to the server.

:::image type="content" source="media/deployment-install-os/azure-stack-hci-sconfig-screen.png" alt-text="Screenshot of the Server Configuration tool interface." lightbox="media/deployment-install-os/azure-stack-hci-sconfig-screen.png":::

> [!IMPORTANT]
> - Do not install Windows Updates using SConfig. Updates are installed during the deployment. Installing updates using SConfig causes a deployment failure.
> - Machines must not be joined to Active Directory before deployment.

Follow these steps to configure the operating system using SConfig:

1. Install the latest drivers and firmware as per the instructions provided by your hardware manufacturer. You can use SConfig to run driver installation apps. After the installation is complete, restart your servers.

    > [!IMPORTANT]
    > If your hardware partner provides a solution builder extension (SBE), copy it to each server that you intend to cluster. Place the SBE content at *C:\SBE* to ensure that it is detected and used during deployment. For more information, see [Azure Stack HCI solution builder extension](../concepts/system-requirements-23h2.md#hardware-requirements).

1. Configure networking as per your environment. You can configure the following optional settings:

    - Configure VLAN IDs for the management network. For more information, see [Management VLAN ID](../plan/cloud-deployment-network-considerations.md#management-vlan-id) and [Management VLAN ID with a virtual switch](../plan/cloud-deployment-network-considerations.md#management-vlan-id-with-a-virtual-switch).
    - Configure DHCP for the management network. For more information, see [DHCP IP assignment](../plan/cloud-deployment-network-considerations.md#dhcp-ip-assignment).
    - Configure a proxy server. For more information, see [Configure proxy settings for Azure Stack HCI, version 23H2](../manage/configure-proxy-settings-23h2.md).

1. Use the **Network Settings** option in SConfig to configure a default valid gateway and a DNS server. Set **DNS** to the DNS of the domain you're joining.

1. Configure a valid time server on each server. Validate that your server is not using the local CMOS clock as a time source, using the following command:

   ```cmd
   w32tm /query /status
   ```

   To configure a valid time source, run the following command:

   ```cmd
   w32tm /config /manualpeerlist:"ntpserver.contoso.com" /syncfromflags:manual /update
   ```

   Confirm that the time is successfully synchronizing using the new time server:

   ```cmd
   w32tm /query /status
   ```

   Once the server is domain joined, it synchronizes its time from the PDC emulator.

1. (Optional) At this point, you can enable Remote Desktop Protocol (RDP) and then RDP to each server rather than use the virtual console. This action should simplify performing the remainder of the configuration.

1. (Optional) Change the Computer Name as desired. This will be the name shown in the Azure portal as well as your Active Directory environment once joined.

1. Clean all the non-OS drives for each server that you intend to deploy. Remove any virtual media that have been used when installing the OS. Also validate that no other root drives exist.

    > [!NOTE]
    > This step doesn't apply to a server repair operation.

1. Restart the servers.

1. Set the local administrator credentials to be identical across all servers.

    > [!NOTE]
    > - Make sure that the local administrator password follows Azure password length and complexity requirements. Use a password that is at least 12 characters long and contains a lowercase character, an uppercase character, a numeral, and a special character.
    > - Do not join the servers with the Azure Stack HCI operating system installed, to the Active Directory domain prior to cloud deployment. Cluster nodes are automatically joined to a domain during the [Deployment via Azure portal](./deploy-via-portal.md).

## Install required Windows roles

**This step is only required if you're using an OS ISO that's older than 2408**. For more information, see [What's new in 2408](../whats-new.md#features-and-improvements-in-2408).

Install the Hyper-V role. Run the following command on each server of the cluster:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

Your servers will restart; this takes a few minutes.

You are now ready to register the Azure Stack HCI server with Azure Arc and assign permissions for deployment.

## Next steps

- (Optional) [Configure proxy settings for Azure Stack HCI, version 23H2](../manage/configure-proxy-settings-23h2.md).
- [Register Azure Stack HCI servers in your system with Azure Arc and assign permissions](./deployment-arc-register-server-permissions.md).