---
title: Network considerations for cloud deployment for Azure Stack HCI, version 23H2
description: This article introduces network considerations for cloud deployments of Azure Stack HCI, version 23H2.
author: alkohli
ms.topic: conceptual
ms.date: 05/29/2024
ms.author: alkohli 
ms.reviewer: alkohli
---

# Network considerations for cloud deployments of Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article discusses how to design and plan an Azure Stack HCI, version 23H2 system network for cloud deployment. Before you continue, familiarize yourself with the various [Azure Stack HCI networking patterns](../plan/choose-network-pattern.md) and available configurations.

## Network design framework

The following diagram shows the various decisions and steps that define the network design framework for your Azure Stack HCI system - cluster size, cluster storage connectivity, network traffic intents, management connectivity, and network adapter configuration. Each design decision enables or permits the design options available in subsequent steps:

:::image type="content" source="media/cloud-deployment-network-considerations/network-decision-framework.png" alt-text="Diagram showing step 1 of the network decision framework." lightbox="media/cloud-deployment-network-considerations/network-decision-framework.png":::

## Step 1: Determine cluster size

:::image type="content" source="media/cloud-deployment-network-considerations/step-1.png" alt-text="Diagram showing the network decision framework." lightbox="media/cloud-deployment-network-considerations/step-1.png":::

To help determine the size of your Azure Stack HCI system, use the [Azure Stack HCI sizer tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer), where you can define your profile such as number of virtual machines (VMs), size of the VMs, and the workload use of the VMs such as Azure Virtual Desktop, SQL Server, or AKS.

As described in the Azure Stack HCI [system server requirements](../concepts/system-requirements-23h2.md#server-and-storage-requirements) article, the maximum number of servers supported on Azure Stack HCI system is 16. Once you complete your workload capacity planning, you should have a good understanding of the number of server nodes required to run workloads on your infrastructure.

- **If your workloads require four or more nodes**: You can't deploy and use a switchless configuration for storage network traffic. You need to include a physical switch with support for Remote Direct Memory Access (RDMA) to handle storage traffic. For more information on Azure Stack HCI cluster network architecture, see [Network reference patterns overview](./network-patterns-overview.md).

- **If your workloads require three or less nodes**: You can choose either switchless or switched configurations for storage connectivity.

- **If you plan to scale out later to more than three nodes**: You need to use a physical switch for storage network traffic. Any scale out operation for switchless deployments requires manual configuration of your network cabling between the nodes that Microsoft isn't actively validating as part of its software development cycle for Azure Stack HCI.

Here are the summarized considerations for the cluster size decision:


|Decision  |Consideration  |
|---------|---------|
|Cluster size (number of nodes per cluster)     |Switchless configuration via the Azure portal or Azure Resource Manager templates is only available for 1, 2, or 3 node clusters. <br><br>Clusters with 4 or more nodes require physical switch for the storage network traffic.         |
|Scale out requirements     |If you intend to scale out your cluster using the orchestrator, you need to use a physical switch for the storage network traffic.         |


## Step 2: Determine cluster storage connectivity

:::image type="content" source="media/cloud-deployment-network-considerations/step-2.png" alt-text="Diagram showing step 2 of the network decision framework." lightbox="media/cloud-deployment-network-considerations/step-2.png":::

As described in [Physical network requirements](../concepts/physical-network-requirements.md), Azure Stack HCI supports two types of connectivity for storage network traffic:

- Use a physical network switch to handle the traffic.
- Directly connect the nodes between them with crossover network or fiber cables for the storage traffic.

The advantages and disadvantages of each option are documented in the article linked above.

As stated previously, you can only decide between the two options when the size of your cluster is three or less nodes. Any cluster with four or more nodes is automatically deployed using a network switch for storage. 

If clusters have fewer than three nodes, the storage connectivity decision influences the number and type of network intents you can define in the next step.

For example, for switchless configurations, you need to define two network traffic intents. Storage traffic for east-west communications using the crossover cables doesn't have north-south connectivity and it is completely isolated from the rest of your network infrastructure. That means you need to define a second network intent for management outbound connectivity and for your compute workloads.

Although it is possible to define each network intent with only one physical network adapter port each, that doesn't provide any fault tolerance. As such, we always recommend using at least two physical network ports for each network intent. If you decide to use a network switch for storage, you can group all network traffic including storage in a single network intent, which is also known as a *hyperconverged* or *fully converged* host network configuration.

Here are the summarized considerations for the cluster storage connectivity decision:


|Decision  |Consideration  |
|---------|---------|
|No switch for storage     |Switchless configuration via Azure portal or Resource Manager template deployment is only supported for 1, 2 or 3 node clusters. <br><br>1 or 2 node storage switchless clusters can be deployed using the Azure portal or Resource Manager templates.<br><br>3 node storage switchless clusters can be deployed only using Resource Manager templates.<br><br>Scale out operations are not supported with the switchless deployments. Any change to the number of nodes after the deployment requires a manual configuration. <br><br>At least 2 network intents are required when using storage switchless configuration.        |
|Network switch for storage     |If you intend to scale out your cluster using the orchestrator, you need to use a physical switch for the storage network traffic. <br><br>You can use this architecture with any number of nodes between 1 to 16. <br><br>Although is not enforced, you can use a single intent for all your network traffic types (Management, Compute, and Storage)        |

The following diagram summarizes storage connectivity options available to you for various deployments:

:::image type="content" source="media/cloud-deployment-network-considerations/step-2-summary.png" alt-text="Diagram showing step 2 option summary for the network decision framework." lightbox="media/cloud-deployment-network-considerations/step-2-summary.png":::

## Step 3: Determine network traffic intents

:::image type="content" source="media/cloud-deployment-network-considerations/step-3.png" alt-text="Diagram showing step 3 of the network decision framework." lightbox="media/cloud-deployment-network-considerations/step-3.png":::


For Azure Stack HCI, all deployments rely on Network ATC for the host network configuration. The network intents are automatically configured when deploying Azure Stack HCI via the Azure portal. To understand more about the network intents and how to troubleshoot those, see [Common network ATC commands](../deploy/network-atc.md#common-network-atc-commands).

This section explains the implications of your design decision for network traffic intents, and how they influence the next step of the framework. For cloud deployments, you can select between four options to group your network traffic into one or more intents. The options available depend on the number of nodes in your cluster and the storage connectivity type used.

The available network intent options are discussed in the following sections.

### Network intent: Group all traffic

Network ATC configures a unique intent that includes management, compute, and storage network traffic. The network adapters assigned to this intent share bandwidth and throughput for all network traffic.

- This option requires a physical switch for storage traffic. If you require a switchless architecture, you can't use this type of intent. Azure portal automatically filters out this option if you select a switchless configuration for storage connectivity.

- At least two network adapter ports are recommended to ensure High Availability.

- At least 10 Gbps network interfaces are required to support RDMA traffic for storage.

### Network intent: Group management and compute traffic

Network ATC configures two intents. The first intent includes management and compute network traffic, and the second intent includes only storage network traffic. Each intent must have a different set of network adapter ports.

You can use this option for both switched and switchless storage connectivity, if:

- At least two network adapter ports are available for each intent to ensure high availability.

- A physical switch is used for RDMA if you use the network switch for storage.

- At least 10 Gbps network interfaces are required to support RDMA traffic for storage.

### Network intent: Group compute and storage traffic

Network ATC configures two intents. The first intent includes compute and storage network traffic, and the second intent includes only management network traffic. Each intent must use a different set of network adapter ports.

- This option requires a physical switch for storage traffic as the same ports are shared with compute traffic, which require north-south communication. If you require a switchless configuration, you can't use this type of intent. Azure portal automatically filters out this option if you select a switchless configuration for storage connectivity.

- This option requires a physical switch for RDMA.

- At least two network adapter ports are recommended to ensure high availability.

- At least 10 Gbps network interfaces are recommended for the compute and storage intent to support RDMA traffic.

- Even when the management intent is declared without a compute intent, Network ATC creates a Switch Embedded Teaming (SET) virtual switch to provide high availability to the management network.

### Network intent: Custom configuration

Define up to three intents using your own configuration as long as at least one of the intents includes management traffic. We recommend that you use this option when you need a second compute intent. Scenarios for this second compute intent requirement include remote storage traffic, VMs backup traffic, or a separate compute intent for distinct types of workloads.

- Use this option for both switched and switchless storage connectivity if the storage intent is different from the other intents.

- Use this option when another compute intent is required or when you want to fully separate the distinct types of traffic over different network adapters.

- Use at least two network adapter ports for each intent to ensure high availability.

- At least 10 Gbps network interfaces are recommended for the compute and storage intent to support RDMA traffic.

The following diagram summarizes network intent options available to you for various deployments:

:::image type="content" source="media/cloud-deployment-network-considerations/step-3-summary.png" alt-text="Diagram showing step 3 option summary for the network decision framework." lightbox="media/cloud-deployment-network-considerations/step-3-summary.png":::

## Step 4: Determine management network connectivity

:::image type="content" source="media/cloud-deployment-network-considerations/step-4.png" alt-text="Diagram showing step 4 of the network decision framework." lightbox="media/cloud-deployment-network-considerations/step-4.png":::

In this step, you define the infrastructure subnet address space, how these addresses are assigned to your cluster, and if there is any proxy or VLAN ID requirement for the nodes for outbound connectivity to the internet and other intranet services such as Domain Name System (DNS) or Active Directory Services.

The following infrastructure subnet components must be planned and defined before you start deployment so you can anticipate any routing, firewall, or subnet requirements.

### Network adapter drivers

Once you install the operating system, and before configuring networking on your nodes, you must ensure that your network adapters have the latest driver provided by your OEM or network interface vendor. Important capabilities of the network adapters might not surface when using the default Microsoft drivers.

### Management IP pool

When doing the initial deployment of your Azure Stack HCI system, you must define an IP range of consecutive IPs for infrastructure services deployed by default. 

To ensure the range has enough IPs for current and future infrastructure services, you must use a range of at least six consecutive available IP addresses. These addresses are used for - the cluster IP, the Azure Resource Bridge VM and its components. 

If you anticipate running other services in the infrastructure network, we recommend that you assign an extra buffer of infrastructure IPs to the pool. It is possible to add other IP pools after deployment for the infrastructure network using PowerShell if the size of the pool you planned originally gets exhausted.

The following conditions must be met when defining your IP pool for the infrastructure subnet during deployment:

|#  | Condition |
|---------|---------|
|1     | The IP range must use consecutive IPs and all IPs must be available within that range. This IP range can't be changed post deployment.       |
|2     | The range of IPs must not include the cluster node management IPs but must be on the same subnet as your nodes.        |
|3     | The default gateway defined for the management IP pool must provide outbound connectivity to the internet.        |
|4     | The DNS servers must ensure name resolution with Active Directory and the internet.        |
|5     | The management IPs require outbound internet access.        |

### Management VLAN ID

We recommend that the management subnet of your Azure HCI cluster use the default VLAN, which in most cases is declared as VLAN ID 0. However, if your network requirements are to use a specific management VLAN for your infrastructure network, it must be configured on your physical network adapters that you plan to use for management traffic.

If you plan to use two physical network adapters for management, you need to set the VLAN on both adapters. This must be done as part of the bootstrap configuration of your servers, and before they're registered to Azure Arc, to ensure you successfully register the nodes using this VLAN.

To set the VLAN ID on the physical network adapters, use the following PowerShell command:

This example configures VLAN ID 44 on physical network adapter `NIC1`.

```powershell
Set-NetAdapter -Name "NIC1" -VlanID 44
```

Once the VLAN ID is set and the IPs of your nodes are configured on the physical network adapters, the orchestrator reads this VLAN ID value from the physical network adapter used for management and stores it, so it can be used for the Azure Resource Bridge VM or any other infrastructure VM required during deployment. It isn't possible to set the management VLAN ID during cloud deployment from Azure portal as this carries the risk of breaking the connectivity between the nodes and Azure if the physical switch VLANs aren't routed properly.


### Management VLAN ID with a virtual switch

In some scenarios, there is a requirement to create a virtual switch before deployment starts. 

> [!NOTE]
> Before you create a virtual switch, make sure to enable the Hype-V role. For more information, see [Install required Windows role](../deploy/deployment-install-os.md).

If a virtual switch configuration is required and you must use a specific VLAN ID, follow these steps:

#### 1. Create virtual switch with recommended naming convention

Azure Stack HCI deployments rely on Network ATC to create and configure the virtual switches and virtual network adapters for management, compute, and storage intents. By default, when Network ATC creates the virtual switch for the intents, it uses a specific name for the virtual switch.

We recommend naming your virtual switch names with the same naming convention. The recommended name for the virtual switches is as follows:

"`ConvergedSwitch($IntentName)`",
where `$IntentName` must match the name of the intent typed into the portal during deployment. This string must also match the name of the virtual network adapter used for management as described in the next step.

The following example shows how to create the virtual switch with PowerShell using the recommended naming convention with `$IntentName`. The list of network adapter names is a list of the physical network adapters you plan to use for management and compute network traffic:

```powershell
$IntentName = "MgmtCompute"
New-VMSwitch -Name "ConvergedSwitch($IntentName)" -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $true
```

#### 2. Configure management virtual network adapter using required Network ATC naming convention for all nodes

Once the virtual switch and the associated management virtual network adapter are created, make sure that the network adapter name is compliant with Network ATC naming standards.

Specifically, the name of the virtual network adapter used for management traffic must use the following conventions:

- Name of the network adapter and the virtual network adapter must use `vManagement($intentname)`.
- This name is case-sensitive.
- `$Intentname` can be any string, but must be the same name used for the virtual switch. Make sure you use this same string in Azure portal when defining the `Mgmt` intent name.

To update the management virtual network adapter name, use the following commands:

```powershell
$IntentName = "MgmtCompute"

#Rename VMNetworkAdapter for management because during creation, Hyper-V uses the vSwitch name for the virtual network adapter.
Rename-VmNetworkAdapter -ManagementOS -Name "ConvergedSwitch(MgmtCompute)" -NewName "vManagement(MgmtCompute)"

#Rename NetAdapter because during creation, Hyper-V adds the string “vEthernet” to the beginning of the name.
Rename-NetAdapter -Name "vEthernet (ConvergedSwitch(MgmtCompute))" -NewName "vManagement(MgmtCompute)"

```

#### 3. Configure VLAN ID to management virtual network adapter for all nodes

Once the virtual switch and the management virtual network adapter are created, you can specify the required VLAN ID for this adapter. Although there are different options to assign a VLAN ID to a virtual network adapter, the only supported option is to use the `Set-VMNetworkAdapterIsolation` command.

Once the required VLAN ID is configured, you can assign the IP address and gateways to the management virtual network adapter to validate that it has connectivity with other nodes, DNS, Active Directory, and the internet.

The following example shows how to configure the management virtual network adapter to use VLAN ID `8` instead of the default:

```powershell
Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID "8"
```

#### 4. Reference physical network adapters for the management intent during deployment

Although the newly created virtual network adapter shows as available when deploying via Azure portal, it is important to remember that the network configuration is based on Network ATC. This means that when configuring the management, or the management and compute intent, we still need to select the physical network adapters used for that intent.

> [!NOTE]
> Do not select the virtual network adapter for the network intent.

The same logic applies to the Azure Resource Manager templates. You must specify the physical network adapters that you want to use for the network intents and never the virtual network adapters.

Here are the summarized considerations for the VLAN ID:

|#  | Considerations  |
|---------|---------|
|1    | VLAN ID must be specified on the physical network adapter for management before registering the servers with Azure Arc.         |
|2     | Use specific steps when a virtual switch is required before registering the servers to Azure Arc.         |
|3     | The management VLAN ID is carried over from the host configuration to the infrastructure VMs during deployment.        |
|4     | There is no VLAN ID input parameter for Azure portal deployment or for Resource Manager template deployment.        |

### Node and cluster IP assignment

For Azure Stack HCI system, you have two options to assign IPs for the server nodes and for the cluster IP. 

- Both the static and Dynamic Host Configuration Protocol (DHCP) protocols are supported.

- Proper node IP assignment is key for cluster lifecycle management. Decide between the static and DHCP options before you register the nodes in Azure Arc.

- Infrastructure VMs and services such as Arc Resource Bridge and Network Controller keep using static IPs from the management IP pool. That implies that even if you decide to use DHCP to assign the IPs to your nodes and your cluster IP, the management IP pool is still required.

The following sections discuss the implications of each option.

#### Static IP assignment

If static IPs are used for the nodes, the management IP pool is used to obtain an available IP and assign it to the cluster IP automatically during deployment.

It is important to use management IPs for the nodes that aren't part of the IP range defined for the management IP pool. Server node IPs must be on the same subnet of the defined IP range.

We recommend that you assign only one management IP for the default gateway and for the configured DNS servers for all the physical network adapters of the node. This ensures that the IP doesn't change once the management network intent is created. This also ensures that the nodes keep their outbound connectivity during the deployment process, including during the Azure Arc registration.

To avoid routing issues and to identify which IP will be used for outbound connectivity and Arc registration, Azure portal validates if there is more than one default gateway configured.

If a virtual switch and a management virtual network adapter were created during the OS configuration, the management IP for the node must be assigned to that virtual network adapter.

#### DHCP IP assignment

If IPs for the nodes are acquired from a DHCP server, a dynamic IP is also used for the cluster IP. Infrastructure VMs and services still require static IPs, and that implies that the management IP pool address range must be excluded from the DHCP scope used for the nodes and the cluster IP.

For example, if the management IP range is defined as 192.168.1.20/24 to 192.168.1.30/24 for the infrastructure static IPs, the DHCP scope defined for subnet 192.168.1.0/24 must have an exclusion equivalent to the management IP pool to avoid IP conflicts with the infrastructure services. We also recommend that you use DHCP reservations for node IPs.

The process of defining the management IP after creating the management intent involves using the MAC address of the first physical network adapter that is selected for the network intent. This MAC address is then assigned to the virtual network adapter that is created for management purposes. This means that the IP address that the first physical network adapter obtains from the DHCP server is the same IP address that the virtual network adapter uses as the management IP. Therefore, it is important to create DHCP reservation for node IP.

The network validation logic used during Cloud deployment will fail if it detects multiple physical network interfaces that have a default gateway in their configuration. If you need to use DHCP for your host IP assignments, you need to pre-create the SET _(switch embedded teaming)_ virtual switch and the management virtual network adapter as described above, so only the management virtual network adapter acquires an IP address from the DHCP server.

#### Cluster node IP considerations

Here are the summarized considerations for the IP addresses:

|#  | Considerations  |
|---------|---------|
|1     | Node IPs must be on the same subnet of the defined management IP pool range regardless if they're static or dynamic addresses.         |
|2     | The management IP pool must not include node IPs. Use DHCP exclusions when dynamic IP assignment is used.        |
|3     | Use DHCP reservations for the nodes as much as possible.        |
|4     | DHCP addresses are only supported for node IPs and the cluster IP. Infrastructure services use static IPs from the management pool.       |
|5     | The MAC address from the first physical network adapter is assigned to the management virtual network adapter once the management network intent is created.       |

### Proxy requirements

A proxy is most likely required to access the internet within your on-premises infrastructure. Azure Stack HCI supports only non-authenticated proxy configurations. Given that internet access is required to register the nodes in Azure Arc, the proxy configuration must be set as part of the OS configuration before server nodes are registered. For more information, see [Configure proxy settings](../manage/configure-proxy-settings-23h2.md).

The Azure Stack HCI OS has three different services (WinInet, WinHTTP, and environment variables) that require the same proxy configuration to ensure all OS components can access the internet. The same proxy configuration used for the nodes is automatically carried over to the Arc Resource Bridge VM and AKS, ensuring that they have internet access during deployment.

Here are the summarized considerations for proxy configuration:

|#     |Consideration  |
|---------|---------|
|1     | Proxy configuration must be completed before registering the nodes in Azure Arc.        |
|2     | The same proxy configuration must be applied for WinINET, WinHTTP, and environment variables.        |
|3     | The Environment Checker ensures that proxy configuration is consistent across all proxy components.       |
|4     | Proxy configuration of Arc Resource Bridge VM and AKS is automatically done by the orchestrator during deployment.        |
|5     | Only the non-authenticated proxies are supported.        |
 

### Firewall requirements

You are currently required to open several internet endpoints in your firewalls to ensure that Azure Stack HCI and its components can successfully connect to them. For a detailed list of the required endpoints, see [Firewall requirements](../concepts/firewall-requirements.md).

Firewall configuration must be done prior to registering the nodes in Azure Arc. You can use the standalone version of the environment checker to validate that your firewalls aren't blocking traffic sent to these endpoints. For more information, see [Azure Stack HCI Environment Checker](../manage/use-environment-checker.md) to assess deployment readiness for Azure Stack HCI.

Here are the summarized considerations for firewall:

|#     |Consideration  |
|------|---------|
|1     | Firewall configuration must be done before registering the nodes in Azure Arc.        |
|2     | Environment Checker in standalone mode can be used to validate the firewall configuration.       |


## Step 5: Determine network adapter configuration

:::image type="content" source="media/cloud-deployment-network-considerations/step-5.png" alt-text="Diagram showing step 5 of the network decision framework." lightbox="media/cloud-deployment-network-considerations/step-5.png":::

Network adapters are qualified by network traffic type (management, compute, and storage) they're used with. As you review the [Windows Server Catalog](https://www.windowsservercatalog.com/), the Windows Server 2022 certification indicates for which network traffic the adapters are qualified. 

Before purchasing a server for Azure Stack HCI, you must have at least one adapter that is qualified for management, compute, and storage as all three traffic types are required on Azure Stack HCI. Cloud deployment relies on Network ATC to configure the network adapters for the appropriate traffic types, so it is important to use supported network adapters.

The default values used by Network ATC are documented in [Cluster network settings](../deploy/network-atc.md?tabs=22H2#cluster-network-settings). We recommend that you use the default values. With that said, the following options can be overridden using Azure portal or Resource Manager templates if needed:

- **Storage VLANs**: Set this value to the required VLANs for storage.
- **Jumbo Packets**: Defines the size of the jumbo packets.
- **Network Direct**: Set this value to false if you want to disable RDMA for your network adapters.
- **Network Direct Technology**: Set this value to `RoCEv2` or `iWarp`.
- **Traffic Priorities Datacenter Bridging (DCB)**: Set the priorities that fit your requirements. We highly recommend that you use the default DCB values as these are validated by Microsoft and customers.

Here are the summarized considerations for network adapter configuration:

|#     |Consideration  |
|---------|---------|
|1     | Use the default configurations as much as possible.        |
|2     | Physical switches must be configured according to the network adapter configuration. See [Physical network requirements for Azure Stack HCI](../concepts/physical-network-requirements.md#network-switches-for-azure-stack-hci).    |
|3     | Ensure that your network adapters are supported for Azure Stack HCI using the Windows Server Catalog.       |
|4     | When accepting the defaults, Network ATC automatically configures the storage network adapter IPs and VLANs. This is known as Storage Auto IP configuration. <br><br>In some instances, Storage Auto IP isn't supported and you need to declare each storage network adapter IP using Resource Manager templates.        |


## Next steps

- [About Azure Stack HCI, version 23H2 deployment](../deploy/deployment-introduction.md).
