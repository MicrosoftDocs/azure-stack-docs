---
title: Network ATC overview 
description: This article introduces Network ATC for Azure Local and Windows Server.
author: parammahajan5
ms.topic: overview
ms.date: 10/10/2025
ms.author: alkohli 
ms.reviewer: alkohli
zone_pivot_groups: windows-os
---

# Network ATC overview

:::zone pivot="azure-local"

[!INCLUDE [hci-applies-to-23h2-22h2](../includes/hci-applies-to-23h2-22h2.md)]

Deployment and operation of Azure Local networking can be a complex and error-prone process. Due to the configuration flexibility provided with the host networking stack, there are many moving parts that can be easily misconfigured or overlooked. Staying up to date with the latest best practices is also a challenge as improvements are continuously made to the underlying technologies. Additionally, configuration consistency across Azure Local machines is important as it leads to a more reliable experience. Network ATC is the complete product name and not an acronym.

::: zone-end

:::zone pivot="windows-server"

>Applies to: Windows Server 2025

Deployment and operation of Windows Server cluster networking can be a complex and error-prone process. Due to the configuration flexibility provided with the host networking stack, there are many moving parts that can be easily misconfigured or overlooked. Staying up to date with the latest best practices is also a challenge as improvements are continuously made to the underlying technologies. Network ATC applies a consistency configuration across Windows Server cluster nodes to create a more reliable experience. As Network ATC is designed for Windows Server clusters, it requires Windows Server Datacenter edition and the Failover Clustering feature. Network ATC is the complete product name and not an acronym.

::: zone-end

Network ATC can help:

- Reduce host networking deployment time, complexity, and errors
- Deploy the latest Microsoft validated and supported best practices
- Ensure configuration consistency across the cluster
- Eliminate configuration drift

## Features

Network ATC provides the following features:

- **Windows Admin Center deployment**: Network ATC is integrated with Windows Admin Center to provide an easy-to-use experience for deploying host networking.

:::zone pivot="azure-local"

- **Network symmetry**: Network ATC configures and optimizes all adapters identically based on your configuration. Beginning with Azure Local, version 22H2, Network ATC also verifies the make, model, and speed of your network adapter to ensure network symmetry across all nodes of the cluster.

::: zone-end

:::zone pivot="windows-server"

- **Network symmetry**: Network ATC configures and optimizes all adapters identically based on your configuration. Network ATC also verifies the make, model, and speed of your network adapter to ensure network symmetry across all nodes of the cluster.

::: zone-end

- **Storage adapter configuration**: Network ATC automatically configures the following components for your storage network.

  - Physical adapter properties
  - Data Center Bridging
  - Determines if a virtual switch is needed, and if so, creates the required virtual adapters
  - Maps the virtual adapters to the appropriate physical adapter
  - Assigns VLANs

  :::zone pivot="azure-local"

  - Beginning with Azure Local, version 22H2, Network ATC automatically assigns IP Addresses for storage adapters.

  :::zone-end

  :::zone pivot="windows-server"

  - Network ATC automatically assigns IP Addresses for storage adapters.

  :::zone-end

- **Cluster network naming**: Network ATC automatically names the cluster networks based on their usage. For example, the storage network might be named _storage_compute(Storage\_VLAN711)_.

- **Live Migration guidelines**: Network ATC keeps you up to date with the recommended guidelines for Live Migration based on the operating system version (you can always override). Network ATC manages the following Live Migration settings:

  - The maximum number of simultaneous live migrations
  - The live migration network
  - The live migration transport
  - The maximum amount of SMBDirect (RDMA) bandwidth used for live migration

- **Proxy configuration**: Network ATC can help you configure all cluster nodes with the same proxy configuration information if your environment requires it.

- **Stretch S2D cluster support**: Network ATC deploys the configuration required for [the storage replica networks](host-network-requirements.md#stretched-clusters). Since these adapters need to route across subnets, Network ATC doesn't assign any IP addresses, so you need to assign the IP address.

- **Scope detection**: Beginning with Azure Local, version 22H2, Network ATC automatically detects if you're running the command on a cluster node. Meaning, you don't need to use the `-ClusterName` parameter because it automatically detects the cluster that you're on.

To learn more about the features in Network ATC, see [Network ATC: What's coming](https://techcommunity.microsoft.com/t5/networking-blog/network-atc-what-s-coming-in-azure-stack-hci-22h2/ba-p/3598442).

## Terminology

To understand Network ATC, you need to understand some basic concepts. Here's some terminology used by Network ATC:

**Intent**: An intent is a definition of how you intend to use the physical adapters in your system. An intent has a friendly name, identifies one or more physical adapters, and includes one or more intent types.

An individual physical adapter can only be included in one intent. By default, an adapter doesn't have an intent (there's no special status or property given to adapters that don't have an intent). You can have multiple intents; the number of adapters in your system limits the number of intents you have.

**Intent type**: Every intent requires one or more intent types. Any combination of the intent types can be specified for any specific single intent. Here are the currently supported intent types and the maximum number of intents they can be defined in:

Management: Adapters are used for management access to nodes. This intent type can be defined in a maximum of one intent.
Compute: Adapters are used to connect virtual machine (VM) traffic to the physical network. This intent type can be defined in unlimited intents.
Storage: Adapters are used for SMB traffic, including Storage Spaces Direct. This intent type can be defined in a maximum of one intent.
Stretch: Adapters are set up similarly to a storage intent, except RDMA can't be used with stretch intents. This intent type can be defined in a maximum of one intent.

**Override**: By default, Network ATC deploys the most common configuration, asking for the smallest amount of user input. Overrides allow you to customize your deployment if necessary. For example, you might choose to modify the VLANs used for storage adapters from the defaults.

Network ATC allows you to modify all configuration that the OS allows. However, the OS limits some modifications to the OS and Network ATC respects these limitations. For example, a virtual switch doesn't allow modification of SR-IOV after it's deployed.

## Deployment example

The following video provides an overview of Network ATC using the [Copy-NetIntent](/powershell/module/networkatc/copy-netintent) command to copy an intent from one cluster to another. To learn more about the demonstration, see our Tech Community article [Deploying 100s of production clusters in minutes](https://techcommunity.microsoft.com/t5/networking-blog/deploying-100s-of-production-clusters-in-minutes/ba-p/3724977).<br /><br />

> [!VIDEO https://www.youtube.com/embed/AZBE_3LCiHQ]

## Next steps

To get started with Network ATC, review the following articles:

:::zone pivot="azure-local"

- Review Network ATC defaults and example deployment options. See [Deploy host networking with Network ATC](../deploy/network-atc.md?pivots=azure-local).
- Configure Network ATC using PowerShell. See [Step 4: Configure host networking](../deploy/create-cluster-powershell.md#step-4-configure-host-networking).
- Manage Network ATC after deployment. See [Manage host networking using Network ATC](../manage/manage-network-atc.md?pivots=azure-local).
- [Migrate an existing cluster to Network ATC](https://techcommunity.microsoft.com/t5/networking-blog/migrate-an-existing-cluster-to-network-atc/ba-p/3843606).
- To learn more about the latest networking announcements, build your skills, and connect with the Microsoft Edge Networking community, see the [Tech Community Networking Blog](https://techcommunity.microsoft.com/t5/networking-blog/bg-p/NetworkingBlog).

::: zone-end

:::zone pivot="windows-server"

- Review Network ATC defaults and example deployment options. See [Deploy host networking with Network ATC](../deploy/network-atc.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking).
- Configure Network ATC using PowerShell. See [Step 4: Configure host networking](../deploy/create-cluster-powershell.md?context=/windows-server/context/windows-server-edge-networking#step-4-configure-host-networking).
- Manage Network ATC after deployment. See [Manage host networking using Network ATC](../manage/manage-network-atc.md?pivots=windows-server&context=/windows-server/context/windows-server-edge-networking).
- [Migrate an existing cluster to Network ATC](https://techcommunity.microsoft.com/t5/networking-blog/migrate-an-existing-cluster-to-network-atc/ba-p/3843606).
- To learn more about the latest networking announcements, build your skills, and connect with the Microsoft Edge Networking community, see the [Tech Community Networking Blog](https://techcommunity.microsoft.com/t5/networking-blog/bg-p/NetworkingBlog).

::: zone-end
