---
title: Manage Trusted launch for Azure Local VM enabled by Azure Arc guest state protection key
description: Learn how to manage a Trusted launch for Azure Local VM enabled by Azure Arc guest state protection key.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.reviewer: alkohli
ms.date: 03/27/2025
---

# Manage backup and recovery of Trusted launch for Azure Local VMs enabled by Azure Arc

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manually back up and restore a Trusted launch for Azure Local VM enabled by Azure Arc.

Unlike standard Azure Local VMs, Trusted launch for Azure Local VMs use a VM guest state protection (GSP) key to protect the VM guest state, including the virtual TPM (vTPM) state, while at rest. The VM GSP key is stored in a local key vault in the Azure Local system where the VM resides.

Trusted launch for Azure Local VMs store the VM guest state in two files, VM Guest state (VMGS) and VM Runtime state (VMRS). If the VM GSP key is lost, you can't boot up a Trusted launch for Azure Local VM.

It is important that you back up your Trusted launch for Azure Local VM periodically, so you can recover your VM in the event of a data loss. To back up a Trusted launch VM, back up all the VM files, including VMGS and VMRS files. Additionally, back up the VM GSP key to a backup key vault.

Similarly, to restore a Trusted launch for Azure Local VM to a target Azure Local system, restore all the VM files, including VMGS and VMRS files. Additionally, restore the VM GSP key from the backup key vault to another key vault on the target Azure Local system.

The following sections describe how you can back up the Trusted launch for Azure Local VM and restore it in the event of a data loss.

## Back up the VM

You can use [Export-VM](/powershell/module/hyper-v/export-vm) to obtain a copy of all the VM files, including VMGS and VMRS files, for your Trusted launch for Azure Local VM. You can then back up those VM files.

Follow these steps to copy the VM GSP key from the key vault on the Azure Local system (where the VM resides) to a backup key vault on a different Azure Local system:


### 1. On the Azure Local system with the backup key vault

Run the following commands on the Azure Local system with the backup key vault.

1. Create a wrapping key in the backup key vault.

    ```azurecli
    New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048
    ```

1. Download the Privacy Enhanced Mail (PEM) file.

    ```azurecli
    Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem
    ```

### 2. On the Azure Local system where the VM resides

Run the following commands on the Azure Local system.

1. Copy the PEM file to the Azure Local system.

1. Confirm the owner node of the VM.

    ```azurecli
    Get-ClusterGroup <VM name>
    ```

1. Run the following cmdlet on the owner node to determine the VM ID.

    ```azurecli
    (Get-VM -Name <VM name>).vmid
    ```

1. Export the GSP key for the VM.

    ```azurecli
    Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256
    ```

### 3. On the Azure Local system with the backup key vault

Run the following steps on the Azure Local system.

1. Copy the `<VM ID>` and `<VM ID>.json` file to the Azure Local system.

1. Import the GSP key for the VM to the backup key vault.

    ```azurecli
    Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
    ```

## Restore the VM

In the event of a data loss, use the backup copy of your VM files, and restore the VM to a target Azure Local system using [Import-VM](/powershell/module/hyper-v/import-vm). This restores all the VM files, including VMGS and VMRS files.

Follow these steps to copy the VM GSP key from the backup key vault in the Azure Local system (where the backup copy of the VM GSP key was stored) to the key vault on the target Azure Local system (where the VM needs to be restored).

> [!NOTE]
> Trusted launch for Azure Local VMs restored on an alternate Azure Local system (different from the Azure Local system where the VM originally resided) can't be managed from the Azure control plane.


### 1. On the source Azure Local system where the VM needs to be restored

Run the following commands on the Azure Local system.

1. Create a wrapping key in the key vault.

    ```azurecli
    New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048
    ```

1. Download the Privacy Enhanced Mail (PEM) file.

    ```azurecli
   Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem
    ```

### 2. On the Azure Local system with the backup key vault

Run the following commands on the Azure Local system.

1. Copy the PEM file to the Azure Local system.

1. Get the `<VM ID>` from the VM files stored on disk (wherever this is located). There will be a VM config file (.xml) that has the `<VM ID>` as its name. You can also use the following command to obtain the `<VM ID>` if you know the VM name. You need to do this step on a Hyper-V host that has the VM files.

    ```azurecli
    (Get-VM -Name <VM name>).vmid
    ```

1. Export the VM GSP key for the VM.

    ```azurecli
    Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256
    ```

### 3. On the Azure Local system where the VM needs to be restored

Run the following commands from the target Azure Local system.

1. Copy the `<VM ID>` and `<VM ID>.json` file to the Azure Local system.

1. Import the VM GSP key for the VM.

    ```azurecli
    Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
    ```

    > [!NOTE]
    > Restore the VM GSP key (complete the steps above) before you start the VM on the Azure Local system (where the VM needs to be restored). This ensures that the VM uses the restored VM GSP key. Otherwise, the VM creation fails, and a new VM GSP key is created by the system. If this happens by mistake (human error), delete the VM GSP key and then repeat the steps to restore the VM GSP key.

    ```azurecli
    Remove-MocKey -name <vm id> -group AzureStackHostAttestation -keyvaultName > AzureStackTvmKeyVault
    ```

## Next steps

- [Manage VM extensions](virtual-machine-manage-extension.md).
