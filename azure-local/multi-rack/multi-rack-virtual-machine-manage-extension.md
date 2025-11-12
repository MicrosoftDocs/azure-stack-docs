---
title: Manage VM extensions on Azure Local VMs for multi-rack deployments (Preview)
description: Learn how to enable guest management and then install and manage extensions on Azure Local VMs via Azure portal for multi-rack deployments (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/07/2025
---

# Manage VM extensions on Azure Local for multi-rack deployments (Preview) 

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to install and manage Azure Local virtual machine (VM) extensions for multi-rack deployments via Azure portal.

The VM extensions for Azure Local VMs enabled by Azure Arc are useful for post-deployment configuration, software installation, or other management tasks. To install VM extensions, you must enable Azure guest management on your Azure Local VMs.

## Supported VM extensions

For a full list of supported VM extensions, see:

- [Supported VM extensions for Windows](/azure/azure-arc/servers/manage-vm-extensions#windows-extensions)
- [Supported VM extensions for Linux](/azure/azure-arc/servers/manage-vm-extensions#linux-extensions)

## Prerequisites

- Access to a VM running on Azure Local with guest management enabled. Guest management is supported on Windows and Linux VMs. For information on how to create a VM, see [Create Azure Local VMs](../manage/create-arc-virtual-machines.md).

## Verify that guest management is enabled

To manage VMs on Azure Local, you must enable guest management on the VMs. When you enable guest management on a VM, an agent is installed on the VM.

You must verify that guest management is enabled on your VMs before you install VM extensions.

> [!NOTE]
> Extensions for domain join are supported only for Windows VMs. You can enable and install these extensions only during VM creation, via the Azure portal. For more information, see [Create Azure Local VMs](../manage/create-arc-virtual-machines.md).

To verify that guest management is enabled:

1. In the Azure portal for your Azure Local resource, go to **Resources** > **Virtual machines**.

1. In the list of VMs, select the VM where you want to install the extension.

1. On the **Overview** pane, under **Properties** > **Configuration**, verify that **Guest management** shows **Enabled**.

   :::image type="content" source="./media/multi-rack-virtual-machine-manage-extension/verify-guest-management-enablement-1.png" alt-text="Screenshot that shows guest management enabled for a selected Azure Local VM." lightbox="./media/multi-rack-virtual-machine-manage-extension/verify-guest-management-enablement-1.png":::

## Add a VM extension

After you verify that guest management is enabled, follow these steps to add a VM extension:

1. In the Azure portal for your Azure Local resource, go to **Resources** > **Virtual machines**.

1. Select your VM, and then go to **Settings** > **Extensions**.

1. On the command bar, select **+ Add**.

    :::image type="content" source="./media/multi-rack-virtual-machine-manage-extension/add-azure-monitor-extension-1.png" alt-text="Screenshot that shows the command to add an extension on the chosen Azure Local VM." lightbox="./media/multi-rack-virtual-machine-manage-extension/add-azure-monitor-extension-1.png":::

1. On the **Install extension** pane, choose from the available extensions. In this example, we'll deploy **Azure Monitor Agent for Windows (Recommended)**.

    :::image type="content" source="./media/multi-rack-virtual-machine-manage-extension/add-azure-monitor-extension-2.png" alt-text="Screenshot that shows the Azure Monitor extension selected for the chosen Azure Local VM." lightbox="./media/multi-rack-virtual-machine-manage-extension/add-azure-monitor-extension-2.png":::

1. Provide the parameters to configure the selected VM extension.

    In this example, you specify if you want to use a proxy for your VM. You also specify corresponding proxy settings, such as proxy server URL and port number.

    :::image type="content" source="./media/multi-rack-virtual-machine-manage-extension/add-azure-monitor-extension-3.png" alt-text="Screenshot that shows the configuration of Azure Monitor Extension installation for the chosen Azure Local VM." lightbox="./media/multi-rack-virtual-machine-manage-extension/add-azure-monitor-extension-3.png":::

1. Select **Review + Create**.

The extension might take a few minutes to install. After the extension is installed, the list refreshes to display the newly installed extension.

## List installed extensions

To list all the VM extensions installed on your Azure Local instance:

1. In the Azure portal for your Azure Local resource, go to **Resources** > **Virtual machines**.

1. Select your VM, and then select **Extensions**.

    The **Extensions** pane shows the list of extensions on your VM.

    :::image type="content" source="./media/multi-rack-virtual-machine-manage-extension/list-virtual-machine-extension-1.png" alt-text="Screenshot that shows the list of installed extensions for the chosen Azure Local VM." lightbox="./media/multi-rack-virtual-machine-manage-extension/list-virtual-machine-extension-1.png":::

## Delete a VM extension

You might want to delete a VM extension if the installation fails or if you no longer need the extension.

1. In the Azure portal for your Azure Local resource, go to **Resources** > **Virtual machines**.

1. Select your VM, and then select **Extensions**.

1. In the list of extensions on your VM, select the extension that you want to delete.

1. On the command bar, select **Uninstall** to delete the extension.

    In this example, **AzureMonitorWindowsAgent** is selected for deletion.

    :::image type="content" source="./media/multi-rack-virtual-machine-manage-extension/uninstall-azure-monitor-extension-1.png" alt-text="Screenshot showing Uninstall selected for the chosen Azure Local VM." lightbox="./media/multi-rack-virtual-machine-manage-extension/uninstall-azure-monitor-extension-1.png":::

Removal of the extension from the list should take a couple of minutes.  

## Related content

- [Enable guest management when creating Azure Local VMs](../manage/create-arc-virtual-machines.md)
- [Troubleshoot VM extension issues](/azure/azure-arc/servers/troubleshoot-vm-extensions)

