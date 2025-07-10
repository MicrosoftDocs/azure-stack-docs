---
title: Enable backup for Azure Stack Hub with PowerShell 
description: Learn how to enable the Infrastructure Backup Service with PowerShell so that Azure Stack Hub can be restored if there's a failure. 
author: sethmanheim
ms.topic: how-to
ms.date: 01/15/2025
ms.author: sethm
ms.lastreviewed: 03/14/2019

# Intent: As an Azure Stack operator, I want to enable backups with Powershell so Azure Stack can generate infrastructure backups.
# Keyword: enable backup powershell

---

# Enable backup for Azure Stack Hub with PowerShell

You can enable the Infrastructure Backup Service with Windows PowerShell to take periodic backups of:

- Internal identity service and root certificate.
- User plans, offers, subscriptions.
- Compute, storage, and network user quotas.
- User Key Vault secrets.
- User RBAC roles and policies.
- User storage accounts.

You can access the PowerShell cmdlets to enable backup, start backup, and get backup information via the operator management endpoint.

## Prepare PowerShell environment

For instructions on configuring the PowerShell environment, see [Install PowerShell for Azure Stack Hub](powershell-install-az-module.md). To sign in to Azure Stack Hub, see [Configure the operator environment and sign in to Azure Stack Hub](azure-stack-powershell-configure-admin.md).

## Provide the backup share, credentials, and encryption key to enable backup

In the same PowerShell session, edit the following PowerShell script by adding the variables for your environment. Run the updated script to provide the backup share, credentials, and encryption key to the Infrastructure Backup Service.

| Variable        | Description   |
|---              |---                                        |
| `$username`       | Type the **Username** using the domain and username for the shared drive location with sufficient access to read and write files. For example, `Contoso\backupshareuser`. |
| `$password`       | Type the **Password** for the user. |
| `$sharepath`      | Type the path to the **Backup storage location**. You must use a Universal Naming Convention (UNC) string for the path to a file share hosted on a separate device. A UNC string specifies the location of resources such as shared files or devices. To ensure availability of the backup data, the device should be in a separate location. |
| `$frequencyInHours` | The frequency in hours determines how often backups are created. The default value is 12. Scheduler supports a maximum of 12 and a minimum of 4.|
| `$retentionPeriodInDays` | The retention period in days determines how many days of backups are preserved on the external location. The default value is 7. Scheduler supports a maximum of 14 and a minimum of 2. Backups older than the retention period get automatically deleted from the external location.|
| `$encryptioncertpath` | Applies to 1901 and later. Parameter is available in Azure Stack Hub Module version 1.7 and later. The encryption certificate path specifies the file path to the .CER file with public key used for data encryption. |

### Enable backup using certificate

Run the following command to enable the backup using a certificate:

```powershell
# Example username:
$username = "domain\backupadmin"
# Example share path:
$sharepath = "\\serverIP\AzSBackupStore\contoso.com\seattle"

$password = Read-Host -Prompt ("Password for: " + $username) -AsSecureString

# Create a self-signed certificate using New-SelfSignedCertificate, export the public key portion and save it locally.

$cert = New-SelfSignedCertificate `
    -DnsName "www.contoso.com" `
    -CertStoreLocation "cert:\LocalMachine\My" 

New-Item -Path "C:\" -Name "Certs" -ItemType "Directory" 

# Make sure to export the PFX format of the certificate with the public and private keys and then delete the certificate from the local certificate store of the machine where you created the certificate
    
Export-Certificate `
    -Cert $cert `
    -FilePath c:\certs\AzSIBCCert.cer 

# Set the backup settings with the name, password, share, and CER certificate file.
Set-AzsBackupConfiguration -Path $sharepath -Username $username -Password $password -EncryptionCertPath "c:\temp\cert.cer"
```

## Confirm backup settings

In the same PowerShell session, run the following commands:

```powershell
Get-AzsBackupConfiguration | Select-Object -Property Path, UserName
```

The result should look like the following example output:

```output
Path                        : \\serverIP\AzsBackupStore\contoso.com\seattle
UserName                    : domain\backupadmin
```

## Update backup settings

In the same PowerShell session, you can update the default values for retention period and frequency for backups. Run the following commands:

```powershell
# Set the backup frequency and retention period values.
$frequencyInHours = 10
$retentionPeriodInDays = 5

Set-AzsBackupConfiguration -BackupFrequencyInHours $frequencyInHours -BackupRetentionPeriodInDays $retentionPeriodInDays

Get-AzsBackupConfiguration | Select-Object -Property Path, UserName, AvailableCapacity, BackupFrequencyInHours, BackupRetentionPeriodInDays
```

The result should look like the following example output:

```powershell
Path                        : \\serverIP\AzsBackupStore\contoso.com\seattle
UserName                    : domain\backupadmin
AvailableCapacity           : 60 GB
BackupFrequencyInHours      : 10
BackupRetentionPeriodInDays    : 5
```

### Azure Stack Hub PowerShell

The PowerShell cmdlet to configure infrastructure backup is `Set-AzsBackupConfiguration`. In previous releases, the cmdlet was `Set-AzsBackupShare`. This cmdlet requires providing a certificate. If infrastructure backup is configured with an encryption key, you can't update the encryption key or view the property. You must use version 1.6 of the Admin PowerShell.

If infrastructure backup was configured before updating to 1901, you can use version 1.6 of the admin PowerShell to set and view the encryption key. Version 1.6 won't allow you to update from encryption key to a certificate file. See [Install Azure Stack Hub PowerShell](powershell-install-az-module.md) for more information about installing the correct version of the module.

## Next steps

- [Back up Azure Stack Hub](azure-stack-backup-back-up-azure-stack.md)
- [Confirm backup completed in administration portal](azure-stack-backup-back-up-azure-stack.md)
