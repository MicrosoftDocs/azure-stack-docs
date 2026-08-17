---
title: Start-SecretRotation privileged endpoint cmdlet for Azure Stack Hub
description: Reference for PowerShell Azure Stack Hub privileged endpoint - Start-SecretRotation
author: sethmanheim

ms.topic: reference
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Start-SecretRotation

## Synopsis
Triggers secret rotation on a stamp.

## Syntax

```
Start-SecretRotation [-PathAccessCredential <Object>] [-ReRun] [-CertificatePassword <Object>] [-Internal]
 [-PfxFilesPath <Object>] [-AsJob]
```

## Description
Invokes the secret rotation process for infrastructure secrets of an Azure Stack Hub system. By default, it rotates only the certificates of external network infrastructure endpoints. See [Rotate secrets in Azure Stack Hub](../../operator/azure-stack-rotate-secrets.md) for more details.

## Parameters

### -Internal
Rotate secrets for internal network infrastructure endpoints.

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

### -PfxFilesPath
Path of the new pfx files shared for external certs rotation.
Include this parameter if you want to rotate external certificates.

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

### -PathAccessCredential
Credentials to access PfxFilesPath.
Include this parameter if you want to rotate external certificates.

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

### -CertificatePassword
Password for the new PFX files.
Include this parameter if you want to rotate external certificates.
This password can be different from the original PFX password that you provided during deployment.
The process regenerates the PFX files with the correct CA password.

Usage ::

```console
    # Rotates external certificates only
    Start-SecretRotation -PfxFilesPath \<String\> -PathAccessCredential \<PSCredential\> -CertificatePassword \<SecureString\>

    # Rotates internal secrets only
    Start-SecretRotation -Internal  

    # Reruns internal secrets only
    Start-SecretRotation -Internal -ReRun 

    # Reruns external certificates only
    Start-SecretRotation -ReRun
```

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

### -ReRun
 

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
