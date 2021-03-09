---
title: Proxy Server settings in Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about proxy server settings in Azure Kubernetes Service (AKS) on Azure Stack HCI
ms.topic: conceptual
ms.date: 03/04/2021
ms.custom: fasttrack-edit
ms.author: mikek
author: mkostersitz
---
# Use proxy server settings on AKS on Azure Stack HCI

If your network requires the use of a proxy server to connect to the internet, this topic walks you through the steps required to set up proxy support on AKS on Azure Stack HCI using the **AksHci** and **WinInetProxy** PowerShell modules.

## Deploy AKS on Azure Stack HCI host using a proxy server

You can set proxy configurations for an AKS host installation using the `Set-AksHciConfig` command. There are different sets of steps depending on whether the proxy server requires authentication.

Once you have configured your deployment using the options listed below, you can [install an AKS host on Azure Stack HCI](./setup-powershell.md) and [create AKS clusters using PowerShell](./create-kubernetes-cluster-powershell.md).

### Configure an AKS host for a proxy server with basic authentication  

If your proxy server requires authentication, run the following commands to get credentials and then set the configuration details.

```powershell
$proxyCred = Get-Credential
Set-AksHciConfig -proxyServerHTTP "http://proxy.contoso.com:8888" -proxyServerHTTPS "http://proxy.contoso.com:8888" -proxyServerCredential $ProxyCred
```

## Configure an AKS host for a proxy server with NTLM/Kerberos authentication

```powershell
$credential = Get-Credential # get the credential for the proxy server
Set-AksHciConfig -proxyServerHttp "http://proxy.contoso.com:8888" -proxyServerHttps "http://proxy.contoso.com:8888" -proxyServerCredential $credential
```

### Configure an AKS host for a proxy server without authentication  

If your proxy server does not require authentication, open PowerShell as an administrator and run the following command:

```powershell
Set-AksHciConfig -proxyServerHTTP "http://proxy.contoso.com:8888" -proxyServerHTTPS "http://proxy.contoso.com:8888"
```

### Configure an AKS host for a proxy server with a trusted certificate

If your proxy server requires proxy clients to trust a certificate, specify the certificate file when you run `Set-AksHciConfig`. The format of the certificate file is *Base-64 encoded X .509*. This will enable us to provision and trust the certificate throughout our stack:

>[!Important]
>If your proxy requires a certificate to be trusted by the physical Azure Stack HCI nodes, make sure that you have imported the certificate chain to the appropriate certificate store on each Azure Stack HCI node before you continue. Follow the procedures for your deployment to enroll the Azure Stack HCI nodes with the required certificates for proxy authentication.

#### Configure AKS on Azure Stack HCI for using a certificate for proxy authentication

```powershell
Set-AksHciConfig -proxyServerHTTP "http://proxy.contoso.com:8888" -proxyServerHTTPS "http://proxy.contoso.com:8888" -proxyServerCertFile "C:\proxycertificate.crt"
```

> [!NOTE]
> Proxy certificates are not yet provisioned/trusted on Windows Kubernetes worker nodes. Support for Windows workers will be enabled in a future release.

## Exclude specific hosts or domains from using the proxy server

In most networks you'll need to exclude certain networks, hosts, or domains from being accessed through the proxy server. You can do this by exempting address strings using the `-proxyServerNoProxy` parameter in `Set-AksHciConfig`.

The default value for `proxyServerNoProxy` is `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`

When you run this command, the following are excluded:

- The localhost traffic (localhost, 127.0.0.1)
- Internal Kubernetes service traffic (.svc) where _.svc_ represents a wildcard name. This is similar to saying*.svc but no* is used in this schema.
- The private network address space (10.0.0.0/8,172.16.0.0/12,192.168.0.0/16). Note that the private network address space contains important networks, such as the Kubernetes Service CIDR (10.96.0.0/12) and Kubernetes POD CIDR (10.244.0.0/16).

While these default values will work for many networks, you may need to add more subnet ranges and/or names to the exemption list. For example, you may want to exempt your enterprise namespace (.contoso.com) from being directed through the proxy. You can achieve that by specifying the values in the proxyServerNoProxy list:

```powershell
Set-AksHciConfig -proxyServerHttp "http://proxy.contoso.com:8888" -proxyServerHttps "http://proxy.contoso.com:8888" -proxyServerNoProxy "localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.contoso.com"
```

## Next Steps

[Deploy Azure Kubernetes Services on Azure Stack HCI using PowerShell](./setup-powershell.md)