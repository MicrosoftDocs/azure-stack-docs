---
title: Install Azure Stack HCI, version 22H2 operating system (preview)
description: Learn how to install the Azure Stack HCI version 22H2 operating system on each server of your cluster (preview).
author: alkohli
ms.topic: how-to
ms.date: 11/17/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Install the Azure Stack HCI, version 22H2 operating system (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

The Azure Stack HCI, version 22H2 operating system is installed locally on each server in your cluster.
The installation includes a folder that contains the deployment tool used to deploy a cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.

## Boot and install the operating system

The Supplemental package supports only the English version of the Azure Stack HCI operating system.

To install the Azure Stack HCI operating system in English, follow these steps:

1. [Download the Azure Stack HCI operating system from the Azure portal](../deploy/download-azure-stack-hci-software.md). Make sure to select **English** from the **Choose language** dropdown list.
1. Start the **Install Azure Stack HCI** wizard on the system drive of the server where you want to install the operating system.
1. Choose the language to install or accept the default language settings, select **Next**, and then on next page of the wizard, select **Install now**.

    :::image type="content" source="../media/operating-system/azure-stack-hci-install-language.png" alt-text="Screenshot of the language page of the Install Azure Stack HCI wizard.":::

1. On the **Applicable notices and license terms** page, review the license terms, select the **I accept the license terms** checkbox, and then select **Next**.
1. On the **Which type of installation do you want?** page, select **Custom: Install the newer version of Azure Stack HCI only (advanced)**.

    > [!NOTE]
    > Upgrade installations are not supported in this release of the operating system.

    :::image type="content" source="../media/operating-system/azure-stack-hci-install-which-type.png" alt-text="Screenshot of the installation type option page of the Install Azure Stack HCI wizard.":::

1. On the **Where do you want to install Azure Stack HCI?** page, confirm the drive where the operating system is installed, and then select **Next**.

    :::image type="content" source="../media/operating-system/azure-stack-hci-install-where.png" alt-text="Screenshot of the drive location page of the Install Azure Stack HCI wizard.":::

1. The **Installing Azure Stack HCI** page displays to show status on the process.

    :::image type="content" source="../media/operating-system/azure-stack-hci-installing.png" alt-text="Screenshot of the status page of the Install Azure Stack HCI wizard.":::

    > [!NOTE]
    > The installation process restarts the operating system twice to complete the process, and displays notices on starting services before opening an Administrator command prompt.

1. At the Administrator command prompt, select **Ok** to change the user's password before signing in to the operating system, and press **Enter**.

    :::image type="content" source="../media/operating-system/azure-stack-hci-change-admin-password.png" alt-text="Screenshot of the change password prompt.":::

1. At the **Enter new credential** for Administrator prompt, enter a new password. Enter the password again to confirm it, and then press **Enter**.

1. At the **Your password has been changed** confirmation prompt, press Enter.

    :::image type="content" source="../media/operating-system/azure-stack-hci-admin-password-changed.png" alt-text="Screenshot of the changed password confirmation prompt.":::

Now you're ready to use the Server Configuration tool (SConfig) to perform important tasks. To use *SConfig*, log on to the server running the Azure Stack HCI operating system. This could be locally via a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. The *SConfig* tool opens automatically when you log on to the server.

:::image type="content" source="../media/operating-system/azure-stack-hci-sconfig-screen.png" alt-text="Screenshot of the Server Configuration tool interface." lightbox="../media/operating-system/azure-stack-hci-sconfig-screen.png":::

## Configure the operating system using SConfig

You can use [*SConfig*](https://www.powershellgallery.com/packages/SCONFIG/2.0.1)to configure Azure Stack HCI version 22H2 after installation as follows:

1. Make sure that Windows updates won't be downloaded and installed during the deployment.

1. Configure networking as per your environment.

1. Configure a default valid gateway and a DNS server.

1. Rename the server(s) using option 2 in *SConfig* to match what you have used when preparing Active Directory, as you won't rename the servers later.

1. Restart the servers.

1. Set the local administrator credentials to be identical across all servers.

1. Install the latest drivers and firmware as per the instructions provided by your hardware manufacturer. You can use *SConfig* to run driver installation apps. After the install is complete, restart your servers again.

## Install required Windows roles

1. Install the Hyper-V role. Run the following command:

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

    1. Enable ICMP. This command is required for the other nodes to access the first node.

        ```azurepowershell
        netsh advfirewall firewall add rule name="ICMP Allow incoming V4 echo request" protocol=icmpv4:8,any dir=in action=allow
        ```



## Next steps

[Set up the first server in your Azure Stack HCI cluster](deployment-tool-set-up-first-server.md).
