---
title: Optimize SDN Availability and Performance
description: Learn how to improve availability and optimize performance for Software Defined Networking (SDN) deployments in Azure Local. 
author: ronmiab
ms.topic: how-to
ms.date: 11/03/2026
ms.author: robess
ms.service: azure-local
ms.subservice: hyperconverged
---

# Optimize SDN availability and performance

This article describes how to improve the availability and performance of Software Defined Networking (SDN) deployments. It covers distributing SDN infrastructure virtual hard disks (VHDs) across multiple storage locations, enabling clustering for SDN roles, configuring affinity rules, and optimizing SDN virtual machines (VMs) for packet-processing workloads.

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

## Configure anti-affinity rules

Use failover cluster anti-affinity to distribute VMs that perform the same SDN role across different Hyper-V hosts. Assign a separate anti-affinity class to the Network Controller, RAS gateway, and Load Balancer MUX cluster groups. Failover Clustering then avoids placing two members of the same role-specific class on the same host. Separating Network Controller VMs helps preserve Service Fabric quorum if a Hyper-V host becomes unavailable.

Anti-affinity separates members of the same class. It doesn't reserve a dedicated host for a role, and it doesn't prevent Network Controller, gateway, and MUX VMs from sharing a host because each role uses a different class name. If you require role-dedicated hosts, combine anti-affinity with carefully planned possible owners or preferred owners, and validate that sufficient failover capacity remains.

### Choose enforced or not enforced anti-affinity

The `AntiAffinityClassNames` property is a soft rule by default. When `ClusterEnforcedAntiAffinity` is `0`, the cluster attempts to place roles in the same anti-affinity class on different hosts. If no other eligible host is available, it can place them together.

When `ClusterEnforcedAntiAffinity` is `1`, the rule is enforced. If the cluster can't find a host that satisfies the rule, the affected role remains offline with an Anti-Affinity Conflict state.

`ClusterEnforcedAntiAffinity` applies to the entire cluster, not to an individual class. Before you enable it, review every clustered role that has an `AntiAffinityClassNames` value.

Use the following capacity rule when deciding whether to enforce the setting:

H >= V + F

In this formula:

- **H** is the number of Hyper-V hosts available to run the role.
- **V** is the number of VMs in one anti-affinity class.
- **F** is the number of simultaneous host outages or maintenance events that the design must tolerate while keeping all VMs online.

Each host can run no more than one VM from a hard-enforced class.

The following table summarizes the host requirements and availability trade-offs for enforced and not enforced anti-affinity.

| VMs in the role (V) | Hosts for normal separation | Hosts for one unavailable host | Enforcement guidance | Availability impact |
| --- | --- | --- | --- | --- |
| 2 | 2 | 3 | Use Not Enforced with only 2 hosts. Enforced is suitable with 3 or more hosts when one-host resiliency is required. | With Enforced on 2 hosts, one VM can't fail over if either host is unavailable. |
| 3 | 3 | 4 | Use Not Enforced with fewer than 3 hosts. With exactly 3 hosts, use Not Enforced if service availability during one host outage is more important than strict separation. Enforced is suitable with 4 or more hosts for one-host resiliency. | With Enforced on 3 hosts, the displaced VM remains offline during a single host outage. |
| 4 | 4 | 5 | Use Not Enforced with fewer than 4 hosts. With exactly 4 hosts, use Not Enforced if all VMs must remain online during one host outage. Enforced is suitable with 5 or more hosts for one-host resiliency. | With Enforced on 4 hosts, the displaced VM remains offline during a single host outage. |
| Any V | V | V + 1 | For F tolerated unavailable hosts, enforce only when H is at least V + F and the remaining hosts have sufficient CPU, memory, storage, and network capacity. | If H falls below V while enforcement is enabled, at least V - H roles can't be online. |

For most clusters, use **Not Enforced** when the number of hosts is equal to or less than the number of VMs in a role. This setting preserves service availability by allowing temporary colocation during maintenance or a host failure.

Use **Enforced** only when strict separation is required and the cluster has enough additional hosts and capacity for the planned failure tolerance.

### Assign role-specific anti-affinity classes

1. Identify the cluster group names for the SDN infrastructure VMs.

    ```powershell
    Get-ClusterGroup | 
    Where-Object GroupType -eq 'VirtualMachine' | 
    Select-Object Name, OwnerNode, State 
    ```

1. Replace the example group names in the following commands with the cluster group names from your environment, and then run the following commands. Use the same anti-affinity class name for VMs that perform the same SDN role and a different class name for each role.

    ```powershell
    function Set-RoleAntiAffinityClass { 
        param( 
            [Parameter(Mandatory)] 
            [string[]] $GroupName, 
 
            [Parameter(Mandatory)] 
            [string] $ClassName 
        ) 
 
        foreach ($name in $GroupName) { 
            $classNames = [System.Collections.Specialized.StringCollection]::new() 
            [void] $classNames.Add($ClassName) 
            (Get-ClusterGroup -Name $name).AntiAffinityClassNames = $classNames 
        } 
    } 
 
    Set-RoleAntiAffinityClass ` 
        -GroupName 'SDN_FABRIC_GW_1','SDN_FABRIC_GW_2','SDN_FABRIC_GW_3' ` 
        -ClassName 'SDN-RAS-Gateway' 
 
    Set-RoleAntiAffinityClass ` 
        -GroupName 'SDN_FABRIC_MUX_1','SDN_FABRIC_MUX_2','SDN_FABRIC_MUX_3' ` 
        -ClassName 'SDN-Load-Balancer-MUX' 
 
    Set-RoleAntiAffinityClass ` 
        -GroupName 'SDN_FABRIC_NC_1','SDN_FABRIC_NC_2','SDN_FABRIC_NC_3' ` 
        -ClassName 'SDN-Network-Controller'
    ```

1. Choose one cluster-wide enforcement setting:

    - **Not enforced**: Set `ClusterEnforcedAntiAffinity` to `0` to allow temporary colocation when separation isn't possible.

        ```powershell
        (Get-Cluster).ClusterEnforcedAntiAffinity = 0
        ```

    - **Enforced**: Set `ClusterEnforcedAntiAffinity` to `1` only when strict separation is required and the cluster meets the capacity requirements. Don't enable enforced anti-affinity when there are fewer available hosts than VMs in any enforced class. During a host outage or drain, a VM that can't be placed without violating the rule remains offline.

        ```powershell
        (Get-Cluster).ClusterEnforcedAntiAffinity = 1
        ```

### Verify placement and enforcement

Review the anti-affinity class, owner node, and state of each configured group, along with the cluster-wide enforcement setting:

```powershell
Get-ClusterGroup | 
    Where-Object { $_.AntiAffinityClassNames.Count -gt 0 } | 
    Select-Object Name, OwnerNode, State, 
        @{Name='AntiAffinityClassNames';Expression={ 
            $_.AntiAffinityClassNames -join ',' 
        }} 
 
Get-Cluster | Select-Object ClusterEnforcedAntiAffinity
```

Affinity changes don't automatically move roles that are already online on the same host. Apply the setting during a maintenance window, then move or recycle the affected roles according to your standard cluster maintenance process. Confirm that peers in each class run on different hosts after the operation.

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