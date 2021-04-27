---
title: Get-AksHciProxySetting
author: mkostersitz
description: The Get-AksHciProxySetting PowerShell command retrieves a proxy configuration.
ms.topic: reference
ms.date: 4/16/2021
ms.author: mikek
---

# Get-AksHciProxySetting

## Synopsis
Retrieve a list or an individual proxy settings object.

## Syntax
```powershell
Get-AksHciProxySetting [-name <String>]
```

## Description
If no name is specified `Get-AksHciProxySetting` will return a list of all proxy settings objects known to the AKS-HCI host.

> [!NOTE]
> Only one settings object can be defined and active at this point.

## Examples

### Example return a list of proxy server settings

```powershell
PS C:\> Get-AksHciProxySetting

name                proxyServerHTTP            proxyServerHTTPS                    proxyServerBypass
---------           ------------------         ----------------------              ----------------------
myProxy             <http://contosoproxy:8080>      <https://contosoproxy:8443>    {localhost,127.0.0.1,.svc,10.96.0 ....} 
```

### Example return the details of a proxy server setting

```powershell
PS C:\> Get-AksHciProxySetting -name myProxy

name: myProxy
proxyServerHTTP: <http://contosoproxy:8080>
proxyServerHTTPS: <https://contosoproxy:8443>                   
proxyServerBypass: {localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16}
proxyServerCredential: {PSCredential} 
proxyServerCertFile: 
```

### -name

The alphanumeric name of your proxy setting

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

