---
title: Add a custom VM image to Azure Stack | Microsoft Docs
description: Learn how to add or remove a custom VM image to Azure Stack.
services: azure-stack
documentationcenter: ''
author: Justinha
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: PowerShell
ms.topic: conceptual
ms.date: 10/16/2019
ms.author: Justinha
ms.reviewer: kivenkat
ms.lastreviewed: 06/08/2018

---
# Add a custom VM to Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

In Azure Stack, you can add your custom virtual machine (VM) image to the marketplace and make it available to your users. Images are added by using Azure Resource Manager templates for Azure Stack. You can also add VM images to the Azure Marketplace UI as a marketplace item using the administrator portal or Windows PowerShell. Use either an image from the global Azure Marketplace, or your own custom VM image.

## Generalize the VM image

### Windows

Create a custom generalized VHD. If the VHD is from outside Azure, follow the steps in [Upload a generalized VHD and use it to create new VMs in Azure](/azure/virtual-machines/windows/upload-generalized-managed) to correctly **Sysprep** your VHD and make it generalized.

If the VHD is from Azure, follow the instructions in [Generalize the source VM by using Sysprep](/azure/virtual-machines/windows/upload-generalized-managed#generalize-the-source-vm-by-using-sysprep) before porting it to Azure Stack.

### Linux

If the VHD is from outside Azure, follow the appropriate instructions to generalize the VHD:

- [CentOS-based Distributions](/azure/virtual-machines/linux/create-upload-centos?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Debian Linux](/azure/virtual-machines/linux/debian-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Red Hat Enterprise Linux](/azure/azure-stack/azure-stack-redhat-create-upload-vhd)
- [SLES or openSUSE](/azure/virtual-machines/linux/suse-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Ubuntu Server](/azure/virtual-machines/linux/create-upload-ubuntu?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)

If the VHD is from Azure, follow these instructions to generalize the VHD:

1. Stop the **waagent** service:

   ```bash
   # sudo waagent -force -deprovision
   # export HISTSIZE=0
   # logout
   ```

2. Shut down the VM and download the VHD. If you are bringing your VHD from Azure, you can do this using disk export, as shown in [Download a Windows VHD from Azure](/azure/virtual-machines/windows/download-vhd).

Keep in mind the Azure Linux Agent versions that work with Azure Stack [as documented here](azure-stack-linux.md#azure-linux-agent). Make sure that the sysprepped image has an Azure Linux agent version that is compatible with Azure Stack.

### Common steps for both Windows and Linux

Before you upload the image, it's important to consider the following:

- Azure Stack only supports generating one (1) VM in the fixed disk VHD format. The fixed-format structures the logical disk linearly within the file, so that disk offset *X* is stored at blob offset *X*. A small footer at the end of the blob describes the properties of the VHD. To confirm if your disk is fixed, use the **Get-VHD** PowerShell cmdlet.

- Azure Stack does not support dynamic disk VHDs. Resizing a dynamic disk that's attached to a VM will leave the VM in a failed state. To mitigate this issue, delete the VM without deleting the VM's disk, a VHD blob in a storage account. Then, convert the VHD from a dynamic disk to a fixed disk and re-create the VM.

## Add a VM image as an Azure Stack operator using the portal

1. Images must be able to be referenced by a blob storage URI. Prepare a Windows or Linux operating system image in VHD format (not VHDX), and then upload the image to a storage account in Azure or Azure Stack.

   - If the VHD is in Azure, you can use a tool such as [Azcopy](/azure/storage/common/storage-use-azcopy) to directly transfer the VHD between an Azure and your Azure Stack storage account if you are running on a connected Azure Stack.

   - On a disconnected Azure Stack, if your VHD is in Azure, you will need to download the VHD to a machine that has connectivity to both Azure and Azure Stack. Then you copy the VHD to this machine from Azure before you transfer the VHD to Azure Stack using any of the common [storage data transfer tools](../user/azure-stack-storage-transfer.md) that can be used across Azure and Azure Stack.

2. You can follow [this example](/powershell/module/azurerm.compute/add-azurermvhd?view=azurermps-6.13.0) to upload a VHD to a storage account in the Azure Stack Administrator portal.

   - It is more efficient to upload an image to Azure Stack blob storage than to Azure blob storage because it takes less time to push the image to the Azure Stack image repository.

   - When you upload the [Windows VM image](https://azure.microsoft.com/documentation/articles/virtual-machines-windows-upload-image/), make sure to switch the **Login to Azure** step with the [Configure the Azure Stack operator's PowerShell environment](azure-stack-powershell-configure-admin.md) step.  

3. Make a note of the blob storage URI where you upload the image. The blob storage URI has the following format:
     *&lt;storageAccount&gt;/&lt;blobContainer&gt;/&lt;targetVHDName&gt;*.vhd.

4. To make the blob anonymously accessible, go to the storage account blob container where the VM image VHD was uploaded. Select **Blob**, and then select **Access policy**. Optionally, you can generate a shared access signature for the container, and include it as part of the blob URI. This step makes sure the blob is available to be used. If the blob isn't anonymously accessible, the VM image will be created in a failed state.

   ![Go to storage account blobs](./media/azure-stack-add-vm-image/image1.png)

   ![Set blob access to public](./media/azure-stack-add-vm-image/image2.png)

5. Sign in to Azure Stack as operator. In the menu, select **All services** > **Images** under **Compute** > **Add**.

6. Under **Create image**, enter the Name, Subscription, Resource Group, Location, OS disk, OS type, storage blob URI, Account type, and Host caching. Then, select **Create** to begin creating the VM image.

   ![Begin to create the image](./media/azure-stack-add-vm-image/image4.png)

   When the image is successfully created, the VM image status changes to **Succeeded**.

7. When you add an image, it is only available for Azure Resource Manager-based templates and PowerShell deployments. To make an image available to your users as a marketplace item, publish the marketplace item using the steps in the article [Create and publish a Marketplace item](azure-stack-create-and-publish-marketplace-item.md). Make sure you note the **Publisher**, **Offer**, **SKU**, and **Version** values. You will need them when you edit the resource manager template and Manifest.json in your custom .azpkg.

## Remove the VM image as an Azure Stack operator using the portal

1. Open the Azure Stack [administrator portal](https://adminportal.local.azurestack.external).

2. If the VM image has an associated Marketplace item, select **Marketplace management**, and then select the VM marketplace item you want to delete.

3. If the VM image does not have an associated Marketplace item, navigate to **All services > Compute > VM Images**, and then select the ellipsis (**...**) next to the VM image.

4. Select **Delete**.

## Add a VM image as an Azure Stack operator using PowerShell

1. [Install PowerShell for Azure Stack](azure-stack-powershell-install.md).  

2. Sign in to Azure Stack as an operator. For instructions, see [Sign in to Azure Stack as an operator](azure-stack-powershell-configure-admin.md).

3. Open PowerShell with an elevated prompt, and run:

   ```powershell
    Add-AzsPlatformimage -publisher "<publisher>" `
      -offer "<Offer>" `
      -sku "<SKU>" `
      -version "<#.#.#>" `
      -OSType "<OS type>" `
      -OSUri "<OS URI>"
   ```

   The **Add-AzsPlatformimage** cmdlet specifies values used by the Azure Resource Manager templates to reference the VM image. The values include:
   - **publisher**  
     For example: `Canonical`  
     The **publisher** name segment of the VM image that users use when they deploy the image. Don't include a space or other special characters in this field.  
   - **offer**  
     For example: `UbuntuServer`  
     The **offer** name segment of the VM image that users use when they deploy the VM image. Don't include a space or other special characters in this field.  
   - **sku**  
     For example: `14.04.3-LTS`  
     The **SKU** name segment of the VM Image that users use when they deploy the VM image. Don't include a space or other special characters in this field.  
   - **version**  
     For example: `1.0.0`  
     The version of the VM Image that users use when they deploy the VM image. This version is in the format *\#.\#.\#*. Don't include a space or other special characters in this field.  
   - **osType**  
     For example: `Linux`  
     The **osType** of the image must be either **Windows** or **Linux**.  
   - **OSUri**  
     For example: `https://storageaccount.blob.core.windows.net/vhds/Ubuntu1404.vhd`  
     You can specify a blob storage URI for an `osDisk`.  

     For more information, see the PowerShell reference for the [Add-AzsPlatformimage](/powershell/module/azs.compute.admin/add-azsplatformimage) and the [New-DataDiskObject](/powershell/module/Azs.Compute.Admin/New-DataDiskObject) cmdlets.

## Remove a VM image as an Azure Stack operator using PowerShell

When you no longer need the VM image that you uploaded, you can delete it from the Marketplace by using the following cmdlet:

1. [Install PowerShell for Azure Stack](azure-stack-powershell-install.md).

2. Sign in to Azure Stack as an operator.

3. Open PowerShell with an elevated prompt, and run:

   ```powershell  
   Remove-AzsPlatformImage `
    -publisher "<Publisher>" `
    -offer "<Offer>" `
    -sku "<SKU>" `
    -version "<Version>" `
   ```

   The **Remove-AzsPlatformImage** cmdlet specifies values used by the Azure Resource Manager templates to reference the VM image. The values include:
   - **publisher**  
     For example: `Canonical`  
     The **publisher** name segment of the VM image that users use when they deploy the image. Don't include a space or other special characters in this field.  
   - **offer**  
     For example: `UbuntuServer`  
     The **offer** name segment of the VM image that users use when they deploy the VM image. Don't include a space or other special characters in this field.  
   - **sku**  
     For example: `14.04.3-LTS`  
     The **SKU** name segment of the VM Image that users use when they deploy the VM image. Don't include a space or other special characters in this field.  
   - **version**  
     For example: `1.0.0`  
     The version of the VM Image that users use when they deploy the VM image. This version is in the format *\#.\#.\#*. Don't include a space or other special characters in this field.  

     For more info about the **Remove-AzsPlatformImage** cmdlet, see the Microsoft PowerShell [Azure Stack Operator module documentation](/powershell/module/).

## Next steps

- [Create and publish a custom Azure Stack Marketplace item](azure-stack-create-and-publish-marketplace-item.md)
- [Provision a virtual machine](../user/azure-stack-create-vm-template.md)
