---
title: Get-AksHciConfig for AKS on Azure Stack HCI
author: mattbriggs
description: The Get-AksHciConfig PowerShell command lists the current configuration settings for the Azure Kubernetes Service host.
ms.topic: reference
ms.date: 2/12/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: jeguan

---

# Get-AksHciConfig

## Synopsis
List the current configuration settings for the Azure Kubernetes Service host.

## Syntax

```powershell
Get-AksHciConfig | ConvertTo-Json
```

## Description
List the current configuration settings for the Azure Kubernetes Service host. If the `ConvertTo-Json` cmdlet isn't included when running `Get-AksHciConfig`, the values won't be returned and look like the following.

| Name | Value |
| ---- | -----  |
| MOC | {catalog, ipaddressprefix, cloudServiceCidr, deploymentType...}  |
| AksHci | {manifestCache, enableDiagnosticData, installationPackageDir, workingDir...}  |
| KVA | {catalog, vlanid, vnetvippoolend, ring...}  |

When `ConvertTo-Json` is included, the configuration values will be returned as JSON objects.

## Examples

### Example 
```powershell
Get-AksHciConfig | ConvertTo-Json
```

## Next steps

[AksHci PowerShell Reference](index.md)
