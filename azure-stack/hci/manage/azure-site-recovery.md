---
title: Protect Azure Stack HCI VMs using Azure Site Recovery
description: Use Windows Admin Center to protect your Azure Stack HCI VMs with Azure Site Recovery.
ms.topic: how-to
author: davannaw-msft
ms.author: dawhite
ms.date: 04/30/2020
ms.localizationpriority: low
---

# Protect Azure Stack HCI VMs using Azure Site Recovery

>Applies To: Windows Server 2019, Azure Stack HCI version 20H2

Windows Admin Center streamlines the process of replicating virtual machines (VMs) on your servers or clusters, giving you the power to take advantage of Azure from your own datacenter. To automate setup, you connect Windows Admin Center to Azure.

This article shows you how to use Azure Site Recovery to configure replication settings and create a recovery plan in the Azure portal. Completing these tasks enables Windows Admin Center to start VM replication to protect your VMs. Azure Site Recovery also protects your physical servers and cluster nodes.

To learn more, see [Connecting Windows Server to Azure hybrid services](/windows-server/manage/windows-admin-center/azure/).

## How Azure Site Recovery works with Windows Admin Center
*Azure Site Recovery* is an Azure service that replicates workloads running on VMs so that your business-critical infrastructure is protected from a disaster. To learn more, see [About Site Recovery](/azure/site-recovery/site-recovery-overview).

Azure Site Recovery consists of two components: *replication* and *failover*. The replication portion protects your VMs from disaster by replicating the target VM's VHD to an Azure storage account. You can then fail over the VMs and run them in Azure in the event of a disaster. You can also do a test failover without impacting your primary VMs to test the recovery process in Azure.

Completing setup for the replication component alone is sufficient to protect your VMs from a disaster. However, you can't start the VMs in Azure until you configure the failover portion of the process.

You can set up the failover portion when you want to fail over to an Azure VM; it's not required during initial setup. If the host server goes down, you can configure the failover component at that time and access the workloads of the protected VM. However, we recommend configuring the failover-related settings before a disaster.

## Prerequisites and planning
The following is required to complete the steps in this article:

- The target servers hosting the VMs that you want to protect must have Internet access to replicate to Azure.
- A connection from Windows Admin Center to Azure. For more information, see [Configuring Azure integration](/windows-server/manage/windows-admin-center/azure/azure-integration).
- Review the capacity planning tool to evaluate the requirements for successful replication and failover. For more information, see [About the Azure Site Recovery Deployment Planner for Hyper-V disaster recovery to Azure](/azure/site-recovery/hyper-v-site-walkthrough-capacity).

## Step 1: Set up VM protection on your target host
Complete the following steps once per host server or cluster containing the VMs that you want to target for protection:
1. In Windows Admin Center on the **All connections** page, connect to the server or cluster hosting the VMs that you want to protect.
1. Under **Tools**, select **Virtual machines**, and then select the **Inventory** tab.
1. Select any VM (it doesn't need to be the VM that you want to protect).
1. Expand the **More** submenu and then select **Set up VM Protection**.

    :::image type="content" source="media/azure-site-recovery/set-up-vm-protection.png" alt-text="The Set up VM Protection submenu option in Windows Admin Center.":::

1. Sign in to your Azure Account.
1. On the Setting up host with Azure Site Recovery page, enter the required information, and then select **Set up**:

   - **Subscription:** The Azure subscription that you want to use for VM replication on this host.
   - **Resource Group:** A new Resource Group name.
   - **Recovery Services Vault:** A name for the Azure Site Recovery vault for the protected VMs on this host.
   - **Location:** The Azure region where the Azure Site Recovery resources should be created.

    :::image type="content" source="media/azure-site-recovery/set-up-host-with-asr.png" alt-text="The Setting up host with Azure Site Recovery page in Windows Admin Center.":::

1. Wait until you see the notification: **Site Recovery Setting Completed**.

This process could take up to 10 minutes. You can watch the progress by going to **Notifications** (the bell icon at the top right of Windows Admin Center).

>[!NOTE]
> This process automatically installs the Azure Site Recovery agent onto the target server or nodes (if you are configuring a cluster), and creates a **Resource Group** with the specified **Storage Account** and **Vault**, in the specified **Location**. It also registers the target host with the Azure Site Recovery service and configures a default replication policy.

## Step 2: Select VMs to protect
Complete the following steps to protect your VMs:
1. In Windows Admin Center, return to the server or cluster that you configured in the previous task.
1. Under **Tools**, select **Virtual machines**, and then select the  **Inventory** tab.
1. Select the VM that you want to protect, expand the **More** submenu,  and then select **Protect VM**.

    :::image type="content" source="media/azure-site-recovery/protect-vm-setting.png" alt-text="The Protect VM setting option in Windows Admin Center.":::

1. Review capacity requirements for protecting the VM. For more information, see [Plan capacity for Hyper-V VM disaster recovery](/azure/site-recovery/site-recovery-capacity-planner).

    If you want to use a premium storage account, create one in the Azure portal. To learn more, see the **Premium SSD** section of [What disk types are available in Azure?](/azure/storage/common/storage-premium-storage) The **Create New** option provided in Windows Admin Center creates a standard storage account.

1. Enter the name of the **Storage Account** to use for this VM's replication, and then select **Protect VM** to enable replication for the VM.

    :::image type="content" source="media/azure-site-recovery/protect-vm-setting-asr.png" alt-text="Defining the Storage Account for Azure Site Recovery to protect a VM in Windows Admin Center.":::

    Azure Site Recovery starts the replication process. The VM is protected when the value in the **Protected** column of the **Virtual Machine Inventory** grid changes to **Yes**. This process could take several minutes.

## Step 3: Configure and run a test failover in the Azure portal
It's not required to complete this step before starting VM replication. The VM is protected with only replication. However, we recommend configuring failover settings when you set up Azure Site Recovery.

Complete the following steps to prepare failover to an Azure VM:
1. Set up an Azure network that the failed-over VM will attach to this VNET. To learn more, see [Set up disaster recovery of on-premises Hyper-V VMs to Azure](/azure/site-recovery/hyper-v-site-walkthrough-prepare-azure).

    >[!NOTE]
    > Windows Admin Center automatically completes the steps in this resource. You only need to set up the Azure network.

1. Run a test failover. To learn more, see [Run a disaster recovery drill to Azure](/azure/site-recovery/hyper-v-site-walkthrough-test-failover).

## Step 4: Create recovery plans
Recovery plans in Azure Site Recovery enable you to fail over and recover an entire application's collection of VMs. It's possible to recover protected VMs individually. But a better way is to add the VMs of an application to your recovery plan. You can then fail over the entire application through the recovery plan. You can also use the test failover feature of a recovery plan to test the recovery of the application.

Recovery plans let you group VMs, sequence the order in which they should start during a failover, and automate additional recovery steps. After you've protected your VMs, you can go to the Azure Site Recovery vault in the Azure portal to create recovery plans for them. To learn more, see [Create and customize recovery plans](/azure/site-recovery/site-recovery-create-recovery-plans).

## Step 5: Monitor replicated VMs in Azure
To verify no failures in the server registration process, go to the **Azure portal**, select **All resources**, select **Recovery Services Vault**, select **Jobs**, and then select **Site Recovery Jobs**. The **Recovery Services Vault** name is the one that you specified in Step 6 of the first task in this article.

To monitor VM replication, go to the **Recovery Services Vault**, and then **Replicated Items**.

To see all servers that are registered to the vault, go to **Recovery Services Vault**, **Site Recovery Infrastructure**, and then **Hyper-V hosts** (under the Hyper-V sites section).

## Known issue ##
When you register Azure Site Recovery with a cluster, if a node either fails to install Azure Site Recovery or register the Azure Site Recovery service, your VMs may not be protected. To verify all nodes in the cluster are registered in the Azure portal, go to the **Recovery Services vault**, **Jobs**, and then **Site Recovery Jobs**.

## Next steps
For more information about Azure Site Recovery, see also:

- [General questions about Azure Site Recovery](/azure/site-recovery/site-recovery-faq)
