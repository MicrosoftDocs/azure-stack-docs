---
title: New-AksHciProxySetting for AKS on Azure Stack HCI
author: mkostersitz
description: The New-AksHciProxySetting PowerShell command creates an object for a new proxy configuration.
ms.topic: reference
ms.date: 4/16/2021
ms.author: mikek
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
Create a proxy settings object to use for all virtual machines in the deployment. This proxy settings object can be used to configure the proxy settings across all Azure Stack HCI and Kubernetes cluster nodes.

> [!Note]
> Proxy settings are only applied during `Install-AksHci` and `New-AksHciCluster`. If you change the proxy settings object after running `Install-AksHci` or `New-AksHciCluster`, the new settings will only be applied to new Kubernetes workload clusters. The existing Azure Stack HCI and workload cluster nodes will not be updated.

## Examples

### Configure Proxy Settings with credentials and a proxy exception list

Use the `Get-Credential` PowerShell command to create a credential object and pass the credential object to the New-AksHciProxySetting command
```powershell
PS C:\> $proxyCredential=Get-Credential
PS C:\> $proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 -credential $proxyCredential
```

### Configure Proxy Settings with a certificate and a proxy exception list
```powershell
PS C:\> $proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 -certFile c:\Temp\proxycert.cer
```

### Configure Proxy Settings without credentials and a proxy exception list
```powershell
PS C:\> $proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16
```

### Configure Proxy Settings with credentials and no proxy exception list

Use the `Get-Credential` PowerShell command to create a credential object and pass the credential object to the New-AksHciProxySetting command
```powershell
PS C:\> $proxyCredential=Get-Credential
PS C:\> $proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -credential $proxyCredential
```

### Configure Proxy Settings with a certificate and no proxy exception list
```powershell
PS C:\> $proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -certFile c:\Temp\proxycert.cer
```

### Configure Proxy Settings without credentials and no proxy exception list
```powershell
PS C:\> $proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443
```


### -name

The alphanumeric name of your Proxy Server settings.

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

The comma delimited list of URLs, IP Addresses and domains that should be requested directly without going through the Proxy server.

```yaml
Type: System.String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16
Accept pipeline input: False
Accept wildcard characters: False
```

### -credential

The PS Credential object containing the username and password to authenticate against the Proxy server.

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
Default value: localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16
Accept pipeline input: False
Accept wildcard characters: False
```
## Next steps

[AksHci PowerShell Reference](index.md)