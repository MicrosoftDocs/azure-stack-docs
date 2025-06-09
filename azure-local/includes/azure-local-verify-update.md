---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 05/13/2024
---

1. To get the summary information about an update in progress, run the `Get-CauRun` cmdlet:

    ```PowerShell
    Get-CauRun -ClusterName <SystemName>
    ```

    Here's a sample output: <!--ASK-->

    ```output
    RunId                   : <Run ID> 
    RunStartTime            : 10/13/2024 1:35:39 PM 
    CurrentOrchestrator     : NODE1 
    NodeStatusNotifications : { 
    Node      : NODE1 
    Status    : Waiting 
    Timestamp : 10/13/2024 1:35:49 PM 
    } 
    NodeResults             : { 
    Node                     : NODE2 
    Status                   : Succeeded 
    ErrorRecordData          : 
    NumberOfSucceededUpdates : 0 
    NumberOfFailedUpdates    : 0 
    InstallResults           : Microsoft.ClusterAwareUpdating.UpdateInstallResult[] 
    }
    ```

1. Validate the health of your system by running the `Test-Cluster` cmdlet on one of the machines in the system. If any of the condition checks fail, resolve them before proceeding to the next step.

    ```powershell
    Test-Cluster
    ```

1. Verify that the registry keys are still applied on each machine in the system before moving to the next step.

    To check if the registry key exists:
   
    ```powershell
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" 
    ```
   
    To reapply the registry keys if needed and reboot each machine for the changes to take effect:

    ```powershell
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\FileSystem" -Name "RefsEnableMetadataValidation" -Value 0 -Type DWord  -ErrorAction Stop
    ```

    If the OS upgrade fails, run the following command to recover the CAU run:

    ```powershell
    Invoke-CauRun –ForceRecovery -Force
    ```

You're now ready to perform the post-OS upgrade steps for your system.