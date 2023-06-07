---
title: Create an Azure Stack HCI cluster using Windows Admin Center
description: Learn how to create a server cluster for Azure Stack HCI using Windows Admin Center
author: JasonGerend
ms.topic: how-to
ms.date: 04/17/2023
ms.author: jgerend
ms.reviewer: shsathee
---

# Create an Azure Stack HCI cluster using Windows Admin Center

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

Now that you've deployed the Azure Stack HCI operating system, you'll learn how to use Windows Admin Center to create an Azure Stack HCI cluster that uses Storage Spaces Direct, and, optionally, Software Defined Networking. The Create Cluster wizard in Windows Admin Center will do most of the heavy lifting for you. If you'd rather do it yourself with PowerShell, see [Create an Azure Stack HCI cluster using PowerShell](create-cluster-powershell.md). The PowerShell article is also a good source of information for what is going on under the hood of the wizard and for troubleshooting purposes.

> [!NOTE]
> If you are doing a single server installation of Azure Stack HCI 21H2, use [PowerShell](../deploy/create-cluster-powershell.md#using-windows-powershell) to create the cluster.

If you're interested in testing Azure Stack HCI but have limited or no spare hardware, see the [Azure Stack HCI Evaluation Guide](../guided-quick-deploy-eval.yml?tabs=global-admin), where we'll walk you through experiencing Azure Stack HCI using nested virtualization inside an Azure VM. Or try the [Create a VM-based lab for Azure Stack HCI](tutorial-private-forest.md) tutorial to create your own private lab environment using nested virtualization on a server of your choice to deploy VMs running Azure Stack HCI for clustering.

## Cluster creation workflow

Here's the workflow for creating a cluster in Windows Admin Center:

1. [Complete the prerequisites](#prerequisites).
1. [Start the Create Cluster wizard](#start-the-create-cluster-wizard).
1. Complete the following steps in the Create Cluster wizard:
    1. [**Step 1: Get Started**](#step-1-get-started). Ensures that each server meets the prerequisites and features needed for cluster join.
    1. [**Step 2: Networking**](#step-2-networking). Assigns and configures network adapters and creates the virtual switches for each server.
    1. [**Step 3: Clustering**](#step-3-clustering). Validates the cluster is set up correctly. For stretched clusters, also sets up the two sites.
    1. [**Step 4: Storage**](#step-4-storage). Configures Storage Spaces Direct.
    1. [**Step 5: SDN**](#step-5-sdn-optional). (Optional) Sets up a Network Controller for SDN deployment.

After you're done creating a cluster in the **Create Cluster** wizard, complete these post-cluster creation steps:

- [Set up a cluster witness](../manage/witness.md). This is highly recommended for all clusters with at least two nodes.
- [Register with Azure](register-with-azure.md). Your cluster is not fully supported until your registration is active.
- [Validate an Azure Stack HCI cluster](validate.md). Your cluster is ready to work in a production environment after completing this step.

## Prerequisites

Before you run the **Create Cluster** wizard in Windows Admin Center, you must complete the following prerequisites.

> [!WARNING]
> Running the wizard before completing the prerequisites can result in a failure to create the cluster.

- Review the hardware and related requirements in [System requirements](../concepts/system-requirements.md).  

- Consult with your networking team to identify and understand [Physical network requirements](../concepts/physical-network-requirements.md), [Host network requirements](../concepts/host-network-requirements.md), and [Firewall requirements](../concepts/firewall-requirements.md). Especially review the [Network Reference patterns](../plan/network-patterns-overview.md), which provide example network designs. Also, determine how you'd like to configure host networking, using [Network ATC](network-atc.md) or manually.

- Install the Azure Stack HCI operating system on each server in the cluster. See [Deploy the Azure Stack HCI operating system](operating-system.md).

- Obtain an account that's a member of the local Administrators group on each server.

- Have at least two servers to cluster; four if creating a stretched cluster (two in each site). To instead deploy Azure Stack HCI on a single server, see [Deploy Azure Stack HCI on a single server](single-server.md).

- Ensure all servers are in the same time zone as your local domain controller.

- Install the latest version of Windows Admin Center on a PC or server for management. See [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install).

- Ensure that Windows Admin Center and your domain controller are not installed on the same system. Also, ensure that the domain controller is not hosted on the Azure Stack HCI cluster or one of the nodes in the cluster.

- If you're running Windows Admin Center on a server (instead of a local PC), use an account that's a member of the Gateway Administrators group, or the local Administrators group on the Windows Admin Center server.

- Verify that your Windows Admin Center management computer is joined to the same Active Directory domain in which you'll create the cluster, or joined to a fully trusted domain. The servers that you'll cluster don't need to belong to the domain yet; they can be added to the domain during cluster creation.

- If you're using an integrated system from a Microsoft hardware partner, install the latest version of vendor extensions on Windows Admin Center to help keep the integrated hardware and firmware up to date. To install them, open Windows Admin Center and click **Settings** (gear icon) at the upper right. Select any applicable hardware vendor extensions, and click **Install**.

- For stretched clusters, set up your two sites beforehand in Active Directory. Alternatively, the wizard can set them up for you too. For more information about stretched clusters, see the [Stretched clusters overview](../concepts/stretched-clusters.md).

## Start the Create Cluster wizard

To start the Create Cluster wizard in Windows Admin Center:

1. Log in to Windows Admin Center.
1. Under **All connections**, click **Add**.
1. In the **Add or create resources** panel, under **Server clusters**, select **Create new**.
1. Under **Choose the cluster type**, select **Azure Stack HCI**.

    :::image type="content" source="media/cluster/create-cluster-type.png" alt-text="Create cluster wizard - HCI option" lightbox="media/cluster/create-cluster-type.png":::

1. Under **Select server locations**, select one the following:

    - **All servers in one site**
    - **Servers in two sites** (for stretched cluster)

1. When finished, click **Create**. You'll see the Create Cluster wizard, as shown below.

    :::image type="content" source="media/cluster/create-cluster-wizard.png" alt-text="Create cluster wizard - Get Started" lightbox="media/cluster/create-cluster-wizard.png":::

   Proceed to the next step in the cluster creation workflow, [Step 1: Get started](#step-1-get-started).

## Step 1: Get started

Step 1 of the wizard walks you through making sure all prerequisites are met, adding the server nodes, installing needed features, and then restarting each server if needed.

1. Review **1.1 Check the prerequisites** listed in the wizard to ensure each server node is cluster-ready. When finished, click **Next**.
1. On **1.2 Add servers**, enter your account username using the format **domain\username**. Enter your password, then click **Next**. This account must be a member of the local Administrators group on each server.
1. Enter the name of the first server you want to add, then click **Add**. When you add servers, make sure to use a fully qualified domain name.
1. Repeat Step 3 for each server that will be part of the cluster. When you're finished, select **Next**.
1. If needed, on **1.3 Join a domain​**, specify the domain to join the servers to and the account to use. You can optionally rename the servers if you want. Then click **Next**.
1. On **1.4 Install features**, review and add features as needed. When finished, click **Next**.

    The wizard lists and installs required features for you, including the following options:

    - Data Deduplication
    - Hyper-V
    - BitLocker Drive Encryption
    - Data Center Bridging (for RoCEv2 network adapters)
    - Failover Clustering
    - Network ATC
    - Active Directory module for Windows PowerShell
    - Hyper-V module for Windows PowerShell

1. On **1.5 Install updates**, click **Install updates** as needed to install any operating system updates. When complete, click **Next**.
1. On **1.6 Install hardware updates**, click **Get updates** as needed to get available vendor hardware updates. If you don't install the updates now, we recommend manually installing the latest networking drivers before continuing. Updated drivers are required if you want to use Network ATC to configure host networking.

    > [!NOTE]
    > Some extensions require extra configuration on the servers or your network, such as configuring the baseboard management controller (BMC). Consult your vendor's documentation for details.

1. Follow the vendor-specific steps to install the updates on your hardware. These steps include performing symmetry and compliance checks on your hardware to ensure a successful update. You may need to re-run some steps. 
1. On **1.7 Restart servers**, click **Restart servers** if required. Verify that each server has successfully started.
1. On **1.8 Choose host networking**, select one of the following:
    - **Use Network ATC to deploy and manage networking (Recommended)**. We recommend using this option for configuring host networking. Network ATC provides an intent-based approach to host network deployment and helps simplify the deployment and network configuration management for Azure Stack HCI clusters. For more information about using Network ATC, see [Network ATC](network-atc.md).
    - **Manually configure host networking**. Select this option to manually configure host networking. For more information about configuring RDMA and Hyper-V host networking for Azure Stack HCI, see [Host network requirements](../concepts/host-network-requirements.md).
1. Select **Next: Networking** to proceed to [Step 2: Networking](#step-2-networking).

## Step 2: Networking

Step 2 of the wizard walks you through configuring the host networking elements for your cluster. RDMA (both iWARP and RoCE) network adapters are supported.

Depending on the option you selected in **1.8 Choose host networking** of [Step 1: Get started](#step-1-get-started) above, refer to one of the following tabs to configure host networking for your cluster:

### [Use Network ATC to deploy and manage networking (Recommended)](#tab/use-network-atc-to-deploy-and-manage-networking-recommended)

This is the recommended option for configuring host networking. For more information about Network ATC, see [Network ATC overview](../concepts/network-atc-overview.md).

1. On **2.1 Verify network adapters**, review the list displayed, and exclude or add any adapters you want to cluster. Wait for a couple of minutes for the adapters to show up. Only adapters with matching names, interface descriptions, and link speed on each server are displayed. All other adapters are hidden.

    :::image type="content" source="media/cluster/create-cluster-atc-verify-adaptor.png" alt-text="Create cluster wizard - Verify network adapters" lightbox="media/cluster/create-cluster-atc-verify-adaptor.png":::

1. If you don't see your adapters in the list, click **Show hidden adapters** to see all the available adapters and then select the missing adapters.

1. On the **Select the cluster network adapters** page, select the checkbox for any adapters listed that you want to cluster. The adapters must have matching names, interface descriptions, and link speeds on each server. You can rename the adapters to match, or just select the matching adapters. When finished, click **Close**.

    :::image type="content" source="media/cluster/create-cluster-atc-see-all-adaptor.png" alt-text="Create cluster wizard - See all adapters" lightbox="media/cluster/create-cluster-atc-see-all-adaptor.png":::

1. The selected adapters will now display under **Adapters available on all servers**. When finished selecting and verifying adapters, click **Next**.  

1. On **2.2 Define intents**, under **Intent 1**, do the following:
    - For **Traffic types**, select a traffic type from the dropdown list. You can add the **Management** and **Storage** intent types to exactly one intent while the **Compute** intent type can be added to one or more intents. For more information, see [Network ATC traffic types](../concepts/host-network-requirements.md#network-traffic-types).
    - For **Intent name**, enter a friendly name for the intent.
    - For **Network adapters**, select an adapter from the dropdown list.  
    - (Optional) Click **Select another adapter for this traffic** if needed.
    
    For recommended intent configurations, see the network reference pattern that matches your deployment:

    - [Storage switchless, single switch](../plan/two-node-switchless-single-switch.md#network-atc-intents)
    - [Storage switchless, two switches](../plan/two-node-switchless-two-switches.md#network-atc-intents)
    - [Storage switched, non-converged](../plan/two-node-switched-non-converged.md#network-atc-intents)
    - [Storage switched, fully converged](../plan/two-node-switched-converged.md#network-atc-intents)
    
1.  (Optional) After an intent is added, select **Customize network settings** to modify its network settings. When finished, select **Save**.

1. (Optional) To add another intent, select **Add an intent**, and repeat step 5 and optionally step 6.

1. When finished defining network intents, select **Next**.

1. On **2.3: Provide network details**, for each storage traffic adapter listed, enter the following or use the default values (recommended):
    - Subnet mask/CIDR
    - VLAN ID
    - IP address (this is usually on a private subnet such as 10.71.1.x and 10.71.2.x) 

    :::image type="content" source="media/cluster/create-cluster-atc-provide-network.png" alt-text="Create cluster wizard - Provide network details" lightbox="media/cluster/create-cluster-atc-provide-network.png":::

1. Select **Next: Clustering** to proceed to [Step 3: Clustering](#step-3-clustering).

### [Manually configure host networking](#tab/manually-configure-host-networking)

Follow these steps to manually configure host networking.

> [!NOTE]
> If you see errors listed during any networking or virtual switch steps, select **Apply and test** again.

1. On **2.1 Check network adapters**, wait until green checkboxes appear next to each adapter, then select **Next**.

1. On **2.2 Select management adapters**, select one or two management adapters to use for each server. It is mandatory to select at least one of the adapters for management purposes, as the wizard requires at least one dedicated physical NIC for cluster management.  Once an adapter is designated for management, it's excluded from the rest of the wizard workflow.

    :::image type="content" source="media/cluster/create-cluster-management-adapters.png" alt-text="Create cluster wizard - Select management adapters" lightbox="media/cluster/create-cluster-management-adapters.png":::

    Management adapters have two configuration options:

    - **One physical network adapter for management**. For this option, both DHCP or static IP address assignment is supported.

    - **Two physical network adapters teamed for management**. When a pair of adapters is teamed, only static IP address assignment is supported. If the selected adapters use DHCP addressing (either for one or both), the DHCP IP addresses would be converted to static IP addresses before virtual switch creation.

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

    > [!NOTE]
    > We recommend using separate subnets in switchless deployments. For more information on switchless connections, see [Using switchless](../concepts/physical-network-requirements.md#using-switchless).

1. Wait until the **Status** column shows **Passed** for each server, then click **Next**. This step verifies network connectivity between all adapters with the same subnet and VLAN ID. The provided IP addresses are transferred from the physical adapter to the virtual adapters once the virtual switches are created in the next step. It may take several minutes to complete depending on the number of adapters configured.

1. Under **2.3 Virtual switch**, select one of the following options as applicable. Depending on how many network adapters there are, not all options may be available:

    - **Skip virtual switch creation** - choose if you want set up virtual switches later.
    - **Create one virtual switch for compute and storage together** - choose if you want to use the same virtual switch for your VMs and Storage Spaces Direct. This is the "converged" option.
    - **Create one virtual switch for compute only** - choose if you want to use a virtual switch for your VMs only.
    - **Create two virtual switches** - choose if you want a dedicated virtual switch each for VMs and for Storage Spaces Direct.

        > [!NOTE]
        > If you are going to deploy Network Controller for SDN (in **Step 5: SDN** of the wizard), you will need a virtual switch. So if you opt out of creating a virtual switch here and don't create one outside the wizard, the wizard won't deploy Network Controller.

        :::image type="content" source="media/cluster/create-cluster-virtual-switches.png" alt-text="Create cluster wizard - virtual switches" lightbox="media/cluster/create-cluster-virtual-switches.png":::

    The following table shows which virtual switch configurations are supported and enabled for various network adapter configurations:

    | Option | 1-2 adapters | 3+ adapters | teamed adapters |
    | :------------- | :--------- |:--------| :---------|
    | single switch (compute + storage) | enabled | enabled  | not supported |
    | single switch (compute only) | not supported| enabled | enabled |
    | two switches | not supported | enabled | enabled |

1. Change the name of a switch and other configuration settings as needed, then click **Apply and test**. The **Status** column should show **Passed** for each server after the virtual switches have been created.

1. Step **2.4 RDMA** is optional. If you're using RDMA, select the **Configure RDMA (Recommended)** checkbox and click **Next**.

    :::image type="content" source="media/cluster/create-cluster-rdma.png" alt-text="Create cluster wizard - configure RDMA" lightbox="media/cluster/create-cluster-rdma.png":::

    For information on assigning bandwidth reservations, see the [Traffic bandwidth allocation](../concepts/host-network-requirements.md#traffic-bandwidth-allocation) section in [Host network requirements](../concepts/host-network-requirements.md).

1. Select **Advanced**, then select the **Data Center Bridging (DCB)** checkbox.

1. Under **Cluster heartbeat**, assign a priority level and a bandwidth reservation percentage.

1. Under **Storage**, assign a priority level and a bandwidth reservation percentage.

1. When finished, select **Apply changes** and click **Next**.

1. On **2.5 Define networks**, review and edit the Name, IP address, Subnet mask, VLAN ID, and Default gateway fields for each adapter listed.

    :::image type="content" source="media/cluster/create-cluster-define-networks.png" alt-text="Create cluster wizard - Define networks" lightbox="media/cluster/create-cluster-define-networks.png":::

1. When finished, click **Apply and test**. You may need to **Retry connectivity test** if status is not OK for an adapter.
1. Select **Next: Clustering** to proceed to [Step 3: Clustering](#step-3-clustering).

---

## Step 3: Clustering

Step 3 of the wizard makes sure everything thus far is set up correctly, automatically sets up two sites in the case of stretched cluster deployments, and then actually creates the cluster. You can also set up your sites beforehand in Active Directory.

1. On **3.1 Create the cluster**, specify a unique name for the cluster.

1. Under **IP address**, do one of the following:
    - Specify one or more static addresses. The IP address must be entered in the following format: IP address/current subnet length. For example: 10.0.0.200/24.
    - Assign address dynamically with DHCP.

1. When finished, select **Create cluster**. This can take a while to complete. 

    If you get the error "Failed to reach cluster through DNS," select the **Retry connectivity checks** button. You might have to wait several hours before it succeeds on larger networks due to DNS propagation delays.

    > [!IMPORTANT]
    >  If you failed to create a cluster, do not click the **Back** button instead of the **Retry connectivity checks button**. If you select **Back**, the Cluster Creation wizard exits prematurely, and can potentially reset the entire process.

    If you encounter issues with deployment after the cluster is created and you want to restart the Cluster Creation wizard, first remove (destroy) the cluster. To do so, see  [Remove a cluster](/azure-stack/hci/manage/cluster-powershell#remove-a-cluster).

1. The next step appears only if you selected **Use Network ATC to deploy and manage networking (Recommended)** for step **1.8 Choose host networking**.

    In **Deploy host networking settings**, select **Deploy** to apply the Network ATC intents you defined earlier. If you chose to manually deploy host networking in step 1.8 of the Cluster Creation wizard, you won't see this page.

1. On **3.2 Deploy host networking settings**, select **Deploy** to apply the 
 Network ATC intents you defined earlier. This can take a few minutes to complete. When finished, select **Next**.

1. On **3.3 Validate cluster**, select **Validate**. Validation can take several minutes. Note that the in-wizard validation is not the same as the post-cluster creation validation step, which performs additional checks to catch any hardware or configuration problems before the cluster goes into production. If you experience issues with cluster validation, see [Troubleshoot cluster validation reporting](../manage/validate-qos.md).

    If the **Credential Security Service Provider (CredSSP)** pop-up appears, select **Yes** to temporarily enable CredSSP for the wizard to continue. Once your cluster is created and the wizard has completed, you'll disable CredSSP to increase security. If you experience issues with CredSSP, see [Troubleshoot CredSSP](../manage/troubleshoot-credssp.md).

1. Review all validation statuses, download the report to get detailed information on any failures, make changes, then click **Validate again** as needed. You can **Download report** as well. Repeat again as necessary until all validation checks pass. When all is OK, click **Next**.

1. Select **Advanced**. You have a couple of options here:

    - **Register the cluster with DNS and Active Directory**
    - **Add eligible storage to the cluster (recommended)**

1. Under **Networks**, select whether to **Use all networks (recommended)** or **Specify one or more networks not to use**.

1. When finished, click **Create cluster**.

1. For stretched clusters, on **3.3 Assign servers to sites**, name the two sites that will be used.

1. Next assign each server to a site. You'll set up replication across sites later. When finished, click **Apply changes**.

1. Select **Next: Storage** to proceed to [Step 4: Storage](#step-4-storage).

## Step 4: Storage

Complete these steps after finishing the Create Cluster wizard. 
Step 4 walks you through setting up Storage Spaces Direct for your cluster.

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

1. (Optional) Select **Next: SDN** to proceed to [Step 5: SDN](#step-5-sdn-optional).

## Step 5: SDN (optional)

This optional step walks you through setting up the Network Controller component of [Software Defined Networking (SDN)](../concepts/software-defined-networking.md). Once the Network Controller is set up, you can configure other SDN components such as Software Load Balancer (SLB) and RAS Gateway as per your requirements. See the [Phased deployment](../concepts/plan-software-defined-networking-infrastructure.md#phased-deployment) section of the planning article to understand what other SDN components you might need.

You can also deploy Network Controller using SDN Express scripts. See [Deploy an SDN infrastructure using SDN Express](../manage/sdn-express.md).

> [!NOTE]
> The Create Cluster wizard does not currently support configuring SLB And RAS gateway. You can use [SDN Express scripts](https://github.com/microsoft/SDN/tree/master/SDNExpress/scripts) to configure these components. Also, SDN is not supported or available for stretched clusters.

:::image type="content" source="media/cluster/create-cluster-network-controller.png" alt-text="Create cluster wizard - create Network Controller" lightbox="media/cluster/create-cluster-network-controller.png":::

1. Under **Host**, enter a name for the Network Controller. This is the DNS name used by management clients (such as Windows Admin Center) to communicate with Network Controller. You can also use the default populated name.
1. Download the Azure Stack HCI VHDX file. For more information, see [Download the VHDX file](../manage/sdn-express.md#download-the-vhdx-file).
1. Specify the path where you downloaded the VHDX file. Use **Browse** to find it quicker.
1. Specify the number of VMs to be dedicated for Network Controller. Three VMs are strongly recommended for production deployments.
1. Under **Network**, enter the VLAN ID of the management network. Network Controller needs connectivity to same management network as the Hyper-V hosts so that it can communicate and configure the hosts.
1. For **VM network addressing**, select either **DHCP** or **Static**.
1. If you selected **DHCP**, enter the name for the Network Controller VMs. You can also use the default populated names.
1. If you selected **Static**, do the following:
     - Specify an IP address.
     - Specify a subnet prefix.
     - Specify the default gateway.
     - Specify one or more DNS servers. Click **Add** to add additional DNS servers.
1. Under **Credentials**, enter the username and password used to join the Network Controller VMs to the cluster domain.
1. Enter the local administrative password for these VMs.
1. Under **Advanced**, enter the path to the VMs. You can also use the default populated path.
1. Enter values for **MAC address pool start** and **MAC address pool end**. You can also use the default populated values.
1. When finished, click **Next**.
1. Wait until the wizard completes its job. Stay on this page until all progress tasks are complete. Then click **Finish**.

> [!NOTE]
> After Network Controller VM(s) are created, you must configure [dynamic DNS updates](/troubleshoot/windows-server/networking/configure-dns-dynamic-updates-windows-server-2003) for the Network Controller cluster name on the DNS server.

If Network Controller deployment fails, do the following before you try this again:

- Stop and delete any Network Controller VMs that the wizard created.

- Clean up any VHD mount points that the wizard created.

- Ensure you have at least 50-100GB of free space on your Hyper-V hosts.

## Step 6: Remove a Cluster (optional)

There are situations in which you may need to actually remove the cluster which you created in Step 3. If so, choose the **Remove the Cluster** option in the Cluster Creation wizard.

For more information about removing a cluster, see [Remove a cluster](/azure-stack/hci/manage/cluster-powershell#remove-a-cluster).

## Next steps

To perform the next management task related to this article, see:
> [!div class="nextstepaction"]
> [Set up a cluster witness](../manage/witness.md)
