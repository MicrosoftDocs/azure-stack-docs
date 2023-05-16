---
title: Test-UpdateAksHci for AKS hybrid
author: sethmanheim
description: The Test-UpdateAksHci PowerShell command checks whether any target clusters are outside the supported window for the latest version of AKS hybrid.
ms.topic: reference
ms.date: 05/16/2023
ms.author: sethm 
ms.lastreviewed: 05/16/2023
ms.reviewer: rbaziwane

---

# Test-UpdateAksHci

## Synopsis

Checks whether any target clusters are outside the supported window for the latest version of AKS hybrid.

## Syntax

```powershell
Test-UpdateAksHci
```

## Examples

### Example

```powershell
Test-UpdateAksHci
```

```output
TestName       : Validate AksHci Update
Category       : AksHci
TestResult     : Failed
Details        : Target cluster seasons is operating on a deprecated minor version v1.21.7.
Recommendation : An AKS cluster that is operating on a deprecated minor version has to be updated to a supported version to be eligible for support. Run Update-AksHciCluster before you proceed with this update. See AKS version support policy for details.
```

## Next steps

[AksHci PowerShell reference](index.md)
