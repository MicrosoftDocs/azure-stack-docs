---
title: Create a Windows VM with Azure Stack Hub portal 
description: Learn how to create a Windows Server 2016 virtual machine (VM) with the Azure Stack Hub portal.
author: sethmanheim
ms.topic: quickstart
ms.date: 10/4/2021
ms.author: sethm
ms.reviewer: kivenkat
ms.lastreviewed: 10/4/2021
ms.custom: contperf-fy22q2, mode-portal

# Intent: As an Azure Stack user, I want to quickly create a VM using the Azure Stack portal so I can begin using the VM.
# Keyword: azure stack vm windows

---

# Quickstart: Create a Windows server VM with the Azure Stack Hub portal

Learn how to create a Windows Server 2016 virtual machine (VM) by using the Azure Stack Hub portal.

> [!NOTE]  
> If you are looking for instructions to create a Windows VM in global Azure rather than
Azure Stack Hub, see [Quickstart: Create a Windows virtual machine in the Azure portal](/azure/virtual-machines/windows/quick-create-portal).

## Sign in to the Azure Stack Hub portal

Sign in to the Azure Stack Hub user portal. The address of the Azure Stack Hub portal depends on which Azure Stack Hub product you're connecting to:

* For the Azure Stack Development Kit (ASDK), go to: `https://portal.local.azurestack.external`.
* For an Azure Stack Hub integrated system, go to the URL that your Azure Stack Hub operator provided.
* For more information about working with the Azure Stack Hub user portal, see [Use the Azure Stack Hub user portal](azure-stack-use-portal.md).

If you have already created a VM in Azure Stack Hub, you can find best practices, the availability of sizes, and OS disks and images at [Introduction to Azure Stack Hub VMs](azure-stack-compute-overview.md).

## Create a VM

1. Select **Create a resource** > **Compute**. Search for` Windows Server 2016 Datacenter - Pay as you use`.
    If you don't see the **Windows Server 2016 Datacenter - Pay-as-you-use** entry, contact your Azure Stack Hub cloud operator and ask for the image to be added to the Azure Stack Hub Marketplace. For instructions, your cloud operator can refer to [Create and publish a custom Azure Stack Hub Marketplace item](../operator/azure-stack-create-and-publish-marketplace-item.md).

    ![Windows Server 2016 Datacenter - Pay as you use](./media/azure-stack-quick-windows-portal/image1a.png)

1. Select **Create**.

    ![Create a resource](./media/azure-stack-quick-windows-portal/image2a.png)

1. Enter a **Name**, **Disk Type**, **User name**, and **Password** under **Basics**. Choose a **Subscription**. Create a **Resource group**, or select an existing one, select a **Location**, and then select **OK**.

    ![Create a VM - Basics](./media/azure-stack-quick-windows-portal/image3a.png)

1. Select **D1_v2** under **Size**,  and then choose on **Select**.

    ![Create a VM - Size](./media/azure-stack-quick-windows-portal/image4a.png)

1. On the **Settings** page, change the defaults to match your configuration. Configure the public inbound ports from the related drop-down. Then,select **OK**.

    ![Create a VM - Settings](./media/azure-stack-quick-windows-portal/image5a.png)

1. Select **OK** under **Summary** to create the VM.

    ![Create a VM - Summary](./media/azure-stack-quick-windows-portal/image6a.png)

1. Select **Virtual Machines** to review your new VM. Search for the VM name, and then select the VM in the search results.

![Create a VM - Search for VM](./media/azure-stack-quick-windows-portal/image7a.png)

## Clean up resources

When you're finished using the VM, delete the VM and its resources. To do so, select the resource group on the VM page and select **Delete**.

## Next steps

In this quickstart, you deployed a basic Windows Server VM. To learn more about Azure Stack Hub VMs, continue to [Considerations for VMs in Azure Stack Hub](azure-stack-vm-considerations.md).
