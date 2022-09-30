---
title: Get-AksHciProxySetting for AKS on Azure Stack HCI and Windows Server
author: sethmanheim
description: The Get-AksHciProxySetting PowerShell command retrieves a proxy configuration.
ms.topic: reference
ms.date: 4/16/2021
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek

---

# Get-AksHciProxySetting

## Synopsis
Retrieves a list or an individual proxy settings object.

## Syntax
```powershell
Get-AksHciProxySetting 
```

## Description
 Returns a list of all proxy settings objects known to the AKS on Azure Stack HCI and Windows Server host.

> [!NOTE]
> Only one settings object can be defined and active at this point.

## Examples

### Example return a list of proxy server settings

```powershell
Get-AksHciProxySetting

name                proxyServerHTTP            proxyServerHTTPS                    proxyServerBypass
---------           ------------------         ----------------------              ----------------------
myProxy             <http://contosoproxy:8080>      <https://contosoproxy:8443>    {localhost,127.0.0.1,.svc,10.96.0 ....} 
```

### Example return the details of a proxy server setting

```powershell
Get-AksHciProxySetting -name myProxy

name: myProxy
proxyServerHTTP: <http://contosoproxy:8080>
proxyServerHTTPS: <https://contosoproxy:8443>                   
proxyServerBypass: {localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16}
proxyServerCredential: {PSCredential} 
proxyServerCertFile: 
```
## Next steps

[AksHci PowerShell Reference](index.md)

