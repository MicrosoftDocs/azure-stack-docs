---
title: Network considerations for Azure Stack HCI cloud deployment
description: This topic introduces network considerations for Azure Stack HCI cloud deployments.
author: alkohli
ms.topic: conceptual
ms.date: 02/21/2024
ms.author: alkohli 
ms.reviewer: alkohli
---

# Network considerations for Azure Stack HCI cloud deployment

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

In this article, learn how to design and plan an Azure Stack HCI version 23H2 system network for cloud deployment. Before you continue, familarize yourself with the various [Azure Stack HCI networking patterns](../plan/choose-network-pattern.md) and configurations available.

## Network design framework

The following diagram shows the various decisions and steps that define the network design framework. Each design decision enables or permits the design options available in subsequent steps:

:::image type="content" source="media/cloud-deployment-network-considerations/network-decision-framework.png" alt-text="Diagram showing step 1 of the network desicion framework." lightbox="media/cloud-deployment-network-considerations/network-decision-framework.png":::

## Step 1: Determine cluster size

:::image type="content" source="media/cloud-deployment-network-considerations/step-1.png" alt-text="Diagram showing the network desicion framework." lightbox="media/cloud-deployment-network-considerations/step-1.png":::

To help determine the size of your Azure Stack HCI system, use the [Azure Stack HCI sizer tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer), where you can define your profile such as number of virtual machines (VMs), size of the VMs, and the workload use, such as Azure Virtual Desktop, SQL Server, or AKS for example.

As described in the Azure Stack HCI [system server requirements](system-requirements.md) article, the maximum number of servers supported on Azure Stack HCI system is 16. Once you have completed your workload capacity planning, you should have a good understanding of the number of server nodes required to run workloads on your infrastructure.

If your workloads require four or more nodes, you will not be able to deploy and use a switchless configuration for storage network traffic. You need to include a physical switch with support for Remote Direct Memory Access (RDMA) to handle storage traffic. For more information on Azure Stack HCI cluster network architecture, see [Network reference patterns overview](../plan/network-patterns-overview.md).

If your workloads require three or less nodes, you can choose either switchless or switched configurations for storage connectivity. However, if you plan to scale out later to more than three nodes, you need to use a physical switch for storage network traffic. Any scale out operation for switchless deployments require manual configuration of your network cabling between the nodes that Microsoft is not actively validating as part of its software development cycle for Azure Stack HCI.

Deployments via Azure portal will select these options for you. Deployments via ARM templates only support the validated architecture described here.

## Step 2: Determine cluster storage connectivity

:::image type="content" source="media/cloud-deployment-network-considerations/step-2.png" alt-text="Diagram showing step 2 of the network desicion framework." lightbox="media/cloud-deployment-network-considerations/step-2.png":::

As described in [Physical network requirements](physical-network-requirements.md), Azure Stack HCI supports two types of connectivity for storage network traffic. The first option is to use a physical network switch to handle the traffic, and the second option is to directly connect the nodes between them with cross-over network or fiber cables for the storage traffic. The advantages and disadvantages of each option are documented in the article linked above.

As stated previously, you will only be able to decide between the two options when the size of your cluster is three or less nodes. Any cluster with four or more nodes will automatically be deployed using a network switch for storage. If clusters with less than three nodes, the storage connectivity decision will influence the number and type of network intents you will be able to define in the next step.

For example, for switchless configurations, you will need to define two network traffic intents. Storage traffic for east-west communications using the cross-over cables will not have north-south connectivity and it will be completely isolated from the rest of your network infrastructure. That means you will need to define a second network intent for management outbound connectivity and for your compute workloads. 

Although it is possible to define each network intent with only one physical network adapter port each, that will not provide any fault tolerance. As such, we always recommend using at least two physical network ports for each network intent. If you decide to use a network switch for storage, you can group all network traffic including storage in a single network intent, which is also known as a hyperconverged or fully converged host network configuration.

The following diagram summarizes storage connectivity options available to you for various deployments:

:::image type="content" source="media/cloud-deployment-network-considerations/step-2-summary.png" alt-text="Diagram showing step 2 option summary for the network desicion framework." lightbox="media/cloud-deployment-network-considerations/step-2-summary.png":::

## Step 3: Determine network traffic intents

:::image type="content" source="media/cloud-deployment-network-considerations/step-3.png" alt-text="Diagram showing step 3 of the network desicion framework." lightbox="media/cloud-deployment-network-considerations/step-3.png":::

> [!NOTE]
> Although not recommended, you can use a single intent for all your network traffic types (management, compute, and storage).

For Azure Stack HCI version 23H2, all deployments rely on Network ATC for the host network configuration. For more information, see [Deploy host networking with Network ATC](../deploy/network-atc.md).

This section explains the implications of your design decision for network traffic intents, and how they influence the next step of the framework. For cloud deployments, you can select between four options to group your network traffic into one or more intents. The options available depend on the number of nodes in your cluster and the storage connectivity type used.

The following network intent options are available:

**Group all traffic**. Network ATC will configure a unique intent that includes management, compute, and storge network traffic. The network adapters assigned to this intent share bandwidth and throughput for all network traffic.

This option requires a physical switch for storage traffic. If you require a switchless architecture, you can't use this type of intent. Azure portal automatically filters out this option if you select a switchless configuration for storage connectivity.

At least two network adapter ports are recommended to ensure High Availability.

**Group management and compute traffic.** Network ATC configures two intents. The first intent includes management and compute network traffic, and the second intent includes only storage network traffic. Each intent must have a different set of network adapter ports.

You can use this option for both switched and switchless storage connectivity, provided that:

- At least two network adapter ports are available for each intent to ensure high availability.

- A physical switch is used for RDMA if you use the network switch for storage.

**Group compute and storage traffic.**  Network ATC configures two intents. The first intent include compute and storage network traffic, and the second intent includes only management network traffic. Each intent must use a different set of network adapter ports. This option is used for private multi-access edge compute (PMEC) scenarios where management traffic must be fully isolated.

This option requires a physical switch for storage traffic as the same ports are shared with compute traffic, which require north-south communication. If you require a switchless configuration, you can't use this type of intent. Azure portal automatically filters out this option if you select a switchless configuration for storage connectivity.

- This option requires a physical switch for RDMA.

- At least two network adapter ports are recommended to ensure high availability.

- Even when the management intent is declared without a compute intent, Network ATC creates a SET virtual switch to provide high availability to the management network.

**Custom configuration.**  Define up to three intents using your own configuration as long as at least one of the intents includes management traffic. It is recommended to use this option when you need a second compute intent. Scenarios for this second compute intent requirement include remote storage traffic, VMs backup traffic, or a separate compute intent for distinct types of workloads.

Use this option for both switched and switchless storage connectivity if the storage intent is different from the other intents.

- Use this option when an additional compute intent is required or when you want to fully separate the distinct types of traffic over different network adapters.

- Use at least two network adapter ports for each intent to ensure high availability.

The following diagram summarizes network intent options available to you for various deployments:

:::image type="content" source="media/cloud-deployment-network-considerations/step-3-summary.png" alt-text="Diagram showing step 3 option summary for the network desicion framework." lightbox="media/cloud-deployment-network-considerations/step-3-summary.png":::

## Step 4: Determine management network connectivity

:::image type="content" source="media/cloud-deployment-network-considerations/step-4.png" alt-text="Diagram showing step 4 of the network desicion framework." lightbox="media/cloud-deployment-network-considerations/step-4.png":::

In this step, you define the infrastructure subnet address space, how these addresses are assigned to your cluster, and if there is any proxy requirement for the nodes for outbound connectivity to the internet and other intranet services such as Domain Name System (DNS) or Active Directory Services.

The following infrastructure subnet components must be planned and defined before you start deployment so you can anticipate any routing, firewall, or subnet requirements.

### Network adapter drivers

Once you install the operating system, and before configuring networking on your nodes, you must ensure that your network adapters have the latest driver provided by your OEM or NIC vendor. Important capabilities of the network adapters might not surface when using the default Microsoft drivers.

### Management IP pool

When doing initial deployment of your Azure Stack HCI system, you must define an IP range of consecutive IPs for infrastructure services deployed by default. To ensure the range has enough IPs for current and future infrastructure services, you must use a range of at least six consecutive available IP addresses. These addresses are used for the cluster IP, the Azure Resource Bridge VM and its components, the upcoming Network Controller Cluster Service IP, and the VM update role. If you anticipate running additional services in the infrastructure network, we recommend assigning an extra buffer of infrastructure IPs to the pool. It is possible to add additional IP pools after deployment for the infrastructure network using PowerShell if the size of the pool you planned originally gets exhausted.

The following conditions must be met when defining your IP pool for the infrastructure subnet during deployment:

- The IP range must use consecutive IPs and all IPs must be available within that range.

- The range of IPs must not include the cluster node management IPs but must be on the same subnet of your nodes.

- The default gateway defined for the management IP pool must provide outbound connectivity to the internet.

- The DNS server(s) must ensure name resolution with Active Directory and the internet.

### Management VLAN ID

We recommend the management subnet of your Azure HCI cluster use the default VLAN, which in most cases is declared as VLAN ID 0. However, if your network requirements are to use a specific VLAN for your infrastructure network, it must be configured on your physical network adapters that you plan to use for management traffic. If you plan to use two physical network adapters for management, you need to set the VLAN on both adapters. This must be done as part of the bootstrap configuration of your servers, and before they are registered to Azure Arc, to ensure you successfully register the nodes using this VLAN.

Once the VLAN ID is set and the IPs of your nodes are configured, the VLAN ID is stored for use with the Azure Resource Bridge VM and other infrastructure VMs required during deployment. It is not possible to set the management VLAN ID during cloud deployment from Azure portal as this carries the risk of breaking the connectivity between the nodes and Azure if the physical switch VLANs are not routed properly.

### Management VLAN ID with a virtual switch

In some scenarios, there is a requirement to create a virtual switch before deployment starts. If a virtual switch configuration is required and you must use a specific VLAN ID, follow these steps:

**1. Create virtual switch with recommended naming convention.**
Azure Stack HCI 23H2 deployments relies on Network ATC to create and configure the virtual switches and virtual network adapters for management, compute and storage intents. By default, when Network ATC creates the virtual switch for the intents, it uses a specific name for the virtual switch. Although it is not required, we recommend naming your virtual switches with the same naming convention. The recommended name for the virtual switches is as follows:

Name of the virtual switch: "`ConvergedSwitch($IntentName)`",
Where `$IntentName` can be any string. This string should match the name of the virtual network adapter for management as described in the next step.

The example below shows how to create the virtual switch with PowerShell using the recommended naming convention with `$IntentName` describing the purpose of the virtual switch. The list of network adapter names is a list of the physical network adapters you plan to use for management and compute network traffic:

```powershell
$IntentName = "MgmtCompute"
New-VMSwitch -Name "ConvergedSwitch($IntentName)" -SwitchType External -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $false
```

**2. Configure the management virtual network adapter using required Network ATC naming convention for all nodes**. Once the virtual switch is configured, the management virtual network adapter needs to be created. The name of the virtual network adapter used for Management traffic must use the following naming convention:
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

**3. Configure the VLAN ID to the management virtual network adapter for all nodes.** Once the virtual switch and the management virtual network adapter are created, you can specify the required VLAN ID for this adapter. Although there are different options to assign a VLAN ID to a virtual network adapter, the only supported option is to use the `Set-VMNetworkAdapterIsolation` command. Once the required VLAN ID is configured, you can assign the IP address and gateways to the management virtual network adapter to validate that it has connectivity with other nodes, DNS, Active Directory, and the internet.

The following example shows how to configure the management virtual network adapter to use VLAN ID 8 instead of the default:

```powershell
Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID
```

**4. Reference the physical network adapters for the management intent during deployment**. Although the newly created virtual network adapter will show as being available when deploying via Azure portal, it is important to remember that the network configuration is based on Network ATC, and this means that when configuring the management, or the management and compute intent, we still need to select the physical network adapters used for that intent. Do not select the virtual network adapter for the network intent. The same logic applies to the Azure Resource Manager (ARM) templates. You must specify the physical network adapters that you want to use for the network intents and never the virtual network adapters.

Here are some considerations for the VLAN ID:

- VLAN ID must be specified on the physical network adapter for management before registering the servers with Azure Arc.
- Use specific steps when a virtual switch is required before registering the servers to Azure Arc.
- The management VLAN ID is carried over from the host configuration to the infrastructure VMs during deployment.
- There is no VLAN ID input parameter for Azure portal deployment or for ARM template deployment.

### Node and cluster IP assignment

With the release of Azure Stack HCI version 23H2, you have two options for assigning IPs for the server nodes and for the cluster IP. Static and Dynamic Host Configuration Protocol (DHCP) protocols are supported. Proper node IP assignment is key for cluster lifecycle management, and it is important to decide between the two options before you register the nodes in Azure Arc.

#### IP considerations

Some considerations to keep in mind for IP addresses:

- Infrastructure VMs and services such as Arc Resource Bridge and Network Controller use static IPs from the management IP pool. If you decide to use DHCP to assign the IPs to your nodes and cluster, the management IP pool is still required.

- Nodes IPs must be on the same subnet of the defined management IP pool range regardless if they are static or dynamic addresses.

- The management IP pool must not include node IPs. Use DHCP exclusions when dynamic IP assignment is used.

- Use DHCP reservations for the nodes as much as possible.

- DHCP addresses are only supported for node IPs and the cluster IP. Infrastructure services use static IPs from the management pool.

- The MAC address from the first physical network adapter is assigned to the management virtual network adapter once the management network intent is created.

#### Static IP assignment

If static IPs are used for the nodes, the management IP pool is used to obtain an available IP and assign it to the cluster IP automatically during deployment.

It is important to use management IPs for the nodes that are not part of the IP range defined for the management IP pool. Server node IPs must be on the same subnet of the defined IP range.

It is recommended to assign only one management IP for the default gateway and DNS servers configured for all the physical network adapters of the node. This will ensure that the IP will not change once the management network intent is created, and that nodes will keep their outbound connectivity during the deployment process, including during Azure Arc registration.

To avoid routing issues and to identify which IP will be used for outbound connectivity and Arc registration, Azure Portal validates if there is more than one default gateway configured. This validation approach will change with upcoming updates.

If a virtual switch and a management virtual network adapter were created during the OS configuration, the management IP for the node must be assigned to that virtual network adapter.

#### DHCP IP assignment

If IPs for the nodes are acquired from a DHCP server, a dynamic IP is also used for the cluster IP. Infrastructure VMs and services still require static IPs, and that implies that the management IP pool address range must be excluded from the DHCP scope used for the nodes and the cluster IP. 

For example, if the management IP range is defined as 192.168.1.20/24 to 192.168.1.30/24 for the infrastructure static IPs, the DHCP scope defined for subnet 192.168.1.0/24 must have an exclusion equivalent to the management IP pool to avoid IP conflicts with the infrastructure services. Additionally, although it is not mandatory, we also recommend using DHCP reservations for node IPs.

The process of defining the management IP after creating the management intent involves using the MAC address of the first physical network adapter that is selected for the network intent. This MAC address is then assigned to the virtual network adapter that is created for management purposes. This means that the IP address that the first physical network adapter obtains from the DHCP server is the same IP address that the virtual network adapter will use as the management IP. Therefore, it is important to create DHCP reservations for node IP based on this logic.

### Proxy requirements

A proxy is most likely required to access the internet within your on-premises infrastructure. In Azure Stack HCI version, support is provided for non-authenticated proxy configurations. Given that internet access is required to register the nodes in Azure Arc, the proxy configuration must be set as part of the OS configuration before server nodes are registered. For more information, see [Configure proxy settings](../manage/configure-proxy-settings.md).

The Azure Stack HCI OS has three different services (WinInet, WinHTTP, and environment variables) that require the same proxy configuration to ensure all OS components can access the internet. With version 23H2, proxy configuration takes special importance because of Arc Resource Bridge and AKS component deployment, which have their own proxy configuration.

The same proxy configuration used for the nodes is automatically carried over to the Arc Resource Bridge VM and AKS, ensuring that they have internet access during deployment.

Some things to keep in mind:

- Proxy configuration must be completed before registering the nodes in Azure Arc.

- The same proxy configuration must be applied for WinINET, WinHTTP, and environment variables.

- The Environment Checker ensures that proxy configuration is consistent across all proxy components.

- Arc Resource Bridge VM and AKS proxy configuration is automatically done by lifecycle management orchestrator during deployment.

- Non-authenticated proxy is supported.

### Firewall requirements

You are currently required to open several internet endpoints in your firewalls to ensure that Azure Stack HCI and its components can successfully connect to them. For a detailed list of the required endpoints, see [Firewall requirements](firewall-requirements.md). Firewall configuration must be done prior to registering the nodes in Azure Arc. You can use the standalone version of the environment checker to validate that your firewalls are not blocking traffic sent to these endpoints. For more information, see [Azure Stack HCI Environment Checker](../manage/use-environment-checker.md) to assess deployment readiness for Azure Stack HCI.

Some things to keep in mind:

- Firewall configuration must be done before registering the nodes in Azure Arc.

- Environment Checker in standalone mode can be used to validate the firewall configuration.

## Step 5: Determine network adapter configuration

:::image type="content" source="media/cloud-deployment-network-considerations/step-5.png" alt-text="Diagram showing step 5 of the network desicion framework." lightbox="media/cloud-deployment-network-considerations/step-5.png":::

Network adapters are qualified by network traffic type (management, compute, and storage) they are used with. As you review the [Windows Server Catalog](https://www.windowsservercatalog.com/), the Windows Server 2022 certification indicates one or more of the following roles. Before purchasing a server for Azure Stack HCI, you must have at least one adapter that is qualified for management, compute, and storage as all three traffic types are required on Azure Stack HCI version 23H2. Cloud deployment relies on Network ATC to configure the network adapters for the appropriate traffic types, so it is important to use supported network adapters.

The default values used by Network ATC are documented in [Cluster network settings](../deploy/network-atc.md?tabs=22H2#cluster-network-settings). It is recommended to use the default values. With that said, the following options can be overridden using Azure Portal or ARM templates if needed:

- **Storage VLANs**: Set this value to the required VLANs for storage.
- **Jumbo Packets**: Defines the size of the jumbo packets.
- **Network Direct**: Set this value to false if you want to disable RDMA for your network adapters.
- **Network Direct Technology**: Set this value to `RoCEv2` or `iWarp`.
- **Traffic Priorities Datacenter Bridging (DCB)**: Set the priorities that fit your requirements.

Some things to keep in mind:

- Use the default configurations as much as possible.

- Physical switches must be configured according to the network adapter configuration.

- Ensure that your network adapters are supported for Azure Stack HCI using the Windows Server Catalog.

- When leaving the defaults, Network ATC will automatically configure the storage network adapter IPs and VLANs. This is known as Storage Auto IP. However,for the three-node switchless pattern, Storage Auto IP is not supported and will be disabled, and you will need to declare each storage network adapter IP.


## Next steps

- [About Azure Stack HCI, version 23H2 deployment](../deploy/deployment-introduction.md).