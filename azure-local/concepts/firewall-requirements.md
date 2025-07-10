---
title: Firewall requirements for Azure Local
description: This topic provides guidance on firewall requirements for the Azure Stack HCI operating system.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 01/08/2025
---

# Firewall requirements for Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

This article provides guidance on how to configure firewalls for the Azure Stack HCI operating system. It includes firewall requirements for outbound endpoints and internal rules and ports. The article also provides information on how to use Azure service tags with Microsoft Defender firewall.

This article also describes how to optionally use a highly locked-down firewall configuration to block all traffic to all destinations except those included in your allowlist.

If your network uses a proxy server for internet access, see [Configure proxy settings for Azure Local](../manage/configure-proxy-settings-23h2.md).

> [!IMPORTANT]
> Azure Express Route and Azure Private Link are not supported for Azure Local or any of its components as it is not possible to access the public endpoints required for Azure Local.

## Firewall requirements for outbound endpoints

Opening ports 80 and 443 for outbound network traffic on your organization's firewall meets the connectivity requirements for the Azure Stack HCI operating system to connect with Azure and Microsoft Update.

Azure Local needs to periodically connect to Azure for:

- Well-known Azure IPs
- Outbound direction
- Ports 80 (HTTP) and 443 (HTTPS)

> [!IMPORTANT]
> Azure Local doesn't support HTTPS inspection. Make sure that HTTPS inspection is disabled along your networking path for Azure Local to prevent any connectivity errors. This includes use of [Entra ID **tenant restrictions v1**](/entra/identity/enterprise-apps/tenant-restrictions) which is not supported for Azure Local management network communication.

As shown in the following diagram, Azure Local can access Azure using more than one firewall potentially.

:::image type="content" source="./media/firewall-requirements/firewalls-diagram.png" alt-text="Diagram shows Azure Local accessing service tag endpoints through Port 443 (HTTPS) of firewalls." lightbox="./media/firewall-requirements/firewalls-diagram.png":::

## Required firewall URLs for Azure Local deployments

Azure Local instances automatically enables Azure Resource Bridge and AKS infrastructure and uses the Arc for Servers agent to connect to Azure control plane. Along with the list of HCI specific endpoints on the following table, the [Azure Resource Bridge on Azure Local](/azure/azure-arc/resource-bridge/network-requirements) endpoints, the [AKS on Azure Local](/azure/aks/hybrid/aks-hci-network-system-requirements#firewall-url-exceptions) endpoints and the [Azure Arc-enabled servers](/azure/azure-arc/servers/network-requirements) endpoints must be included in the allow list of your firewall.

For a consolidated list of endpoints for East US that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in East US for Azure Local](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/EastUSendpoints/eastus-hci-endpoints.md)

For a consolidated list of endpoints for West Europe that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in West Europe for Azure Local](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/WestEuropeendpoints/westeurope-hci-endpoints.md)

For a consolidated list of endpoints for Australia East that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in Australia East for Azure Local](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/AustraliaEastendpoints/AustraliaEast-hci-endpoints.md)

For a consolidated list of endpoints for Canada Central that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in Canada Central for Azure Local](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/CanadaCentralEndpoints/canadacentral-hci-endpoints.md)

For a consolidated list of endpoints for India Central that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in India Central for Azure Local](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/IndiaCentralEndpoints/IndiaCentral-hci-endpoints.md)

For a consolidated list of endpoints for Southeast Asia that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in Southeast Asia for Azure Local](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/SouthEastAsiaEndpoints/southeastasia-hci-endpoints.md)

For a consolidated list of endpoints for Japan East that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in Japan East for Azure Local](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/JapanEastEndpoints/japaneast-hci-endpoints.md)

For a consolidated list of endpoints for South Central US that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in South Central US for Azure Local](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/SouthCentralUSEndpoints/southcentralus-hci-endpoints.md)

## Required firewall URLs for Azure Local in Azure Government regions

For a consolidated list of endpoints for US Gov Virginia that includes Azure Local, Arc-enabled servers, ARB, and AKS, use:
- [Required endpoints in US Gov Virginia for Azure Local](https://github.com/CristianEdwards/AzureStack-Tools/blob/master/HCI/usgovvirginia-hci-endpoints/usgovvirginia-hci-endpoints.md)

## Firewall requirements for OEMs

Depending on the OEM you are using for Azure Local you may need to open additional endpoints in your firewall.

DataON required endpoints for Azure Local deployments
- [DataOn required endpoints](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/OEMEndpoints/DataOn/DataOnAzureLocalEndpoints.md)

Dell required endpoints for Azure Local deployments
- [Dell required endpoints](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/OEMEndpoints/Dell/DellAzureLocalEndpoints.md)

HPE required endpoints for Azure Local deployments
- [HPE required endpoints](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/OEMEndpoints/HPE/HPEAzureLocalEndpoints.md)

Hitachi required endpoints for Azure Local deployments
- [Hitachi required endpoints](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/OEMEndpoints/Hitachi/HitachiAzureLocalEndpoints.md)

Lenovo required endpoints for Azure Local deployments
- [Lenovo required endpoints](https://github.com/Azure/AzureStack-Tools/blob/master/HCI/OEMEndpoints/Lenovo/LenovoAzureLocalEndpoints.md)

## Firewall requirements for additional Azure services

Depending on additional Azure services you enable for Azure Local, you may need to make additional firewall configuration changes. Refer to the following links for information on firewall requirements for each Azure service:

- [Azure Monitor Agent](/azure/azure-monitor/agents/azure-monitor-agent-data-collection-endpoint?tabs=PowerShellWindows#firewall-requirements)
- [Azure portal](/azure/azure-portal/azure-portal-safelist-urls?tabs=public-cloud)
- [Azure Site Recovery](/azure/site-recovery/hyper-v-azure-architecture#outbound-connectivity-for-urls)
- [Azure Virtual Desktop](/azure/firewall/protect-azure-virtual-desktop)
- [Microsoft Defender](/microsoft-365/security/defender-endpoint/production-deployment?#network-configuration)
- [Microsoft Monitoring Agent (MMA) and Log Analytics Agent](/azure/azure-monitor/agents/log-analytics-agent#network-requirements)
- [Qualys](/azure/defender-for-cloud/deploy-vulnerability-assessment-vm#what-prerequisites-and-permissions-are-required-to-install-the-qualys-extension)
- [Remote support](../manage/get-remote-support.md#configure-proxy-settings)
- [Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/network-requirements)
- [Windows Admin Center in Azure portal](/windows-server/manage/windows-admin-center/azure/manage-hci-clusters?toc=/azure-stack/hci/toc.json&bc=/azure-stack/breadcrumb/toc.json#networking-requirements)

## Firewall requirements for internal rules and ports

Ensure that the proper network ports are open between all nodes, both within a site and between sites for stretched instances (stretched instance functionality is only available in Azure Stack HCI, version 22H2). You'll need appropriate firewall rules to allow ICMP, SMB (port 445, plus port 5445 for SMB Direct if using iWARP RDMA), and WS-MAN (port 5985) bi-directional traffic between all nodes in the cluster.

When using the **Creation wizard** in Windows Admin Center to create the cluster, the wizard automatically opens the appropriate firewall ports on each server in the cluster for Failover Clustering, Hyper-V, and Storage Replica. If you're using a different firewall on each machine, open the ports as described in the following sections:

### Azure Stack HCI OS management

Ensure that the following firewall rules are configured in your on-premises firewall for Azure Stack HCI OS management, including licensing and billing.

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow inbound/outbound traffic to and from the Azure Local service on Azure Local machines | Allow | Instance nodes | Instance nodes | TCP | 30301 |

### Windows Admin Center

Ensure that the following firewall rules are configured in your on-premises firewall for Windows Admin Center.

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Provide access to Azure and Microsoft Update | Allow | Windows Admin Center | Azure Local | TCP | 445 |
| Use Windows Remote Management (WinRM) 2.0<br> for HTTP connections to run commands<br> on remote Windows servers | Allow | Windows Admin Center | Azure Local | TCP | 5985 |
| Use WinRM 2.0 for HTTPS connections to run<br> commands on remote Windows servers | Allow | Windows Admin Center | Azure Local | TCP | 5986 |

>[!NOTE]
> While installing Windows Admin Center, if you select the **Use WinRM over HTTPS only** setting, then port 5986 is required.

### Active Directory

Ensure that the following firewall rules are configured in your on-premises firewall for Active Directory (local security authority).

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow inbound/outbound connectivity to the Active Directory Web services (ADWS) and Active Directory Management Gateway Service | Allow | Azure Local | Active Directory Services | TCP | 9389 |

### Network Time Protocol

Ensure that the following firewall rules are configured in your on-premises firewall for Network Time Protocol (NTP).

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow inbound/outbound connectivity to the Network Time Protocol (NTP) server. This server can be Active Directory domain controllers, or an NTP appliance. | Allow | Azure Local | Network Time Protocol (NTP/SNTP) server | UDP | 123 |

### Failover Clustering

Ensure that the following firewall rules are configured in your on-premises firewall for Failover Clustering.

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow Failover Cluster validation | Allow | Management system | Instance nodes | TCP | 445 |
| Allow RPC dynamic port allocation | Allow | Management system | Instance nodes | TCP | Minimum of 100 ports<br> above port 5000 |
| Allow Remote Procedure Call (RPC) | Allow | Management system | Instance nodes | TCP | 135 |
| Allow Cluster Administrator | Allow | Management system | Instance nodes | UDP | 137 |
| Allow Cluster Service | Allow | Management system | Instance nodes | UDP | 3343 |
| Allow Cluster Service (Required during<br> a server join operation.) | Allow | Management system | Instance nodes | TCP | 3343 |
| Allow ICMPv4 and ICMPv6<br> for Failover Cluster validation | Allow | Management system | Instance nodes | n/a | n/a |

>[!NOTE]
> The management system includes any computer from which you plan to administer the system, using tools such as Windows Admin Center, Windows PowerShell, or System Center Virtual Machine Manager.

### Hyper-V

Ensure that the following firewall rules are configured in your on-premises firewall for Hyper-V.

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow cluster communication | Allow | Management system | Hyper-V server | TCP | 445 |
| Allow RPC Endpoint Mapper and WMI | Allow | Management system | Hyper-V server | TCP | 135 |
| Allow HTTP connectivity | Allow | Management system | Hyper-V server | TCP | 80 |
| Allow HTTPS connectivity | Allow | Management system | Hyper-V server | TCP | 443 |
| Allow Live Migration | Allow | Management system | Hyper-V server | TCP | 6600 |
| Allow VM Management Service | Allow | Management system | Hyper-V server | TCP | 2179 |
| Allow RPC dynamic port allocation | Allow | Management system | Hyper-V server | TCP | Minimum of 100 ports<br> above port 5000 |

>[!NOTE]
> Open up a range of ports above port 5000 to allow RPC dynamic port allocation. Ports below 5000 may already be in use by other applications and could cause conflicts with DCOM applications. Previous experience shows that a minimum of 100 ports should be opened, because several system services rely on these RPC ports to communicate with each other. For more information, see [How to configure RPC dynamic port allocation to work with firewalls](/troubleshoot/windows-server/networking/configure-rpc-dynamic-port-allocation-with-firewalls).

### Storage Replica (stretched cluster)

Ensure that the following firewall rules are configured in your on-premises firewall for Storage Replica (stretched instance).

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow Server Message Block<br> (SMB) protocol | Allow | Stretched instance nodes | Stretched instance nodes | TCP | 445 |
| Allow Web Services-Management<br> (WS-MAN) | Allow | Stretched instance nodes | Stretched instance nodes | TCP | 5985 |
| Allow ICMPv4 and ICMPv6<br> (if using the `Test-SRTopology`<br> PowerShell cmdlet) | Allow | Stretched instance nodes | Stretched instance nodes | n/a | n/a |

## Update Microsoft Defender firewall

This section shows how to configure Microsoft Defender firewall to allow IP addresses associated with a service tag to connect with the operating system. A *service tag* represents a group of IP addresses from a given Azure service. Microsoft manages the IP addresses included in the service tag, and automatically updates the service tag as IP addresses change to keep updates to a minimum. To learn more, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).

1. Download the JSON file from the following resource to the target computer running the operating system: [Azure IP Ranges and Service Tags – Public Cloud](https://www.microsoft.com/download/details.aspx?id=56519).

1. Use the following PowerShell command to open the JSON file:

    ```powershell
    $json = Get-Content -Path .\ServiceTags_Public_20201012.json | ConvertFrom-Json
    ```

1. Get the list of IP address ranges for a given service tag, such as the `AzureResourceManager` service tag:

    ```powershell
    $IpList = ($json.values | where Name -Eq "AzureResourceManager").properties.addressPrefixes
    ```

1. Import the list of IP addresses to your external corporate firewall, if you're using an allowlist with it.

1. Create a firewall rule for each node in the system to allow outbound 443 (HTTPS) traffic to the list of IP address ranges:

    ```powershell
    New-NetFirewallRule -DisplayName "Allow Azure Resource Manager" -RemoteAddress $IpList -Direction Outbound -LocalPort 443 -Protocol TCP -Action Allow -Profile Any -Enabled True
    ```

## Next steps

For more information, see also:

- The Windows Firewall and WinRM 2.0 ports section of [Installation and configuration for Windows Remote Management](/windows/win32/winrm/installation-and-configuration-for-windows-remote-management#windows-firewall-and-winrm-20-ports).
- [About Azure Local deployment](../deploy/deployment-introduction.md).
