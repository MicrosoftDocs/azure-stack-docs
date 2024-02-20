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

In this article, learn how to design and plan an Azure Stack HCI version 23H2 system network for cloud deployments. Before you continue, you should familarize yourself with the various [Azure Stack HCI networking patterns](../plan/choose-network-pattern.md) and options depending on your environment.

## Network design framework

The following diagram shows the various network design steps that define the arhitecture framework. Each design decision enables or permits the design options available in subsequent steps:

:::image type="content" source="media/cloud-network-considerations/network-decision-framework.png" alt-text="Diagram showing step 1 of the network desicion framework." lightbox="media/cloud-network-considerations/network-decision-framework.png":::

To help determine the size of your Azure Stack HCI system, use the [Azure Stack HCI sizer tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer), where you can define your profile such as number of virtual machines (VMs), size of the VMs, and the workload use, such as Azure Virtual Desktop, SQL Server, or AKS for example.

## Step 1: Determine cluster size

:::image type="content" source="media/cloud-network-considerations/step-1.png" alt-text="Diagram showing the network desicion framework." lightbox="media/cloud-network-considerations/step-1.png":::

As described in the Azure Stack HCI [system server requirements](system-requirements.md) article, the maximum number of servers supported on Azure Stack HCI system is 16. Once you have completed your workload capacity planning, you should have a good understanding of the number of server nodes required to run workloads on your infrastructure.

For example, if your workload requires four or more nodes, you will not be able to deploy and use a switchless configuration for the storage network traffic. That implies you will need to include a physical switch with support for Remote Direct Memory Access (RDMA) to handle storage traffic. For more information on Azure Stack HCI cluster network architecture, see [Network reference patterns overview](../plan/network-patterns-overview.md).

However, if your workload requires three or less nodes, you will be able to decide which storage connectivity option you would like to use. However, if you plan to scale out later, switchless deployments won't support orchestrated scale out operations using the Lifecycle Manager orchestrator. Any scale out operation in your switchless deployments will require manual configuration of your network cabling between the nodes that Microsoft is not actively validating as part of its software development cycle for Azure Stack HCI.

Switchless configuration with Lifecycle Manager deployment and orchestration support is only available for systems with three or less server nodes. Clusters with four or more nodes require a physical switch for the storage network traffic. In this case, the Azure portal deployment flow will filter these options for you. In addition, ARM deployments only support the validated architecture described here.

In summary, if you scale out your cluster using Lifecycle Manager orchestration, you need to use a physical switch for the storage network traffic.

## Step 2: Determine cluster storage connectivity

:::image type="content" source="media/cloud-network-considerations/step-2.png" alt-text="Diagram showing step 2 of the network desicion framework." lightbox="media/cloud-network-considerations/step-2.png":::

As described in [Physical network requirements](physical-network-requirements.md), Azure Stack HCI supports two types of connectivity for storage network traffic. The first option is to use a physical network switch to handle the traffic, and the second option is to directly connect the nodes between them with cross-over network or fiber cables for the storage traffic. The advantages and disadvantages of each option are documented in the article linked above.

As stated previously, you will only be able to decide between the two options when the size of your cluster is three or less nodes. Any cluster with four or more nodes will automatically be deployed using a network switch for storage. If clusters with less than three nodes, the storage connectivity decision will influence the number and type of network intents you will be able to define in the next step.

For example, for switchless configurations, you will need to define two network traffic intents. Storage traffic for east-west communications using the cross-over cables will not have north-south connectivity and it will be completely isolated from the rest of your network infrastructure. That means you will need to define a second network intent for management outbound connectivity and for your compute workloads.

Although it is possible to define each network intent with only one physical network adapter port each, that will not provide any fault tolerance. As such, we always recommend using at least two physical network ports for each network intent. If you decide to use a network switch for storage, you can group all network traffic including storage in a single network intent, which is also known as a hyperconverged or fully converged host network configuration.

The following diagram summarizes the options for this step:

:::image type="content" source="media/cloud-network-considerations/step-2-summary.png" alt-text="Diagram showing step 2 option summary for the network desicion framework." lightbox="media/cloud-network-considerations/step-2-summary.png":::

### Using switchless

Switchless configuration with lifecycle manager deployment and orchestration support is only available for clusters with three or fewer nodes. Scale in and scale out operations are not supported using lifecycle manager orchestration.

Any change in the number of nodes post-deployment will require a manual configuration. At least two network intents are required when using a switchless configuration for storage.

### Using a switch

If you scale out your cluster using lifecycle manager orchestration, you need to use a physical switch for storage network traffic. You can use this architecture with any number of nodes between one to 16. Although this is not recommended, you can use a single intent for all your network traffic types (Management, Compute, and Storage).

## Step 3: Determine network traffic intents

:::image type="content" source="media/cloud-network-considerations/step-3.png" alt-text="Diagram showing step 3 of the network desicion framework." lightbox="media/cloud-network-considerations/step-3.png":::

For Azure Stack HCI version 23H2, all deployments rely on Network ATC for the host network configuration. For more information, see [Deploy host networking with Network ATC](../deploy/network-atc.md).

This section explains what the implications of your design decision for network traffic intents are, and how it influences the next step of the framework. For clout deployments, you are able to select between four options to group your network traffic into one or more intents. As explained in the previous section, the options available depend on the size of your cluster and the storage connectivity type.

The following table explains each of the network traffic intent options available:

| Network intents | Description | Design decision considerations |
| -- | -- | -- |
| Group all traffic |When selecting this option, Network ATC will configure a unique intent that will include management, compute and storge network traffic configuration. The network adapters assigned to this intent will share the bandwidth and throughput for all the network traffic. | - This option requires a physical switch for storage traffic. If you require switchless architecture, you cannot use this type of intent. The portal will automatically filter out this option if you select no switch for storage connectivity.<br>- This option requires physical switch configuration for RDMA.<br>- At least 2 network adapter ports are recommended to ensure HA (High Availability). |
| Group management and compute traffic | When selecting this option, Network ATC will configure two intents. The first intent will include Management and Compute network traffic, and the second intent will only include storage network traffic. Each intent must have a different set of network adapter ports. |You can use this option with both switched and switchless storage connectivity.<br>- At least 2 network adapter ports for each intent recommended to ensure HA.<br>- This option requires physical switch configuration for RDMA if you use network switch for storage |
| Group compute and storage traffic | When selecting this option, Network ATC will configure two intents. The first intent will include Compute and Storage network traffic, and the second intent will only include Management network traffic. Each intent must have a different set of network adapter ports. This option is considered a rare configuration used on PMEC (private multiaccess edge compute) scenarios, where management traffic must be fully isolated.| This option requires a physical switch for storage traffic because the same ports are shared with compute traffic that will require north-south communication. If you require switchless architecture, you cannot use this type of intent. The portal will automatically filter out this option if you select no switch for storage connectivity.<br>- This option requires physical switch configuration for RDMA.<br>- At least 2 network adapter ports are recommended to ensure HA.<br>- Even when Management intent is declared without compute, Network ATC will create a SET virtual switch to provide HA to the management network. |
|Custom configuration  |When selecting this option, you will be able to define up to three intents with your own configuration as long as at least one of the intents includes Management traffic. It is recommended to use this option when you need a second compute intent. Scenarios for this second compute intent requirement can be remote storage traffic, VMs backup traffic or simply a separate compute intent for distinct types of workloads | You can use this option with both switched and switchless storage connectivity if the storage intent is different from the other intents.<br>- You can use this option when additional compute intent is required or when you want to fully separate the distinct types of traffic over different network adapters.<br>- At least 2 network adapter ports for each intent recommended to ensure HA.|

:::image type="content" source="media/cloud-network-considerations/step-3-summary.png" alt-text="Diagram showing step 3 option summary for the network desicion framework." lightbox="media/cloud-network-considerations/step-3-summary.png":::

## Step 4: Determine management network connectivity

:::image type="content" source="media/cloud-network-considerations/step-4.png" alt-text="Diagram showing step 4 of the network desicion framework." lightbox="media/cloud-network-considerations/step-4.png":::

You next define your infrastructure subnet address space, how these addresses are assigned to your cluster, and if there is any proxy requirement for the nodes for outbound connectivity to the internet and other intranet services such as Domain Name System (DNS) or Active Directory Services.

The following infrastructure subnet components must be planned and defined before you start deployment of the cluster so you can anticipate any routing, firewalling, or subnet future requirements.

### Network adapter drivers

Once you installed the operating system, and before configuring networking on your nodes, you must ensure that your network adapters have the latest driver provided by your OEM or NIC vendor. Important capabilities of the network adapters might not surface when using the default Microsoft drivers.

### Management IP pool

When doing initial deployment of your Azure Stack HCI system, you must define an IP range of consecutive IPs for infrastructure services deployed by default. To ensure the range has enough IPs for current and future infrastructure services, we enforce defining a range of at least six consecutive available IP addresses. These addresses are used for the cluster IP, the Azure Resource Bridge VM and its components, the upcoming Network Controller Cluster Service IP, and the VM update role. If you anticipate running additional services in the infrastructure network, we recommend assigning an extra buffer of infrastructure IPs to the pool. It is possible to add additional IP pools after deployment for the infrastructure network using PowerShell if the size of the pool you planned originally gets exhausted.

The following conditions must be true when defining your IP pool for the infrastructure subnet during deployment:

- The IP range must use consecutive IPs and all IPs must be available within that range.

- The range of IPs must not include the cluster node management IPs but must be on the same subnet of your nodes.

- The default gateway defined for the management IP pool must provide outbound connectivity to the internet.

- The DNS server(s) must ensure name resolution with Active Directory and the internet.

### Management VLAN ID

We recommend the management subnet of your Azure HCI cluster use the default VLAN, which in most cases is declared as VLAN ID 0. However, if your network requirements are to use a specific VLAN for your infrastructure network, it must be configured on your physical network adapters that you plan to use for management traffic. If you plan to use two physical network adapters for management, you need to set the VLAN on both adapters. This must be done as part of the bootstrap configuration of your servers, and before they are registered to Azure Arc, to ensure you successfully register the nodes using this VLAN. Once the VLAN ID is set and the IPs of your nodes are configured, the lifecycle orchestrator will read this VLAN ID value from the physical network adapter used for management and will store it, so it can be used for the Azure Resource Bridge VM or other infrastructure VM required during deployment. It is not possible to set the management VLAN ID during cloud deployment from Azure portal as this carries the risk of breaking the connectivity between the nodes and Azure if the physical switch VLANs are not routed properly.

### Management VLAN ID when a virtual switch is pre-created

In some scenarios, there is a requirement to create a virtual switch before deployment starts. If a virtual switch configuration is required and you must use a specific VLAN ID, follow these steps:

1. **Create virtual switch with recommended naming convention.**
Azure Stack HCI 23H2 deployments relies on Network ATC to create and configure the virtual switches and virtual network adapters for management, compute and storage intents. By default, when Network ATC creates the virtual switch for the intents, it uses a specific name for the virtual switch. Although it is not required, we recommend naming your virtual switches with the same naming convention. The recommended name for the virtual switches is as follows:

Name of the virtual switch: "`ConvergedSwitch($IntentName)`",
Where `$IntentName` can be any string. This string should match the name of the virtual network adapter for management as described in the next step.

The example below shows how to create the virtual switch with PowerShell using the recommended naming convention with `$IntentName` describing the purpose of the virtual switch. The list of network adapter names is a list of the physical network adapters you plan to use for management and compute network traffic.

```powershell
$IntentName = "MgmtCompute"
New-VMSwitch -Name "ConvergedSwitch($IntentName)" -SwitchType External -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $false
```

1. Configure the management virtual network adapter using required Network ATC naming convention for all nodes. Once the virtual switch is configured, the management virtual network adapter needs to be created. The name of the virtual network adapter used for Management traffic must use the following naming convention:
    - Name of the network adapter and the virtual network adapter: `vManagement($intentname)`
    - Name is case sensitive
    - `$Intentname` can be any string, but must be the same name used for the virtual switch.

To update the management virtual network adapter name, use the following command:

```powershell
$IntentName = "MgmtCompute"
Add-VMNetworkAdapter -ManagementOS -SwitchName "ConvergedSwitch($IntentName)" -Name "vManagement($IntentName)"
#NetAdapter needs to be renamed because during creation, Hyper-V adds the string “vEthernet “ to the beginning of the name
Rename-NetAdapter -Name "vEthernet (vManagement($IntentName))" -NewName "vManagement($IntentName)"
```

1. **Configure the VLAN ID to the management virtual network adapter for all nodes.** Once the virtual switch and the management virtual network adapter are created, you can specify the required VLAN ID for this adapter. Although there are different options to assign a VLAN ID to a virtual network adapter, the only supported option is to use the `Set-VMNetworkAdapterIsolation` command. Once the required VLAN ID is configured, you can assign the IP address and gateways to the management virtual network adapter to validate that it has connectivity with other nodes, DNS, Active Directory, and the internet.

The following example shows how to configure the management virtual network adapter to use VLAN ID 8 instead of native:

```powershell
Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID
```

1. **Reference the physical network adapters for the management intent during cloud deployment**. Although the newly created virtual network adapter will show as being available when deploying via Azure portal, it is important to remember that the network configuration is based on Network ATC, and this means that when configuring the management, or the management and compute intent, we still need to select the physical network adapters used for that intent. Do not select the virtual network adapter for the network intent. The same logic applies to the Azure Resource Manager (ARM) templates. You must specify the physical network adapters that you want to use for the network intents and never the virtual network adapters.

Here are some considerations:

- VLAN ID must be specified on the physical network adapter for management before registering the servers to Azure Arc.
- Use specific steps when a virtual switch is required before registering the servers to Azure Arc.
- The management VLAN ID is carried over from the host configuration to the infrastructure VMs during deployment.
- There is no VLAN ID input parameter for Azure portal deployment or for ARM template deployment

### Nodes and cluster IP assignment

With the release of Azure Stack HCI version 23H2, you have two options for assigning IPs for the server nodes and for the cluster IP. Static and Dynamic Host Configuration Protocol (DHCP) protocols are supported by the lifecycle orchestrator when deciding how the IPs get assigned. Proper node IP assignment is key for cluster lifecycle management, and it is important to decide between the two options before you register the nodes in Azure Arc. 

Regardless of the selected option, infrastructure VMs and services such as Arc Resource Bridge and Network Controller will keep using static IPs from the management IP pool. That implies that even if you decide to use DHCP to assign the IPs to your nodes and your cluster IP, the management IP pool is still required.

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