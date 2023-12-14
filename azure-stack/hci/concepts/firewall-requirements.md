---
title: Firewall requirements for Azure Stack HCI
description: This topic provides guidance on firewall requirements for the Azure Stack HCI operating system.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 12/11/2023
---

# Firewall requirements for Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2-21h2.md)]

This article provides guidance on how to configure firewalls for the Azure Stack HCI operating system. It includes firewall requirements for outbound endpoints and internal rules and ports. The article also provides information on how to use Azure service tags with Microsoft Defender firewall.

If your network uses a proxy server for internet access, see [Configure proxy settings for Azure Stack HCI](../manage/configure-proxy-settings.md).

## Firewall requirements for outbound endpoints

Opening port 443 for outbound network traffic on your organization's firewall meets the connectivity requirements for the operating system to connect with Azure and Microsoft Update. If your outbound firewall is restricted, then we recommend including the URLs and ports described in the [Recommended firewall URLs](#recommended-firewall-urls) section of this article.

Azure Stack HCI needs to periodically connect to Azure. Access is limited only to:

- Well-known Azure IPs
- Outbound direction
- Port 443 (HTTPS)

> [!IMPORTANT]
> Azure Stack HCI doesn’t support HTTPS inspection. Make sure that HTTPS inspection is disabled along your networking path for Azure Stack HCI to prevent any connectivity errors.

As shown in the following diagram, Azure Stack HCI accesses Azure using more than one firewall potentially.

:::image type="content" source="./media/firewall-requirements/firewalls-diagram.png" alt-text="Diagram shows Azure Stack HCI accessing service tag endpoints through Port 443 (HTTPS) of firewalls." lightbox="./media/firewall-requirements/firewalls-diagram.png":::

This article describes how to optionally use a highly locked-down firewall configuration to block all traffic to all destinations except those included in your allowlist.

## Required firewall URLs

The following table provides a list of required firewall URLs. Make sure to include these URLs to your allowlist.

> [!NOTE]
> The Azure Stack HCI firewall rules are the minimum endpoints required for HciSvc connectivity, and don't contain wildcards. However, the following table currently contains wildcard URLs, which may be updated into precise endpoints in the future.

[!INCLUDE [Required URLs table](../../includes/hci-required-urls-table.md)]

For a comprehensive list of all the firewall URLs, download the [firewall URLs spreadsheet](https://github.com/Azure/AzureStack-Tools/raw/master/HCI/azure-stack-hci-firewall-rules.xlsx).

## Recommended firewall URLs

The following table provides a list of recommended firewall URLs. If your outbound firewall is restricted, we recommend including the URLs and ports described in this section to your allowlist.

> [!NOTE]
> The Azure Stack HCI firewall rules are the minimum endpoints required for HciSvc connectivity, and don't contain wildcards. However, the following table currently contains wildcard URLs, which may be updated into precise endpoints in the future.

[!INCLUDE [Recommended URLs table](../../includes/hci-recommended-urls-table.md)]

## Firewall requirements for additional Azure services

Depending on additional Azure services you enable on HCI, you may need to make additional firewall configuration changes. Refer to the following links for information on firewall requirements for each Azure service:

- [AKS on Azure Stack HCI](/azure-stack/aks-hci/system-requirements?tabs=allow-table#aks-on-azure-stack-hci-requirements)
- [Azure Arc-enabled servers](/azure/azure-arc/servers/network-requirements)
- [Azure Arc VM management](../manage/azure-arc-vm-management-prerequisites.md)
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

Ensure that the proper network ports are open between all server nodes both within a site and between sites (for stretched clusters). You'll need appropriate firewall rules to allow ICMP, SMB (port 445, plus port 5445 for SMB Direct if using iWARP RDMA), and WS-MAN (port 5985) bi-directional traffic between all servers in the cluster.

When using the Cluster Creation wizard in Windows Admin Center to create the cluster, the wizard automatically opens the appropriate firewall ports on each server in the cluster for Failover Clustering, Hyper-V, and Storage Replica. If you're using a different firewall on each server, open the ports as described in the following sections:

### Azure Stack HCI OS management

Ensure that the following firewall rules are configured in your on-premises firewall for Azure Stack HCI OS management, including licensing and billing.

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow inbound/outbound traffic to and from the Azure Stack HCI service on cluster servers | Allow | Cluster servers | Cluster servers | TCP | 30301 |

### Windows Admin Center

Ensure that the following firewall rules are configured in your on-premises firewall for Windows Admin Center.

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Provide access to Azure and Microsoft Update | Allow | Windows Admin Center | Azure Stack HCI | TCP | 445 |
| Use Windows Remote Management (WinRM) 2.0<br> for HTTP connections to run commands<br> on remote Windows servers | Allow | Windows Admin Center | Azure Stack HCI | TCP | 5985 |
| Use WinRM 2.0 for HTTPS connections to run<br> commands on remote Windows servers | Allow | Windows Admin Center | Azure Stack HCI | TCP | 5986 |

>[!NOTE]
> While installing Windows Admin Center, if you select the **Use WinRM over HTTPS only** setting, then port 5986 is required.

### Failover Clustering

Ensure that the following firewall rules are configured in your on-premises firewall for Failover Clustering.

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow Failover Cluster validation | Allow | Management system | Cluster servers | TCP | 445 |
| Allow RPC dynamic port allocation | Allow | Management system | Cluster servers | TCP | Minimum of 100 ports<br> above port 5000 |
| Allow Remote Procedure Call (RPC) | Allow | Management system | Cluster servers | TCP | 135 |
| Allow Cluster Administrator | Allow | Management system | Cluster servers | UDP | 137 |
| Allow Cluster Service | Allow | Management system | Cluster servers | UDP | 3343 |
| Allow Cluster Service (Required during<br> a server join operation.) | Allow | Management system | Cluster servers | TCP | 3343 |
| Allow ICMPv4 and ICMPv6<br> for Failover Cluster validation | Allow | Management system | Cluster servers | n/a | n/a |

>[!NOTE]
> The management system includes any computer from which you plan to administer the cluster, using tools such as Windows Admin Center, Windows PowerShell or System Center Virtual Machine Manager.

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

Ensure that the following firewall rules are configured in your on-premises firewall for Storage Replica (stretched cluster).

| Rule | Action | Source | Destination | Service | Ports |
|:--|:--|:--|:--|:--|:--|
| Allow Server Message Block<br> (SMB) protocol | Allow | Stretched cluster servers | Stretched cluster servers | TCP | 445 |
| Allow Web Services-Management<br> (WS-MAN) | Allow | Stretched cluster servers | Stretched cluster servers | TCP | 5985 |
| Allow ICMPv4 and ICMPv6<br> (if using the `Test-SRTopology`<br> PowerShell cmdlet) | Allow | Stretched cluster servers | Stretched cluster servers | n/a | n/a |

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