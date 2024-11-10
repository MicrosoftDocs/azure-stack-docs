---
title: Manage Trusted launch Arc VM guest state protection key on Azure Local, version 23H2
description: Learn how to manage a Trusted launch Arc VM guest state protection key on Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack-hci
ms.reviewer: alkohli
ms.date: 10/23/2024
---

# Manage Trusted launch Arc VM guest state protection key on Azure Local, version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manage a Trusted launch Arc VM guest state protection key on Azure Local.

A VM guest state protection key is used to protect the VM guest state, like the vTPM state, while at rest in storage. It's not possible to boot up a Trusted launch Arc VM without the guest state protection key. The key is stored in a key vault in the Azure Local system where the VM is located.


## Export and import the VM

The first step is to export the VM from the source Azure Local system and then import it into the target Azure Local system.

1. To export the VM from the source cluster, see [Export-VM (Hyper-V)](/powershell/module/hyper-v/export-vm).

2. To import the VM to the target cluster, see [Import-VM (Hyper-V)](/powershell/module/hyper-v/import-vm).

## Transfer the VM guest state protection key

After you have exported and then imported the VM, use the following steps to transfer the VM guest state protection key from the source Azure Local system to the target Azure Local system:

### 1. On the target Azure Local system

Run the following commands from the target Azure Local system.

1. Sign into the key vault using administrative privileges.

   ```azurepowershell
   mocctl.exe security login --identity --loginpath (Get-MocConfig).mocLoginYAML --cloudFqdn (Get-MocConfig).cloudFqdn
   ```

1. Create a master key in the target key vault. Run the following command.

   ```azurepowershell
   mocctl.exe security keyvault key create --location VirtualMachineLocation --group AzureStackHostAttestation --vault-name AzureStackTvmKeyVault --key-size 2048 --key-type RSA --name master
   ```

1. Download the Privacy Enhanced Mail (PEM) file.

   ```azurepowershell
   mocctl.exe security keyvault key download --name master --file-path C:\master.pem --vault-name AzureStackTvmKeyVault
   ```

### 2. On the source Azure Local system

Run the following commands from the source Azure Local system.

1. Copy the PEM file from the target cluster to the source cluster.

1. Run the following cmdlet to determine the ID of the VM.

   ```azurepowershell
   (Get-VM -Name <vmName>).vmid  
   ```

1. Sign into the key vault using administrative privileges.

   ```azurepowershell
     mocctl.exe security login --identity --loginpath (Get-MocConfig).mocLoginYAML --cloudFqdn (Get-MocConfig).cloudFqdn
   ```

1. Export the VM guest state protection key for the VM.

   ```azurepowershell
   mocctl.exe security keyvault key export --vault-name AzureStackTvmKeyVault --name <vmID> --wrapping-pub-key-file C:\master.pem --out-file C:\<vmID>.json  
   ```

### 3. On the target Azure Local system

Run the following commands from the target Azure Local system.

1. Copy the `vmID` and `vmID.json` file from the source cluster to the target cluster.

1. Import the VM guest state protection key for the VM.

   ```azurepowershell
   mocctl.exe security keyvault key import --key-file-path C:\<vmID>.json --name <vmID> --vault-name AzureStackTvmKeyVault --wrapping-key-name master --key-type AES --key-size 256
   ```

## Next steps

- [Manage VM extensions](virtual-machine-manage-extension.md).
