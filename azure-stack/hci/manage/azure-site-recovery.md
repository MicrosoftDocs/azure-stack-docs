---
title: Protect your Hyper-V Virtual Machine workloads on Azure Stack HCI with Azure Site Recovery. (preview)
description: Use Azure Site Recovery to protect Hyper-V VM workloads running on your Azure Stack HCI clusters. (preview)
ms.topic: article
author: alkohli
ms.author: alkohli
ms.date: 05/12/2023
---
<!-- This article is used by the Windows Server Docs, all links must be site relative (except include files). For example, /azure-stack/hci/manage/azure-site-recovery -->

# Protect VM workloads with Azure Site Recovery on Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-22h2-later](../../includes/hci-applies-to-22h2-later.md)]

This guide describes how to protect Windows and Linux VM workloads running on your Azure Stack HCI clusters if there is a disaster. You can use the Azure Site Recovery to replicate your on-premises Azure Stack HCI virtual machines (VMs) into Azure and protect your business critical workloads.

This feature is enabled on your Azure Stack HCI clusters running May 2023 cumulative update of version 22H2 and later.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Azure Site Recovery with Azure Stack HCI

*Azure Site Recovery* is an Azure service that replicates workloads running on VMs so that your business-critical infrastructure is protected if there's a disaster. For more information about Azure Site Recovery, see [About Site Recovery](/azure/site-recovery/site-recovery-overview).

The disaster recovery strategy for Azure Site Recovery consists of the following steps:

- **Replication** - Replication lets you replicate the target VM’s VHD to an Azure Storage account and thus protects your VM if there's a disaster.
- **Failover** -  Once the VM is replicated, fail over the VM and run it in Azure. You can also perform a test failover without impacting your primary VMs to test the recovery process in Azure.
- **Re-protect** – VMs are replicated back from Azure to the on-premises cluster.
- **Failback** - You can fail back from Azure to the on-premises cluster.

In the current implementation of Azure Site Recovery integration with Azure Stack HCI, you can start the disaster recovery and prepare the infrastructure from the Azure Stack HCI cluster resource in the Azure portal. After the preparation is complete, you can finish the remaining steps from the Site Recovery resource in the Azure portal.

> [!NOTE]
> Azure Site Recovery doesn't support the replication, failover, and failback of the Arc resource bridge and Arc VMs.


## Overall workflow

The following diagram illustrates the overall workflow of Azure Site Recovery working with Azure Stack HCI.

![Illustration describing Azure Site Recovery and Azure Stack HCI workflow.](/azure-stack/hci/manage/media/azure-site-recovery/site-recovery-workflow.png)

Here are the main steps that occur when using Site Recovery with an Azure Stack HCI cluster:

1. Start with a registered Azure Stack HCI cluster on which you enable Azure Site Recovery.
1. Make sure that you meet the [prerequisites](#prerequisites-and-planning) before you begin.
1. Create the following resources in your Azure Stack HCI resource portal:
    1. Recovery services vault
    1. Hyper-V site
    1. Replication policy
1. Once you have created all the resources, prepare infrastructure.
1. Enable VM replication. Complete the remaining steps for replication in the Azure Site Recovery resource portal and begin replication.
1. Once the VMs are replicated, you can fail over the VMs and run on Azure.

## Supported scenarios

The following table lists the scenarios that are supported for Azure Site Recovery and Azure Stack HCI.

**Fail over Azure Stack HCI VMs to Azure followed by failback**

| **Azure Stack HCI VM details** | **Failover**      | **Failback**                                   |
|--------------------------------|-------------------|------------------------------------------------|
| Windows Gen 1                  | Failover to Azure | Failback on same or different host as failover |
| Windows Gen 2                  | Failover to Azure | Failback on same or different host as failover |
| Linux Gen 1                    | Failover to Azure | Failback on same or different host as failover |

> [!NOTE]
> Manual intervention is needed if after failover, VM is deleted on Azure Stack HCI followed by a failback to same or different host.

## Prerequisites and planning

Before you begin, make sure to complete the following prerequisites:

- The Hyper-V VMs that you intend to replicate should be made highly available for replication to happen. If VMs aren't highly available, then the replication would fail. For more information, see [How to make an existing Hyper-V machine VM highly available](https://www.thomasmaurer.ch/2013/01/how-to-make-an-existing-hyper-v-virtual-machine-highly-available/).
- Make sure that Hyper-V is set up on the Azure Stack HCI cluster.
- The servers hosting the VMs you want to protect must have internet access to replicate to Azure.
- The Azure Stack HCI cluster must already be registered.
    - The cluster must be running May cumulative update for Azure Stack HCI, version 22H2.
    - If you're running an earlier build, the Azure portal indicates that the disaster recovery isn't supported as managed identity isn't enabled for older versions.

        Run the repair registration cmdlet to ensure that a managed identity is created for your Azure Stack HCI resource and then retry the workflow. For more information, go to [Enable enhanced management from Azure for Azure Stack HCI](/azure-stack/hci).

    - The cluster must be Arc-enabled. If the cluster isn't Arc-enabled, you see an error in the Azure portal to the effect that the **Capabilities** tab isn't available.
- You need owner permissions on the Recovery Services Vault to assign permissions to the managed identity. You also need read/write permissions on the Azure Stack HCI cluster resource and its child resources.
- [Review the caveats](#caveats) associated with the implementation of this feature.
- [Review the capacity planning tool to evaluate the requirements for successful replication and failover](/azure/site-recovery/hyper-v-site-walkthrough-capacity).

## Step 1: Prepare infrastructure on your target host

To prepare the infrastructure, prepare a vault and a Hyper-V site, install the site recovery extension, and associate a replication policy with the cluster nodes.

On your Azure Stack HCI target cluster, follow these steps to prepare infrastructure:

1. In the Azure portal, go to the **Overview** pane of the target cluster resource that is hosting VMs that you want to protect.

1. In the right-pane, go to the **Capabilities** tab and select the **Disaster recovery** tile. As managed identity is enabled on your cluster, disaster recovery should be available.

    ![Screenshot of Capabilities tab in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/prepare-infra-1.png)

1. In the right-pane, go to **Protect** and select **Protect VM workloads**.

    ![Screenshot of Protect VM workloads in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/prepare-infra-2.png)

1. On the **Replicate VMs to Azure**, select **Prepare infrastructure**.

    ![Screenshot of Prepare infrastructure in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/prepare-infra-3.png)


1. On the **Prepare infrastructure**, select an existing or create a new Recovery services vault. You use this vault to store the configuration information for virtual machine workloads. For more information, see [Recovery services vault overview](/azure/backup/backup-azure-recovery-services-vault-overview).
    1. If you choose to create a new Recovery services vault, the subscription and resource groups are automatically populated.
    1. Provide a vault name and select the location of the vault same as where the cluster is deployed.
    1. Accept the defaults for other settings.

        > [!IMPORTANT]
        > You will need owner permissions on the Recovery services vault to assign permissions to the managed identity. You will need read/write permission on the Azure Stack HCI cluster resource and its child resources.

        Select **Review + Create** to start the vault creation. For more information, see [Create and configure a Recovery services vault](/azure/backup/backup-create-recovery-services-vault).

        ![Screenshot of Create Recovery Services vault in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/prepare-infra-4.png)

1. Select an existing **Hyper-V site** or create a new site.

    ![Screenshot of Create Hyper-V site in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/prepare-infra-5.png)

1. Select an existing **Replication policy** or create new. This policy is used to replicate your VM workloads. For more information, see [Replication policy](/azure/site-recovery/hyper-v-azure-tutorial#replication-policy). After the policy is created, select **OK**.

    ![Screenshot of Create replication policy in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/prepare-infra-6.png)

1. Select **Prepare infrastructure**. When you select **Prepare infrastructure**, the following actions occur:
    1. A **Resource Group** with the **Storage Account** and the specified **Vault** and the replication policy are created in the specified **Location**.
    1. An Azure Site Recovery agent is automatically downloaded on each node of your cluster that is hosting the VMs.
    1. Managed Identity gets the vault registration key file from Recovery Services vault that you created and then the key file is used to complete the installation of the Azure Site Recovery agent. A **Resource Group** with the **Storage Account** and the specified **Vault** and the replication policy are created in the specified **Location**.
    1. Replication policy is associated with the specified Hyper-V site and the target cluster host is registered with the Azure Site Recovery service.

        If you don't have owner level access to the subscription/resource group where you create the vault, you see an error to the effect that you don't have authorization to perform the action.

1. Depending on the number of nodes in your cluster, the infrastructure preparation could take several minutes. You can watch the progress by going to **Notifications** (the bell icon at the top right of the window).

## Step 2: Enable replication of VMs

After the infrastructure preparation is complete, follow these steps to select the VMs to replicate.

1. On **Step 2: Enable replication**, select **Enable replication**. You're now directed to the Recovery services vault where you can specify the VMs to replicate.

    ![Screenshot of Enable replication in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-1.png)

1. Select **Replicate** and in the dropdown select **Hyper-V machines to Azure**. 
2. On the **Source environment** tab, specify the source location for your Hyper-V site. In this instance, you have set up the Hyper-V site on your Azure Stack HCI cluster. Select **Next**.

1. On the **Target environment** tab, complete these steps:
    1. For **Subscription**, enter or select the subscription.
    1. For **Post-failover resource group**, select the resource group name to which you fail over. When the failover occurs, the VMs in Azure are created in this resource group.
    1. For **Post-failover deployment model**, select **Resource Manager**. The Azure Resource Manager deployment is used when the failover occurs.
    1. For **Storage account**, enter or select an existing storage account associated with the subscription that you have chosen. This account could be a standard or a premium storage account that is used for the VM’s replication.

        ![Screenshot of target environment tab in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-2.png)

    1. For the network configuration of the VMs that you’ve selected to replicate in Azure, provide a virtual network and a subnet that would be associated with the VMs in Azure. To create this network, see the instructions in [Create an Azure network for failover](/azure/site-recovery/tutorial-dr-drill-azure#create-a-network-for-test-failover).

        You can also choose to do the network configuration later.

        ![Screenshot of target environment tab with Configure later selected in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-3.png)

        Once the VM is replicated, you can select the replicated VM and go to the **Compute and Network** setting and provide the network information.

1. Select **Next**.
1. On the **Virtual machine selection** tab, select the VMs to replicate, and then select **Next**. Make sure to review the [capacity requirements for protecting the VM](/azure/site-recovery/site-recovery-capacity-planner).

    ![Screenshot of virtual selection tab in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-4.png)

1. On the **Replication settings** tab, select the operating system type, operating system disk and the data disks for the VM you intend to replicate to Azure, and then select **Next**.

    ![Screenshot of Replication settings tab in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-5.png)

1. On the **Replication policy** tab, verify that the correct replication policy is selected. The selected policy should be the same replication policy that you created when preparing the infrastructure. Select **Next**.

    ![Screenshot of Replication policy tab in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-6.png)

1. On the **Review** tab, review your selections, and then select **Enable Replication**.

    ![Screenshot of Review tab in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-7.png)

1. A notification indicating that the replication job is in progress is displayed. Go to **Protected items \> Replication items** to view the status of the replication health and the status of the replication job.

    ![Screenshot of Replicated items in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-8.png)

1. To monitor the VM replication, follow these steps.

    1. To view the **Replication health** and **Status**, select the VM and go to the Overview. You can see the percentage completion of the replication job.
     
        ![Screenshot of Overview of a replicated item in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-9.png)
    
    1. To see a more granular job status and **Job id**, select the VM and go to the **Properties** of the replicated VM.

        ![Screenshot of Properties of a replicated item in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-10.png)

    1. To view the disk information, go to **Disks**. Once the replication is complete, the **Operating system disk** and **Data disk** should show as **Protected**.

        ![Screenshot of Disks for a selected replicated VM in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/enable-replication-11.png)

The next step is to configure a test failover.

## Step 3: Configure and run a test failover in the Azure portal

Once the replication is complete, the VMs are protected. We do recommend that you configure failover settings and run a test failover when you set up Azure Site Recovery.

To prepare for fail over to an Azure VM, complete the following steps:

1. If you didn't specify the network configuration for the replicated VM, you can complete that configuration now.
    1. First, make sure that an Azure network is set up to test failover as per the instructions in [Create a network for test failover](/azure/site-recovery/tutorial-dr-drill-azure#create-a-network-for-test-failover).
    1. Select the VM and go to the **Compute and Network** settings and specify the virtual network and the subnet. The failed-over VM in Azure attaches to this virtual network and subnet.

1. Once the replication is complete and the VM is **Protected** as reflected in the status, you can start **Test Failover**.

    ![Screenshot of Test failover for a selected replicated VM in Azure portal for Azure Stack HCI cluster resource.](/azure-stack/hci/manage/media/azure-site-recovery/run-test-failover-1.png)

1. To run a test failover, see the detailed instructions in [Run a disaster recovery drill to Azure](/azure/site-recovery/tutorial-dr-drill-azure#run-a-test-failover-for-a-single-vm).

## Step 4: Create Recovery Plans

*Recovery Plan* is a feature in Azure Site Recovery that lets you fail over and recover an entire application comprising a collection of VMs. While it's possible to recover protected VMs individually, by adding the VMs comprising an application to a recovery plan, you're able to fail over the entire application through the recovery plan.

You can also use the test failover feature of Recovery Plan to test the recovery of the application. Recovery Plan lets you group VMs, sequence the order in which they should be brought up during a failover, and automate other steps to be performed as part of the recovery process. Once you've protected your VMs, you can go to the Azure Site Recovery vault in the Azure portal and create recovery plans for these VMs. [Learn more about recovery plans](/azure/site-recovery/site-recovery-create-recovery-plans).

## Step 5: Fail over to Azure

To fail over to Azure, you can follow the instructions in [Fail over Hyper-V VMs to Azure](/azure/site-recovery/hyper-v-azure-failover-failback-tutorial).

## Caveats

Consider the following information before you use Azure Site Recovery to protect your on-premises VM workloads by replicating those VMs to Azure.

- Extensions installed by Arc aren’t visible on the Azure VMs. The Arc server will still show the extensions that are installed, but you can't manage those extensions (for example, install, upgrade, or uninstall) while the server is in Azure.
- Guest Configuration policies won't run while the server is in Azure, so any policies that audit the OS security/configuration won't run until the machine is migrated back on-premises.
- Log data (including Sentinel, Defender, and Azure Monitor info) will be associated with the Azure VM while it's in Azure. Historical data is associated with the Arc server. If it's migrated back on-premises, it starts being associated with the Arc server again. They can still find all the logs by searching by computer name as opposed to resource ID, but it's worth noting the Portal UX experiences look for data by resource ID so you'll only see a subset on each resource.
- We strongly recommend that you don't install the Azure VM Guest Agent to avoid conflicts with Arc if there's any potential that the server will be migrated back on-premises. If you need to install the guest agent, make sure that the VM has extension management disabled. If you try to install/manage extensions using the Azure VM guest agent when there are already extensions installed by Arc on the same machine (or vice versa), you run into all sorts of issues because our agents are unaware of the previous extension installations and will encounter state reconciliation issues.

## Known issues

Here's a list of known issues and the associated workarounds in this release:

| \# | Issue                   | Workaround/Comments    |
|----|----------------------|---------------------------|
| 1. | When you register Azure Site Recovery with a cluster, a node fails to install Azure Site Recovery or register to the Azure Site Recovery service.  | In this instance, your VMs may not be protected. Verify that all servers in the cluster are registered in the Azure portal by going to the **Recovery Services vault** \> **Jobs** \> **Site Recovery Jobs**. |
| 2. | Azure Site Recovery agent fails to install. No error details are seen at the cluster or server levels in the Azure Stack HCI portal. | When the Azure Site Recovery agent installation fails, it is because of the one of the following reasons:  <br><br> - Installation fails as Hyper-V isn't set up on the cluster. </br><br> - The Hyper-V host is already associated to a Hyper-V site and you're trying to install the extension with a different Hyper-V site. </br>  |


## Next steps

[Learn more about Hybrid capabilities with Azure services](/azure-stack/hci/hybrid-capabilities-with-azure-services)
