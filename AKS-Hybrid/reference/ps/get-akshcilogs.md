---
title: Get-AksHciLogs for AKS hybrid
author: sethmanheim
description: The Get-AksHciLogs PowerShell command creates a zipped folder with logs from all your pods.
ms.topic: reference
ms.date: 02/28/2023
ms.author: sethm 
ms.lastreviewed: 02/28/2023
ms.reviewer: jeguan

---

# Get-AksHciLogs

## Synopsis

Creates a zipped folder with logs from all your pods.

## Syntax

```powershell
Get-AksHciLogs [-virtualMachineLogs]
               [-agentLogs]
               [-eventLogs]
               [-kvaLogs] 
               [-downloadSdkLogs] 
               [-billingRecords] 
```

## Description

Creates a zipped folder with logs from all your pods. This command creates an output zipped folder called `akshcilogs.zip` in your AKS hybrid working directory. The full path to the **akshcilogs.zip** file will be the output after running  `Get-AksHciLogs` (for example, `C:\AksHci\0.9.6.3\akshcilogs.zip`, where `0.9.6.3` is the AKS hybrid release number). When no flags are used, the command collects all logs.

## Examples

### Example 1

This example returns the smallest log size. This size is enough to debug any issues with management cluster pods, target cluster pods, billing, and download issues:

```powershell
Get-AksHciLogs -EventLogs -KvaLogs -DownloadSdkLogs -BillingRecords
```

For example, for billing issues, example 1 should be good enough.

### Example 2

In addition to example 1, this command returns all VM logs. It's larger than example 1, but smaller than example 3:

```powershell
Get-AksHciLogs -EventLogs -KvaLogs -DownloadSdkLogs -BillingRecords -VirtualMachineLogs
```

### Example 3

This example returns MOC logs. It's the largest of all the options.

```powershell
Get-AksHciLogs
```

## Parameters

### -agentLogs

Use this flag to get the logs from the MOC stack cloud agent and node agent services.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -eventLogs
Use this flag to get the event logs logged to event viewer.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -virtualMachineLogs
Use this flag to get the logs from the guest virtual machines created by AKS hybrid.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -kvaLogs
Use this flag to get the logs from the AKS hybrid host.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -downloadSdkLogs
Use this flag to get the download logs from downloading the binaries and images that AKS hybrid uses.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -billingRecords
Use this flag to get the billing records.

```yaml
Type: System.Management.Automation.SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

## Next steps

[AksHci PowerShell reference](index.md)