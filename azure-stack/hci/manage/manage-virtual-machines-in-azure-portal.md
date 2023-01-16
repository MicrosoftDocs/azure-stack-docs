---
title: Create Arc virtual machines on Azure Stack HCI (preview)
description: Learn how to view your cluster in the Azure portal and create Arc virtual machines on your Azure Stack HCI (preview).
author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/07/2022
---

# Use VM images to create Arc virtual machines on Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article describes how to create an Arc VM starting with the VM images that you've created on your Azure Stack HCI cluster. You can create Arc VMs using the Azure portal.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About Azure Stack HCI cluster resource

You can use the [Azure Stack HCI cluster resource page](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.AzureStackHCI%2Fclusters) for the following operations:

- You can create and manage Arc VM resources such as VM images, disks, network interfaces.
- You can use this page to view and access Azure Arc Resource Bridge and Custom Location associated with the Azure Stack HCI cluster.
- You can also use this page to provision and manage Arc VMs.

The procedure to create Arc VMs is described in the next section.

## Prerequisites

Before you create an Azure Arc-enabled VM, make sure that the following prerequisites are completed.

[!INCLUDE [hci-vm-prerequisites](../../includes/hci-vm-prerequisites.md)]

## Create Arc VMs

Follow these steps in the Azure portal to create an Arc VM on your Azure Stack HCI cluster.

1. Go to **Resources (Preview) > Virtual machines**.
1. From the top command bar, select **+ Create VM**.

   :::image type="content" source="./media/manage-vm-resources/select-create-vm.png" alt-text="Screenshot of select + Create VM." lightbox="./media/manage-vm-resources/select-create-vm.png":::

1. In the **Create an Azure Arc virtual machine** wizard, on the **Basics** tab, input the following parameters:

    1. **Subscription** – The subscription is tied to the billing. Choose the subscription that you want to use to deploy this VM.

    1. **Resource group** – Create new or choose an existing resource group where you'll deploy all the resources associated with your VM.

    1. **Virtual machine name** – Enter a name for your VM. The name should follow all the naming conventions for Azure virtual machines.  
    
        > [!IMPORTANT]
        > VM names should be in lowercase letters and may use hyphens and numbers.

    1. **Custom location** – Select the custom location for your VM. The custom locations are filtered to only show those locations that are enabled for your Azure Stack HCI.

    1. **Image** – Select the Marketplace or customer managed image to create the VM image. If you selected a Windows image, provide a username and password for the administrator account. For Linux VMs, provide SSH keys.

    1. **Virtual processor count** – Specify the number of vCPUs you would like to use to create the VM.

    1. **Memory** – Specify the memory in GB for the VM you intend to create.

    1. **Memory type** – Specify the memory type as static or dynamic.

       :::image type="content" source="./media/manage-vm-resources/create-arc-vm.png" alt-text="Screenshot showing how to Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm.png":::
    
    1. **Administrator account**: Specify the username and the password for the administrator account on the VM. 
    
    1. **Enable guest management** - Select the checkbox to enable guest management. You can install extensions on VMs where the guest management is enabled.
    
        > [!NOTE]
        > - You can't enable guest management via Azure portal if the Arc VM is already created.
        > - Add atleast one network interface through the **Networking** tab to complete guest management setup.

       :::image type="content" source="./media/manage-vm-resources/create-arc-vm-1.png" alt-text="Screenshot guest management enabled during Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm.png":::

1. **(Optional)** Create new or add more disks to the VM by providing a name and size. You can also choose the disk type to be static or dynamic.

1. **(Optional)** Create or add network interface (NIC) cards for the VM by providing a name for the network interface. Then select the network and choose static or dynamic IP addresses.

    > [!NOTE]
    > If you enabled guest management, you must add at least one network interface.

   :::image type="content" source="./media/manage-vm-resources/create-arc-vm-2.png" alt-text="Screenshot of network interface added during Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm-2.png":::


1. **(Optional)** Add tags to the VM resource if necessary.

1. Review all the properties, and then select **Create**. It should take a few minutes to provision the VM.


## Next steps

- [Install and manage VM extensions](./virtual-machine-manage-extension.md)
- [Troubleshoot](troubleshoot-arc-enabled-vms.md)
- [FAQs](faqs-arc-enabled-vms.md)