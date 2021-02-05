---
title: Configure proxy settings for AKS on Azure Stack HCI
description: Learn how to plan and configure proxy support to connect to the internet.
author: abha
ms.topic: how-to
ms.date: 01/27/2021
ms.author: abha
ms.reviewer: 
---

# Configure proxy settings on AKS on Azure Stack HCI

If your network requires the use of a proxy server to connect to the internet, this document walks you through steps required to set up proxy support on AKS on Azure Stack HCI using the AksHci and WinInetProxy PowerShell module. 

If you do not want to use WinInetProxy, you can also use **Internet Properties** (inetcpl.cpl) and click on **Connections** tab and **LAN settings** to configure and veriy your proxy server settings.


## Before you begin

Install the [WinInetProxy](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0) PowerShell module to configure a proxy server by running the following command in a PowerShell administrative window:

```Powershell
Install-Module -Name WinInetProxy -Repository PSGallery
```

For other pre-requisites visit [system requirements](./system-requirements.md). To download the AksHci PowerShell module, visit [set up AksHci Powershell module](./setup-powershell.md).

## Configure a proxy server without authentication

To configure a proxy server that does not require authentication run the following command on each Azure Stack HCI cluster node:

```powershell
Set-WinInetProxy -ProxyServer http://proxy.contoso.com:3128 -ProxyBypass "local"
```

## Configure a proxy server with authentication

To configure a proxy server that requires authentication, you need to configure credentials for the AKS on Azure Stack host to use with the WinINet proxy. This varies depending on what kind of authentication the proxy requires, and can either be NTLM/Kerberos or basic authentication.

> [!NOTE]
> If you want to use a certificate to connect to the proxy server, then you are responsible for provisioning that certificate to the appropriate certificate store on your hosts to ensure that it's trusted.

### Configure a proxy server with NTLM/Kerberos authentication

Add new Windows Credentials using the below command. Enter your secure password when prompted. Alternatively, you can also use Windows Credential Manager under **Windows Credentials** to add a new entry for Windows Credentials. 

```powershell
cmdkey /generic:proxy.contoso.com /user:username /pass
```
When you run this command, you will be asked to enter the password.

In the PowerShell profile, add the following command to allow AKS-HCI agents to use the cached credentials:

```powershell
Set-WinInetProxy -ProxyServer http://proxy.contoso.com:3128 -ProxyBypass "local"
notepad $PROFILE
[System.Net.WebRequest]::DefaultWebProxy.Credentials = [System.Net.CredentialCache]::DefaultCredentials
```  

### Configure a proxy server with basic authentication

You need to add basic authentication credentials need to be added to the PowerShell profile so that the download agent module can use them. 

> [!NOTE]
> The credentials in the PowerShell profile are not encrypted and appear in clear text. Make sure the PowerShell profile is protected by access control lists (ACLs), so only Administrators and the LocalSystem account can view them.

Edit the PowerShell profile to replace the username and password with the basic authentication credentials as shown below:

```powershell
Set-WinInetProxy -ProxyServer http://proxy.contoso.com:3128 -ProxyBypass "local"
notepad $profile
[System.Net.WebRequest]::DefaultWebProxy.Credentials = new-object System.Net.NetworkCredential("username", "password")
```

## Deploy AKS on Azure Stack HCI host using a proxy server

Once your proxy server is configured, you can set proxy configurations for an AKS host installation using the `Set-AksHciConfig` command. There are different sets of steps depending on whether the proxy server requires authentication.

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

## Next steps

- [Deploy a Linux application on your Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows application on your Kubernetes cluster](./deploy-windows-application.md).
