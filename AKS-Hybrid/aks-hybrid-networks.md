---
title: How to create AKS hybrid networks for Azure (preview)
description: Learn how to create Arc enabled networks and connect them to Azure.
ms.topic: overview
author: sethmanheim
ms.date: 11/21/2022
ms.author: sethm 
ms.lastreviewed: 11/21/2023
ms.reviewer: mikek

---

# How to create AKS hybrid networks and connect them to Azure (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

Once you've installed and configured Azure Stack HCI 23H2, the infrastructure administrator must also create Arc-enabled networks and connect these networks to Azure.

> [!NOTE]
> Both DHCP and static IP-based networking for your AKS clusters are supported. We strongly recommend using static IP addresses for AKS for production deployments.

## Before you begin

Before you begin, make sure you meet the following requirements:

- Access and the required permissions to an Azure subscription.
- Installed and configured Azure Stack HCI 23H2 or newer and created a custom location.
- IP address exhaustion can lead to Kubernetes cluster deployment failures. As an administrator, you must make sure that the network you create contains enough usable IP addresses. For more information, see the following section.

## IP address planning

Regardless of your deployment model, the number of IP addresses reserved remains the same. This section describes the number of IP addresses you need to reserve based on your AKS hybrid deployment model.

## Minimum IP address reservation

At a minimum, you should reserve the following number of IP addresses for your deployment:

| Cluster type     | Control plane node | Worker node     | For update operations | Load balancer |
|------------------|--------------------|-----------------|-----------------------|---------------|
| Workload cluster | One IP per node    | One IP per node | 5 IP                  | One IP        |

Additionally, you should reserve the following number of IP addresses for your Kubernetes service VIP pool:

| Resource type                | Number of IP addresses |
|------------------------------|------------------------|
| Kubernetes Internal Services | 1 per service          |
| Application Services         | 1 per service planned  |

As you can see, the number of required IP addresses is variable depending on the architecture of your AKS deployment, and the number of services you run on your Kubernetes cluster. We recommend reserving a minimum of 256 IP addresses (/24 subnet) for your deployment.

## Choose between static IP (recommended) and DHCP-based networks

You can choose between Static IP and DHCP based networks for your AKS hybrid clusters. Run the following commands from any one node on your physical cluster.

### [Static IP-based network with VLAN](#tab/staticip)

```powershell
New-ArcHciVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsServers -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -k8snodeippoolstart $vmPoolStart -k8snodeippoolend $vmPoolEnd -vlanID $vlanid
```

### [DHCP-based network with VLAN](#tab/dhcp)

```powershell
New-ArcHciVirtualNetwork -name $clustervnetname -vswitchname $vswitchname -ipaddressprefix $ipaddressprefix -gateway $gateway -dnsservers $dnsServers -vippoolstart $vipPoolStart -vippoolend $vipPoolEnd -k8snodeippoolstart $vmPoolStart -k8snodeippoolend $vmPoolEnd -vlanID $vlanid
```

---

| Parameter    | Details                                                                                                                                                         |
|------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `$clustervnetname` | The name of your virtual network for AKS hybrid clusters.                                                                                                 |
| `$vswitchname`     | The name of your VM switch.                                                                                                                               |
| `$ipaddressprefix` | The IP address value of your subnet.                                                                                                                      |
| `$gateway`         | The IP address value of your gateway for the subnet.                                                                                                      |
| `$dnsservers`      | The IP address value(s) of your DNS servers.                                                                                                              |
| `$vmPoolStart`     | The start IP address of your VM IP pool. The address must be in range of the subnet.                                                                                          |
| `$vmPoolEnd`       | The end IP address of your VM IP pool. The address must be in range of the subnet.                                                                                            |
| `$vipPoolStart`    | The start IP address of the VIP pool. The address must be within the range of the subnet. The IP addresses in the VIP pool are for the API server and for Kubernetes services. |
| `$vipPoolEnd`      | The end IP address of the VIP pool.                                                                                                                       |
| `$vlanId`          | The identification number of the VLAN in use. Every virtual machine is tagged with that VLAN ID.                                                                        |

## Next steps

[Create and manage AKS hybrid clusters using Azure CLI](create-aks-hybrid-preview-cli.md)
