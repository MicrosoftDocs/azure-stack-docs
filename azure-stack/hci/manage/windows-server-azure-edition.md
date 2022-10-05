---
title: Windows Server Azure Edition for new VMs
description: Learn about Windows Server Azure Edition for new VMs.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/05/2022
---

# Windows Server Azure Edition for new VMs

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

Azure Stack HCI is the only on-premise platform to run Windows Server Azure Edition and its unique [Automanage](/azure/automanage.md) features like [Hotpatch](/azure/automanage/automanage-hotpatch.md) and [SMB over QUIC](/windows-server/storage/file-server/smb-over-quic.md). Azure Automanage brings new capabilities specifically to Windows Server Azure Edition, including Hotpatch, SMB over QUIC, and Extended network for Azure.

**[*TODO: Azure benefits here*]**

To use Windows Server Azure Edition on your Azure Stack HCI environment, here are a couple of considerations:

- **Azure Stack HCI host version:**  Windows Server Azure Edition can be deployed only on Azure Stack HCI version 21H2 and Azure Stack HCI version 22H2.

- **VM licensing:**  Windows Server Azure Edition can be licensed with a Windows Server subscription, or with Software Assurance.  For more information, see **[*TODO: link to licensing details*]**.

>[!NOTE]
>While Windows Server Azure Edition and Hotpatch are available on the Azure public cloud (Azure IaaS), this experience is in preview for Azure Stack HCI.

## Deploy the OS

The Windows Server Azure Edition OS can be deployed as a guest virtual machine (VM) using the HCI Marketplace GUI option, or using the IaaS Marketplace manual [azcopy](/azure/storage/common/storage-ref-azcopy.md) option.

### Provision a VM

You can provision a Windows Server Azure Edition VM directly from Azure Marketplace using **[Azure Marketplace integration (preview)][TODO: link from HCI marketplace team]** in conjunction with VM provisioning using Azure Portal on Azure Stack HCI by following these steps:

1. Deploy [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview.md).
1. Enable [Azure Marketplace](/marketplace/azure-marketplace-overview.md) integration.
1. Configure a new Azure Stack HCI gallery OS image for Windows Server Azure Edition that links to the corresponding Azure Marketplace OS image.
1. Use the Windows Server Azure Edition HCI gallery OS image to provision a VM.

### 1. Download the OS image

You can download a Windows Server Azure Edition VHD image from Azure Marketplace, then use the VHD image to provision and deploy a VM.  Complete the instructions in the following sections in order.

You can run the commands below from Azure Portal using Azure Cloud shell, or locally using the Azure CLI.

- **Using Azure Cloud shell:** Make sure you're connected to Azure and are running [Azure Cloud Shell](/azure/cloud-shell/overview.md) in either a command prompt or in the bash environment.

- **Using Azure CLI locally:** Run the [az login](/azure/authenticate-azure-cli.md) command to sign into Azure. Follow any other prompts to finish signing in.

    - If this is your first time using Azure CLI, install any required extensions by following the instructions in [Use extensions with the Azure CLI](/cli/azure/azure-cli-extensions-overview.md).

    - Run the az version command to make sure your client is up to date. If it's out of date, run the az upgrade command to upgrade to the latest version.

### 2. Search for OS image

You can find Windows Server Azure Edition images that are available to download by using the search function in Azure Marketplace in the Azure portal. The example query below has search criteria for Windows Server 2022 Azure Edition Core:

```powershell
az vm image list --all --publisher "microsoftwindowsserver" --offer "WindowsServer" --sku "2022-datacenter-azure-edition-core"
```

This command should return the following example result:

```powershell
MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition-core:latest
```

### 3. Create a new Azure managed disk

Next, you'll need to create an Azure managed disk from the image you downloaded from Azure Marketplace.

To create an Azure managed disk:

1. Run the following commands in an Azure command-line prompt to set the parameters of your managed disk. Make sure to replace the items in brackets with relevant values:

    ```powershell
    $urn = <URN_of_Marketplace_image> #Example: "MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition-core:latest"
    $diskName = <disk_name> #Name for new disk to be created
    $diskRG = <resource_group> #Resource group that contains the new disk
    ```

1. Run the following commands to create the disk and generate a Serial Attached SCSI (SAS) access URL:

    ```powershell
    az disk create -g $diskRG -n $diskName --image-reference $urn
    $sas = az disk grant-access --duration-in-seconds 36000 --access-level Read --name $diskName --resource-group $diskRG
    $diskAccessSAS = ($sas | ConvertFrom-Json)[0].accessSas
    ```

### 4. Export VHD to Azure Stack HCI cluster

Next, you'll need to export the VHD you created from the managed disk to your Azure Stack HCI cluster, which will let you create new VMs. Use the following method using a regular web browser or using Azure Storage Explorer.

To export the VHD:

1. Open a browser and go to the SAS URL of the managed disk you generated in **Create a new Azure managed disk from the image**. You can download the VHD image for the image you downloaded at Azure Marketplace at this URL.

1. Download the VHD image. The process may take several minutes, so be patient. Make sure the image has fully downloaded before proceeding. If you’re running the [azcopy](/azure/storage/common/storage-ref-azcopy.md) command, you can skip MD5 checksum validation by running this command:

    ```powershell
    azcopy copy "$sas" "destination_path_on_cluster" --check-md5 NoCheck
    ```

### 5. Clean up your disk

When you're done with your VHD, free up space by deleting the managed disk.

To delete the managed disk you created, first revoke access:

```powershell
az disk revoke-access --name $diskName --resource-group $diskRG 
```

Then, delete the disk:

```powershell
az disk delete --name $diskName --resource-group $diskRG --yes
```

### 6. (Optional) Convert to dynamic VHDX

Optionally, you can convert the downloaded VHD to a dynamic VHDX by running the following PowerShell command :

```powershell
Convert-VHD -Path "<path_to_vhd\filename.vhd>" -DestinationPath "destination_path_on_cluster\filename.vhdx" -VHDType Dynamic
```

## Using Hotpatch

[TODO: Differences between IaaS and HCI; Details about sconfig.]

## Next steps

Learn more about Windows Server Azure Edition.