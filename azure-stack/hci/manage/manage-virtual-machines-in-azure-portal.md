---
title: Manage virtual machines in Azure portal
description: Learn how to view your cluster in Azure portal and manage virtual machines.
author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/23/2022
---

# View your cluster in Azure portal and manage virtual machines

> Applies to: Azure Stack HCI, version 21H2

IT or cluster administrators can create and manage VMs and the associated disks, network interfaces from the Azure Stack HCI resource page in [Azure portal](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.AzureStackHCI%2Fclusters). The cluster resource page provides links to view & access Azure Arc Resource Bridge and Custom Location associated with the Azure Stack HCI cluster. From the Azure Stack HCI cluster resource page in Portal, admins can provision and manage VMs by navigating to **Virtual Machines** under **Resources** in the left nav on Azure portal. Other Azure Active Directory (AAD) user or groups with **Owner** or **Contributor** access on this subscription will also be able to view, create & manage VMs on this Azure Stack HCI cluster.

For VM management from the Virtual Machines blade in Azure portal, use the following steps:

1. From your browser, go to the [Azure portal](https://portal.azure.com/#blade/HubsExtension/BrowseResource/resourceType/Microsoft.Compute%2FVirtualMachines). You'll see a unified browsing experience for Azure and Arc VMs.

2. Select **Add**, and then select **Azure Arc machine** from the drop-down.

3. Select the Azure subscription and resource group where you want to deploy the VM.

4. Provide the VM name and then select a custom location that your administrator has shared with you.

   > [!IMPORTANT]
   > Names for all entities of a VM should be in lower case and may use "-" and numbers.
   
5. Select an image from the image gallery for the VM you'll create.

6. If you selected a Windows image, provide a username and password for the administrator account. For Linux VMs, provide SSH keys.

7. **(Optional)** Create new or add more disks to the VM by providing a name and size. You can also choose the disk type to be static or dynamic.

8. **(Optional)** Create or add network interface (NIC) cards for the VM by providing a name for the network interface. Then select the network and choose static or dynamic IP addresses.

9. **(Optional)** Add tags to the VM resource if necessary.

10. Review all the properties, and then select **Create**. It should take a few minutes to provision the VM.

## Next steps

Now you're ready to create VMs in Azure portal.

> [!div class="nextstepaction"]
> [Go to Azure portal](https://portal.azure.com/#home)
