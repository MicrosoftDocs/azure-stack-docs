---
title: Getting Started with Azure Stack HCI Deployment
description: How to prepare to deploy Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 03/06/2020
---

# Before you deploy Azure Stack HCI

In this how-to guide, you learn how to:

- Determine whether your hardware meets the base requirements for Azure Stack HCI
- Gather the required information for a successful deployment
- Install Windows Admin Center on a Windows 10 PC

## Determine hardware requirements

Microsoft recommends purchasing a validated Azure Stack HCI hardware/software solution from our partners. These solutions are designed, assembled, and validated against our reference architecture to ensure compatibility and reliability, so you get up and running quickly.

- Check that the systems, components, devices, and drivers you are using are Windows Server 2019 Certified per the Windows Server Catalog. Visit the [Azure Stack HCI solutions](https://azure.microsoft.com/overview/azure-stack/hci) website for validated solutions.
- Azure Stack HCI requires a minimum of 2 servers and a maximum of 16 servers. It is recommended that all servers be the same manufacturer and model, with Intel Nehalem or later compatible processor or AMD EPYC or later compatible processor.
- Make sure that the servers are equipped with sufficient memory for the server operating system, VMs, and other apps or workloads. In addition, allow 4 GB of RAM per terabyte (TB) of cache drive capacity on each server for Storage Spaces Direct metadata.
- You can use any boot device supported by Windows Server, which [now includes SATADOM](https://cloudblogs.microsoft.com/windowsserver/2017/08/30/announcing-support-for-satadom-boot-drives-in-windows-server-2016/). RAID 1 mirror is **not** required, but is supported for boot. A 200 GB minimum size is recommended.
- Azure Stack HCI requires a reliable high bandwidth, low latency network connection between each node. For a small scale cluster (2-3 nodes), you will need a 10 Gbps network interface card (NIC) or faster. For larger clusters (4+ nodes), use 25 Gbps NICs or faster that are remote-direct memory access (RDMA) capable, iWARP (recommended) or RoCE. For any size cluster, two or more network connections from each node is recommended for redundancy and performance.
- Switched or switchless node interconnects are supported. Network switches must be properly configured to handle the bandwidth and networking type. If using RDMA that implements the RoCE protocol, network device and switch configuration is even more important. Nodes can also be interconnected using direct connections, avoiding using a switch. It is required that every node have a direct connection with every other node of the cluster.
- Azure Stack HCI works with direct-attached SATA, SAS, or NVMe drives that are physically attached to just one server each. For more help choosing drives, see the [Choosing drives](/windows-server/storage/storage-spaces/choosing-drives) topic. Drives can be internal to the server, or in an external enclosure that is connected to just one server. SCSI Enclosure Services (SES) is required for slot mapping and identification. Each external enclosure must present a unique identifier (Unique ID). **NOT SUPPORTED:** RAID controller cards or SAN (Fibre Channel, iSCSI, FCoE) storage, shared SAS enclosures connected to multiple servers, or any form of multi-path IO (MPIO) where drives are accessible by multiple paths. Host-bus adapter (HBA) cards must implement simple pass-through mode.
- The fully configured cluster (servers, networking, and storage) must pass all [cluster validation tests](https://technet.microsoft.com/library/cc732035(v=ws.10).aspx) per the wizard in Failover Cluster Manager or with the [Test-Cluster cmdlet](/powershell/module/failoverclusters/test-cluster?view=win10-ps) in PowerShell.

## Gather information

To prepare for deployment, gather the following details about your environment:

- **Server names:** Get familiar with your organization's naming policies for computers, files, paths, and other resources. You'll need to provision several servers, each with unique names.
- **Domain name:** Get familiar with your organization's policies for domain naming and domain joining. You'll be joining the servers to your domain, and you'll need to specify the domain name.
- **RDMA networking:** There are two types of RDMA protocols: iWarp and RoCE. Note which one your network adapters use, and if RoCE, also note the version (v1 or v2). For RoCE, also note the model of your top-of-rack switch.
- **VLAN ID:** Note the VLAN ID to be used for management OS network adapters on the servers, if any. You should be able to obtain this from your network administrator.

## Install Windows Admin Center

Windows Admin Center is a locally deployed, browser-based app for managing Azure Stack HCI. The simplest way to install Windows Admin Center is on a local Windows 10 PC, although you can also install it on a server or as a VM in Azure if you want to enable multiple admins to connect to it via a web browser. When you install Windows Admin Center on Windows 10, it uses port 6516 by default, but you have the option to specify a different port. 

1. **Download [Windows Admin Center](https://www.microsoft.com/evalcenter/evaluate-windows-admin-center)** from the Microsoft Evaluation Center. Even though it says "Start your evaluation", this is the generally available version for production use, included as part of your Windows or Windows Server license.
1. Run the WindowsAdminCenter.msi file to install.
1. When you start Windows Admin Center for the first time, you'll see an icon in the notification area of your desktop. Right-click this icon and choose Open to open the tool in your default browser, or choose Exit to quit the background process.

## Next steps

Advance to the next article to learn how to deploy the operating system for Azure Stack HCI.
> [!div class="nextstepaction"]
> [Deploy the operating system](operating-system.md)