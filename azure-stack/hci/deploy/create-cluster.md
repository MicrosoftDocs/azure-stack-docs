---
title: Create an Azure Stack HCI cluster using Windows Admin Center
description: Learn how to create a server cluster for Azure Stack HCI using Windows Admin Center
author: v-dasis
ms.topic: article
ms.prod: 
ms.date: 06/07/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Create an Azure Stack HCI cluster using Windows Admin Center

> Applies to Azure Stack HCI v20H2

Using the Create Cluster wizard in Windows Admin Center, you will create an Azure Stack HCI cluster with two or more server nodes.

It is highly recommended that you use Windows Admin Center from a remote computer running Windows 10, rather than from a host server in the cluster. This remote computer is called the management computer.

## Before you begin

Here are a couple of requirements before you begin:

- You must have local administrative privileges on each server of the cluster.

- Each server you want to add to the cluster, as well as the management computer, must all be joined to the same Active Directory domain.

## Run the wizard

These are the major steps in the Create Cluster wizard for creating a cluster:

1. **Get Started** - ensures that each server meets the prerequisites for and features needed for cluster join.
1. **Networking** - assigns and configures network adapters and creates a virtual switch.
1. **Cluster** - validates the cluster is setup correctly.
1. **Storage** - configures virtual storage.
1. **SDN** (optional) - configures software-defined networking.

OK, lets begin:

1. In Windows Admin Center, under All connections, click **Add**.
1. In the **Add resources** panel, under **Windows Server cluster**, select **Create new**.
1. Under **Choose the type of cluster to create**, select **Azure Stack HCI**, then click **Create**. **<== awaiting stretched configuration option in the UI.**

### Step 1: Get Started

Step 1 of the wizard walks you through making sure all prerequisites are met beforehand, adding the servers, installing needed features, and then restarting each server.

1. Review the prerequisites listed in the wizard to ensure each server computer is cluster-ready. When finished, click **Next**.
1. Enter your domain account username *<domain/user>* and password and click **Next**. This account must be a member of the local Administrators group on each server.
1. Enter the fully-qualified domain name (FQDN) of the first server and click **Add**.
1. Repeat Step 3 for each server that will become part of the cluster. There must be a minimum of two servers available for clustering. When finished, click **Next**.
1. Click **Install Features**. When finished, click **Next**.

> [!NOTE]
> The wizard will install the following required features for you:

> - BitLocker
> - Data Center Bridging (if you're using RoCEv2 instead of iWARP network adapters)
> - Failover Clustering
> - FS-Data-Deduplication module
> - Hyper-V
> - RSAT-AD-PowerShell module
> - File Server (for file share witness or hosting file shares)
> - Storage Replica (only installed for stretched cluster type)

1. If prompted, click **Restart servers** and verify that each server has successfully started.

### Step 2: Networking

Step 2 of the wizard walks you through verifying network adapters, assigning IPv4 addresses, subnet masks, and VLAN IDs for each server as applicable.

1. Select **Next: Networking**.
1. Under **Verify network adapters**, wait until the green checkbox appears and select **Next**.
1. Select specific network adapters to use if applicable; otherwise just select **Next**.
1. Under **Edit adapter properties**, make sure each network adapter for each server has a unique IPv4 address, a subnet mask, and a VLAN ID. Hover over each table element and enter or change values as needed. **<== Wizard may fail here**

1. Wait for the virtual switch to be successfully created.

### Step 3: Clustering

Step 3 of the wizard clusters the servers together and performs validation tests to make sure the cluster is set up correctly.

1. Select **Next: Clustering**.
1. Under **Validate the cluster**, select **Validate**.
1. If the **Credential Security Service Provider (CredSSP)** pop-up appears, select **YES** to temporarily enable CredSSP for the wizard to continue. 

    > [!NOTE]
    > Once your cluster is created and the wizard is complete, you will need to disable again CredSSP for security reasons.

1. Review all validation steps and make changes as needed.

    **[STOPPAGE** - wizard validation errors "Validate Network Communication"
Network interfaces hci-srv4.redmond.corp.microsoft.com - vSMB1 and hci-srv3.redmond.corp.microsoft.com - vSMB1 are on the same cluster network, yet address 10.0.0.13 is not reachable from 10.0.0.14 using UDP on port 3343.

    Node hci-srv3.redmond.corp.microsoft.com is reachable from Node hci-srv4.redmond.corp.microsoft.com by only one pair of network interfaces. It is possible that this network path is a single point of failure for communication within the cluster. Please verify that this single path is highly available, or consider adding additional networks to the cluster.].

1. Under **Create the cluster**, enter a name for your cluster.
1. Under **IP addresses**, select **Specify one or more static addresses**, enter `10.0.0.10`, and then click **Add**.
1. Click **Create cluster**.

### Step 4: Storage

Step 4 of the wizard walks you through setting up Storage Spaces Direct and virtual hard disks for your cluster.

> [!NOTE]
> If you are using the Create Cluster wizard to create a stretched cluster type, you will need to create your sites before enabling Storage Spaces Direct.

1. Select **Next: Storage**.
1. Under **Verify drives**, click the **>** icon next to each server to verify that the proper disks are attached.
1. Under **Clean drives**, click **Next**.
1. Under **Validate storage**, click **Next**.
1. Review the results, then click **Next**.
1. Under **Enable Storage Spaces Direct**, click **Next**.

### Step 5 (Optional): SDN

Step 5 of the wizard is only applicable if you selected a **Hyperconverged + SDN** cluster type to create at the start of the wizard. This stage then walks you through setting up software-defined networking (SDN) for your cluster.

1. Select **Next: SDN**.
1. **[PLACEHOLDER STEPS]**
1. **[PLACEHOLDER STEPS]**

## Disable CredSSP

After your server cluster is successfully created, you will need to disable the Credential Security Support Provider (CredSSP) protocol on each server for security purposes. CredSSP needed to be enabled for the Create Cluster wizard. For more information, see [CVE-2018-0886](https://portal.msrc.microsoft.com/security-guidance/advisory/CVE-2018-0886).

1. In Windows Admin Center, under **All connections**, select the first server in your cluster.
1. Under **Overview**, select **Disable CredSSP**. You will see that the red **CredSSP ENABLED** banner at the top disappears.
1. Repeat both steps for each server in your cluster.

## Setup the witness

When using Storage Spaces Direct in a cluster a witness resource is not automatically created as there are no shared disks yet. You can use either an Azure cloud witness or a file share witness.

Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline. Two node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. You can use a file share as a witness, or use an Azure cloud witness. A cloud witness is recommended.

1. In Windows Admin Center, under **Tools**, select **Settings**.
1. In the right pane, select **Witness**.
1. Under **Witness type**, select one of the following:
      - **Cloud witness** - enter your Azure storage account name, key and endpoint
      - **File share witness** - enter the file share path (//server/share)

> [!NOTE]
> The **Disk witness** option is not suitable for stretched clusters.

## Create VMs

The last step is to create and provision VMs on the cluster. VM files should be stored on the server CSV namespace (example: c:\\ClusterStorage\\Volume1), just like VMs on traditional Windows Server failover clusters.

For more information on creating VMs, see [Manage VMs on Azure Stack HCI using Windows PowerShell](https://docs.microsoft.com/azure-stack/hci/manage/vm-powershell).

## Next steps

- Test the performance of your cluster using synthetic workloads prior to bringing up any real workloads. This lets you confirm that the cluster is performing properly. For more info, see [Test Storage Spaces Performance Using Synthetic Workloads in Windows Server](https://docs.microsoft.com/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn894707(v=ws.11)?redirectedfrom=MSDN).

- You can also create a cluster using Windows PowerShell. See [Create an Azure Stack HCI cluster using PowerShell](create-cluster-powershell.md).

- To create a cluster that is stretched across two sites for failover disaster recovery, see [Deploy a stretched cluster].
