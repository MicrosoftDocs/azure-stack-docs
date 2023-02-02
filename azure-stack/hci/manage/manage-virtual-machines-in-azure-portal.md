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

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

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

    1. **Image** – Select the Marketplace or customer managed image to create the VM image.
    
        1. If you selected a Windows image, provide a username and password for the administrator account. You'll also need to confirm the password.
 
           :::image type="content" source="./media/manage-vm-resources/create-arc-vm-windows-image.png" alt-text="Screenshot showing how to Create a VM using Windows VM image." lightbox="./media/manage-vm-resources/create-arc-vm-windows-image.png":::       

        1. If you selected a Linux image, in addition to providing username and password, you'll also need SSH keys.

           :::image type="content" source="./media/manage-vm-resources/create-arc-vm-linux-vm-image.png" alt-text="Screenshot showing how to Create a VM using a Linux VM image." lightbox="./media/manage-vm-resources/create-arc-vm-linux-vm-image.png":::


    1. **Virtual processor count** – Specify the number of vCPUs you would like to use to create the VM.

    1. **Memory** – Specify the memory in GB for the VM you intend to create.

    1. **Memory type** – Specify the memory type as static or dynamic.

       :::image type="content" source="./media/manage-vm-resources/create-arc-vm.png" alt-text="Screenshot showing how to Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm.png":::
    
    1. **Administrator account** – Specify the username and the password for the administrator account on the VM.
    
    1. **Enable guest management** – Select the checkbox to enable guest management. You can install extensions on VMs where the guest management is enabled.
    
        > [!NOTE]
        > - You can't enable guest management via Azure portal if the Arc VM is already created.
        > - Add at least one network interface through the **Networking** tab to complete guest management setup.
        > - The network interface that you enable, must have a valid IP address and internet access. For more information, see [Network topology and connectivity for Azure Arc-enabled servers](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-arc-servers-connectivity#define-extensions-connectivity-method).

    1. If you selected a Windows VM image, you can domain join your Windows VM. Follow these steps: 
    
        1. Select **Enable domain join**. Azure AD-joined VMs remove the need to have line-of-sight from the VM to an on-premises or virtualized Active Directory Domain Controller or to deploy Azure AD Domain Services.
    
        1. Only the Azure Active Directory is supported and selected by default.  
        
        1. Provide the AD domain join UPN. The UPN user has permissions and is used to join the virtual machines to your domain.
        
        1. Provide the domain administrator password for the virtual machine.

        1. Specify domain or unit. You can join virtual machines to a specific domain or to an organizational unit (OU) and then provide the domain to join and the OU path. 
        
            If not specified, the domain name uses the suffix of the Active Directory domain join UPN by default. For example, the user "azurestackhciuser@contoso.com" would get the default domain name "contoso.com".
        
       :::image type="content" source="./media/manage-vm-resources/create-vm-enable-guest-management.png" alt-text="Screenshot guest management enabled during Create a VM." lightbox="./media/manage-vm-resources/create-vm-enable-guest-management.png":::

1. **(Optional)** Create new or add more disks to the VM by providing a name and size. You can also choose the disk type to be static or dynamic.

1. **(Optional)** Create or add network interface (NIC) cards for the VM by providing a name for the network interface. Then select the network and choose static or dynamic IP addresses.

    > [!NOTE]
    > If you enabled guest management, you must add at least one network interface.

   :::image type="content" source="./media/manage-vm-resources/create-arc-vm-2.png" alt-text="Screenshot of network interface added during Create a VM." lightbox="./media/manage-vm-resources/create-arc-vm-2.png":::

1. **(Optional)** Add tags to the VM resource if necessary.

1. Review all the properties, and then select **Create**. It should take a few minutes to provision the VM.


## Next steps

- [Install and manage VM extensions](./virtual-machine-manage-extension.md).
- [Troubleshoot Arc VMs](troubleshoot-arc-enabled-vms.md).
- [Frequently Asked Questions for Arc VM management](faqs-arc-enabled-vms.md).