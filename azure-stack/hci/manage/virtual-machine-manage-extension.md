---
title: Manage VM Extensions on Arc-enabled VMs on Azure Stack HCI (preview)
description: Learn how to enable guest management and then install and manage extensions on Azure Arc-enabled VMs running on Azure Stack HCI via Azure portal (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/01/2023
---

# Manage VM extensions on Azure Stack HCI virtual machines (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to install and manage VM extensions on your Azure Stack HCI via the Azure portal.

The VM extensions on your Azure Arc-enabled VMs on Azure Stack HCI are useful for post-deployment configuration, software installation, or other management tasks. To install VM extensions, you must enable Azure guest management on your Arc-enabled VMs.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Supported VM extensions on Windows

The following VM extensions are supported on Azure Stack HCI VMs.

| Extension       | Publisher  | Type               |
|---------------------|--------------|------------|
| Custom Script Extension | Microsoft.Compute    |CustomScriptExtension|
| Domain Join Extension | Microsoft.Compute    |DomainJoinExtension|


## Supported VM extensions on Linux

The following VM extensions are supported on Azure Stack HCI VMs.

| Extension       | Publisher  | Type               |
|---------------------|--------------|------------|
| Custom Script Extension | Microsoft.Compute    |CustomScriptExtension|


## Prerequisites

Before you install and manage VM extensions, make sure that:

- You’ve access to an Arc-enabled Azure Stack HCI VM that has guest management enabled. Guest management is supported both on Windows and Linux VMs. For more information on how to create an Arc-enabled VM, see [Deploy Arc-enabled VMs on your Azure Stack HCI cluster](./manage-virtual-machines-in-azure-portal.md).

## Verify guest management is enabled

To perform guest OS operations on the Arc-enabled VMs on Azure Stack HCI, you must enable guest management on the VMs. When you enable guest management, an agent is installed on the VM.

You must verify that guest management is enabled on your VMs before you install VM extensions.

> [!NOTE]
> Domain Join extension is only available during VM creation. For more information on how to enable Domain Join extension when creating Arc VMs, see [Create Arc VMs in Azure Stack HCI](../manage/manage-virtual-machines-in-azure-portal.md#create-arc-vms).


Follow these steps to verify that guest management is enabled using the Azure portal.

1. In the Azure portal of your Azure Stack HCI cluster resource, go to **Resources (Preview)** > **Virtual machines**.

1. From the list of the VMs displayed in the right-pane, select the VM where you’ll install the extension.

1. In the **Overview** blade, under **Properties > Configuration**, verify that the **Guest management** shows as **Enabled**.

   :::image type="content" source="./media/virtual-machine-manage-extension/verify-guest-management-enablement-1.png" alt-text="Screenshot showing guest management as enabled in the selected Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/verify-guest-management-enablement-1.png":::


## Add VM extension

After the guest management enablement is verified, you can now add the VM extension.

Follow these steps in Azure portal to add a VM extension.

1. In the Azure portal of your Azure Stack HCI cluster resource, go to **Resources (Preview) > Virtual machines**.

1. Select your VM and go to **Settings > Extensions**.
 
1. From the top of the command bar in the right-pane, select **+ Add**.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-custom-script-extension-1.png" alt-text="Screenshot showing + Add selected to add an extension in the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/add-custom-script-extension-1.png":::

1. In the **Install extension**, choose from the available extensions. In this example, we'll deploy the **Custom Script Extension for Windows - Azure arc**.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-custom-script-extension-2.png" alt-text="Screenshot showing the Custom Script Extension selected in the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/add-custom-script-extension-2.png":::

1. Provide the parameters to configure the selected VM extension. 
    For example, if you choose Custom Script Extension, on the **Create** tab, input the script file and the arguments that you want to execute at runtime.

    Make sure that the script to execute is uploaded in an Azure Storage account and the VM can reach the storage account.

    :::image type="content" source="./media/virtual-machine-manage-extension/add-custom-script-extension-3.png" alt-text="Screenshot showing configuration of Custom Script Extension installation in the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/add-custom-script-extension-3.png":::

1. Select **Review + Create**.

The extension may take a few minutes to install. After the extension is installed, the list refreshes to display the newly installed extension.

## List installed extensions

You can get a list of all the VM extensions installed on your Azure Stack HCI cluster.

Follow these steps in Azure portal to list the installed VM extensions.

1. In the Azure portal of your Azure Stack HCI cluster resource, go to **Resources (Preview) > Virtual machines**.

1. Select your VM and select **Extensions**.
 
1. In the right pane, you can view the list of extensions on your VM.

    :::image type="content" source="./media/virtual-machine-manage-extension/list-virtual-machine-extension-1.png" alt-text="Screenshot showing the list of installed extensions for the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/list-virtual-machine-extension-1.png":::

## Delete VM extension

You may want to delete a VM extension if the installation fails for some reason or if the extension is no longer needed.

> [!NOTE]
> You can remove only Windows VM extensions using this method.

1. In the Azure portal of your Azure Stack HCI cluster resource, go to **Resources (Preview) > Virtual machines**.

1. Select your VM and select **Extensions**.
 
1. From the list of extensions on your VM, choose the extension you wish to remove. From the top command bar, select **Uninstall** to remove the extension.

    In this example, **Custom Script Extension for Windows - Azure arc** is selected.

    :::image type="content" source="./media/virtual-machine-manage-extension/uninstall-custom-script-extension-1.png" alt-text="Screenshot showing Uninstall selected for the chosen Arc-enabled VM." lightbox="./media/virtual-machine-manage-extension/uninstall-custom-script-extension-1.png":::

The extension should take a couple minutes for removal.  


## Next steps

Learn how to:

- [Enable guest management when creating Arc VMs](../manage/manage-virtual-machines-in-azure-portal.md).
- Troubleshoot [VM extension issues](/azure/azure-arc/servers/troubleshoot-vm-extensions).