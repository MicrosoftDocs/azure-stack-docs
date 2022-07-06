---
title: Firewall requirements for Azure Stack HCI
description: This topic provides guidance on firewall requirements for the Azure Stack HCI operating system.
author: cosmosdarwin
ms.author: cosdar
ms.topic: how-to
ms.date: 04/28/2022
---

# Firewall requirements for Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

This article provides guidance on how to configure firewalls for the Azure Stack HCI operating system. It includes firewall requirements for outbound endpoints and internal rules and ports. The article also provides information on how to set up a proxy server and how to use Azure service tags with Microsoft Defender firewall.

## Firewall requirements for outbound endpoints

Opening port 443 for outbound network traffic on your organization's firewall meets the connectivity requirements for the operating system to connect with Azure and Microsoft Update. If your outbound firewall is restricted, then we recommend including the URLs and ports described in the [Recommended firewall URLs](#recommended-firewall-urls) section of this article.

Azure Stack HCI needs to periodically connect to Azure. Access is limited only to:

- Well-known Azure IPs
- Outbound direction
- Port 443 (HTTPS)

This article describes how to optionally use a highly locked-down firewall configuration to block all traffic to all destinations except those included in your allowlist.

As shown in the following diagram, Azure Stack HCI accesses Azure using more than one firewall potentially.

:::image type="content" source="./media/firewall-requirements/firewalls-diagram.png" alt-text="Diagram shows Azure Stack HCI accessing service tag endpoints through Port 443 (HTTPS) of firewalls." lightbox="./media/firewall-requirements/firewalls-diagram.png":::

The following sections provide consolidated lists of required and recommended URLs for the Azure Stack HCI core components, which include cluster creation, registration and billing, Microsoft Update, and cloud cluster witness. You can use the JSON tab to directly copy-and-paste the URLs into your allowlist.

The subsequent sections provide additional details about the firewall requirements of Azure Stack HCI core components, followed by firewall requirements for additional Azure services (optional).

### Required firewall URLs

This section provides a list of required firewall URLs. Make sure to include these URLs to your allowlist.

### [Table](#tab/allow-table)

The following table provides a list of required firewall URLs.

[!INCLUDE [Required URLs table](../../includes/required-urls-table.md)]

### [JSON](#tab/allow-json)

The following are the required firewall URLs in the JSON format. Use the Copy button to copy-and-paste this content to your allowlist.

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
        "URL": "https://dp.stackhci.azure.com (Azure Public)", 
        "Port": "443", 
        "Notes": “(Azure Public) For Dataplane which pushes up diagnostics data, is used in the Portal pipeline, and pushes billing data. Note that this URL has been updated. Previously, this URL was: https://azurestackhci.azurefd.net. If you've already registered your cluster with the old URL, you must allowlist the old URL as well.” 
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

### Recommended firewall URLs

This section provides a list of recommended firewall URLs. If your outbound firewall is restricted, we recommend including the URLs and ports described in this section to your allowlist.

### [Table](#tab/allow-table)

The following table provides a list of recommended firewall URLs.

[!INCLUDE [Recommended URLs table](../../includes/recommended-urls-table.md)]

### [Json](#tab/allow-json)

The following are the recommended firewall URLs in the JSON format. Use the Copy button to copy-and-paste this content to your allowlist.

```json
[{ 
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
    }]
```
----

### Cluster creation

You don't need any other firewall rules if you use Windows Admin Center or PowerShell to create your Azure Stack HCI cluster.

### Cluster registration and billing

Cluster registration requires the Az.StackHCI PowerShell module, which isn't included in the Azure Stack HCI operating system. If you use Windows Admin Center or PowerShell, you need to either unblock \*.powershellgallery.com or download and install the Az.StackHCI PowerShell module manually from [PowerShell Gallery](https://www.powershellgallery.com/packages/Az.StackHCI/1.1.1).

Optionally, download the Arc for Servers agent for registration. This isn't required but recommended to manage your cluster from the Azure portal or use Arc services. You need to allow-list the URL endpoints in order to download the Arc for Servers agent for registration.

For information about networking requirements for using the Connected Machine agent to onboard a physical server or virtual machine to Azure Arc-enabled servers, see [Connected Machine agent network requirements](/azure/azure-arc/servers/network-requirements).

### Microsoft Update

If there's a corporate firewall between the Azure Stack HCI operating system and the internet, you might have to configure that firewall to ensure the operating system can obtain updates. To obtain updates from Microsoft Update, the operating system uses port 443 for the HTTPS protocol. Although most corporate firewalls allow this type of traffic, some companies restrict internet access due to their security policies. If your company restricts access, we recommend including the URLs and ports described in the [Recommended firewall URLs](#recommended-firewall-urls) section to your allowlist.

### Cluster Cloud Witness

This is optional. If you choose to use a cloud witness as the cluster witness, you must allow firewall access to the Azure blob container, for example, `\[myblobstorage\].blob.core.windows.net`.

### Firewall requirements for additional Azure services (optional)

Depending on additional Azure services you enable on HCI, you may need to make additional firewall configuration changes. Refer to the following links for information on firewall requirements for each Azure service.

- [AKS on Azure Stack HCI](/azure-stack/aks-hci/system-requirements?tabs=allow-table#aks-on-azure-stack-hci-requirements)
- [Arc for Servers](/azure/azure-arc/servers/network-requirements)
- [Azure Arc resource bridge](/azure/azure-arc/resource-bridge/overview)
- [Azure portal](/azure/azure-portal/azure-portal-safelist-urls?tabs=public-cloud)
- [Microsoft Defender](/microsoft-365/security/defender-endpoint/configure-proxy-internet?view=o365-worldwide&preserve-view=true#enable-access-to-microsoft-defender-for-endpoint-service-urls-in-the-proxy-server)
- [Microsoft Monitoring Agent (MMA) and Log Analytics Agent](/azure/azure-monitor/agents/log-analytics-agent#network-requirements)
- [Qualys](/azure/defender-for-cloud/deploy-vulnerability-assessment-vm#what-prerequisites-and-permissions-are-required-to-install-the-qualys-extension)
- [Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/network-requirements)
- [Windows Admin Center in Azure Portal](/windows-server/manage/windows-admin-center/azure/manage-hci-clusters?toc=%2Fazure-stack%2Fhci%2Ftoc.json&bc=%2Fazure-stack%2Fbreadcrumb%2Ftoc.json#networking-requirements)

## Firewall requirements for internal rules and ports

Ensure that the proper network ports are open between all server nodes both within a site and between sites (for stretched clusters). You'll need appropriate firewall rules to allow ICMP, SMB (port 445, plus port 5445 for SMB Direct if using iWARP RDMA), and WS-MAN (port 5985) bi-directional traffic between all servers in the cluster.

When using the Cluster Creation wizard in Windows Admin Center to create the cluster, the wizard automatically opens the appropriate firewall ports on each server in the cluster for Failover Clustering, Hyper-V, and Storage Replica. If you're using a different firewall on each server, open the ports as described in the following sections:

### Windows Admin Center

Ensure that the following firewall rules are configured in your on-premises firewall for Windows Admin Center.

| Rule                                          | Action | Source                      | Destination            | Service | Ports |
| :-------------------------------------------- | :----- | :-------------------------- | :--------------------- | :------ | :---- |
| Provide access to Azure and Microsoft Update  | Allow  | Windows Admin Center        | Azure Stack HCI        | TCP     | 445   |
| Use Windows Remote Management (WinRM) 2.0<br> for HTTP connections to run commands<br> on remote Windows servers | Allow | Windows Admin Center | Azure Stack HCI | TCP | 5985  |
| Use WinRM 2.0 for HTTPS connections to run<br> commands on remote Windows servers                            | Allow | Windows Admin Center | Azure Stack HCI | TCP | 5986  |

>[!NOTE]
> While installing Windows Admin Center, if you select the **Use WinRM over HTTPS only** setting, then port 5986 is required.

### Failover Clustering

Ensure that the following firewall rules are configured in your on-premises firewall for Failover Clustering.

| Rule                                | Action | Source                     | Destination            | Service | Ports  |
| :---------------------------------  | :----- | :------------------------- | :--------------------- | :------ | :----- |
| Allow Failover Cluster validation   | Allow  | Management system          | Cluster servers        | TCP     | 445    |
| Allow RPC dynamic port allocation   | Allow  | Management system          | Cluster servers        | TCP     | Minimum of 100 ports<br> above port 5000 |
| Allow Remote Procedure Call (RPC)   | Allow  | Management system          | Cluster servers        | TCP     | 135    |
| Allow Cluster Administrator         | Allow  | Management system          | Cluster servers        | TCP     | 137    |
| Allow Cluster Service               | Allow  | Management system          | Cluster servers        | UDP     | 3343   |
| Allow Cluster Service (Required during<br> a server join operation.) | Allow  | Management system  | Cluster servers  | TCP     | 3343 |
| Allow ICMPv4 and ICMPv6<br> for Failover Cluster validation | Allow  | Management system           | Cluster servers  | n/a     | n/a  |

>[!NOTE]
> The management system includes any computer from which you plan to administer the cluster, using tools such as Windows Admin Center, Windows PowerShell or System Center Virtual Machine Manager.

### Hyper-V

Ensure that the following firewall rules are configured in your on-premises firewall for Hyper-V.

| Rule                               | Action | Source                      | Destination            | Service | Ports  |
| :--------------------------------- | :----- | :-------------------------- | :--------------------- | :------ | :----- |
| Allow cluster communication        | Allow  | Management system             | Hyper-V server         | TCP     | 445    |
| Allow RPC Endpoint Mapper and WMI  | Allow  | Management system             | Hyper-V server         | TCP     | 135    |
| Allow HTTP connectivity            | Allow  | Management system             | Hyper-V server         | TCP     | 80     |
| Allow HTTPS connectivity           | Allow  | Management system             | Hyper-V server         | TCP     | 443    |
| Allow Live Migration               | Allow  | Management system             | Hyper-V server         | TCP     | 6600   |
| Allow VM Management Service        | Allow  | Management system             | Hyper-V server         | TCP     | 2179   |
| Allow RPC dynamic port allocation  | Allow  | Management system             | Hyper-V server         | TCP     | Minimum of 100 ports<br> above port 5000 |

>[!NOTE]
> Open up a range of ports above port 5000 to allow RPC dynamic port allocation. Ports below 5000 may already be in use by other applications and could cause conflicts with DCOM applications. Previous experience shows that a minimum of 100 ports should be opened, because several system services rely on these RPC ports to communicate with each other. For more information, see [How to configure RPC dynamic port allocation to work with firewalls](/troubleshoot/windows-server/networking/configure-rpc-dynamic-port-allocation-with-firewalls).

### Storage Replica (stretched cluster)

Ensure that the following firewall rules are configured in your on-premises firewall for Storage Replica (stretched cluster).

| Rule                                          | Action | Source                     | Destination                      | Service | Ports  |
| :-------------------------------------------  | :----- | :------------------------- | :------------------------------- | :------ | :----- |
| Allow Server Message Block<br> (SMB) protocol | Allow  | Stretched cluster servers  | Stretched cluster servers        | TCP     | 445    |
| Allow Web Services-Management<br> (WS-MAN)    | Allow  | Stretched cluster servers  | Stretched cluster servers        | TCP     | 5985   |
| Allow ICMPv4 and ICMPv6<br> (if using the `Test-SRTopology`<br> PowerShell cmdlet) | Allow  | Stretched cluster servers  | Stretched cluster servers  | n/a     | n/a  |

## Set up a proxy server

> [!NOTE]
> Windows Admin Center proxy settings and Azure Stack HCI proxy settings are separate. Changing Azure Stack HCI cluster proxy settings doesn't affect Windows Admin Center outbound traffic, such as connecting to Azure, downloading extensions, and so on. Install the WinInetProxy module to run the commands in this section. For information about the module and how to install it, see [PowerShell Gallery | WinInetProxy 0.1.0](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0).

To set up a proxy server for Azure Stack HCI, run the following PowerShell command as an administrator on each server in the cluster:

```powershell
Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer webproxy1.com:9090
```

Use the `ProxySettingsPerUser` `0` flag to make the proxy configuration server-wide instead of per user, which is the default.

To remove the proxy configuration, run the PowerShell command `Set-WinInetProxy` without arguments.

Refer to the following articles for information about how to configure proxy servers:

- To configure a proxy server on AKS on Azure Stack HCI, see [Configure proxy server settings on AKS on Azure Stack HCI](/azure-stack/aks-hci/set-proxy-settings).
- To configure the HTTPS-PROXY environment correctly with AKS-HCI, see [Set proxy for Azure Stack HCI and Windows Server clusters with machine-wide proxy settings](/azure-stack/aks-hci/set-proxy-settings#set-proxy-for-azure-stack-hci-and-windows-server-clusters-with-machine-wide-proxy-settings).
- To configure a proxy for Arc for Servers, see the "Update or remove proxy settings" section in [Managing and maintaining the Connected Machine agent](/azure/azure-arc/servers/manage-agent#update-or-remove-proxy-settings).
- To configure a proxy for Microsoft Monitoring Agent (MMA), see the [Network requirements](/azure/azure-monitor/agents/log-analytics-agent#network-requirements) section in the Log Analytics agent overview article.

## Update Microsoft Defender firewall

This section shows how to configure Microsoft Defender firewall to allow IP addresses associated with a service tag to connect with the operating system. A *service tag* represents a group of IP addresses from a given Azure service. Microsoft manages the IP addresses included in the service tag, and automatically updates the service tag as IP addresses change to keep updates to a minimum. To learn more, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).

1. Download the JSON file from the following resource to the target computer running the operating system: [Azure IP Ranges and Service Tags – Public Cloud](https://www.microsoft.com/download/details.aspx?id=56519).

1. Use the following PowerShell command to open the JSON file:

    ```powershell
    $json = Get-Content -Path .\ServiceTags_Public_20201012.json | ConvertFrom-Json
    ```

1. Get the list of IP address ranges for a given service tag, such as the "AzureResourceManager" service tag:

    ```powershell
    $IpList = ($json.values | where Name -Eq "AzureResourceManager").properties.addressPrefixes
    ```

1. Import the list of IP addresses to your external corporate firewall, if you're using an allowlist with it.

1. Create a firewall rule for each server in the cluster to allow outbound 443 (HTTPS) traffic to the list of IP address ranges:

    ```powershell
    New-NetFirewallRule -DisplayName "Allow Azure Resource Manager" -RemoteAddress $IpList -Direction Outbound -LocalPort 443 -Protocol TCP -Action Allow -Profile Any -Enabled True
    ```

## Next steps

For more information, see also:

- The Windows Firewall and WinRM 2.0 ports section of [Installation and configuration for Windows Remote Management](/windows/win32/winrm/installation-and-configuration-for-windows-remote-management#windows-firewall-and-winrm-20-ports)