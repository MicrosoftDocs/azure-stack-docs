---
title: Getting started with Azure Stack HCI deployment
description: How to prepare to deploy Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 07/14/2020
---

# Before you deploy Azure Stack HCI

> Applies to Azure Stack HCI v20H2

In this how-to guide, you learn how to:

- Determine whether your hardware meets the base requirements for standard (single site) or stretched (two-site) Azure Stack HCI clusters
- Make sure you're not exceeding the maximum supported hardware specifications
- Gather the required information for a successful deployment
- Install Windows Admin Center on a management PC

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
- For additional feature-specific requirements for Hyper-V, see [System requirements for Hyper-V on Windows Server](https://docs.microsoft.com/windows-server/virtualization/hyper-v/system-requirements-for-hyper-v-on-windows).

### Networking requirements

An Azure Stack HCI cluster requires a reliable high-bandwidth, low-latency network connection between each server node. There are multiple types of communication going on between server nodes:

- Cluster communication (node joins, cluster updates, registry updates)
- Cluster Heartbeats
- Cluster Shared Volume (CSV) redirected traffic
- Live migration traffic for virtual machines

With Storage Spaces Direct, there is additional network traffic to consider:

- Storage Bus Layer (SBL) – extents, or data, spread out between the nodes
- Health – monitoring and managing objects (nodes, drives, network cards, Cluster Service)

For stretched clusters, there is also additional Storage Replica traffic flowing between the sites. Storage Bus Layer (SBL) and Cluster Shared Volume (CSV) traffic does not go between sites, only between the server nodes within each site.

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

- At least one 1 Gb RDMA (preferably) or Ethernet/TCP connection between sites for synchronous replication.
- A network between sites with enough bandwidth to contain your I/O write workload and an average of 5ms round trip latency or lower for synchronous replication. Asynchronous replication doesn't have a latency recommendation.
- If using a single connection between sites, set SMB bandwidth limits for Storage Replica using PowerShell. For more information, see [Set-SmbBandwidthLimit](https://docs.microsoft.com/powershell/module/smbshare/set-smbbandwidthlimit?view=win10-ps).
- If using multiple connections between sites, separate traffic between the connections. For example, put Storage Replica traffic on a separate network than Hyper-V live migration traffic using PowerShell. For more information, see [Set-SRNetworkConstraint](https://docs.microsoft.com/powershell/module/storagereplica/set-srnetworkconstraint?view=win10-ps).

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

### Storage requirements

- Azure Stack HCI works with direct-attached SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each.
- Each server in the cluster should have the same model, size, and number of drives, with the same sector sizes on all disks. Drives can be internal to the server, or in an external enclosure that is connected to just one server.
- Each server in the cluster should have dedicated volumes for logs, with log storage at least as fast as data storage. Stretched clusters require at least two volumes: one for replicated data, and one for log data.
- SCSI Enclosure Services (SES) is required for slot mapping and identification. Each external enclosure must present a unique identifier (Unique ID). **NOT SUPPORTED:** RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple servers, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths. Host-bus adapter (HBA) cards must implement simple pass-through mode.
- For more help, see the [Choosing drives](../concepts/choose-drives.md) topic or [Storage Spaces Direct hardware requirements](https://docs.microsoft.com/windows-server/storage/storage-spaces/storage-spaces-direct-hardware-requirements).
- For available options for volumes and resiliency, see the [Planning volumes in Storage Spaces Direct](https://docs.microsoft.com/windows-server/storage/storage-spaces/plan-volumes#choosing-the-resiliency-type) topic.
- If you're also deploying virtual machines and virtualized storage, see [Using Storage Spaces Direct in guest virtual machine clusters](https://docs.microsoft.com/windows-server/storage/storage-spaces/storage-spaces-direct-in-vm).

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

## Install Windows Admin Center

Windows Admin Center is a locally deployed, browser-based app for managing Azure Stack HCI. The simplest way to install Windows Admin Center is on a local Windows 10 PC, although you can also install it on a server if you want to enable multiple admins to connect to it via a web browser. When you install Windows Admin Center on Windows 10, it uses port 6516 by default, but you have the option to specify a different port.

1. **Download [Windows Admin Center](https://www.microsoft.com/evalcenter/evaluate-windows-admin-center)** from the Microsoft Evaluation Center. Even though it says "Start your evaluation", this is the generally available version for production use.
1. Run the WindowsAdminCenter.msi file to install.
1. When you start Windows Admin Center for the first time, you'll see an icon in the notification area of your desktop. Right-click this icon and choose Open to open the tool in your default browser, or choose Exit to quit the background process.

## Next steps

Advance to the next article to learn how to deploy the Azure Stack HCI operating system.
> [!div class="nextstepaction"]
> [Deploy the Azure Stack HCI operating system](operating-system.md)