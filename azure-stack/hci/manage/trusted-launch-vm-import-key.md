---
title: Manage Trusted launch Arc VM guest state protection key on Azure Stack HCI, version 23H2 (preview)
description: Learn how to manage a Trusted launch Arc VM guest state protection key on Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.reviewer: alkohli
ms.date: 11/08/2023
---

# Manage Trusted launch Arc VM guest state protection key on Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage a Trusted launch Arc VM guest state protection key on Azure Stack HCI.

A VM guest state protection key is used to protect the VM guest state, like the vTPM state, while at rest in storage. It's not possible to boot up a Trusted launch Arc VM without the guest state protection key. The key is stored in a key vault in the Azure Stack HCI cluster where the VM is located.

> [!NOTE]
> To export a VM from the source cluster, see [Export-VM (Hyper-V)](/powershell/module/hyper-v/export-vm). To import a VM to the target cluster, see [Import-VM (Hyper-V)](/powershell/module/hyper-v/import-vm).

Use the following steps to transfer the VM guest state protection key from the source cluster to the target cluster:

1. Sign in to the key vault on the target Azure Stack HCI cluster, then run the following command:

   ```azurepowershell
   mocctl.exe security login --identity --loginpath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\IgvmAgent\Credentials\AzureStackIgvmAgentMocStackIdentity.yaml
   ```

1. Create a master key in the target key vault by running the following command:

   ```azurepowershell
   mocctl.exe security keyvault key create --location VirtualMachineLocation --group AzureStackHostAttestation --vault-name AzureStackTvmKeyVault --key-size 2048 --key-type RSA --name master
   ```

1. Download the .PEM file:

   ```azurepowershell
   mocctl.exe security keyvault key download --name master  --file-path C:\master.pem --vault-name AzureStackTvmKeyVault
   ```

1. On the source Azure Stack HCI cluster, copy the .PEM file from the target cluster to source cluster.

1. Run the following cmdlet to determine the ID of the VM:

   ```azurepowershell
   (Get-VM  -Name <vmName>).vmid  
   ```

1. Sign in to the key vault:

   ```azurepowershell
   mocctl.exe security login --identity --loginpath C:\ClusterStorage\Infrastructure_1\Shares\SU1_Infrastructure_1\IgvmAgent\Credentials\AzureStackIgvmAgentMocStackIdentity.yaml  
   ```

1. Export the VM guest state protection key for the VM:

   ```azurepowershell
   mocctl.exe security keyvault key export --vault-name AzureStackTvmKeyVault --name <vmID> --wrapping-pub-key-file C:\master.pem  --out-file C:\<vmID>.wrap  
   ```

1. On the target Azure Stack HCI cluster, copy the `vmID` and `vmID.wrap` file from the source cluster to the target cluster.

1. Import the VM guest state protection key for the VM.

   ```azurepowershell
   mocctl.exe security keyvault key import --key-file-path C:\<vmID>.wrap --name <vmID> --vault-name AzureStackTvmKeyVault --wrapping-key-name master --key-type AES --key-size 256
   ```

## Next steps

- [Manage Trusted launch Arc VM guest state protection key](trusted-launch-vm-import-key.md).