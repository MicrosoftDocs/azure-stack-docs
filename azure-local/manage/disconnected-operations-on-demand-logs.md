---
title: Collect Logs On-Demand with Azure Local Disconnected Operations (preview)
description: Learn how to use the PowerShell module to collect logs on-demand for Azure Local disconnected operations (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 10/15/2025
ai-usage: ai-assisted
---

# Collect logs on-demand with the Azure Local disconnected operations PowerShell module

::: moniker range=">=azloc-2506"

This article explains how to collect logs on-demand for Azure Local disconnected operations by using the PowerShell module. You learn how to provide logs for troubleshooting and support when Azure Local operates in disconnected mode.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Overview

Log collection helps you diagnose and troubleshoot issues in Azure Local disconnected operations. Use this feature to send logs to Microsoft support. Logs include information about the Azure Local disconnected operations environment, like the management endpoint, integrated runtime, and other components. During log collection, you might see errors because of different environmental or tool limitations.

> [!IMPORTANT]
> Before you use on-demand direct log collection, complete the prerequisites and set up observability with the `Set-ApplianceObservabilityConfiguration` cmdlet. If you skip these steps, you might see an error.

## Prerequisites

Before you set up observability for your Azure Local appliance, make sure you:

- [Deploy Disconnected Operations for Azure Local (preview)](disconnected-operations-deploy.md)
- [Set up observability for diagnostics and support](#set-up-observability-for-diagnostics-and-support)
- Have enough disk space for both compressed and uncompressed logs when you upload with diagnostic tools. The required space depends on the log size.
  - For typical log collection, keep at least 20 GB of free space.
  - For larger log bundles, such as those from an Azure Local appliance, compressed logs can exceed 25 GB, and uncompressed logs can be even larger because of extra metadata and processing.
    - As a rule, keep at least twice the compressed log size available. For example:
      - For a 10 GB compressed log bundle, keep at least 20 GB free.
      - For a 25 GB compressed bundle, keep at least 50 GB free.

> [!NOTE]
> Upload logs in small batches to reduce processing time and disk usage. Before you start, check your disk space to prevent failures because of low storage.

## Workflow

To collect logs on-demand, follow these steps:

- [Prerequisites](#prerequisites)
- [Select a log collection method for your connectivity scenario](#supported-scenarios)
- [Collect logs](#log-collection-cmdlets)
- [Monitor log collection](#monitor-log-collection)
- Review logs locally or [send them to Microsoft](#use-send-diagnosticdata)

[!INCLUDE [disconnected-operations-observability-diagnostics](../includes/disconnected-operations-observability-diagnostics.md)]

## Supported scenarios

The following on-demand scenarios are supported for log collection:

| Scenario for log collection             | How to collect logs                    |
|------------------------------------------|----------------------------------------|
| [Use on-demand direct log collection](#azure-local-disconnected-when-the-appliance-vm-is-connected-to-azure) when an on-premises device with Azure Local disconnected operations connects to Azure and the management endpoint for disconnected operations is accessible. | To collect logs, run the `Invoke-ApplianceLogCollection` cmdlet. |
| [Use on-demand indirect log collection](#azure-local-disconnected-when-the-appliance-vm-isnt-connected-to-azure) when an on-premises device using Azure Local disconnected operations can't connect to Azure but can still reach the management endpoint for disconnected operations. | Trigger log collection with the `Invoke-ApplianceLogCollectionAndSaveToShareFolder` cmdlet.<br></br> After you run the `Invoke-ApplianceLogCollectionAndSaveToShareFolder` cmdlet, use the `Send-DiagnosticData` cmdlet to upload the copied logs from the file share to Microsoft. |
| [Use on-demand fallback log collection](./disconnected-operations-fallback.md) when the management endpoint for disconnected operations isn't accessible or the integrated runtime disconnected operations with Azure Local virtual machine (VM) is down. | Collect logs after you shut down the disconnected operations appliance VM, mount and unlock virtual hard disks (VHDs), and copy logs by using the `Copy-DiagnosticData` cmdlet from mounted VHDs into a local, user-defined location.<br></br> Use the `Send-DiagnosticData` cmdlet to manually send diagnostic data to Microsoft. For more information, see [Appliance fallback log collection for disconnected operations](./disconnected-operations-fallback.md). |

For a list of unsupported features in disconnected mode, see [Unsupported features in disconnected mode](#unsupported-features-in-disconnected-mode).

> [!IMPORTANT]
> Don’t run the `Send-DiagnosticData` cmdlet on Azure Local host nodes. The Azure Local disconnected operations control plane manages these nodes. Run the cmdlet from a Windows machine with Azure connectivity, such as your laptop or desktop.

## Azure Local disconnected when the appliance VM is connected to Azure

When the appliance VM is connected to Azure, you can upload host node logs the same way you do in the Azure Local disconnected scenario. For control plane logs, send them directly by using `Invoke-ApplianceLogCollection`. You don't need to save them locally.

The following diagram shows the key components for log collection in Azure Local disconnected when the appliance VM is connected to Azure:

:::image type="content" source="./media/disconnected-operations/on-demand-logs/on-demand-components-2.png" alt-text="Diagram that shows the key components for on-demand log collection in Azure Local disconnected operations." lightbox=" ./media/disconnected-operations/on-demand-logs/on-demand-components-2.png":::

> [!NOTE]
> For each deployment, the management IP address, management endpoint client certificate, and certificate password are different. Make sure you use the correct values for your deployment.

Before you collect logs in a connected disconnected scenario, make sure you:

1. Complete each of the [Prerequisites](#prerequisites).

1. Install the operations module if it's not installed. Use the `Import-Module` cmdlet and change the path to match your folder structure.

    ```powershell
    Import-Module "<disconnected operations module folder path>\Azure.Local.DisconnectedOperations.psd1" -Force
    ```

    Example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> Import-Module "Q:\AzureLocalVHD\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force  
    VERBOSE: [2025-03-26 19:49:12Z][Test-RunningRequirements] PSVersionTable:  
      
    Name                           Value  
    ----                           -----  
    PSVersion                      5.1.26100.2161  
    PSEdition                      Desktop  
    PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}  
    BuildVersion                   10.0.26100.2161  
    CLRVersion                     4.0.30319.42000  
    WSManStackVersion              3.0  
    PSRemotingProtocolVersion      2.3  
    SerializationVersion           1.1.0.1  
      
    VERBOSE: See Readme.md for directions on how to use this module.
    ```

1. Use [Deploy disconnected operations for Azure Local (Preview)](disconnected-operations-deploy.md) for your management endpoint.

    - Identify your management endpoint IP address.
    - Identify the management client certificate used to authenticate with the Azure Local disconnected operations management endpoint.
    - Set up the management endpoint client context. Run this script:

    ```PowerShell
    $certPasswordPlainText = "***"
    $certPassword = ConvertTo-SecureString $certPasswordPlainText -AsPlainText -Force
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "<Management Endpoint Client Cert Path>" -ManagementEndpointClientCertificatePassword $certPassword -ManagementEndpointIpAddress "<Management Endpoint IP address>"
    ```

1. Collect control plane logs. Run this command on a system that can access the appliance VM (usually the same Hyper-V host):

    ```powershell
    Invoke-ApplianceLogCollection
    ```

    This command gathers logs from the appliance VM and sends them directly to Microsoft support.

1. Collect host node logs. On each Azure Local host node, run this command:

    ```powershell
    Send-DiagnosticData -SaveToPath <shared folder path>
    ```

    This command collects logs specific to the node, including system level and cluster level diagnostics. For more information, see [Send-DiagnosticData -SaveToPath](#send-diagnosticdata--savetopath-disconnected-mode).

1. Upload host node logs by using the **standalone observability tool** and running the `Send-AzStackHciDiagnosticData` command.

    To learn more about the `Send-AzStackHciDiagnosticData` command, see [Get support for Azure Local deployment issues](../manage/get-support-for-deployment-issues.md).

## Azure Local disconnected when the appliance VM isn't connected to Azure

In disconnected Azure Local environments, you can collect logs from the control plane (appliance) and host nodes, and then manually upload them with a standalone tool.

The following diagram shows key components for log collection in Azure Local disconnected environments when the appliance VM isn't connected to Azure.

:::image type="content" source="./media/disconnected-operations/on-demand-logs/on-demand-components.png" alt-text="Diagram that shows key components for on-demand log collection in Azure Local disconnected operations." lightbox=" ./media/disconnected-operations/on-demand-logs/on-demand-components.png":::

Before you collect logs in a disconnected scenario, make sure you:

1. Install the operations module if it's not installed. Use the `Import-Module` cmdlet and change the path to match your folder structure.

    ```powershell
    Import-Module "<disconnected operations module folder path>\Azure.Local.DisconnectedOperations.psd1" -Force
    ```

    Example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> Import-Module "Q:\AzureLocalVHD\OperationsModule\Azure.Local.DisconnectedOperations.psd1" -Force  
    VERBOSE: [2025-03-26 19:49:12Z][Test-RunningRequirements] PSVersionTable:  
      
    Name                           Value  
    ----                           -----  
    PSVersion                      5.1.26100.2161  
    PSEdition                      Desktop  
    PSCompatibleVersions           {1.0, 2.0, 3.0, 4.0...}  
    BuildVersion                   10.0.26100.2161  
    CLRVersion                     4.0.30319.42000  
    WSManStackVersion              3.0  
    PSRemotingProtocolVersion      2.3  
    SerializationVersion           1.1.0.1  
      
    VERBOSE: See Readme.md for directions on how to use this module.
    ```

1. Use [Deploy disconnected operations for Azure Local (Preview)](disconnected-operations-deploy.md) for your management endpoint.

    - Identify your management endpoint IP address.
    - Identify the management client certificate used to authenticate with the Azure Local disconnected operations management endpoint.
    - Set up the management endpoint client context. Run this script:

    ```PowerShell
    $certPasswordPlainText = "***"
    $certPassword = ConvertTo-SecureString $certPasswordPlainText -AsPlainText -Force
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "<Management Endpoint Client Cert Path>" -ManagementEndpointClientCertificatePassword $certPassword -ManagementEndpointIpAddress "<Management Endpoint IP address>"
    ```

1. Create a share. Run this command:

    ```powerShell
    New-SMBShare -Name `<share-name>` -Path `<path-to-share>` -FullAccess Users -ChangeAccess 'Server Operators'
    ```

1. Set up credentials for the share. Replace the placeholder text `<share-name>` and `<path-to-share>` with your own values, then run this command:

    ```powerShell
    $user = "<username>"
    $pass = "<password>"
    $sec=ConvertTo-SecureString -String $pass -AsPlainText -Force
    $shareCredential = New-Object System.Management.Automation.PSCredential ($user, $sec)
    ```

1. Collect control plane logs. Run this command on a system that can access the appliance VM (usually the same Hyper-V host):

    ```powershell
    Invoke-ApplianceLogCollectionAndSaveToShareFolder
    ```

    This command gathers logs from the appliance VM and saves them to the shared folder you specify.

    Example:

    ```azurecli
    $fromDate = (Get-Date).AddMinutes(-30)
    $toDate = (Get-Date)
    $operationId = Invoke-ApplianceLogCollectionAndSaveToShareFolder -FromDate $fromDate -ToDate $toDate `
    -LogOutputShareFolderPath "<File Share Path>" -ShareFolderUsername "ShareFolderUser" -ShareFolderPassword (ConvertTo-SecureString "<Share Folder Password>" -AsPlainText -Force)
    ```

    Example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> $operationId = Invoke-ApplianceLogCollectionAndSaveToShareFolder -FromDate $fromDate -ToDate $toDate -LogOutputShareFolderPath "\\<LogShareName>\$logShareName" -ShareFolderUsername "<Username>.masd.stbtest.microsoft.com\administrator" -ShareFolderPassword (ConvertTo-SecureString "<Password>" -AsPlainText -Force)  
        
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ApplianceLogCollectionAndSaveToShareFolder] Trigger log collections with parameters:  
    https://<IP address>/logs/logCollectionIndirectJob  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ScriptsWithRetry] Executing 'Trigger log collection ...' with timeout 600 seconds ...  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ScriptsWithRetry] [CHECK] [Attempt 0] for task 'Trigger log collection ...' ...  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ScriptsWithRetry] Task 'Trigger log collection ...' succeeded.  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ApplianceLogCollectionAndSaveToShareFolder] Log collections trigger result: "<Instance Id>"  
    
    PS C:\Users\administrator.s46r2004\Documents> $onDemandRequestBody  
    Name        Value  
    ----        -----  
    SaveToPath  \\<IP address>\Arc\LogsShare1  
    FromDate    2025-04-09T21:26:51.8237434+00:00  
    UserName    masd.stbtest.microsoft.com\administrator  
    ToDate      2025-04-10T21:56:50.7453871+00:00  
    UserPassword <Password>
    ```

1. Collect host node logs. On each Azure Local host node, run this command:

    ```powershell
    Send-DiagnosticData -SaveToPath <shared folder path>
    ```

    This command collects logs specific to the node, including system level and cluster level diagnostics. For more information, see [Send-DiagnosticData -SaveToPath](#send-diagnosticdata--savetopath-disconnected-mode).

1. Upload logs by using the **standalone observability tool**.

    After you save logs from both the appliance and host nodes to a shared location, upload them with the standalone observability tool. There are product specific wrappers around **Microsoft.AzureStack.Observability.Standalone**.

    - For appliance logs: To upload logs from the appliance VM, use the `Send-DiagnosticData` command from the Azure Local disconnected operations PowerShell module.
    - For host node logs: To upload logs from the host node, use the `Send-AzStackHciDiagnosticData` command.

    To learn more about the `Send-AzStackHciDiagnosticData` command, see [Get support for Azure Local deployment issues](../manage/get-support-for-deployment-issues.md).

1. After collection, review the logs locally or upload them to Microsoft with the [`Send-DiagnosticData`](#use-send-diagnosticdata) cmdlet.

## Log collection cmdlets

### Invoke-ApplianceLogCollection

Use the `Invoke-ApplianceLogCollection` cmdlet to collect diagnostic logs from your Azure Local appliance on demand. Use this cmdlet when you need to troubleshoot issues or when Microsoft Support requests logs.

The cmdlet lets you specify a time range for log collection. Run this cmdlet from a host that has the required PowerShell module imported and that can access the appliance management endpoint.

### Invoke-ApplianceLogCollectionAndSaveToShareFolder

Use the `Invoke-ApplianceLogCollectionAndSaveToShareFolder` cmdlet to collect logs in your disconnected environment and copy them from the disconnected operations appliance VM to a shared folder. Use this cmdlet when the disconnected operations appliance VM management endpoint is accessible.

### Send-DiagnosticData -SaveToPath (disconnected mode)

The `Send-DiagnosticData -SaveToPath` cmdlet works in disconnected mode, and is the only supported option to copy logs from Azure Local host nodes. This cmdlet provides detailed diagnostic data to help you troubleshoot issues and is available when the [telemetry and diagnostics extension](../concepts/telemetry-and-diagnostics-overview.md) is installed.

This cmdlet:

- Is available when the [telemetry and diagnostics extension](../concepts/telemetry-and-diagnostics-overview.md) is installed.
- Provides detailed diagnostic data to help you troubleshoot issues.

Capabilities:

- Collects role-specific and supplementary logs, and optional Software Defined Data Center logs
- Filters logs by role, date range, or log type.
- Runs only on the node where you execute the command, and bypasses observability agents.
- Saves logs locally only when you use the `-SaveToPath` parameter.
- Supports secure credentials to save logs to a network share.

### Send-DiagnosticData

The `Send-DiagnosticData` cmdlet lets you send logs to Microsoft support through the standalone pipeline.

This cmdlet requires:

- Subscription details: *ResourceGroupName*, *SubscriptionId*, *TenantId*, and *RegistrationRegion*.
- Credentials: Either through manual sign-in or by providing the appropriate *service principal* and *password*.

Review the [Set up observability for diagnostics and support](#set-up-observability-for-diagnostics-and-support) section for steps to create the *resource group* and *service principal* required to upload logs.

The standalone pipeline:

- Connects your host machine to Azure.
- Targets all logs in a folder you provided.
- Uploads them to Microsoft support.
  - If the upload fails, the cmdlet tries up to three times and shows the results when finished.

> [!NOTE]
> Run `Send-DiagnosticData` on a Windows machine connected to the internet.
>
> - You can't run this cmdlet on Azure Local Hosts because they can't use Azure as the Arc control plane when disconnected operations are set up.
> - When you run the cmdlet, the machine uses Arc registration to upload data to Microsoft support.
>   - *RegistrationRegion* is the same as *Location* in `ObservabilityConfiguration`.

Use this method when you can’t collect logs directly from the appliance VM, for example:

- The appliance VM is disconnected from Azure.
- The management endpoint isn’t accessible.

#### Send-DiagnosticData cmdlet examples

Here are some examples of how to use the `Send-DiagnosticData` cmdlet.

- To import the module, run this command:

    ```powershell
    Import-Module "Q:\AzureLocalVHD\OperationsModule\ApplianceFallbackLogging.psm1" -Force
    Send-DiagnosticData -ResourceGroupName <String> -SubscriptionId <String> -TenantId <String> [-RegistrationWithDeviceCode] -RegistrationRegion <String> [-Cloud <String>] -DiagnosticLogPath <String> [-ObsRootFolderPath <String>] [-StampId <Guid>] [<CommonParameters>]
    ```

- To sign in manually by using a device code, run this command:

    ```powerShell
    Send-DiagnosticData -ResourceGroupName <String> -SubscriptionId <String> -TenantId <String> [-RegistrationWithDeviceCode] -RegistrationRegion <String> [-Cloud <String>] -DiagnosticLogPath <String> [-ObsRootFolderPath <String>] [-StampId <Guid>] [<CommonParameters>]
    ```

- To use service principal credentials, run this command:

    ```powerShell
    Send-DiagnosticData -ResourceGroupName <String> -SubscriptionId <String> -TenantId <String> -RegistrationWithCredential <PSCredential> -RegistrationRegion <String> [-Cloud <String>] -DiagnosticLogPath <String> [-ObsRootFolderPath <String>] [-StampId <Guid>] [<CommonParameters>]
    ```

## Monitor log collection

Use these commands to monitor log collection.

### Get-ApplianceLogCollectionJobStatus

Check the status of the log collection job with this cmdlet.

```powershell
Get-ApplianceLogCollectionJobStatus -OperationId $OperationId
```

Example output:

```console
   PS C:\Users\administrator.s46r2004\Documents> Get-ApplianceLogCollectionJobStatus -OperationId $operationId  
   VERBOSE: [2023-04-09 22:35:29Z] [Invoke-ScriptsWithRetry] Executing 'Get log collection job status ...' with timeout 600 seconds ...  
   VERBOSE: [2023-04-09 22:35:29Z] [Invoke-ScriptsWithRetry] [CHECK] [Attempt 0] for task 'Get log collection job status ...' ...  
   VERBOSE: [2023-04-09 22:35:29Z] [Invoke-ScriptsWithRetry] Task 'Get log collection job status ...' succeeded.  
      
   StatusRecord                               
   @{Instance Id=<Instance Id>; State=Running; StartTime=0001-01-01T00:00:00; EndTime=0001-01-01T00:00:00}
```

### Get-ApplianceLogCollectionHistory

Get log collection history with this cmdlet. The input parameter `FromDate` takes DateTime type, and sets the start time for the history search window. If you don't specify the `FromDate`, the cmdlet searches the last three hours.

```powershell
   Get-ApplianceLogCollectionHistory -FromDate ((Get-Date).AddHours(-5))
```

Example output:

```console
PS G:\azurelocal\OperationsModule> Get-ApplianceLogCollectionHistory -FromDate ((Get-Date).AddHours(-5))
VERBOSE: [2025-10-17 05:16:14Z][Invoke-ScriptsWithRetry][Get-ApplianceLogCollectionHistory] Executing 'Get log collection job history ...' with timeout 600 seconds ...
VERBOSE: [2025-10-17 05:16:14Z][Invoke-ScriptsWithRetry][Get-ApplianceLogCollectionHistory] [CHECK][Attempt 0] for task 'Get log collection job history ...' ...
VERBOSE: [2025-10-17 05:16:14Z][Invoke-ScriptsWithRetry][Get-ApplianceLogCollectionHistory] Task 'Get log collection job history ...' succeeded.
 
 
Name              : b4cffa08-6eb8-4700-a29e-6b5f08824c87
OperationId       : b4cffa08-6eb8-4700-a29e-6b5f08824c87
CorrelationId     : 0436955c-5008-49cb-af54-98b696bcb9bc
State             : Succeeded
CollectionTime    : 2025-10-17T01:13:00.273+00:00
CollectionEndTime : 2025-10-17T02:07:52.069+00:00
FromDate          : 2025-10-17T00:39:40.448+00:00
ToDate            : 2025-10-17T01:09:40.453+00:00
Distributed       : True
JobType           : OnDemand
StorageKind       : Azure
Reason            : User initiated
Error             : @{Code=0}
UploadDetails     : @{UploadStartTime=2025-10-17T01:13:00.273+00:00; UploadSizeInMb=6982; UploadNumberOfFiles=710}
```

### Get-ApplianceInstanceConfiguration

Get the appliance instance configuration, including the stamp ID and resource ID (DeviceARMResourceUri), with this cmdlet.

```powershell
   $stampId = (Get-ApplianceInstanceConfiguration).StampId
```

Example output:

```console
    PS G:\azurelocal\> Get-ApplianceInstanceConfiguration
    VERBOSE: [2025-08-06 00:00:35Z][Invoke-ScriptsWithRetry][Get-ApplianceInstanceConfiguration] Executing 'Retrieving system configuration ...' with timeout 300 seconds ...
    VERBOSE: [2025-08-06 00:00:35Z][Invoke-ScriptsWithRetry][Get-ApplianceInstanceConfiguration] [CHECK][Attempt 0] for task 'Retrieving system configuration ...' ...
    VERBOSE: [2025-08-06 00:00:35Z][`ScriptBlock`] Getting system configuration from https://</IP address>:9443/sysconfig/SystemConfiguration
    VERBOSE: [2025-08-06 00:00:35Z][Invoke-ScriptsWithRetry][Get-ApplianceInstanceConfiguration] Task 'Retrieving system configuration ...' succeeded.
         
         
    IsAutomaticUpdatePreparation :
    ExternalTimeServers          :
    IsTelemetryOptOut            : False
    ExternalDomainSuffix         : autonomous.cloud.private
    ImageVersion                 : 7.1064750419.18210
    IngressNICPrefixLength       : 24
    DeviceARMResourceUri         : /subscriptions/<Subcription ID>/resourceGroups/<Resource group>/providers/Microsoft.Edge/winfields/7dfd0b
    ConnectionIntent             : Connected
    StampId                      : <Stamp ID>
    IngressNICIPAddress          : 10.0.50.4
    DnsForwarderIpAddress        : 10.10.240.23
    IngressNICDefaultGateway     : 10.0.50.1
```

## Security considerations

When you collect diagnostic logs in air-gapped environments, you should understand the security and privacy protections built into this process. The following considerations help ensure that your diagnostic data remains secure while still providing Microsoft with the information needed for effective support.

- In air-gapped environments, use this method to get and give diagnostic logs to Microsoft.
- Logs aren't automatically sent unless you clearly set them to be sent.
- Logs can be saved locally and reviewed before sharing.
- Logs can contain sensitive operational metadata, but they don't include personal data by default.
- Microsoft doesn't keep access to logs unless customers directly share them.

If your organization blocks the affected node from connecting directly to the internet, follow these steps:

1. To store logs locally, use the `-SaveToPath` option.
2. Move the logs to a separate VM or system that can connect to the internet.
3. To upload logs to Microsoft through secure support channels, use that system.

## Common issues

- `Invoke-ApplianceLogCollectionAndSaveToShareFolder`: Specify the account in the format: Domain\Username. If you omit the domain or use an incorrect username, the copy operation to the share fails with an access-denied error.

- `Send-DiagnosticData`: Run this cmdlet on a Windows machine that has direct internet access to Azure, isn't arc-enabled, and doesn't use the appliance as its arc control plane.

- `Copy-DiagnosticData`: Run this cmdlet on the Hyper-V host that hosts your Azure Local disconnected VM.

- **FilterRoles**: The roles required for log collection or diagnostics vary depending on the scenario. To determine the appropriate roles to include, use the `get-help` cmdlet or work with your support contact.

- Improper Execution of `Send-DiagnosticData`
  - Log collection fails when you run `Send-DiagnosticData` or `Copy-DiagnosticData` from:
    - Nodes that aren't part of the Azure Local host infrastructure.
    - External machines (for example, personal laptops) that don't host the required appliance VMs on the same Hyper-V host.

- Misuse of the Observability Tool
  - Run the Standalone Observability Tool on a Windows Server.
  - Set up the tool with more manual steps if you execute it in unsupported environments.

## Unsupported features in disconnected mode

These features are unsupported in disconnected mode.

- Remote support.
- Portal-based log collection.
- Metrics and telemetry streaming.

## Related content

- Learn how and when to [Use appliance fallback log collection](disconnected-operations-fallback.md).

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
