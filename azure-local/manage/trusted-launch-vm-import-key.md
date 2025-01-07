---
title: Manage Trusted launch Arc VM guest state protection key on Azure Local, version 23H2
description: Learn how to manage a Trusted launch Arc VM guest state protection key on Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack-hci
ms.reviewer: alkohli
ms.date: 01/07/2025
---

# Manage Trusted launch Arc VM guest state protection key on Azure Local, version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manage a Trusted launch Arc VM guest state protection (GSP) key on Azure Local.

A VM GSP key is used to protect the VM guest state, like the vTPM state, while at rest in storage. The VM GSP key is stored in a key vault that is local to the Azure Local cluster where the VM is located. If there is an unexpected data loss that affects the cluster, then the VM GSP key stored in the local key vault can be lost. In such a situation, if the VM GSP key is lost, it is not possible to boot up a Trusted launch Arc VM. To avoid this, it is important that you back up the VM GSP key of each of your Trusted launch Arc VMs.

The following section shows how you can back up the VM GSP key and restore it in the event of data loss.

## Back up the VM guest state protection key

Use the following steps to copy the VM GSP key from the key vault on the Azure Local system where the VM resides to a backup key vault on a different (target) Azure Local system.

### 1. On the source Azure Local system

Run the following commands from the source Azure Local system where the backup key and VM reside.

1. Create a wrapping key in the backup key vault.

    ```azurecli
    New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048
    ```

1. Download the Privacy Enhanced Mail (PEM) file.

    ```azurecli
    Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem
    ```

1. Copy the PEM file to the Azure Local system.

1. Run the following cmdlet to confirm the owner node of the VM:

    ```azurecli
    Get-ClusterGroup <vm_name>
    ```

1. From the owner node, get the VM ID and then export the GSP key for the VM.

    ```azurecli
    (Get-VM -Name <VM name>).vmid
    ```

    ```azurecli
    Export-MocKey -name <vm id> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <vm id>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256
    ```

### 1. On the target Azure Local system

Complete the following steps on the target Azure Local system where the backup key vault resides.

1. Copy the VM ID and associated JSON file to the target Azure Local system.

1. Import the VM GSP key for the VM to the backup key vault.

    ```azurecli
    Import-MocKey -name <vm id> -importKeyFile <vm id>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
    ```

## Restore the VM guest state protection key

In the event of a data loss on your Azure Local system where the VM GSP key for the Trusted launch VM stored in the local key vault is lost, you can restore the VM GSP key using the backup copy stored in the backup key vault.

Use the steps below to copy the VM GSP key from the backup key vault in the source Azure Local system where the backup copy of the VM GSP key is stored to the key vault on the target Azure Local system where the VM needs to be restored.

### 1. On the target Azure Local system

Run the following commands on target the Azure Local system where the VM needs to be restored.

1. Create a wrapping key in the key vault.

    ```azurecli
    New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048
    ```

1. Download the Privacy Enhanced Mail (PEM) file.

    ```azurecli
   Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem
    ```

### 1. On the source Azure Local system

Run the following commands on the source Azure Local system where the backup key vault is located.

1. Copy the PEM file to the Azure Local system.

1. Get the VM ID from the VM files stored on disk. There will be a VM XML config file that has the VM ID as its name. You can also use the following command to obtain the VM ID if you know the VM name. You need to do this step on a Hyper-V host that has the VM files.

    ```azurecli
    (Get-VM -Name <vm name>).vmid
    ```

1. Export the VM GSP key for the VM.

    ```azurecli
    Export-MocKey -name <vm id> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <vm id>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256
    ```

### 1. On the target Azure Local system

Run the following commands from the target Azure Local system where the VM needs to be restored.

1. Copy the VM ID and associated JSON file to the target Azure Local system.

1. Import the VM GSP key for the VM.

    ```azurecli
    Import-MocKey -name <vm id> -importKeyFile <vm id>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
    ```

## Next steps

- [Manage VM extensions](virtual-machine-manage-extension.md).
