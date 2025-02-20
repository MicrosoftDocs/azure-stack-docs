---
title: Collect logs on-demand with Azure Local disconnected operations (preview)
description: Use PowerShell module to collect logs on demand for Azure Local disconnected operations (preview).
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 02/11/2025
---

# Log collections on demand with Azure Local disconnected operations PowerShell Module

[!INCLUDE [applies-to](../includes/release-2411-1-later.md)]

This document helps you connect with support and provide logs for troubleshooting issues when Azure Local is operating in a disconnected mode.

[!INCLUDE [IMPORTANT](../includes/disconnected-operations-preview.md)]

## Overview

On-demand log collection lets you collect logs from Azure Local disconnected operations for troubleshooting purposes. This feature is useful when you need to provide logs to Microsoft support for troubleshooting issues.

## Supported scenarios

The following on-demand scenarios are supported for log collection:

| Scenarios for log collection             | How to collect logs                    |
|------------------------------------------|----------------------------------------|
| [Use on-demand direct log collection](#log-collection-with-an-accessible-management-endpoint) when an on-premises device with Azure Local disconnected operations is connected to Azure and the management endpoint for disconnected operations is accessible. | Trigger log collection with cmdlet `Invoke-ApplianceLogCollection`.<br></br>**Prerequisite**: Setup observability configuration using the cmdlet: `Set-ApplianceObservabilityConfiguration`. |
| [Use on-demand indirect log collection](#log-collection-with-a-disconnected-environment-and-accessible-management-endpoint) when an on-premises device using Azure Local disconnected operations doesn't have a connection to Azure, but the management endpoint for disconnected operations is accessible. | Trigger log collection with cmdlet `Invoke-ApplianceLogCollectionAndSaveToShareFolder`.<br></br> Manually send diagnostic data to Microsoft after you copy data from a Virtual Hard Disk (VHD) to a host using the `Send-DiagnosticData` cmdlet. |
| [Use on-demand fallback log collection](#log-collection-with-an-inaccessible-management-endpoint) when the management endpoint for disconnected operations isn't accessible or the integrated runtime disconnected operations virtual machine is down. | Logs are collected after shutting down the disconnected operations virtual machine, mounting and unlocking VHDs and copying logs using the `Copy-DiagnosticData` cmdlet from mounted VHDs into a local, user-defined location.<br></br> Manually send diagnostic data to Microsoft using the `Send-DiagnosticData` cmdlet. |

## Trigger on-demand log collection

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
- `Get-SDDCDiagnosticInfo` and upload it to customer service and support (CSS) data transfer manager (DTM) share. For more information, see [Collect diagnostic data for clusters](/azure/azure-local/manage/collect-diagnostic-data).

## Set up service principle for log collection

There are a few prerequisites to perform to set up a service principle for log collection. Follow these steps:

1. Sign-in to Azure.

    ```azurecli
    az login
    ```

2. Create a resource group.

    ```azurecli
    az group create -g WinfieldPreview -l eastus
    ```

3. List accounts to find the tenant ID and subscription ID.

    ```azurecli
    az account list -o table
    ```

4. Create a service principal.

    ```azurecli
    az ad sp create-for-rbac --name "ObsBootcampSPN" --role "Azure Connected Machine Onboarding" --scopes /subscriptions/<GUID>
    ```

5. Copy `AppId` and `Password` from the output. Use them as **ServicePrincipalId** and **ServicePrincipalSecret** during observability setup.

6. [Install the operations module](disconnected-operations-deploy.md).

7. Identify your management endpoint IP address.

8. Identify the management client certificate used to authenticate with the Azure Local disconnected operations management endpoint.

9. Run this command to set up the management endpoint client context.

    ```azurecli
    Import-Module "<disconnected operations Module Folder Path>\Azure.Local.DisconnectedOperations.psd1" -Force
    
    $certPasswordPlainText = "***"
    $certPassword = ConvertTo-SecureString $certPasswordPlainText -AsPlainText -Force
    $context = Set-DisconnectedOperationsClientContext -ManagementEndpointClientCertificatePath "<Management Endpoint Client Cert Path>" -ManagementEndpointClientCertificatePassword $certPassword -ManagementEndpointIpAddress "<Management Endpoint IP address>"
    ```

    Here's example output:

    ```azurecli
    $recoveryKeys = Get-ApplianceBitlockerRecoveryKeys $context # context can be omitted if context is set.
    $recoveryKeys
    ```

> [!NOTE]
> On each deployment, the management IP address, management endpoint client certificate, and certificate password are different. Make sure you know the correct values for your deployment.

## Log collection when connected to Azure with an accessible management endpoint

Before you start, make sure the observability configuration with Azure Local disconnected operations module is set up. Run the following command:

```azurecli
Get-ApplianceObservabilityConfiguration
```

If the observability configuration isn't set up, run the following script:

```azurecli
$observabilityConfiguration = New-ApplianceObservabilityConfiguration `
  -ResourceGroupName "WinfieldPreview" `
  -TenantId "<Tenant Id>" `
  -Location "eastus" `
  -SubscriptionId "<Subscription Id>" `
  -ServicePrincipalId "<Service Principal Id of the one you prepared for log collection>" `
  -ServicePrincipalSecret (Read-Host -AsSecureString "Service Principal secret of the one for log collection")
Set-ApplianceObservabilityConfiguration -ObservabilityConfiguration $observabilityConfiguration
```

1. Trigger log collection. Run the `Invoke-applianceLogCollection` cmdlet.

    ```azurecli
    $fromDate = (Get-Date).AddMinutes(-30)
    $toDate = (Get-Date)
    $operationId = Invoke-ApplianceLogCollection -FromDate $fromDate -ToDate $toDate
    ```

2. Check the status of the log collection job. Use the `Get-ApplianceLogCollectionJobStatus` or `Get-ApplianceLogCollectionHistory` cmdlet.

    ```azurecli
    Get-ApplianceLogCollectionJobStatus -OperationId $OperationId
    ```

    ```azurecli
    Get-ApplianceLogCollectionHistory -FromDate ((Get-Date).AddHours(-3))
    ```

3. Get the stamp ID

    ```azurecli
    $stampId = (Get-ApplianceInstanceConfiguration).StampId
    ```

## Log collection for a disconnected environment and accessible management endpoint

For this scenario, the management API is used to copy logs from disconnected operations to a shared folder. Logs are then analyzed locally or manually uploaded to Microsoft via the `Send-DiagnsticsData` cmdlet.

To trigger log collection if the management endpoint is accessible, follow these steps:

1. Trigger log collection. Run the `Invoke-ApplianceLogCollectionAndSaveToShareFolder` cmdlet.

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

2. Check the status of the log collection job. Use the `Get-ApplianceLogCollectionJobStatus` or `Get-ApplianceLogCollectionHistory` cmdlet.

    ```azurecli
    Get-ApplianceLogCollectionJobStatus -OperationId $OperationId
    ```

    ```azurecli
    Get-ApplianceLogCollectionHistory -FromDate ((Get-Date).AddHours(-3))
    ```

3. Send diagnostic data to Microsoft. Unzip all files into the share folder.

    ```azurecli
    $logShareFolderPath = "***"
    $unzipLogPath = "***"
    $files = Get-ChildItem -Path $logShareFolderPath | Where-Object { $_.Extension -like "*.zip*" }
    foreach ($file in $files) {
        Expand-Achive -Path $file.FullName -Destination $unzipLogPath -Verbose
    }
    ```

4. Get the stamp ID

    ```azurecli
    $stampId = (Get-ApplianceInstanceConfiguration).StampId
    ```

## Log collection with an inaccessible management endpoint

Use fallback log collection to collect and send logs when the disconnected operations virtual machine is down, the management endpoint isn't accessible, and standard log collection can't be invoked.

There are three methods in this scenario:

**Copy-DiagnosticData**: Used to copy logs from the disconnected operations virtual machine to a local folder.
**Send-DiagnosticData**: Used to send logs to Microsoft for analysis.
**Get-observabilityStampId**: Used to get the stamp ID.

For more information, see [Use appliance fallback log collection](disconnected-operations-fallback.md).