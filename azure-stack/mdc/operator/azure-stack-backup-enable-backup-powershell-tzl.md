---
title: Enable backup for Azure Stack with PowerShell | Microsoft Docs
description: Learn how to enable the Infrastructure Backup Service with PowerShell so that Azure Stack can be restored if there's a failure. 
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: tzl
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/27/2020
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 10/27/2020

---

# Configure backup for Azure Stack with PowerShell

*Applies to: Modular Data Center, Azure Stack Hub ruggedized*

You can configure the Infrastructure Backup Service to export infrastructure backups to an external storage location, using PowerShell. Infrastructure backups can be used by support to fix degraded services.

## Prepare PowerShell environment

For instructions on configuring the PowerShell environment, see [Install PowerShell for Azure Stack](../../operator/azure-stack-powershell-install.md). To sign in to Azure Stack, see [Configure the operator environment and sign in to Azure Stack](../../operator/azure-stack-powershell-configure-admin.md).

## Provide the backup share, credentials, and encryption key to enable backup

In the same PowerShell session, edit the following PowerShell script by adding the variables for your environment. Run the updated script to provide the backup share, credentials, and encryption key to the Infrastructure Backup Service.

|Variable  |Description  |
|---------|---------|
|$username     | Type the **Username** using the domain and username for the shared drive location with sufficient access to read and write files. For example, Contoso\\backupshareuser.        |
|$password     | Type the **Password** for the user.        |
|$path     | Type the path to the **Backup storage location**. You must use a Universal Naming Convention (UNC) string for the path to a file share hosted on a separate device. A UNC string specifies the location of resources such as shared files or devices. To ensure availability of the backup data, the device should be in a separate location.        |
|$backupfrequencyinhours     | The frequency in hours determines how often backups are created. The default value is 12. Scheduler supports a minimum of 4 and a maximum of 12.        |
|$backupretentionperiodindays     | The retention period in days determines how many days of backups are preserved on the external location. The default value is 7. Scheduler supports a minimum of 2 and a maximum of 14. Backups older than the retention period get automatically deleted from the external location.        |
|$encryptioncertpath     | Certificate provided during deployment. No need to provide a new one when configuring the external storage location. The encryption certificate path specifies the file path to the .CER file with public key used for data encryption.        |
|$isbackupschedulerenabled     | Enables/disables automatic backups. Automatic backups are enabled by default after providing share and credentials.        |

## Configure backup

```powershell
# Example username
$username = "domain\backupadmin"

# Example share path
$sharepath = "\\serverIP\AzSBackupStore\contoso.com\seattle"

$password = Read-Host -Prompt ("Password for: " + $username) -AsSecureString

# Set the backup settings with the name, password, share, and CER certificate file.
Set-AzsBackupConfiguration -BackupShare path -Username $username -Password $password
```

## Confirm backup settings

In the same PowerShell session, run the following commands:

```powershell
Get-AzsBackupConfiguration | Select-Object -Property Path, UserName
```

The result should look like the following example output:

```shell
Path : \\serverIP\AzsBackupStore\contoso.com\seattle
UserName : domain\backupadmin
```

## Update backup settings

In the same PowerShell session, you can update the default values for the retention period and frequency for backups:

```powershell
# Set the backup frequency and retention period values.
$frequencyInHours = 10
$retentionPeriodInDays = 5

Set-AzsBackupConfiguration -BackupFrequencyInHours $backupfrequencyInHours -BackupRetentionPeriodInDays $backupretentionPeriodInDays

Get-AzsBackupConfiguration | Select-Object -Property Path, UserName, AvailableCapacity, BackupFrequencyInHours, BackupRetentionPeriodInDays
```

## Update encryption certificate

In the same PowerShell session, you can update the encryption certificate used to encrypt backup data. Only new backups will use the new encryption certificate. All existing backups will remain encrypted with the previous certificate. Make sure to keep a copy of the previous certificate for at least a month to ensure previous backups encrypted with the old certificate have been purged:

```powershell
#Set the new encryption certificate by providing local path to CER file.
Set-AzsBackupConfiguration -EncryptionCertPath "c:\temp\cert.cer"
```

## Enable or disable automatic backups

In the same PowerShell session, you can enable or disable automatic backups. Automatic backups are enabled by default.

```powershell
#Disable automatic backups.
Set-AzsBackupConfiguration - Isbackupschedulerenabled $false

#Enable automatic backups.
Set-AzsBackupConfiguration - Isbackupschedulerenabled $true
```

## Next steps

To learn how to verify that your backup ran, see [Confirm backup completed in administration portal](../../operator/azure-stack-backup-back-up-azure-stack.md).
