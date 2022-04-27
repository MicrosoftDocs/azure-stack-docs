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

Table View:

Required URLs for HCI cluster creation and registration:

### [Table](#tab/allow-table)

The following URLs need to be added to your allowlist.

[!INCLUDE [URL allow table](includes/data-allow-table.md)]

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


Recommended URLs:

JSON: [Recommended URLs
JSON](https://microsoft-my.sharepoint-df.com/:w:/p/timathur/EfLB-ANAjbRPoTgWW3oWeKoBnMg7pwN3bFrV1WuTAulrmw)

+-------------------------------------+--------------+-----------------+
| URL                                 | Port         | Notes           |
+=====================================+==============+=================+
| https://login.microsoftonline.com   | 443          | For Active      |
|                                     |              | Directory       |
| (Azure Public)                      |              | Authority and   |
|                                     |              | used for        |
| https://login.chinacloudapi.cn/     |              | authentication, |
|                                     |              | token fetch,    |
| (Azure China)                       |              | and validation. |
|                                     |              | Service Tag:    |
| https://login.microsoftonline.us    |              | AzureA          |
|                                     |              | ctiveDirectory. |
| (Azure Gov)                         |              |                 |
+-------------------------------------+--------------+-----------------+
| https://graph.windows.net/          | 443          | For Graph, and  |
|                                     |              | used for        |
| (Azure Public, Azure Gov)           |              | authentication, |
|                                     |              | token fetch,    |
| https://graph.chinacloudapi.cn/     |              | and validation. |
|                                     |              | Service Tag:    |
| (Azure China)                       |              | AzureA          |
|                                     |              | ctiveDirectory. |
+-------------------------------------+--------------+-----------------+
| https://management.azure.com/       | 443          | For Resource    |
|                                     |              | Manager and     |
| (Azure Public)                      |              | used during     |
|                                     |              | initial         |
| h                                   |              | bootstrapping   |
| ttps://management.chinacloudapi.cn/ |              | of the cluster  |
|                                     |              | to Azure for    |
| (Azure China)                       |              | registration    |
|                                     |              | purposes and to |
| ht                                  |              | unregister the  |
| tps://management.usgovcloudapi.net/ |              | cluster.        |
|                                     |              | Service Tag:    |
| (Azure Gov)                         |              | AzureR          |
|                                     |              | esourceManager. |
+-------------------------------------+--------------+-----------------+
| https://azurestackhci.azurefd.net   | 443          | For Dataplane   |
|                                     |              | which pushes up |
| (Azure Public)                      |              | diagnostics     |
|                                     |              | data, is used   |
| https://dp.stackhci.azure.cn        |              | in the Portal   |
|                                     |              | pipeline, and   |
| (Azure China)                       |              | pushes billing  |
|                                     |              | data.           |
| https://dp.azurestackchi.azure.us   |              |                 |
|                                     |              |                 |
| (Azure Gov)                         |              |                 |
+-------------------------------------+--------------+-----------------+
| ht                                  | 443          | For Microsoft   |
| tp://\*.windowsupdate.microsoft.com |              | Update, which   |
|                                     |              | allows the OS   |
| htt                                 |              | to receive      |
| ps://\*.windowsupdate.microsoft.com |              | updates.        |
|                                     |              |                 |
| http://\*.update.microsoft.com      |              |                 |
|                                     |              |                 |
| https://\*.update.microsoft.com     |              |                 |
|                                     |              |                 |
| http://\*.windowsupdate.com         |              |                 |
|                                     |              |                 |
| http://download.windowsupdate.com   |              |                 |
|                                     |              |                 |
| https://download.microsoft.com      |              |                 |
|                                     |              |                 |
| h                                   |              |                 |
| ttp://\*.download.windowsupdate.com |              |                 |
|                                     |              |                 |
| http://wustat.windows.com           |              |                 |
|                                     |              |                 |
| http://ntservicepack.microsoft.com  |              |                 |
|                                     |              |                 |
| http://go.microsoft.com             |              |                 |
|                                     |              |                 |
| http://dl.delivery.mp.microsoft.com |              |                 |
|                                     |              |                 |
| h                                   |              |                 |
| ttps://dl.delivery.mp.microsoft.com |              |                 |
+-------------------------------------+--------------+-----------------+
| \*.blob.core.windows.net OR         | 443          | For Cluster     |
|                                     |              | Cloud Witness,  |
| \[my                                |              | in order to use |
| blobstorage\].blob.core.windows.net |              | a cloud witness |
|                                     |              | as the cluster  |
|                                     |              | witness.        |
+-------------------------------------+--------------+-----------------+
| \*.servicebus.windows.net           | 443          | For Remote      |
|                                     |              | Support, in     |
| \*.core.windows.net                 |              | order to allow  |
|                                     |              | remote access   |
| login.microsoftonline.com           |              | to Microsoft    |
|                                     |              | support for     |
| https://edgesupprdwestuu            |              | t               |
| frontend.westus2.cloudapp.azure.com |              | roubleshooting. |
|                                     |              |                 |
| https://edgesupprdwesteufro         |              |                 |
| ntend.westeurope.cloudapp.azure.com |              |                 |
|                                     |              |                 |
| https://edgesupprdeastu             |              |                 |
| sfrontend.eastus.cloudapp.azure.com |              |                 |
|                                     |              |                 |
| https://edgesupprdwestcufronte      |              |                 |
| nd.westcentralus.cloudapp.azure.com |              |                 |
|                                     |              |                 |
| https://edgesupprdasiasefronte      |              |                 |
| nd.southeastasia.cloudapp.azure.com |              |                 |
|                                     |              |                 |
| ht                                  |              |                 |
| tps://edgesupprd.trafficmanager.net |              |                 |
+-------------------------------------+--------------+-----------------+
| \*.powershellgallery.com OR install | 443          | To obtain the   |
| module at                           |              | Az.StackHCI     |
| [https://www.powershellgallery.co   |              | PowerShell      |
| m/packages/Az.StackHCI](https://nam |              | module, which   |
| 06.safelinks.protection.outlook.com |              | is required for |
| /?url=https%3A%2F%2Fwww.powershellg |              | cluster         |
| allery.com%2Fpackages%2FAz.StackHCI |              | registration.   |
| &data=05%7C01%7CTiara.Mathur%40micr |              |                 |
| osoft.com%7C3a9527f2928a4f804a7b08d |              |                 |
| a1ef84485%7C72f988bf86f141af91ab2d7 |              |                 |
| cd011db47%7C1%7C0%7C637856348914018 |              |                 |
| 481%7CUnknown%7CTWFpbGZsb3d8eyJWIjo |              |                 |
| iMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTi |              |                 |
| I6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C% |              |                 |
| 7C%7C&sdata=ODZr6pfGWRW2LF8kfqjlSnx |              |                 |
| 8AMbalzR5FdBEbMruEgU%3D&reserved=0) |              |                 |
+-------------------------------------+--------------+-----------------+

Refer to the linked documentation for firewall rules for additional
recommended services.

\[Copy and Download Button\]

## Set up a Proxy Server

> [!NOTE]
> Windows Admin Center proxy settings and Azure Stack HCI proxy settings are separate. Changing Azure Stack HCI cluster proxy settings doesn't affect Windows Admin Center outbound traffic, such as connecting to Azure, downloading extensions, and so on. Install the WinInetProxy module to run the commands in this section. For information about the module and how to install it, see PowerShell Gallery \| WinInetProxy 0.1.0. To set up a proxy server for Azure Stack HCI, run the following PowerShell command as an administrator on each server in the cluster:

```powershell
> Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer webproxy1.com:9090
```

Use the ProxySettingsPerUser 0 flag to make the proxy configuration server-wide instead of per user, which is the default.

To remove the proxy configuration, run the PowerShell command Set-WinInetProxy without arguments.

To configure a proxy for AKS-HCI:
> <https://docs.microsoft.com/en-us/azure-stack/aks-hci/set-proxy-settings>.
> Refer to this documentation to configure the HTTPS-PROXY environment
> correctly with AKS-HCI:
> [https://docs.microsoft.com/en-us/azure-stack/aks-hci/set-proxy-settings#set-proxy-for-azure-stack-hci-and-windows-server-clusters-with-machine-wide-proxy-settings](https://nam06.safelinks.protection.outlook.com/?url=https%3A%2F%2Fdocs.microsoft.com%2Fen-us%2Fazure-stack%2Faks-hci%2Fset-proxy-settings%23set-proxy-for-azure-stack-hci-and-windows-server-clusters-with-machine-wide-proxy-settings&data=05%7C01%7CTiara.Mathur%40microsoft.com%7Cacd13fe394d24521e65108da19a1ca8c%7C72f988bf86f141af91ab2d7cd011db47%7C1%7C0%7C637850480166713310%7CUnknown%7CTWFpbGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%7C3000%7C%7C%7C&sdata=2PP08kDxkk%2FLfHsqcwL5fU1O6JkYeYyjGtFJytrgkhQ%3D&reserved=0)
>
> To configure a proxy for Arc for Servers: :
> <https://docs.microsoft.com/en-us/azure/azure-arc/servers/manage-agent>
>
> To configure a proxy for MMA:
> <https://docs.microsoft.com/en-us/azure/azure-monitor/agents/log-analytics-agent#network-requirements>
>
## Next steps

Learn about how to [update Microsoft Defender firewall] \[link out to new page\]

> The Windows Firewall and WinRM 2.0 ports section of [Installation and
> configuration for Windows Remote
> Management](https://docs.microsoft.com/en-us/windows/win32/winrm/installation-and-configuration-for-windows-remote-management#windows-firewall-and-winrm-20-ports)
