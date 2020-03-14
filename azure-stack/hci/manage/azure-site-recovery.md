---
title: Protect your Hyper-V VMs with Azure Site Recovery and Windows Admin Center
description: Use Windows Admin Center to protect Hyper-V VMs with Azure Site Recovery.
ms.topic: article
author: haley-rowland
ms.author: harowl
ms.date: 03/12/2020
ms.localizationpriority: low
---

# Protect your Hyper-V VMs with Azure Site Recovery and Windows Admin Center

>Applies To: Windows Admin Center Preview, Windows Admin Center

Windows Admin Center streamlines the process of replicating virtual machines (VMs) on your Hyper-V servers or clusters, giving you the power to take advantage of Azure from your own datacenter. To automate setup, you connect the Windows Admin Center gateway to Azure.

This article shows you how to configure replication settings and create a recovery plan in the Azure portal. Completing these tasks enables Windows Admin Center to start VM replication to protect your VMs.

To learn more, see [About Azure integration with Windows Admin Center](../plan/azure-integration-options.md).

## How Azure Site Recovery works with Windows Admin Center

**Azure Site Recovery** is an Azure service that replicates workloads running on VMs so that your business-critical infrastructure is protected from a disaster. To learn more, see [About Site Recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-overview).

Azure Site Recovery consists of two components: **replication** and **failover**. The replication portion protects your VMs in case of disaster by replicating the target VM's VHD to an Azure storage account. You can then fail over the VMs and run them in Azure in the event of a disaster. You can also perform a test failover without impacting your primary VMs to test the recovery process in Azure.

Completing setup for the replication component alone is sufficient to protect your VMs from a disaster. However, you won't be able to start the VMs in Azure until you configure the failover portion of the process.

You can set up the failover portion when you want to failover to an Azure VM, because it's not required during initial setup. If the host server goes down, you can configure the failover component at that time and access the workloads of the protected VM. However, we recommend configuring the failover related settings before a disaster.

## Prerequisites and planning

The following is required to complete the steps in this article:

- The target servers hosting the VMs that you want to protect must have Internet access to replicate to Azure.
- A connection from your Windows Admin Center gateway to Azure. For more information, see [Configuring Azure integration](https://docs.microsoft.com/windows-server/manage/windows-admin-center/azure/azure-integration).
- Review the capacity planning tool to evaluate the requirements for successful replication and failover. For more information, see [About the Azure Site Recovery Deployment Planner for Hyper-V disaster recovery to Azure](https://docs.microsoft.com/azure/site-recovery/hyper-v-site-walkthrough-capacity).

## Step 1: Set up VM protection on your target host

Complete the following steps once per host server or cluster containing the VMs that you want to target for protection:

1. In Windows Admin Center, navigate to the server or cluster hosting the VMs that you want to protect (via either with **Server Manager** or **Cluster Manager**).
1. Under **Tools** click **Virtual machines** and then click the  **Inventory** tab.
1. Select any VM (it doesn't need to be the VM that you want to protect).
1. Expand the **More** submenu and then click **Set up VM Protection**.
1. Sign in to your Azure Account.
1. Enter the required information:

   - **Subscription:** The Azure subscription that you want to use for VM replication on this host.
   - **Location:** The Azure region where the ASR resources should be created.
   - **Storage Account:** The storage account where replicated VM workloads on this host will be saved.
   - **Vault:** A name for the Azure Site Recovery vault for the protected VMs on this host.

1. Select **Setup ASR**.
1. Wait until you see the notification: **Site Recovery Setting Completed**.
 
This could take up to 10 minutes. You can watch the progress by going to **Notifications** (the bell icon at the top right of Windows Admin Center).

>[!NOTE]
> This process automatically installs the ASR agent onto the target server or nodes (if you are configuring a cluster), and creates a **Resource Group** with the specified **Storage Account** and **Vault**, in the specified **Location**. It also registers the target host with the ASR service and configures a default replication policy.

## Step 2: Select VMs to protect

Complete the following steps to protect your VMs:

1. In Windows Admin Center, return to the server or cluster that you configured in the previous task, and go to **Virtual Machines > Inventory**.
1. Under **Tools** click **Virtual machines** and then click the  **Inventory** tab.
1. Select the VM that you want to protect, then expand the **More** submenu and click **Protect VM**.
1. Review capacity requirements for protecting the VM. For more information, see [Plan capacity for Hyper-V VM disaster recovery](https://docs.microsoft.com/azure/site-recovery/site-recovery-capacity-planner).

    If you want to use a premium storage account, [create one in the Azure portal](https://docs.microsoft.com/azure/storage/common/storage-premium-storage). The **Create New** option provided in the Windows Admin Center pane creates a standard storage account.

1. Enter the name of the **Storage Account** to use for this VM's replication, and then select **Protect VM** to enable replication for the VM. 

    Azure Site Recovery (ASR) starts the replication process. The VM is protected when the value in the **Protected** column of the **Virtual Machine Inventory** grid changes to **Yes**. This can take several minutes.  

## Step 3: Configure and run a test failover in the Azure portal

 Although it is not required to complete this step before starting VM replication (the VM is protected with only replication), we recommend configuring failover settings when you set up ASR.
 
 Complete the following steps to prepare failover to an Azure VM:

1. Set up an Azure network that the failed-over VM will attach to this VNET. To learn more, see [Set up disaster recovery of on-premises Hyper-V VMs to Azure](https://docs.microsoft.com/azure/site-recovery/hyper-v-site-walkthrough-prepare-azure). 

    >[!NOTE]
    > Windows Admin Center automatically completes the steps in this resource. You only need to set up the Azure network.

1. Run a test failover. To learn more, see [Run a disaster recovery drill to Azure](https://docs.microsoft.com/azure/site-recovery/hyper-v-site-walkthrough-test-failover).

## Step 4: Create recovery plans

**Recovery Plan** is a feature in ASR that lets you failover and recover an entire application comprising a collection of VMs. While it is possible to recover protected VMs individually, by adding the VMs of an application to a recovery plan, you can fail over the entire application through the recovery plan. You can also use the test failover feature of Recovery Plan to test the recovery of the application.

Recovery Plan lets you group VMs, sequence the order in which they should be brought up during a failover, and automate additional steps as part of the recovery process. After you've protected your VMs, you can go to the Azure Site Recovery vault in the Azure portal to create recovery plans for them. To learn more, see [Create and customize recovery plans](https://docs.microsoft.com/azure/site-recovery/site-recovery-create-recovery-plans).

## Monitor replicated VMs in Azure

To verify no failures in server registration processs, go to the **Azure portal**, click **All resources**, click **Recovery Services Vault** (the one you specified in the first task, Step 6) click **Jobs**, and then click **Site Recovery Jobs**.

To monitor VM replication, go to the **Recovery Services Vault**, and then **Replicated Items**.

To see all servers that are registered to the vault, go to **Recovery Services Vault**, **Site Recovery Infrastructure**, and then **Hyper-V hosts** (under the Hyper-V sites section).

## Known issue ##

When registering ASR with a cluster, if a node fails to install ASR or register to the ASR service, your VMs may not be protected. Verify that all nodes in the cluster are registered in the Azure portal by going to the **Recovery Services vault**, **Jobs**, and then **Site Recovery Jobs**.