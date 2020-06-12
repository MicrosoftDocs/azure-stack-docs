---
title: Create an Azure Stack HCI cluster using Windows Admin Center
description: Learn how to create a server cluster for Azure Stack HCI using Windows Admin Center
author: v-dasis
ms.topic: article
ms.prod: 
ms.date: 06/10/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Create an Azure Stack HCI cluster using Windows Admin Center

> Applies to Azure Stack HCI v20H2

In this article you will learn how to use Windows Admin Center to create an Azure Stack HCI hyperconverged cluster that uses Storage Spaces Direct. The Create Cluster wizard in Windows Admin Center will do most of the heavy lifting for you.

You have a choice between two cluster types:

- Standard cluster with at least two server nodes, all residing in a single site.
- Stretched cluster with at least four server nodes that span across two sites, with two nodes per site.

Sites can be in two different states, different cities, different floors, or different rooms. Using two sites provides disaster recovery and business continuity should a site suffer an outage or failure.

## Before you begin

Here are several requirements before you begin:

- Make sure you have reviewed hardware requirements and considerations in [Planning a cluster].

- You should run Windows Admin Center from a remote computer running Windows 10, rather than from a host server in the cluster. This remote computer is called the management computer.

- You must have administrative privileges for the cluster. Use an account that’s a member of the local Administrators group on each server.

- Each server you want to add to the cluster, as well as the management computer, must all be joined to the same Active Directory domain or fully trusted domain.

## Run the Create Cluster wizard

These are the major steps in the Create Cluster wizard:

1. **Get Started** - ensures that each server meets the prerequisites for and features needed for cluster join.
1. **Networking** - assigns and configures network adapters and creates a virtual switch.
1. **Clustering** - validates the cluster is setup correctly. For stretched clusters, also sets up up the two sites.
1. **Storage** - Configures Storage Spaces Direct and virtual storage.
1. **SDN** (optional) - configures software-defined networking.

After the wizard completes, you will then setup the witness. For stretched clusters, you will also configure Storage Replica and replication between your sites.

OK, lets begin:

1. In Windows Admin Center, under **All connections**, click **Add**.
1. In the **Add resources** panel, under **Windows Server cluster**, select **Create new**.
1. Under **Choose cluster type**, select **Azure Stack HCI**.
1. Select whether or not to deploy Software Defined Networking. 
1. Under **Select server locations**, select one the following:

    - **All servers in one site**
    - **Servers in two sites**

1. When finished, click **Create**.

### Step 1: Get Started

Step 1 of the wizard walks you through making sure all prerequisites are met beforehand, adding the server nodes, installing needed features, and then restarting each server.

1. Review the prerequisites listed in the wizard to ensure each server node is cluster-ready. When finished, click **Next**.
1. On **Add servers to the cluster** page, enter your domain account username *<domain/user>* and password, then click **Next**. This account must be a member of the local Administrators group on each server.
1. Enter the fully-qualified domain name (FQDN) of the first server and click **Add**.
1. Repeat Step 3 for each server that will be part of the cluster. When finished, click **Next**.
1. If needed, on the **Join the servers to a domain​** page, specify the domain and an account that can join servers to the domain. Then optionally rename the servers and click **Next**.
1. Click **Install Features**. When finished, click **Next**.

> [!NOTE]
> The wizard will install the following required features for you:

> - BitLocker
> - Data Center Bridging (for RoCEv2 network adapters)
> - Failover Clustering
> - File Server (for file share witness or hosting file shares)
> - FS-Data-Deduplication module
> - Hyper-V
> - RSAT-AD-PowerShell module
> - Storage Replica (only installed for stretched clusters)

1. For **Install updates**, if needed, click **Install updates**. When complete, click **Next**.
1. For **Solution updates**, if needed, click **Install extension**. When complete, click **Next**.
1. If needed, click **Restart servers** and verify that each server has successfully started.

### Step 2: Networking

Step 2 of the wizard walks you through verifying network adapters, assigning IPv4 addresses, subnet masks, and VLAN ID for each server and creating virtual switches.

1. Select **Next: Networking**.
1. Under **Verify the network adapters**, wait until the green checkbox appears and select **Next**.

1. For **Select management adapters**, select either one for two management adapters to use for each server and then do the following for each server:

- Select the **Description** checkbox. Note that all adapters are selected and that wizard may offer a recommendation for you.
- Unselect the checkboxes for those adapters you don't want used for cluster management.

> [!NOTE]
> It is recommended that you reserve the highest-speed adapters for data traffic and use the lowest-speed adapter for cluster management.

1. When changes have been made, click **Apply and test**.
1. Under **Define networks**, make sure each network adapter for each server has a unique IPv4 address, a subnet mask, and a VLAN ID. Hover over each table element and enter or change values as needed. When finished, click **Apply and test**.
1. Wait until the **Status** column shows **Passed** for each server, then click **Next**.

1. Under **Virtual switch**, change the name  and other configuration settings as needed, then click **Apply and test**. The **Status** column should show **Passed** for each server after the virtual switches have been created.

### Step 3: Clustering

Step 3 of the wizard makes sure everything thus far has been set up correctly, assigns sites in the case of stretched cluster deployments, and then actually creates the cluster.

1. Select **Next: Clustering**.
1. Under **Validate the cluster**, select **Validate**. Validation may take several minutes.

    > [!NOTE]
    > If the **Credential Security Service Provider (CredSSP)** pop-up appears, select **Yes** to temporarily enable CredSSP for the wizard to continue. Once your cluster is created and the wizard is completed, you will need to disable again CredSSP for security reasons.

1. 
1. Review all validation status, download the report to get detailed information on any failures, make changes, then click **Validate again** as needed.
1. Under **Create the cluster**, enter a name for your cluster.
1. Under **Networks**, select the preferred configuration.
1. Under **IP addresses**, select either dynamic or static IP addresses to use.
1. When finished, click **Create cluster**.

1. For stretched clusters, Under **Assign servers to sites**, name the two sites that will be used.

1. Next assign each server to a site. You'll setup replication across sites later. When finished, click **Apply**.

### Step 4: Storage

Step 4 of the wizard walks you through setting up Storage Spaces Direct and virtual hard disks for your cluster.

> [!NOTE]
> For stretched clusters, make sure the sites have been configured properly and server nodes assigned to them before enabling Storage Spaces Direct.

1. Select **Next: Storage**.
1. Under **Verify drives**, click the **>** icon next to each server to verify that the proper disks are working and connected, then click **Next**.
1. Under **Clean drives**, click **Clean drives** to empty the drives. When ready, click **Next**.
1. Under **Validate storage**, click **Next**.
1. Review the validation results. If all is good, click **Next**.
1. Under **Enable Storage Spaces Direct**, click **Enable**.
1. Download the report and review. When all is good, click **Finish**.

### Step 5 (Optional): SDN

Step 5 of the wizard is only applicable if you selected a **Hyperconverged + SDN** cluster type to create at the start of the wizard. This stage then walks you through setting up software-defined networking (SDN) for your cluster.

1. Select **Next: SDN**.
1. **[PLACEHOLDER STEPS]**  **<== need massive help here. Is this on the plate for July release? ==>**

## Disable CredSSP

After your server cluster is successfully created, you will need to disable the Credential Security Support Provider (CredSSP) protocol on each server for security purposes. CredSSP needed to be enabled for the Create Cluster wizard. For more information, see [CVE-2018-0886](https://portal.msrc.microsoft.com/security-guidance/advisory/CVE-2018-0886).

1. In Windows Admin Center, under **All connections**, select the cluster you just created.
1. Under **Tools**, select **Servers**.
1. In the right pane, select the first server in the cluster.
1. Under **Overview**, select **Disable CredSSP**. You will see that the red **CredSSP ENABLED** banner at the top disappears.
1. Repeat steps 3 and 4 for each server in your cluster.

## Setup the witness

When using Storage Spaces Direct in a cluster a witness resource is not automatically created as there are no shared disks yet. You can use either an Azure cloud witness or a file share witness.

Three and higher-node clusters need a witness to be able to withstand two servers failing or being offline. Two-node clusters need a witness so that either server going offline does not cause the other node to become unavailable as well. You can use a file share as a witness, or use an Azure cloud witness. A cloud witness is recommended.

1. In Windows Admin Center, under **Tools**, select **Settings**.
1. In the right pane, select **Witness**.
1. Under **Witness type**, select one of the following:
      - **Cloud witness** - enter your Azure storage account name, key and endpoint
      - **File share witness** - enter the file share path (//server/share)

> [!NOTE]
> The **Disk witness** option is not suitable for stretched clusters.

## Create volumes and setup replication

> [!NOTE]
> This task only applies to stretched clusters.

For stretched clusters, you need to create data and log volumes for each server pair across sites, create a replication group for each site, and setup replication between the sites.

There are two types of stretched clusters, active/passive and active/active.
You can set up active-passive site replication, where there is a preferred site and direction for replication. Active-active replication is where replication can happen bi-directionally from either site. This article covers the active/passive configuration only.

### Active/passive stretched cluster

The following diagram shows Site 1 as the active site with replication to Site 2, a unidirectional replication.

:::image type="content" source="media/cluster/stretch-active-passive.png" alt-text="Active/passive stretched cluster scenario" lightbox="media/cluster/stretch-active-passive.png":::

### Active/active stretched cluster

The following diagram shows both Site 1 and Site 2 as being active sites, with bidirectional replication to the other site.

:::image type="content" source="media/cluster/stretch-active-active.png" alt-text="Active/active stretched cluster scenario" lightbox="media/cluster/stretch-active-active.png":::

OK, let's begin:

1. In Windows Admin Center, under **Tools**, select **Volumes**.
1. In the right pane, select the **Inventory** tab, then select **Create**.
1. In the **Create volume** panel, select **Replicate volume between sites**.
1. Select a replication direction between sites from the drop-down box.
1. Under **Replication mode**, select **Asynchronous** or **Synchronous**.
1. Enter a Source replication group name and a Destination replication group name.
1. Enter the desired size for the log volume.
1. Under **Advanced**, do the following:
     - Enter/change the **Source replication group name**.
     - Enter/change the **Destination replication group name**.
     - To **use blocks already seeded on the target**..., select that checkbox.
     - To **encrypt replication traffic**, select that checkbox.
     - To **enable consistency groups**, select that checkbox.
1. When finished, click **Create**.
1. Verify that a data disk and a log disk are created in your source site, and that corresponding data and log replica disks are created in the destination site.
1. Under **Tools**, select **Storage Replica**.
1. In the right pane, under **Partnerships**, verify that the replication partnership has been successfully created.

## Next steps

- You may want to further validate your cluster. See [Validate server cluster].

- For stretched clusters, you can verify replication between sites. See [Create Azure Stack HCI cluster using PowerShell].

- You can create your virtual machines. See [Manage VMs on Azure Stack HCI](https://docs.microsoft.com/azure-stack/hci/manage/vm).

- You can also create a cluster using Windows PowerShell. See [Create an Azure Stack HCI cluster using PowerShell](create-cluster-powershell.md).