---
title: Set-GraphApplication privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Set-GraphApplication
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Set-GraphApplication

## Synopsis
Set-GraphApplication is a wrapper function to call AD FS Graph cmdlets on AD FS.

## Syntax

```
Set-GraphApplication [-ClientCertificates <Object>] [-ClientRedirectUris <Object>]
 [-ApplicationIdentifier <Object>] [-ChangeClientSecret] [-ResetClientSecret] [-AsJob]
```

## Description
Invokes the Set-GraphApplicationGroup on AD FS to modify an application on to AD FS machine.

## Examples

### Example 1
```
$cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2('c:\temp\testcert.cer')
$appId = 'S-1-1-11-2222222222-3333333333-4444444444-5555'
$script = {
    Set-GraphApplication -ApplicationIdentifier $using:appId -ClientCertificates $using:cert
}
Invoke-Command -ComputerName '<ercs01 computer name>' -ScriptBlock $script -ConfigurationName PrivilegedEndpoint
```

## Parameters

### -ApplicationIdentifier
 

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

### -ResetClientSecret
 

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

### -ChangeClientSecret
 

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
