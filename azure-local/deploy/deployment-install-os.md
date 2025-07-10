---
title: Install Azure Stack HCI operating system, version 23H2
description: Learn how to install the Azure Stack HCI operating system, version 23H2 on each machine of your system.
author: alkohli
ms.topic: how-to
ms.date: 05/29/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Install the Azure Stack HCI operating system

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the steps needed to install the Azure Stack HCI operating system locally on your Azure Local machines.

## Prerequisites

Before you begin, make sure you do the following steps:

- Satisfy the [prerequisites](./deployment-prerequisites.md).
- Prepare your [Active Directory](./deployment-prep-active-directory.md) environment.
- Make sure to keep a password handy to use to sign in to the operating system. This password must conform to the length and complexity requirements. Use a password that is at least 14 characters long and contains a lowercase character, an uppercase character, a numeral, and a special character.

## Boot and install the operating system

To install the operating system, follow these steps:

1. [Download the Azure Stack HCI operating system from the Azure portal](./download-23h2-software.md).

1. Start the **Install Azure Stack HCI** wizard on the system drive of the machine where you want to install the operating system.

1. Select **English (United States)** as the installation language and the time and currency format. Select **Next**, and then on the next page of the wizard, select **Install now**.

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
    > Make sure that the local administrator password follows Azure password length and complexity requirements. Use a password that is at least 14 characters long and contains a lowercase character, an uppercase character, a numeral, and a special character.

    Enter the password again to confirm it, then press **Enter**.

1. At the **Your password has been changed** confirmation prompt, press **Enter**.

   :::image type="content" source="media/deployment-install-os/azure-stack-hci-admin-password-changed.png" alt-text="Screenshot of the changed password confirmation prompt." lightbox="media/deployment-install-os/azure-stack-hci-admin-password-changed.png":::

## Install drivers and firmware

To install the latest drivers and firmware, follow these steps:

1. Install the latest supported drivers and firmware as per the instructions provided by your hardware manufacturer. After the installation is complete, restart your machines.

1. Perform this step only if your hardware partner provides an SBE. Copy the SBE to each machine that you intend to cluster. Place the SBE content at *C:\SBE* to ensure that it is detected and used during deployment. For more information, see [Azure Local solution builder extension](../concepts/system-requirements-23h2.md#hardware-requirements).

Now you're ready to use the Server Configuration tool (SConfig) to perform important tasks.

## Configure the operating system using SConfig

You can use [*SConfig*](https://www.powershellgallery.com/packages/SCONFIG/2.0.1) to configure Azure Stack HCI OS after installation.

To use SConfig, sign in to the machine running the Azure Stack HCI operating system. This could be locally via a keyboard and monitor, or using a remote management (headless or BMC) controller, or Remote Desktop. The SConfig tool opens automatically when you sign in to the machine.

:::image type="content" source="media/deployment-install-os/azure-stack-hci-sconfig-screen.png" alt-text="Screenshot of the Server Configuration tool interface." lightbox="media/deployment-install-os/azure-stack-hci-sconfig-screen.png":::

> [!IMPORTANT]
> - Do not install Windows Updates using SConfig. Updates are installed during the deployment. Installing updates using SConfig causes a deployment failure.
> - Machines must not be joined to Active Directory before deployment.

Follow these steps to configure the operating system using SConfig:

1. Configure networking as per your environment. You can configure the following optional settings:

    - Configure VLAN IDs for the management network. For more information, see [Management VLAN ID](../plan/cloud-deployment-network-considerations.md#management-vlan-id) and [Management VLAN ID with a virtual switch](../plan/cloud-deployment-network-considerations.md#management-vlan-id-with-a-virtual-switch).
    - Configure DHCP for the management network. For more information, see [DHCP IP assignment](../plan/cloud-deployment-network-considerations.md#dhcp-ip-assignment).
    - Configure a proxy server. For more information, see [Configure proxy settings for Azure Local](../manage/configure-proxy-settings-23h2.md).

1. Use the **Network Settings** option in SConfig to configure a default valid gateway and a DNS server. Set **DNS** to the DNS of the domain you're joining.

   > [!IMPORTANT]
   > It is not supported to change the DNS servers after deployment. Make sure you plan your DNS strategy before doing the deployment. For more information, see [DNS Servers Considerations](../plan/cloud-deployment-network-considerations.md#dns-server-considerations).


2. Configure a valid time server on each machine. Validate that your machine is not using the local CMOS clock as a time source, using the following command:

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

   Once the machine is domain joined, it synchronizes its time from the PDC emulator.

3. (Optional) At this point, you can enable Remote Desktop Protocol (RDP) and then RDP to each machine rather than use the virtual console. This action should simplify performing the remainder of the configuration.

4. (Optional) Change the Computer Name as desired. This will be the name shown in the Azure portal as well as your Active Directory environment once joined.

5. Clean all the non-OS drives for each machine that you intend to deploy. Remove any virtual media that have been used when installing the OS. Also validate that no other root drives exist.

    > [!NOTE]
    > This step doesn't apply to a machine repair operation.

6. Restart the machines.

7. Set the local administrator credentials to be identical across all machines.

    > [!NOTE]
    > - Make sure that the local administrator password follows Azure password length and complexity requirements. Use a password that is at least 14 characters long and contains a lowercase character, an uppercase character, a numeral, and a special character.
    > - Do not join the machines with the Azure Stack HCI operating system installed, to the Active Directory domain prior to cloud deployment. The machines are automatically joined to a domain during the [Deployment via Azure portal](./deploy-via-portal.md).

## Install required Windows roles

**This step is only required if you're using an OS ISO that's older than 2408**. For more information, see [What's new in 2408](../whats-new.md#features-and-improvements-in-2408).

Install the Hyper-V role. Run the following command on each machine of the system:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

Your machines will restart; this takes a few minutes.

You are now ready to register the Azure Local machine with Azure Arc and assign permissions for deployment.

## Next steps

- (Optional) [Configure proxy settings for Azure Local](../manage/configure-proxy-settings-23h2.md).
- [Register Azure Local machines in your system with Azure Arc and assign permissions](./deployment-arc-register-server-permissions.md).