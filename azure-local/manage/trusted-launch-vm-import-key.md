---
title: Manual backup and recovery of guest state protection keys for Trusted launch Azure Local VMs enabled by Azure Arc
description: Learn how to perform a manual backup and recovery of guest state protection keys for Trusted launch Azure Local VMs enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.reviewer: alkohli
ms.date: 07/23/2025
---

# Manual backup and recovery of guest state protection keys for Trusted launch Azure Local VMs enabled by Azure Arc

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to manually back up and restore guest state protection keys for Trusted launch Azure Local virtual machines (VMs) enabled by Azure Arc.

- **For Azure Local release 2505 and later**: Back up and restore Azure Local VM guest state protection keys to and from a file system folder.  

- **For Azure Local releases prior to 2505**: Back up and restore Azure Local VM guest state protection keys to and from a key vault in another Azure Local instance.

# [Azure Local release 2505 and later](#tab/azure-local-release-2505-and-later)

This section applies to Azure local release 2505 and later.

For back up, VM guest state protection keys are copied from the on-premises key vault of your Azure Local instance to a folder that is backed up periodically. The VM guest state protection keys stored inside that folder are in an encrypted form.

For restore, VM guest state protection keys are restored from a folder containing the backup copy to the key vault of an Azure Local instance where the VMs need to be restored.  

### Back up keys

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
        Here is a sample output after running this command:

        ```output
        Backing up TVM Vault keys to .\<backup root folder>\20250722192116
        Backing up key 11111111-1111-1111-1111-111111111111 to AES folder
        Backing up key 7fb16fe7-00a0-476f-92b3-ccb98fd9525a to AES folder
        Backing up key AzureStackTvmAKRootKey to RSA folder
        ```

1. Make note of the timestamped backup folder created under the backup root folder. You'll need this later during recovery.  For example, backup folder named "20250612205355" with the format "yyyyMMddHHmmss".

### Restore keys

The steps below involve restoring VM guest state protection keys from a folder containing the backup copy to the key vault of an Azure Local instance where the VMs need to be restored.

1. Copy both private and public key files for the wrapping key that you created previously to the Azure Local instance.  

1. Copy the timestamped backup folder to the Azure Local instance. Pick the folder under the backup root folder with the latest timestamp as that folder will have the most recent copy. Don't modify the backup folder.

1. Import the wrapping key that you created previously to the Azure Local instance:

    1. Download the [TvmBackupUtils.psm1 script](https://github.com/Azure-Samples/AzureLocal/blob/main/trusted-launch-vms/TvmBackupUtils.psm1) on GitHub to your Azure Local instance.

    1. Run the following commands.
    
        > [!NOTE]
        > Make sure to create a unique name for the WrappingKeyName. Otherwise, this will cause a failure during import:

        ```powershell
        Import-Module .\TvmBackupUtils.psm1 -force 

        Import-TvmWrappingKeyFromPem -KeyName <WrappingKeyName> -PublicKeyPath <path to public.pem> -PrivateKeyPath <path to private.pem> -KeySize 2048
        ```
        Here is sample output:

        ```output
        Generating import JSON for key <WrappingKeyName> at temporary location C:\Users\HCIDeploymentUser\AppData\Local\Temp\tmpD383.tmp... 
        Importing key <WrappingKeyName> into the vault...
        Key <WrappingKeyName> successfully imported into the vault.
        Temporary file C:\Users\HCIDeploymentUser\AppData\Local\Temp\tmpD383.tmp has been cleaned up.
        ```

1. Do this step only if you're restoring the VM to the same Azure Local instance where the VM resided before failure. Delete `AzureStackTvmAKRootKey` as follows:

    ```powershell
    Remove-MocKey -name  AzureStackTvmAKRootKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault
    ```

1. Restore the keys from backup:

    ```powershell
    Import-TVMKeys -WrappingKeyName <WrappingKeyName> -BackupPath <path to timestamped backup folder>
    ```
    Here is sample output:

    ```output
    Importing TVM  keys from .\tvm_keys_backup_root\20250722192116\

    Importing key 11111111-1111-1111-1111-111111111111 with size 256 from AES folder path = .\tvm_keys_backup_root\20250722192116\AES\11111111-1111-1111-1111-111111111111_256.json

    Importing key 7fb16fe7-00a0-476f-92b3-ccb98fd9525a with size 256 from AES folder path = .\tvm_keys_backup_root\20250722192116\AES\7fb16fe7-00a0-476f-92b3-ccb98fd9525a_256.json

    Importing key AzureStackTvmAKRootKey with size 4096 from RSA folder path = .\tvm_keys_backup_root\20250722192116\RSA\AzureStackTvmAKRootKey_4096.json
    ```

    If the local key vault of the Azure Local instance already has a VM guest state protection key with the same name or already has an `AzureStackTvmAKRootKey`, you'll receive an `InvalidVersion` error for that key. You can ignore this, as the key is already in the key vault.

    Here is sample output showing this error:

    ```output
    Importing TVM  keys from .\tvm_keys_backup_root\20250722192116\
    Importing key 11111111-1111-1111-1111-111111111111 with size 256 from AES folder path = .\tvm_keys_backup_root\20250722192116\AES\11111111-1111-1111-1111-111111111111_256.json
    Import-TVMKeys : Error Importing Key: C:\Program Files\AksHci\mocctl.exe --cloudFqdn
    s-cluster.v.masd.stbtest.microsoft.com  security keyvault key import --group "AzureStackHostAttestation" --key-size
    "256" --vault-name "AzureStackTvmKeyVault" --key-type "AES" --key-file-path
    ".\tvm_keys_backup_root\20250722192116\AES\11111111-1111-1111-1111-111111111111_256.json" --name
    "11111111-1111-1111-1111-111111111111" --wrapping-key-name "WrappingKey" System.Collections.Hashtable.generic_non_zero
    1 [Error: Keys Import failed:  Type[Key] Vault[AzureStackTvmKeyVault] Name[11111111-1111-1111-1111-111111111111]:
    InvalidVersion]
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Import-TVMKeys

    Importing key 7fb16fe7-00a0-476f-92b3-ccb98fd9525a with size 256 from AES folder path = .\tvm_keys_backup_root\20250722192116\AES\7fb16fe7-00a0-476f-92b3-ccb98fd9525a_256.json
    Import-TVMKeys : Error Importing Key: C:\Program Files\AksHci\mocctl.exe --cloudFqdn
    s-cluster.v.masd.stbtest.microsoft.com  security keyvault key import --group "AzureStackHostAttestation" --key-size
    "256" --vault-name "AzureStackTvmKeyVault" --key-type "AES" --key-file-path
    ".\tvm_keys_backup_root\20250722192116\AES\7fb16fe7-00a0-476f-92b3-ccb98fd9525a_256.json" --name
    "7fb16fe7-00a0-476f-92b3-ccb98fd9525a" --wrapping-key-name "WrappingKey" System.Collections.Hashtable.generic_non_zero
    1 [Error: Keys Import failed:  Type[Key] Vault[AzureStackTvmKeyVault] Name[7fb16fe7-00a0-476f-92b3-ccb98fd9525a]:
    InvalidVersion]
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Import-TVMKeys

    Importing key AzureStackTvmAKRootKey with size 4096 from RSA folder path = .\tvm_keys_backup_root\20250722192116\RSA\AzureStackTvmAKRootKey_4096.json
    Import-TVMKeys : Error Importing Key: C:\Program Files\AksHci\mocctl.exe --cloudFqdn
    s-cluster.v.masd.stbtest.microsoft.com  security keyvault key import --group "AzureStackHostAttestation" --key-size
    "4096" --vault-name "AzureStackTvmKeyVault" --key-type "RSA" --key-file-path
    ".\tvm_keys_backup_root\20250722192116\RSA\AzureStackTvmAKRootKey_4096.json" --name "AzureStackTvmAKRootKey"
    --wrapping-key-name "WrappingKey" System.Collections.Hashtable.generic_non_zero 1 [Error: Keys Import failed:
    Type[Key] Vault[AzureStackTvmKeyVault] Name[AzureStackTvmAKRootKey]: InvalidVersion]
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Import-TVMKeys
    ```

1. Clean up files and keys:

    1. Delete both `public.pem` and `private.pem` files from the Azure Local instance.

        > [!IMPORTANT]  
        > Remove the wrapping key from the key vault of the Azure Local instance using `Remove-MocKey`. This will help avoid collisions later.

        ```powershell
        Remove-MocKey -name WrappingKeyName -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault
        ```


# [Azure Local releases prior to 2505](#tab/azure-local-releases-prior-to-2505)

This section applies to Azure Local releases prior to 2505.

For back up, the VM guest state protection keys are copied from the on-premises key vault of your Azure Local instance to the key vault of another Azure Local instance that is used for key back up purposes.

For restore, the VM guest state protection keys are restored from the local backup key vault of the Azure Local instance to the key vault of an Azure Local instance where the VMs need to be restored.

### Back up keys

Follow these steps to copy the VM guest state protection key from the local key vault of the Azure Local instance where the VM resides to a backup key vault on another Azure Local instance:

1. On the Azure Local system with the backup key vault, run the following commands on the Azure Local system with the backup key vault:

    1. Create a wrapping key in the backup key vault. Make note of the name as you'll need it later:

        ```powershell
        New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048
        ```

    1. Download the Privacy Enhanced Mail (PEM) file:

        ```powershell
        Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem
        ```

1. On the Azure Local system where the VM resides, run the following commands on the Azure Local system:

    1. Copy the PEM file to the Azure Local system.

    1. Confirm the owner node of the VM by running:

        ```powershell
        Get-ClusterGroup <VM name>
        ```

    1. Run the following cmdlet on the owner node to determine the VM ID:

        ```powershell
        (Get-VM -Name <VM name>).vmid
        ```

    1. Export the VM guest state protection key:

        ```powershell
        Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256
        ```

1. On the Azure Local system with the backup key vault, run the following steps:

    1. Copy the `VM ID` and `VM ID`.json file to the Azure Local system.

    1. Import the VM guest state protection key to the backup key vault:

        ```powershell
        Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
        ```

### Restore keys

Follow these steps to copy the VM guest state protection key. The key is copied from the backup key vault of the Azure Local instance to the key vault of the target Azure Local system where the VM needs to be restored:

1. On the source Azure Local system where the VM needs to be restored, run the following commands:

    1. Create a wrapping key in the key vault:

        ```powershell
        New-MocKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type RSA -size 2048
        ```

    1. Download the PEM file:

        ```powershell
        Get-MocKeyPublicKey -name wrappingKey -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -outputFile wrappingKey.pem
        ```

1. On the Azure Local system with the backup key vault, run the following commands:

    1. Copy the PEM file to the Azure Local system.

    1. Get the `VM ID` from the VM files stored on disk. There is a VM config file (.xml) that has the `VM ID` as its name. You can also use the following command to obtain the `VM ID` if you know the VM name. Perform this step on a Hyper-V host that has the VM files:

        ```powershell
        (Get-VM -Name <VM name>).vmid
        ```

    1. Export the VM guest state protection key:

        ```powershell
        Export-MocKey -name <VM ID> -wrappingKeyName wrappingKey -wrappingPubKeyFile wrappingKey.pem -outFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -size 256
        ```

1. On the Azure Local system where the VM needs to be restored, run the following commands from the target Azure Local system:

    1. Copy the `VM ID` and `VM ID`.json file to the Azure Local system.

    1. Import the VM guest state protection key:

        ```powershell
        Import-MocKey -name <VM ID> -importKeyFile <VM ID>.json -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault -type AES -size 256
        ```

        > [!NOTE]
        > Restore the VM guest state key (complete the preceding steps) before you start the VM on the Azure Local instance where the VM needs to be restored. This ensures that the VM uses the restored VM guest state protection key. Otherwise, the VM creation fails, and a new VM guest state protection key is created by the system. If this happens by mistake (human error), delete the VM guest state protection key and then repeat the steps to restore the VM guest state protection key.

        ```powershell
        Remove-MocKey -name <vm id> -group AzureStackHostAttestation -keyvaultName AzureStackTvmKeyVault
        ```

---

## Next steps

- [Manage VM extensions](virtual-machine-manage-extension.md).
