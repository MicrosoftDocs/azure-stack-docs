---
title: Manage Trusted launch Arc VM guest state protection key on Azure Local
description: Learn how to manage a Trusted launch Arc VM guest state protection key on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.reviewer: alkohli
ms.date: 02/21/2025
---

# Manage backup and recovery of Trusted launch Arc VMs on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manually backup and restore a Trusted launch Arc VM.

Unlike standard Azure Arc VMs, Trusted launch Arc VMs use a VM guest state protection (GSP) key to protect the VM guest state, including the vTPM state, while at rest. The VM GSP key is stored in a local key vault in the Azure Local system where the VM resides. Trusted launch Arc VMs store the VM guest state in two files: VM Guest state (VMGS) and VM Runtime State (VMRS). If the VM GSP key is lost, it is not possible to boot up a Trusted launch Arc VM.

It is important that you backup your Trusted launch Arc VM periodically, so you can recover your VM in the event of a data loss. To back up a Trusted launch VM, you must backup all the VM files, including VMGS and VMRS files, and additionally backup the VM GSP key to a backup key vault. Similarly, to restore a Trusted launch Arc VM to a target Azure Local system, you must restore all the VM files, including VMGS and VMRS files, and additionally restore the VM GSP key from the backup key vault to the local key vault of the target Azure Local system.

The following section shows how you can back up the Trusted launch Arc VM and restore it in the event of a data loss.

## Back up the VM

You can use Export-VM (Hyper-V) to obtain a copy of all the VM files, including VMGS and VMRS files, for your Trusted launch Arc VM. You can then back up those VM files.
Use the following steps to copy the VM GSP key from the key vault on the Azure Local system (where the VM resides) to a backup key vault on a different Azure Local system:


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

1. Copy the <VM ID> and <VM ID>.json file to the Azure Local system.

1. Import the GSP key for the VM to the backup key vault.

    ```azurecli
    Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
    ```

## Restore the VM

In the event of a data loss, you can use the backup copy of your VM files, and restore the VM to a target Azure Local system using [Import-VM](/powershell/module/hyper-v/import-vm?view=windowsserver2025-ps)(Hyper-V). This will restore all the VM files, including VMGS and VMRS files.
Use the steps below to copy the VM GSP key from the backup key vault in the Azure Local system (where the backup copy of the VM GSP key was stored) to the key vault on the target Azure Local system (where the VM needs to be restored).

Note: Trusted launch Arc VMs restored on an alternate Azure Local system (different from the Azure Local system where the VM originally resided) cannot be managed from the Azure control plane.


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

### 2. On the Azure Local system with the backup key

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
