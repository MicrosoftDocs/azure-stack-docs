---
title: Register-CustomAdfs privileged endpoint for Azure Stack Hub
description: Reference for PowerShell Azure Stack privileged endpoint - Register-CustomAdfs
author: sethmanheim

ms.topic: reference
ms.date: 04/27/2020
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/27/2020
---

# Register-CustomAdfs

## Synopsis
Script to register custom Active Directory Federation Service (AD FS) as claims provider with Azure Stack AD FS

## Syntax

```
Register-CustomAdfs [-CustomADFSFederationMetadataEndpointUri <Object>]
 [-CustomADFSFederationMetadataFileContent <Object>] [-TimeoutInSecs <Object>] [-CustomAdfsName <Object>]
 [-SigningCertificateRevocationCheck <Object>] [-EncryptionCertificateRevocationCheck <Object>] [-AsJob]
```

## Description
Script to register custom Active Directory Federation Service (AD FS) as claims provider with Azure Stack AD FS

## Examples

### Example 1
```
Register-CustomAdfs -CustomAdfsName "Contoso" -CustomADFSFederationMetadataEndpointUri "https://adfs.contoso.com/federationmetadata/2007-06/federationmetadata.xml"  -TimeoutInSecs 1000
```

### Example 2
```
Register-CustomAdfs -CustomAdfsName "Contoso" -CustomADFSFederationMetadataFile "c:\temp\FederationMetadata.xml" -TimeoutInSecs 1000
```
## Parameters

### -CustomAdfsName
 

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

### -CustomADFSFederationMetadataEndpointUri
 

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

### -CustomADFSFederationMetadataFileContent
 

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

### -EncryptionCertificateRevocationCheck
 

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

### -SigningCertificateRevocationCheck
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: CheckChainExcludeRoot
Accept pipeline input: False
Accept wildcard characters: False
```

### -TimeoutInSecs
 

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
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
