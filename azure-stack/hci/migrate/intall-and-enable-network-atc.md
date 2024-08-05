---
title:  Install and enable Network ATC on an existing Azure Stack HCI, version 22H2 cluster
description: Learn how to install and enable Network ATC on an existing Azure Stack HCI, version 22H2 cluster
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: alkohli
ms.lastreviewed: 08/13/2024
ms.date: 08/13/2024
#Customer intent: As a Senior Content Developer, I want to provide customers with content and steps to help them successfully install and enable Network ATC on their existing Azure Stack HCI, version 22H2 cluster.
---

# Install and enable Network ATC on existing Azure Stack HCI, version 22H2 clusters

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-22h2.md)]

This article provides information on how to install and enable Network ATC on your existing Azure Stack HCI, version 22H2 cluster. Once Network ATC is enabled you can take advantage of several benefits and utilize this configuration across all new deployments.

## About Network ATC

Network ATC stores information in the cluster database, which is then replicated to other nodes in the cluster. From the initial node, other nodes in the cluster see the change in the cluster database and create a new intent. Here, we set up the cluster to receive a new intent. Additionally, we control the rollout of the new intent by stopping or disabling the Network ATC service on nodes that have virtual machines (VM) on them.

## Benefits

For Azure Stack HCI, Network ATC provides the following benefits:

- Reduces host networking deployment time, complexity, and errors.
- Deploys the latest Microsoft validated and supported best practices.
- Ensures configuration consistency across the cluster.
- Eliminates configuration drift.

## Before you begin

Before you install and enable Network ATC on your existing Azure Stack HCI, make sure:

- You're on a host that doesn't have a running VM on it
- You're on a cluster that has running workloads on the node.

## Steps to install and enable Network ATC

> [!IMPORTANT]
> If you don't have running workloads on your nodes, just add your intent command as if this was a new cluster. You don't need to continue with the next set of instructions.

### Step 1: Install Network ATC

In this step, you install Network ATC on every node in the cluster using the following command. No reboot is required.

```powershell
Install-WindowsFeature -Name NetworkATC
```

### Step 2: Pause one node in the cluster

When you pause one node in the cluster, all workloads are moved to other nodes, making your machine available for changes. The paused node is then migrated to Network ATC. To pause your cluster node, use the following command:

```powershell
Suspend-ClusterNode
```

### Step 3: Stop the Network ATC service

To prevent Network ATC from applying the intent while VMs are running, stop or disable the Network ATC service on all nodes that aren't paused. Use these commands:

```powershell
Set-Service -Name NetworkATC -StartupType Disabled
Stop-Service -Name NetworkATC
```

### Step 4: Remove the existing configuration on the paused node without running VMs

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

### Step 5: Start the Network ATC service

As a precaution, to control the speed of the rollout, we paused the node in step 2 and stopped or disabled the Network ATC service in step 3. Since Network ATC intents are implemented cluster-wide, perform this step only once.

To start the Network ATC service, on the paused node only, run the following command:

```powershell
Start-Service -Name NetworkATC
Set-service -Name NetworkATC -StartupType Automatic
```

### Step 6: Add the Network ATC intent

There are various intents that you can add. Identify the intent or intents you'd like using the examples in the next section.

To add the Network ATC intent, run the following command:

```powershell
Set-Service -Name NetworkATC -StartupType Automatic
```

### Example intents

Network ATC modifies how you deploy host networking, not what you deploy. You can deploy multiple scenarios if each scenario is supported by Microsoft. Here are some examples of common host networking patterns and the corresponding PowerShell commands for your Azure Stack HCI.

These examples aren't the only combinations available, but they should give you an idea of the possibilities.

For simplicity we only demonstrate two physical adapters per SET team, however it's possible to add more. For more information, please see [Network reference patterns overview for Azure Stack HCI](../plan/network-patterns-overview.md).

#### Group management and compute in one intent with a separate intent for storage

In this example, we have two intents that are managed across cluster nodes.

1. **Management and compute**: This intent uses a dedicated pair of network adapter ports.
2. **Storage**: This intent uses a dedicated pair of network adapter ports.

    :::image type="content" source="media/migrate-cluster-to-network-atc/group-management-and-compute.png" alt-text="Screenshot of an Azure Stack HCI cluster with a grouped management and compute intent." lightbox="media/migrate-cluster-to-network-atc/group-management-and-compute.png":::

    Here's an example to implement this host network pattern:

    ```PowerShell
    Add-NetIntent -Name Management_Compute -Management -Compute -AdapterName pNIC1, pNIC2
    
    Add-NetIntent -Name Storage -Storage -AdapterName pNIC3, pNIC4
    ```

#### Group all traffic on a single intent

In this example, a single intent is managed across cluster nodes.

1. **Management, Compute, and Storage**: This intent uses a dedicated pair of network adapter ports.

    :::image type="content" source="media/migrate-cluster-to-network-atc/group-all-traffic.png" alt-text="Screenshot of an Azure Stack HCI cluster with all traffic on a single intent." lightbox="media/migrate-cluster-to-network-atc/group-all-traffic.png":::

    Here's an example to implement this host network pattern:

    ```powershell
    Add-Netintent -Name MgmtComputeStorage -Management -Compute -Storage -AdapterName pNIC1, pNIC2
    ```

#### Group compute and storage traffic on one intent with a separate management intent

In this example, we have two intents managed across cluster nodes.

1. **Management**: This intent uses a dedicated pair of network adapter ports.
2. **Compute and Storage**: This intent uses a dedicated pair of network adapter ports.

    :::image type="content" source="media/migrate-cluster-to-network-atc/group-compute-and-storage.png" alt-text="Screenshot of an Azure Stack HCI cluster with a grouped compute and storage intent." lightbox="media/migrate-cluster-to-network-atc/group-compute-and-storage.png":::

    Here's an example to implement this host network pattern:

    ```powershell
    Add-NetIntent -Name Mgmt -Management -AdapterName pNIC1, pNIC2
    
    Add-NetIntent -Name Compute_Storage -Compute -Storage -AdapterName pNIC3, pNIC4
    ```

#### Fully disaggregated host networking

In this example, we have three intents that are managed across cluster nodes.

1. **Management**: This intent uses a dedicated pair of network adapter ports.
2. **Compute**: This intent uses a dedicated pair of network adapter ports.
3. **Storage**: This intent uses a dedicated pair of network adapter ports.

    :::image type="content" source="media/migrate-cluster-to-network-atc/fully-disaggregated.png" alt-text="Screenshot of an Azure Stack HCI cluster with a fully disaggregated intent." lightbox="media/migrate-cluster-to-network-atc/fully-disaggregated.png":::

    Here's an example to implement this host network pattern:

    ```powershell
    Add-NetIntent -Name Mgmt -Management -AdapterName pNIC1, pNIC2
    
    Add-NetIntent -Name Compute -Compute -AdapterName pNIC3, pNIC4

    Add-NetIntent -Name Storage -Storage -AdapterName pNIC5, pNIC6
    ```

### Step 7: Verify the deployment on one node

The `Get-NetIntentStatus` command shows the deployment status of the requested intents. The result returns one object per intent for each node in the cluster. For example, if you have a three-node cluster with two intents, you should see six objects, each with their own status, returned by the command.

To verify your node's successful deployment of the intents submitted in step 5, run the following command:

```powershell
Get-NetIntentStatus -Name <IntentName>
```

Here's an example of the output:

```console

PS C:\Users\administrator.CONTOSO> Get-NetlntentStatus

IntentName                  : convergedintent
Host                        : node1
IsComputelntentSet          : True
IsManagementlntentSet       : True
IsStoragelntentSet          : True
IsStretchlntentSet          : False
LastUpdated                 : 07/23/2024 11:11:15
LastSuccess                 : 07/23/2024 11:11:15
RetryCount                  : 0
LastConfigApplied           : 1
Error                       :
Progress                    : 1 of 1
ConfigurationStatus         : Success
ProvisioningStatus          : Completed
```

Ensure that each intent added has an entry for the host you're working on. Also, make sure the **ConfigurationStatus** shows **Success**.

If the **ConfigurationStatus** shows **Failed**, check to see if the error message indicates the reason for the failure. For some examples of failure resolutions, see [Common Error Messages](../deploy/network-atc.md#common-error-messages).

### Step 8: Rename the VMSwitch on other nodes

In this step, you move from the node deployed with Network ATC to the next node and migrate the VMs from this second node. You must verify that the second node has the same VMSwitch name as the node deployed with Network ATC.

This is a non-disruptive change and can be done of all the nodes simultaneously. Run the following command:

```powershell
#Run on the node where you configured Network ATC
Get-vmswitch | ft name

#Run on the next node to rename the virtual switch
Rename-VMSwitch -Name 'ExistingName' -NewName 'NewATCName'
```

After your switch is renamed, disconnect and reconnect your vNICs for the VSwitch name change to go through. Once the change goes through, on each node, run the following commands:

```powershell
$VMSW = Get-VMSwitch
$VMs = get-vm
$VMs | %{Get-VMNetworkAdapter -VMName $_.name | Disconnect-VMNetworkAdapter ; Get-VMNetworkAdapter -VMName $_.name | Connect-VMNetworkAdapter -SwitchName $VMSW.name}
```

We don't change the Network ATC VMSwitch for two reasons:

- Network ATC ensures that all nodes in the cluster have the same name to support live migration and symmetry.
- Network ATC implements and controls the names of configuration objects. Otherwise, you'd need to ensure this configuration artifact is perfectly deployed.

### Step 9: Resume the cluster node

To reenter or put your cluster back in service, run the following command:

```powershell
Resume-ClusterNode
```

> [!NOTE]
> To apply the Network ATC settings across the cluster, repeat steps 1 through 5, step 7, and step 9 for each node of the cluster.

## Next step

Learn how to [Prepare to apply solution upgrade on Azure Stack HCI, version 23H2](../index.yml).