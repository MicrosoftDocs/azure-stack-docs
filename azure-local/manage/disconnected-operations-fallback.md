---
title: Appliance fallback log collection for disconnected operations with Azure Local VMs enabled by Azure Arc (Preview)
description: Export and send logs for disconnected operations with Azure Local VMs enabled by Azure Arc (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 08/06/2025
ai-usage: ai-assisted
---

# Appliance fallback log collection for disconnected operations with Azure Local VMs enabled by Azure Arc (preview)

::: moniker range=">=azloc-2506"

This article explains how to use appliance fallback logging to export and send logs to Microsoft when Azure Local VMs operates in disconnected mode. This process helps you troubleshoot issues when standard log collection isn't available.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About fallback logging

Use appliance fallback logging to collect and send logs to Microsoft when the Azure Local disconnected operations appliance virtual machine (VM) is down. Use this method if standard log collection can't start and you need logs for troubleshooting.

## Prerequisites

Import the appliance logging module to use the cmdlets in this article.

## Import appliance logging

To import appliance logging, run the following command:

```PowerShell
Import-Module "C:\azurelocal\OperationsModule\ApplianceFallbackLogging.psm1" -Force
```

## Export logs using the Copy-DiagnosticData command

To export logs in the fallback scenario, use the `Copy-DiagnosticData` cmdlet.

### Copy-DiagnosticData command

The **Copy-DiagnosticData** command is used to copy diagnostic logs from mounted virtual hard disks (VHDs) to a specified folder. This command is part of the operations module and helps you collect diagnostic data from a log volume VHD for analysis.

The fallback logging scenario applies when the Azure Local VM running disconnected operations isn't working as expected or a management endpoint isn't functional. This cmdlet shuts down the VM. To get the logs, mount and unlock the VHDs, then copy the logs from the mounted VHDs to a local `LogsToExport` folder inside the folder you specify with `DiagnosticLogPath`. You can set the time window and roles to collect. If you set the `Observability Stamp ID`, the cmdlet includes it in the return values.

Make sure this location has enough space for the logs because the Azure Local VMs running disconnected VHDs are temporarily mounted there during the copy action.

Use these parameters with the `Copy-DiagnosticData` cmdlet.

- **DiagnosticLogPath**: Required. The destination path contains copied logs and temporarily mounted VHDs.

- **Roles**: The roles required for log collection or diagnostics may vary depending on the scenario. Work with your support contact to determine the appropriate roles to include.

- **FromDate** and **ToDate**: Optional. Start and end times of logs included in the collection. Logs before the FromDate and after the ToDate are excluded. By default, logs from the **last four hours** of the current time are collected, if you don't provide these parameters.

- **RecoveryKeySet** (BitLocker): Optional. The RecoveryKeySet contains relevant **ProtectorId** and **RecoveryPassword** pairs for BitLocker encrypted volumes used for log collection retrieval. If recovery keys aren't provided, manual entry of the keys is required during the mount process.

    > [!NOTE]
    > The BitLocker recovery key set is required to unlock the mounted VHDs used for log collection. These keys should be retrieved and saved upon successful deployment of the appliance using the BitlockerRecoveryKeys endpoint.

    Example:

    ```PowerShell
    $certPasswordPlainText = "***"
    $certPassword = ConvertTo-SecureString $certPasswordPlainText -AsPlainText -Force
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "<Management Endpoint Client Cert Path>" -ManagementEndpointClientCertificatePassword $certPassword -ManagementEndpointIpAddress "<Management Endpoint IP address>"
    
    $recoveryKeys = Get-ApplianceBitlockerRecoveryKeys $context # context can be omitted if context is set.
    $recoveryKeys
    ```

    Example output:

    ```PowerShell
    PS G:\azurelocal> $recoveryKeys = Get-ApplianceBitlockerRecoveryKeys $context # context can be omitted if context is set.
    >>
    >> $recoverykeys.recoveryKeySet | ConvertTo-JSON > c:\recoveryKeySet.json
    >>
    >> Get-content c:\recoveryKeySet.json
    >>
    VERBOSE: [2025-08-05 23:10:58Z][Get-ApplianceBitlockerRecoveryKeys] [START] Get bitlocker recovery keys.
    VERBOSE: [2025-08-05 23:10:58Z][Invoke-ScriptsWithRetry][Get-ApplianceBitlockerRecoveryKeys] Executing 'Script Block' with timeout 300 seconds ...
    VERBOSE: [2025-08-05 23:10:58Z][Invoke-ScriptsWithRetry][Get-ApplianceBitlockerRecoveryKeys] [CHECK][Attempt 0] for task 'Script Block' ...
    VERBOSE: [2025-08-05 23:10:58Z][Invoke-ScriptsWithRetry][Get-ApplianceBitlockerRecoveryKeys] Task 'Script Block' succeeded.
    VERBOSE: [2025-08-05 23:10:58Z][Get-ApplianceBitlockerRecoveryKeys] [END] Get bitlocker recovery keys.
    [
        {
            "protectorid":  "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",
            "recoverypassword":  "xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx"
        },
        {
            "protectorid":  "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",
            "recoverypassword":  "xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx"
        },
        {
            "protectorid":  "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",
            "recoverypassword":  "xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx"
        },
        {
            "protectorid":  "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",
            "recoverypassword":  "xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx"
        },
        {
            "protectorid":  "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",
            "recoverypassword":  "xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx"
        },
        {
            "protectorid":  "{xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx}",
            "recoverypassword":  "xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx-xxxxxx"
        }
    ]
    ```

    To manually create a RecoveryKeySet parameter, use this template:

    ```powershell
    $bitLockerKeysPasswords = @(
    [PSCustomObject]@{protectorid = "{<Protector Id>}"; recoverypassword = "<Recovery password>"})
    ```

### Copy from the Azure Local disconnected operations appliance VM

Here are some examples of how to use the `Copy-DiagnosticData` cmdlet to get logs from the Azure Local disconnected operations appliance VM.

#### Copy diagnostic data logs for specific roles

To copy diagnostic data logs for specific roles, run these commands:

```powershell
Import-Module "C:\azurelocal\OperationsModule\ApplianceFallbackLogging.psm1" -Force
```

```powershell
Copy-DiagnosticData -DiagnosticLogPath "C:/path/to/copied_logs_parent_directory" -Roles @("Agents", "Oplets", "ServiceFabric")
```

#### Copy diagnostic data logs for specific roles and time ranges

To copy diagnostic data logs for specific roles with time ranges and recovery keys, if provided, run these commands:

```powershell
Import-Module "C:\azurelocal\OperationsModule\ApplianceFallbackLogging.psm1" -Force
```

```powershell
$diagnosticLogPath = "C:\path\to\LogsToExport"
$roles = @("Agents", "Oplets", "ServiceFabric")
$fromDate = [datetime]"03/13/2024 12:00:00"
$toDate = [datetime]"03/13/2024 15:00:00"
$recoveryKeySet = @()
```

```powershell  
Copy-DiagnosticData -DiagnosticLogPath $diagnosticLogPath -Roles $roles -FromDate $fromDate -ToDate $toDate -RecoveryKeySet $recoveryKeySet
```

Example output:

```PowerShell
PS C:\Users\administrator.s46r2004\Documents> Copy-DiagnosticData -DiagnosticLogPath $diagnosticLogPath -RecoveryKeySet $recoveryKeySet  
VERBOSE: [2025-03-26 22:10:58Z] [Get-ValidCollectionWindow] $ToDate not provided, set to: 03/26/2025 22:10:58 (current time)  
VERBOSE: [2025-03-26 22:10:58Z] [Get-ValidCollectionWindow] #FromDate not provided, set to: 03/26/2025 18:10:58 (4hr collection window)  
VERBOSE: [2025-03-26 22:10:58Z] [Copy-DiagnosticData] Collecting logs for range: '03/26/2025 18:10:58' - '03/26/2025 22:10:58'  
VERBOSE: [2025-03-26 22:10:58Z] [Copy-DiagnosticData] Collecting logs for roles: 'Agents', 'Oplets', 'MASLogs', 'ServiceFabric', 'ArcADiagnostics', 'Observability', 'WindowsEventLogs'  
VERBOSE: [2025-03-26 22:10:59Z] [Invoke-StopIRVMAndMountVHDs] Stopping the IRVM...  
VERBOSE: [2025-03-26 22:11:55Z] [Invoke-StopIRVMAndMountVHDs] Attempting to mount VHD 'C:\ClusterStorage\UserStorage_1\InfraVms\IRVM01\Virtual Hard Disks\OSAndDocker_A.vhdx'...      
```

Example of the copy-diagnosticdata output:

```output
| DiagnosticLogPath                                       | StampId                                  |
|---------------------------------------------------------|------------------------------------------|
| C:\CopyLogs_20240501T1525097418\LogsToExport            | <Stamp ID>                               |
```

> [!NOTE]
> The Azure Local disconnected operations appliance VM restarts after this operation finishes.

#### Copy diagnostic data logs to a specific directory path

To copy diagnostic data logs to a specific directory path, run these commands:

```powershell
Import-Module "C:\azurelocal\OperationsModule\ApplianceFallbackLogging.psm1" -Force
```

```powershell
Copy-DiagnosticData -DiagnosticLogPath "C:/path/to/copied_logs_parent_directory"
```

## Related content

- [Collect logs on-demand with Azure Local disconnected operations (preview)](disconnected-operations-on-demand-logs.md)
- [Disconnected operations with Azure Local overview](disconnected-operations-overview.md)

</details>

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
