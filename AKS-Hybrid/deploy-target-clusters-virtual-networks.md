---
title: How to deploy AKS hybrid target clusters on different SDN virtual networks
description: Learn how to deploy AKS hybrid target clusters on different software defined networking (SDN) virtual networks.
author: sethmanheim
ms.topic: how-to
ms.date: 06/01/2023
ms.author: sethm 
ms.lastreviewed: 06/01/2023
ms.reviewer: kybisnet

# Intent: As an IT pro, I want to learn how to deploy AKS hybrid target clusters on different SDN virtual networks.
# Keyword: networking software defined networking virtual networking

---

# Deploy AKS hybrid target clusters on different SDN virtual networks

Deploying AKS hybrid target clusters on different software defined networking (SDN) virtual networks (VNETs, see [Deploy Microsoft SDN with AKS hybrid](software-defined-networking.md)) can offer a range of benefits, primarily focused on security, scalability, and organization of networks:

- **Security and isolation**: Each isolated vNET acts as a separate entity, which can help to contain potential security threats. If one network is compromised, the threat is less likely to spread to other vNETs.
- **Scalability**: Deploying AKS hybrid target clusters on multiple networks can improve the scalability of your applications. As your requirements and/or compliance grows, you can simply add more AKS hybrid target clusters to new SDN vNETs.
- **Service segmentation**: Isolated networks enable you to logically segregate services or applications based on their function or the business they serve, especially O/T networks with high compliance and regulatory requirements. This simplifies management, monitoring, and troubleshooting.
- **Regulatory compliance**: For organizations operating under strict guidelines such as manufacturing, healthcare, and finance, isolated networks can help achieve compliance with little increase in physical IP address space such as VLANs, subnets, etc.

## Configure a new SDN virtual network

Prior to deploying a new AKS hybrid target cluster, you must create a new virtual network. If the name of the SDN vNET was already created using Windows Admin Center or PowerShell, you can re-use the existing vNET (SDN managed vNET). If it has not been created, we create this for you in AKS and SDN Network Controller (MOC Managed Virtual Network):

```powershell
New-AksHciNetworkSetting -name "SDNvNET1" -vswitchName "ConvergedSwitch(hci) ` 
-ipAddressPrefix "13.20.0.0/8" -gateway "13.20.0.1" -dnsServers "10.195.95.223"  ` 
-k8sNodeIpPoolStart "13.20.0.2" -k8sNodeIpPoolEnd "13.20.100.255"  ` 
```

|       Parameter                          |     Description                                                                                                                                                                                                           |
|------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
|     `name`                                 |   Name of the default virtual network. Reuses existing SDN managed network if it exists, or creates a new MOC managed network.                                                                                                |
|     `vswitchName`                         |   Name of the vSwitch configured for SDN. This vSwitch has the VFP extension enabled; only one vSwitch with VFP can be enabled on the system.                                                                           |
|     `ipAddressPrefix`                      |   Subnet prefix for creating the virtual network in the Network Controller. This prefix is a subnet prefix, not a virtual network prefix. Currently, MOC only supports a single subnet.                                           |
|     `gateway`                              |   Default gateway for the subnet. Must be the first IP of the subnet. SDN doesn't support custom default gateways for virtual networks.                                                                                  |
|     `dnsServers`                           |   DNS servers reachable from SDN VMs public IP or other (for example, an L3 connection), used for name resolutions.                                                                                                              |
|     `K8sNodeIpPoolStart`, `K8sNodeIpPoolEnd`  |   A subset or full IP range from the `ipAddressPrefix`. Used by MOC IPAM to allocate IP addresses for nodes. Useful if deploying non-AKSHCI VMs on the same subnet, but not recommended due to possible misconfigurations.  |

## Create a Kubernetes cluster on your SDN virtual network

After you create an SDN vNET that is isolated, you can create a new Kubernetes cluster. First, retrieve the SDN vNET that you created, and save this value into a variable:

```powershell
$SDNvNET1 = Get-AksHciClusterNetwork -name "SDNvNET1"
```

You can use that variable to pass to the [New-AksHciCluster](reference/ps/new-akshcicluster.md) cmdlet. You must specify at least the name and the vnet:

```powershell
New-AksHciCluster -name "OTCluster1" -vnet "$SDNvNET1"
```

## Next steps

[Deploy Microsoft Software Defined Networking (SDN) with AKS hybrid](software-defined-networking.md)