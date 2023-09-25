---
title: Collect diagnostic logs for Azure Stack HCI
description: How to collect diagnostic logs and share them with Microsoft.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/20/2023
---

# Collect diagnostic logs

> Applies to: Azure Stack HCI, Supplemental Package; Azure Stack HCI, version 23H2 (preview)

This article describes how to collect diagnostic logs and send them to Microsoft to help identify and fix any issues with your Azure Stack HCI solution.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Collect logs

Use the `Send-DiagnosticData` cmdlet from any Azure Stack HCI server node to manually collect and send diagnostic logs to Microsoft. When you run this cmdlet, the logs are temporarily copied locally. This copy is parsed, sent to Microsoft, and then deleted from your system. Microsoft retains this diagnostic data for up to 29 days and handles it as per the [standard privacy practices](https://privacy.microsoft.com/).

The `Send-DiagnosticData`cmdlet takes some time to complete based on which roles the logs are collecting, time duration specified, and the number of nodes in your Azure Stack HCI environment.

Here's the syntax of the `Send-DiagnosticData` cmdlet:

```powershell
Send-DiagnosticData [[-FilterByRole] <string[]>] [[-FromDate] <datetime>] [[-ToDate] <datetime>] [[-CollectSddc] <bool>]  [<CommonParameters>]
```

where: 

- `FromDate` and `ToDate` parameters collect logs for a particular time period. If these parameters aren't specified, logs are collected for the past one hour by default.

- `FilterByRole` parameter collects logs for each role. Currently, you can use the `FilterByRole` parameter to filter log collection by the following roles. This list of roles may change in a future release.

  - ALM
  - ArcAgent
  - AutonomousLogs
  - BareMetal
  - CommonInfra
  - DeploymentLogs
  - ECE
  - Extension
  - FleetDiagnosticsAgent
  - HCICloudService
  - DownloadService
  - Health
  - HostNetwork
  - MOC_ARB
  - NC
  - ObservabilityAgent
  - ObservabilityLogmanTraces
  - ObservabilityVolume
  - OEMDiagnostics
  - OSUpdateLogs
  - RemoteSupportAgent
  - URP

- `CollectSddc` parameter is set to `$true` by default, which triggers the `Get-SDDCDiagnosticInfo` cmdlet and includes its logs as part of the log collection.

## Examples and sample outputs

Here are some example commands with sample outputs that show how to use the `Send-DiagnosticData` cmdlet with different parameters.

### Send diagnostics data with date filtering

In this example, you send diagnostics data with date filtering for log files for the past two hours:

   ```powershell
   Send-DiagnosticData -FromDate (Get-Date).AddHours(-2) -ToDate (Get-Date)
   ```

   Here's a sample output of this command:

   ```output
   PS C:\CloudDeployment\logs> Send-DiagnosticData -FromDate (Get-Date).AddHours(-2) -ToDate (Get-Date)
   Successfully submitted on-demand. Operation tracking Id: ec0d1a53-f75b-4df5-afb8-cfbf6d4c8118
   Current log collection status: Running
   Waiting for log collection to complete...
   ==== CUT ==================== CUT =======
   Log collection ended with status: Succeeded
   PS C:\CloudDeployment\logs>
   ```

### Send diagnostic data with role filtering

In this example, you send diagnostic data with role filtering for BareMetal and ECE:

   ```powershell
   Send-DiagnosticData -FilterByRole BareMetal, ECE
   ```

   Here's a sample output of this command:

   ```output
   PS C:\Users\docsuser> Send-DiagnosticData -FilterByRole BareMetal, ECE
   FromDate parameter not specified. Setting to default value 09/27/2022 17:13:38
   ToDate parameter not specified. Setting to default value 09/27/2022 18:13:38
   Successfully submitted on-demand. Operation tracking Id: ea5fcb7a-4e54-4de2-b519-88439e0a8149
   Current log collection status: Running
   Waiting for log collection to complete...
   ==== CUT ==================== CUT =======
   Log collection ended with status: Succeeded
   PS C:\Users\docsuser>
   ```

### Get a history of log collection

To get a history of log collections for the last 90 days, enter:

   ```powershell
   Get-LogCollectionHistory  
   ```

   Here's a sample output of the `Get-LogCollectionHistory` cmdlet:

   ```output
   PS C:\CloudDeployment\logs> Get-LogCollectionHistory
   Name                           Value
   ----                           -----
   TimeCollected                  9/29/2022 5:08:14 PM +00:00
   Status                         Succeeded
   CollectionFromDate             9/29/2022 4:07:57 PM +00:00
   CollectionToDate               9/29/2022 5:07:57 PM +00:00
   LogCollectionId                fdcd94c8-1bd2-4ec6-8612-c92d5abd9a84
   Type                           OnDemand
   LogUploadSizeMb                1598
   UploadNumberOfFiles            1924
   Directory
   Location
   Error
   ----------                     ---------------------------------------------------------
   TimeCollected                  9/27/2022 11:57:25 PM +00:00
   Status                         Succeeded
   CollectionFromDate             9/27/2022 9:57:16 PM +00:00
   CollectionToDate               9/27/2022 11:57:16 PM +00:00
   LogCollectionId                f3d8dcc6-901e-4c72-a3cc-210055e6f198
   Type                           OnDemand
   LogUploadSizeMb                1069
   UploadNumberOfFiles            1941
   Directory
   Location
   Error
   PS C:\CloudDeployment\logs>
   ```

## Save logs to a local file share

You can save diagnostic logs to a local Server Message Block (SMB) share if you want to save data locally or don’t have access to send data to Azure.
Run the following command on each node of the cluster to collect logs and save them locally:

```powershell
Send-DiagnosticData –ToSMBShare -BypassObsAgent –SharePath <Path to the SMB share> -ShareCredential <Crendentials to connect to the SharePath>  
```

If you have outbound connectivity from the SMB share where you saved the logs, you can run the following command to send the logs to Microsoft:

```powershell
Send-DiagnosticData –FromSMBShare –BypassObsAgent –SharePath <Path to the SMB share> -ShareCredential <Crendentials to connect to the SharePath>
```

## Next steps

- [Contact Microsoft Support](get-support.md)
- [Review known issues in Azure Stack HCI](../../hci/hci-known-issues.md)