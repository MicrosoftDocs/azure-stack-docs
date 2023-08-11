---
title: New-GraphApplication privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - New-GraphApplication
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# New-GraphApplication

## Synopsis
New-GraphApplication is a wrapper function to call AD FS Graph cmdlets on AD FS.

## Syntax

```
New-GraphApplication [-ClientCertificates <Object>] [-Name <Object>] [-ClientRedirectUris <Object>]
 [-GenerateClientSecret] [-AsJob]
```

## Description
Invokes the New-GraphApplicationGroup on AD FS to add new application on to AD FS machine.

## Examples

### Example 1
```
New-GraphApplication -Name $ApplicationName -ClientRedirectUris $redirectUri -ClientCertificates $certificate
```

## Parameters

### -Name
Name of the Application with maximum length of 50 chars, It will be modified as `Azurestack-$Name-$({guid}::{NewGuid}())`and is returned by the function.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientRedirectUris
Redirect URI used to create a new application in AD FS.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ClientCertificates
Certificate used to create a new application in AD FS.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -GenerateClientSecret
 

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
