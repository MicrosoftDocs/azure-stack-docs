---
title: What's new in Azure Stack HCI, version 22H2
description: Find out what's new in Azure Stack HCI, version 22H2
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/10/2022
---

# What's new in Azure Stack HCI, version 22H2 (preview)

> Applies to: Azure Stack HCI, version 22H2 (preview)

This article lists the various features and improvements that are now available in Azure Stack HCI, version 22H2. Over the next several weeks, this article will be updated as more features are rolled out for subsequent previews.

You can join the Azure Stack HCI preview channel to test out features for this new version of the Azure Stack HCI operating system. For more info, see [Join the Azure Stack HCI preview channel](manage/preview-channel.md).

## New Azure Stack HCI, version 22H2 Operating System

Azure Stack HCI, version 22H2 is the latest version of the operating system available for the Azure Stack HCI solution. This version has a major update with new features and enhancements. The update is focused on Storage replication compression, Network ATC v2 improvements, Hyper-V live migration and others.

Azure Stack HCI, version 22H2 is offered to you if you are running Azure Stack HCI version 21H2. To identify the operating system version from the available updates in Windows Admin Center, confirm that the release ID shows **22H2**. Once installed, you can verify the version by typing `systeminfo` (in cmd.exe) or `Get-ComputerInfo` (PowerShell) to see the OS version. For more information, see how to [Install Azure Stack HCI version 22H2 OS](./manage/install-preview-build.md).

The following sections briefly describe the various OS-related features and enhancements.

### Network ATC v2 improvements

In this release, the Network ATC has several new features and improvements:

- **Network symmetry**. Network ATC automatically checks for and validates network symmetry across all adapters (on each node) in the same intent - specifically the make, model, speed, and configuration of your selected adapters.

- **Storage Automatic IP assignment**. Network ATC automatically identifies available IPs in our default subnets and assigns those addresses to your storage adapters.

- **Scope detection**. Network ATC automatically detects if you are configuring a cluster node, so no need to add the -ClusterName or -ComputerName parameter in your commands.

- **Contextual cluster network naming**. Network ATC understands how you will use cluster networks and will name them more relevantly.

- **Live Migration optimization**. Network ATC will intelligently manage:

  - Maximum simultaneous live migrations - Network ATC ensures that the maximum recommended value is configured and maintained across all cluster nodes.
  - Best live migration network - Network ATC determines the best network for live migration and automatically configures your system.
  - Best live migration transport - Network ATC selects the best algorithm for SMB, compression, and TCP given your network configuration.
  - Maximum SMB (RDMA) bandwidth - If SMB (RDMA) is used, Network ATC determines the maximum bandwidth reserved for live migration to ensure that there is enough bandwidth for Storage Spaces Direct.

- **Proxy configuration**. Network ATC can configure all server nodes with the same proxy information as needed for your environment. This provides one-time configuration for all current and future server nodes.

- **Stretched cluster support**. Network ATC configures all storage adapters used by Storage Replica in stretched cluster environments. However, since such adapters need to route across subnets, Network ATC can't assign any IP addresses to them, so you’ll still need to assign these yourselves.

- **Post-deployment VLAN modification**. You can use the new Set-NetIntent parameter in Network ATC to modify VLAN settings just as you would if you were using the Add-NetIntent parameter. No need to remove and then add the intents again when changing VLANs.

For more information, see the blog on [Network ATC v2 improvements](overview.md).


### Storage replica compression

This release includes the Storage Replica compression feature for data transferred between the source and destination servers. This new functionality compresses the replication data from the source system, which is transferred over the network, decompressed, and then saved on the destination.  The compression results in fewer network packets to transfer the same amount of data, allowing for higher throughput and lower network utilization, which in turn results in lower costs for metered networks.

There are no changes to the way you create replica groups and partnerships. The only change is a new parameter that can be used with the existing Storage Replica cmdlets.

You specify compression when the group and the partnership is created. Use the following cmdlets to specify compression:
 
```powershell
New-SRGroup -EnableCompression 
New-SRPartnership -EnableCompression 
```

If the parameter is not specified, the default is set to `Disabled`.

To modify this setting later, use the following cmdlets:
 
```powershell
Set-SRGroup -Compression [$true/$false]
Set-SRPartnership -Compression [$true/$false]

```

Here `False` is `Disabled` and `True` is `Enabled`.
 
All the other commands and steps remain the same. These changes are not in Windows Admin Center at this time and will be added in a subsequent release.

For more information, see [Storage Replica overview](/windows-server/storage/storage-replica/storage-replica-overview).

### Hyper-V live migration improvements

In version 22H2, the Hyper-V live migration is faster and more reliable for switchless 2-node and 3-node clusters. Switchless interconnects can cause live migration delays and this release addresses these issues.

### Cluster-Aware Updating (CAU) improvements

With this release, cluster-aware updating is more reliable due to the smarter retry and mitigation logic that reduces errors when pausing and draining cluster nodes. Cluster-aware updating also supports single-node deployments.

For more information, see [What is Cluster-Aware Updating?](/windows-server/failover-clustering/cluster-aware-updating)

## New security capabilities

For new installations, version 22H2 starts with a secure-by-default strategy. The new version has a tailored security baseline coupled with a security drift control mechanism and a set of well-known security features enabled by default.

In a nutshell, version 22H2 will provide:

- A tailored security baseline with over 200 security settings configured and enforced with a security drift control mechanism that ensures the cluster always starts and remains in a good known security state. This baseline enables the customers to closely meet the CIS Benchmark, Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG), Common Criteria and  Federal Information Processing Standards (FIPS) requirements for the OS and the Microsoft recommended security baseline.

- Improved security posture achieved through a stronger set of protocols and cipher suites enabled by default.

- Secured-Core Server that achieves higher protection by advancing a combination of hardware, firmware, and driver capabilities.

- Out-of-box protection for data and network with SMB signing and BitLocker encryption for OS and Cluster Shared Volumes.

- Reduced attack surface by using Windows Defender Application Control to limit the applications and the code that you can run on the core platform.


## Azure Arc VM changes and Azure Marketplace

Beginning this release, Azure Marketplace integration for Azure Arc-enabled Azure Stack HCI is also available. With this integration, you will be able to access the latest fully-patched images from Microsoft, including Windows Server 2022 Azure Edition and Windows 10/11 Enterprise multi-session for Azure Virtual Desktop.

You can now use the Azure portal or the Azure CLI to easily add and manage VM images and then use those images to create Azure Arc-enabled VMs. This feature works with your existing Azure Stack HCI cluster running version 21H2 or later.

## New Azure Stack HCI Environment Checker tool

Before you deploy your Azure Stack HCI solution, you can now use a standalone, PowerShell tool to check your environment readiness. The Azure Stack HCI Environment Checker is a lightweight, easy-to-use tool that will let you validate your:

- Internet connectivity.
- Hardware.
- Network infrastructure for valid IP ranges provided by customers for deployment.
- Active Directory (Adprep tool is run prior to deployment).

While the connectivity validator is available today, the hardware, network infrastructure and Active Directory validators are coming soon.

The Environment Checker tool runs tests on all the nodes of your Azure Stack HCI cluster, returns a Pass/Fail status for each test, and saves a log file and a detailed report file.

You can [download](https://www.powershellgallery.com/packages/AzStackHci.EnvironmentChecker) this free tool. The tool does not need an Azure subscription and will work with your existing Azure Stack HCI cluster running version 21H2 or later.


## Next steps

- [Read the blog on What’s new for Azure Stack HCI at Microsoft Inspire 2022](https://techcommunity.microsoft.com/t5/azure-stack-blog/what-s-new-for-azure-stack-hci-at-microsoft-inspire-2022/ba-p/3576847)
- [Update to Azure Stack HCI, version 22H2](./manage/install-preview-build.md)