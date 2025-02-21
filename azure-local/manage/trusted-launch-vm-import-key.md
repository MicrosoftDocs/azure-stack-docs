---
title: Manage Trusted launch Arc VM guest state protection key on Azure Local
description: Learn how to manage a Trusted launch Arc VM guest state protection key on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.reviewer: alkohli
ms.date: 02/20/2025
---

# Manage Trusted launch Arc VM guest state protection key on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manage a Trusted launch Arc virtual machine (VM) guest state protection (GSP) key on Azure Local.

A VM GSP key is used to protect the VM guest state, like the vTPM state, while at rest in storage. The VM GSP key is stored in a key vault that is local to the Azure Local system where the VM is located.

If there is an unexpected data loss that affects the system, then the VM GSP key stored in the local key vault can be lost. In such a situation, if the VM GSP key is lost, it is not possible to boot up a Trusted launch Arc VM. To avoid this, it is important that you back up the VM GSP key for each of your Trusted launch Arc VMs.

The following section shows how you can back up the VM GSP key and restore it in the event of data loss.

## Back up the VM guest state protection key

Use the following steps to copy the VM GSP key from the key vault on the Azure Local system where the VM resides to a backup key vault on a different Azure Local system.

### 1. On the backup Azure Local system

Run the following commands on the Azure Local system where the backup key vault resides.

1. Create a wrapping key in the backup key vault.

    ```azurecli
    New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048
    ```

1. Download the Privacy Enhanced Mail (PEM) file.

    ```azurecli
    Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem
    ```

### 2. On the source Azure Local system

Run the following commands on the Azure Local system where the VM resides.

1. Copy the PEM file to the Azure Local system.

1. Get and confirm the owner node of the VM.

    ```azurecli
    Get-ClusterGroup <VM name>
    ```

1. On the owner node, get the VM ID for the VM.

    ```azurecli
    (Get-VM -Name <VM name>).vmid
    ```

1. Export the GSP key for the VM.

    ```azurecli
    Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256
    ```

### 1. On the backup Azure Local system

Complete the following steps on the Azure Local system where the backup key vault resides.

1. Copy the VM ID and associated .JSON file to the target Azure Local system.

1. Import the GSP key for the VM to the backup key vault.

    ```azurecli
    Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
    ```

## Restore the VM guest state protection key

In the event of a data loss on your Azure Local system where the GSP key for the Trusted launch VM that is stored in the local key vault is lost, you can restore the GSP key using the backup copy stored in the backup key vault.

Use the steps below to copy the VM GSP key from the backup key vault in the Azure Local system where the backup copy of the VM GSP key is stored to the key vault on the original Azure Local system where the VM needs to be restored.

### 1. On the source Azure Local system

Run the following commands on the Azure Local system where the GSP key needs to be restored to.

1. Create a wrapping key in the key vault.

    ```azurecli
    New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048
    ```

1. Download the Privacy Enhanced Mail (PEM) file.

    ```azurecli
   Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem
    ```

### 1. On the backup Azure Local system

Run the following commands on the Azure Local system where the backup key vault is located.

1. Copy the PEM file to the Azure Local system.

1. Get the VM ID from the VM files stored on disk. There will be a VM XML config file that has the VM ID as its name. You can also use the following command to obtain the VM ID if you know the VM name. Perform this step on a Hyper-V host that has the VM files.

    ```azurecli
    (Get-VM -Name <VM name>).vmid
    ```

1. Export the VM GSP key for the VM.

    ```azurecli
    Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256
    ```

### 1. On the source Azure Local system

Complete the following steps on the Azure Local system where the GSP key needs to be restored to.

1. Copy the VM ID and associated .JSON file to the source Azure Local system.

1. Import the VM GSP key for the VM.

    ```azurecli
    Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
    ```

Complete the steps above before starting the VM. This will ensure that the VM will use the restored VM GSP key. Otherwise, the VM creation will fail, and a new VM GSP key will be created by the system. If VM creation fails, delete the VM GSP key as follows and then repeat steps above to restore the VM GSP key.

```azurecli
Remove-MocKey -name <vm id> -group AzureStackHostAttestation -keyvaultName > AzureStackTvmKeyVault
```

## Next steps

- [Manage VM extensions](virtual-machine-manage-extension.md).
