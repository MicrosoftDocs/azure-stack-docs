---
title: Join the Azure Stack HCI preview channel
description: How to join the Azure Stack HCI preview channel and install feature updates by using Windows PowerShell or Windows Admin Center.
author: jasongerend
ms.author: jgerend
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/11/2022
---

# Join the Azure Stack HCI preview channel

> Applies to: Azure Stack HCI, version 22H2

The Azure Stack HCI release preview channel is an opt-in program that lets customers install the next version of the operating system before it's officially released. It's intended for customers who want to evaluate new features, system architects who want to build a solution before conducting a broader deployment, or anyone who wants to see what's next for Azure Stack HCI. There are no program requirements or commitments. Preview builds are available via Windows Update using Windows Admin Center or PowerShell.

   > [!WARNING]
   > Azure Stack HCI clusters that are managed by Microsoft System Center should not join the preview channel yet. System Center 2022 (including Virtual Machine Manager, Operations Manager, and other components) supports Azure Stack HCI, version 21H2 which is the current in-market (GA) version. System Center does not yet support further preview versions. See the [System Center blog](https://techcommunity.microsoft.com/t5/system-center-blog/bg-p/SystemCenterBlog) for the latest updates.

   > [!WARNING]
   > Don't use preview builds in production. Preview builds contain experimental pre-release software made available for evaluating and testing only. You might experience crashes, security vulnerabilities, or data loss. Be sure to back up any important virtual machines (VMs) before upgrading your cluster. Once you install a build from the preview channel, the only way to go back is a clean install.

## How to join the preview channel

Before joining the preview channel, make sure that all servers in the cluster are online and that the cluster is [registered with Azure](../deploy/register-with-azure.md).

   > [!IMPORTANT]
   > You must be running version 21H2 to be offered version 22H2.

1. Make sure you have the latest version of Windows Admin Center installed on a management PC or server.

2. Connect to the Azure Stack HCI cluster on which you want to install feature updates and select **Settings** from the bottom-left corner of the screen. Select **Join the preview channel**, then **Get started**.

   :::image type="content" source="media/preview-channel/join-preview-channel.png" alt-text="Select join the preview channel, then Get started" lightbox="media/preview-channel/join-preview-channel.png":::

3. You'll be reminded that preview builds are provided as-is and aren't eligible for production-level support. Select the **I understand** checkbox, then click **Join the preview channel**.

4. You should see a confirmation that you've successfully joined the preview channel and that the cluster is now ready to flight preview builds.

   :::image type="content" source="media/preview-channel/joined-preview-channel.png" alt-text="Your cluster is now ready to flight preview builds" lightbox="media/preview-channel/joined-preview-channel.png":::

   > [!NOTE]
   > If any of the servers in the cluster say **Not configured** for preview builds, try repeating the process.

Once you've joined the preview channel, you're ready to install Azure Stack HCI, 22H2 using either Windows Admin Center or PowerShell.

## Next steps

> [!div class="nextstepaction"]
> [Install Azure Stack HCI, 22H2](../manage/install-preview-version.md)
