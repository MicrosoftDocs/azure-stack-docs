---
title: Collect Logs On-Demand with Azure Local Disconnected Operations (preview)
description: Learn how to use the PowerShell module to collect logs on demand for Azure Local disconnected operations (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 08/06/2025
ai-usage: ai-assisted
---

# Collect logs on demand with Azure Local disconnected operations PowerShell module

::: moniker range=">=azloc-2506"

This article explains how to collect logs on demand for Azure Local disconnected operations using the PowerShell module. Learn how to provide logs for troubleshooting and support when Azure Local operates in disconnected mode.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Overview

Log collection is essential for diagnosing and troubleshooting issues in Azure Local disconnected operations. Use this feature to provide logs to Microsoft support. The logs collected include information about the Azure Local disconnected operations environment, such as the management endpoint, integrated runtime, and other components. Note, during the process of collecting logs, you might encounter errors due to various environmental and tooling limitations.

## Supported scenarios

The following on-demand scenarios are supported for log collection:

| Scenarios for log collection             | How to collect logs                    |
|------------------------------------------|----------------------------------------|
| [Use on-demand direct log collection](#log-collection-when-connected-to-azure-with-an-accessible-management-endpoint) when an on-premises device with Azure Local disconnected operations is connected to Azure and the management endpoint for disconnected operations is accessible. | Trigger log collection with cmdlet `Invoke-ApplianceLogCollection`.<br></br>**Prerequisite**: Setup observability configuration using the cmdlet: `Set-ApplianceObservabilityConfiguration`. |
| [Use on-demand indirect log collection](#log-collection-for-a-disconnected-environment-with-an-accessible-management-endpoint) when an on-premises device using Azure Local disconnected operations doesn't have a connection to Azure, but the management endpoint for disconnected operations is accessible. | Trigger log collection with cmdlet `Invoke-ApplianceLogCollectionAndSaveToShareFolder`.<br></br> After the `Invoke-ApplianceLogCollectionAndSaveToShareFolder` step, use the `Send-DiagnosticData` cmdlet to upload the copied data logs from the file share to Microsoft.  |
| [Use on-demand fallback log collection](#log-collection-when-the-management-endpoint-is-inaccessible) when the management endpoint for disconnected operations isn't accessible or the integrated runtime disconnected operations with Azure Local virtual machine (VM) is down. | Logs are collected after shutting down the disconnected operations with Azure Local VM, mounting and unlocking virtual hard disks (VHDs) and copying logs using the `Copy-DiagnosticData` cmdlet from mounted VHDs into a local, user-defined location.<br></br> Use the `Send-DiagnosticData` cmdlet to manually send diagnostic data to Microsoft. |

## Azure Local disconnected when the appliance VM isn't connected to Azure

In disconnected Azure Local environments, you collect logs from the control plane (appliance) and host nodes, then manually upload them with a standalone tool.

The following diagram shows the key components for log collection in Azure Local disconnected when the appliance VM isn't connected to Azure:

:::image type="content" source="./media/disconnected-operations/on-demand-logs/on-demand-components.png" alt-text="Screenshot showing the key components for on-demand log collection in Azure Local disconnected operations." lightbox=" ./media/disconnected-operations/on-demand-logs/on-demand-components.png":::

To collect logs from the control plane, follow these steps:

1. Collect control plane logs. Run the following command on a system with access to the appliance VM (usually the same Hyper-V host):

```powershell
Invoke-ApplianceLogCollectionAndSaveToShareFolder
```

This command gathers logs from the appliance VM and saves them to a specified shared folder.

1. Collect host node logs. On each Azure Local host node, run:

```powershell
Send-DiagnosticData -SaveToPath <shared folder path>
```

This command collects logs specific to the node, including system and cluster-level diagnostics.

For more information on the Send-DiagnosticData command, see [Fallback log collection](disconnected-operations-fallback.md).

1. Upload logs using the **standalone observability tool**.

    After you save logs from both the appliance and host nodes to a shared location, upload them with the standalone observability tool:

    - For appliance logs: Use the tool version that supports logs collected with `Send-DiagnosticData`.
    - For host node logs: Use the `Send-AzStackHciDiagnosticData` command to upload logs from the host node.

## Azure Local disconnected when the appliance VM is connected to Azure

When the appliance VM is connected to Azure, upload host node logs the same way as in the Azure Local disconnected scenario. For control plane logs, send them directly using `Invoke-ApplianceLogCollection`; you don't need to save them locally first.

The following diagram shows the key components for log collection in Azure Local disconnected when the appliance VM is connected to Azure:

:::image type="content" source="./media/disconnected-operations/on-demand-logs-2/on-demand-components.png" alt-text="Screenshot showing the key components for on-demand log collection in Azure Local disconnected operations." lightbox=" ./media/disconnected-operations/on-demand-logs/on-demand-components-2.png":::

Here's what you need to perform log collection in a connected disconnected operations scenario.

1. Use [Deploy disconnected operations for Azure Local (Preview)](disconnected-operations-deploy.md) to set up the following Azure resources:
  
    - A resource group in Azure for the appliance.
    - A Service Principal (SPN) with contributor rights on the resource group.
    - Copy the `AppId` and `Password` from the output. Use them as **ServicePrincipalId** and **ServicePrincipalSecret** during observability setup.

1. Install the operations module if it's not installed. Use the `Import-Module` cmdlet and modify the path to match your folder structure.

    ```azurecli
    Import-Module "<disconnected operations module folder path>\Azure.Local.DisconnectedOperations.psd1" -Force
    ```

    Here's an example output:

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

    ```azurecli
    $certPasswordPlainText = "***"
    $certPassword = ConvertTo-SecureString $certPasswordPlainText -AsPlainText -Force
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "<Management Endpoint Client Cert Path>" -ManagementEndpointClientCertificatePassword $certPassword -ManagementEndpointIpAddress "<Management Endpoint IP address>"
    ```

1. Retrieve BitLocker keys:
  
    ```azurecli
    $recoveryKeys = Get-ApplianceBitlockerRecoveryKeys $context # context can be omitted if context is set.
    $recoveryKeys
    ```

    Here's the example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> $recoverykeySet = Get-ApplianceBitlockerRecoveryKeys  
    >> $recoverykeySet | ConvertTo-JSON > c:\recoveryKey.json  
    VERBOSE: [2025-03-26 21:57:01Z][Get-ApplianceBitlockerRecoveryKeys] [START] Get bitlocker recovery keys.
    VERBOSE: [2025-03-26 21:57:01Z][Invoke-ScriptsWithRetry] Executing 'Script Block' with timeout 300 seconds ...
    VERBOSE: [2025-03-26 21:57:01Z][Invoke-ScriptsWithRetry] [CHECK][Attempt 0] for task 'Script Block' ...
    VERBOSE: [2025-03-26 21:57:01Z][Invoke-ScriptsWithRetry] Task 'Script Block' succeeded.
    VERBOSE: [2025-03-26 21:57:01Z][Get-ApplianceBitlockerRecoveryKeys] [END] Get bitlocker recovery keys.
    PS C:\Users\administrator.s46r2004\Documents> Get-content c:\recoveryKey.json
    ```

> [!NOTE]
> For each deployment, the management IP address, management endpoint client certificate, and certificate password are different. Make sure you use the correct values for your deployment.

<!--## Trigger on demand log collection

To trigger on demand log collection in Azure Local disconnected operations, use the following cmdlets with the parameters FromDate and ToDate in PowerShell:

- `Invoke-ApplianceLogCollection`
- `Invoke-ApplianceLogCollectionAndSaveToShareFolder`
- `Get-ApplianceLogCollectionHistory`
- `Get-ApplianceLogCollectionJobStatus`

> [!NOTE]
> Run these commands on the host that can access the management endpoint.

## Triage Azure Local issues

Use the following cmdlets and references to triage Azure Local issues.

- `AzsSupportDataBundle`. For more information, see [Azure Local Support Diagnostic Tool](/azure/azure-local/manage/support-tools).
- `Send-AzStackHciDiagnosticData`. For more information, see [Get support for Azure Local deployment issues](/azure/azure-local/manage/get-support-for-deployment-issues).
- `Get-SDDCDiagnosticInfo` and upload it to customer service and support (CSS) data transfer manager (DTM) share. For more information, see [Collect diagnostic data for clusters](/azure/azure-local/manage/collect-diagnostic-data).-->

## Log collection for a disconnected environment with an accessible management endpoint

In this scenario, use the management application programming interface (API) to copy logs from disconnected operations to a shared folder. You can review the logs locally or upload them to Microsoft with the `Send-DiagnosticData` cmdlet.

Trigger log collection in your disconnected environment by running `Invoke-ApplianceLogCollectionAndSaveToShareFolder`.

Before you trigger a log collection, create a share and credentials for a share.

1. Create a share. Run this command:

    ```PowerShell
    New-SMBShare -Name <share-name> -Path <path-to-share> -FullAccess Users -ChangeAccess 'Server Operators'
    ```

1. Create PSCredentials to the share. Run this command:

    ```PowerShell
    $user = "<username>"
    $pass = "<password>"
    $sec=ConvertTo-SecureString -String $pass -AsPlainText -Force
    $shareCredential = New-Object System.Management.Automation.PSCredential ($user, $sec)
    ```

1. Trigger log collection with the `Invoke-ApplianceLogCollectionAndSaveToShareFolder`.

    Here's an example:

    ```azurecli
    $fromDate = (Get-Date).AddMinutes(-30)
    $toDate = (Get-Date)
    $operationId = Invoke-ApplianceLogCollectionAndSaveToShareFolder -FromDate $fromDate -ToDate $toDate `
    -LogOutputShareFolderPath "<File Share Path>" -ShareFolderUsername "ShareFolderUser" -ShareFolderPassword (ConvertTo-SecureString "<Share Folder Password>" -AsPlainText -Force)
    ```

1. Copy logs from your disconnected environment to the share folder.

    Here's an example:

    ```azurecli
    $fromDate = (Get-Date).ToUniversalTime().AddHours(-1)
    $toDate = (Get-Date).ToUniversalTime()
    
    $onDemandRequestBody = @{
        FromDate = $fromDate.ToString("o")
        ToDate = $toDate.ToString("o")
        SaveToPath = "<share folder path>" # \\10.11.206.2\irvmlogs\winfieldlogs
        UserPassword = "****"
        UserName = "<share folder user name>" # 10.11.206.2\administrator
    } | ConvertTo-JSON
    
    $mgmtClientCert = "***" # The client certificate to access management endpoint
    $mgmtIpAddress = "***"
    
    $OperationId = Invoke-RestMethod -Certificate $mgmtClientCert -Method "PUT" -URI "https://$($mgmtIpAddress):9443/logs/logCollectionIndirectJob" -Content "application/json" -Body $onDemandRequestBody -Verbose
    ```

1. Check the status of the log collection job.

    Use the `Get-ApplianceLogCollectionJobStatus` or `Get-ApplianceLogCollectionHistory` cmdlet to retrieve the current log collection job status.

    Here's an example:

    ```azurecli
    Get-ApplianceLogCollectionJobStatus -OperationId $OperationId
    ```

    ```azurecli
    Get-ApplianceLogCollectionHistory -FromDate ((Get-Date).AddHours(-3))
    ```

    Here's an example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> $operationId = Invoke-ApplianceLogCollectionAndSaveToShareFolder -FromDate $fromDate -ToDate $toDate -LogOutputShareFolderPath "\\<LogShareName>\$logShareName" -ShareFolderUsername "<Username>.masd.stbtest.microsoft.com\administrator" -ShareFolderPassword (ConvertTo-SecureString "<Password>" -AsPlainText -Force)  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ApplianceLogCollectionAndSaveToShareFolder] Trigger log collections with parameters:  
    https://<IP address>/logs/logCollectionIndirectJob  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ScriptsWithRetry] Executing 'Trigger log collection ...' with timeout 600 seconds ...  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ScriptsWithRetry] [CHECK] [Attempt 0] for task 'Trigger log collection ...' ...  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ScriptsWithRetry] Task 'Trigger log collection ...' succeeded.  
    VERBOSE: [2023-04-09 22:34:28Z] [Invoke-ApplianceLogCollectionAndSaveToShareFolder] Log collections trigger result: "<Instance Id>"  
    PS C:\Users\administrator.s46r2004\Documents> Get-ApplianceLogCollectionJobStatus -OperationId $operationId  
    VERBOSE: [2023-04-09 22:35:29Z] [Invoke-ScriptsWithRetry] Executing 'Get log collection job status ...' with timeout 600 seconds ...  
    VERBOSE: [2023-04-09 22:35:29Z] [Invoke-ScriptsWithRetry] [CHECK] [Attempt 0] for task 'Get log collection job status ...' ...  
    VERBOSE: [2023-04-09 22:35:29Z] [Invoke-ScriptsWithRetry] Task 'Get log collection job status ...' succeeded.  
      
    StatusRecord                               
       @{Instance Id=<Instance Id>; State=Running; StartTime=0001-01-01T00:00:00; EndTime=0001-01-01T00:00:00} 
    ```

    Here's an example output:

    ```console

    PS C:\Users\administrator.s46r2004\Documents> $onDemandRequestBody  
    Name        Value  
    ----        -----  
    SaveToPath  \\<IP address>\Arc\LogsShare1  
    FromDate    2025-04-09T21:26:51.8237434+00:00  
    UserName    masd.stbtest.microsoft.com\administrator  
    ToDate      2025-04-10T21:56:50.7453871+00:00  
    UserPassword <Password>  
      
    PS C:\Users\administrator.s46r2004\Documents> $response = Invoke-WebRequest -Uri "http://<IP address>:7345/logCollectionIndirectJob" -Method Put -Body $onDemandRequestBody | ConvertTo-Json -ContentType 'application/json' -UseBasicParsing  
    PS C:\Users\administrator.s46r2004\Documents> $response  
      
    StatusCode        : 200  
    StatusDescription : OK 
    Content           : 
    RawContent        : HTTP/1.1 200 OK  
                        x-ms-correlation-request-id: <Correlation Id>  
                        Content-Length: 38  
                        Content-Type: application/json; charset=utf-8  
                        Date: Thu, 10 Apr 2025 14:59:27 GMT  
                        Server: Micr...  
    Forms  
    Headers           : {[x-ms-correlation-request-id, <Correlation Id>], [Content-Length, 38], [Content-Type, application/json; charset=utf-8], [Date, Thu, 10 Apr 2025 14:59:27 GMT]...}  
    Images            : {}
    InputFields       : {} 
    Links             : {} 
    ParsedHtml        :   
    RawContentLength  : 38  
    ```

    Here's an example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> Get-ApplianceLogCollectionJobStatus -OperationId $operationId  
    VERBOSE: [2025-04-10 15:07:33Z] [Invoke-ScriptsWithRetry] Executing 'Get log collection job status ...' with timeout 600 seconds ...  
    VERBOSE: [2025-04-10 15:07:33Z] [Invoke-ScriptsWithRetry] [CHECK] [Attempt 0] for task 'Get log collection job status ...' ...  
    VERBOSE: [2025-04-10 15:07:33Z] [Invoke-ScriptsWithRetry] Task 'Get log collection job status ...' succeeded.  
      
    StatusRecord
    -----------  
    @{IntanceId=<Instance Id>; State=Succeeded; StartTime=2025-04-10T14:59:43.8936665Z; EndTime=2025-04-10T15:07:11.0920805Z}
      
    PS C:\Users\administrator.s46r2004\Documents> dir C:\Arc\Logs1  
      
        Directory: C:\Arc\Logs1  
      
    Mode                LastWriteTime         Length Name  
    ----                -------------         ------ ----  
    ----                4/10/2025  3:05 PM           LO_06ec98de-c1c4-406f-a5a9-89f2b803c70f_IRVM01  
    ```

1. Send diagnostic data to Microsoft.
    1. Use the `Send-DiagnosticData` cmdlet to manually send diagnostics data to Microsoft. For more information, see [Send-DiagnosticData](disconnected-operations-fallback.md#send-diagnosticdata).

    2. Unzip all files into the share folder.

    ```azurecli
    $logShareFolderPath = "***"
    $unzipLogPath = "***"
    $files = Get-ChildItem -Path $logShareFolderPath | Where-Object { $_.Extension -like "*.zip*" }
    foreach ($file in $files) {
        Expand-Achive -Path $file.FullName -Destination $unzipLogPath -Verbose
    }
    ```

1. Get the stamp ID

    ```azurecli
    $stampId = (Get-ApplianceInstanceConfiguration).StampId
    ```

## Log collection for control plane when connected to Azure with an accessible management endpoint

Before you can start log collection and get the Stamp ID, set up the observability configuration with Azure Local disconnected operations module.

1. To check that the observability configuration is set up. Use the Get-`ApplianceObservabilityConfiguration` or `Get-Appliancehealthstate` cmdlet:

    Here's an example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> Get-ApplianceHealthState  
    VERBOSE: [2025-03-26 22:43:43Z][Invoke-ScriptsWithRetry] Executing 'Get health state ...' with timeout 300 seconds ...  
    VERBOSE: [2025-03-26 22:43:43Z][Invoke-ScriptsWithRetry] [CHECK][Attempt 0] for task 'Get health state ...' ...  
    VERBOSE: [2025-03-26 22:43:44Z][Invoke-ScriptsWithRetry] Task 'Get health state ...' succeeded.  
      
    SystemReady ReadinessStatusDetails ErrorMessages  
    ----------- ---------------------- -------------  
    False       @{Services=79; Diagnostics=100; Identity=100; Networking=100} @{Services=System.Object[]; Diagnostics=System.Object[]; Identity=System.Object[]; Networking=System.Object[]}  
    ```

    > [!NOTE]
    > If the observability configuration is set up, skip step 2 and proceed to step 3.

1. If the observability configuration isn't set up, run the following script:

    ```azurecli
    $observabilityConfiguration = New-ApplianceObservabilityConfiguration `
      -ResourceGroupName "WinfieldPreview" `
      -TenantId "<Tenant Id>" `
      -Location "eastus" `
      -SubscriptionId "<Subscription Id>" `
      -ServicePrincipalId "<Service Principal Id of the one you prepared for log collection>" `
      -ServicePrincipalSecret (ConvertTO-SecureString "Service Principal secret of the one for log collection" -AsPlainText -Force")
    Set-ApplianceObservabilityConfiguration -ObservabilityConfiguration $observabilityConfiguration
    ```

    Here's an example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> $observabilityConfiguration = New-ApplianceObservabilityConfiguration `  
    >> -ResourceGroupName "WinfieldPreviewShip" `  
    >> -ServerId "<Server Id>" `  
    >> -Location "eastus" `  
    >> -SubscriptionId "<Subscription Id>" `  
    >> -ClientId "<Client ID>" `  
    >> -ServicePrincipalSecret (ConvertTo-SecureString "SY5T0_9@_eFlLoSdB1uck_1v_0S0#Mf1O#A0o" -AsPlainText -Force)  
    PS C:\Users\administrator.s46r2004\Documents> Set-ApplianceObservabilityConfiguration -ObservabilityConfiguration $observabilityConfiguration  
    VERBOSE: [2025-03-26 22:34:56Z][ConfigureObservability] [START] Set observability configuration  
    VERBOSE: [2025-03-26 22:34:56Z][Invoke-ScriptsWithRetry] Executing 'Setting up diagnostics ...' with timeout 300 seconds ...  
    VERBOSE: [2025-03-26 22:34:56Z][Invoke-ScriptsWithRetry] [CHECK][Attempt 0] for task 'Setting up diagnostics ...' ...  
    VERBOSE: [2025-03-26 22:34:56Z][ScriptBlock] [INFO] Result of observability configuration: ...  
    VERBOSE: [2025-03-26 22:34:56Z][Invoke-ScriptsWithRetry] Task 'Setting up diagnostics ...' succeeded.  
    VERBOSE: [2025-03-26 22:34:56Z][Invoke-ScriptsWithRetry] Executing 'Wait Diagnostics ready' with timeout 1200 seconds ...  
    VERBOSE: [2025-03-26 22:34:56Z][Invoke-ScriptsWithRetry] [CHECK][Attempt 0] for task 'Wait Diagnostics ready' ...  
    VERBOSE: [2025-03-26 22:34:56Z][Invoke-ScriptsWithRetry] Executing 'Get health state ...' with timeout 300 seconds ...  
    VERBOSE: [2025-03-26 22:34:56Z][Invoke-ScriptsWithRetry] [CHECK][Attempt 0] for task 'Get health state ...' ...  
    VERBOSE: [2025-03-26 22:34:56Z][Invoke-ScriptsWithRetry] Task 'Get health state ...' succeeded.  
    VERBOSE: [2025-03-26 22:34:56Z][ScriptBlock] System Readiness information:  
    
    SystemReady ReadinessStatusDetails ErrorMessages  
    ----------- ---------------------- -------------  
    False       @{Services=22; Diagnostics=0; Identity=100; Networking=100} @{Services=System.Object[]; Diagnostics=System.Object[]; Identity=System.Object[]; Networking=System.Object[]}  
    ```

1. Trigger log collection. Run the `Invoke-applianceLogCollection` cmdlet.

    ```azurecli
    $fromDate = (Get-Date).AddMinutes(-30)
    $toDate = (Get-Date)
    $operationId = Invoke-ApplianceLogCollection -FromDate $fromDate -ToDate $toDate
    ```

1. Check the status of the log collection job. Use the `Get-ApplianceLogCollectionJobStatus` or `Get-ApplianceLogCollectionHistory` cmdlet.

    ```azurecli
    Get-ApplianceLogCollectionJobStatus -OperationId $OperationId
    ```

    ```azurecli
    Get-ApplianceLogCollectionHistory -FromDate ((Get-Date).AddHours(-3))
    ```

1. Get the stamp ID

    ```azurecli
    $stampId = (Get-ApplianceInstanceConfiguration).StampId
    ```

    Here's an example output:

    ```console
    PS C:\Users\administrator.s46r2004\Documents> $stampId = (Get-ApplianceInstanceConfiguration).StampId  
    VERBOSE: [2025-03-27 19:56:41Z][Invoke-ScriptsWithRetry] Executing 'Retrieving system configuration ...' with timeout 300 seconds ...  
    VERBOSE: [2025-03-27 19:56:41Z][Invoke-ScriptsWithRetry] [CHECK][Attempt 0] for task 'Retrieving system configuration ...' ...  
    VERBOSE: [2025-03-27 19:56:41Z][ScriptBlock] Getting system configuration from https://100.69.172.253:9443/sysconfig/SystemConfiguration  
    VERBOSE: [2025-03-27 19:56:42Z][Invoke-ScriptsWithRetry] Task 'Retrieving system configuration ...' succeeded.  
    PS C:\Users\administrator.s46r2004\Documents> $stampId <Stamp ID>
    ```

## Log collection when the management endpoint is inaccessible

The `Send-DiagnosticData` cmdlet collects logs and, if needed, securely sends them to Microsoft for analysis. It works with both Azure Stack HCI and Azure Local environments, helping troubleshoot issues by providing detailed telemetry and diagnostic data. This cmdlet is available when the [Telemetry and Diagnostics](../concepts/telemetry-and-diagnostics-overview.md) extension is installed, ensuring all components needed for log collection and upload are in place.

What Send-DiagnosticData does:

- Collects logs from the local system, including:
  - Role-specific logs
  - Supplementary logs
  - Software Defined Data Center (SDDC) log (Optional)

- Supports filtering by:
  - Role
  - Date range
  - Log type

- Can bypass observability agents to collect logs only on the node where the command is run.

- Allows saving logs locally using the `-SaveToPath` parameter.

- Supports secure credentialed access when saving to a network share.

## Security considerations

- In air-gapped environments, this is the only supported method to extract and provide diagnostic logs to Microsoft.
- Logs are not automatically transmitted unless explicitly configured.
- Logs can be saved locally and reviewed before sharing.
- Logs may contain sensitive operational metadata but do not include PII (Personally Identifiable Information) by default.
- Microsoft does not retain access to logs unless they are explicitly shared by the customer.

If your organization does not allow direct internet connectivity from the affected node, follow these steps:

1. Use the -SaveToPath option to store logs locally.
2. Transfer the logs to a separate VM or system that is permitted to connect to the internet.
3. Use that system to upload the logs to Microsoft via secure support channels.

This approach ensures that diagnostic data can still be shared for support purposes without compromising the integrity of your air-gapped environment.

### Use Fallback log collection

Use fallback log collection to collect and send logs when the disconnected operations with Azure Local VM is down, the management endpoint isn't accessible, and you can't invoke standard log collection.

There are three methods used in this scenario:

- **Copy-DiagnosticData**: Copy logs from the disconnected operations with Azure Local VM to a local folder.
- **Send-DiagnosticData**: Send logs to Microsoft for analysis.
- **Get-observabilityStampId**: Get the stamp ID.

For more information, see [Use appliance fallback log collection](disconnected-operations-fallback.md).

## Common issues

- `Copy-DiagnosticData`: this cmdlet must be run on the Hyper-V host that is hosting your Azure Local disconnected VM.

- `Send-DiagnosticData`: this cmdlet must be run on a windows machine that has direct internet access to Azure and is not arc-enabled and does not use the appliance as its arc control plane.

- `Invoke-ApplianceLogCollectionAndSaveToShareFolder`: you need to specify the account in the format: Domain\Username, if you omit the domain or use an incorrect username, the copy operation to the share will fail with an access-denied error.

## When to use on-demand log collection

Use on-demand direct log collection when an on-premises device running Azure Local temporarily has connectivity to Azure.

- Improper Execution of Send-DiagnosticData.
  - Log collection fails when customers attempt to run Send-DiagnosticData or copy diagnostic data from:
    - Nodes that are not part of the Azure Local host infrastructure.
    - External machines (e.g., personal laptops) that do not host the required appliance VMs (such as IRVM) on the same Hyper-V host.

- Misuse of the Observability Tool.
  - The Standalone Observability Tool must be:
    - Run on a Windows Server.
    - Configured with additional manual steps if executed in unsupported environments.

### Indirect or Fallback Log Collection (Disconnected Mode)

Use indirect log collection methods when direct upload is not possible:

- Run the following commands on the seed node:
  - `Invoke-ApplianceLogCollectionAndSaveToShareFolder`
  - `Copy-DiagnosticData`

- Ensure that:
  - The share folder is accessible.
  - Troubleshooting instructions are provided for common failures (e.g., permission issues, missing dependencies).

### Uploading Logs to Microsoft Support

To upload collected logs to Microsoft:

- Use the Send-DiagnosticData command from the Azure Local Disconnected Operations PowerShell module.
- Important: This command must not be run on Azure Local host nodes, as those are managed by the ALDO control plane.
- Instead, run it from a Windows machine with Azure connectivity—ideally the customer’s laptop or desktop.

## Related content

- Learn how and when to use [Use appliance fallback log collection](disconnected-operations-fallback.md).

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506.

::: moniker-end
