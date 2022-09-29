---
title: Windows Server Azure Edition for new VMs
description: Learn about Windows Server Azure Edition for new VMs.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/29/2022
---

# Windows Server Azure Edition for new VMs

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

Azure Stack HCI is the only on-premise platform to run Windows Server Azure Edition and its unique [Automanage](/azure/automanage.md) features like [Hotpatch](/azure/automanage/automanage-hotpatch.md) and [SMB over QUIC](/windows-server/storage/file-server/smb-over-quic.md).

Azure Automanage for Windows Server brings new capabilities specifically to Windows Server Azure Edition, including Hotpatch, SMB over QUIC, and Extended network for Azure.

**[*TODO: Azure benefits here*]**

  >[!NOTE]
  >While Windows Server Azure Edition and Hotpatch are available on the Azure public cloud (Azure IaaS), this experience is in preview for Azure Stack HCI.

## Planning and prerequisites

To use Windows Server Azure Edition on your Azure Stack HCI environment, there are some things to consider:

- **Azure Stack HCI host version:**  Windows Server Azure Edition can be used on Azure Stack HCI version 21H2 and Azure Stack HCI version 22H2.

- **VM licensing:**  Windows Server Azure Edition can be licensed with a Windows Server subscription, or with Software Assurance.  For more information, see **[*TODO: link to licensing details*]**.

## Deploy the OS

The Windows Server Azure Edition OS can be deployed as a guest VM using the HCI Marketplace GUI option, or using the IaaS Marketplace manual [azcopy](/azure/storage/common/storage-ref-azcopy.md) option.

### Provision a VM using HCI Marketplace

You can provision a Windows Server Azure Edition VM directly from Azure Marketplace using **[Azure Marketplace integration (preview)][TODO: link from HCI marketplace team]** in conjunction with VM provisioning using Azure Portal on Azure Stack HCI (preview).

You can do this using the following steps:

1. Deploy Arc Resource Bridge.
1. Enable Azure Marketplace integration.
1. Configure a new HCI gallery image for Windows Server Azure Edition that links to the corresponding Azure Marketplace image.
1. Use Windows Server Azure Edition HCI gallery image to provision a VM.

### Download the OS image

You can download a Windows Server Azure Edition VHD image from Azure Marketplace, then use the VHD image to provision and deploy a VM.  Complete the instructions in the following sections in order.

### Prerequisites

You can run the commands below from Azure Portal using Azure Cloud shell, or locally using the Azure CLI.

- **Using Azure Cloud shell:** Make sure you're connected to Azure and are running [Azure Cloud Shell](/azure/cloud-shell/overview.md) in either a command prompt or in the bash environment.

- **Using Azure CLI locally:** Run the [az login](/azure/authenticate-azure-cli.md) command to sign into Azure. Follow any other prompts to finish signing in.

    - If this is your first time using Azure CLI, install any required extensions by following the instructions in [Use extensions with the Azure CLI](/cli/azure/azure-cli-extensions-overview.md).

    - Run the az version command to make sure your client is up to date. If it's out of date, run the az upgrade command to upgrade to the latest version.

### Search Azure Marketplace for image

You can find Windows Server Azure Edition images that are available to download by using the Search function in Azure Marketplace in the Azure portal. The example query below has search criteria for Windows Server 2022 Azure Edition Core:

```powershell
az vm image list --all --publisher "microsoftwindowsserver" --offer "WindowsServer" --sku "2022-datacenter-azure-edition-core"
```

This command should return the following result:

```powershell
MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition-core:latest
```

### Create a new Azure managed disk from image

Next, you'll need to create an Azure managed disk from the image you downloaded from Azure Marketplace.

To create an Azure managed disk:

1. Run the following commands in an Azure command-line prompt to set the parameters of your managed disk. Make sure to replace the items in brackets with the values relevant to your scenario:

    ```powershell
    $urn = <URN_of_Marketplace_image> #Example: “MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition-core:latest”
    $diskName = <disk_name> #Name for new disk to be created
    $diskRG = <resource_group> #Resource group that contains the new disk
    ```

1. Run the following commands to create the disk and generate a Serial Attached SCSI (SAS) access URL:

    ```powershell
    az disk create -g $diskRG -n $diskName --image-reference $urn
    $sas = az disk grant-access --duration-in-seconds 36000 --access-level Read --name $diskName --resource-group $diskRG
    $diskAccessSAS = ($sas | ConvertFrom-Json)[0].accessSas
    ```

### Export VHD from managed disk to Azure Stack HCI cluster

Next, you'll need to export the VHD you created from the managed disk to your Azure Stack HCI cluster, which will let you create new VMs. Use the following method in a regular web browser or in Azure Storage Explorer.

To export the VHD:

1. Open a browser and go to the SAS URL of the managed disk you generated in **Create a new Azure managed disk from the image**. You can download the VHD image for the image you downloaded at Azure Marketplace at this URL.

1. Download the VHD image. The process may take several minutes, so be patient. Make sure the image has fully downloaded before proceeding. If you’re running the[`azcopy`](/azure/storage/common/storage-ref-azcopy.md) command, you may need to skip the md5check by running this command:

    ```powershell
    azcopy copy “$sas" "destination_path_on_cluster" --check-md5 NoCheck
    ```

### Clean up

When you're done with your VHD, you'll need to free up space by deleting the managed disk.

To delete the managed disk you created, run these commands:

```powershell
az disk revoke-access --name $diskName --resource-group $diskRG 
 az disk delete --name $diskName --resource-group $diskRG --yes
```

### Convert VHD to dynamic VHDx

Optionally, you can convert the downloaded VHD to a dynamic VHDx by running this command in PowerShell on your cluster:

```powershell
Convert-VHD -Path " destination_path_on_cluster\file_name.vhd" -DestinationPath " destination_path_on_cluster\file_name.vhdx" -VHDType Dynamic
```

## Using Hotpatch

[TODO: Differences between IaaS and HCI; Details about sconfig.]

## Next steps

Learn more about Windows Server Azure Edition and Automanage for Windows Server on the Azure public cloud.
