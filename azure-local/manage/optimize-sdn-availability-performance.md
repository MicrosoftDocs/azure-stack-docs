---
title: Optimize SDN Availability and Performance
description: Learn how to improve availability and optimize performance for Software Defined Networking (SDN) deployments in Azure Local. 
author: ronmiab
ms.topic: how-to
ms.date: 08/03/2026
ms.author: robess
ms.service: azure-local
ms.subservice: hyperconverged
---

# Optimize SDN availability and performance

This article describes how to improve the availability and performance of Software Defined Networking (SDN) deployments. It covers distributing SDN infrastructure virtual hard disks (VHDs) across multiple storage locations, enabling clustering for SDN roles, configuring affinity rules, and optimizing SDN virtual machines for packet-processing workloads.

After you deploy your SDN infrastructure, perform the tasks in this article to reduce single points of failure and improve resiliency during planned maintenance and unexpected outages.

## Distribute VHDs across cluster storage

Commonly, you deploy SDN infrastructure VHDs to the same storage location. However, this configuration can create a single point of failure if that storage location becomes unavailable.

If you're using Cluster Shared Volumes, for example, use the following design:

- SDN_FABRIC_{ROLE}_1 → ClusterSharedVolume1

- SDN_FABRIC_{ROLE}_2 → ClusterSharedVolume2

- SDN_FABRIC_{ROLE}_3 → ClusterSharedVolume3

If *ClusterSharedVolume2* encounters an issue, only NetworkController2, LoadBalancerMux2, and RasGateway2 are impacted. There's a temporary disruption during failover; however, the Network Controller remains operational and automatically moves the appropriate tenant resources to available infrastructure nodes to restore services.

## Enable clustering for SDN roles

Enable clustering for each of the SDN fabric nodes to improve fault tolerance if a physical node has problems, or if you need to perform scheduled maintenance and drain or suspend the node. When you enable clustering, the VM moves to a new physical host with minimal disruption to hosted workloads and services.

If you have sufficient hosts, configure affinity rules to ensure that you don't place all SDN infrastructure nodes on the same Hyper‑V host. For example, if two Network Controller VMs are on the same host and that host encounters a problem, Service Fabric services within the Network Controller might be impacted, resulting in a read‑only state. In this state, the Network Controller can't fail over workloads or configure policies until Service Fabric quorum is restored.

## Use a static IP for the northbound REST endpoint

During deployment, specify either `RestName` or `RestIPAddress`. This setting determines how the Network Controller northbound API endpoint registers in DNS for name resolution.

To identify the current configuration, run the `Get-NetworkController` cmdlet. If the `RestName` property contains a value, the deployment uses a dynamic DNS record.

When the `ApiService` role fails over to a new primary replica, it updates the DNS record to point to the new IP address. In some environments, this behavior can cause interoperability problems between Network Controller and DNS services. If the DNS record can't be resolved, requests to the northbound API endpoint fail.

To avoid this problem, use a static IP address that moves with the service during failover. Use the `SdnDiagnostics` module to change the configuration to Static.

```powershell
Set-SdnNetworkController -RestIPAddress IP_Address/CIDR
```

For more information, see the [Dynamic vs Static RestName](https://github.com/microsoft/SdnDiagnostics/wiki/Dynamic-vs-Static-RestName) wiki page.

## Performance recommendations

The following recommendations can help reduce CPU bottlenecks, improve packet-processing performance, and minimize network latency.

### RAS gateway virtual machines

Remote Access Service (RAS) gateways process packets between internal and external interfaces. Because packet processing is more CPU-intensive than memory-intensive, use the following minimum configuration:

- Memory: 8 GB

- vCPU: 16 cores

- OS disk size: 120 GB

To improve packet-processing performance, enable forwarding optimization and increase the send and receive buffer sizes on the network adapters that handle internal and external traffic. Each RAS gateway VM includes three network adapters: Management, Internal, and External.

Run the following commands on the adapters responsible for internal or external packet processing:

```powershell
Set-NetAdapterAdvancedProperty -Name "Internal","External" -DisplayName "Forwarding Optimization" -DisplayValue Enabled -NoRestart

Set-NetAdapterAdvancedProperty -Name "Internal","External" -DisplayName "Receive Buffer Size" -DisplayValue 16MB -NoRestart

Set-NetAdapterAdvancedProperty -Name "Internal","External" -DisplayName "Send Buffer Size" -DisplayValue 32MB -NoRestart
```

#### Gateway performance without optimizations

The following image shows CPU utilization on a RAS gateway VM configured with eight vCPUs and default network adapter settings. Several logical processors remain heavily utilized, which can increase latency and lead to packet drops when the gateway is under load. The increased utilization occurs on logical processors that map to physical CPU cores, a behavior that's expected in environments that use Hyper-Threading.

:::image type="content" source="media/optimize-sdn-availability-performance/no-optimization.png" alt-text="Diagram showing CPU utilization view of an eight-vCPU RAS gateway virtual machine without performance optimizations, showing several logical processors consistently operating at high utilization levels." lightbox="media/optimize-sdn-availability-performance/no-optimization.png":::

#### Gateway performance with optimizations

The following image shows CPU utilization after increasing the VM to 16 vCPUs. By increasing the vCPU count and configuring the advanced properties, you can reduce average consumption to around 50% per core, significantly improving packet performance on the RAS gateway and ensuring minimal latency.

:::image type="content" source="media/optimize-sdn-availability-performance/optimization.png" alt-text="Diagram showing CPU utilization view of an optimized RAS gateway virtual machine with 16 vCPUs, showing balanced workload distribution and lower processor utilization across logical processors." lightbox="media/optimize-sdn-availability-performance/optimization.png":::

### Load Balancer Muxes

Like RAS gateways, Load Balancer MUXes perform extensive packet processing. Increasing the number of vCPUs can improve packet-processing performance.

- Memory: 8 GB

- vCPU: 16 Cores

- OS disk size: 120 GB

To improve packet-processing performance, enable forwarding optimization and increase the send and receive buffer sizes on the MUX network adapters. Each MUX should have at least two network adapters: one for management and another connected to the HNVPA logical network. If you're using multiple logical networks on different VLANs, you can add more adapters to the MUX. Each adapter corresponds to a logical network that you want the Load Balancer MUXes to work with.

```powershell
Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Forwarding Optimization" -DisplayValue Enabled -NoRestart

Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Receive Buffer Size" -DisplayValue 16MB -NoRestart

Set-NetAdapterAdvancedProperty -Name "Ethernet" -DisplayName "Send Buffer Size" -DisplayValue 32MB -NoRestart
```

### Network Controllers

Use the following minimum configuration to support policy management, infrastructure orchestration, and controller operations:

- Memory: 12 GB

- vCPU: 8 Cores

- OS disk size: 160 GB

## Next steps

- [Software Defined Networking (SDN) managed by on-premises tools in Azure Local](../concepts/software-defined-networking-23h2.md)
- [Manage Software Load Balancer for SDN managed by on-premises tools](./load-balancers.md)
- [Manage Azure Local gateway connections](./gateway-connections.md)