---
title: Before you deploy Azure Stack HCI
description: How to prepare to deploy Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/01/2020
---

# Before you deploy Azure Stack HCI

> Applies to: Azure Stack HCI, version 20H2

In this how-to guide, you learn how to:

- Determine whether your hardware meets the base requirements for standard (single site) or stretched (two-site) Azure Stack HCI clusters
- Make sure you're not exceeding the maximum supported hardware specifications
- Gather the required information for a successful deployment
- Install Windows Admin Center on a management PC or server

For Azure Kubernetes Service on Azure Stack HCI requirements, see [AKS requirements on Azure Stack HCI](../../aks-hci/overview.md#what-you-need-to-get-started).

## Determine hardware requirements

Microsoft recommends purchasing a validated Azure Stack HCI hardware/software solution from our partners. These solutions are designed, assembled, and validated against our reference architecture to ensure compatibility and reliability, so you get up and running quickly. Check that the systems, components, devices, and drivers you are using are Windows Server 2019 Certified per the Windows Server Catalog. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) website for validated solutions.

### Server requirements

- A standard Azure Stack HCI cluster requires a minimum of 2 servers and a maximum of 16 servers; however, clusters can be combined using cluster sets to create an HCI platform of hundreds of nodes.
- Stretched clusters require servers to be deployed at two separate sites. The sites can be in different countries, different cities, different floors, or different rooms. A stretched cluster requires a minimum of 4 servers (2 per site) and a maximum of 16 servers (8 per site).
- It's recommended that all servers be the same manufacturer and model, using 64-bit Intel Nehalem grade, AMD EPYC grade, or later compatible processors with second-level address translation (SLAT). A second generation Intel Xeon Scalable processor is required to support Intel Optane DC persistent memory. Processors must be at least 1.4 GHz and compatible with the x64 instruction set.
- Make sure that the servers are equipped with at least 32 GB of RAM per node to accommodate the server operating system, VMs, and other apps or workloads. In addition, allow 4 GB of RAM per terabyte (TB) of cache drive capacity on each server for Storage Spaces Direct metadata.
- Verify that virtualization support is turned on in the BIOS or UEFI:
    - Hardware-assisted virtualization. This is available in processors that include a virtualization option, specifically processors with Intel Virtualization Technology (Intel VT) or AMD Virtualization (AMD-V) technology.
    - Hardware-enforced Data Execution Prevention (DEP) must be available and enabled. For Intel systems, this is the XD bit (execute disable bit). For AMD systems, this is the NX bit (no execute bit).
- You can use any boot device supported by Windows Server, which [now includes SATADOM](https://cloudblogs.microsoft.com/windowsserver/2017/08/30/announcing-support-for-satadom-boot-drives-in-windows-server-2016/). RAID 1 mirror is **not** required, but is supported for boot. A 200 GB minimum size is recommended.
- For additional feature-specific requirements for Hyper-V, see [System requirements for Hyper-V on Windows Server](/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows).

### Networking requirements

An Azure Stack HCI cluster requires a reliable high-bandwidth, low-latency network connection between each server node. You should verify the following:

- Verify at least one network adapter is available and dedicated for cluster management.
- Verify that physical switches in your network are configured to allow traffic on any VLANs you will use.

There are multiple types of communication going on between server nodes:

- Cluster communication (node joins, cluster updates, registry updates)
- Cluster Heartbeats
- Cluster Shared Volume (CSV) redirected traffic
- Live migration traffic for virtual machines

With Storage Spaces Direct, there is additional network traffic to consider:

- Storage Bus Layer (SBL) – extents, or data, spread out between the nodes
- Health – monitoring and managing objects (nodes, drives, network cards, Cluster Service)

For stretched clusters, there is also additional Storage Replica traffic flowing between the sites. Storage Bus Layer (SBL) and Cluster Shared Volume (CSV) traffic does not go between sites, only between the server nodes within each site.

### Software defined networking requirements

When you create an Azure Stack HCI cluster using Windows Admin Center, you have the option to deploy Network Controller to enable software defined networking (SDN). If you intend to use SDN on Azure Stack HCI:

- Make sure the host servers have at least 50-100 GB of free space to create the Network Controller VMs.

- You must copy a virtual hard disk (VHD) of the Azure Stack HCI operating system to the first node in the cluster in order to create the Network Controller VMs. You can prepare the VHD using [Sysprep](/windows-hardware/manufacture/desktop/sysprep-process-overview) or by running the [Convert-WindowsImage](https://gallery.technet.microsoft.com/scriptcenter/Convert-WindowsImageps1-0fe23a8f) script to convert an .iso file into a VHD.

For more information about preparing for using SDN in Azure Stack HCI, see [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md) and [Plan to deploy Network Controller](../concepts/network-controller.md).

### Domain requirements

There are no special domain functional level requirements for Azure Stack HCI - just an operating system version for your domain controller that's still supported. We do recommend turning on the Active Directory Recycle Bin feature as a general best practice, if you haven't already.

### Interconnect requirements between nodes

This section discusses specific networking requirements between server nodes in a site, called interconnects. Either switched or switchless node interconnects can be used and are supported:

- **Switched:** Server nodes are most commonly connected to each other via Ethernet networks that use network switches. Switches must be properly configured to handle the bandwidth and networking type. If using RDMA that implements the RoCE protocol, network device and switch configuration is important.
- **Switchless:** Server nodes can also be interconnected using direct Ethernet connections without a switch. In this case, each server node must have a direct connection with every other cluster node in the same site.

#### Interconnects for 2-3 node clusters

These are the *minimum* interconnect requirements for single-site clusters having two or three nodes. These apply for each server node:

- One or more 1 Gb network adapter cards to be used for management functions
- One or more 10 Gb (or faster) network interface cards for storage and workload traffic
- Two or more network connections between each node recommended for redundancy and performance

#### Interconnects for 4-node and greater clusters

These are the *minimum* interconnect requirements for clusters having four or more nodes, and for high-performance clusters. These apply for each server node:

- One or more 1 Gb network adapter cards to be used for management functions.
- One or more 25 Gb (or faster) network interface cards for storage and workload traffic. We recommend two or more network connections for redundancy and performance.
- Network cards that are remote-direct memory access (RDMA) capable: iWARP (recommended) or RoCE.

### Site-to-site requirements (stretched cluster)

When connecting between sites for stretched clusters, interconnect requirements within each site still apply, and have additional Storage Replica and Hyper-V live migration traffic requirements that must be considered:

- At least one 1 Gb RDMA or Ethernet/TCP connection between sites for synchronous replication. A 25 Gb RDMA connection is preferred.
- A network between sites with enough bandwidth to contain your I/O write workload and an average of 5ms round trip latency or lower for synchronous replication. Asynchronous replication doesn't have a latency recommendation.
- If using a single connection between sites, set SMB bandwidth limits for Storage Replica using PowerShell. For more information, see [Set-SmbBandwidthLimit](/powershell/module/smbshare/set-smbbandwidthlimit).
- If using multiple connections between sites, separate traffic between the connections. For example, put Storage Replica traffic on a separate network than Hyper-V live migration traffic using PowerShell. For more information, see [Set-SRNetworkConstraint](/powershell/module/storagereplica/set-srnetworkconstraint).

### Network port requirements

Ensure that the proper network ports are open between all server nodes both within a site and between sites (for stretched clusters). You'll need appropriate firewall and router rules to allow ICMP, SMB (port 445, plus port 5445 for SMB Direct), and WS-MAN (port 5985) bi-directional traffic between all servers in the cluster.

When using the Cluster Creation wizard in Windows Admin Center to create the cluster, the wizard automatically opens the appropriate firewall ports on each server in the cluster for Failover Clustering, Hyper-V, and Storage Replica. If using a different software firewall on each server, open the following ports:

#### Failover Clustering ports

- ICMPv4 and ICMPv6
- TCP port 445
- RPC Dynamic Ports
- TCP port 135
- TCP port 137
- TCP port 3343
- UDP port 3343

#### Hyper-V ports

- TCP port 135
- TCP port 80 (HTTP connectivity)
- TCP port 443 (HTTPS connectivity)
- TCP port 6600
- TCP port 2179
- RPC Dynamic Ports
- RPC Endpoint Mapper
- TCP port 445

#### Storage Replica ports (stretched cluster)

- TCP port 445
- TCP 5445 (if using iWarp RDMA)
- TCP port 5985
- ICMPv4 and ICMPv6 (if using Test-SRTopology)

There may be additional ports required not listed above. These are the ports for basic Azure Stack HCI functionality.

### Network switch requirements

This section defines the requirements for physical switches used with Azure Stack HCI. These requirements list the industry specifications, organizational standards, and protocols that are mandatory for all Azure Stack HCI deployments. Unless otherwise noted, the latest active (non-superseded) version of the standard is required.

These requirements help ensure reliable communications between nodes in Azure Stack HCI cluster deployments. Reliable communications between nodes are critical. To provide the needed level of reliability for Azure Stack HCI requires that switches:

- Comply with applicable industry specifications, standards, and protocols
- Provide visibility as to which specifications, standards, and protocols the switch supports
- Provide information on which capabilities are enabled

Make sure you ask your switch vendor if your switch supports the following:

#### Standard: IEEE 802.1Q

Ethernet switches must comply with the IEEE 802.1Q specification that defines VLANs. VLANs are required for several aspects of Azure Stack HCI and are required in all scenarios.

#### Standard: IEEE 802.1Qbb

Ethernet switches must comply with the IEEE 802.1Qbb specification that defines Priority Flow Control (PFC). PFC is required where Data Center Bridging (DCB) is used. Since DCB can be used in both RoCE and iWARP RDMA scenarios, 802.1Qbb is required in all scenarios. A minimum of three Class of Service (CoS) priorities are required without downgrading the switch capabilities or port speed.

#### Standard: IEEE 802.1Qaz

Ethernet switches must comply with the IEEE 802.1Qaz specification that defines Enhanced Transmission Select (ETS). ETS is required where DCB is used. Since DCB can be used in both RoCE and iWARP RDMA scenarios, 802.1Qaz is required in all scenarios. A minimum of three CoS priorities are required without downgrading the switch capabilities or port speed.

#### Standard: IEEE 802.1AB

Ethernet switches must comply with the IEEE 802.1AB specification that defines the Link Layer Discovery Protocol (LLDP). LLDP is required for Windows to discover switch configuration. Configuration of the LLDP Type-Length-Values (TLVs) must be dynamically enabled. These switches must not require additional configuration.

For example, enabling 802.1 Subtype 3 should automatically advertise all VLANs available on switch ports.

#### TLV Requirements

LLDP allows organizations to define and encode their own custom TLVs. These are called Organizationally Specific TLVs. All Organizationally Specific TLVs start with an LLDP TLV Type value of 127. The following table shows which Organizationally Specific Custom TLV (TLV Type 127) subtypes are required and which are optional:

|Condition|Organization|TLV Subtype|
|-|-|-|
|Required|IEEE 802.1|VLAN Name (Subtype = 3)|
|Required|IEEE 802.3|Maximum Frame Size (Subtype = 4)|
|Optional|IEEE 802.1|Port VLAN ID (Subtype = 1)|
|Optional|IEEE 802.1|Port And Protocol VLAN ID (Subtype = 2)|
|Optional|IEEE 802.1|Link Aggregation (Subtype = 7)|
|Optional|IEEE 802.1|Congestion Notification (Subtype = 8)|
|Optional|IEEE 802.1|ETS Configuration (Subtype = 9)|
|Optional|IEEE 802.1|ETS Recommendation (Subtype = A)|
|Optional|IEEE 802.1|PFC Configuration (Subtype = B)|
|Optional|IEEE 802.1|EVB (Subtype = D)|
|Optional|IEEE 802.3|Link Aggregation (Subtype = 3)|

> [!NOTE]
> Some of the optional features listed may be required in the future.

### Storage requirements

- Azure Stack HCI works with direct-attached SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each.
- Every server in the cluster should have the same types of drives and the same number of each type. It's also recommended (but not required) that the drives be the same size and model. Drives can be internal to the server, or in an external enclosure that is connected to just one server. To learn more, see [Drive symmetry considerations](../concepts/drive-symmetry-considerations.md).
- Each server in the cluster should have dedicated volumes for logs, with log storage at least as fast as data storage. Stretched clusters require at least two volumes: one for replicated data, and one for log data.
- SCSI Enclosure Services (SES) is required for slot mapping and identification. Each external enclosure must present a unique identifier (Unique ID). **NOT SUPPORTED:** RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple servers, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths. Host-bus adapter (HBA) cards must implement simple pass-through mode.
- For more help, see the [Choosing drives](../concepts/choose-drives.md) topic or [Storage Spaces Direct hardware requirements](/windows-server/storage/storage-spaces/storage-spaces-direct-hardware-requirements).
- For available options for volumes and resiliency, see the [Planning volumes in Storage Spaces Direct](/windows-server/storage/storage-spaces/plan-volumes#choosing-the-resiliency-type) topic.
- If you're also deploying virtual machines and virtualized storage, see [Using Storage Spaces Direct in guest virtual machine clusters](/windows-server/storage/storage-spaces/storage-spaces-direct-in-vm).

## Review maximum supported hardware specifications

Azure Stack HCI deployments that exceed the following specifications are not supported:

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 16      |
| VMs per host                 | 1,024   |
| Disks per VM (SCSI)          | 256     |
| Storage per cluster          | 4 PB    |
| Storage per server           | 400 TB  |
| Logical processors per host  | 512     |
| RAM per host                 | 24 TB   |
| RAM per VM                   | 12 TB (generation 2 VM) or 1 TB (generation 1)|
| Virtual processors per host  | 2,048   |
| Virtual processors per VM    | 240 (generation 2 VM) or 64 (generation 1)|

## Gather information

To prepare for deployment, gather the following details about your environment:

- **Server names:** Get familiar with your organization's naming policies for computers, files, paths, and other resources. You'll need to provision several servers, each with unique names.
- **Domain name:** Get familiar with your organization's policies for domain naming and domain joining. You'll be joining the servers to your domain, and you'll need to specify the domain name.
- **Static IP addresses:** Azure Stack HCI requires static IP addresses for storage and workload (VM) traffic and doesn't support dynamic IP address assignment through DHCP for this high-speed network. You can use DHCP for the management network adapter unless you're using two in a team, in which case again you need to use static IPs. Consult your network administrator about the IP address you should use for each server in the cluster.
- **RDMA networking:** There are two types of RDMA protocols: iWarp and RoCE. Note which one your network adapters use, and if RoCE, also note the version (v1 or v2). For RoCE, also note the model of your top-of-rack switch.
- **VLAN ID:** Note the VLAN ID to be used for the network adapters on the servers, if any. You should be able to obtain this from your network administrator.
- **Site names:** For stretched clusters, two sites are used for disaster recovery. You can set up sites using Active Directory Domain Services, or the Create cluster wizard can automatically set them up for you. Consult your domain administrator about setting up sites. Or to learn more, see [Active Directory Domain Services Overview](/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview).

## Install Windows Admin Center

Windows Admin Center is a locally deployed, browser-based app for managing Azure Stack HCI. The simplest way to [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) is on a local management PC (desktop mode), although you can also install it on a server (service mode).

If you install Windows Admin Center on a server, tasks that require CredSSP, such as cluster creation and installing updates and extensions, require using an account that's a member of the Gateway Administrators group on the Windows Admin Center server. For more information, see the first two sections of [Configure User Access Control and Permissions](/windows-server/manage/windows-admin-center/configure/user-access-control#gateway-access-role-definitions).

## Next steps

Advance to the next article to learn how to deploy the Azure Stack HCI operating system.
> [!div class="nextstepaction"]
> [Deploy the Azure Stack HCI operating system](operating-system.md)
