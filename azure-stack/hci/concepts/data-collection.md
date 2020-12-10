---
title: Azure Stack HCI data collection
description: This topic describes the design and policies relevant to diagnostic data collected by Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/10/2020
---

# Azure Stack HCI data collection

> Applies to: Azure Stack HCI, version 20H2

This topic describes required data collected to keep Azure Stack HCI secure, up to date, and working as expected for General Availability (GA) in December 2020.

The data described below is required for Microsoft to provide Azure Stack HCI. This data is collected once a day, and data collection events can be viewed in the event logs. Azure Stack HCI collects the minimum data required to keep your clusters up to date, secure, and operating properly.

   > [!IMPORTANT]
   > The data described below that Azure Stack HCI collects is independent from Windows diagnostic data, which can be configured for various levels of collection. In Azure Stack HCI, the default setting for Windows diagnostic data collection is Security (off), meaning that no Windows diagnostic data is sent unless the administrator changes the diagnostic data settings. For more information, see [Configure Windows diagnostic data in your organization](/windows/privacy/configure-windows-diagnostic-data-in-your-organization). Microsoft is an independent controller of any Windows diagnostic data collected in connection with Azure Stack HCI. Microsoft will handle the Windows diagnostic data in accordance with the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement).

## Data collection and residency

This Azure Stack HCI data: 

- is not sent to Microsoft until the product is registered with Azure. When Azure Stack HCI is unregistered, this data collection stops.
- is logged to the Microsoft-AzureStack-HCI/Analytic event channel. 
- is in JSON format, so that system administrators can examine and analyze the data being sent.
- is stored within the United States in a secure Microsoft-operated datacenter.

## Data retention

Once Azure Stack HCI collects this data, it is retained for 90 days. Aggregated, de-identified data may be kept longer.

## What data is collected?

Azure Stack HCI collects:

- Information about servers such as operating system version, processor model, number of processor cores, memory size, cluster identifier, and hash of hardware ID
- List of installed Azure Stack HCI server features (e.g. BitLocker)
- Information necessary to compute the reliability of the Azure Stack HCI operating system
- Information necessary to compute the reliability of the health collection data
- Information gathered from the event log for specific errors, such as update download failed
- Information for computing storage reliability
- Information for computing physical disk reliability
- Information for computing the reliability of volume encryption
- Information for computing the reliability and performance of Storage Spaces repair
- Information to validate security of the Azure Stack HCI operating system
- Information to compute reliability of the antivirus/antimalware state of the Azure Stack HCI operating system
- Information to correlate reliability of the networking components
- Information to correlate networking performance
- Information to correlate reliability of updates and installations
- Information to measure reliability of Hyper-V
- Information to measure/correlate reliability of the clustering components
- Information to track the success of the Cluster Aware Updating (CAU) feature
- Information to measure/correlate the reliability of the Disaster Recovery feature
- Information to describe the SMB Bandwidth limits applied to Azure Stack HCI servers

## View this data

1. Enable the analytic log using the following PowerShell command:

   ```PowerShell
   wevtutil sl Microsoft-AzureStack-HCI/Analytic /e:True
   ```

2. View the log to see the collected data:

   ```PowerShell
   Get-WinEvent -LogName Microsoft-AzureStack-HCI/Analytic -Oldest
   ```

3. Format the data for exporting:

   ```PowerShell
   Get-WinEvent -LogName Microsoft-AzureStack-HCI/Analytic -Oldest `
   | Where-Object Id -eq 802 `
   | ForEach-Object { 
       [pscustomobject] @{
           TimeCreated = $_.TimeCreated 
           EventName=$_.Properties[0].Value 
           Value=$_.Properties[1].Value 
       } 
   }
   ```
 
The output should look something like this:

```shell
TimeCreated            EventName                                                  Value
-----------            ---------                                                  -----
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.Core                   {"OEMName":"Microsoft Corporation"...
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.ProductFeatures        {"InstalledFeatures":["Server-Core...
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.OSReliability          {"DailyDirtyRestarts":0,"WeeklyDir...
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.DiagnosticHealth       {"DailySuccessfulDiagnosticUploads...
11/16/2020 10:36:28 AM Microsoft.AzureStack.HCI.Diagnostic.ErrorSummary           {"ErrorSummary":[{"EventName":"Win...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.VolumeSummary          {"VolumeCount":2,"HealthyVolumeCou...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.DiskSummary            {"DiskCount":33,"Summary":[]}
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.BitlockerVolumeSummary {"BitlockerVolumeCount":0,"Summary...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.StorageErrors          {"ErrorSummary":[{"EventName":"Sto...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.StorageRepairSummary   {"DailyRepairStartCount":0,"Weekly...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.TrustedPlatformModule  {"Manufacturer":"MSFT","Manufactur...
11/16/2020 10:36:29 AM Microsoft.AzureStack.HCI.Diagnostic.MicrosoftDefender      {"AMEngineVersion":"1.1.17600.5","...
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.NetworkInfo            {"NetworkDirect":true,"NetworkDire...
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.NetworkAdapterSummary  {"NetworkAdapterGroup":[{"DriverNa...
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.OSDeploy               {"OSInstallType":0}
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.ClusterProperties      {"Id":"fd2fc061-b924-4d61-a45b-3b3...
11/16/2020 10:36:30 AM Microsoft.AzureStack.HCI.Diagnostic.DisasterRecovery       {"IsDisasterRecoveryEnabled":false...
```
