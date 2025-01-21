---
title: Manage VM Extensions on Azure Arc VMs on Azure Local 
description: Learn how to enable guest management and then install and manage extensions on Azure Arc VMs running on Azure Local via the Azure portal.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack-hci
ms.date: 10/24/2024
---

# Manage VM extensions on Azure Local virtual machines 

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to install and manage virtual machine (VM) extensions on Azure Local via the Azure portal.

The VM extensions on your Azure Arc VMs on Azure Local are useful for post-deployment configuration, software installation, or other management tasks. To install VM extensions, you must enable Azure guest management on your Azure Arc VMs.

## Supported VM extensions

For a full list of supported VM extensions, see:

- [Supported VM extensions for Windows](/azure/azure-arc/servers/manage-vm-extensions#windows-extensions)
- [Supported VM extensions for Linux](/azure/azure-arc/servers/manage-vm-extensions#linux-extensions)

## Prerequisites

- Access to an Azure Arc VM running on Azure Local with guest management enabled. Guest management is supported on Windows and Linux VMs. For information on how to create an Azure Arc VM, see [Create Azure Arc virtual machines on Azure Local](./create-arc-virtual-machines.md).

## Verify that guest management is enabled

To manage VMs on Azure Local, you must enable guest management on the VMs. When you enable guest management, an agent is installed on the VM.

You must verify that guest management is enabled on your VMs before you install VM extensions.

> [!NOTE]
> Domain Join extensions are supported only for Windows VMs. These extensions can only be enabled and installed during VM creation via the Azure portal. For more information on how to enable Domain Join extension when creating Azure Arc VMs, see [Create Azure Arc VMs in Azure Local](./create-arc-virtual-machines.md).

Follow these steps to verify that guest management is enabled using the Azure portal:

1. In the Azure portal of your Azure Local resource, go to **Resources** > **Virtual machines**.

1. From the list of the VMs displayed in the right-pane, select the VM where you'll install the extension.

1. In the **Overview** blade, under **Properties > Configuration**, verify that the **Guest management** shows as **Enabled**.

   :::image type="content" source="./media/virtual-machine-manage-extension/verify-guest-management-enablement-1.png" alt-text="Screenshot showing guest management as enabled in the selected Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/verify-guest-management-enablement-1.png":::

## Add VM extension

After the guest management enablement is verified, you can now add the VM extension.

Follow these steps in Azure portal to add a VM extension.

1. In the Azure portal of your Azure Local resource, go to **Resources > Virtual machines**.

1. Select your VM and go to **Settings > Extensions**.

1. From the top of the command bar in the right-pane, select **+ Add**.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-azure-monitor-extension-1.png" alt-text="Screenshot showing + Add selected to add an extension in the chosen Azure Arc VM." lightbox="./media/virtual-machine-manage-extension/add-azure-monitor-extension-1.png":::

1. In the **Install extension**, choose from the available extensions. In this example, we'll deploy the **Azure Monitor Agent for Windows (Recommended)**.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-azure-monitor-extension-2.png" alt-text="Screenshot showing the Azure Monitor Extension selected in the chosen Azure Arc VM." lightbox="./media/virtual-machine-manage-extension/add-azure-monitor-extension-2.png":::

1. Provide the parameters to configure the selected VM extension.

    In this example, you specify if you want to use proxy for your VM and the corresponding proxy settings such as proxy server URL and port number.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-azure-monitor-extension-3.png" alt-text="Screenshot showing configuration of Azure Monitor Extension installation in the chosen Azure Arc VM." lightbox="./media/virtual-machine-manage-extension/add-azure-monitor-extension-3.png":::

1. Select **Review + Create**.

The extension might take a few minutes to install. After the extension is installed, the list refreshes to display the newly installed extension.

## List installed extensions

You can get a list of all the VM extensions installed on your Azure Local.

Follow these steps in Azure portal to list the installed VM extensions.

1. In the Azure portal of your Azure Local resource, go to **Resources > Virtual machines**.

1. Select your VM and select **Extensions**.

1. In the right pane, you can view the list of extensions on your VM.

    :::image type="content" source="./media/virtual-machine-manage-extension/list-virtual-machine-extension-1.png" alt-text="Screenshot showing the list of installed extensions for the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/list-virtual-machine-extension-1.png":::

## Delete VM extension

You might want to delete a VM extension if the installation fails for some reason or if the extension is no longer needed.

1. In the Azure portal of your Azure Local resource, go to **Resources > Virtual machines**.

1. Select your VM and select **Extensions**.

1. From the list of extensions on your VM, choose the extension you wish to remove. From the top command bar, select **Uninstall** to remove the extension.

    In this example, **AzureMonitorWindowsAgent** is selected.

    :::image type="content" source="./media/virtual-machine-manage-extension/uninstall-azure-monitor-extension-1.png" alt-text="Screenshot showing Uninstall selected for the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/uninstall-azure-monitor-extension-1.png":::

The extension should take a couple minutes for removal.  

## Related content

Learn how to:

- [Enable guest management when creating Azure Arc VMs](./create-arc-virtual-machines.md#create-arc-vms).
- Troubleshoot [VM extension issues](/azure/azure-arc/servers/troubleshoot-vm-extensions).
