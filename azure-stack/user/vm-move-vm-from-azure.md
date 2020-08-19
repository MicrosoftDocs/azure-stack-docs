---
title: Move a VM from Azure to Azure Stack Hub
description: Learn how to move a VM from Azure to Azure Stack Hub to Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 8/18/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 8/18/2020

# Intent: As an Azure Stack Hub user, I wan to learn about how where to find more information developing solutions.
# Keywords: Develop solutions with Azure Stack Hub

---

# Move a VM from Azure to Azure Stack Hub

You can add a virtual machine (VM) image from your on-premesis environment. You can create your image as a virtual hard disk (VHD) and upload the image to a storage account in your Azure Stack Hub instance. You can then create a VM from the VHD.

## Get your VHD from Azure

::: moniker range="<=azs-1910"
- When you provision the VM on Azure, use PowerShell and provision it without the `-ProvisionVMAgent` flag.
- Remove all VM extensions using the **Remove-AzureRmVMExtension** cmdlet from the VM before generalizing the VM in Azure. You can find which VM extensions are installed by going to `Windows (C:) > WindowsAzure > Logs > Plugins`.

```powershell
Remove-AzureRmVMExtension -ResourceGroupName winvmrg1 -VMName windowsvm -Name "CustomScriptExtension"
```
::: moniker-end
::: moniker range=">=azs-2002"

Follow the instructions in [this article](/azure/virtual-machines/windows/download-vhd) to correctly generalize and download the VHD before porting it to Azure Stack Hub.
::: moniker-end

#### [Windows - Specialized](#tab/win-spec)

Follow the steps [here](/azure/virtual-machines/windows/create-vm-specialized#prepare-the-vm) to prepare the VHD correctly.

To deploy VM extensions, make sure that the VM agent .msi available [in this article](/azure/virtual-machines/extensions/agent-windows#manual-installation) is installed in the VM before VM deployment. If the VM agent is not present in the VHD, extension deployment will fail. You do not need to set the OS profile while provisioning, or set `$vm.OSProfile.AllowExtensionOperations = $true`.

#### [Windows - Generalized](#tab/win-gen)

Prior to generalizing the VM, make sure of the following:

Before the Azure Stack 1910 release:

- When you provision the VM on Azure, use PowerShell and provision it without the `-ProvisionVMAgent` flag.
- Remove all VM extensions using the **Remove-AzureRmVMExtension** cmdlet from the VM before generalizing the VM in Azure. You can find which VM extensions are installed by going to `Windows (C:) > WindowsAzure > Logs > Plugins`.

```powershell
Remove-AzureRmVMExtension -ResourceGroupName winvmrg1 -VMName windowsvm -Name "CustomScriptExtension"
```

On or after the Azure Stack 1910 release:

- The preceding steps do not apply to VHDs brought from Azure to an Azure Stack Hub that is on or beyond the 1910 release.

Follow the instructions in [this article](/azure/virtual-machines/windows/download-vhd) to correctly generalize and download the VHD before porting it to Azure Stack Hub.

### Windows - Specialized

Follow the steps [here](/azure/virtual-machines/windows/create-vm-specialized#prepare-the-vm) to prepare the VHD correctly.
To deploy VM extensions, make sure that the VM agent .msi available [in this article](/azure/virtual-machines/extensions/agent-windows#manual-installation) is installed in the VM before VM deployment. If the VM agent is not present in the VHD, extension deployment will fail. You do not need to set the OS profile while provisioning, or set `$vm.OSProfile.AllowExtensionOperations = $true`.

#### [Linux - Specialized](#tab/lin-spec)

Specialized VHDs should not be used as the base VHD for a marketplace item. Use generalized VHDs for this. However, specialized VHDs are a good fit for when you need to migrate VMs from on-premises to Azure Stack Hub.

You can use [this guidance](/azure/virtual-machines/linux/upload-vhd#requirements) to prepare the VHD.

> [!IMPORTANT]  
> You can use the following PowerShell example to upload the VHD to an Azure Stack Hub user storage account:

```powershell  
# Provide values for the variables
$resourceGroup = 'myResourceGroup'
$location = 'Orlando'
$storageaccount = 'mystorageaccount'
$storageType = 'Standard_LRS'
$storageaccounturl = 'https://resourcegrpabc.blob.orlando.azurestack.corp.microsoft.com/container'
$localPath = 'C:\Users\Public\Documents\Hyper-V\VHDs\generalized.vhd'
$vhdName = 'myUploadedVhd.vhd'

New-AzResourceGroup -Name $resourceGroup -Location $location
New-AzStorageAccount -ResourceGroupName $resourceGroup -Name $storageAccount -Location $location `
  -SkuName $storageType -Kind "Storage"
$urlOfUploadedImageVhd = ($storageaccounturl + '/' + $vhdName)
Add-AzVhd -ResourceGroupName $resourceGroup -Destination $urlOfUploadedImageVhd `
    -LocalFilePath $localPath
```

For a specialized VHD, make sure to use "attach" semantics using `-CreateOption Attach`, [as in this example](/azure/virtual-machines/scripts/virtual-machines-windows-powershell-sample-create-vm-from-managed-os-disks), to create a VM from this VHD.

### Considerations

Before you upload the image, it's important to consider the following:

- Azure Stack Hub only supports generation 1 VMs in the fixed disk VHD format. The fixed-format structures the logical disk linearly within the file, so that disk offset **X** is stored at blob offset **X**. A small footer at the end of the blob describes the properties of the VHD. To confirm if your disk is fixed, use the **Get-VHD** PowerShell cmdlet.

- Azure Stack Hub does not support dynamic disk VHDs.

#### [Linux - Generalized](#tab/lin-gen)

If the VHD is from Azure, follow these instructions to generalize and download the VHD:

1. Stop the **waagent** service:

   ```bash
   sudo waagent -force -deprovision
   export HISTSIZE=0
   logout
   ```

   The Azure Linux Agent versions that work with Azure Stack Hub [are documented here](../operator/azure-stack-linux.md#azure-linux-agent). Make sure that the sysprepped image has an Azure Linux agent version that is compatible with Azure Stack Hub.

2. Stop deallocate the VM.

3. Download the VHD.

   1. To download the VHD file, generate a shared access signature (SAS) URL. When the URL is generated, an expiration time is assigned to the URL.

   1. On the menu of the blade for the VM, select **Disks**.

   1. Select the operating system disk for the VM, and then select **Disk Export**.

   1. Set the expiration time of the URL to 36000.

   1. Select **Generate URL**.

   1. Generate the URL.

   1. Under the URL that was generated, select **Download the VHD file**.

   1. You might need to select **Save** in the browser to start the download. The default name for the VHD file is **abcd**.

   1. You can now port this VHD to Azure Stack Hub.

> [!IMPORTANT]  
> You can find a script in the article [Sample script to upload a VHD to Azure and create a new VM](/azure/virtual-machines/scripts/virtual-machines-windows-powershell-upload-generalized-script) to upload the VHD to an Azure Stack Hub user storage account and create a VM. Make sure to provide `$urlOfUploadedImageVhd` as the Azure Stack Hub storage account+container URL. For a generalized VHD, make sure to use `FromImage` value when setting `-CreateOption FromImage`.

---

## Upload to a storage account

[!INCLUDE [Upload to a storage account](../includes/user-compute-upload-vhd.md)]

## Create the image in Azure Stack Hub

[!INCLUDE [Create the image in Azure Stack Hub](../includes/user-compute-create-image.md)]

## Next steps

[DIntroduction to Azure Stack Hub VMs](azure-stack-compute-overview.md)
