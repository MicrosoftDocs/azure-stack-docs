---
title: Install Azure Stack HCI, version 23H2 operating system (preview)
description: Learn how to install the Azure Stack HCI, version 23H2 operating system on each server of your cluster (preview).
author: alkohli
ms.topic: how-to
ms.date: 11/27/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Install the Azure Stack HCI, version 23H2 operating system (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the steps needed to install the Azure Stack HCI, version 23H2 operating system locally on each server in your cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](./deployment-prerequisites.md).
- Complete the [deployment checklist](./deployment-checklist.md).
- Prepare your [Active Directory](./deployment-prep-active-directory.md) environment.
- Make sure to keep a password handy that you will use to sign in to the operating system. This password must conform to the length and complexity requirements. Use a password that is at least 12 characters long and contains: a lowercase character, an uppercase character, a numeral, and  a special character.

## Boot and install the operating system

To install the Azure Stack HCI, version 23H2 operating system, follow these steps:

1. [Download the Azure Stack HCI operating system from the Azure portal](./download-azure-stack-hci-23h2-software.md).

1. Start the **Install Azure Stack HCI** wizard on the system drive of the server where you want to install the operating system.

1. Choose the language to install or accept the default language settings, select **Next**, and then on next page of the wizard, select **Install now**.

   :::image type="content" source="media/install-os/azure-stack-hci-install-language.png" alt-text="Screenshot of the language page of the Install Azure Stack HCI wizard." lightbox="media/install-os/azure-stack-hci-install-language.png":::

1. On the **Applicable notices and license terms** page, review the license terms, select the **I accept the license terms** checkbox, and then select **Next**.

1. On the **Which type of installation do you want?** page, select **Custom: Install the newer version of Azure Stack HCI only (advanced)**.

    > [!NOTE]
    > Upgrade installations are not supported in this release of the operating system.

   :::image type="content" source="media/install-os/azure-stack-hci-install-which-type.png" alt-text="Screenshot of the language page of the Install Type Azure Stack HCI wizard." lightbox="media/install-os/azure-stack-hci-install-language.png":::

1. On the **Where do you want to install Azure Stack HCI?** page, confirm the drive where the operating system is installed, and then select **Next**.

   :::image type="content" source="media/install-os/azure-stack-hci-install-where.png" alt-text="Screenshot of the installation type page of the Install Azure Stack HCI wizard." lightbox="media/install-os/azure-stack-hci-install-where.png":::

    > [!NOTE]
    > If the hardware was used before, run `diskpart` to clean the OS drive. For more information, see how to [Use diskpart](/windows-server/administration/windows-commands/diskpart). Also see the instructions in [Clean drives](/windows-server/storage/storage-spaces/deploy-storage-spaces-direct#step-31-clean-drives).

1. The **Installing Azure Stack HCI** page displays to show status on the process.

   :::image type="content" source="media/install-os/azure-stack-hci-installing.png" alt-text="Screenshot of the status page of the Install Azure Stack HCI wizard." lightbox="media/install-os/azure-stack-hci-installing.png":::

    > [!NOTE]
    > The installation process restarts the operating system twice to complete the process, and displays notices on starting services before opening an Administrator command prompt.

1. At the Administrator command prompt, select **Ok** to change the user's password before signing in to the operating system, and press **Enter**.

   :::image type="content" source="media/install-os/azure-stack-hci-change-admin-password.png" alt-text="Screenshot of the change password prompt." lightbox="media/install-os/azure-stack-hci-change-admin-password.png":::


1. At the **Enter new credential** for Administrator prompt, enter a new password. 

    > [!IMPORTANT]
    > Make sure that the local administrator password follows Azure password length and complexity requirements. Use a password that is at least 12 characters long and contains: lowercase character, an uppercase character, a numeral, and  a special character.**

    Enter the password again to confirm it, and then press **Enter**.

1. At the **Your password has been changed** confirmation prompt, press **Enter**.

   :::image type="content" source="media/install-os/azure-stack-hci-admin-password-changed.png" alt-text="Screenshot of the changed password confirmation prompt." lightbox="media/install-os/azure-stack-hci-admin-password-changed.png":::

Now you're ready to use the Server Configuration tool (SConfig) to perform important tasks. 

## Configure the operating system using SConfig

You can use [*SConfig*](https://www.powershellgallery.com/packages/SCONFIG/2.0.1)to configure Azure Stack HCI version 23H2 after installation. 

To use *SConfig*, sign in to the server running the Azure Stack HCI operating system. This could be locally via a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. The *SConfig* tool opens automatically when you sign in to the server.

:::image type="content" source="media/install-os/azure-stack-hci-sconfig-screen.png" alt-text="Screenshot of the Server Configuration tool interface." lightbox="media/install-os/azure-stack-hci-sconfig-screen.png":::

Follow these steps to configure the operating system using *SConfig*:

1. Configure networking as per your environment.

1. Use the **Network Settings** option in *SConfig* to configure a default valid gateway and a DNS server. Set DNS to the DNS of Domain you're joining.

1. Rename all the servers using option 2 in *SConfig* to match what you have used when preparing Active Directory, as you won't rename the servers later. <!--Make a note of the network adapter names in the OS so as to ensure that these names match in the *config.json* file that you create later.-->

1. (Optional) At this point, you can enable Remote Desktop Protocol (RDP) and then RDP to each server rather than use the virtual console. This action should simplify performing the remainder of the configuration.

1. (Optional) Clean all the non-OS drives for each server that you intend to deploy. Remove any virtual media that have been used when installing the OS. Also validate that no other root drives exist.

1. Restart the servers.

1. Set the local administrator credentials to be identical across all servers. 

    > [!NOTE]
    > Make sure that the local administrator password follows Azure password length and complexity requirements. Use a password that is at least 12 characters long and contains: lowercase character, an uppercase character, a numeral, and  a special character.

1. Install the latest drivers and firmware as per the instructions provided by your hardware manufacturer. You can use *SConfig* to run driver installation apps. After the install is complete, restart your servers again.

## Install required Windows roles

1. Install the Hyper-V role. Run the following command on each server of the cluster:

    ```powershell
    Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
    ```

    Your servers will restart and this will take a few minutes.

1. After the servers have restarted, use the option 15 in *SConfig* to launch the PowerShell session.

1. Skip this step if you're deploying a single server.

    1. On each node, run the following command:

        ```powershell
        winrm quickconfig
        ```

    1. Enable Internet Control Message Protocol (ICMP). This command is required for the other nodes to access the first node.

        ```azurepowershell
        netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
        ```

## Next steps

- [Register Azure Stack HCI servers in your system with Azure Arc and assign permissions](./deployment-arc-register-server-permissions.md).
- (Optional) [Configure proxy settings for Azure Stack HCI, version 23H2](../manage/configure-proxy-settings-23h2.md).
