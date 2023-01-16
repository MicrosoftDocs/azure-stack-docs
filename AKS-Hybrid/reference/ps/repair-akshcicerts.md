---
title: Repair-AksHciCerts for AKS on Azure Stack HCI and Windows Server
description: The Repair-AksHciCerts PowerShell troubleshoots and fixes errors related to expired certificates for the AKS on Azure Stack HCI and Windows Server host.
author: sethmanheim
ms.topic: reference
ms.date: 6/16/2022
ms.author: sethm 
ms.lastreviewed: 6/16/2022
ms.reviewer: jeguan

---

# Repair-AksHciCerts

## Synopsis

Troubleshoots and fixes errors related to expired certificates for the AKS on Azure Stack HCI and Windows Server host.

## Syntax

```powershell
Repair-AksHciCerts [-sshPrivateKeyFile <String>] 
```

## Description

**This cmdlet will be deprecated, please use [Update-AksHciCertificates](update-akshcicertificates.md).**

Troubleshoots and fixes errors related to expired certificates for the AKS on Azure Stack HCI and Windows Server host.

## Example

```powershell
Repair-AksHciCerts
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

[AksHci PowerShell reference](index.md)
