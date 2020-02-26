---
title: Back up Azure Stack Hub 
description: Learn how to do an on-demand backup on Azure Stack Hub.
author: justinha

ms.topic: article
ms.date: 02/12/2019
ms.author: justinha
ms.reviewer: hectorl
ms.lastreviewed: 09/05/2

# Intent: As an Azure Stack operator, I want to perform an on-demand backup.
# Keyword: azure stack backup

---

# Back up Azure Stack Hub

This article shows you how to do an on-demand backup on Azure Stack Hub. For instructions on configuring the PowerShell environment, see [Install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md). To sign in to Azure Stack Hub, see [Using the administrator portal in Azure Stack Hub](azure-stack-manage-portals.md).

## Start Azure Stack Hub backup

### Start a new backup without job progress tracking
Use Start-AzSBackup to start a new backup immediately with no job progress tracking.

```powershell
   Start-AzsBackup -Force
```

### Start Azure Stack Hub backup with job progress tracking
Use Start-AzSBackup to start a new backup with the **-AsJob** parameter and save it as a variable to track backup job progress.

> [!NOTE]
> Your backup job appears as successfully completed in the portal about 10-15 minutes before the job finishes.
>
> The actual status is better observed via the code below.

> [!IMPORTANT]
> The initial 1 millisecond delay is introduced because the code is too quick to register the job correctly and it comes back with no **PSBeginTime** and in turn with no **State** of the job.

```powershell
    $BackupJob = Start-AzsBackup -Force -AsJob
    While (!$BackupJob.PSBeginTime) {
        Start-Sleep -Milliseconds 1
    }
    Write-Host "Start time: $($BackupJob.PSBeginTime)"
    While ($BackupJob.State -eq "Running") {
        Write-Host "Job is currently: $($BackupJob.State) - Duration: $((New-TimeSpan -Start ($BackupJob.PSBeginTime) -End (Get-Date)).ToString().Split(".")[0])"
        Start-Sleep -Seconds 30
    }

    If ($BackupJob.State -eq "Completed") {
        Get-AzsBackup | Where-Object {$_.BackupId -eq $BackupJob.Output.BackupId}
        $Duration = $BackupJob.Output.TimeTakenToCreate
        $Pattern = '^P?T?((?<Years>\d+)Y)?((?<Months>\d+)M)?((?<Weeks>\d+)W)?((?<Days>\d+)D)?(T((?<Hours>\d+)H)?((?<Minutes>\d+)M)?((?<Seconds>\d*(\.)?\d*)S)?)$'
        If ($Duration -match $Pattern) {
            If (!$Matches.ContainsKey("Hours")) {
                $Hours = ""
            } 
            Else {
                $Hours = ($Matches.Hours).ToString + 'h '
            }
            $Minutes = ($Matches.Minutes)
            $Seconds = [math]::round(($Matches.Seconds))
            $Runtime = '{0}{1:00}m {2:00}s' -f $Hours, $Minutes, $Seconds
        }
        Write-Host "BackupJob: $($BackupJob.Output.BackupId) - Completed with Status: $($BackupJob.Output.Status) - It took: $($Runtime) to run" -ForegroundColor Green
    }
    ElseIf ($BackupJob.State -ne "Completed") {
        $BackupJob
        $BackupJob.Output
    }
```

## Confirm backup has completed

### Confirm backup has completed using PowerShell
Use the following PowerShell commands to ensure the backup has completed successfully:

```powershell
   Get-AzsBackup
```

The result should look like the following output:

```powershell
    BackupDataVersion : 1.0.1
    BackupId          : <backup ID>
    RoleStatus        : {NRP, SRP, CRP, KeyVaultInternalControlPlane...}
    Status            : Succeeded
    CreatedDateTime   : 7/6/2018 6:46:24 AM
    TimeTakenToCreate : PT20M32.364138S
    DeploymentID      : <deployment ID>
    StampVersion      : 1.1807.0.41
    OemVersion        : 
    Id                : /subscriptions/<subscription ID>/resourceGroups/System.local/providers/Microsoft.Backup.Admin/backupLocations/local/backups/<backup ID>
    Name              : local/<local name>
    Type              : Microsoft.Backup.Admin/backupLocations/backups
    Location          : local
    Tags              : {}
```

### Confirm backup has completed in the administrator portal
Use the Azure Stack Hub administrator portal to verify that backup has completed successfully by following these steps:

1. Open the [Azure Stack Hub administrator portal](azure-stack-manage-portals.md).
2. Select **All services**, and then under the **ADMINISTRATION** category select > **Infrastructure backup**. Choose **Configuration** in the **Infrastructure backup** blade.
3. Find the **Name** and **Date Completed** of the backup in **Available backups** list.
4. Verify the **State** is **Succeeded**.

## Next steps

Learn more about the workflow for [recovering from a data loss event](azure-stack-backup-recover-data.md).
