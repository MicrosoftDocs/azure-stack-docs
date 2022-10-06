---
title: What's new in Azure Stack HCI, version 22H2
description: Find out what's new in Azure Stack HCI, version 22H2
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/04/2022
---

# What's new in Azure Stack HCI, version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article lists the various features and improvements that are now available in Azure Stack HCI, version 22H2. Over the next several weeks, this article will be updated as more features are rolled out for subsequent previews. To see what we added in the previous release of Azure Stack HCI, see [What's new in Azure Stack, version 21H2](whats-new-in-hci-21h2.md).

## New Azure Stack HCI, version 22H2 Operating System

Azure Stack HCI, version 22H2 is the latest version of the operating system available for the Azure Stack HCI solution. This version has a major update with new features and enhancements. The update is focused on Storage replication compression, Network ATC v2 improvements, Hyper-V live migration, and more.

Azure Stack HCI, version 22H2 is offered to you if you're running Azure Stack HCI version 21H2. To identify the operating system version from the available updates in Windows Admin Center, confirm that the release ID shows **22H2**. Once installed, you can verify the version by typing `systeminfo` (in cmd.exe) or `Get-ComputerInfo` (PowerShell) to see the OS version. For more information, see how to [Install Azure Stack HCI version 22H2 OS](./manage/install-preview-version.md).

You can join the Azure Stack HCI preview channel to test out features for this new version of the Azure Stack HCI operating system. For more information, see [Join the Azure Stack HCI preview channel](./manage/preview-channel.md).

The following sections briefly describe the various OS-related features and enhancements.

### Network ATC v2 improvements

In this release, the Network ATC has several new features and improvements:

- **Network symmetry**. Network ATC automatically checks for and validates network symmetry across all adapters (on each node) in the same intent - specifically the make, model, speed, and configuration of your selected adapters.

- **Storage automatic IP assignment**. Network ATC automatically identifies available IPs in our default subnets and assigns those addresses to your storage adapters.

- **Scope detection**. Network ATC automatically detects if you're configuring a cluster node, so no need to add the `-ClusterName` or `-ComputerName` parameter in your commands.

- **Contextual cluster network naming**. Network ATC understands how you'll use cluster networks and names them more appropriately.

- **Live Migration optimization**. Network ATC intelligently manages:

  - **Maximum simultaneous live migrations** - Network ATC ensures that the maximum recommended value is configured and maintained across all cluster nodes.
  - **Best live migration network** - Network ATC determines the best network for live migration and automatically configures your system.
  - **Best live migration transport** - Network ATC selects the best algorithm for SMB, compression, and TCP given your network configuration.
  - **Maximum SMB (RDMA) bandwidth** - If SMB (RDMA) is used, Network ATC determines the maximum bandwidth reserved for live migration to ensure that there's enough bandwidth for Storage Spaces Direct.

- **Proxy configuration**. Network ATC can configure all server nodes with the same proxy information as needed for your environment. This action provides one-time configuration for all current and future server nodes.

- **Stretched cluster support**. Network ATC configures all storage adapters used by Storage Replica in stretched cluster environments. However, since such adapters need to route across subnets, Network ATC can't assign any IP addresses to them, so you’ll still need to assign these addresses yourselves.

- **Post-deployment VLAN modification**. You can use the new `Set-NetIntent` cmdlet in Network ATC to modify VLAN settings just as you would if you were using the `Add-NetIntent` cmdlet. No need to remove and then add the intents again when changing VLANs.

For more information, see the blog on [Network ATC v2 improvements](https://aka.ms/hciatcv2-blog).

### Storage replica compression

This release includes the Storage Replica compression feature for data transferred between the source and destination servers. This new functionality compresses the replication data from the source system, which is transferred over the network, decompressed, and then saved on the destination. The compression results in fewer network packets to transfer the same amount of data, allowing for higher throughput and lower network utilization, which in turn results in lower costs for metered networks.

There are no changes to the way you create replica groups and partnerships. The only change is a new parameter that can be used with the existing Storage Replica cmdlets.

You specify compression when the group and the partnership are created. Use the following cmdlets to specify compression:
 
```powershell
New-SRGroup -EnableCompression 
New-SRPartnership -EnableCompression 
```

If the parameter isn't specified, the default is set to `Disabled`.

To modify this setting later, use the following cmdlets:
 
```powershell
Set-SRGroup -Compression [$true/$false]
Set-SRPartnership -Compression [$true/$false]

```

Here `False` is `Disabled` and `True` is `Enabled`.
 
All the other commands and steps remain the same. These changes aren't in Windows Admin Center at this time and will be added in a subsequent release.

For more information, see [Storage Replica overview](/windows-server/storage/storage-replica/storage-replica-overview).

### Hyper-V live migration improvements

In version 22H2, the Hyper-V live migration is faster and more reliable for switchless 2-node and 3-node clusters. Switchless interconnects can cause live migration delays and this release addresses these issues.

### Cluster-Aware Updating (CAU) improvements

With this release, cluster-aware updating is more reliable due to the smarter retry and mitigation logic that reduces errors when pausing and draining cluster nodes. Cluster-aware updating also supports single server deployments.

For more information, see [What is Cluster-Aware Updating?](/windows-server/failover-clustering/cluster-aware-updating)

### Thin provisioning conversion

With this release, you can now convert existing fixed provisioned volumes to thin using PowerShell. Thin provisioning improves storage efficiency and simplifies management.

For more information, see [Convert fixed to thin provisioned volumes on your Azure Stack HCI](./manage/thin-provisioning-conversion.md).

### Single server scale-out

This release supports inline fault domain and resiliency changes to scale out a single server. Azure Stack HCI version 22H2 provides easy scaling options to go from a single server to a two-node cluster, and from a two-node cluster to a three-node cluster.

For more information, see [Scale out single server on your Azure Stack HCI](./manage/single-node-scale-out.md).

### Tag-based segmentation

In this release, you can secure your application workload virtual machines (VMs) from external and lateral threats with custom tags of your choice. Assign custom tags to classify your VMs, and then apply Network Security Groups (NSGs) based on those tags to restrict communication to and from external and internal sources. For example, to prevent your SQL VMs from communicating with your web server VMs, simply tag the corresponding VMs with *SQL* and *Web* tags. You can then create an NSG to prevent *Web* tag from communicating with *SQL* tag.

For more information, see [Configure network security groups with Windows Admin Center](./manage/configure-network-security-groups-with-tags.md).

## Azure Hybrid Benefit for Azure Stack HCI

Azure Hybrid Benefit program enables customers to significantly reduce the costs of running workloads in the cloud. With Windows Server Software Assurance, We are further expanding Azure Hybrid Benefit to reduce the costs of running workloads on-premises and at edge locations.

If you have Windows Server Datacenter licenses with active Software Assurance, use Azure Hybrid Benefit to waive host service fees for Azure Stack HCI and unlimited virtualization with Windows Server subscription at no additional cost. You can then modernize your existing datacenter and edge infrastructure to run VM and container-based applications.

## Azure Arc VM changes and Azure Marketplace

With this release, Azure Marketplace integration for Azure Arc-enabled Azure Stack HCI is also available. With this integration, you'll be able to access the latest fully patched images from Microsoft, including Windows Server 2022 Azure Edition and Windows 10/11 Enterprise multi-session for Azure Virtual Desktop.

You can now use the Azure portal or the Azure CLI to easily add and manage VM images and then use those images to create Azure Arc-enabled VMs. This feature works with your existing Azure Stack HCI cluster running version 21H2 or later.

For more information, see:

  - [Create VM image using an Azure marketplace image](./manage/virtual-machine-image-azure-marketplace.md).
  - [Create VM image using an image in an Azure Storage account](./manage/virtual-machine-image-storage-account.md).
  - [Create VM image using an image in a local share](./manage/virtual-machine-image-local-share.md).


## Windows Server 2022 Datacenter Azure Edition VMs on Azure Stack HCI

Beginning this release, you can run Windows Server Azure Edition on Azure Stack HCI. The preview of Marketplace VM images lets customers deploy Windows Server Azure Edition (already generally available in Azure IaaS) on Azure Stack HCI. This enables unique features like Hotpatch and SMB over QUIC on Windows Server Azure Edition VMs on Azure Stack HCI. Through future guest management extensions, the full Azure Automanage experience will also become available in upcoming releases. 


## New Azure Stack HCI Environment Checker tool

Before you deploy your Azure Stack HCI solution, you can now use a standalone, PowerShell tool to check your environment readiness. The Azure Stack HCI Environment Checker is a lightweight, easy-to-use tool that will let you validate your:

- Internet connectivity.
- Hardware.
- Network infrastructure for valid IP ranges provided by customers for deployment.
- Active Directory (Adprep tool is run prior to deployment).

The Environment Checker tool runs tests on all the nodes of your Azure Stack HCI cluster, returns a Pass/Fail status for each test, and saves a log file and a detailed report file.

You can [download this free tool here](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker). The tool doesn't need an Azure subscription and will work with your existing Azure Stack HCI cluster running version 21H2 or later.

## New security capabilities

For new installations, version 22H2 starts with a secure-by-default strategy. The new version has a tailored security baseline coupled with a security drift control mechanism and a set of well-known security features enabled by default.

In summary, version 22H2 provides:

- A tailored security baseline with over 200 security settings configured and enforced with a security drift control mechanism that ensures the cluster always starts and remains in a known good security state. 

    The security baseline enables you to closely meet the Center for Internet Security (CIS) Benchmark, Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG), Common Criteria, and  Federal Information Processing Standards (FIPS) requirements for the OS and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-windows).

- Improved security posture achieved through a stronger set of protocols and cipher suites enabled by default.

- Secured-Core Server that achieves higher protection by advancing a combination of hardware, firmware, and driver capabilities.

- Out-of-box protection for data and network with SMB signing and BitLocker encryption for OS and Cluster Shared Volumes.

- Reduced attack surface as Windows Defender Application Control is enabled by default and limits the applications and the code that you can run on the core platform.


## Next steps

- [Read the blog about What’s new for Azure Stack HCI at Microsoft Inspire 2022](https://techcommunity.microsoft.com/t5/azure-stack-blog/what-s-new-for-azure-stack-hci-at-microsoft-inspire-2022/ba-p/3576847)
- [Install Azure Stack HCI version 22H2 OS](./manage/install-preview-version.md)