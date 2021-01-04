---
title: Move a VM from Azure to Azure Stack Hub
description: Learn how to move a VM from Azure to Azure Stack Hub to Azure Stack Hub.
author: mattbriggs
ms.topic: how-to
ms.date: 12/16/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 9/8/2020

# Intent: As an Azure Stack Hub user, I wan to learn about how where to find more information developing solutions.
# Keywords:  migration workload VM from Azure to Azure Stack Hub

---

# Move a VM from Azure to Azure Stack Hub

You can upload a virtual hard drive (VHD) from a virtual machine (VM) created in Azure to your Azure Stack Hub instance.

## Prepare and download your VHD from Azure

Find the section that that is specific to your needs when preparing your VHD.

#### [Windows - Specialized](#tab/win-spec)

- Follow the steps in the article [Create a Windows VM from a specialized disk by using PowerShell](/azure/virtual-machines/windows/create-vm-specialized#prepare-the-vm) to prepare the VHD.
- To deploy VM extensions, make sure that the VM agent .msi available.  
  For information and steps, see [Azure Virtual Machine Agent overview](/azure/virtual-machines/extensions/agent-windows). Make sure the extension is installed on the VM before your move VM. If the VM agent is not present in the VHD, extension deployment will fail. You do not need to set the OS profile while provisioning, or set `$vm.OSProfile.AllowExtensionOperations = $true`.

#### [Windows - Generalized](#tab/win-gen)

::: moniker range="<=azs-1910"
- Follow the instructions in [Download a Windows VHD from Azure](/azure/virtual-machines/windows/download-vhd) to correctly generalize and download the VHD before moving it to Azure Stack Hub.
- When you provision the VM on Azure, use PowerShell. Prepare it without the `-ProvisionVMAgent` flag.
- Remove all VM extensions using the cmdlet from the VM before generalizing the VM in Azure. You can find which VM extensions are installed by going to `Windows (C:) > WindowsAzure > Logs > Plugins`.

Use the Az PowerShell module:

```powershell  
Remove-AzVMExtension -ResourceGroupName winvmrg1 -VMName windowsvm -Name "CustomScriptExtension"
```

Use the AzureRM PowerShell module:

```powershell  
Remove-AzureRmVMExtension -ResourceGroupName winvmrg1 -VMName windowsvm -Name "CustomScriptExtension"
```
::: moniker-end
::: moniker range=">=azs-2002"

Follow the instructions in [Download a Windows VHD from Azure](/azure/virtual-machines/windows/download-vhd) to correctly generalize and download the VHD before moving it to Azure Stack Hub.
::: moniker-end

#### [Linux - Specialized](#tab/lin-spec)

- Before downloading your Linux VM, follow the guidance in the "Prepare VM" section of the article [Create a Linux VM from a custom disk with the Azure CLI](/azure/virtual-machines/linux/upload-vhd#prepare-the-vm)
- Follow the steps in the article [Download a Linux VHD from Azure](/azure//virtual-machines/windows/download-vhd) to prepare and download the VHD.
- For a specialized VHD, make sure to use "attach" semantics using `-CreateOption Attach`. You can find an example in the article [Create a virtual machine using an existing managed OS disk with PowerShell (Windows)](/azure/virtual-machines/scripts/virtual-machines-powershell-sample-create-vm-from-managed-os-disks).

#### [Linux - Generalized](#tab/lin-gen)

1. Stop the **waagent** service:

   ```bash
   sudo waagent -force -deprovision
   export HISTSIZE=0
   logout
   ```

   The Azure Linux Agent versions that work with Azure Stack Hub [are documented here](../operator/azure-stack-linux.md#azure-linux-agent). Make sure that the image on which you have run sysprep has an Azure Linux agent version that is compatible with Azure Stack Hub.

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

   1. You can now move this VHD to Azure Stack Hub.

> [!IMPORTANT]  
> You can find a script in the article [Sample script to upload a VHD to Azure and create a new VM](/azure/virtual-machines/scripts/virtual-machines-windows-powershell-upload-generalized-script) to upload the VHD to an Azure Stack Hub user storage account and create a VM. Make sure to provide `$urlOfUploadedImageVhd` as the Azure Stack Hub storage account+container URL. For a generalized VHD, make sure to use `FromImage` value when setting `-CreateOption FromImage`.

---

## Verify your VHD

[!INCLUDE [Verify VHD](../includes/user-compute-verify-vhd.md)]

## Upload to a storage account

[!INCLUDE [Upload to a storage account](../includes/user-compute-upload-vhd.md)]

## Create the VM

Custom images come in two forms: **specialized** and **generalized**.

### [Specialized](#tab/create-vm-spec)

[!INCLUDE [Create the disk in Azure Stack Hub](../includes/user-compute-create-disk.md)]

### [Generalized](#tab/create-vm-gen)

[!INCLUDE [Create the image in Azure Stack Hub](../includes/user-compute-create-image.md)]
---
## Next steps

[Move a VM to Azure Stack Hub Overview](vm-move-overview.md)
