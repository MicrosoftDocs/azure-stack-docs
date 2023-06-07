---
title: What's new in Azure Stack HCI, version 22H2 and Azure Stack HCI, Supplemental Package
description: Find out what's new in Azure Stack HCI, version 22H2 and Azure Stack HCI, Supplemental Package
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/30/2023
---

# What's new in Azure Stack HCI, version 22H2

[!INCLUDE [hci-applies-to-supplemental-package-22h2](../includes/hci-applies-to-supplemental-package-22h2.md)]

This article lists the various features and improvements that are available in Azure Stack HCI, version 22H2. This article also describes the Azure Stack HCI, Supplemental Package that can be deployed in conjunction with Azure Stack HCI, version 22H2 OS.

Azure Stack HCI, version 22H2 is the latest version of the operating system available for the Azure Stack HCI solution and focuses on Network ATC v2 improvements, storage replication compression, Hyper-V live migration, and more. Additionally, a preview version of Azure Stack HCI, Supplemental Package, is now available that can be deployed on servers running the English version of the Azure Stack HCI, version 22H2 OS.

You can also join the Azure Stack HCI preview channel to test out features for future versions of the Azure Stack HCI operating system. For more information, see [Join the Azure Stack HCI preview channel](./manage/preview-channel.md).

The following sections briefly describe the various features and enhancements in [Azure Stack HCI, Supplemental Package](#azure-stack-hci-supplemental-package-preview) and in [Azure Stack HCI, version 22H2](#azure-stack-hci-version-22h2).


[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Azure Stack HCI, Supplemental Package (preview)

Azure Stack HCI, Supplemental Package is now available to be deployed on servers running Azure Stack HCI, version 22H2 OS. This package contains a brand new deployment tool that allows for an interactive deployment, new security capabilities, an Azure Stack HCI Environment Checker tool that will validate connectivity, hardware, identity and networking prior to deployment, and a unified log collection experience.

### New deployment tool (preview)

For servers running Azure Stack HCI, version 22H2 OS, you can perform new deployments using the Azure Stack HCI, Supplemental Package (preview). You can deploy an Azure Stack HCI cluster via a brand new deployment tool in one of the three ways - interactively, using an existing configuration file, or via PowerShell.

[!INCLUDE [hci-deployment-tool-sp](../includes/hci-deployment-tool-sp.md)]

To learn more about the new deployment methods, see [Deployment overview](../hci/deploy/deployment-tool-introduction.md).

### New security capabilities (preview)

[!INCLUDE [hci-security-capabilities-sp](../includes/hci-security-capabilities-sp.md)]

### New Azure Stack HCI Environment Checker tool (preview)

[!INCLUDE [hci-environment-checker-sp](../includes/hci-environment-checker-sp.md)]

## Azure Stack HCI, version 22H2

The following sections briefly describe the various features and enhancements in Azure Stack HCI, version 22H2.

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

### Storage Replica compression

This release includes the Storage Replica compression feature for data transferred between the source and destination servers. This new functionality compresses the replication data from the source system, which is transferred over the network, decompressed, and then saved on the destination. The compression results in fewer network packets to transfer the same amount of data, allowing for higher throughput and lower network utilization, which in turn results in lower costs for metered networks.

There are no changes to the way you create replica groups and partnerships. The only change is a new parameter that can be used with the existing Storage Replica cmdlets.

You specify compression when the group and the partnership are created. Use the following cmdlets to specify compression:
 
```powershell
New-SRGroup -EnableCompression 
New-SRPartnership -EnableCompression 
```

If the parameter isn't specified, the default is set to **Disabled**.

To modify this setting later, use the following cmdlets:
 
```powershell
Set-SRGroup -Compression <Boolean>
Set-SRPartnership -Compression <Boolean>

```

where `$False` is **Disabled** and `$True` is **Enabled**.
 
All the other commands and steps remain the same. These changes aren't in Windows Admin Center at this time and will be added in a subsequent release.

For more information, see [Storage Replica overview](/windows-server/storage/storage-replica/storage-replica-overview).

### Partition and share GPU with virtual machines on Azure Stack HCI

With this release, GPU partitioning is now supported on NVIDIA [A2](https://www.nvidia.com/en-us/data-center/products/a2/), [A10](https://www.nvidia.com/en-us/data-center/products/a10-gpu/), [A16](https://www.nvidia.com/en-us/data-center/products/a16-gpu/), and [A40](https://www.nvidia.com/en-us/data-center/a40/) GPUs in Azure Stack HCI, enabled with NVIDIA RTX Virtual Workstation (vWS) and NVIDIA Virtual PC (vPC) software. GPU partitioning is implemented using single root I/O virtualization (SR-IOV), which provides a strong, hardware-backed security boundary with predictable performance for each virtual machine.

For more information, see [Partition and share GPU with virtual machines on Azure Stack HCI](../hci/manage/partition-gpu.md).

### Hyper-V live migration improvements

In Azure Stack HCI, version 22H2, the Hyper-V live migration is faster and more reliable for switchless 2-node and 3-node clusters. Switchless interconnects can cause live migration delays and this release addresses these issues.

### Cluster-Aware Updating (CAU) improvements

With this release, Cluster-Aware Updating is more reliable due to the smarter retry and mitigation logic that reduces errors when pausing and draining cluster nodes. Cluster-Aware Updating also supports single server deployments.

For more information, see [What is Cluster-Aware Updating?](/windows-server/failover-clustering/cluster-aware-updating)

### Thin provisioning conversion

With this release, you can now convert existing fixed provisioned volumes to thin using PowerShell. Thin provisioning improves storage efficiency and simplifies management.

For more information, see [Convert fixed to thin provisioned volumes on your Azure Stack HCI](./manage/thin-provisioning-conversion.md).

### Single server scale-out

This release supports inline fault domain and resiliency changes to scale out a single server. Azure Stack HCI, version 22H2 provides easy scaling options to go from a single server to a two-node cluster, and from a two-node cluster to a three-node cluster.

For more information, see [Scale out single server on your Azure Stack HCI](./manage/single-node-scale-out.md).

### Tag-based segmentation

In this release, you can secure your application workload virtual machines (VMs) from external and lateral threats with custom tags of your choice. Assign custom tags to classify your VMs, and then apply Network Security Groups (NSGs) based on those tags to restrict communication to and from external and internal sources. For example, to prevent your SQL Server VMs from communicating with your web server VMs, simply tag the corresponding VMs with *SQL* and *Web* tags. You can then create an NSG to prevent *Web* tag from communicating with *SQL* tag.

For more information, see [Configure network security groups with Windows Admin Center](./manage/configure-network-security-groups-with-tags.md).

### Azure Hybrid Benefit for Azure Stack HCI

Azure Hybrid Benefit program enables customers to significantly reduce the costs of running workloads in the cloud. With Windows Server Software Assurance (SA), we are further expanding Azure Hybrid Benefit to reduce the costs of running workloads on-premises and at edge locations.

If you have Windows Server Datacenter licenses with active Software Assurance, use Azure Hybrid Benefit to waive host service fees for Azure Stack HCI and unlimited virtualization with Windows Server subscription at no additional cost. You can then modernize your existing datacenter and edge infrastructure to run VM and container-based applications.

For more information, see [Azure Hybrid Benefit for Azure Stack HCI](./concepts/azure-hybrid-benefit-hci.md).

### Azure Arc VM changes and Azure Marketplace

Another feature also available with this release is Azure Marketplace integration for Azure Arc-enabled Azure Stack HCI. With this integration, you'll be able to access the latest fully updated images from Microsoft, including Windows Server 2022 Datacenter: Azure Edition and Windows 10/11 Enterprise multi-session for Azure Virtual Desktop.

You can now use the Azure portal or the Azure CLI to easily add and manage VM images and then use those images to create Azure Arc VMs. This feature works with your existing cluster running Azure Stack HCI, version 21H2 or later.

For more information, see:

- [Create VM image using an Azure Marketplace image](./manage/virtual-machine-image-azure-marketplace.md).
- [Create VM image using an image in an Azure Storage account](./manage/virtual-machine-image-storage-account.md).
- [Create VM image using an image in a local share](./manage/virtual-machine-image-local-share.md).

### Windows Server 2022 Datacenter: Azure Edition VMs on Azure Stack HCI

Beginning this release, you can run Windows Server 2022 Datacenter: Azure Edition on Azure Stack HCI. The preview of Marketplace VM images lets customers deploy Windows Server 2022 Datacenter: Azure Edition (already generally available in Azure IaaS) on Azure Stack HCI. This enables unique features like Hotpatch and SMB over QUIC on Windows Server 2022 Datacenter: Azure Edition VMs on Azure Stack HCI. Through future guest management extensions, the full Azure Automanage experience will also become available in upcoming releases.

### Automatic renewal of Network Controller certificates

You can now renew your Network Controller certificates automatically, in addition to manual renewal. For information on how to renew the Network Controller certificates automatically, see [Automatic renewal](./manage/update-network-controller-certificates.md?tabs=automatic-renewal#renew-network-controller-certificates).

## Next steps

- [Read the blog about What’s new for Azure Stack HCI at Microsoft Ignite 2022](https://techcommunity.microsoft.com/t5/azure-stack-blog/what-s-new-for-azure-stack-hci-at-microsoft-ignite-2022/ba-p/3650949).
- For existing Azure Stack HCI deployments, [Update Azure Stack HCI](./manage/update-cluster.md).
- For new Azure Stack HCI deployments:
    - Read the [Deployment overview](./deploy/deployment-tool-introduction.md).
    - Learn how to [Deploy interactively](./deploy/deployment-tool-new-file.md) using the Azure Stack HCI, Supplemental Package.
