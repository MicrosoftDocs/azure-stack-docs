---
title: Export-AksEdgeWorkerNodeConfig for AKS Lite
author: rcheeran
description: The Export-AksEdgeWorkerNodeConfig PowerShell command captures the cluster configurations in a JSON file.
ms.topic: reference
ms.date: 10/04/2022
ms.author: rcheeran 
ms.lastreviewed: 10/04/2022
#ms.reviewer: jeguan

---

# Export-AksEdgeWorkerNodeConfig

## Synopsis

The Export-AksEdgeWorkerNodeConfig PowerShell command captures the cluster configurations in a JSON file

## Syntax

```powershell
Export-AksEdgeWorkerNodeConfig [[-outFile] <String>] [[-WorkloadType] <WorkloadType>] [[-LinuxIp] <String>]
 [[-WindowsIp] <String>] [-ControlPlane]
```

## Parameters

### -ControlPlane

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -LinuxIp

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WindowsIp

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -WorkloadType

```yaml
Type: WorkloadType
Parameter Sets: (All)
Aliases:
Accepted values: Linux, Windows, LinuxAndWindows

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -outFile

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: 0
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```
## Next steps

[Akslite PowerShell Reference](./index.md)
