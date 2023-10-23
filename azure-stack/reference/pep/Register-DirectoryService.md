---
title: Register-DirectoryService privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint -Register-DirectoryService
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Register-DirectoryService

## Synopsis
Script to register customer Microsoft Entra ID with Graph Service.
**CustomADGlobalCatalog** is the global catalog for custom Active Directory.
This will be `RootDomain` value from output of **Get-ADForest** cmdlet.

## Syntax

```
Register-DirectoryService [-Force] [[-TimeoutInSecs] <Object>] [-SkipRootDomainValidation]
 [[-CustomADAdminCredential] <Object>] [-ValidateParameters] [[-CustomADGlobalCatalog] <Object>] [-AsJob]
```

## Description
Script to register customer Active Directory with Graph Service.
**CustomADGlobalCatalog** is Global Catalog for custom Active Directory.
This will be `RootDomain` value from output of **Get-ADForest** cmdlet.

## Examples

### Example 1
```
Register-DirectoryService -CustomADGlobalCatalog "contoso.com" -CustomADAdminCredential (Get-Credential) -TimeoutInSecs 1000
```

## Parameters

### -CustomADGlobalCatalog
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 1
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CustomADAdminCredential
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 2
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValidateParameters
 

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -SkipRootDomainValidation
 

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -Force
 

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: False
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutInSecs
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: 3
Default value: 1000
Accept pipeline input: False
Accept wildcard characters: False
```

### -AsJob


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

## Next steps

For information on how to access and use the privileged endpoint, see [Use the privileged endpoint in Azure Stack Hub](../../operator/azure-stack-privileged-endpoint.md).
