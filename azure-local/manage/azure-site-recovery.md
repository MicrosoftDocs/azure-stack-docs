---
title: Protect your Hyper-V virtual machine workloads on Azure Local with Azure Site Recovery 
description: Use Azure Site Recovery to protect Hyper-V VM workloads running on Azure Local.
ms.topic: how-to
author: ronmiab
ms.author: robess
ms.date: 09/10/2026
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
---
<!-- This article is used by the Windows Server Docs, all links must be site relative (except include files). For example, /azure-stack/hci/manage/azure-site-recovery -->

# Protect VM workloads with Azure Site Recovery on Azure Local

This guide describes how to protect Windows and Linux VM workloads running on your Azure Local if there's a disaster. You can use Azure Site Recovery to replicate your on-premises Azure Local virtual machines (VMs) into Azure and protect your business-critical workloads.

## Azure Site Recovery with Azure Local

*Azure Site Recovery* is an Azure service that replicates workloads running on VMs so that your business-critical infrastructure is protected if there's a disaster. For more information about Azure Site Recovery, see [About Site Recovery](/azure/site-recovery/site-recovery-overview).

The disaster recovery strategy for Azure Site Recovery consists of the following steps:

- **Replicate** - Replication lets you replicate the target VM’s virtual hard disk (VHD) to an Azure Storage account and thus protects your VM if there's a disaster.
- **Test Failover** - Validate your disaster recovery plan with non-disruptive test failovers that create a VM in Azure in an isolated network without impacting production replication.
- **Failover to Azure (planned or unplanned)** -  Once the VM is replicated, you can fail it over and run it in Azure, even if the server hosting the VM is no longer available. In such cases, the VM starts from its last replicated state, and any in-memory state is lost.
- **Re-protect** – VMs are replicated back from Azure to the on-premises system.

- **Planned failover back to on-premises (also known as failback)** - Use planned failover to fail the VM back from Azure to the on-premises environment.
- **Reverse replicate** - After the VM is back on-premises, it is recommended that you reverse replicate it to Azure to restore continuous replication, maintain protection against data loss, and support rapid recovery in the event of another disaster.


> [!NOTE]
> In the current implementation of Azure Site Recovery integration with Azure Local, you can start the disaster recovery and prepare the infrastructure from the Azure Local resource in the Azure portal. Once the preparation is complete, perform all remaining steps from the Recovery Services vault in the Azure portal.

## Overall workflow

Here are the main steps that occur when using Site Recovery with an Azure Local system:

1. Start with a registered Azure Local system on which you prepared the infrastructure for Azure Site Recovery.
1. Make sure that you meet the [prerequisites](#prerequisites-and-planning) before you begin.
1. Enable [VM replication](#step-2-enable-replication-of-vms) and begin replication.
1. After the VMs are replicated, you can [fail over the VMs](/azure/site-recovery/hyper-v-azure-failover-failback-tutorial) and run on Azure.
1. To fail back from Azure, follow the instructions in [Fail back from Azure](/azure/site-recovery/hyper-v-azure-failback).

## Supported scenarios

The following table lists the scenarios that Azure Site Recovery and Azure Local support.

| **Azure Local VM details** | **Failover** | **Failback** |
|--|--|--|
| Windows Gen 1 | Failover to Azure | Failback on same or an alternate host as failover |
| Windows Gen 2 | Failover to Azure | Failback on same or an alternate host as failover |
| Linux Gen 1 | Failover to Azure | Failback on same or an alternate host as failover |
| Linux Gen 2 | Failover to Azure | Failback on same or an alternate host as failover |

> [!NOTE]
> If you delete an Azure Local VM after a failover, you need to manually intervene to continue managing this VM by using Azure Local. 

## Prerequisites and planning

Before you begin, complete the following prerequisites:

- The Azure Local hosting the VMs you want to protect must have internet access to replicate to Azure.
- The Azure Local must already be registered.
- You need owner permissions on the Recovery Services Vault to assign permissions to the managed identity. You also need read/write permissions on the Azure Local resource and its child resources.
- Review the caveats associated with the implementation of this feature.
- Review the [capacity planning tool](/azure/site-recovery/hyper-v-site-walkthrough-capacity) to evaluate the requirements for successful replication and failover.

## Caveats

Consider the following information before you use Azure Site Recovery to protect your on-premises VM workloads by replicating those VMs to Azure.

- Extensions installed by Arc aren't visible on the Azure VMs. The Azure Local VMs still show the extensions that are installed, but you can't manage those extensions (for example, install, upgrade, or uninstall) while the machine is in Azure.
- Guest Configuration policies don't run while the machine is in Azure, so any policies that audit the OS security or configuration don't run until the machine is migrated back on-premises.
- Log data (including Sentinel, Defender, and Azure Monitor info) is associated with the Azure VM while it's in Azure. Historical data is associated with the Arc-enabled server. If the data is migrated back on-premises, it starts being associated with the Arc-enabled server again. You can still find all the logs by searching by computer name as opposed to resource ID, but it's worth noting the Portal UX experiences look for data by resource ID, so you only see a subset on each resource.
- We strongly recommend that you don't install the Azure VM Guest Agent to avoid conflicts with Arc if there's any potential that the machine will be migrated back on-premises. If you need to install the guest agent, make sure that the VM has extension management disabled. If you try to install or manage extensions using the Azure VM guest agent when there are already extensions installed by Arc on the same machine (or vice versa), the agent might encounter state reconciliation issues because it's unaware of the previous extension installations.

## Step 1: Prepare infrastructure

On your Azure Local system, follow these steps to prepare the infrastructure:

1. In the Azure portal, go to the **Overview** pane of the Azure Local system that's hosting VMs that you want to protect.

1. In the right pane, go to the **Capabilities** tab and select the **Disaster recovery** tile.

    :::image type="content" source="media/azure-site-recovery/prepare-infra-1.png" alt-text="Screenshot of Capabilities tab in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/prepare-infra-1.png":::

1. In the right-pane, go to **Protect** and select **Protect VM workloads**.

    :::image type="content" source="media/azure-site-recovery/prepare-infra-2.png" alt-text="Screenshot of Protect VM workloads in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/prepare-infra-2.png":::

1. On the **Replicate VMs to Azure**, select **Prepare infrastructure**.

    :::image type="content" source="media/azure-site-recovery/prepare-infra-3.png" alt-text="Screenshot of Prepare infrastructure in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/prepare-infra-3.png":::

1. On **Prepare infrastructure**, select an existing or create a new Recovery Services vault. Use this vault to store the configuration information for virtual machine workloads. For more information, see [Recovery Services vault overview](/azure/backup/backup-azure-recovery-services-vault-overview).
    1. If you choose to create a new Recovery Services vault, the subscription and resource groups are automatically populated.
    1. Provide a vault name and select the location of the vault same as where the system is deployed.
    1. Accept the defaults for other settings.
    1. Select **Review + Create** to start the vault creation. For more information, see [Create and configure a Recovery Services vault](/azure/backup/backup-create-recovery-services-vault).

        :::image type="content" source="media/azure-site-recovery/prepare-infra-4.png" alt-text="Screenshot of Create Recovery Services vault in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/prepare-infra-4.png":::

1. Select an existing **Hyper-V site** or create a new site.

    :::image type="content" source="media/azure-site-recovery/prepare-infra-5.png" alt-text="Screenshot of Create Hyper-V site in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/prepare-infra-5.png":::

1. Select an existing **Replication policy** or create new. This policy is used to replicate your VM workloads. For more information, see [Replication policy](/azure/site-recovery/hyper-v-azure-tutorial#replication-policy). After the policy is created, select **OK**.

    :::image type="content" source="media/azure-site-recovery/prepare-infra-6.png" alt-text="Screenshot of Create replication policy in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/prepare-infra-6.png":::

1. Select **Prepare infrastructure**. The following actions occur:
    1. A **Resource Group** with the **Storage Account** and the specified **Vault** and the replication policy are created in the specified **Location**.
    1. An Azure Site Recovery agent is automatically downloaded on each node of your system that's hosting the VMs.
    1. Managed Identity gets the vault registration key file from the Recovery Services vault that you created and then uses the key file to complete the installation of the Azure Site Recovery agent. A **Resource Group** with the **Storage Account** and the specified **Vault** and the replication policy are created in the specified **Location**.
    1. The replication policy is associated with the specified Hyper-V site and the target system host is registered with the Azure Site Recovery service.

        If you don't have owner-level access to the subscription or resource group where you create the vault, you see an error that you don't have authorization to perform the action.

1. Depending on the number of nodes in your system, the infrastructure preparation could take several minutes. You can watch the progress by going to **Notifications** (the bell icon at the top right of the window).

## Step 2: Enable replication of VMs

After the infrastructure preparation is complete, follow these steps to select the VMs to replicate.

1. On **Step 2: Enable replication**, select **Enable replication**. You're now directed to the Recovery Services vault where you can specify the VMs to replicate.

    :::image type="content" source="media/azure-site-recovery/enable-replication-1.png" alt-text="Screenshot of Enable replication in Azure portal for an Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-1.png":::

1. Select **Replicate** and in the dropdown select **Hyper-V machines to Azure**.

1. On the **Source environment** tab, specify the source location for your Hyper-V site. In this instance, you have set up the Hyper-V site on your Azure Local resource. Select **Next**.

1. On the **Target environment** tab, complete these steps:
    1. For **Subscription**, enter or select the subscription.
    1. For **Post-failover resource group**, select the resource group name to which you fail over. When the failover occurs, the VMs in Azure are created in this resource group.
    1. For **Post-failover deployment model**, select **Resource Manager**. The Azure Resource Manager deployment is used when the failover occurs.
    1. For **Storage**, select the type of Azure storage you're replicating to. We recommend using managed disk.

        :::image type="content" source="media/azure-site-recovery/enable-replication-2.png" alt-text="Screenshot of target environment tab in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-2.png":::

    1. For the network configuration of the VMs that you selected to replicate in Azure, provide a virtual network and a subnet that would be associated with the VMs in Azure. To create this network, see the instructions in [Create an Azure network for failover](/azure/site-recovery/tutorial-dr-drill-azure#create-a-network-for-test-failover).

        You can also choose to do the network configuration later.

        :::image type="content" source="media/azure-site-recovery/enable-replication-3.png" alt-text="Screenshot of target environment tab with Configure later selected in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-3.png":::

        Once the VM is replicated, you can select the replicated VM and go to the **Compute and Network** setting and provide the network information.

1. Select **Next**.
1. On the **Virtual machine selection** tab, select the VMs to replicate, and then select **Next**. Make sure to review the [capacity requirements for protecting the VM](/azure/site-recovery/site-recovery-capacity-planner).

    :::image type="content" source="media/azure-site-recovery/enable-replication-4.png" alt-text="Screenshot of virtual selection tab in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-4.png":::

1. On the **Replication settings** tab, select the operating system type, operating system disk, and the data disks for the VM you intend to replicate to Azure, and then select **Next**.

    :::image type="content" source="media/azure-site-recovery/enable-replication-5.png" alt-text="Screenshot of Replication settings tab in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-5.png":::

1. On the **Replication policy** tab, verify that the correct replication policy is selected. The selected policy should be the same replication policy that you created when preparing the infrastructure. Select **Next**.

    :::image type="content" source="media/azure-site-recovery/enable-replication-6.png" alt-text="Screenshot of Replication policy tab in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-6.png":::

1. On the **Review** tab, review your selections, and then select **Enable Replication**.

    :::image type="content" source="media/azure-site-recovery/enable-replication-7.png" alt-text="Screenshot of Review tab in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-7.png":::

1. A notification indicating that the replication job is in progress is displayed. Go to **Protected items \> Replication items** to view the status of the replication health and the status of the replication job.

    :::image type="content" source="media/azure-site-recovery/enable-replication-8.png" alt-text="Screenshot of Replicated items in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-8.png":::

### Monitor VM replication

To monitor the VM replication, follow these steps:

1. To view the **Replication health**, **Status**, and replication progress, select the VM, and then go to **Overview**.

    :::image type="content" source="media/azure-site-recovery/enable-replication-9.png" alt-text="Screenshot of Overview of a replicated item in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-9.png":::
 
1. To view detailed job status and the **Job ID**, select the VM, and then go to **Properties**.
  
    :::image type="content" source="media/azure-site-recovery/enable-replication-10.png" alt-text="Screenshot of the Properties page for a replicated Azure Local VM in the Azure portal." lightbox="media/azure-site-recovery/enable-replication-10.png":::
 
1. To view disk information, go to **Disks**. After replication is complete, verify that the **Operating system disk** and **Data disk** show a status of **Protected**.
 
    :::image type="content" source="media/azure-site-recovery/enable-replication-11.png" alt-text="Screenshot of Disks for a selected replicated VM in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-11.png"::: 
 
1. To view the **Replication health** and **Status**, select the VM and go to the Overview. You can see the percentage completion of the replication job.
     
    :::image type="content" source="media/azure-site-recovery/enable-replication-9.png" alt-text="Screenshot of Overview of a replicated item in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-9.png":::
    
1. To see a more granular job status and **Job id**, select the VM and go to the **Properties** of the replicated VM.

    :::image type="content" source="media/azure-site-recovery/enable-replication-10.png" alt-text="Screenshot of Properties of a replicated item in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-10.png":::

1. To view the disk information, go to **Disks**. Once the replication is complete, the **Operating system disk** and **Data disk** should show as **Protected**.

   :::image type="content" source="media/azure-site-recovery/enable-replication-11.png" alt-text="Screenshot of Disks for a selected replicated VM in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/enable-replication-11.png":::

The next step is to configure a test failover.

## Step 3: Configure and run a test failover in the Azure portal

After replication finishes, the VMs are protected. Configure the failover settings and run a test failover as part of your Azure Site Recovery setup.

To prepare for failover to an Azure VM, complete the following steps:

1. If you didn't specify the network configuration for the replicated VM, you can complete that configuration now.
    1. Ensure that an Azure network is set up to test failover as per the instructions in [Create a network for test failover](/azure/site-recovery/tutorial-dr-drill-azure#create-a-network-for-test-failover).
    1. Select the VM and go to the **Compute and Network** settings and specify the virtual network and the subnet. The failed-over VM in Azure attaches to this virtual network and subnet.

1. Once the replication is complete and the VM is **Protected** as reflected in the status, you can start **Test Failover**.

    :::image type="content" source="media/azure-site-recovery/run-test-failover-1.png" alt-text="Screenshot of Test failover for a selected replicated VM in Azure portal for Azure Local resource." lightbox="media/azure-site-recovery/run-test-failover-1.png":::

1. To run a test failover, see the detailed instructions in [Run a disaster recovery drill to Azure](/azure/site-recovery/tutorial-dr-drill-azure#run-a-test-failover-for-a-single-vm).

## Step 4: Create recovery plans


A recovery plan in Azure Site Recovery groups VMs so that you can fail over and recover an application as a single unit. Although you can recover protected VMs individually, a recovery plan lets you group application VMs, define the order in which they start after failover, and automate recovery tasks.



Use a recovery plan to group VMs, define the order in which they start during failover, and automate recovery tasks. You can run a test failover for the recovery plan to validate application recovery.

After you protect your VMs, create a recovery plan for them in the Recovery Services vault in the Azure portal. For more information, see 
[Create and customize recovery plans](/azure/site-recovery/site-recovery-create-recovery-plans).

## Step 5: Fail over to Azure

To fail over to Azure, follow the instructions in [Fail over Hyper-V VMs to Azure](/azure/site-recovery/hyper-v-azure-failover-failback-tutorial).

## Step 6: Fail back from Azure

To fail back from Azure, follow the instructions in [Fail back from Azure](/azure/site-recovery/hyper-v-azure-failback).
> [!NOTE]
> If you prepare multiple Azure Local instances by using the same Hyper-V site, you can fail back a VM to a host in either instance. Select **Create on-premises virtual machine if it does not exist**, and then choose the target Hyper-V host under **Host Name**. To learn more about this process, see [Fail back to an alternate location](/azure/site-recovery/hyper-v-azure-failback#fail-back-to-an-alternate-location).


## Step 7: Reverse replicate to Azure

Reverse replicate your VMs back to Azure to restore continuous replication and maintain ongoing protection against data loss. This protection enables rapid recovery in the event of another disaster. Only the delta changes since the VM was turned off in Azure are replicated.


## Known issues

Here's a list of known issues and the associated workarounds in this release:

| \# | Issue                   | Workaround/Comments    |
|----|----------------------|---------------------------|
| 1. | When you register Azure Site Recovery with a system, a machine fails to install Azure Site Recovery or register to the Azure Site Recovery service.  | In this instance, your VMs might not be protected. Verify that all machines in the system are registered in the Azure portal by going to the **Recovery Services vault** \> **Jobs** \> **Site Recovery Jobs**. |
| 2. | Azure Site Recovery agent fails to install. No error details are seen at the system or machine levels in the Azure Local portal. | When the Azure Site Recovery agent installation fails, it's because of one of the following reasons:  <br><br> - Installation fails as Hyper-V isn't set up on the host. </br><br> - The Hyper-V host is already associated to a Hyper-V site and you're trying to install the extension with a different Hyper-V site. </br>  |



## Next steps
- [Learn more about Hybrid capabilities with Azure services](/azure-stack/hci/hybrid-capabilities-with-azure-services)
- [Hyper-V to Azure disaster recovery architecture](/azure/site-recovery/hyper-v-azure-architecture)
- [Troubleshoot Hyper-V to Azure replication and failover](/azure/site-recovery/hyper-v-azure-troubleshoot)

