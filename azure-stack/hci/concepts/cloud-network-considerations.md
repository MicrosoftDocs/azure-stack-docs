---
title: Network considerations for cloud deployment
description: This topic introduces network considerations Azure Stack HCI cloud deployments.
author: alkohli
ms.topic: conceptual
ms.date: 02/20/2024
ms.author: alkohli 
ms.reviewer: alkohli
---

# Network considerations for cloud deployment

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

In this article, you will understand how to design and plan an Azure Stack HCI system network architecture before deployment. We encourage you familarize yourself with the [Azure Stack HCI networking patterns](../plan/choose-network-pattern.md) as the next step of your design and plan effort.

We have defined the following design decision framework:

:::image type="content" source="media/cloud-network-considerations/network-decision-framework.png" alt-text="Diagram showing step 1 of the network desicion framework." lightbox="media/cloud-network-considerations/network-decision-framework.png":::

The framework proposes the following design decision steps, with each design decisions in the first step to condition the options available in the following steps. To help with the first design decision regarding the size of the HCI cluster, we recommend first using the [Azure Stack HCI sizer tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer), where you can define your workloads profile such as number of VMs (Virtual Machines), size of the VMs, or if the use of those VMs will be for example for Azure Virtual Desktop, SQL Server, AKS (Azure Kubernetes Services) or any other generic type of workloads.

## Step 1: Determine cluster size

:::image type="content" source="media/cloud-network-considerations/step-1.png" alt-text="Diagram showing the network desicion framework." lightbox="media/cloud-network-considerations/step-1.png":::

As described in the Azure Stack HCI [system server requirements](system-requirements.md), the maximum number of nodes supported on Azure Stack HCI clusters is 16. Once you have completed your workload capacity planning you should have a good understanding of the number of nodes required to run your workloads. The number of nodes will condition the architecture of your cluster and you should make some design decisions aligned with your infrastructure and workloads requirements. For example, if your workload requires 4 or more nodes, in Azure Stack HCI 23H2 you will not be able to deploy and use a switchless configuration for the storage network traffic. That implies that as part of your architecture design you will need to include a physical switch with support for RDMA (Remote Direct Memory Access) to handle the storage traffic of your cluster. You can find more information to plan your HCI cluster network architecture at [Network reference patterns overview](../plan/network-patterns-overview.md).

However, if your workload requires 3 or less nodes, then you will be able to decide which storage connectivity option you would like to use. Another important design decision on this phase is if you plan to scale out or scale in the capacity of your cluster. If your intention is to start small to grow later, then you should be aware that switchless deployments will not support orchestrated scale out operations via the LCM orchestrator. Any scale out operation in your switchless deployments will require manual configuration of your network cabling between the nodes that Microsoft is not actively validating as part of its software development cycle for HCI.

Switchless configuration with LCM deployment and orchestration support is only available for 1, 2 or 3 nodes clusters. Clusters with 4 or more nodes require physical switch for the storage network traffic and the Azure Portal deployment flow will filter these options for you. ARM deployments will also support only the validated architecture described here.

If you scale out your cluster using LCM orchestration is a design requirement, you would have to use a physical switch for the storage network traffic.

## Step 2: Determine cluster storage connectivity

:::image type="content" source="media/cloud-network-considerations/step-2.png" alt-text="Diagram showing step 2 of the network desicion framework." lightbox="media/cloud-network-considerations/step-2.png":::

As described in [Physical network requirements](physical-network-requirements.md), Azure Stack HCI supports two types of connectivity for storage network traffic. The first option is to use a physical network switch to handle the traffic and the second option is to directly connect the nodes between them with cross-over network or fiber cables for the storage traffic. The advantages and disadvantages of each option are documented in the article above, so we are not going into detail in this document.

The main purpose of this section is to explain what the implications of your design decision for the storage connectivity are, and how it will influence the next phase of the framework, where you will need to define your cluster network intents. As explained in the cluster size section, you will only be able to decide between the two options when the size of your cluster is between 1 and 3 nodes. Any cluster with 4 or more nodes will automatically be deployed using a network switch for storage.

If your cluster is within the range of 1 to 3 nodes, the storage connectivity decision will influence the number and type of intents you will be able to define in the next phase. For example, if you decide to use a switchless configuration, that will imply that at least you will need to define 2 network traffic intents. Storage traffic for east-west communications using the cross-over cables will not have north-south connectivity and it will be completely isolated from the rest of your network infrastructure. That means you will need to define a second intent for management outbound connectivity and for your compute workloads. Although it is possible to define each intent with only one physical network adapter port each, that will not provide any fault tolerance mechanism and we always recommend using at least 2 physical network ports for each intent. On the contrary, if you decide to use a network switch for storage, you will be able to group all your network traffic including storage in a single intent, which is also known as hyperconverged or fully converged host network configuration.

:::image type="content" source="media/cloud-network-considerations/step-2-summary.png" alt-text="Diagram showing step 2 option summary for the network desicion framework." lightbox="media/cloud-network-considerations/step-2-summary.png":::

### With no switch

Switchless configuration with LCM deployment and orchestration support is only available for 1, 2 or 3 nodes clusters. Scale in and scale out operations are not supported using the LCM orchestrator. Any change in the number of nodes post deployment will require a manual configuration. At least 2 network intents are required when using storage switchless configuration.

### With a switch

If scale out your cluster using LCM orchestration is a design requirement, you would need to use a physical switch for the storage network traffic. You can use this architecture with any number of nodes between 1 to 16. Although is not enforced, you can use a single intent for all your network traffic types (Management, Compute and Storage).

## Step 3: Determine network traffic intents

:::image type="content" source="media/cloud-network-considerations/step-3.png" alt-text="Diagram showing step 3 of the network desicion framework." lightbox="media/cloud-network-considerations/step-3.png":::

In Azure Stack HCI 23H2, all the deployments rely on Network ATC for the host network configuration. If you are not familiar with Network ATC, see [Deploy host networking with Network ATC](../deploy/network-atc.md) to familiarize yourself with concepts such as network intents, intent overrides and all the options that this core OS (operating systems) feature brings to Azure Stack HCI.

The main purpose of this section is to explain what the implications of your design decision for network traffic intents are, and how it will influence the next phase of the framework. With the new Cloud Deployment approach, you will be able to select between four options to group your network traffic in one or more intents. As explained in the previous section, the options available depend on the size of your cluster and the storage connectivity type. The following table explains each of the network traffic intent options available to help you with your design decision.

| Network intents | Description | Design decision considerations |
| -- | -- | -- |
| Group all traffic |When selecting this option, Network ATC will configure a unique intent that will include management, compute and storge network traffic configuration. The network adapters assigned to this intent will share the bandwidth and throughput for all the network traffic. | - This option requires a physical switch for storage traffic. If you require switchless architecture, you cannot use this type of intent. The portal will automatically filter out this option if you select no switch for storage connectivity.<br>- This option requires physical switch configuration for RDMA.<br>- At least 2 network adapter ports are recommended to ensure HA (High Availability). |
| Group Management & Compute traffic | When selecting this option, Network ATC will configure two intents. The first intent will include Management and Compute network traffic, and the second intent will only include storage network traffic. Each intent must have a different set of network adapter ports. |You can use this option with both switched and switchless storage connectivity.<br>- At least 2 network adapter ports for each intent recommended to ensure HA.<br>- This option requires physical switch configuration for RDMA if you use network switch for storage |
| Group Compute & Storage traffic | When selecting this option, Network ATC will configure two intents. The first intent will include Compute and Storage network traffic, and the second intent will only include Management network traffic. Each intent must have a different set of network adapter ports. This option is considered a rare configuration used on PMEC (private multiaccess edge compute) scenarios, where management traffic must be fully isolated.| This option requires a physical switch for storage traffic because the same ports are shared with compute traffic that will require north-south communication. If you require switchless architecture, you cannot use this type of intent. The portal will automatically filter out this option if you select no switch for storage connectivity.<br>- This option requires physical switch configuration for RDMA.<br>- At least 2 network adapter ports are recommended to ensure HA.<br>- Even when Management intent is declared without compute, Network ATC will create a SET virtual switch to provide HA to the management network. |
|Custom configuration  |When selecting this option, you will be able to define up to three intents with your own configuration as long as at least one of the intents includes Management traffic. It is recommended to use this option when you need a second compute intent. Scenarios for this second compute intent requirement can be remote storage traffic, VMs backup traffic or simply a separate compute intent for distinct types of workloads | You can use this option with both switched and switchless storage connectivity if the storage intent is different from the other intents.<br>- You can use this option when additional compute intent is required or when you want to fully separate the distinct types of traffic over different network adapters.<br>- At least 2 network adapter ports for each intent recommended to ensure HA.|

:::image type="content" source="media/cloud-network-considerations/step-3-summary.png" alt-text="Diagram showing step 3 option summary for the network desicion framework." lightbox="media/cloud-network-considerations/step-3-summary.png":::

## Step 4: Determine management network connectivity

:::image type="content" source="media/cloud-network-considerations/step-4.png" alt-text="Diagram showing step 4 of the network desicion framework." lightbox="media/cloud-network-considerations/step-4.png":::

A critical task as part of your network architecture design for any Azure Stack HCI cluster is to define what will be your infrastructure subnet address space, how these addresses will be assigned to your cluster and if there is any proxy requirement on the nodes for outbound connectivity to the internet and other intranet services such as DNS (Domain Name System) or Active Directory Services. The following infrastructure subnet components must be planned and defined before you start the deployment of the cluster, so you can anticipate any routing, firewalling, or subnet future requirements.

### Network Adapters drivers

Once you installed OS, and before configuring networking on your nodes, you must ensure that your network adapters are using the latest driver provided by your OEM or the NIC vendor. Important capabilities of the network adapters might not surface when using the default Microsoft drivers.

### Management IP Pool

When doing the initial deployment of your Azure Stack HCI cluster, one of the mandatory parameters is to define an IP range of consecutive IPs for infrastructure services deployed by default. To ensure the range has enough IPs for the current and future infrastructure services, we enforce defining at least a range with 6 consecutive available IP addresses, so we can use these IPs for the Cluster IP, the Azure Resource Bridge VM and its components, the upcoming Network Controller Cluster Service IP and the VM update role. However, if you anticipate you will need to run additional services in the infrastructure network, we recommend assigning
an extra buffer of infrastructure IPs to the pool. It is possible to add additional IP Pools after deployment for the infrastructure network using PowerShell if the size of the pool you planned originally gets exhausted.

The following conditions must be true when defining your IP pool for the infrastructure subnet during deployment:\

- The range of IPs must have consecutive IPs and all the IPs must be available within that range.

- The range of IPs must not include the cluster nodes Management IPs but must be on the same subnet of your nodes.

- The default gateway defined for the Management IP pool must provide outbound connectivity to the internet.

- The DNS server or servers must ensure name resolution with Active Directory and the internet.

### Management VLAN ID

The recommendation for the Management subnet of your Azure HCI cluster is to use the default VLAN, which in most cases is declared as VLAN ID 0. However, if your network requirements are to use a specific VLAN for your infrastructure network, it must be configured on your physical network adapters that you plan to use for Management traffic (if you plan to use two physical network adapters for management, you need to set the VLAN on both adapters). This must be done as part of the bootstrap configuration of your nodes, before they are registered to Azure Arc, to ensure you successfully register the nodes using this VLAN. Once the VLAN ID is set and the IPs of your nodes are configured, the LCM orchestrator will read this VLAN ID value from the physical network adapter used for Management and will store it, so it can be used for the Azure Resource Bridge VM or any other infrastructure VM required during deployment. It is not possible to set the management VLAN ID during Cloud Deployment from the portal because that carries the risk of breaking the connectivity between the nodes and Azure if the physical switch VLANs routed properly.

### Management VLAN ID when a virtual switch is pre-created

In some scenarios, there is a requirement to pre-create a virtual switch before the deployment starts. If a virtual switch configuration is required and you must use a specific VLAN ID, you must use the following steps:

1. Create virtual switch with recommended naming convention. 
Azure Stack HCI 23H2 deployments relies on Network ATC to create and configure the virtual switches and virtual network adapters 
for management, compute and storage intents. By default, when Network ATC creates the virtual switch for the intents, it uses a 
specific name for the virtual switch. Although it is not required, we recommend naming your virtual switches with the same naming 
convention. The recommended name for the virtual switches is as follows: 
• Name of the virtual switch: “ConvergedSwitch($intentname)”
• Where $Intentname inside parenthesis can be any string defined by the user. This string should match the name on the virtual 
network adapter for management as described in the next step.
The example below explains how you can create the virtual switch using the recommended naming convention and with an intent 
name within parenthesis describing the purpose of the virtual switch. The list of network adapter names must be the list of physical 
network adapters that you plan to use for Management and Compute network traffic.

```powershell
$IntentName = "MgmtCompute"
New-VMSwitch -Name "ConvergedSwitch($IntentName)" -SwitchType External -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $false
```

1. Configure Management virtual network adapter using required Network ATC naming convention in all nodes Once the virtual switch is configured, the Management virtual network adapter needs to be created. The name of the virtual network adapter used for Management traffic must use the following naming convention:
- Name of the Network Adapter and the Virtual Network Adapter: “vManagement($intentname)”
- Where the name is case sensitive 
- Where $Intentname inside parenthesis can be any string defined by the user but must be the same used for the virtual switch.

To update the Management virtual network adapter name, use the following command:

```powershell
$IntentName = "MgmtCompute"
Add-VMNetworkAdapter -ManagementOS -SwitchName "ConvergedSwitch($IntentName)" -Name "vManagement($IntentName)"
#NetAdapter needs to be renamed because during creation, Hyper-V adds the string “vEthernet “ to the beginning of the name
Rename-NetAdapter -Name "vEthernet (vManagement($IntentName))" -NewName "vManagement($IntentName)"
```

1. Configure the VLAN ID to the Management virtual network adapter in all nodes. Once the virtual switch and the Management virtual network adapter are created, you can specify the required VLAN ID to this adapter. Although there are different options to assign a VLAN ID to a virtual network adapter, the only supported option is to use the `Set-VMNetworkAdapterIsolation` command. Once the required VLAN ID is configured, you can assign the IP address and Gateways to the Management virtual network adapter to validate that it has connectivity with other nodes, DNS, Active Directory, and Internet.

The following example shows how to configure the Management virtual network adapter to use VLAN ID 8 instead of native:

```powershell
Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID
```

1. Reference the physical network adapters for Management intent during Cloud Deployment

Although the newly created virtual network adapter will show listed as available network adapter when doing the deployment from 
Azure Portal, it is important to remember that the network configuration is based on Network ATC, and it means that when 
configuring the Management, or the Management & Compute intent, we still need to select the physical network adapters used for 
that intent. Do not select the virtual network adapter for the network intents. The same logic applies to the ARM (Azure Resource 
Manager) templates. You must specify the physical network adapters that you want to use for the intents and never the virtual network 
adapters.

Considerations:
- VLAN ID must be specified on the physical network adapter for management before registering the servers to Azure Arc.
- Use specific steps when a virtual switch is required before registering the servers to Azure Arc.
- The management VLAN ID is carried over from the host configuration to infrastructure VMs during deployment.
- There is no VLAN ID input parameter in the Azure Portal deployment flow nor in the ARM templates.

### Nodes and Cluster IP assignment

With the release of Azure Stack HCI 23H2 customers will have two options to assign the IPs to the nodes and the cluster IP. Static IPs or DHCP (Dynamic Host Configuration Protocol) are supported by the LCM orchestrator when deciding how the IPs will get assigned. Proper design of your nodes IP assignment is key for the cluster lifecycle management, and it is important to decide between the two options before you register the nodes in Azure Arc. Regardless of the selected option, infrastructure VMs and services such as Arc Resource Bridge and Network Controller will keep using static IPs from the Management IP pool. That implies that even if you decide to use DHCP to assign the IPs to your nodes and your cluster IP, the Management IP pool is still required.

#### Static IP assignment

If static IPs are used for the nodes, the LCM orchestrator will use the Management IP pool to get one available IP and assign it to the Cluster IP automatically during the deployment. It is important to use management IPs for the nodes that are not part of the IP range defined for the Management IP pool. However, the nodes IPs must be on the same subnet of the defined IP range.

It is recommended to assign only 1 management IP with default gateway and DNS servers configuration across all the physical network adapters of the node. This will ensure that this IP will not change once the management intent is created, and the nodes will keep their outbound connectivity during the entire deployment process, including Arc registration. To avoid routing issues and to identify which IP will be used for outbound connectivity and Arc registration, the Azure Portal validates if there is more than one default gateway configured.

This validation approach will change with upcoming updates, and we will rely on the first selected NIC for the management intent to define the management IP of the node during deployment.

If a virtual switch and a management virtual network adapter were created during the OS configuration, the management IP of the node must be assigned to that virtual network adapter.

#### DHCP IP assignment

If the IPs for the nodes are acquired from a DHCP server, the LCM Orchestrator will also use a DHCP address for the cluster IP. As explained earlier, infrastructure VMs and services will still require static IPs, and that implies that the Management IP pool address range must be excluded from the DHCP scope used for the nodes and the cluster IP. For example, if the Management IP range is defined as 192.168.1.20/24 to 192.168.1.30/24 for the infrastructure static IPs, the DHCP scope defined for subnet 192.168.1.0/24 must have an exclusion equivalent to the management IP pool to avoid IP conflicts with the infrastructure services. Additionally, although it is not mandatory, we also recommend using DHCP reservations for the nodes IPs.

The process of defining the Management IP after creating the management intent involves using the MAC address of the first physical network adapter that is selected for the intent. This MAC address is then assigned to the virtual network adapter that is created for management purposes. This means that the IP address that the first physical network adapter obtains from the DHCP server is the same IP address that the virtual network adapter will use as the Management IP. Therefore, it is important to create DHCP reservations for the nodes IP based on this logic.

#### IP considerations

- Nodes IPs must be on the same subnet of the defined management IP pool range regardless of if they are static or dynamic.

- The management IP pool must not include the nodes IPs. Use DHCP exclusions when dynamic IP assignment is used.

- It is recommended to use DHCP reservations for the nodes as much as possible.

- DHCP addresses are only supported for nodes and cluster IP. Infrastructure services will use static IPs from the management pool.

- MAC address from the first physical network adapter will be assigned to the management virtual network adapter once the management intent is created.

### Proxy requirements

In many cases, customers require the use of a proxy to access the internet within their on-premises infrastructure. In Azure Stack HCI 23H2 we provide support for non-authenticated proxy configurations. Given that internet access is required to register the nodes in Azure Arc, the proxy configuration must be set as part of the OS configuration before nodes registration. A full guidance on how to configure the proxy on your nodes is here: [Configure proxy settings](../manage/configure-proxy-settings.md).

Without going into the specifics on how to configure the proxy in your nodes (it is well covered on the article above), it is important to highlight that Azure Stack HCI OS has 3 different services (WinInet, WinHTTP and environment variables) that require the same proxy configuration to ensure all the OS components can access the internet. With HCI 23H2, these 3 proxy configuration takes special importance because we are also deploying the Arc Resource Bridge and AKS components, which have their own proxy configuration mechanism.

To alleviate the burden of configuring the proxy to the customers, the LCM orchestrator will read the environment variables proxy configuration from the nodes and will carry over the same proxy configuration to the Arc Resource Bridge VM and AKS, ensuring that they also have internet access during the deployment.

CONSIDERATIONS

- Proxy configuration must be done before registering the nodes in Azure Arc.

- Same proxy configuration must be applied for WinINET, WinHTTP and environment variables.

- Environment Checker will ensure that proxy configuration is consistent across the 3 proxy components.

- Arc Resource Bridge VM and AKS proxy configuration is automatically done by LCM orchestrator during deployment.

- Non-Authenticated proxy is supported.

### Firewall requirements

For the time being, and until the Arc Gateway is released, customers are required to open several internet endpoints in their firewalls to ensure the Azure Stack HCI and its components can successfully connect to them. A detailed list of the required endpoints is documented here [Firewall requirements](firewall-requirements.md). Firewall configuration must be done prior to registering the nodes in Azure Arc and customers can leverage the standalone version of the environment checker to validate that their firewalls are not blocking the traffic towards these required endpoints. Guidance on how to use the environment checker in standalone mode can be found here [Azure Stack HCI Environment Checker](../manage/use-environment-checker.md) to assess deployment readiness for Azure Stack HCI.

Considerations

- Firewall configuration must be done before registering the nodes in Azure Arc.

- Environment Checker in standalone mode can be used to validate the firewall configuration.

- Microsoft is actively working on the Arc Gateway to drastically reduce the number of endpoints required by HCI and its components.

## Step 5: Determine network adapter configuration

:::image type="content" source="media/cloud-network-considerations/step-5.png" alt-text="Diagram showing step 5 of the network desicion framework." lightbox="media/cloud-network-considerations/step-5.png":::

Network adapters are qualified by the network traffic types (Management, Compute and storage) they are supported for use with. As you review the [Windows Server Catalog](https://www.windowsservercatalog.com/), the Windows Server 2022 certification now indicates one or more of the following roles. Before purchasing a server for Azure Stack HCI, you must have at least one adapter that is qualified for management, compute, and storage as all three traffic types are required on Azure Stack HCI 23H2. As explained before, the new cloud deployment and the LCM orchestrator relies on Network ATC to configure the network adapters for the appropriate traffic types, so it is important to have supported network adapters.

This approach dramatically removes the burden of learning and configuring all the network adapters and cluster network options. The default values used by Network ATC are well documented in this article [Cluster network settings](../deploy/network-atc.md?tabs=22H2#cluster-network-settings) and in general Microsoft recommends leaving these default values unchanged. However, we acknowledge that each customer scenario is different, and the following options can be overridden by customers using the Azure Portal or ARM templates:

- Storage VLANs: Set this value to the required VLANs for storage.
- Jumbo Packets: Define the size of the jumbo packets.
- Network Direct: Set this value to false if you want to disable RDMA in your network adapters.
- Network Direct Technology: Set this value to RoCEv2 or iWarp.
- Traffic Priorities (DCB (Datacenter Bridging)): Set the priorities that fit your requirements. We discourage customers from changing these DCB default values unless it is strictly necessary. They are well proven and validated by customers and Microsoft over the last decade.

Considerations
- We recommend using the default configurations as much as possible.

- The physical switches must be configured according to the network adapters configuration. Reference here.

- Ensure that your network adapters are supported for Azure Stack HCI using the Windows Server Catalog.

- When leaving the defaults, Network ATC will automatically configure the storage network adapters IPs and VLANs. This is known as
Storage Auto IP. For the 3 nodes switchless scenario, Storage Auto IP is not supported and will be disabled, forcing customers to
declare each storage network adapter IP.



## Next steps

- 