---
title: Importing and exporting a VM guest state protection key
description: Learn about importing and exporting a VM guest state protection key on an Azure Stack HCI cluster.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.reviewer: alkohli
ms.date: 11/08/2023
---

# Importing and exporting a VM guest state protection key

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes importing and exporting a VM guest state protection key on an Azure Stack HCI cluster.

A VM guest state protection key is used to protect the VM guest state, like the vTPM state, while at rest in storage. It's not possible to boot up a Trusted launch VM without the guest state protection key. The key is stored in a key vault in the Azure Stack HCI cluster where VM is located.

## Export Trusted launch VM from source cluster and import it to a target cluster

You can export the VM from a source cluster using [Export-VM (Hyper-V)]().

You can import the VM to the target cluster using [Import-VM (Hyper-V)]().

Use the following steps to transfer the VM guest state protection key from source to target cluster:

1. Log in to the key vault on the target Azure Stack HCI cluster:

   ```azurepowershell
   mocctl.exe security login --identity --loginpath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\IgvmAgent\Credentials\AzureStackIgvmAgentMocStackIdentity.yaml
   ```

1. Create a master key in the target key vault:

   ```azurepowershell
   mocctl.exe security keyvault key create --location VirtualMachineLocation --group AzureStackHostAttestation --vault-name AzureStackTvmKeyVault --key-size 2048 --key-type RSA --name master
   ```

1. Download the PEM file:

   ```azurepowershell
   mocctl.exe security keyvault key download --name master  --file-path C:\master.pem --vault-name AzureStackTvmKeyVault
   ```

On the source Azure Stack HCI cluster:

1. Copy the PEM file from target cluster to source cluster.

1. Run the following cmdlet to determine the ID of the VM:

   ```azurepowershell
   (Get-VM  -Name <vmName>).vmid  
   ```

1. Log in to the key vault:

   ```azurepowershell
   mocctl.exe security login --identity --loginpath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\IgvmAgent\Credentials\AzureStackIgvmAgentMocStackIdentity.yaml  
   ```

1. Export the VM guest state protection key for the VM:

   ```azurepowershell
   mocctl.exe security keyvault key export --vault-name AzureStackTvmKeyVault --name <vmID> --wrapping-pub-key-file C:\master.pem  --out-file C:\<vmID>.wrap  
   ```

On the target Azure Stack HCI cluster:

1. Copy the `vmID` and `vmID.wrap` file from the source cluster to the target cluster.

1. Import the VM guest state protection key for the VM.

   ```azurepowershell
   mocctl.exe security keyvault key import --key-file-path C:\<vmID>.wrap --name <vmID> --vault-name AzureStackTvmKeyVault --wrapping-key-name master --key-type AES --key-size 256
   ```
