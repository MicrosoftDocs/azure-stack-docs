---
title: Configure proxy server settings in Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about proxy server settings in Azure Kubernetes Service (AKS) on Azure Stack HCI
ms.topic: conceptual
ms.date: 04/11/2022
ms.custom: fasttrack-edit
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: mikek
author: mattbriggs

#intent: As an IT Pro, I want to learn how to configure proxy server settings in my AKS deployments that require authentication.
#keyword: proxy server settings

---
# Configure proxy server settings on AKS on Azure Stack HCI

> [!NOTE]
> This topic covers how to configure proxy settings for AKS on Azure Stack HCI. If you want to use Arc enabled Kubernetes and Azure Services via Azure Arc, make sure you also allow the URLs shown in [Connect an existing Kubernetes cluster to Azure Arc](/azure/azure-arc/kubernetes/quickstart-connect-cluster?tabs=azure-cli#meet-network-requirements). 

If your network requires the use of a proxy server to connect to the internet, this article walks you through the steps required to set up proxy support on AKS on Azure Stack HCI using the **AksHci** PowerShell module. There are different sets of steps depending on whether the proxy server requires authentication.

Once you've configured your deployment using the options listed below, you can [install an AKS host on Azure Stack HCI](./kubernetes-walkthrough-powershell.md) and [create AKS clusters using PowerShell](./kubernetes-walkthrough-powershell.md#step-6-create-a-kubernetes-cluster).

## Before you begin

Make sure you have satisfied all the prerequisites on the [system requirements](.\system-requirements.md) page. 

### **Proxy server configuration information:**
   - HTTP URL and port, such as `http://proxy.corp.contoso.com:8080`.
   - HTTPS URL and port, such as `https://proxy.corp.contoso.com:8443`.
   - (Optional) Valid credentials for authentication to the proxy server.
   - (Optional) Valid certificate chain if your proxy server is configured to intercept SSL traffic. This certificate chain will be imported into all AKS control plane and worker nodes as well as the management cluster to establish a trusted connection to the proxy server.
   - IP address ranges and domain names to exclude so they are not sent to the proxy:
      - Kubernetes node IP pool
      - Kubernetes services VIP pool
      - The cluster network IP addresses
      - DNS server IP addresses
      - Time service IP addresses
      - Local domain name(s)
      - Local host name(s)
   - The default exclusion list in the AksHci PowerShell is shown below, which exempts all private subnets from being sent to the proxy:
      - 'localhost,127.0.0.1': standard localhost exclusion
      - '.svc': Wildcard exclusion for all Kubernetes Services host names
      - '172.16.0.0/12': Kubernetes services IP address pool
      - '192.168.0.0/16': Kubernetes pod IP address pool

## Install the AksHci PowerShell modules

Configure the System proxy settings on each of the physical nodes in the cluster and ensure that all nodes have access to the URLs and ports outlined in [System requirements](system-requirements.md#network-port-and-url-requirements).

**If you are using remote PowerShell, you must use CredSSP.**

**Close all open PowerShell windows.** before running the following command -

```powershell
Install-Module -Name AksHci -Repository PSGallery
```

If your environment uses a proxy server to access the internet, you may need to add proxy parameters to the **Install-Module** command before installing AKS on Azure Stack HCI. See the [Install-Module documentation](/powershell/module/powershellget/install-module) for details and follow the [Azure Stack HCI documentation](/azure-stack/hci/manage/configure-firewalls#set-up-a-proxy-server) to configure the proxy settings on the physical cluster nodes.

**Close all PowerShell windows** and reopen a new administrative session to check if you have the latest version of the PowerShell module.
  
```powershell
Get-Command -Module AksHci
```
To view the complete list of AksHci PowerShell commands, see [AksHci PowerShell](./reference/ps/index.md).

When you download AksHci PowerShell module, we also download Az PowerShell modules that are required for registering for AKS host to Azure for billing. If a proxy is necessary for an HTTP request, the Azure PowerShell team recommends the following proxy configuration for different platforms:


|      **Platform**       |    **Recommended Proxy Settings**    |         **Comment**   |
| ----------------------- | ------------------------------------ | ------------------------ |
| Windows PowerShell 5.1  | System proxy settings  | We recommend you don't set HTTP_PROXY/HTTPS_PROXY environment variables.|
| PowerShell 7 on Windows | System proxy settings   | You can configure proxy by setting both HTTP_PROXY and HTTPS_PROXY environment variables.    |
| PowerShell 7 on macOS   | System proxy settings  | You can configure proxy by setting both HTTP_PROXY and HTTPS_PROXY environment variables.     |
| PowerShell 7 on Linux   | Set both HTTP_PROXY and HTTPS_PROXY environment variables, plus NO_PROXY(optional) | You should set the environment variables before starting PowerShell, otherwise, they may not be respected. |

The environment variables used include the following:

- HTTP_PROXY: the proxy server used on HTTP requests.
- HTTPS_PROXY: the proxy server used on HTTPS requests.
- NO_PROXY: a comma-separated list of hostnames and IP addresses that should be excluded from the proxy.

> [!NOTE]
> On systems where environment variables are case-sensitive, the variable names may be all lowercase or all uppercase. The lowercase names are checked first.

## Configure an AKS host for a proxy server with basic authentication

If your proxy server requires authentication, open PowerShell as an administrator and run the following command to get credentials and set the configuration details:

```powershell
$proxyCred = Get-Credential
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 -credential $proxyCredential
```

## Configure an AKS host for a proxy server without authentication  

If your proxy server doesn't require authentication, run the following command:

```powershell
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 
```

## Configure an AKS host for a proxy server with a trusted certificate

If your proxy server requires proxy clients to trust a certificate, specify the certificate file when you run `Set-AksHciConfig`. The format of the certificate file is *Base-64 encoded X .509*. This will enable you to create and trust the certificate throughout the stack.

> [!Important]
> If your proxy requires a certificate to be trusted by the physical Azure Stack HCI nodes, make sure that you have imported the certificate chain to the appropriate certificate store on each Azure Stack HCI node before you continue. Follow the procedures for your deployment to enroll the Azure Stack HCI nodes with the required certificates for proxy authentication.

## Configure an AKS host to use a certificate for proxy authentication

```powershell
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.96.0.0/12,10.244.0.0/16 -certFile c:\temp\proxycert.pfx
```

> [!NOTE]
> Proxy certificates must be provided as a personal information exchange (PFX) file format or string, and contain the root authority chain to use the certificate for authentication or for SSL tunnel setup.

## Exclude specific hosts or domains from using the proxy server

In most networks, you'll need to exclude certain networks, hosts, or domains from being accessed through the proxy server. You can exclude these things by exempting address strings using the `-noProxy` parameter in [`New-AksHciProxySetting`](./reference/ps/new-akshciproxysetting.md).

The default value for `noProxy` is `localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16`.

When you run this command, the following are excluded:

- The localhost traffic (localhost, 127.0.0.1)
- Internal Kubernetes service traffic (.svc) where _.svc_ represents a wildcard name. This is similar to saying *.svc, but none is used in this schema.
- The private network address space (10.0.0.0/8,172.16.0.0/12,192.168.0.0/16). Note that the private network address space contains important networks, such as the Kubernetes Service CIDR (10.96.0.0/12) and Kubernetes POD CIDR (10.244.0.0/16).

While these default values will work for many networks, you may need to add more subnet ranges and/or names to the exemption list. For example, you may want to exempt your enterprise namespace (.contoso.com) from being directed through the proxy. You can achieve that by specifying the values in the `noProxy` list:

```powershell
$proxySetting=New-AksHciProxySetting -name "corpProxy" -http http://contosoproxy:8080 -https https://contosoproxy:8443 -noProxy localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16,.contoso.com
```

To exclude all addresses in a domain, you must add the domain to the `noProxy` list. Use a leading period rather than a wildcard (\*) character. In the sample, the addresses `.contoso.com` excludes addresses `prefix1.contoso.com`, `prefix2.contoso.com`, and so on.

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

Run the following PowerShell script and replace the `$no_proxy` parameter string with a suitable `NO_PROXY` exclusion string for your environment. For information about how to correctly configure a `noProxy` list for your environment, see [Exclude specific hosts or domains from using the proxy server](#exclude-specific-hosts-or-domains-from-using-the-proxy-server).

```powershell
$no_proxy = "localhost,127.0.0.1,.svc,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16"
[Environment]::SetEnvironmentVariable("NO_PROXY", $no_proxy, "Machine")
$env:NO_PROXY = [System.Environment]::GetEnvironmentVariable("NO_PROXY", "Machine")
```

You can now proceed with installing AKS on your Azure Stack HCI/Windows Server cluster, by running [`Set-AksHciConfig`](./reference/ps/set-akshciconfig.md) followed by `Install-AksHci`.

## Next steps

[Deploy Azure Kubernetes Services on Azure Stack HCI using PowerShell](./kubernetes-walkthrough-powershell.md)
