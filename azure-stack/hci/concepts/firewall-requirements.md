---
title: Firewall requirements for Azure Stack HCI
description: This topic provides guidance on firewall requirements for the Azure Stack HCI operating system.
author: cosmosdarwin
ms.author: cosdar
ms.topic: how-to
ms.date: 12/14/2021
---

# Firewall requirements for Azure Stack HCI

>Applies to: Azure Stack HCI, versions 21H2 and 20H2

This topic provides guidance on how to configure firewalls for the Azure Stack HCI operating system. It includes connectivity requirements and recommendations, and explains how service tags group IP addresses in Microsoft Azure that the operating system needs to access. The topic also provides steps to update Microsoft Defender Firewall, and information on how to set up a proxy server.

## Connectivity requirements and recommendations

Opening port 443 for outbound network traffic on your organization's firewall meets the connectivity requirements for the operating system to connect with Azure and Microsoft Update. If your outbound firewall is restricted, then we recommend including the URLs and ports described in the [Connectivity recommendations](#connectivity-recommendations) allowlist section of this topic.

### Azure connectivity requirements

Azure Stack HCI needs to periodically connect to Azure. Access is limited to only:

- Well-known Azure IPs
- Outbound direction
- Port 443 (HTTPS)

This topic describes how to optionally use a highly locked-down firewall configuration to block all traffic to all destinations except those included on your allowlist.

As shown in the following diagram, Azure Stack HCI accesses Azure using more than one firewall potentially.

:::image type="content" source="./media/firewall-requirements/firewalls-diagram.png" alt-text="Diagram shows Azure Stack HCI accessing service tag endpoints through Port 443 (HTTPS) of firewalls." lightbox="./media/firewall-requirements/firewalls-diagram.png":::

### Microsoft Update connectivity requirements

If there is a corporate firewall between the operating system and the internet, you might have to configure that firewall to ensure the operating system can obtain updates. To obtain updates from Microsoft Update, the operating system uses port 443 for the HTTPS protocol. Although most corporate firewalls allow this type of traffic, some companies restrict internet access due to their security policies. If your company restricts access, you'll need to obtain authorization to allow internet access to the following URLs:

- http\://windowsupdate.microsoft.com
- http\://\*.windowsupdate.microsoft.com
- https\://\*.windowsupdate.microsoft.com
- http\://\*.update.microsoft.com
- https\://\*.update.microsoft.com
- http\://\*.windowsupdate.com
- http\://download.windowsupdate.com
- https\://download.microsoft.com
- http\://\*.download.windowsupdate.com
- http\://wustat.windows.com
- http\://ntservicepack.microsoft.com
- http\://go.microsoft.com
- http\://dl.delivery.mp.microsoft.com
- https\://dl.delivery.mp.microsoft.com

### Network firewall rules and port requirements

Ensure that the proper network ports are open between all server nodes both within a site and between sites (for stretched clusters). You'll need appropriate firewall rules to allow ICMP, SMB (port 445, plus port 5445 for SMB Direct if using iWARP RDMA), and WS-MAN (port 5985) bi-directional traffic between all servers in the cluster.

When using the Cluster Creation wizard in Windows Admin Center to create the cluster, the wizard automatically opens the appropriate firewall ports on each server in the cluster for Failover Clustering, Hyper-V, and Storage Replica. If you're using a different firewall on each server, open the ports in the following sections:

#### Windows Admin Center

Ensure that the following firewall rules are configured in your on-premises firewall for Windows Admin Center.

| Rule                                          | Action | Source                      | Destination            | Service | Ports |
| :-------------------------------------------- | :----- | :-------------------------- | :--------------------- | :------ | :---- |
| Provide access to Azure and Microsoft Update  | Allow  | Windows Admin Center        | Azure Stack HCI        | TCP     | 445   |
| Use Windows Remote Management (WinRM) 2.0<br> for HTTP connections to run commands<br> on remote Windows servers | Allow | Windows Admin Center | Azure Stack HCI | TCP | 5985  |
| Use WinRM 2.0 for HTTPS connections to run<br> commands on remote Windows servers                            | Allow | Windows Admin Center | Azure Stack HCI | TCP | 5986  |

   >[!NOTE]
   > While installing Windows Admin Center, if you select the **Use WinRM over HTTPS only** setting, then port 5986 is required.

#### Failover Clustering

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

#### Hyper-V

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
   > Open up a range of ports above port 5000 to allow RPC dynamic port allocation. Ports below 5000 may already be in use by other applications and could cause conflicts with DCOM applications. Previous experience shows that a minimum of 100 ports should be opened, because several system services rely on these RPC ports to communicate with each other. For more information. see [How to configure RPC dynamic port allocation to work with firewalls](/troubleshoot/windows-server/networking/configure-rpc-dynamic-port-allocation-with-firewalls).

#### Storage Replica (stretched cluster)

Ensure that the following firewall rules are configured in your on-premises firewall for Storage Replica (stretched cluster).

| Rule                                          | Action | Source                     | Destination                      | Service | Ports  |
| :-------------------------------------------  | :----- | :------------------------- | :------------------------------- | :------ | :----- |
| Allow Server Message Block<br> (SMB) protocol | Allow  | Stretched cluster servers  | Stretched cluster servers        | TCP     | 445    |
| Allow Web Services-Management<br> (WS-MAN)    | Allow  | Stretched cluster servers  | Stretched cluster servers        | TCP     | 5985   |
| Allow ICMPv4 and ICMPv6<br> (if using the `Test-SRTopology`<br> PowerShell cmdlet) | Allow  | Stretched cluster servers  | Stretched cluster servers  | n/a     | n/a  |

### Connectivity recommendations

If your outbound firewall is restricted, then we recommend adding the following URLs and ports in this section to your allowlist.

| Description                                              | URL                               | Port    | Direction |
| :--------------------------------------------------------| :---------------------------------| :------ | :-------- |
| Azure portal URL for proxy bypass                        | `*.aadcdn.microsoftonline-p.com`  | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.aka.ms`                        | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.applicationinsights.io`        | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.azure.com`                     | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.azure.net`                     | 80,443  | Outbound  |
| Azure Stack HCI Cloud Service                            | `*.azurefd.net`                   | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.azure-api.net`                 | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.azuredatalakestore.net`        | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.azureedge.net`                 | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.loganalytics.io`               | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.microsoft.com`                 | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.microsoftonline.com`           | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.microsoftonline-p.com`         | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.msauth.net`                    | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.msftauth.net`                  | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.trafficmanager.net`            | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.visualstudio.com`              | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.windows.net`                   | 80,443  | Outbound  |
| Azure portal URL for proxy bypass                        | `*.windows-int.net`               | 80,443  | Outbound  |
| Windows Update                                           | `*.windowsupdate.com`             | 80,443  | Outbound  |
| Microsoft Office                                         | `www.office.com`                  | 80,443  | Outbound  |
| Azure Automation service for Azure management tasks      | `*.azure-automation.net`          | 80,443  | Outbound  |
| Agent to download Helm binaries                          | `*.helm.sh`                       | 443     | Outbound  |
| Cloud Init service to download Kubernetes binaries       | `storage.googleapis.com`          | 443     | Outbound  |
| Windows Admin Center to download Azure CLI               | `aka.ms/installazurecliwindows`   | 443     | Outbound  |
| Kubernetes service to download container images          | `ecpacr.azurecr.io`               | 443     | Outbound  |
| TCP to support Azure Arc agents                          | `git://:9418`                     | 9,418   | Outbound  |
| PowerShell Gallery central repository                    | `*.powershellgallery.com`         | 80,443  | Outbound  |
| Web-hosting platform that supports multiple technologies | `*.azurewebsites.net`             | 443     | Outbound  |
| Content Delivery Network (CDN) downloads                 | `*.msecnd.net`                    | 443     | Outbound  |

For more information about these connectivity recommendations and others, see the following resources:

- [Allow the Azure portal URLs on your firewall or proxy server](/azure/azure-portal/azure-portal-safelist-urls)
- [Azure Arc networking configuration](/azure/azure-arc/servers/agent-overview#networking-configuration)
- [PowerShell Gallery](https://www.powershellgallery.com) URLs to install components such a NuGet and others
- For access to the Azure Kubernetes Service, Google APIs, Helm, and more, see [Azure Kubernetes Service on Azure Stack HCI network port and URL requirements](../../aks-hci/system-requirements.md#network-port-and-url-requirements)

### Working with service tags

A *service tag* represents a group of IP addresses from a given Azure service. Microsoft manages the IP addresses included in the service tag, and automatically updates the service tag as IP addresses change to keep updates to a minimum. To learn more, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).

   >[!IMPORTANT]
   > If outbound connectivity is restricted by your external corporate firewall or proxy server, ensure that the URLs listed in the table below are not blocked. For related information, see the "Networking configuration" section of [Overview of Azure Arc enabled servers agent](/azure/azure-arc/servers/agent-overview#networking-configuration).

### Required endpoint daily access (after Azure registration)

Azure maintains well-known IP addresses for Azure services that are organized using service tags. Azure publishes a weekly JSON file of all the IP addresses for every service. The IP addresses don’t change often, but they do change a few times per year. The following table shows the service tag endpoints that the operating system needs to access.

| Description                   | Service tag for IP range  | URL                                                                       | Azure China URL                         |
| :-----------------------------| :-----------------------  | :------------------------------------------------------------------------ | :-------------------------------------- |
| Azure Active Directory        | AzureActiveDirectory      | `https://login.microsoftonline.com`<br> `https://graph.microsoft.com`<br> `https://graph.windows.net`     | `https://login.partner.microsoftonline.cn`<br> `https://microsoftgraph.chinacloudapi.cn`<br> `https://graph.chinacloudapi.cn` |
| Azure Resource Manager        | AzureResourceManager      | `https://management.azure.com`                                            | `https://management.chinacloudapi.cn` |
| Azure Stack HCI Cloud Service | AzureFrontDoor.Frontend<br> AzureCloud.ChinaEast2 (Azure China) | `https://azurestackhci.azurefd.net` | `https://dp.stackhci.azure.cn` |
| Azure Arc                     | AzureArcInfrastructure<br> AzureTrafficManager | Depends on the functionality you want to use:<br> Hybrid Identity Service: `*.his.arc.azure.com`<br> Guest Configuration: `*.guestconfiguration.azure.com`<br> **Note:** Expect more URLs as we enable more functionality. | Coming soon. |

## Update Microsoft Defender Firewall

This section shows how to configure Microsoft Defender Firewall to allow IP addresses associated with a service tag to connect with the operating system:

1. Download the JSON file from the following resource to the target computer running the operating system: [Azure IP Ranges and Service Tags – Public Cloud](https://www.microsoft.com/download/details.aspx?id=56519).

1. Use the following PowerShell command to open the JSON file:

    ```powershell
    $json = Get-Content -Path .\ServiceTags_Public_20201012.json | ConvertFrom-Json
    ```

1. Get the list of IP address ranges for a given service tag, such as the “AzureResourceManager” service tag:

    ```powershell
    $IpList = ($json.values | where Name -Eq "AzureResourceManager").properties.addressPrefixes
    ```

1. Import the list of IP addresses to your external corporate firewall, if you're using an allowlist with it.

1. Create a firewall rule for each server in the cluster to allow outbound 443 (HTTPS) traffic to the list of IP address ranges:

    ```powershell
    New-NetFirewallRule -DisplayName "Allow Azure Resource Manager" -RemoteAddress $IpList -Direction Outbound -LocalPort 443 -Protocol TCP -Action Allow -Profile Any -Enabled True
    ```

### Additional endpoint for one-time Azure registration

During the Azure registration process, when you run either `Register-AzStackHCI` or use Windows Admin Center, the cmdlet tries to contact the PowerShell Gallery to verify that you have the latest version of required PowerShell modules, such as Az and AzureAD.

Although the PowerShell Gallery is hosted on Azure, currently there isn't a service tag for it. If you can't run the `Register-AzStackHCI` cmdlet from a server node because of no internet access, we recommend downloading the modules to your management computer, and then manually transferring them to the server node where you want to run the cmdlet.

## Set up a proxy server

This section shows how to set up a proxy server for your cluster.

   >[!NOTE]
   > Windows Admin Center proxy settings and Azure Stack HCI proxy settings are separate. Changing Azure Stack HCI cluster proxy settings doesn't affect Windows Admin Center outbound traffic, such as connecting to Azure, downloading extensions, and so on.

Install the WinInetProxy module to run the commands in this section. For information about the module and how to install it, see [PowerShell Gallery | WinInetProxy 0.1.0](https://www.powershellgallery.com/packages/WinInetProxy/0.1.0).

To set up a proxy server for Azure Stack HCI, run the following PowerShell command as an administrator on each server in the cluster:

```powershell
Set-WinInetProxy -ProxySettingsPerUser 0 -ProxyServer webproxy1.com:9090
```

Use the `ProxySettingsPerUser 0` flag to make the proxy configuration server-wide instead of per user, which is the default.

To remove the proxy configuration, run the PowerShell command `Set-WinInetProxy` without arguments.

## Next steps

For more information, see also:

- The Windows Firewall and WinRM 2.0 ports section of [Installation and configuration for Windows Remote Management](/windows/win32/winrm/installation-and-configuration-for-windows-remote-management#windows-firewall-and-winrm-20-ports)
