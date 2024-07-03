---
title:  Migrate an existing Azure Stack HCI cluster to Network ATC
description: This article describes how to migrate an existing Azure Stack HCI cluster to Network ATC
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: alkohli
ms.lastreviewed: 07/02/2024
ms.date: 07/02/2024
#Customer intent: As a Senior Content Developer, I want to provide customers with content and steps to help them successfully migrate their existing Azure Stack HCI clusters to Network ATC.
---

# Migrate an existing Azure Stack HCI cluster to Network ATC

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article provides information on how to migrate your existing Azure Stack HCI cluster to Network ATC so that you can take advantage of several benefits. We also describe how to utilize this configuration across all new deployments.

## About Network ATC

Network ATC stores information in the cluster database, which is then replicated to other nodes in the cluster. From the initial node, other nodes in the cluster see the change in the cluster database and create a new intent. Here, we set up the cluster to receive a new intent. Additionally, we control the rollout of the new intent by stopping or disabling the Network ATC service on nodes that have virtual machines (VM) on them.

## Benefits

Since the release of Azure Stack HCI, version 21H2, customers utilize Network ATC to:

- Reduce host networking deployment time, complexity, and errors.
- Deploy the latest Microsoft validated and supported best practices.
- Ensure configuration consistency across the cluster.
- Eliminate configuration drift.

## Before you begin

Before you begin the migration process of your existing Azure Stack HCI cluster to Network ATC, make sure:

- You're on a host without a running VM on it.
- You're on a cluster with running workloads on the node.

## Steps to Migrate to Network ATC

> [!IMPORTANT]
> If you don't have running workloads on your nodes, just add your intent command as if this was a brand-new cluster. You don't need to continue with the next set of instructions.

### Step 1: Install Network ATC

In this step, you install Network ATC on every node in the cluster using the following command. No reboot is required.

```powershell
Install-WindowsFeature -Name NetworkATC
```

### Step 2: Pause one node in the cluster

When you pause one node in the cluster, all workloads are moved to other nodes, making your machine available for changes. The paused node is then migrated to NetworkATC. To pause your cluster node, use the following command:

```powershell
Suspend-ClusterNode
```

### Step 3: Stop the Network ATC service

To prevent Network ATC from applying the intent while VMs are running, stop or disable the Network ATC service on all nodes that aren't paused. Use these commands:

```powershell
Set-Service -Name NetworkATC -StartupType Disabled
Stop-Service -Name NetworkATC
```

### Step 4: Remove the existing configuration

In this step, we eliminate any previous configurations, such as VMSwitch, Data Center Bridging (NetQos) policy for RDMA traffic, and Load Balancing Failover (LBFO), which might interfere with Network ATC’s ability to implement the new intent. Although Network ATC attempts to adopt existing configurations with matching names; including NetQos and other settings, it’s easier to remove the current configuration and allow Network ATC to redeploy the necessary configuration items and more.

If you have more than one VMSwitch on your system, make sure you specify the switch attached to the adapters being used in the intent.

To remove the existing VMSwitch configuration, run the following command:

```PowerShell
Get-VMSwitch -Name <VMSwitchName> | Remove-VMSwitch -force
```

To remove your existing NetQos configurations, use the following commands:

```powershell
Get-NetQosTrafficClass | Remove-NetQosTrafficClass
Get-NetQosPolicy | Remove-NetQosPolicy -Confirm:$false
Get-NetQosFlowControl | Disable-NetQosFlowControl
```

LBFO isn't supported in Azure Stack HCI. However, if you accidentally deployed an LBFO team it should be removed using the following command:

```powershell
Get-NetLBFOTeam | Remove-NetLBFOTeam -Confirm:$true
```

If your nodes were configured via Virtual Machine Manager (VMM), those configuration objects may need to be removed as well.

> [!NOTE]
> Network ATC is being improved to prevent accidental oversights, including LBFO and it will avoid deploying unsupported solutions.

### Step 5: Add the Network ATC intent

As a precaution, to control the speed of the rollout, we paused the node in step 2 and stopped or disabled the Network ATC service in step 3. Since Network ATC intents are implemented cluster wide, you should only need to perform this step once.

To start the Network ATC service, on this node only, run the following command:

```powershell
Set-Service -Name NetworkATC -StartupType Automatic
Start-Service -Name NetworkATC
```

There are various intents that you can add. Identify the intent or intents you'd like using the examples in the next section.

[!INCLUDE [migrate-cluster-network-atc-intent](../../includes/migrate-cluster-network-atc-intent.md)]

For more information on Network ATC, see [Deploy host networking with Network ATC](../deploy/network-atc.md).

### Step 6: Verify the deployment on one node

The `Get-NetIntentStatus` command shows the deployment status of the requested intents. The result returns one object per intent for each node in the cluster. For example, if you have a three-node cluster with two intents, you should see six objects, each with their own status, returned by the command.

To verify your node's successful deployment of the intents submitted in step 5, run the following command:

```powershell
Get-NetIntentStatus -Name <IntentName>
```

Here's an example:

:::image type="content" source="media/migate-cluster-to-network-atc/get-net-intent-status-output.png" alt-text="Screenshot of Get NetIntentStatus command results using PowerShell"  lightbox="media/migate-cluster-to-network-atc/get-net-intent-status-output.png":::

Ensure that each intent added has an entry for the host you're working on. Also, make sure the **ConfigurationStatus** shows **Success**.

If the **ConfigurationStatus** shows **Failed**, check to see if the error message indicates the reason for the failure. For some examples of failure resolutions, see [Common Error Messages](../deploy/network-atc.md#common-error-messages).

### Step 7: Rename the VMSwitch on other nodes

In this step, you move from the node deployed with Network ATC to the next node and migrate the VMs from this second node. You must verify that the second node has the same VMSwitch name as the node deployed with Network ATC.

This change is a non-disruptive and can be done on all nodes at the same time, using the following command.

```powershell
Rename-VMSwitch -Name 'ExistingName' -NewName 'NewATCName'
```

After your switch is renamed, disconnect and reconnect your vNICs for the VSwitch name change to go through. Once the change goes through, on each node, run the following commands:

```powershell
$VMSW=Get-VMSwitch
$VMs = get-vm
$VMs | %{Get-VMNetworkAdapter -VMName $_.name | Disconnect-VMNetworkAdapter ; Get-VMNetworkAdapter -VMName $_.name | Connect-VMNetworkAdapter -SwitchName $VMSW.name}
```

>[!NOTE]
> We don't change the Network ATC VMSwitch for two reasons:
>
> - Network ATC ensures that all nodes in the cluster have the same name to support live migration and symmetry.
> - Network ATC implements and controls the names of configuration objects. Otherwise, you'd need to ensure this configuration artifact is perfectly deployed.

### Step 8: Resume the cluster node

To reenter or put your cluster back in service, run the following command:

```powershell
Resume-ClusterNode
```

> [!NOTE]
> To complete the migration to Network ATC across the cluster, follow steps 1-4, 6, and 8 for each node.


