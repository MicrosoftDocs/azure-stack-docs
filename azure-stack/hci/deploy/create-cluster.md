---
title: Create an Azure Stack HCI cluster using Windows Admin Center
description: Learn how to create a server cluster for Azure Stack HCI using Windows Admin Center
author: v-dasis
ms.topic: how-to
ms.date: 12/11/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Create an Azure Stack HCI cluster using Windows Admin Center

> Applies to Azure Stack HCI, version v20H2

In this article you will learn how to use Windows Admin Center to create an Azure Stack HCI cluster that uses Storage Spaces Direct. The Create cluster wizard in Windows Admin Center will do most of the heavy lifting for you. If you'd rather do it yourself with PowerShell, see [Create an Azure Stack HCI cluster using PowerShell](create-cluster-powershell.md). The PowerShell article is also a good source of information for what is going on under the hood of the wizard and for troubleshooting purposes.

You have a choice between creating two cluster types:

- Standard cluster with at least two server nodes, residing in a single site.
- Stretched cluster with at least four server nodes that span across two sites, with at least two nodes per site.

For more information about stretched clusters, see [Stretched clusters overview](../concepts/stretched-clusters.md).

If you’re interested in testing Azure Stack HCI, but have limited or no spare hardware, check out the [Azure Stack HCI Evaluation Guide](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/README.md), where we’ll walk you through experiencing Azure Stack HCI using nested virtualization, either in Azure, or on a single physical system on-premises.

## Before you run the wizard

Before you run the Create Cluster wizard, make sure you:

- Have read the hardware and related requirements in [System requirements](../concepts/system-requirements.md).
- Have read the [Physical network requirements](../concepts/physical-network-requirements.md) and [Host network requirements](../concepts/host-network-requirements.md) for Azure Stack HCI.
- Install the Azure Stack HCI OS on each server in the cluster. See [Deploy the Azure Stack HCI operating system](operating-system.md).
- Have an account that’s a member of the local Administrators group on each server.
- Install Windows Admin Center on a PC or server for management. See [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).
- For stretched clusters, set up your two sites beforehand in Active Directory. But not to worry, the wizard can set them up for you too.

If you're running Windows Admin Center on a server (instead of a local PC), use an account that's a member of the Gateway administrators group, or the local administrators group on the Windows Admin Center server.

Also, your Windows Admin Center management computer must be joined to the same Active Directory domain in which you'll create the cluster, or a fully trusted domain. The servers that you'll cluster don't need to belong to the domain yet; they can be added to the domain during cluster creation.

Here are the major steps in the Create Cluster wizard:

1. **Get Started** - ensures that each server meets the prerequisites for and features needed for cluster join.
1. **Networking** - assigns and configures network adapters and creates the virtual switches for each server.
1. **Clustering** - validates the cluster is set up correctly. For stretched clusters, also sets up up the two sites.
1. **Storage** - Configures Storage Spaces Direct.

After the wizard completes, you set up the cluster witness, register with Azure, and create volumes (which also sets up replication between sites if you're creating a stretched cluster).

Before you start the wizard, make sure you have the latest Windows Admin Center extensions installed, particularly the Cluster Creation extension. To do so:

1. Open Windows Admin Center and click Settings (gear icon) at the upper right.
1. Under **Settings**, select **Extensions**.
1. Select **Cluster Creation** and then click **Install**.
1. Select **Cluster Manager** and click **Install** also while you are at it.

Now you are ready, so let's begin:

1. In Windows Admin Center, under **All connections**, click **Add**.
1. In the **Add or create resources** panel, under **Server clusters**, select **Create new**.
1. Under **1. Choose cluster type**, select **Azure Stack HCI**.

    :::image type="content" source="media/cluster/create-cluster-type.png" alt-text="Create cluster wizard - HCI option" lightbox="media/cluster/create-cluster-type.png":::

1. Under **Select server locations**, select one the following:

    - **All servers in one site**
    - **Servers in two sites** (for stretched cluster)

1. When finished, click **Create**. You will now see the Create Cluster wizard, as shown below.

    :::image type="content" source="media/cluster/create-cluster-wizard.png" alt-text="Create cluster wizard - Get Started" lightbox="media/cluster/create-cluster-wizard.png":::

## Step 1: Get started

Step 1 of the wizard walks you through making sure all prerequisites are met, adding the server nodes, installing needed features, and then restarting each server if needed.

1. Review **1.1 Check the prerequisites** listed in the wizard to ensure each server node is cluster-ready. When finished, click **Next**.
1. On **1.2 Add servers**, enter your account username and password, then click **Next**. This account must be a member of the local Administrators group on each server.
1. Enter the name of the first server you want to add, then click **Add**.
1. Repeat Step 3 for each server that will be part of the cluster. When finished, click **Next**.
1. If needed, on **1.3 Join a domain​**, specify the domain to join the servers to and the account to use. You can optionally rename the servers if you want. Then click **Next**.
1. On **1.4 Install features**, review and add features as needed. When finished, click **Next**.

    The wizard installs the following required features for you:

    - BitLocker
    - Data Center Bridging (for RoCEv2 network adapters)
    - Failover Clustering
    - File Server
    - FS-Data-Deduplication module
    - Hyper-V
    - RSAT-AD-PowerShell module
    - Storage Replica (installed for stretched clusters)

1. On **1.5 Install updates**, click **Install updates** as needed to install any operating system updates. When complete, click **Next**.
1. On **1.6 Install hardware updates**, click **Get updates** as needed to get available vendor hardware updates.
1. Follow the vendor-specific steps to install the updates on your hardware. These steps include performing symmetry and compliance checks on your hardware to ensure a successful update. You may need to re-run some steps.
1. On **1.7 Restart servers**, click **Restart servers** if required. Verify that each server has successfully started.

## Step 2: Networking

Step 2 of the wizard walks you through configuring virtual switches, network adapters, and other networking elements for your cluster. RDMA (both iWARP and RoCE ) network adapters are supported.

For more information on RDMA and Hyper-V host networking for Azure Stack HCI, see [Host network requirements](../concepts/host-network-requirements.md).

> [!NOTE]
> If you see errors listed during any networking or virtual switch steps, select **Apply and test** again.

1. Select **Next: Networking**.
1. On **2.1 Check network adapters**, wait until green checkboxes appear next to each adapter, then select **Next**.

1. On **2.2 Select management adapters**, select one or two management adapters to use for each server. It is mandatory to select at least one of the adapters for management purposes, as the wizard requires at least one dedicated physical NIC for cluster management.  Once an adapter is designated for management, it’s excluded from the rest of the wizard workflow.

    :::image type="content" source="media/cluster/create-cluster-management-adapters.png" alt-text="Create cluster wizard - Select management adapters" lightbox="media/cluster/create-cluster-management-adapters.png":::

    Management adapters have two configuration options:

    - **One physical network adapter for management**. For this option, both DHCP or static IP address assignment is supported.

    - **Two physical network adapters teamed for management**. When a pair of adapters are teamed, only static IP address assignment is supported. If the selected adapters use DHCP addressing (either for one or both), the DHCP IP addresses would be converted to static IP addresses before virtual switch creation.

    By using teamed adapters, you have a single connection to multiple switches but only use a single IP address. Load-balancing becomes available and fault-tolerance is instant instead of waiting for DNS records to update.

    Now do the following for each server:

    - Select the **Description** checkbox. Note that all adapters are selected and that the wizard may offer a recommendation for you.
    - Clear the checkboxes for those adapters you don't want used for cluster management.

    > [!NOTE]
    > You can use 1 Gb adapters as management adapters, but we recommend using 10 Gb or faster adapters for carrying storage and workload (VM) traffic.

1. When changes have been made, click **Apply and test**.
1. Under **Define networks**, make sure each network adapter for each server has a unique static IP address, a subnet mask, and a VLAN ID. Hover over each table element and enter or change values as needed. When finished, click **Apply and test**.

    > [!NOTE]
    > To support VLAN ID configuration for the cluster, all networks adapters on all servers must support the VLANID property.

1. Wait until the **Status** column shows **Passed** for each server, then click **Next**. This step verifies network connectivity between all adapters with the same subnet and VLAN ID. The provided IP addresses are transferred from the physical adapter to the virtual adapters once the virtual switches are created in the next step. It may take several minutes to complete depending on the number of adapters configured.

1. Under **2.3 Virtual switch**, select one of the following options as applicable. Depending on how many network adapters there are, not all options may be available:

    - **Skip virtual switch creation** - choose if you want set up virtual switches later.
    - **Create one virtual switch for compute and storage together** - choose if you want to use the same virtual switch for your VMs and Storage Spaces Direct. This is the "converged" option.
    - **Create one virtual switch for compute only** - choose if you want to use a virtual switch for your VMs only.
    - **Create two virtual switches** - choose if you want a dedicated virtual switch each for VMs and for Storage Spaces Direct.

        :::image type="content" source="media/cluster/create-cluster-virtual-switches.png" alt-text="Create cluster wizard - virtual switches" lightbox="media/cluster/create-cluster-virtual-switches.png":::

    > [!NOTE]
    > If you are going to deploy Network Controller for SDN (in **Step 5: SDN** of the wizard), you will need a virtual switch. So if you opt out of creating a virtual switch here and don't create one outside the wizard, the wizard won't deploy Network Controller.

    The following table shows which virtual switch configurations are supported and enabled for various network adapter configurations:

    | Option | 1-2 adapters | 3+ adapters | teamed adapters |
    | :------------- | :--------- |:--------| :---------|
    | single switch (compute + storage) | enabled | enabled  | not supported |
    | single switch (compute only) | not supported| enabled | enabled |
    | two switches | not supported | enabled | enabled |

1. Change the name of a switch and other configuration settings as needed, then click **Apply and test**. The **Status** column should show **Passed** for each server after the virtual switches have been created.

1. Step **2.4 RDMA** is optional. If you are using RDMA, select the **Configure RDMA (Recommended)** checkbox and click **Next**.

    :::image type="content" source="media/cluster/create-cluster-rdma.png" alt-text="Create cluster wizard - configure RDMA" lightbox="media/cluster/create-cluster-rdma.png":::

    For information on assigning bandwidth reservations, see the [Traffic bandwidth allocation](../concepts/host-network-requirements.md#traffic-bandwidth-allocation) section in [Host network requirements](../concepts/host-network-requirements.md).

1. Select **Advanced**, then select the **Data Center Bridging (DCB)** checkbox.

1. Under **Cluster heartbeat**, assign a priority level and a bandwidth reservation percentage.

1. Under **Storage**, assign a priority level and a bandwidth reservation percentage.

1. When finished, select **Apply changes** and click **Next**.

1. On **2.5 Define networks**, review and edit the Name, IP address, Subnet mask, VLAN ID, and Default gateway fields for each adapter listed.

    :::image type="content" source="media/cluster/create-cluster-define-networks.png" alt-text="Create cluster wizard - Define networks" lightbox="media/cluster/create-cluster-define-networks.png":::

1. When finished, click **Apply and test**. You may need to **Retry connectivity test** if status is not OK for an adapter.

## Step 3: Clustering

Step 3 of the wizard makes sure everything thus far has been set up correctly, automatically sets up two sites in the case of stretched cluster deployments, and then actually creates the cluster. You can also set up your sites beforehand in Active Directory.

1. Select **Next: Clustering**.
1. On **3.1 Validate the cluster**, select **Validate**. Validation may take several minutes.

    If the **Credential Security Service Provider (CredSSP)** pop-up appears, select **Yes** to temporarily enable CredSSP for the wizard to continue. Once your cluster is created and the wizard has completed, you'll disable CredSSP to increase security. If you experience issues with CredSSP, see [Troubleshoot CredSSP](../manage/troubleshoot-credssp.md) for more information.

1. Review all validation statuses, download the report to get detailed information on any failures, make changes, then click **Validate again** as needed. You can **Download report** as well. Repeat again as necessary until all validation checks pass. When all is OK, click **Next**.
1. On **3.2 Create cluster**, enter a name for your cluster.

    :::image type="content" source="media/cluster/create-cluster.png" alt-text="Create cluster wizard - Create cluster" lightbox="media/cluster/create-cluster.png":::

1. Under **IP address**, select either static or dynamic IP addresses to use.
1. Select **Advanced**. You have a couple of options here:

    - **Register the cluster with DNS and Active Directory**
    - **Add eligible storage to the cluster (recommended)**

1. Under **Networks**, select whether to **Use all networks (recommended)** or **Specify one or more networks not to use**.

1. When finished, click **Create cluster**.

1. For stretched clusters, on **3.3 Assign servers to sites**, name the two sites that will be used.

1. Next assign each server to a site. You'll set up replication across sites later. When finished, click **Apply changes**.

## Step 4: Storage

Step 4 of the wizard walks you through setting up Storage Spaces Direct for your cluster.

1. Select **Next: Storage**.
1. On **4.1 Clean drives**, you can optionally select **Erase drives** if it makes sense for your deployment.
1. On **4.2 Check drives**, click the **>** icon next to each server to verify that the disks are working and connected. If all is OK, click **Next**.
1. On **4.3 Validate storage**, click **Next**.
1. Download and review the validation report. If all is good, click **Next**. If not, run **Validate again**.
1. On **4.4 Enable Storage Spaces Direct**, click **Enable**.
1. Download and review the report. When all is good, click **Finish**. 
1. Select **Go to connections list**.
1. After a few minutes, you should see your cluster in the list. Select it to view the cluster overview page.

It can take some time for the cluster name to be replicated across your domain, especially if workgroup servers have been newly added to Active Directory. Although the cluster might be displayed in Windows Admin Center, it might not be available to connect to yet.

If resolving the cluster isn't successful after some time, in most cases you can substitute a server name instead of the cluster name.

## Step 5: SDN (optional)

This optional step walks you through setting up the Network Controller component of [Software Defined Networking (SDN)](../concepts/software-defined-networking.md). Once the Network Controller is set up, you can configure other components of SDN such as Software Load Balancer (SLB) and RAS Gateway as needed.

> [!NOTE]
> The wizard does not configure SLB and RAS Gateway for SDN. You can use SDN Express scripts to configure these components. For information on how to do this, see the [SDNExpress GitHub repo](https://github.com/microsoft/SDN/tree/master/SDNExpress/scripts).

> [!NOTE]
> SDN is not supported for stretched clusters.

1. Select **Next: SDN**.

    :::image type="content" source="media/cluster/create-cluster-network-controller.png" alt-text="Create cluster wizard - SDN Network Controller" lightbox="media/cluster/create-cluster-network-controller.png":::

1. On **5.1 Define the Network Controller cluster**, under **Host**, enter a name for the Network Controller. This is the DNS name used by management clients (such as Windows Admin Center) to communicate with the Network Controller.
1. Specify a path to the Azure Stack HCI VHD file. Use **Browse** to find it quicker.
1. Specify the number of VMs to be dedicated for Network Controller. At least three VMs are recommended for high availability.
1. Under **Network**, enter the VLAN ID of the management network. Network Controller needs connectivity to the same management network as the hosts to communicate and configure the hosts.

    > [!NOTE]
    > Network Controller VMs use the virtual switch used for cluster management if available, otherwise they use the "Compute" virtual switch like the rest of the cluster VMs. For more information, see the [Network Controller requirements](../concepts/network-controller.md#network-controller-requirements) section in [Plan to deploy Network Controller](../concepts/network-controller.md).

1. For **VM network addressing**, select either **DHCP** or **Static**.
1. If you selected **DHCP**, enter the name for the Network Controller VMs.
1. If you selected **Static**, specify the following:
    1. IP address.
    1. Subnet prefix.
    1. Default gateway.
    1. One or more DNS servers. Click **Add** to add additional DNS servers.
1. Under **Credentials**, enter the username and password used to join the Network Controller VMs to the cluster domain.
1. Enter the local administrative password for these VMs.
1. Under **Advanced**, enter the path to the VMs.
1. Enter values for **MAC address pool start** and **MAC address pool end**.
1. When finished, click **Next**.
1. On **Deploy the Network Controller**, wait until the wizard completes its job. Stay on this page until all progress tasks are complete. Then click **Finish**.

1. After Network Controller VMs are created, configure dynamic DNS updates for the Network Controller cluster name on the DNS server. For information on how to do this, see [Configure dynamic DNS registration for Network Controller](/windows-server/networking/sdn/plan/installation-and-preparation-requirements-for-deploying-network-controller#step-3-configure-dynamic-dns-registration-for-network-controller).

1. If Network Controller deployment fails, do the following before you try this again:

- Stop and delete any Network Controller VMs that the wizard created.  

- Clean up any VHD mount points that the wizard created.  

- Ensure you have at least 50-100GB of free space on your Hyper-V hosts.  

## After you complete the wizard

After the wizard has completed, there are still some important tasks you need to complete.

The first task is to disable the Credential Security Support Provider (CredSSP) protocol on each server for security purposes. Remember that CredSSP needed to be enabled for the wizard. If you experience issues with CredSSP, see [Troubleshoot CredSSP](../manage/troubleshoot-credssp.md) for more information.

1. In Windows Admin Center, under **All connections**, select the cluster you just created.
1. Under **Tools**, select **Servers**.
1. In the right pane, select the first server in the cluster.
1. Under **Overview**, select **Disable CredSSP**. You will see that the red **CredSSP ENABLED** banner at the top disappears.
1. Repeat steps 3 and 4 for each server in your cluster.

OK, now here are the other tasks you will need to do:

- Setup a cluster witness. See [Set up a cluster witness](witness.md).
- Create your volumes. See [Create volumes](../manage/create-volumes.md).
- For stretched clusters, create your volumes and setup replication. See [Create stretched cluster volumes and set up replication](../manage/create-stretched-volumes.md).

## Next steps

- Register your cluster with Azure. See [Manage Azure registration](../manage/manage-azure-registration.md).
- Do a final validation of the cluster. See [Validate an Azure Stack HCI cluster](validate.md)
- Provision your VMs. See [Manage VMs on Azure Stack HCI using Windows Admin Center](../manage/vm.md).
- You can also deploy a cluster using PowerShell. See [Create an Azure Stack HCI cluster using PowerShell](create-cluster-powershell.md).
- You can also deploy Network Controller using PowerShell. See [Deploy Network Controller using PowerShell](network-controller-powershell.md).
