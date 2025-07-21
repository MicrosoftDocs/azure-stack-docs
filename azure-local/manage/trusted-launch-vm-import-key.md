---
title: Manual backup and recovery of guest state protection key for Trusted launch Azure Local VMs
description: Learn how to perform a manual backup and recovery of guest state protection key for Trusted launch Azure Local VMs.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.reviewer: alkohli
ms.date: 07/21/2025
---

# Manual backup and recovery of guest state protection key for Trusted launch Azure Local VMs

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manually back up and restore a Trusted launch for Azure Local VM enabled by Azure Arc.

- **For Azure Local release 2505 and later**: Backup/restore VM guest state protection keys to/from a file system folder.  

- **For Azure Local releases prior to 2505**: Backup/restore VM guest state protection keys to/from a key vault in another Azure Local instance.

# [Azure Local release 2505 and later](#tab/azure-local-release-2505-and-later)

For back up, this method copies VM guest state protection keys from the on-premises key vault of your Azure Local instance to a folder that is backed up periodically. The VM guest state protection keys stored inside that folder are in an encrypted form.

For restore, this method restores VM guest state protection keys from a folder (containing the backup copy) to the local key vault of an Azure Local instance where the VMs need to be restored.  

### Backup

The steps below involve copying VM guest state protection keys from the local key vault of your Azure Local instance to a folder that is backed up periodically.

1. On a secure computer using PowerShell 7, generate a wrapping key of size 2048:

    ```powershell
    $rsa = [System.Security.Cryptography.RSA]::Create(2048) 

    $privateKeyPem = $rsa.ExportPkcs8PrivateKeyPem() 

    $privateKeyPem | Out-File -FilePath .\private.pem 

    $publicKeyPem = $rsa.ExportRSAPublicKeyPem() 

    $publicKeyPem | Out-File -FilePath .\public.pem 
    ```
1. Make a note of the wrapping key as you'll need it later.

1. Copy the `.\public.pem` file to your Azure Local instance.

1. Copy VM guest state protection keys from the local key vault of your Azure Local instance to a folder that is backed up periodically:

    1. Download the [TvmBackupUtils.psm1 script](https://github.com/Azure-Samples/AzureLocal/blob/main/trusted-launch-vms/TvmBackupUtils.psm1) on GitHub to your Azure Local instance.

    1. Run the following:

        ```powershell
        import-module .\TvmBackupUtils.psm1 -force

        Backup-TVMKeys -WrappingKeyPath <path to public.pem> -BackupRootPath <path to backup root folder where the timestamped backup folder is stored>
        ```

1. Make note of the timestamped backup folder created under the backup root folder. You will need this later during recovery.  For example, backup folder named "20250612205355" with the format "yyyyMMddHHmmss".

1. Any time you create a new VM on Azure Local instance, run the script and back up the keys in the key vault.

### Restore

The steps below involve restoring VM guest state protection keys from a folder containing the backup copy to the key vault of an Azure Local instance where the VMs need to be restored.

1. Copy both private and public key files for the wrapping key that you created previously to the Azure Local instance.  

1. Copy the timestamped backup folder to the Azure Local instance. Pick the folder under the backup root folder with the latest timestamp as that folder will have the most recent copy.

    > [!NOTE]
    > Don't modify the backup folder.

1. Import the wrapping key that you created previously to the Azure Local instance:

    1. Download the [TvmBackupUtils.psm1 script](https://github.com/Azure-Samples/AzureLocal/blob/main/trusted-launch-vms/TvmBackupUtils.psm1) on GitHub to your Azure Local instance.

    1. Run the following commands. Make sure to create a unique name for the WrappingKeyName. Otherwise, this will cause a failure during import:

        ```powershell
        Import-Module .\TvmBackupUtils.psm1 -force 

        Import-TvmWrappingKeyFromPem -KeyName <WrappingKeyName> -PublicKeyPath <path to public.pem> -PrivateKeyPath <path to private.pem> -KeySize 2048
        ```
    
1. Delete `AzureStackTvmAKRootKey` as follows:

    > [!NOTE]
    > Do this step only if you're restoring the VM to the same Azure Local instance (the Azure Local instance where the VM resided before failure).

    `Remove-MocKey -name  AzureStackTvmAKRootKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault`

1. Restore the keys from backup:

    `Import-TVMKeys -WrappingKeyName <WrappingKeyName> -BackupPath <path to timestamped backup folder>`

    If the local key vault of the Azure Local instance already has a VM guest state protection key with the same name or already has an `AzureStackTvmAKRootKey`, you will receive an `InvalidVersion` error for that key. You can ignore this, as the key is already in the key vault.

1. Clean up files and keys:

    1. Delete both `public.pem` and `private.pem` files from the Azure Local instance.

        > [!IMPORTANT]  
        > Remove the wrapping key from the local key vault of the Azure Local instance using `Remove-MocKey`. This will help avoid collisions later.

    1. Run `Remove-MocKey -name WrappingKeyName -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault`


# [Azure Local releases prior to 2505](#tab/azure-local-releases-prior-to-2505)

To back up, this method copies VM guest state protection keys from the local key vault of your Azure Local instance to the local key vault of another Azure Local instance that is used for key backup purposes.

To restore, this method restores VM guest state protection keys from the local key vault (backup key vault) of the Azure Local instance that is used for key backup purposes to the local key vault of an Azure Local instance where the VMs need to be restored.

### Back up

Follow these steps to copy the VM guest state protection key from the local key vault of the Azure Local instance where the VM resides to a backup key vault on another Azure Local instance:

1. On the Azure Local system with the backup key vault, run the following commands on the Azure Local system with the backup key vault:

    1. Create a wrapping key in the backup key vault:

        `New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048`

    1. Download the Privacy Enhanced Mail (PEM) file:

        `Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem`

1. On the Azure Local system where the VM resides, run the following commands on the Azure Local system:

    1. Copy the PEM file to the Azure Local system.

    1. Confirm the owner node of the VM by running:

        `Get-ClusterGroup <VM name>`

    1. Run the following cmdlet on the owner node to determine the VM ID:

        `(Get-VM -Name <VM name>).vmid`

    1. Export the VM guest state protection key:

        `Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256`

1. On the Azure Local system with the backup key vault, run the following steps:

    1. Copy the `VM ID` and `VM ID`.json file to the Azure Local system.

    1. Import the VM guest state protection key to the backup key vault:

        `Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256`

### Restore

Follow these steps to copy the VM guest state protection key. The key is copied from the backup key vault of the Azure Local instance to the key vault of the target Azure Local system (where the VM needs to be restored):

1. On the source Azure Local system where the VM needs to be restored, run the following commands:

    1. Create a wrapping key in the key vault:

        `New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048`

    1. Download the PEM file:

        `Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem`

1. On the Azure Local system with the backup key vault, run the following commands:

    1. Copy the PEM file to the Azure Local system.

    1. Get the `VM ID` from the VM files stored on disk. There will be a VM config file (.xml) that has the `VM ID` as its name. You can also use the following command to obtain the `VM ID` if you know the VM name. Perform this step on a Hyper-V host that has the VM files:

        `(Get-VM -Name <VM name>).vmid`

    1. Export the VM guest state protection key:

        `Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256`

1. On the Azure Local system where the VM needs to be restored, run the following commands from the target Azure Local system:

    1. Copy the `VM ID` and `VM ID`.json file to the Azure Local system.

    1. Import the VM guest state protection key:

        `Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256`

        > [!NOTE]
        > Restore the VM guest state key (complete the steps above) before you start the VM on the Azure Local instance where the VM needs to be restored. This ensures that the VM uses the restored VM guest state protection key. Otherwise, the VM creation fails, and a new VM guest state protection key is created by the system. If this happens by mistake (human error), delete the VM guest state protection key and then repeat the steps to restore the VM guest state protection key key.

        `Remove-MocKey -name <vm id> -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault`

---

## Next steps

- [Manage VM extensions](virtual-machine-manage-extension.md).
