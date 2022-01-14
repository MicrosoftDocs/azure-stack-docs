---
title: Get-AksHciLogs for AKS on Azure Stack HCI
author: mattbriggs
description: The Get-AksHciLogs PowerShell command creates a zipped folder with logs from all your pods.
ms.topic: reference
ms.date: 04/13/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Get-AksHciLogs

## Synopsis
Create a zipped folder with logs from all your pods. 

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
Create a zipped folder with logs from all your pods. This command will create an output zipped folder called `akshcilogs.zip` in your AKS on Azure Stack HCI working directory. The full path to the `akshcilogs.zip` file will be the output after running  `Get-AksHciLogs` (for example, `C:\AksHci\0.9.6.3\akshcilogs.zip`, where `0.9.6.3` is the AKS on Azure Stack HCI release number). When the no flags are used, then the command will collect all logs.

## Examples

### Example

```powershell
PS C:\> Get-AksHciLogs
```

## Parameters

### -agentLogs
Use this flag to get the logs from the MOC stack Cloud agent and node agent services.

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
Use this flag to get the logs from the guest virtual machines created by Azure Kubernetes Service on Azure Stack HCI.

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
Use this flag to get the logs from the Azure Kubernetes Service on Azure Stack HCI host.

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
Use this flag to get the download logs from downloading the binaries and images that Azure Kubernetes Service on Azure Stack HCI uses.

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

[AksHci PowerShell Reference](index.md)