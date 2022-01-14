---
title: Repair-AksHciCerts for AKS on Azure Stack HCI
description: The Repair-AksHciCerts PowerShell troubleshoots and fixes errors related to expired certificates for the AKS on Azure Stack HCI host.
author: mattbriggs
ms.topic: reference
ms.date: 6/30/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Repair-AksHciCerts

## Synopsis
Troubleshoots and fixes errors related to expired certificates for the AKS on Azure Stack HCI host.

## Syntax

```powershell
Repair-AksHciClusterCerts [-sshPrivateKeyFile <String>] 
```

## Description
Troubleshoots and fixes errors related to expired certificates for the AKS on Azure Stack HCI host.

## Example

```powershell
PS C:\> Repair-AksHciCerts
```

## Parameters

### -sshPrivateKeyFile
The SSH key used to remotely access the host VMs for the cluster.

```yaml
Type: System.String
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