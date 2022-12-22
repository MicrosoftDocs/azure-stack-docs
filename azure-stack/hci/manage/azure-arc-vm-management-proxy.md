---
title: Deploy Arc Resource Bridge on Azure Stack HCI via network proxy
description: Learn how to deploy an Arc Resource Bridge using a network proxy on Azure Stack HCI.
ms.topic: how-to
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/22/2022
---

# Deploy Arc Resource Bridge on Azure Stack HCI using a network proxy

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to set up Arc VM management of an Arc Resource Bridge with a network proxy. If your network requires the use of a proxy server to connect to the internet, this article walks you through the steps required.

You need to have access to an Azure Stack HCI cluster and also access to a proxy server for your Arc Resource Bridge.

> [!NOTE]
> This procedure is not available using Windows Admin Center. You must set up [Arc VM management using command line](deploy-arc-resource-bridge-using-command-line.md).

## Required proxy information

You will need the following information about the proxy server to set up Arc VM management for an Arc Resource Bridge:

|Parameter|Description|
|--|--|
|ProxyServerHTTP|HTTP URL and port for the proxy server, such as `http://proxy.corp.contoso.com:8080`|
|ProxyServerHTTPS|HTTPS URL and port for the proxy server, such as `https://proxy.corp.contoso.com:8443`|
|ProxyServerNoProxy|URLs which can bypass proxy, such as<br>Localhost traffic: `localhost,127.0.0.1`<br>Private network address space: `10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8`<br>URLs in your organizations domain: `.contoso.com`|
|ProxyServerUsername|Username for proxy authentication|
|ProxyServerPassword|Password for proxy authentication|
|CertificateFilePath|Certificate filename with full path, such as `C:\Users\Gus\proxycert.crt`|

## Proxy authentication

The supported authentication methods for the proxy server are:

- Use no authentication
- Use username and password-based authentication
- Use certificate-based authentication

### Use no authentication

In a PowerShell window of the host computer, run the following command as an administrator:

```PowerShell
New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vipPoolStart $ControlPlaneIP -vipPoolEnd $ControlPlaneIP -k8snodeippoolstart $VMIP_1 -k8snodeippoolend $VMIP_2 -gateway $Gateway -dnsservers $DNSServers -ipaddressprefix $IPAddressPrefix -vswitchName $vswitchName -vLanID $vlanID -proxyServerHTTP http://proxy.corp.contoso.com:8080 -proxyServerHTTPS https://proxy.corp.contoso.com:8443 -proxyServerNoProxy "localhost,127.0.0.1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8,.contoso.com"
```

### Use username and password authentication

In a PowerShell window of the host computer, run the following command as an administrator:

```PowerShell
New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP -k8snodeippoolstart $VMIP_1 -k8snodeippoolend $VMIP_2 -gateway $Gateway -dnsservers $DNSServers -ipaddressprefix $IPAddressPrefix -vswitchName $vswitchName -vLanID $vlanID -proxyServerHTTP http://proxy.corp.contoso.com:8080 -proxyServerHTTPS https://proxy.corp.contoso.com:8443 -proxyServerNoProxy "localhost,127.0.0.1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8,.contoso.com" -proxyServerUsername <username_for_proxy> -proxyServerPassword <password_for_proxy>
```

### Use certificate-based authentication

In a PowerShell window of the host computer, run the following command as an administrator:

```PowerShell
New-ArcHciConfigFiles -subscriptionID $subscription -location $location -resourceGroup $resource_group -resourceName $resource_name -workDirectory $csv_path\ResourceBridge -controlPlaneIP $controlPlaneIP -vipPoolStart $controlPlaneIP -vipPoolEnd $controlPlaneIP -k8snodeippoolstart $VMIP_1 -k8snodeippoolend $VMIP_2 -gateway $Gateway -dnsservers $DNSServers -ipaddressprefix $IPAddressPrefix -vswitchName $vswitchName -vLanID $vlanID -proxyServerHTTP http://proxy.corp.contoso.com:8080 -proxyServerHTTPS https://proxy.corp.contoso.com:8443 -proxyServerNoProxy "localhost,127.0.0.1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,100.0.0.0/8,.contoso.com" -certificateFilePath <file_path_to_cert_file> 
```

## Configure Arc Resource Bridge

After authentication is set up, use the command line to [Set up Arc VM management](deploy-arc-resource-bridge-using-command-line.md#set-up-arc-vm-management).

## Current limitation

VMs deployed using Arc VM management currently don't support use of a network proxy.

## Next steps

- [What is Azure Arc VM management?](/manage/azure-arc-vm-management-overview)