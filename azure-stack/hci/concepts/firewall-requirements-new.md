---
title: Firewall requirements for Azure Stack HCI
description: This topic provides guidance on firewall requirements for the Azure Stack HCI operating system.
author: cosmosdarwin
ms.author: cosdar
ms.topic: how-to
ms.date: 01/27/2022
---

# Firewall requirements for Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system. It includes connectivity requirements and recommendations. The topic also provides information on how to set up a proxy server.

## Connectivity requirements and recommendations

Opening port 443 for outbound network traffic on your organization\'s firewall meets the connectivity requirements for the operating system to connect with Azure and Microsoft Update. If your outbound firewall is restricted, then we recommend including the URLs and ports described in the Connectivity recommendations allowlist section of this topic.

Azure Stack HCI needs to periodically connect to Azure. Access is limited to only:

- Well-known Azure IPs
- Outbound direction
- Port 443 (HTTPS)

This topic describes how to optionally use a highly locked-down firewall configuration to block all traffic to all destinations except those included on your allowlist.

As shown in the following diagram, Azure Stack HCI accesses Azure using more than one firewall potentially.


:::image type="content" source="./media/firewall-requirements/firewalls-diagram.png" alt-text="Diagram shows Azure Stack HCI accessing service tag endpoints through Port 443 (HTTPS) of firewalls." lightbox="./media/firewall-requirements/firewalls-diagram.png":::

Firewall Port Requirements for Windows Admin Center, Failover
clustering, Hyper-V, and Storage Replica (stretched cluster): \[link out
to new page\]

## Firewall connectivity recommendations and requirements

### Cluster creation

Using Windows Admin Center or PowerShell, no additional firewall rules are needed to create your cluster.

### Cluster registration and billing

Cluster registration requires the Az.StackHCI PowerShell module, which is not included in the OS. If using either Windows Admin Center or PowerShell, you will need to either unblock \*.powershellgallery.com. Alternatively, download and install the Az.StackHCI PowerShell module manually from [PowerShell Gallery](https://www.powershellgallery.com/packages/Az.StackHCI/1.1.1).

Optional: The Arc for Servers agent should be downloaded for registration as well. This is not a requirement but is recommended in order to manage your cluster from the Azure Portal or use Arc services. The URL endpoints needed to be allow-listed in order to download the Arc for Servers agent for registration. For information about networking requirements for using the Connected Machine agent to onboard a physical server or virtual machine to Azure Arc-enabled servers, see [Connected Machine agent network requirements](/azure/azure-arc/servers/network-requirements).

The following URL endpoints should be allow-listed for registration and billing, dependent on your cluster and its location. The first two of these URLs are for Active Directory Authority and Graph, and are used for authentication, token fetch, and validation. Their service tag is AzureActiveDirectory. The third, Resource Manager, is used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Its service tag is AzureResourceManager. The last URL is for Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data.

#### [Azure Public Cloud](#tab/public-cloud)

```
https://login.microsoftonline.com
https://graph.windows.net/
https://management.azure.com/
https://azurestackhci.azurefd.net
```

#### [U.S. Government Cloud](#tab/us-government-cloud)

```
https://login.microsoftonline.us
https://graph.windows.net
https://management.usgovcloudapi.net/
https://dp.azurestackchi.azure.us
```

#### [China Government Cloud](#tab/china-government-cloud)

```
https://login.chinacloudapi.cn/
https://graph.chinacloudapi.cn/
https://management.chinacloudapi.cn/
https://dp.stackhci.azure.cn
```
---

### Microsoft Update

If there is a corporate firewall between the operating system and the internet, you might have to configure that firewall to ensure the operating system can obtain updates. To obtain updates from Microsoft Update, the operating system uses port 443 for the HTTPS protocol. Although most corporate firewalls allow this type of traffic, some companies restrict internet access due to their security policies. If your company restricts access, you\'ll need to obtain authorization to allow internet access to the following URLs:

http://windowsupdate.microsoft.com
http://\*.windowsupdate.microsoft.com
https://\*.windowsupdate.microsoft.com
http://\*.update.microsoft.com
https://\*.update.microsoft.com
http://\*.windowsupdate.com
http://download.windowsupdate.com
https://download.microsoft.com
http://\*.download.windowsupdate.com
http://wustat.windows.com
http://ntservicepack.microsoft.com
http://go.microsoft.com
http://dl.delivery.mp.microsoft.com
https://dl.delivery.mp.microsoft.com

### Cluster Cloud Witness

It is optional to use a cluster witness. If you choose to use a cloud witness as the cluster witness, you will need to allow firewall access to the Azure blob container, for example \[myblobstorage\].blob.core.windows.net.

### Remote Support

This is optional, and beneficial as it allows Microsoft support professionals to solve support case faster by permitting access to the device remotely to perform troubleshooting and repair operations. If you choose to configure remote support, you will need to allow firewall access to the following URLs:

\*.servicebus.windows.net
\*.core.windows.net
login.microsoftonline.com
https://edgesupprdwestuufrontend.westus2.cloudapp.azure.com
https://edgesupprdwesteufrontend.westeurope.cloudapp.azure.com
https://edgesupprdeastusfrontend.eastus.cloudapp.azure.com
https://edgesupprdwestcufrontend.westcentralus.cloudapp.azure.com
https://edgesupprdasiasefrontend.southeastasia.cloudapp.azure.com
https://edgesupprd.trafficmanager.net

### AKS-HCI
Firewall:
<https://docs.microsoft.com/en-us/azure-stack/aks-hci/system-requirements?tabs=allow-table>


### Arc For Servers

Firewall:
<https://docs.microsoft.com/en-us/azure/azure-arc/servers/network-requirements>

### Microsoft Monitoring Agent (MMA)/Log Analytics Agent

Firewall:
<https://docs.microsoft.com/en-us/azure/azure-monitor/agents/log-analytics-agent#network-requirements>

### Qualys

Firewall:
[[https://docs.microsoft.com/en-us/azure/defender-for-cloud/deploy-vulnerability-assessment-vm#what-prerequisites-and-permissions-are-required-to-install-the-qualys-extension]{.underline}](https://docs.microsoft.com/en-us/azure/defender-for-cloud/deploy-vulnerability-assessment-vm#what-prerequisites-and-permissions-are-required-to-install-the-qualys-extension)

### Microsoft Defender

Firewall:
<https://docs.microsoft.com/en-us/microsoft-365/security/defender-endpoint/configure-proxy-internet?view=o365-worldwide#enable-access-to-microsoft-defender-for-endpoint-service-urls-in-the-proxy-server>

### Azure portal

Firewall: [Allow the Azure portal URLs on your firewall or proxy server - Azure portal \| Microsoft Docs](https://docs.microsoft.com/en-us/azure/azure-portal/azure-portal-safelist-urls?tabs=public-cloud)

### Azure Arc Resource Bridge

Firewall: [Azure Arc resource bridge (preview) overview - Azure Arc \|
Microsoft
Docs](https://docs.microsoft.com/en-us/azure/azure-arc/resource-bridge/overview)

### Required URLs

Required URLs for HCI cluster creation and registration:

### [Table](#tab/allow-table)

The following URLs need to be added to your allowlist.

[!INCLUDE [Required URLs table](includes/required-urls-table.md)]

### [Json](#tab/allow-json)

You can cut and paste the allowlist for Firewall URL exceptions.

```json
[{ 
        "URL": "https://login.microsoftonline.com", 
        "Port": "443", 
        "Notes": “(Azure Public) For Active Directory Authority and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.“ 
    }, 
    { 
        "URL": "https://login.chinacloudapi.cn/", 
        "Port": "443", 
        "Notes": “(Azure China) For Active Directory Authority and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.“ 
    }, 
    { 
        "URL": "https://login.microsoftonline.us", 
        "Port": "443", 
        "Notes": “(Azure Gov) For Active Directory Authority and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.“ 
    }, 
    { 
        "URL": "https://graph.windows.net/", 
        "Port": "443", 
        "Notes": “(Azure Public, Azure Gov) For Graph and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.” 
    }, 
    { 
        "URL": "https://graph.chinacloudapi.cn/", 
        "Port": "443", 
        "Notes": “(Azure China) For Graph and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.” 
    }, 
    { 
        "URL": "https://management.azure.com/", 
        "Port": "443", 
        "Notes": “(Azure Public) For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Service Tag: AzureResourceManager.” 
    }, 
    { 
        "URL": "https://management.chinacloudapi.cn/", 
        "Port": "443", 
        "Notes": “(Azure China) For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Service Tag: AzureResourceManager.” 
    }, 
    { 
        "URL": "https://management.usgovcloudapi.net/", 
        "Port": "443", 
        "Notes": “(Azure Gov) For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Service Tag: AzureResourceManager.” 
    }, 
    { 
        "URL": "https://azurestackhci.azurefd.net", 
        "Port": "443", 
        "Notes": “(Azure Public) For Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data.” 
    }, 
    { 
        "URL": "https://dp.stackhci.azure.cn", 
        "Port": "443", 
        "Notes": “(Azure China) For Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data.” 
    }, 
    { 
        "URL": "https://dp.azurestackchi.azure.us", 
        "Port": "443", 
        "Notes": “(Azure Gov) For Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data.” 
     }]
`````

----


### Recommended URLs

Recommended URLs for HCI cluster creation and registration:

### [Table](#tab/allow-table)

The following URLs need to be added to your allowlist.

[!INCLUDE [Recommended URLs table](includes/recommended-urls-table.md)]

### [Json](#tab/allow-json)

You can cut and paste the allowlist for Firewall URL exceptions.

```json
[{ 
        "URL": "https://login.microsoftonline.com", 
        "Port": "443", 
        "Notes": “(Azure Public) For Active Directory Authority and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.“ 
    }, 
    { 
        "URL": "https://login.chinacloudapi.cn/", 
        "Port": "443", 
        "Notes": “(Azure China) For Active Directory Authority and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.“ 
    }, 
    { 
        "URL": "https://login.microsoftonline.us", 
        "Port": "443", 
        "Notes": “(Azure Gov) For Active Directory Authority and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.“ 
    }, 
    { 
        "URL": "https://graph.windows.net/", 
        "Port": "443", 
        "Notes": “(Azure Public, Azure Gov) For Graph and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.” 
    }, 
    { 
        "URL": "https://graph.chinacloudapi.cn/", 
        "Port": "443", 
        "Notes": “(Azure China) For Graph and used for authentication, token fetch, and validation. Service Tag: AzureActiveDirectory.” 
    }, 
    { 
        "URL": "https://management.azure.com/", 
        "Port": "443", 
        "Notes": “(Azure Public) For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Service Tag: AzureResourceManager.” 
    }, 
    { 
        "URL": "https://management.chinacloudapi.cn/", 
        "Port": "443", 
        "Notes": “(Azure China) For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Service Tag: AzureResourceManager.” 
    }, 
    { 
        "URL": "https://management.usgovcloudapi.net/", 
        "Port": "443", 
        "Notes": “(Azure Gov) For Resource Manager and used during initial bootstrapping of the cluster to Azure for registration purposes and to unregister the cluster. Service Tag: AzureResourceManager.” 
    }, 
    { 
        "URL": "https://azurestackhci.azurefd.net", 
        "Port": "443", 
        "Notes": “(Azure Public) For Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data.” 
    }, 
    { 
        "URL": "https://dp.stackhci.azure.cn", 
        "Port": "443", 
        "Notes": “(Azure China) For Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data.” 
    }, 
    { 
        "URL": "https://dp.azurestackchi.azure.us", 
        "Port": "443", 
        "Notes": “(Azure Gov) For Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data.” 
    }, 
    { 
        "URL": "http://*.windowsupdate.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "https://*.windowsupdate.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "http://*.update.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "https://*.update.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "http://*.windowsupdate.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "http://download.windowsupdate.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "https://download.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "http://*.download.windowsupdate.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "http://wustat.windows.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "http://ntservicepack.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "http://go.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "http://dl.delivery.mp.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "https://dl.delivery.mp.microsoft.com", 
        "Port": "443", 
        "Notes": “For Microsoft Update, which allows the OS to receive updates.” 
    }, 
    { 
        "URL": "*.blob.core.windows.net", 
        "Port": "443", 
        "Notes": “Alternatively, [myblobstorage].blob.core.windows.net for the blob storage account for the cluster witness. For Cluster Cloud Witness.” 
    }, 
    { 
        "URL": "*.powershellgallery.com", 
        "Port": "443", 
        "Notes": “Alternatively, download the Az.StackHCI PowerShell module at https://www.powershellgallery.com/packages/Az.StackHCI. For HCI Registration.” 
    }, 
    { 
        "URL": "*.servicebus.windows.net", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    }, 
    { 
        "URL": "*.core.windows.net", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    }, 
    { 
        "URL": "login.microsoftonline.com", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    }, 
    { 
        "URL": "https://edgesupprdwestuufrontend.westus2.cloudapp.azure.com", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    }, 
    { 
        "URL": "https://edgesupprdwesteufrontend.westeurope.cloudapp.azure.com", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    }, 
    { 
        "URL": "https://edgesupprdeastusfrontend.eastus.cloudapp.azure.com", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    }, 
    { 
        "URL": "https://edgesupprdwestcufrontend.westcentralus.cloudapp.azure.com", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    }, 
    { 
        "URL": "https://edgesupprdasiasefrontend.southeastasia.cloudapp.azure.com", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    }, 
    { 
        "URL": "https://edgesupprd.trafficmanager.net", 
        "Port": "443", 
        "Notes": “For Remote Support, in order to allow remote access to Microsoft support for troubleshooting.” 
    } ] 
```

## Set up a Proxy Server

> [!NOTE]
> Windows Admin Center proxy settings and Azure Stack HCI proxy settings are separate. Changing Azure Stack HCI cluster proxy settings doesn't affect Windows Admin Center outbound traffic, such as connecting to Azure, downloading extensions, and so on. Install the WinInetProxy module to run the commands in this section. For information about the module and how to install it, see PowerShell Gallery \| WinInetProxy 0.1.0. To set up a proxy server for Azure Stack HCI, run the following PowerShell command as an administrator on each server in the cluster:

```powershell
> Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer webproxy1.com:9090
```

Use the ProxySettingsPerUser 0 flag to make the proxy configuration server-wide instead of per user, which is the default.

To remove the proxy configuration, run the PowerShell command Set-WinInetProxy without arguments.

Refer to the following articles for additional information:

- To configure a proxy for Arc for Servers, see [Configure proxy server settings on AKS on Azure Stack HCI](/azure-stack/aks-hci/set-proxy-settings).
- To configure the HTTPS-PROXY environment correctly with AKS-HCI, see [Set proxy for Azure Stack HCI and Windows Server clusters with machine-wide proxy settings](/azure-stack/aks-hci/set-proxy-settings#set-proxy-for-azure-stack-hci-and-windows-server-clusters-with-machine-wide-proxy-settings)
- To configure a proxy for Arc for Servers, see [Update or remove proxy settings](/azure/azure-arc/servers/manage-agent#update-or-remove-proxy-settings)
- To configure a proxy for Microsoft Monitoring Agent (MMA), see [Network requirements](/azure/azure-monitor/agents/log-analytics-agent#network-requirements)

## Next steps

Learn about how to [update Microsoft Defender firewall] \[link out to new page\]
- [Windows Firewall and WinRM 2.0 ports](/windows/win32/winrm/installation-and-configuration-for-windows-remote-management#windows-firewall-and-winrm-20-ports)
