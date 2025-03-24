---
title: Use Appliance fallback logging to collect logs and troubleshoot disconnected operations with Azure Local VMs enabled by Azure Arc (preview)
description: Export and send logs using Appliance Fallback Logging for disconnected operations with Azure Local VMs enabled by Azure Arc (preview)
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 03/19/2025
---

# Appliance fallback log collection for disconnected operations with Azure Local VMs enabled by Azure Arc (preview)

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This article describes how to use appliance fallback logging to export and send logs to Microsoft when Azure Local is operating in a disconnected mode.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## About fallback logging

Use appliance fallback logging to collect and send logs to Microsoft when the Azure Local VM running disconnected is down, standard log collection can't be initiated, and logs are needed for troubleshooting.

## Prerequisites

Before you begin, make sure you:

- Import the Appliance logging.
- Ensure access to the logs.
- Verify permission to run the cmdlets.

## Export logs for the fallback scenario

You can use three cmdlets to export logs for the fallback scenario:

- [**Copy-DiagnosticData**](#copy-diagnosticdata)
- [**Send-DiagnosticData**](#send-diagnosticdata)
- [**Get-ObservabilityStampId**](#get-observabilitystampid-optional)

### Copy-DiagnosticData

The **Copy-DiagnosticData** command is used to copy diagnostic logs from mounted virtual hard disks (VHDs) to a specified folder. This command is part of the operations module and is typically used in scenarios where you need to collect diagnostic data from a VHD for analysis.

Since the Azure Local VM running disconnected operations isn't expected to work in the appliance fallback logging scenario, you need to shut it down to retrieve logs. To obtain the logs, mount and unlock the VHDs, then copy the logs from the mounted VHDs to a local, user-defined file location. You can configure the time window and roles that you want collected. If the `Observability Stamp ID` is configured, it should be included in the cmdlets return values.

Ensure there's enough space in this location to hold the logs, as the Azure Local VMs running disconnected VHDs are temporarily mounted there during the copy action.

You can use these parameters with the `Copy-DiagnosticData` cmdlet.

- **DiagnosticLogPath**: Required. The destination path that contains the copied logs and temporarily mounted VHDs. If the `DiagnosticLogPath` cmdlet is piped into the `Send-DiagnosticData` cmdlet, it also serves as the default location where the Standalone Observability pipeline is installed and logs activity.

- **Roles**: Optional. Roles available: **Agents**, **Oplets**, **MASLogs**, **ServiceFabric**, **ArcADiagnostics**, **Observability**, **WindowsEventLogs**, **CosmosDB**, and **Storage**. By default, all roles except **CosmosDB** and **Storage** are included.

- **FromDate** and **ToDate**: Optional. Start and end times of logs included in the collection. Logs before the FromDate and after the ToDate are excluded. By default, logs from the **last four hours** of the current time are collected, if these parameters aren't provided.

- **RecoveryKeySet** (BitLocker): Optional. The RecoveryKeySet containing relevant **ProtectorId** and **RecoveryPassword** pairs for BitLocker encrypted volumes used for log collection retrieval. If recovery keys aren't provided, manual entry of the keys is required during the mount process.

  - You can use the following template to manually construct a _RecoveryKeySet_ parameter, if needed:

    ```powershell
    $bitLockerKeysPasswords = @(
    [PSCustomObject]@{protectorid = "{<Protector Id>}"; recoverypassword = "<Recovery password>"})
    ```

    > [!NOTE]
    > The BitLocker recovery key set is required to unlock the mounted VHDs used for log collection. These keys should be retrieved and saved upon successful deployment of the appliance using the BitlockerRecoveryKeys endpoint.

#### Copy from the Azuer Local VMs running disconnected and mount VHDs

To copy diagnostic logs from the mounted VHDs to a specified folder nested in the provided `DiagnosticLogPath` location, follow these steps:

1. Provide a drive or path for the `-DiagnosticLogPath` where the logs can be copied. Optionally, you can include specific roles and a log collection window.

    - If you specify a new file destination in the `-DiagnosticLogPath`, that destination is used to store the LogsToExport file. Otherwise, a parent folder named **CopyLogs_{timestamp}** (with the timestamp reflecting the time the cmdlet was called) is created by default.

    - The available roles are **Agents**, **Oplets**, **MASLogs**, **ServiceFabric**, **ArcADiagnostics**, **Observability**, **WindowsEventLogs**, **CosmosDB**, and **Storage**. By default, all roles except **Storage** and **CosmosDB** are included.

    > [!TIP]
    > The standalone pipeline used to send logs to Kusto is limited regarding the log volume it can handle. The more targeted the collection (the shorter the collection window and fewer the roles), the better the chance of avoiding errors during log ingestion.

2. Specify a collection window, use the `-FromDate` and `-ToDate` parameters. By default, logs from the **last four hours** are collected.
3. Run the `Copy-DiagnosticData` cmdlet:

    ```console
    $diagnosticLogPath = "C:\path\to\LogsToExport"
    $roles = @("Agents", "Oplets", "ServiceFabric")
    $fromDate = [datetime]"03/13/2024 12:00:00"
    $toDate = [datetime]"03/13/2024 15:00:00"
    $recoveryKeySet = @()
     
    Copy-DiagnosticData [-DiagnosticLogPath] <String> [[-Roles] <String[]>] [[-FromDate] <Nullable`1>] [[-ToDate] <Nullable`1>] [[-RecoveryKeySet] <PSObject[]>] [<CommonParameters>]
    ```

    Here's an example of the cmdlet:

    ```powershell
    Copy-DiagnosticData -DiagnosticLogPath $diagnosticLogPath -Roles $role -FromDate $fromDate -ToDate $toDate -RecoveryKeySet $recoveryKeySet
    ```

    Here's an example of the copy output including the StampId, if it exists:

    ```output
    | DiagnosticLogPath                                       | StampId                                  |
    |---------------------------------------------------------|------------------------------------------|
    | C:\CopyLogs_20240501T1525097418\LogsToExport            | <Stamp ID>                               |
    ```

    > [!NOTE]
    > The Azure Local VM running disconnected is **restarted** after this operation is completed.

The autogenerated output file, **CopyLogs_20240501T1525097418**, contains the copied logs within the **LogsToExport** folder. Additionally, it includes a **RobocopyLog.log** file and/or a **WEvtUtilLog.log** file, which documents the status of the copy actions.

- **RobocopyLog.log**: Records the copying of all file types except Windows Event files.
- **wevtutil**: A tool used to copy Windows events. This activity is logged in the **WEvtUtilLog.log** file.

Here are examples of the LogtoExport folder structures:

Overall file structure:

[![A screenshot of the copy diagnostics overall file structure.](./media/disconnected-operations/fallback-log/overall-file-structure.png)](media/disconnected-operations/fallback-log/overall-file-structure.png#lightbox)

Disconnected operations virtual machine nested file structure:  

[![A screenshot of the Azure Local VM running disconnected nested file structure.](./media/disconnected-operations/fallback-log/nested-file-structure.png)](media/disconnected-operations/fallback-log/nested-file-structure.png#lightbox)

### Send-DiagnosticData  

After logs are collected into a directory, either by using the `Copy-DiagnosticData` cmdlet or by copying them manually, you can send them to Kusto via the standalone pipeline. This pipeline Arc-enables the host (the machine running the cmdlet) to perform the operation, targeting all the logs in the file location you provide, and sends them for ingestion into Kusto. If log ingestion fails, the cmdlet attempts up to three times and then outputs the results of the send activity once it's complete.

The **Send-DiagnosticData** cmdlet downloads and runs the standalone observability pipeline. You need to enter the credentials required to connect to Azure for the pipeline. There are two options for providing these credentials:

- **Interactive registration with device code**. Prompts you to manually sign in to Azure once the cmdlet is invoked.
- **Registration with Service Principal Credential**. Takes the required credentials upfront and uses them to run to completion.

You must provide the following parameters for either option:

- **ResourceGroupName**  
- **SubscriptionId**  
- **TenantId**  
- **RegistrationRegion**  
- **DiagnosticLogPath**  

Optional parameters to provide:

- **Cloud** (default AzureCloud)*
- **ObsRootFolderPath**

  - Where the observability pipeline is installed
  - Defaults to the parent directory of **DiagnosticLogPath** and is nested in a folder **SendLogs_{timestamp}**
  
- **StampId** (If set it defaults to `$env:STAMP_GUID`. If not the host machine's **UUID** is used.)

> [!NOTE]
> The RegistrationRegion is equivalent to Location with reference to the ObservabilityConfiguration endpoint's $arcContext JSON.

Here's an example using the **Interactive registration with device code**:

```powershell  
Send-DiagnosticData 
-ResourceGroupName "Resource group" `  
-SubscriptionId "Subscription ID" `  
-TenantId "Tenant ID" `  
-RegistrationWithDeviceCode `
-RegistrationRegion "Region" `  
-DiagnosticLogPath "C:\path\to\LogsToExport"   
```  

The **-RegistrationWithDeviceCode** switch is optional. Whenever **-RegistrationWithCredential** is missing, interactive registration is automatically used.

Here's an example using **Registration with Service Principal Credential**:

```powershell  
$spId = "{...}"
$spSecret = "{...}"
$ss = ConvertTo-SecureString -String $spSecret -AsPlainText -Force
$spCred = New-Object System.Management.Automation.PSCredential($spId, $ss)  
   
Send-DiagnosticData 
-ResourceGroupName "Resource group" `  
-SubscriptionId "Subscription ID" `  
-TenantId "Tenant ID" `  
-RegistrationWithCredential {$spCred} `  
-RegistrationRegion "Region" `  
-DiagnosticLogPath "C:\path\to\LogsToExport" `  
-StampId "Stamp ID"  
```  

The cmdlet returns the stamp ID, also known as the **AEOStampId**, which is used for Kusto lookup. It also provides information about any errors encountered and the location of the send activity logs.

Here's an example of the output:

```console
AEOStampID '<Stamp ID>' used for log tracking in Kusto.

Logs and artifacts from send action can be found under:  
G:\CopyLogs_20241218T1622391740\SendLogs_20241218T1625348996  
  
Log parsing engine results can be found under:  
G:\CopyLogs_20241218T1622391740\SendLogs_20241218T1625348996\ObsScheduledTaskTranscripts  
```

Here's an example of the file structure for the send logs:

[![A screenshot of the file structure for the send logs.](./media/disconnected-operations/fallback-log/send-logs-file-structure.png)](media/disconnected-operations/fallback-log/send-logs-file-structure.png#lightbox)

The file structure for the send logs contains all the logs and installation files from the standalone observability pipeline including the **GMACache logs** and pipeline install and/or uninstall logs.

### Get-ObservabilityStampId (optional)

> [!NOTE]
> You don't need to use this cmdlet in addition to `Copy-DiagnosticData`.

The `Get-ObservabilityStampId` cmdlet is a heavy operation and should only be needed in rare cases. This cmdlet also shuts down the Azure Local VM running disconnected and mounts the OS volume VHD to retrieve the stamp ID. After the operation is complete, the Azure Local VM running disconnected is **restarted**.

You can use these parameters with the `Get-ObservabilityStampId` cmdlet:

- **MountPath**: Optional. A valid drive or path to temporarily hold mounted VHDs used to retrieve the stamp ID. The file is removed on cleanup at the end of the cmdlet.
- **Recoverykeyset**: Optional. The RecoveryKeySet containing relevant **ProtectorId** and **RecoveryPassword** pairs for BitLocker encrypted volumes used for log collection retrieval. If recovery keys aren't provided, manual entry of the keys is required during the mount process.

> [!TIP]
> You can provide a desired path for the mounted VHD. Otherwise, the default path `${env:USERPROFILE}\MountedVHDs` is used.

Here's an example of the output with a custom path:

```powershell  
Get-ObservabilityStampId -MountPath "C:/temp/path"  
```  

```console
StampId
-------
<Stamp Id>
```

If no `StampId` is listed in the returned content after running the command, the stamp ID isn't set and needs to be passed into the [Send-DiagnosticData](#send-diagnosticdata) manually. If the stamp ID isn't set and isn't passed manually, it defaults to the host **UUID**.

### Pipe cmdlets

If you plan to use the `Copy-DiagnosticData` or `Get-ObservabilityStampId` cmdlets, you can simplify the calls by piping these commands into the `Send-DiagnosticData` cmdlet.  

More commonly, if you want to copy and send logs, you can run this command:  

```powershell  
Copy-DiagnosticData -DiagnosticLogPath "C:" -Roles @("ServiceFabric") | Send-DiagnosticData `  
-ResourceGroupName "Resource group" `  
-SubscriptionId "Subscription ID" `  
-TenantId "Tenant ID" `  
-RegistrationRegion “eastus”  
```  

The `Copy-DiagnosticData` cmdlet passes the appropriate **DiagnosticLogPath** and **StampId** parameters into `Send-DiagnosticData`. For the full output of piping the copy cmdlet to send, see **Copy_Send.txt** in the [Appendix](#appendix). This command includes all the output you’d see from the send command with the copy command included.

If you already collected logs in a folder and need to look up the stamp ID, you can run this command:  

```powershell  
Get-ObservabilityStampId | Send-DiagnosticData `  
-ResourceGroupName "Resource group" `  
-SubscriptionId "Subscription Id" `  
-TenantId "Tenant Id" `  
-DiagnosticLogPath "C:\path\to\LogsToExport" `  
-RegistrationRegion “eastus”  
```  

The `Get-ObservabilityStampId` return value is passed into `Send-DiagnosticData` as the **StampId** parameter.

## Appendix  

Expand each section to view detailed information about the corresponding cmdlet:

<details>

<summary>Get-Help Copy-DiagnosticData -Detailed</summary>

```plaintext  
NAME  
    Copy-DiagnosticData  
   
SYNOPSIS  
    Stops the Azure Local VM running disconnected, mounts required VHDs, retrieves the observability stamp ID (if available) and  
    copies diagnostic logs from the mounted VHDs to a 'LogsToExport' folder nested in the provided  
    'DiagnosticLogPath' location.  
   
SYNTAX  
    Copy-DiagnosticData [-DiagnosticLogPath] <String> [[-Roles] <String[]>] [[-FromDate] <Nullable`1>] [[-ToDate] <Nullable`1>] [<CommonParameters>]  
   
DESCRIPTION  
    Stops the Azure Local VM running disconnected, mounts required VHDs, retrieves the observability stamp ID (if available) and  
    copies diagnostic logs from the mounted VHDs to a 'LogsToExport' folder nested in the provided  
    'DiagnosticLogPath' location.  
   
PARAMETERS  
    -DiagnosticLogPath <String>  
        The destination path which will contain copied logs and temporarily mounted VHDs.  
        If this cmdlet is piped into the Send-DiagnosticData cmdlet, this is also the default  
        location where the Standalone Observability pipeline is installed and logs activity.  
  
    -Roles <String[]>  
        Optional. Roles to be included in log collection. Roles available are: Agents, Oplets, MASLogs,  
        ServiceFabric, ArcADiagnostics, Observability, WindowsEventLogs, CosmosDb, and Storage.  
        Default: All roles *except* CosmosDB and Storage.  
  
    -FromDate <Nullable`1>  
        Optional. Start time of logs to be included in collection. Logs before this date are excluded.  
        Default: If not provided, from date is set to four hours before ToDate.  
  
    -ToDate <Nullable`1>  
        Optional. End time of logs to be included in collection. Logs after this date are excluded.  
        Default: If not provided, to date is set to the current time.  
  
    <CommonParameters>  
        This cmdlet supports the common parameters: VVERBOSE, Debug,  
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,  
        OutBuffer, PipelineVariable, and OutVariable. For more information, see  
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).  
  
    -------------------------- EXAMPLE 1 --------------------------  
    PS C:\>Copy-DiagnosticData -DiagnosticLogPath "C:"  
  
    -------------------------- EXAMPLE 2 --------------------------  
    PS C:\>Copy-DiagnosticData -DiagnosticLogPath "C:/path/to/copied_logs_parent_directory"  
  
    -------------------------- EXAMPLE 3 --------------------------  
    PS C:\>Copy-DiagnosticData -DiagnosticLogPath "C:" -Roles @("Agents", "Oplets", "ServiceFabric")  
  
    -------------------------- EXAMPLE 4 --------------------------  
    PS C:\>$fromDate = [datetime]"03/13/2024 12:00:00"  
    $toDate = [datetime]"03/13/2024 15:00:00"  
    Copy-DiagnosticData -DiagnosticLogPath "C:" -FromDate $fromDate -ToDate $toDate  
   
REMARKS  
    To see the examples, type: "get-help Copy-DiagnosticData -examples".  
    For more information, type: "get-help Copy-DiagnosticData -detailed".  
    For technical information, type: "get-help Copy-DiagnosticData -full".  
```

</details>

<details>

<summary>Get-Help Get-ObservabilityStampId -Detailed</summary>

```plaintext  
NAME  
    Get-ObservabilityStampId  
   
SYNOPSIS  
    Gets the observability stamp ID if successful; otherwise returns null.  
   
SYNTAX  
    Get-ObservabilityStampId [[-MountPath] <String>] [<CommonParameters>]  
   
DESCRIPTION  
    Gets the observability stamp ID if successful; otherwise returns null.  
   
PARAMETERS  
    -MountPath <String>  
        Optional. A valid drive or path to temporarily hold mounted VHDs used to retrieve the stamp ID.  
        Default: "${env:USERPROFILE}/MountedVHDs" # File is removed on cleanup at cmdlet end.  
  
    <CommonParameters>  
        This cmdlet supports the common parameters: VVERBOSE, Debug,  
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,  
        OutBuffer, PipelineVariable, and OutVariable. For more information, see  
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).  
  
    -------------------------- EXAMPLE 1 --------------------------  
    PS C:\>Get-ObservabilityStampId  
  
    -------------------------- EXAMPLE 2 --------------------------  
    PS C:\>Get-ObservabilityStampId -MountPath "C:/temp/path”  
   
REMARKS  
    To see the examples, type: "get-help Get-ObservabilityStampId -examples".  
    For more information, type: "get-help Get-ObservabilityStampId -detailed".  
    For technical information, type: "get-help Get-ObservabilityStampId -full".  
```

</details>

<details>

<summary>Get-Help Send-DiagnosticData -Detailed</summary>

```plaintext  
NAME  
    Send-DiagnosticData  
   
SYNOPSIS  
    Sends diagnostics data using standalone observability pipeline. Intended for use in cases where  
    standard log collection is unavailable.  
   
SYNTAX  
    Send-DiagnosticData -ResourceGroupName <String> -SubscriptionId <String> -TenantId <String> [-RegistrationWithDeviceCode] -RegistrationRegion <String> [-Cloud <String>] -DiagnosticLogPath <String> [-ObsRootFolderPath <String>] [-StampId <Guid>]    [<CommonParameters>]  
  
    Send-DiagnosticData -ResourceGroupName <String> -SubscriptionId <String> -TenantId <String> -RegistrationWithCredential <PSCredential> -RegistrationRegion <String> [-Cloud <String>] -DiagnosticLogPath <String> [-ObsRootFolderPath <String>] [-StampId    <Guid>] [<CommonParameters>]  
   
DESCRIPTION  
    Accepts a directory location (DiagnosticLogPath) from which logs are sent via the standalone  
    observability pipeline to be ingested into Kusto.  
   
PARAMETERS  
    -ResourceGroupName <String>  
        Azure Resource group name where temporary Arc resource will be created.  
  
    -SubscriptionId <String>  
        Azure SubscriptionID where temporary Arc resource will be created.  
  
    -TenantId <String>  
        Azure TenantID where temporary Arc resource will be created.  
  
    -RegistrationWithDeviceCode [<SwitchParameter>]  
        Switch to use device code for authentication. This is the default if Service Principal  
        credentials (-RegistrationWithCredential {creds}) is not provided.  
  
    -RegistrationWithCredential <PSCredential>  
        Service Principal credentials used for authentication to register ArcAgent.  
  
    -RegistrationRegion <String>  
        Azure registration region where Arc resource will be created, e.g. 'eastus' or 'westeurope'.  
  
    -Cloud <String>  
        Optional. Azure cloud environment to use for registration.  
        Default: AzureCloud  
  
    -DiagnosticLogPath <String>  
        Path to a directory containing the logs to be parsed and sent to Microsoft.  
  
    -ObsRootFolderPath <String>  
        Optional. Observability root folder path where the observability pipeline is (temporarily)  
        installed and activity logs related to sending diagnostic data are output.  
        Default: {DiagnosticLogPath}\..\SendLogs_{yyyyMMddTHHmmssffff}  
                 (a new file created in the DiagnosticLogPath *parent* directory)  
  
    -StampId <Guid>  
        Optional. The value set for the AEOStampId GUID used for tracking collected logs in Kusto.  
        Default: The AEOStampId used will default to the first of the following options applicable:  
           1. The StampId (if provided)  
           2. $env:STAMP_GUID (if set)  
           3. The host machine's UUID  
  
    <CommonParameters>  
        This cmdlet supports the common parameters: VVERBOSE, Debug,  
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,  
        OutBuffer, PipelineVariable, and OutVariable. For more information, see  
        about_CommonParameters (https:/go.microsoft.com/fwlink/?LinkID=113216).  
  
    -------------------------- EXAMPLE 1 --------------------------  
    PS C:\># Interactive registration with device code (used by default)  
    Send-DiagnosticData -ResourceGroupName "Resource group" `  
                                -SubscriptionId "Subscription Id" `  
                                -TenantId "Tenant Id" `   
                                -RegistrationRegion "eastus" `  
                                -DiagnosticLogPath "C:\path\to\LogsToExport" `  
                                -StampId "Stamp ID"  
  
    -------------------------- EXAMPLE 2 --------------------------  
    PS C:\># Interactive registration with device code (declared explicitly)  
    Send-DiagnosticData -ResourceGroupName "Resource group" `  
                                -SubscriptionId "Subscription Id" `  
                                -TenantId "Tenant Id" ` 
                                -RegistrationWithDeviceCode `  
                                -RegistrationRegion "eastus" `  
                                -DiagnosticLogPath "C:\path\to\LogsToExport" `  
                                -StampId "Stamp ID"  
  
    -------------------------- EXAMPLE 3 --------------------------  
    PS C:\># Registration with Service Principal Credential  
    Send-DiagnosticData -ResourceGroupName "Resource group" `  
                                -SubscriptionId "Subscription Id" `  
                                -TenantId "Tenant Id" `  
                                -RegistrationWithCredential {$credential} `  
                                -RegistrationRegion "eastus" `  
                                -DiagnosticLogPath "C:\path\to\LogsToExport" `  
                                -StampId "Stamp ID"  
  
    -------------------------- EXAMPLE 4 --------------------------  
    PS C:\># Get-ObservabilityStampId pipes the Observability Id as the 'StampId' if available.  
    Get-ObservabilityStampId | Send-DiagnosticData `  
        -ResourceGroupName "Resource group" `  
        -SubscriptionId "Subscription Id" `  
        -TenantId "Tenant Id" `  
        -RegstrationRegion “eastus” `  
        -DiagnosticLogPath "C:\path\to\LogsToExport"  
  
    -------------------------- EXAMPLE 5 --------------------------  
    PS C:\># Copy-DiagnosticData pipes the 'DiagnosticLogPath' (always) and the Observability Id  
    # as the 'StampId' if available.  
    Copy-DiagnosticData -DiagnosticLogPath "C:" -Roles @("ServiceFabric") `  
        | Send-DiagnosticData -ResourceGroupName "Resource group" `  
                                      -SubscriptionId "Subscription Id" `  
                                      -TenantId "Tenant Id" `  
                                      -RegstrationRegion “eastus”  
   
REMARKS  
    To see the examples, type: "get-help Send-DiagnosticData -examples".  
    For more information, type: "get-help Send-DiagnosticData -detailed".  
    For technical information, type: "get-help Send-DiagnosticData -full".  
```

</details>

<details>

<summary>Copy_Send.txt</summary>

```plaintext  
PS C:\> $roles = @("Agents", "Oplets", "MASLogs")  
PS C:\> Copy-DiagnosticData -DiagnosticLogPath "G:" -Roles $roles `  
>>    | Send-DiagnosticData `  
>>       -ResourceGroupName "Resource group" `  
>>       -RegistrationRegion "eastus" `  
>>       -SubscriptionId "Subscription Id" `  
>>       -TenantId "Tentant Id" `  
>>       -RegistrationWithCredential $sp  
```

</details>

## Related content