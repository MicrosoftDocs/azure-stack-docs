---
title: Manual backup and recovery of VM guest state protection key
description: Learn how to perform a manual backup and recovery of a VM guest state protection key.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.reviewer: alkohli
ms.date: 07/10/2025
---

# Manual backup and recovery of VM guest state protection key

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

You can backup and restore the VM guest state protection key of each Trusted launch VM on an Azure Local instance using one of the following approaches.

**Approach 1** (recommended): Backup/restore VM guest state protection keys to/from a file system folder. You can use this approach starting with Azure Local 2505 release and onwards. If your Azure Local instance uses an earlier Azure Local release, you can instead use approach 2.

**Approach 2**: Backup/restore VM guest state protection keys to/from a key vault in another Azure Local instance. Use this approach only if your Azure Local instance uses an earlier Azure Local release earlier than 2505. 

## Backup and restore VM guest state protection keys using file system folder

To backup, this approach copies VM guest state protection keys from the local key vault of your Azure Local instance to a folder that is backed up periodically. 

To restore, this approach restores VM guest state protection keys from a folder (containing the backup copy) to the local key vault of an Azure Local instance where the VMs need to be restored. 

### Backup

The steps below involve copying VM guest state protection keys from the local key vault of your Azure Local instance to a folder that is backed up periodically. 

> [!NOTE]
> You can only use this approach starting with Azure Local 2505 release and onwards. If your Azure Local instance uses an earlier Azure Local release, you can instead use approach 2.

1. On a secure computer using PowerShell 7, generate a wrapping key:

    ```azurepowershell
    $rsa = [System.Security.Cryptography.RSA]::Create(2048)  

    $privateKeyPem = $rsa.ExportPkcs8PrivateKeyPem() 

    $privateKeyPem | Out-File -FilePath .\private.pem 

    $publicKeyPem = $rsa.ExportRSAPublicKeyPem() 

    $publicKeyPem | Out-File -FilePath .\public.pem
    ```

1. Copy the `.\public.pem` file to your Azure Local instance.

1. Copy VM guest state protection keys from the local key vault of your Azure Local instance to a folder that is backed up periodically:

    1. Download `TvmBackupUtils.psm1` script file on GitHub repo `Azure-Samples/AzureLocal` to your Azure Local instance. 

    1. Run `import-module .\TvmBackupUtils.psm1 -force`.

    1. Run `Backup-TVMKeys -WrappingKeyPath <path to public.pem> -BackupRootPath` (path to backup root folder where the timestamped backup folder will be stored).

1. Make note of the timestamped backup folder created under the backup root folder. You will need this later during recovery.

1. Make sure to periodically backup the backup root folder.

### Restore

The steps below involve restoring VM guest state protection keys from a folder (containing the backup copy) to the local key vault of an Azure Local instance where the VMs need to be restored.

> [!NOTE]
> You can only use this approach starting Azure Local 2505 release and onwards. If your Azure Local instance is on an earlier Azure Local release, you can instead use approach 2.

1. Copy both private and public key files for the wrapping key (which you had created during backup step 1) to the Azure Local instance.  

1. Copy the timestamped backup folder to the Azure Local instance. Pick the folder (under the backup root folder) with the latest timestamp as that folder will have the most recent copy.

    > [!NOTE]
    >Don't modify the backup folder.

1. Import the wrapping key (which you had created during backup step 1) to the Azure Local instance:

    1. Download the `TvmBackupUtils.psm1` script file (link to file on GitHub repo Azure-Samples/AzureLocal: Contains scripts, code samples, for Azure Stack HCI) to your Azure Local instance.

    1. Run `Import-Module .\TvmBackupUtils.psm1 -force`.

    > [!NOTE]
    > Make sure the WrappingKeyName you specify does not match the name of a key already existing in the backup (timestamped backup folder). Otherwise, this will cause a failure during import (restore step 4).

    1. Run `Import-TvmWrappingKeyFromPem -KeyName <WrappingKeyName>  -PublicKeyPath <path to public.pem> -PrivateKeyPath <path to private.pem> -KeySize <size of key generated 2048>`

1. Restore the keys from backup:

    `Import-TVMKeys -WrappingKeyName  <WrappingKeyName> -BackupPath <path to timestamped backup folder>`.

    > [NOTE!]
    > If the local key vault of the Azure Local instance already has a VM guest state protection key with the same name, you will receive an InvalidVersion error for that key. You can ignore this, as the key is already in the key vault. 

1. Cleanup files and keys

    1. Delete both public.pem and private.pem files from the Azure Local instance. 

    > [!IMPORTANT]  
    > Remove the wrapping key from the local key vault of the Azure Local instance using Remove-MocKey. This will help avoid collisions later. 

    1. Run `Remove-MocKey -name WrappingKeyName -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault`.

    > [!NOTE]
    > You should start a VM on the Azure Local instance only after you have successfully restored both its VM files and its VM guest state protection key. If you had inadvertently attempted to start a VM before restoring its VM guest state protection key, you must delete the AzureStackTvmAKRootKey (which would have been auto generated) from the local key vault of the Azure Local instance. 

    1. Run `Remove-MocKey -name  AzureStackTvmAKRootKey  -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault`.

## Backup or restore VM guest state protection keys via a key vault in another Azure Local instance

To backup, this approach copies VM guest state protection keys from the local key vault of your Azure Local instance to the local key vault (backup key vault) of another Azure Local instance (which is used for key backup purposes). 

To restore, this approach restores VM guest state protection keys from the local key vault (backup key vault) of the Azure Local instance (which is used for key backup purposes) to the local key vault of an Azure Local instance where the VMs need to be restored.

### Backup

Follow these steps to copy the VM guest state protection key from the local key vault of the Azure Local instance (where the VM resides) to a backup key vault on another Azure Local instance:

1. On the Azure Local system with the backup key vault, run the following commands on the Azure Local system with the backup key vault:

    1. Create a wrapping key in the backup key vault:

        `New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048` 

    1. Download the Privacy Enhanced Mail (PEM) file:

        `Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem`

1. On the Azure Local system where the VM resides, run the following commands on the Azure Local system:

    1. Copy the PEM file to the Azure Local system.

    1. Confirm the owner node of the VM:

        `Get-ClusterGroup <VM name>`

1. Run the following cmdlet on the owner node to determine the VM ID:

    1. `(Get-VM -Name <VM name>).vmid`

    1. Export the VM guest state protection key:

        `Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256` 

1. On the Azure Local system with the backup key vault, run the following steps on the Azure Local system:

    1. Copy the `VM ID` and `VM ID`.json file to the Azure Local system.

    1. Import the VM guest state protection key to the backup key vault:

        `Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256`. 

### Restore

Follow these steps to copy the VM guest state protection key from the backup key vault of the Azure Local instance (which was used for key backup purposes) to the local key vault of the target Azure Local system (where the VM needs to be restored):

1. On the source Azure Local system where the VM needs to be restored, run the following commands on the Azure Local system:

    1. Create a wrapping key in the key vault:

        `New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048`

    1. Download the Privacy Enhanced Mail (PEM) file:

        `Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem`

1. On the Azure Local system with the backup key vault, run the following commands on the Azure Local system. 

    1. Copy the PEM file to the Azure Local system. 

    1. Get the `VM ID` from the VM files stored on disk (wherever this is located). There will be a VM config file (.xml) that has the `VM ID` as its name. You can also use the following command to obtain the `VM ID` if you know the VM name. You need to do this step on a Hyper-V host that has the VM files.

        `(Get-VM -Name <VM name>).vmid`

    1. Export the VM guest state protection key.

        `Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256`.

1. On the Azure Local system where the VM needs to be restored, run the following commands from the target Azure Local system:

    1. Copy the `VM ID` and `VM ID`.json file to the Azure Local system.

    1. Import the VM guest state protection key:

        `Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256`.

        > [!NOTE]
        > Restore the VM guest state key (complete the steps above) before you start the VM on the Azure Local instance (where the VM needs to be restored). This ensures that the VM uses the restored VM GSP key. Otherwise, the VM creation fails, and a new VM GSP key is created by the system. If this happens by mistake (human error), delete the VM GSP key and then repeat the steps to restore the VM GSP key. 

        `Remove-MocKey -name <vm id> -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault`.

## Next steps

- [Manage VM extensions](virtual-machine-manage-extension.md).
