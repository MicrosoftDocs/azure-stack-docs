---
title: Proxy server settings in Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about proxy server settings in Azure Kubernetes Service (AKS) on Azure Stack HCI
ms.topic: conceptual
ms.date: 09/28/2021
ms.custom: fasttrack-edit
ms.author: mikek
author: mkostersitz
---
# Use proxy server settings on AKS on Azure Stack HCI

> [!NOTE]
> This topic covers how to configure proxy settings for AKS on Azure Stack HCI. If you want to use Arc enabled Kubernetes and Azure Services via Azure Arc, make sure you also allow the URLs shown in [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements) when you configure proxy settings for AKS on Azure Stack HCI. 

If your network requires the use of a proxy server to connect to the internet, this topic walks you through the steps required to set up proxy support on AKS on Azure Stack HCI using the **AksHci** PowerShell module. You can set up proxy configurations for an AKS host installation using the [`Set-AksHciConfig`](./reference/ps/set-akshciconfig.md) command. There are different sets of steps depending on whether the proxy server requires authentication.

Once you have configured your deployment using the options listed below, you can [install an AKS host on Azure Stack HCI](./kubernetes-walkthrough-powershell.md) and [create AKS clusters using PowerShell](./kubernetes-walkthrough-powershell.md#step-6-create-a-kubernetes-cluster).

## (Optional) Install PowerShell Modules using a Proxy Server

If your environment uses a proxy server to access the Internet, it may be necessary to add proxy parameters to the **Install-Module** command before installing AKS on Azure Stack HCI. See the [Install-Module Documentation](/powershell/module/powershellget/install-module) for details, and follow the [Azure Stack HCI documentation](/azure-stack/hci/manage/configure-firewalls#set-up-a-proxy-server) to configure the proxy settings on the physical cluster nodes.

## Configure an AKS host for a proxy server with basic authentication

If your proxy server requires authentication, open PowerShell as an administrator and run the following command to get credentials and set the configuration details:

```powershell
$proxyCred = Get-Credential
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 -credential $proxyCredential
Set-AksHciConfig -proxySetting $proxySetting -...
```

## Configure an AKS host for a proxy server without authentication  

If your proxy server does not require authentication, run the following command:

```powershell
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 
Set-AksHciConfig -proxySetting $proxySetting -...
```

## Configure an AKS host for a proxy server with a trusted certificate

If your proxy server requires proxy clients to trust a certificate, specify the certificate file when you run `Set-AksHciConfig`. The format of the certificate file is *Base-64 encoded X .509*. This will enable you to provision and trust the certificate throughout the stack.

> [!Important]
> If your proxy requires a certificate to be trusted by the physical Azure Stack HCI nodes, make sure that you have imported the certificate chain to the appropriate certificate store on each Azure Stack HCI node before you continue. Follow the procedures for your deployment to enroll the Azure Stack HCI nodes with the required certificates for proxy authentication.

## Configure an AKS host to use a certificate for proxy authentication

```powershell
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 -certFile c:\temp\proxycert.pfx
Set-AksHciConfig -proxySetting $proxySetting -...
```

> [!NOTE]
> Proxy certificates must be provided as a personal information exchange (PFX) file format or string, and contain the root authority chain to use the certificate for authentication or for SSL tunnel setup.

## Exclude specific hosts or domains from using the proxy server

In most networks, you'll need to exclude certain networks, hosts, or domains from being accessed through the proxy server. You can exclude these things by exempting address strings using the `-noProxy` parameter in [`New-AksHciProxySetting`](./reference/ps/new-akshciproxysetting.md).

The default value for `proxyServerNoProxy` is `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`

When you run this command, the following are excluded:

- The localhost traffic (localhost, 127.0.0.1)
- Internal Kubernetes service traffic (.svc) where _.svc_ represents a wildcard name. This is similar to saying *.svc, but none is used in this schema.
- The private network address space (10.0.0.0/8,172.16.0.0/12,192.168.0.0/16). Note that the private network address space contains important networks, such as the Kubernetes Service CIDR (10.96.0.0/12) and Kubernetes POD CIDR (10.244.0.0/16).

While these default values will work for many networks, you may need to add more subnet ranges and/or names to the exemption list. For example, you may want to exempt your enterprise namespace (.contoso.com) from being directed through the proxy. You can achieve that by specifying the values in the proxyServerNoProxy list:

```powershell
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 3
Set-AksHciConfig -proxySetting $proxySetting -...
```

## Next steps

[Deploy Azure Kubernetes Services on Azure Stack HCI using PowerShell](./kubernetes-walkthrough-powershell.md)