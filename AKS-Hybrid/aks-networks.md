---
title: Create networks for AKS (preview)
description: Learn how to create Arc-enabled networks for AKS and connect them to Azure.
ms.topic: how-to
author: sethmanheim
ms.date: 12/11/2023
ms.author: sethm 
ms.lastreviewed: 11/27/2023
ms.reviewer: mikek

---

# Create networks for AKS (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

After you install and configure Azure Stack HCI 23H2, the infrastructure administrator must also create networks and connect them to Azure so that AKS can use the network when creating Kubernetes clusters.

> [!NOTE]
> Both DHCP and static IP-based networking for your AKS clusters are supported. It's recommended that you use static IP addresses.

## Before you begin

Before you begin, make sure you meet the following requirements:

- An Azure subscription, and the required permissions to access that subscription.
- Install and configure Azure Stack HCI 23H2 or newer and create a custom location, and get the Azure Resource Manager ID of the custom location.
- Download the **akshybrid** Az CLI extension to create the AKS network.
- Make sure that the network you create contains enough usable IP addresses to avoid IP address exhaustion. IP address exhaustion can lead to Kubernetes cluster deployment failures. For more information, see the following section.

## IP address planning

Regardless of your choice of IP address assignment model, the number of IP addresses required by AKS remains the same. This section describes the number of IP addresses you need to reserve, based on your AKS deployment.

## Minimum IP address reservation

At a minimum, you should reserve the following number of IP addresses for your deployment:

| Cluster type     | Control plane node | Worker node     | For update operations | Load balancer |
|------------------|--------------------|-----------------|-----------------------|---------------|
| Workload cluster | One IP per node    | One IP per node | 5 IP                  | One IP        |

Additionally, you should reserve the following number of IP addresses for your Kubernetes service VIP pool. These addresses are allocated to external Kubernetes services used by your applications:

| Resource type                | Number of IP addresses |
|------------------------------|------------------------|
| AKS internal services | 1 per Kubernetes cluster          |
| Application services         | 1 per application service planned  |

As you can see, the number of required IP addresses is variable depending on the architecture of your AKS deployment, and the number of services you run on your Kubernetes cluster. We recommend reserving a minimum of 256 IP addresses (/24 subnet) for your deployment.

## Choose between static IP (recommended) and DHCP-based networks

You can choose between static IP- and DHCP-based networks for your Kubernetes clusters. It's recommended that you only use DHCP-based networks for test and validation environments. For production environments, use static IP address assignments.

Run the following commands from any single node on your physical cluster:

### [Static IP-based network with VLAN](#tab/staticip)

```powershell
New-ArcHciVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsServers -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -k8snodeippoolstart $vmPoolStart -k8snodeippoolend $vmPoolEnd -vlanID $vlanid
```

### [DHCP-based network with VLAN](#tab/dhcp)

```powershell
New-ArcHciVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -vlanID $vlanid
```

---

| Parameter    | Description | DHCP | Static |
|------------------|---------|-----------|-------------------|
| `$clustervnetname` | The name of your virtual network for AKS hybrid clusters. | ![Supported](media/aks-hybrid-networks/check.png) | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vswitchname`     | The name of your VM switch. | ![Supported](media/aks-hybrid-networks/check.png) | ![Supported](media/aks-hybrid-networks/check.png) |
| `$ipaddressprefix` | The IP address value of your subnet.  | N/A | ![Supported](media/aks-hybrid-networks/check.png) |
| `$gateway`         | The IP address value of your gateway for the subnet.  | N/A | ![Supported](media/aks-hybrid-networks/check.png) |
| `$dnsservers`      | The IP address value(s) of your DNS servers. | N/A | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vmPoolStart`     | The start IP address of your VM IP pool. The address must be in range of the subnet.  | N/A | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vmPoolEnd`       | The end IP address of your VM IP pool. The address must be in range of the subnet.  | N/A | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vipPoolStart`    | The start IP address of the VIP pool. The address must be within the range of the subnet. The IP addresses in the VIP pool are for the API server and for Kubernetes services. | ![Supported](media/aks-hybrid-networks/check.png) | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vipPoolEnd`      | The end IP address of the VIP pool. | ![Supported](media/aks-hybrid-networks/check.png) | ![Supported](media/aks-hybrid-networks/check.png) |
| `$vlanId`          | The identification number of the VLAN in use. Every virtual machine is tagged with that VLAN ID. | ![Supported](media/aks-hybrid-networks/check.png) | ![Supported](media/aks-hybrid-networks/check.png) |

## Connect the network to Azure

Use Azure CLI to connect the network created in the previous steps to Azure and make it available for AKS to use. You can run the following command from an Azure shell:

```azurecli-interactive
az akshybrid vnet create -n "<Name of your Azure connected AKS hybrid vnet>" -g $resource_group --custom-location $customlocationID --moc-vnet-name $clustervnetname
```

## Next steps

[Create and manage Kubernetes clusters on-premises using Azure CLI](create-aks-hybrid-preview-cli.md)
