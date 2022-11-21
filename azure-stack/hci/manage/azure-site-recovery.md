---
title: Protect your Hyper-V Virtual Machines with Azure Site Recovery and Windows Admin Center
description: Use Windows Admin Center (Project Honolulu) to protect Hyper-V VMs with Azure Site Recovery.
ms.topic: article
author: sethmanheim
ms.author: sethm
ms.date: 11/02/2022
---
# Protect your Hyper-V Virtual Machines with Azure Site Recovery and Windows Admin Center

>Applies to: Azure Stack HCI, version 21H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

Windows Admin Center streamlines the process of replicating your virtual machines on your Hyper-V servers or clusters, making it easier to use the power of Azure from your own datacenter. To automate setup, you can connect the Windows Admin Center gateway to Azure.

Use the following information to configure replication settings and create a recovery plan from within the Azure portal. The plan enables Windows Admin Center to start VM replication and protect your VMs.

> [!IMPORTANT]
> If you're using an Azure Stack HCI cluster, it's strongly recommended that you manually install the Azure Site Recovery (ASR) agents on each node of your cluster. For more information, see [Set up disaster recovery of on-premises Azure Stack HCI VMs to Azure](/azure/site-recovery/hyper-v-azure-tutorial).

## What is Azure Site Recovery and how does it work with Windows Admin Center?

*Azure Site Recovery* is an Azure service that replicates workloads running on VMs so that your business-critical infrastructure is protected if there's a disaster. For more information about Azure Site Recovery, see [Learn more about Azure Site Recovery](/azure/site-recovery/site-recovery-overview).

Azure Site Recovery consists of two components: **replication** and **failover**. The replication portion protects your VMs in case of disaster by replicating the target VM's VHD to an Azure storage account. You can then fail over these VMs and run them in Azure in the event of a disaster. You can also perform a test failover without impacting your primary VMs to test the recovery process in Azure.

Completing setup for the replication component alone is sufficient to protect your VM in the case of disaster. However, you won't be able to start the VM in Azure until you configure the failover portion. You can set up the failover portion when you want to fail over to an Azure VM - this isn't required as part of the initial setup. If the host server goes down and you haven't yet configured the failover component, you can configure it at that time and access the workloads of the protected VM. However, it's a good practice to configure the failover-related settings before a disaster.

## Prerequisites and planning

- The target servers hosting the VMs you want to protect must have internet access to replicate to Azure.
- [Connect your Windows Admin Center gateway to Azure](/windows-server/manage/windows-admin-center/azure/azure-integration).
- [Review the capacity planning tool to evaluate the requirements for successful replication and failover](/azure/site-recovery/hyper-v-site-walkthrough-capacity).

## Step 1: Set up VM protection on your target host

> [!NOTE]
> You need to do this step once per host server or cluster containing VMs targeted for protection.

1. Navigate to the server or cluster hosting VMs you want to protect (either with Server Manager or Hyper-Converged Cluster Manager).
2. Go to **Virtual Machines** > **Inventory**.
3. Select any VM (this doesn't need to be the VM you want to protect).
4. Select **Manage** > **Replicate using Azure Site Recovery**.
5. Sign into your Azure Account.
6. Enter the required information:

   - **Subscription:** The Azure subscription you want to use for replication of VMs on this host.
   - **Resource Group:** The resource group in which the Azure Site Recovery vault will be located.
   - **Recovery Service Vault:** Choose a name for the Azure Site Recovery vault for protected VMs on this host.
   - **Location:** The Azure region where the Azure Site Recovery resources should be created.

7. Select **Setup ASR**.
8. Wait until you see the notification: **Site Recovery Setting Completed**.

This could take up to 10 minutes. You can watch the progress by going to **Notifications** (the bell icon at the top right of the window).

> [!NOTE]
> This step automatically installs the Azure Site Recovery agent onto the target server or nodes (if configuring on a cluster), creates a **Resource Group** with the **Storage Account** and **Vault** specified, in the **Location** specified. This step also registers the target host with the Azure Site Recovery service and configures a default replication policy.

## Step 2: Select virtual machines to protect

1. Navigate back to the server or cluster you configured in step 2 above, and go to **Virtual Machines > Inventory**.
2. Select the VM you want to protect.
3. Select **Manage** > **Replicate using Azure Site Recovery**.
4. Review the [capacity requirements for protecting the VM](/azure/site-recovery/site-recovery-capacity-planner).

    If you want to use a premium storage account, [create one in the Azure portal](/azure/storage/common/storage-premium-storage). The **Create New** option provided in the Windows Admin Center pane creates a standard storage account.

5. Enter the name of the **Storage Account** to use for this VM's replication, and select **Protect VM**. This step enables replication for the selected Virtual Machine.

6. Azure Site Recovery will start replication. Replication is completed and the VM is protected when the value in the **Protected** column of the **Virtual Machine Inventory** grid changes to **Yes**. This can take several minutes.

## Step 3: Configure and run a test failover in the Azure portal

Although you don't need to complete this step when starting VM replication (the VM will already be protected with just replication), it's recommended that you configure failover settings when you set up Azure Site Recovery. If you want to prepare for failover to an Azure VM, complete the following steps:

1. [Set up an Azure network](/azure/site-recovery/hyper-v-site-walkthrough-prepare-azure) the failed-over VM will attach to this VNET. Note that the other steps listed in the linked page are completed automatically by Windows Admin Center; you only need to set up the Azure network.
2. [Run a test failover](/azure/site-recovery/hyper-v-site-walkthrough-test-failover).

## Step 4: Create Recovery Plans

*Recovery Plan* is a feature in Azure Site Recovery that lets you fail over and recover an entire application comprising a collection of VMs. While it is possible to recover protected VMs individually, by adding the VMs comprising an application to a recovery plan, you'll be able to fail over the entire application through the recovery plan. You can also use the test failover feature of Recovery Plan to test the recovery of the application. Recovery Plan lets you group VMs, sequence the order in which they should be brought up during a failover, and automate additional steps to be performed as part of the recovery process. Once you've protected your VMs, you can go to the Azure Site Recovery vault in the Azure portal and create recovery plans for these VMs. [Learn more about recovery plans](/azure/site-recovery/site-recovery-create-recovery-plans).

## Monitoring replicated VMs in Azure

To verify there are no failures in server registration, go to the Azure portal and select **All resources** > **Recovery Services Vault**  (the one you specified in Step 2) > **Jobs** > **Site Recovery Jobs**.

You can monitor VM replication by going to the **Recovery Services Vault** > **Replicated Items**.

To see all servers that are registered to the vault, go to **Recovery Services Vault** > **Site Recovery Infrastructure** > **Hyper-V hosts** (under the Hyper-V sites section).

## Known issue

When you register Azure Site Recovery with a cluster, if a node fails to install Azure Site Recovery or register to the Azure Site Recovery service, your VMs may not be protected. Verify that all nodes in the cluster are registered in the Azure portal by going to the **Recovery Services vault** > **Jobs** > **Site Recovery Jobs**.

## Next steps

[Learn more about Azure integration with Windows Admin Center](/windows-server/manage/windows-admin-center/azure/index)
