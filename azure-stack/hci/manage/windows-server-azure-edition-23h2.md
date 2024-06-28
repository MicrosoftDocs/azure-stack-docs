---
title: Deploy Windows Server Azure Edition VMs on Azure Stack HCI, version 23H2
description: Learn how to deploy Windows Server Azure Edition VMs on Azure Stack HCI, version 23H2 starting with an image in Azure Stack HCI Marketplace or Azure Marketplace.
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 05/31/2024
---

# Deploy Windows Server Azure Edition VMs on Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

The Windows Server Azure Edition operating system can be deployed as a guest virtual machine (VM) on Azure Stack HCI, version 23H2. This article describes how to deploy and hotpatch Windows Server Azure Edition VMs starting with an image in Azure Stack HCI marketplace or an image in Azure Marketplace.

> [!NOTE]
> Both Azure Arc VMs and non-Arc VMs are supported.

Azure Stack HCI is the only on-premises platform to run Windows Server Azure Edition with [Azure Automanage](/azure/automanage/automanage-windows-server-services-overview). Azure Automanage brings new capabilities specifically to Windows Server Azure Edition, including [Hotpatch](/azure/automanage/automanage-hotpatch), [SMB over QUIC](/windows-server/storage/file-server/smb-over-quic), and [Extended network for Azure](/windows-server/manage/windows-admin-center/azure/azure-extended-network).

To upgrade an existing VM to Windows Server Azure Edition, see [Upgrade VMs to Windows Server Azure Edition](upgrade-vm-windows-server-azure-edition.md).

## Considerations

To use Windows Server Azure Edition on your Azure Stack HCI environment, here are a couple of considerations:

- **Azure Stack HCI host version:**  Windows Server Azure Edition can be deployed on Azure Stack HCI, version 23H2.

- **VM licensing:**  Windows Server Azure Edition can be licensed with either:

  - **Windows Server subscription**: Turn on the subscription on your Azure Stack HCI cluster, then choose one of the following options to activate:
    - Apply [AVMA client keys](/windows-server/get-started/automatic-vm-activation#avma-keys) on the guest VM using the `slmgr /ipk <AVMA_key>` command.
    - Apply AVMA client key on every Azure Stack HCI host using the `Set-VMAutomaticActivation <product key>` cmdlet.
    To learn more, see [Activate Windows Server subscription](vm-activate.md#activate-windows-server-subscription).

  - **Bring Your Own License (BYOL)**: If you have a valid Windows Server Datacenter license with active Software Assurance (SA), you can use [AVMA](vm-activate.md#activate-bring-your-own-license-byol-through-avma) or [KMS](/windows-server/get-started/kms-client-activation-keys) for guest activation.

   > [!Tip]
   > If you already have Windows Server Datacenter licenses with active Software Assurance, you can also turn on Windows Server subscription at no additional cost through [Azure Hybrid Benefit](../concepts/azure-hybrid-benefit-hci.md?tabs=azureportal). This is more convenient and allows you to save more.

- **Azure verification for VMs:** You must enable Azure verification for VMs on your cluster. Azure VM verification is an attestation feature on Azure Stack HCI that makes it possible to run supported Azure-exclusive workloads, such as Windows Server Azure Edition. For more information, see [Azure verification for VMs](../deploy/azure-verification.md).

    > [!NOTE]
    > If you are experiencing issues with Windows Server Azure Edition, a member of the Administrator group needs to sign onto the Azure Stack HCI host to perform attestation and provide the proper license. For more information, see the [Troubleshooting](#troubleshooting) section in this article.

## Deploy the OS

Windows Server Azure Edition can be deployed as a guest VM using either an HCI Marketplace VHD image or an [Azure Marketplace](/marketplace/azure-marketplace-overview) VHD image.

## [HCI marketplace image](#tab/hci)

You can provision a Windows Server Azure Edition VM using an Azure Stack HCI Marketplace image in conjunction with [VM provisioning using Azure portal](azure-arc-vm-management-overview.md).

You do this by following these steps:

1. Deploy [Azure Arc VM management](azure-arc-vm-management-overview.md#) on your Azure Stack HCI.

1. Learn about how certain [Azure Marketplace images](virtual-machine-image-azure-marketplace.md) can now be used to create VMs on Azure Stack HCI.

1. Configure a new Azure Stack HCI gallery OS image for Windows Server Azure Edition that links to the corresponding Azure Marketplace OS image.

1. Use the Windows Server Azure Edition HCI gallery OS image to provision a VM.

## [Azure Marketplace image](#tab/azure)

You can provision a Windows Server Azure Edition VM using an Azure Marketplace image using the process described below.

You can run the commands below from the Azure portal using either the Azure Cloud Shell or locally using the Azure CLI.

**Using Azure Cloud Shell:** Make sure you're connected to Azure and are running [Azure Cloud Shell](/azure/cloud-shell/overview) in either a command prompt or in a bash environment.

**Using Azure CLI locally:** Run the [az login](/cli/azure/reference-index?#az-login) command to sign into Azure. Follow any other prompts to finish signing in.

If this is your first time using Azure CLI, install any required extensions as described in [Use extensions with the Azure CLI](/cli/azure/azure-cli-extensions-overview).

Run the [az version](/cli/azure/reference-index?#az-version) command to make sure your client is up to date. If it's out of date, run the [az upgrade](/cli/azure/reference-index?#az-upgrade) command to upgrade to the latest version.

### 1. Download OS image

You can find Windows Server Azure Edition images that are available to download by using the search function in Azure Marketplace in the Azure portal. The example query below has search criteria for Windows Server 2022 Azure Edition Core:

```powershell
az vm image list --all --publisher "microsoftwindowsserver" --offer "WindowsServer" --sku "2022-datacenter-azure-edition-core"
```

This command should return the following example result:

```output
MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition-core:latest
```

### 2. Create a new Azure managed disk

Next, you'll create an Azure managed disk from the image you downloaded from Azure Marketplace.

To create an Azure managed disk:

1. Run the following commands in an Azure command prompt to set the parameters of your managed disk. Make sure to replace the items in brackets with relevant values:

    ```azurecli
        $urn = <URN_of_Marketplace_image> #Example: "MicrosoftWindowsServer:WindowsServer:2022-datacenter-azure-edition-core:latest"
    $diskName = <disk_name> #Name for new disk to be created
    $diskRG = <resource_group> #Resource group that contains the new disk
    ```

1. Run the following commands to create the disk and generate a Serial Attached SCSI (SAS) access URL:

    ```azurecli
    az disk create -g $diskRG -n $diskName --image-reference $urn
    $sas = az disk grant-access --duration-in-seconds 36000 --access-level Read --name $diskName --resource-group $diskRG
    $diskAccessSAS = ($sas | ConvertFrom-Json)[0].accessSas
    ```

### 3. Export VHD to Azure Stack HCI cluster

Next, you'll need to export the VHD you created from the managed disk to your Azure Stack HCI cluster, which will let you create new VMs. Use the following method using a regular web browser or using Azure Storage Explorer.

To export the VHD:

1. Open a browser and go to the SAS URL of the managed disk you created at [Create a new Azure managed disk from the image](/azure/virtual-desktop/azure-stack-hci#create-a-new-azure-managed-disk-from-the-image). You can download the VHD image for the image you downloaded at Azure Marketplace at this URL.

1. Download the VHD image. The process might take several minutes. Make sure the image has fully downloaded before proceeding. If you're running the [azcopy](/azure/storage/common/storage-ref-azcopy) command, you can skip MD5 checksum validation by running this command:

    ```powershell
    azcopy copy "$sas" "destination_path_on_cluster" --check-md5 NoCheck
    ```

### 4. Clean up the disk

When you're done with your VHD, free up space by deleting the managed disk.

To delete the managed disk you created, first revoke access:

```powershell
az disk revoke-access --name $diskName --resource-group $diskRG 
```

Then, delete the disk:

```powershell
az disk delete --name $diskName --resource-group $diskRG --yes
```

### 5. (Optional) Convert to dynamic VHDX

Optionally, you can convert the downloaded VHD to a dynamic VHDX by running the following PowerShell command:

```powershell
Convert-VHD -Path "<path_to_vhd\filename.vhd>" -DestinationPath "destination_path_on_cluster\filename.vhdx" -VHDType Dynamic
```

---

## Using Hotpatch

There are a few important differences using Hotpatch with Azure Edition guest VMs on Azure Stack HCI as compared to using Hotpatch with Azure Edition guest VMs on Azure IaaS.

These differences include the following limitations for using Hotpatch with Azure Edition guest VMs for this Azure Stack HCI release:

- Hotpatch configuration isn't available using Azure Update Manager.
- Hotpatch can't be disabled.
- Automatic Patching orchestration isn't available.

## Troubleshooting

To obtain Azure verification for the Windows Server Azure Edition license, a member of the Administrator group is required to sign onto the host to enable attestation. In this case, run the following command in *FClip.exe* as an administrator in the system context:

```cmd
Schtasks /change /TN "\Microsoft\Windows\Clip\LicenseImdsIntegration" /RU "NT Authority\System"
```

For more information, see [flcip](https://github.com/urbans0ft/fclip) on GitHub.

## Next steps

Learn more about [Azure Automanage for Windows Server](/azure/automanage/automanage-windows-server-services-overview).
