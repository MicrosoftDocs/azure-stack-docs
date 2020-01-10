---
title: Create a Windows VM with Azure Stack Hub portal | Microsoft Docs
description: Learn how to create a Windows Server 2016 virtual machine (VM) with the Azure Stack Hub portal.
services: azure-stack
author: mattbriggs
manager: femila

ms.service: azure-stack
ms.topic: quickstart
ms.date: 10/02/2019
ms.author: mabrigg
ms.custom: mvc
ms.reviewer: kivenkat
ms.lastreviewed: 01/14/2019
---

# Quickstart: Create a Windows server VM with the Azure Stack Hub portal

Learn how to create a Windows Server 2016 virtual machine (VM) by using the Azure Stack Hub portal.

> [!NOTE]  
> The screenshots in this article are updated to match the user interface that is introduced with Azure Stack Hub version 1808. 1808 adds support for using *managed disks* in addition to unmanaged disks. If you use an earlier version, some images, like disk selection, will be different than what is displayed in this article.  


## Sign in to the Azure Stack Hub portal

Sign in to the Azure Stack Hub portal. The address of the Azure Stack Hub portal depends on which Azure Stack Hub product you're connecting to:

* For the Azure Stack Development Kit (ASDK), go to: https://portal.local.azurestack.external.
* For an Azure Stack Hub integrated system, go to the URL that your Azure Stack Hub operator provided.

## Create a VM

1. Click **+ Create a resource** > **Compute** > **Windows Server 2016 Datacenter - Pay-as-you-use** > **Create**. <br> If you don't see the **Windows Server 2016 Datacenter - Pay-as-you-use** entry, contact your Azure Stack Hub operator and ask that they add it to the marketplace as explained in the [Add the Windows Server 2016 VM image to the Azure Stack Hub marketplace](../operator/azure-stack-create-and-publish-marketplace-item.md) article.

    ![Steps to create a Windows VM in portal](media/azure-stack-quick-windows-portal/image01.png)

2. Under **Basics**, type a **Name**, **User name**, and **Password**. Choose a **Subscription**. Create a **Resource group**, or select an existing one, select a **Location**, and then click **OK**.

    ![Configure basic settings](media/azure-stack-quick-windows-portal/image02.png)

3. Under **Size**, select **D1 Standard**, and then click on **Select**.  

    ![Choose size of VM](media/azure-stack-quick-windows-portal/image03.png)

4. On the **Settings** page, make any desired changes to the defaults.
   - Beginning with Azure Stack Hub version 1808, you can configure **Storage** where you can choose to use *managed disks*. In versions before 1808, only unmanaged disks can be used.  

   ![Configure VM settings](media/azure-stack-quick-windows-portal/image04.png)  

   When your configurations are ready, select **OK** to continue.

5. Under **Summary**, click **OK** to create the VM.
    ![View summary and create VM](media/azure-stack-quick-windows-portal/image05.png)

6. To see your new VM, click **All resources**, search for the VM name, and then select it in the search results.

    ![See VM](media/azure-stack-quick-windows-portal/image06.png)

## Clean up resources

When you're finished using the VM, delete the VM and its resources. To do so, select the resource group on the VM page and click **Delete**.

## Next steps

In this quickstart, you deployed a basic Windows Server VM. To learn more about Azure Stack Hub VMs, continue to [Considerations for VMs in Azure Stack Hub](azure-stack-vm-considerations.md).
