---
title: Proxy server settings in AKS hybrid
description: Learn about proxy server settings in Azure Kubernetes Service (AKS) on Azure Stack HCI
ms.topic: conceptual
ms.date: 10/20/2022
ms.author: sethm 
ms.lastreviewed: 05/25/2022
ms.reviewer: mikek
author: sethmanheim

# Intent: As an IT Pro, I want to learn how to configure proxy server settings in my AKS deployments that require authentication.
# Keyword: proxy server proxy settings

---
# Use proxy server settings in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

<!--LET'S DISCUSS: 1) Title should be "AKS hybrid." Lead probably should be "AKS hybrid." But the structure of the intro makes it very hard to fit in an AKS hybrid product description. 2) Introduction shouldn't start with a Note, but the Note best describes the article.-->

This article describes how to configure proxy settings for Azure Kubernetes Service (AKS) in AKS hybrid. If your network requires the use of a proxy server to connect to the internet, this article walks you through the steps to set up proxy support in AKS using the **AksHci** PowerShell module. The steps are different depending on whether the proxy server requires authentication.<!--I moved the first sentence of the note to the lead to get in a product ID. I think it works better there, and it isn't needed in the note.-->

> [!NOTE]
> If you want to use Kubernetes and Azure Services via Azure Arc, make sure you also allow the URLs shown in [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements).

Once you've configured your deployment using the options listed below, you can [install an AKS host on Azure Stack HCI](./kubernetes-walkthrough-powershell.md) and [create AKS clusters using PowerShell](./kubernetes-walkthrough-powershell.md#step-6-create-a-kubernetes-cluster).

## Before you begin

Make sure you have satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page.

### Proxy server configuration information

The proxy server configuration for your AKS deployment includes the following settings:

- HTTP URL and port, such as `http://proxy.corp.contoso.com:8080`.
- HTTPS URL and port, such as `https://proxy.corp.contoso.com:8443`.
- (Optional) Valid credentials for authentication to the proxy server.
- (Optional) Valid certificate chain if your proxy server is configured to intercept SSL traffic. This certificate chain will be imported into all AKS control plane and worker nodes as well as the management cluster to establish a trusted connection to the proxy server.

### Exclusion list for excluding private subnets from being sent to the proxy

The following table contains the list of addresses that must be excluded by using the `-noProxy` parameter in [`New-AksHciProxySetting`](./reference/ps/new-akshciproxysetting.md).

|      **IP Address**       |    **Reason for exclusion**    |  
| ----------------------- | ------------------------------------ | 
| localhost, 127.0.0.1  | Localhost traffic  |
| .svc | Internal Kubernetes service traffic (.svc) where _.svc_ represents a wildcard name. This is similar to saying \*.svc, but none is used in this schema. |
| 10.0.0.0/8 | private network address space |
| 172.16.0.0/12 |Private network address space - Kubernetes Service CIDR |
| 192.168.0.0/16 | Private network address space - Kubernetes Pod CIDR |
| .contoso.com | You may want to exempt your enterprise namespace (.contoso.com) from being directed through the proxy. To exclude all addresses in a domain, you must add the domain to the `noProxy` list. Use a leading period rather than a wildcard (\*) character. In the sample, the addresses `.contoso.com` excludes addresses `prefix1.contoso.com`, `prefix2.contoso.com`, and so on. |

The default value for `noProxy` is `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`. While these default values will work for many networks, you may need to add more subnet ranges and/or names to the exemption list. For example, you may want to exempt your enterprise namespace (.contoso.com) from being directed through the proxy. You can achieve that by specifying the values in the `noProxy` list.

## Set proxy for Azure Stack HCI and Windows Server clusters with machine-wide proxy settings

If you already have machine-wide proxy settings on your Azure Stack HCI/Windows Server cluster, the settings might override any AKS-specific proxy settings and lead to a failure during installation. 

To detect whether you have machine-wide proxy settings, run the following script on *each* of your physical cluster nodes:

```powershell
$http_proxy = [System.Environment]::GetEnvironmentVariable("HTTP_PROXY", "Machine")
$https_proxy = [System.Environment]::GetEnvironmentVariable("HTTPS_PROXY", "Machine")
$no_proxy = [System.Environment]::GetEnvironmentVariable("NO_PROXY", "Machine")

if ($http_proxy -or $https_proxy) {
    if (-not $no_proxy) {
        Write-Host "Problem Detected! A machine-wide proxy server is configured, but no proxy exclusions are configured"
    }
}
```

Configure machine-wide proxy exclusions on *each* of the physical cluster hosts where the problem was detected.

> [!NOTE]
> We recommend that you use the same proxy settings on all nodes in the failover cluster. Having different proxy settings on different physical nodes in the failover cluster might lead to unexpected results or installation issues.

Run the following PowerShell script and replace the `$no_proxy` parameter string with a suitable `NO_PROXY` exclusion string for your environment. For information about how to correctly configure a `noProxy` list for your environment, see [Exclusion list for excluding private subnets from being sent to the proxy](#exclusion-list-for-excluding-private-subnets-from-being-sent-to-the-proxy).

```powershell
$no_proxy = "localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.contoso.com"
[Environment]::SetEnvironmentVariable("NO_PROXY", $no_proxy, "Machine")
$env:NO_PROXY = [System.Environment]::GetEnvironmentVariable("NO_PROXY", "Machine")
```

## Install the AksHci PowerShell modules

Configure the System proxy settings on each of the physical nodes in the cluster and ensure that all nodes have access to the URLs and ports outlined in [System requirements](system-requirements.md#network-port-and-url-requirements).

**If you are using remote PowerShell, you must use CredSSP.**

**Close all open PowerShell windows.** before running the following command -

```powershell
Install-Module -Name AksHci -Repository PSGallery
```

If your environment uses a proxy server to access the internet, you may need to add proxy parameters to the **Install-Module** command before installing AKS on Azure Stack HCI. See the [Install-Module documentation](/powershell/module/powershellget/install-module) for details and follow the [Azure Stack HCI documentation](/azure-stack/hci/manage/configure-firewalls#set-up-a-proxy-server) to configure the proxy settings on the physical cluster nodes.

When you download AksHci PowerShell module, we also download Az PowerShell modules that are required for registering for AKS host to Azure for billing.


## Configure an AKS host for a proxy server with basic authentication

If your proxy server requires authentication, open PowerShell as an administrator and run the following command to get credentials and set the configuration details:

```powershell
$proxyCred = Get-Credential
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.contoso.com -credential $proxyCredential
```

## Configure an AKS host for a proxy server without authentication  

If your proxy server doesn't require authentication, run the following command:

```powershell
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.contoso.com
```

## Configure an AKS host for a proxy server with a trusted certificate

If your proxy server requires proxy clients to trust a certificate, specify the certificate file when you run `Set-AksHciConfig`. The format of the certificate file is *Base-64 encoded X .509*. This will enable you to create and trust the certificate throughout the stack.

> [!Important]
> If your proxy requires a certificate to be trusted by the physical Azure Stack HCI nodes, make sure that you have imported the certificate chain to the appropriate certificate store on each Azure Stack HCI node before you continue. Follow the procedures for your deployment to enroll the Azure Stack HCI nodes with the required certificates for proxy authentication.


```powershell
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.contoso.com -credential $proxyCredential
```

> [!NOTE]
> Proxy certificates must be provided as a personal information exchange (PFX) file format or string, and contain the root authority chain to use the certificate for authentication or for SSL tunnel setup.


## Next steps

You can now proceed with installing AKS on your Azure Stack HCI or Windows Server cluster, by running [`Set-AksHciConfig`](./reference/ps/set-akshciconfig.md) followed by `Install-AksHci`.

- [Deploy Azure Kubernetes Services on Azure Stack HCI using PowerShell](./kubernetes-walkthrough-powershell.md)
