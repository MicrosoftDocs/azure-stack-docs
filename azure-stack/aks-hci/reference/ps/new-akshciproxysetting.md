---
title: New-AksHciProxySetting for AKS on Azure Stack HCI
author: mattbriggs
description: The New-AksHciProxySetting PowerShell command creates an object for a new proxy configuration.
ms.topic: reference
ms.date: 02/11/2022
ms.author: mabrigg 
ms.lastreviewed: 02/11/2022
ms.reviewer: nwood

---

# New-AksHciProxySetting

## Synopsis
Create an object defining proxy server settings to pass into `Set-AksHciConfig`.

## Syntax
```powershell
New-AksHciProxySetting -name <String>
                       -http <String>
                       -https <String>
                       -noProxy <String>
                      [-credential <PSCredential>]
                      [-certFile <String>]
```

## Description
Create a proxy settings object to use for all virtual machines in the deployment. This proxy settings object will be used to configure proxy settings across all Kubernetes cluster nodes and underlying VMs.

> [!Note]
> Proxy settings are only applied once during `Install-AksHci` and cannot be changed after installation. All AKS workload clusters created after installation will use the same proxy object. If you change the proxy settings object after running `Install-AksHci` or `New-AksHciCluster`, the settings will NOT be applied to any new or existing Kubernetes workload clusters. 

## Examples

### Configure proxy settings with credentials

Use the `Get-Credential` PowerShell command to create a credential object and pass the credential object to the New-AksHciProxySetting command
```powershell
PS C:\> $proxyCredential=Get-Credential
PS C:\> $proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16 -credential $proxyCredential
```

### Configure proxy settings with a certificate 
```powershell
PS C:\> $proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16 -certFile c:\Temp\proxycert.cer
```

### -name

The alphanumeric name of your proxy settings object for AKS-HCI.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: True
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -http

The URL of the proxy server for HTTP (insecure) requests. i.e. 'http://contosoproxy'.
If the proxy server uses a different port than 80 for HTTP requests 'http://contosoproxy:8080'.

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

### -https

The URL of the proxy server for HTTPS (secure) requests. i.e. 'https://contosoproxy'.
If the proxy server uses a different port than 443 for HTTPS requests 'https://contosoproxy:8443'.

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

### -noProxy

The comma delimited list of URLs, IP Addresses and domains that should be requested directly without going through the proxy server.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
Accept pipeline input: False
Accept wildcard characters: False
```

### -credential

The PS Credential object containing the username and password to authenticate against the proxy server.

```yaml
Type: PSCredential
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -certFile

The filename or certificate string of a PFX formatted client certificate used to authenticate against the proxy server.

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

[AksHci PowerShell Reference](index.md)