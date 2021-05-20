---
title: Network ATC for Azure Stack HCI
description: This topic covers how to configure and validate network ATC functionality for Azure Stack HCI.
author: v-dasis
ms.topic: conceptual
ms.date: 05/25/2021
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Network ATC for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2

These article guides you through the key functions of using Network ATC, which is used to simplify the deployment and network configuration management for Azure Stack HCI nodes. Network ATC provides an intent-based approach to host network deployment. By specifying one or more intents (management, compute, storage) for a network adapter, Network ATC can automate the deployment of the intended configuration. All tasks discussed here are run using Windows PowerShell.

If you have feedback or encounter any issues, first review the Requirements and Limitations section, then check the Network ATC event log, then work with your Microsoft Customer Engineer or email us at **SDNBlackbelt@Microsoft.com**. If you encounter an issue requiring support assistance, ensure you can reproduce the issue in a trace. To capture a trace, use the `Set-NetIntentTracing` cmdlet.

## Overview

Deployment and operation of Azure Stack HCI networking can be complex and error-prone. Due to the configuration flexibility provided with the host networking stack, there are many moving parts that can be easily overlooked. Standardization  across HCI cluster nodes is important as it leads to a more reliable and consistent experience. Lastly, staying up to date with the latest best practices is a challenge as improvements are continuously made to the underlying technologies.

Network ATC can:

- Reduce host networking deployment time and complexity
- Reduce host networking configuration errors
- Deploy the latest, Microsoft validated, and supported best practices
- Eliminate configuration drift

Network ATC can be used in standalone mode or clustered mode. Modes are system-wide - you can't have a network intent that is standalone and another that is clustered on the same host system.

**Standalone mode**: Intent is expressed for each host. Once a host is clustered, any standalone intents are ignored. This mode allows you to test an intent before implementing it across a cluster. Standalone intents can be copied to a cluster from a node that is not a member of that cluster.

**Clustered mode**: Intent is expressed once for a cluster. This is the recommended deployment mode and is required when a server is a member of a failover cluster.

## Requirements and limitations

The following are requirements and limitations for using the Network ATC feature in Azure Stack HCI:

- Supported on Azure Stack HCI, version 21H2, Preview release or later.

- Must use two or more identical physical host systems with virtualization capability. All cluster nodes must use the same hardware.

- Must use Azure Stack HCI-capable physical adapters of the same make, model, speed, and configuration for each cluster node.

- Must use the same name for each physical adapter.

- Must insert each adapter in the same PCI slot(s) in each host. This leads to ease in automated naming conventions by imaging systems.

- Ensure each network adapter has an "Up" status, as verified by the PowerShell `Get-NetAdapter` cmdlet.

- Remove any prior ATC configurations on the system.

- Must install Azure Stack HCI, version 21H2, build FE_RELEASE\20324.3.210327-1200 or later on each node.

- Must install the following Windows features on each node:

  - NetworkATC service
  - Data Center Bridging service
  - Failover Clustering service
  - Hyper-V service

You can use the following cmdlet to install these services:

```powershell
Install-WindowsFeature Name NetworkATC, Data-Center-Bridging, Failover-Clustering, Hyper-V IncludeManagementTools
```

> [!NOTE]
> Network ATC does not require a system reboot if the other Windows features have already been installed. Additionally, the NetworkATC service should automatically be running once installed.

## Using Windows PowerShell

There are several new PowerShell commands included with the Network ATC service. Run the`Get-Command -NetworkATC` cmdlet to identify them. Be sure and always run PowerShell as an administrator.

Typically, only a few of the Network ATC cmdlets are needed. Here is a brief overview of these before you start:

|Command|Description|
|--|--|
|Add-NetIntent|Creates and submits an intent to the NetworkATC service|
|Set-NetIntent|Modifies an existing intent|
|Get-NetIntent|Gets a list of intent requests from the target|
|Get-NetIntentStatus|Gets the status of intent requests from the target|
|New-NetIntent…Overrides|Specifies overrides to the default configuration|
|Remove-NetIntent|Removes an intent from the local node or cluster. This does not destroy the configuration invoked by Network ATC.
|Set-NetIntentRetryState|If ATC is unable to provision the configuration, this instructs ATC to stop attempting again (`Get-NetIntentStatus` reports 'Failed' state) to prevent ATC from unnecessarily consuming system resources. Use this cmdlet to tell the service to retry.|

## Example network intents

Network ATC modifies how you deploy host networking, not what you deploy. ATC can handle multiple scenarios so long as the scenario is supported by Microsoft. Here are some examples of common deployment options, and the PowerShell commands needed.
These are not the only combinations available but should give you an idea of the possibilities.

For simplicity we only demonstrate two pNICs per team however it is possible to add up to eight pNICs in a SET team.

### Fully converged intent

For this intent, Network ATC handles compute, storage, and management networks together.

:::image type="content" source="media/network-atc/network-atc-2.png" alt-text="Fully converged network intent"  lightbox="media/network-atc/network-atc-2.png":::

```powershell
Add-NetIntent -Management -Compute -Storage -ClusterName HCI01 -AdapterName pNIC01, pNIC02
```

### Converged compute and storage; separate management intent

For this intent, Network ATC handles compute and storage together, and management networks separately.

:::image type="content" source="media/network-atc/network-atc-3.png" alt-text="Storage and compute converged network intent"  lightbox="media/network-atc/network-atc-3.png":::

```powershell
Add-NetIntent -Management -ClusterName HCI01 -AdapterName pNIC01, pNIC02
Add-NetIntent -Compute -Storage -ClusterName HCI01 -AdapterName pNIC03, pNIC04
```

### Fully disaggregated intent

For this intent, Network ATC handles compute, storage, and management networks separately.

:::image type="content" source="media/network-atc/network-atc-4.png" alt-text="Fully disaggregated network intent"  lightbox="media/network-atc/network-atc-4.png":::

```powershell
Add-NetIntent -Management -ClusterName HCI01 -AdapterName pNIC01, pNIC02
Add-NetIntent -Compute -ClusterName HCI01 -AdapterName pNIC03, pNIC04
Add-NetIntent -Storage -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```

### Storage-only intent

For this intent, Network ATC manages storage only.

:::image type="content" source="media/network-atc/network-atc-5.png" alt-text="Storage only network intent"  lightbox="media/network-atc/network-atc-5.png":::

```powershell
Add-NetIntent -Storage -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```

### Compute and management intent

For this intent, Network ATC manages compute and management networks, but not storage.

:::image type="content" source="media/network-atc/network-atc-6.png" alt-text="Management and compute network intent"  lightbox="media/network-atc/network-atc-6.png":::

```powershell
Add-NetIntent -Management -Compute -ClusterName HCI01 -AdapterName pNIC01, pNIC02
```

### Multiple compute (switch) intent

For this intent, Network ATC manages multiple compute switches.

:::image type="content" source="media/network-atc/network-atc-7.png" alt-text="Multiple switches network intent"  lightbox="media/network-atc/network-atc-7.png":::

```powershell
Add-NetIntent -Compute -ClusterName HCI01 -AdapterName pNIC03, pNIC04
Add-NetIntent -Compute -ClusterName HCI01 -AdapterName pNIC05, pNIC06
```

## Activity overview

Activities represent key functions of the Network ATC service. The activities listed here do not modify your deployment process. If you configured host networking prior to creating a cluster, you may continue to do so. Alternatively, if you create host networking on a single-node cluster, then add nodes to the cluster and configure the hosts, this is also possible with Network ATC.

You can specify any combination of the following intents:

- Compute – adapters will be used to host virtual machines
- Storage – adapters will be used for Storage Spaces Direct
- Management – adapters will be used for management access to nodes. This intent is not covered in this article, but feel free to explore.

Below are the activities covered in this article:

1. (Optional) Activity 1: Standalone configuration

1. (Optional) Activity 2: Clustered configuration

1. Activity 3: Configure overrides

1. Activity 4: Backup and restore a configuration

## Activity 1: Standalone node configuration

In this activity, we will use Network ATC to configure the first node prior to cluster creation.

The intent is to use two physical adapters (named pNIC01 and pNIC02) from their default installation state with no networking configuration, for storage (Storage Spaces Direct) and compute (Hyper-V) traffic.

:::image type="content" source="media/network-atc/network-atc-1.png" alt-text="Network intent"  lightbox="media/network-atc/network-atc-1.png":::

### Task 1: Configure the first node

1. On the first node, run `Get-NetAdapter` to review the physical adapters present. In this example, we are showing two physical adapters pNIC01 and pNIC02:

    ```powershell
    Get-NetAdapter pNIC01, pNIC02 | Sort Name
    ```

1. Run the following command to add storage and compute tags to pNIC01 and pNIC02. Since we do not yet have a cluster, we are deploying the configuration to the local node:

    ```powershell
    Add-NetIntent -AdapterName pNIC01, pNIC02 -IntentName 'Compute_Storage_Intent' -Compute -Storage
    ```

1. Run the `Get-NetIntent` cmdlet to see all intents on your system. Alternatively, you can specify the `-IntentName` parameter to see details of only a specific intent. The following parameters are all that are needed:

    - IntentName
    - IsCompute
    - IsStorage
    - IsManagement
    - Properties ending in "Override"

    ```powershell
    Get-NetIntent 
    ```

    The `Override` properties returned from the `Get-NetIntent` cmdlet are expandable in PowerShell. Overrides are discussed in detail later.

1. The Status parameter should show "Provisioning".

1. After a few minutes, the Status parameter should show "Success". If you see an error for the Status parameter, check the event logs for issues.

### Task 2: Verify configuration changes

The intent in Task 1 was to use specific adapters to provide Hyper-V VMs with connectivity to the physical environment and Storage Spaces Direct connectivity between nodes. As a result, the system translated this intent into a set of actions that it could enact.

In this task, we review the actual configuration changes. You can modify the intents of the adapters and see the differences between the enacted configuration.

1. The pNIC `VLANID` property is reset to 0. This is because the compute tag was specified and pNICs in the team must be configured to 0.

    ```powershell
    Get-NetAdapterAdvancedProperty -Name pNIC01, pNIC02 -RegistryKeyword VLANID
    ```

1. RSS and VMQ settings have been configured to the recommended defaults.

1. Since the `Storage` tag was applied, NetworkDirect (RDMA) was enabled if the adapter supports it and NetworkDirectTechnology (iWARP or RoCE) was configured to the recommended defaults for that adapter.

    See the Appendix for the adapter configuration decision tree.

1. A virtual switch was created as part of the `compute` tag. By default, the switch is created with the following characteristics:

    - `AllowManagementOS $false`: Management tag was not specified

    - `EnableIov $true`: This is the recommended setting. This can be overridden using at intent submission time only because it is a destructive action to add or remove later.

    - `EnableEmbeddedTeaming $true`

    ```powershell
    Get-VMSwitch
    ```

1. Since the `storage` tag was added to an adapter that shares the compute tag, a vSwitch was created. Therefore, host vNICs were also provisioned (one for each physical team member). In this case since there are two physical adapters, we create two storage host virtual NICs and map them to a specific pNIC.

    > [!NOTE]
    > The adapters are named by the intent to the pNIC name they are team-mapped to for easy identification.

    ```powershell
    Get-VMNetworkAdapter -ManagementOS
    Get-VMNetworkAdapterTeamMapping -ManagementOS
    ```

1. The vNICs were given APIPA addresses (169.254.x.x) and given the ATC default VLANs (see the Appendix). You should provide IP Addresses for each of the host vNICs provisioned by Network ATC. Note that the names of the host vNICs may be different at release time.

    ```powershell
    Get-VMNetworkAdapterIsolation -ManagementOS | Sort DefaultIsolationID
    ```

1. The vNICs have also been configured for use with synthetic (non-RDMA) traffic. For RDMA adapters, this is a safety net in case the adapters are unable to use RDMA between nodes.

    > [!NOTE]
    > Both VMMQ and VRSS were requested to be true. The `VMMQEnabled` and `VRSSEnabled` properties may not show true if your system is unable to enable VMQ or VMMQ.

    ```powershell
    Get-VMNetworkAdapter -ManagementOS -Name ATC* | Select *VMMQ*, *VRSS*
    ```

1. Finally, default DCB settings are enacted on the system (see the Appendix). This will occur regardless of whether you have iWARP or RoCE adapters. For this to be effective, the fabric must also be configured. If it is not, there is no harm in configuring the nodes even if your intent is not to use DCB.

    ```powershell
    Get-NetQosPolicy | Sort PriorityValue | Select Name, PriorityValue
    ```

    These adapters were 40 Gbps so the cluster reservation was configured to 1%.

    ```powershell
    Get-NetQosTrafficClass
    ```

    > [!NOTE]
    > DCBX is not supported on adapters attached to a vSwitch. As a result, we disable it.

    ```powershell
    Get-NetQosDcbxSetting pNIC01, pNIC02
    ```

1. Review the various configurations and validate that appropriate settings have been configured.

### Task 3: Validate remediation of configuration drift

Now let’s test remediation of configuration drift. Be aware that only certain configuration items currently support drift remediation. Additionally, we will not take destructive operations or operations that could cause outages.

For example, if the vSwitch is not created and its pNICs are already bound to another team, we will not be able to invoke the intent because we would need to remove the pNICs from another team, which could cause an outage. Many of the "broken" scenarios are due to these dependencies where an administrator should get involved.

> [!TIP]
> the best way to determine whether you have a Network ATC problem or a system problem is to run the configuration manually on your system to see if the commands succeed.

1. [Optional] Modify the default timers to increase the speed at which changes are detected and drift is remediated. To do this, run `Update-NetworkATC` and specify one or more of the available parameters:

    - `DriftTimerInMinutes` - Specifies the number of minutes before drift is detected.
      - Example: Virtual Switch is removed, or physical adapter settings has deviated
      - Min: 1 minute
      - Max: 30 minutes
    - `ConfigurationChangeInSeconds` - How often we check for an update, override, or retry state
      - Example: An override is entered, or a new intent is submitted
      - Min: 30 seconds
      - Max: 1800 seconds (30 minutes)

    > [!NOTE]
    > All online nodes in a cluster are configured to the same value.

    For this example, set them to the minimum values:

    ```powershell
    Update-NetworkATC -DriftTimerInMinutes 1 -ConfigurationChangeInSeconds 30
    ```

1. Remove the vSwitch. This will in turn remove the associated vNICs and configuration with the team.

    ```powershell
    Get-VMSwitch
    ```

1. Run the `Get-NetIntentStatus` cmdlet:

    ```powershell
    Get-NetIntentStatus -ComputerName $thisHost -IntentName compute_Storage
    ```

     -`Error: ProvisioningFailed` means that something is not in compliance with the defined intent

     -`Status: Retrying` means that the system will attempt to remediate the system

    > [!NOTE]
    > It can take a few minutes for the system to recognize drift. This is because we do not want to check constantly and waste unnecessary CPU cycles.
 
1. Shortly, the system should reprovision the necessary configuration items including the vSwitch and vNICs.

### Task 4: Recover from broken states

Certain configuration items cannot be remediated either due to an error or functional reason (not destroying an in-use component). This task will explore the behavior of the NetworkATC service when a configuration item cannot be provisioned.

Imagine you already provisioned a physical adapter to a vSwitch on the system. Next, you specify intent for that physical adapter. As we will not take an action that could cause an outage (removing a NIC from an existing team), we fail the operation. After three attempts, we stop attempting to resolve the issue to prevent over-consumption of system resources.

In this task, we demonstrate how to recover from such a situation.

1. Break the configuration. To do this, stop the NetworkATC service. This is needed only to prevent the service from attempting to provision the configuration again unnecessarily.

1. Run the `Remove-VMSwitchTeamMember` cmdlet to remove one of the pNICs from the team, then create a new switch with that pNIC:

    ```powershell
    Remove-VMSwitchTeamMember -VMSwitchName ATC#ConvergedSwitch_1 -NetAdapterName pNIC01
    New-VMSwitch -Name BadSwitch -NetAdapterName pNIC01
    ```

1. Start the NetworkATC service:

    ```powershell
    Start-Service NetworkATC
    ```

1. Take note of the Status "Retrying" and RetryCount "2". The service is trying again to resolve the issue.

1. Run `Get-NetIntentStatus`. After the third attempt and to avoid an endless loop, the service will stop attempting to provision the configuration.

1. Remove BadSwitch:

    ```powershell
    Remove-VMSwitch BadSwitch
    ```

1. Run `Set-NetIntentRetryState` to ask the service to reattempt provisioning:

    ```powershell
    Set-NetIntentRetryState -ComputerName $thisHost -IntentName compute_Storage
    ```

1. Verify the configuration has been provisioned as expected.

## Activity 2: Clustered configuration

In this activity, we will use Network ATC to maintain a consistent configuration across all cluster nodes. This is beneficial for several reasons and improves the reliability of the cluster.

With Network ATC, the cluster is considered the configuration boundary. That is, all nodes in the cluster share the same configuration (symmetric intent).

You can start with a clustered configuration. You do not need to start in standalone and move to a clustered configuration if you already have a cluster created.

> [!IMPORTANT]
> If a node is clustered, you must use a clustered intent. Standalone intents are ignored.

### Task 1: Create a single-node cluster

Using another node (not the node used in Activity 1), create a cluster. The node will be a single node cluster for demonstration purposes. We will add the other nodes to the cluster later (don't do this now).

> [!NOTE]
> You could add all nodes at one time with New-Cluster, then add the intent to all nodes.

1. Create the cluster on the first node. A simple example is shown as follows:

    ```powershell
    New-Cluster -Name HCIATCluster01
    ```

1. At the end of this section, there should be only a single node in the cluster:

    ```powershell
    Get-Cluster
    Get-ClusterNode
    ```

### Task 2: (Optional) Copy the intent to the cluster

If you provisioned a local standalone intent (as in Activity 1) you can copy the local intent to the cluster. This is useful if you want to provision the first node for testing purposes, then later add the node to a cluster.

If you did not perform Activity 1, you can move directly to Task 3.

> [!NOTE]
> Copying an intent from one member of the cluster to the same cluster is not supported. Only the following scenarios are supported:
> - Standalone intent on a standalone node: can copy to cluster node for cluster intent
> - Cluster intent on a cluster node: can copy to another cluster

Cluster-based intents override the intent specified on the standalone node.

1. Run the `Copy-NetIntent` command to move the standalone intent to a clustered intent:

    ```powershell
    Copy-NetIntent -IntentName Compute_Storage_Intent -DestinationClusterName HCIATCluster01
    ```

1. Run `Get-NetIntent` and specify the `-ClusterName` parameter:

    ```powershell
    Get_netIntent -ClusterName HCIATCluster01
    ```
 
1. You can optionally remove the standalone intent entered in Activity 1 using `Remove-NetIntent`:

    ```powershell
    Remove-NetIntent -IntentName compute_storage -ComputerName 'computer_name'
    ```

    > [!NOTE]
    > When the `-ClusterName` parameter is used, the intent will be added to the cluster database.

### Task 3: Add a new node to the cluster

Now that the configuration is stored in the cluster database, you can freely add nodes to the cluster. The Network ATC service ensures that each node in the cluster receives the same intent, improving the reliability of the cluster.

This symmetry is likely to be the primary challenge with network configuration provisioning. This is a new requirement for administrators, however it should not be overly onerous to ensure that same-named adapters exist on each cluster node.

In this task, you will add additional nodes to the cluster and observe how Network ATC enforces a consistent configuration across all nodes in the cluster.

1. Use the `Add-ClusterNode` cmdlet to add the additional (unconfigured) nodes to the cluster. You need only have management access to the cluster at this time. Each node in the cluster should have all pNICs named the same.

    ```powershell
    Add-ClusterNode -Cluster HCIATCluster01
    Get-ClusterNode
    ```

1. Check the status across all cluster nodes using the `-ClusterName` parameter.

    ```powershell
    Get-NetIntentStatus -ClusterName HCIATCluster01
    ```

    > [!NOTE]
    > If pNICs do not exist on one of the additional nodes, `Get-NetIntentStatus` will report the error 'PhysicalAdapterNotFound', which easily identifies the provisioning issue.

1. Check the provisioning status of all nodes using `Get-NetIntentStatus`. The cmdlet reports the configuration for both nodes. Note that this may take a similar amount of time to provision as the original node.

    ```powershell
    Get-NetIntentStatus -ClusterName HCIATCluster01
    ```

1. You can experiment by adding several nodes to the cluster at once.

### Task 4: (Optional) Create a cluster configuration immediately

In this task, we assume that you did not provision a local standalone intent in Activity 1 and are ready to create a clustered intent from the outset.

1. On one of the cluster nodes, run `Get-NetAdapter` to review the physical adapters. Ensure that each node in the cluster has the same named physical adapters.

    ```powershell
    Get-NetAdapter -Name pNIC01, pNIC02 -CimSession (Get-ClusterNode).Name | Select Name, PSComputerName
    ```

1. Run the following command to add the storage and compute tags to pNIC01 and pNIC02. Note that we specify the `-ClusterName` parameter rather than the `-ComputerName` as in Activity 1.

    ```powershell
    Add-NetIntent -Name Cluster_ComputeStorage -Compute -Storage -ClusterName HCI01 -AdapterName pNIC01, pNIC02
    ```

    The command should immediately return. The cmdlet checks that each node in the cluster:

    - has the adapters specified
    - adapters report status: 'Up'
    - adapters are ready to be teamed to create the specified vSwitch

1. Run the `Get-NetIntent` cmdlet to see the cluster intent. Alternatively, you can specify the `IntentName` parameter to see details of only a specific intent.

    ```powershell
    Get-NetIntent -ClusterName $ClusterName
    ```

1. To see provisioning status of the intents, run the `Get-NetIntentStatus` command:

    ```powershell
    Get-NetIntentStatus -ClusterName $ClusterName
    ```

    Note the status parameter that shows Provisioning, Validating, Success, Failure.

1. Status should display success, which should take a few minutes at most. If this has not occurred or if you see an error for the Status parameter, check the event viewer for issues.

    ```powershell
    Get-NetIntentStatus -ClusterName $ClusterName
    ```
 
1. Check that the configuration has been applied to all cluster nodes. For this example, check that the VMSwitch was deployed on each node in the cluster.

    ```powershell
    Get-VMSwitch -CimSession (Get-ClusterNode).Name | Select Name, ComputerName
    ```

    > [!NOTE]
    > vSwitch and Host vNIC names may be different at release time.

## Activity 3: Override an intent

The default configuration may not work for all situations. For example, over time we expect that many will use the default VLANs enacted by Network ATC for configuration simplicity. This may not be feasible in all environments as those VLANs may already be in use on the physical network. For these scenarios, you will need to override the defaults in Network ATC.

In this activity, we will modify the default configuration and verify Network ATC makes the necessary changes.

> [!NOTE]
> Overrides for virtual NICs are not available.

> [!IMPORTANT]
> We recommend you make the following modifications only if you are an expert or are guided by a Microsoft Product team as Microsoft has chosen the defaults intentionally.

### Task 1: Create an override before an intent is specified

This task will help you override one of the defaults prior to adding an intent. This is useful if you want to modify a VLAN used, a QoS property, or want to deploy this setting in the outset.

The standalone and cluster scenarios operate in the same manner; in this case we show only the standalone scenario. If modifying a cluster intent, ensure you use the `-ClusterName` parameter in place of the `-ComputerName` parameter.

> [!IMPORTANT]
> Use `Add-NetIntent` rather than `Set-NetIntent` as demonstrated in this section. These cmdlets have been modified after this section of the article was created.

1. Get a list of possible override cmdlets. We use wildcards to see the options available:

    ```powershell
    Get-Command -Noun NetIntent*Over*
    ```

1. Create an override object:

    ```powershell
    $QosOverride = New-NetIntentQosPolicyOverrides
    $QosOverride
    ```

1. Modify the bandwidth percentage:

    ```powershell
    $QosOverride.BandwidthPercentage_SMB = 25
    $QosOverride
    ```

1. Submit the intent request specifying the override:

    ```powershell
    Set_NetIntent -AdapterName pNIC01, pNIC02 -Compute -Storage -QosPolicyOverrides $QosOverride
    ```

1. Wait for the provisioning status to complete:

    ```powershell
    Get-NetIntentStatus -ComputerName $thisNode
    ```

1. Check that the override has been properly set. In the example, the SMB_Direct traffic class was overridden with a bandwidth percentage of 25%:

    ```powershell
    Get-NetQosTrafficClass
    ```

### Task 2: Override an existing intent

This task help you override one of the existing intents. This is useful if you want to modify a VLAN used or QoS properties after the initial intent was provisioned.

Almost all properties can be overridden after an intent has been provisioned however there are a few that cannot. For example, a VMSwitch team cannot stop using teaming once it has been provisioned. This is an existing behavior in VMSwitch and not a limitation of Network ATC.

> [!IMPORTANT]
> The `Set-NetIntent` cmdlet has replaced the `Set-NetIntentOverride` cmdlet.

1. Get a list of possible override cmdlets. We use wildcards to see the possibilities:

    ```powershell
    Get-Command -Module NetworkATC -Name New-Intent*Overrides
    ```

1. Create an override object. In this example, we create two objects - one for QoS properties and one for a physical adapter property. You will add a value to these objects in order to override the default settings.

    ```powershell
    $QosOverride = New-IntentQosPolicyOverrides
    $AdapterOverride = New-NetIntentAdapterPropertyOverrides
    $QosOverride
    ```

1. Modify the SMB bandwidth percentage:

    ```powershell
    $QosOverride.BandwidthPercentage_SMB = 25
    $QosOverride
    ```

    > [!NOTE]
    >It is expected that no values appear for any property you don’t override.

1. Modify the JumboPacket value:

    ```powershell
    $AdapterOverride.JumboPacket = 9014
    ```

1. Use the `Set-NetIntent` command to update the intent and specify the overrides objects previously created.

Use the appropriate parameter based on the type of override you're specifying. In the example below, we use the `AdapterPropertyOverrides` parameter for the `$AdapterOverride` object that was created with `New-NetIntentAdapterPropertyOverrides` cmdlet whereas the `QosPolicyOverrides` parameter is used with the `$QosOverride` object created from `New-NetIntenQosPolicyOverrides` cmdlet.

```powershell
Set-NetIntent -ClusterName $ClusterName -IntentName "cluster_compute&storage" -AdapterPropertyOverrides $AdapterOverride -QosPolicyOverride $QosOverride
```

1. First, notice that the status for all nodes in the cluster has changed to ProvisioningUpdate and Progress is on 1 of 2.

    The progress property is similar to a configuration watermark in that you have a new submission to the Network ATC service that must be enacted.

1. Wait for the provisioning status to complete:

    ```powershell
    Get-NetIntentStatus -ClusterName $ClusterName
    ```

1. Check that the override has been properly set (on all cluster nodes if using a cluster scenario). In the example provided, the SMB_Direct traffic class was overridden with a bandwidth percentage of 60%.

    ```powershell
    Get-NetQosTrafficClass -Cimsession (Get-ClusterNode).Name | Select PSComputerName, Name, Priority, Bandwidth 
    ```

    ```powershell
    Get-NetAdapterAdvancedProperty -Name pNIC01, pNIC02 -RegistryKeyword *JumboPacket -Cimsession (Get-ClusterNode).Name
    ```

## Activity 4: Backup and restore a configuration

In this activity, we will backup the Network ATC configuration. This can be performed on either a standalone or cluster node, however the locations where you will need to retrieve the configuration from will be different depending on the scenario.

### Task 1: Backup a standalone configuration

1. Open **Registry Editor** and navigate to the following location: `HKLM:\SYSTEM\CurrentControlSet\Services\NetworkAtc`.

1. Under **File**, select **Export**.

1. Save the file to an appropriate location.

### Task 2: Restore a standalone configuration

Doing a restore is a simple process of installing the registry key previously backed-up.

1. Stop the ATC Service: `Stop-Service NetworkATC`.

1. Running the registry key `.\ATCBackup.reg` directly prompts you for import. Select **Yes** in the **Registry Editor** window to continue and import the configuration.

1. Start the NetworkATC Service and verify configuration using the `Get-NetIntentStatus` command.

### Task 3: Backup and restore a clustered configuration

Network ATC configurations are stored in the cluster database. Follow the guidance to backup and restore a clustered Network ATC configuration.

## Activity 5: Remove an existing intent

If you have previously deployed a configuration on your system, you may need to reset the node so that Network ATC can deploy its configuration. To do this, copy and paste the following commands to remove all existing intents and their corresponding vSwitch:

```
# Start Copy and Paste Section
    $intents = Get-NetIntent
    foreach ($intent in $intents)
    {
        Remove-NetIntent -Name $intent.IntentName
        if ((Get-NetIntent -Name $intent.IntentName) -ne $null)
        {
            throw "NetIntent '$($intent.IntentName)' was not removed"
        }
        # remove all switches
        Remove-VMSwitch -Name "*$($intent.IntentName)*" -ErrorAction SilentlyContinue -Force -Verbose
    }
# End Copy and Paste Section
```

### Task 1: Reset a vSwitch configuration

If adapters are part of a vSwitch that was not originally created by Network ATC, either remove the adapters from that vSwitch using the  `Remove-VMSwitchTeamMember` cmdlet or destroy the vSwitch using:

```powershell
Remove-VMSwitch -Name SwitchName -Force -ErrorAction SilentlyContinue
```

### Task 2: Reset a QoS configuration

To reset a QoS configuration, do the following:

```powershell
Get-NetQosTrafficClass | Remove-NetQosTrafficClass -ErrorAction SilentlyContinue
 
Get-NetQosPolicy | Remove-NetQosPolicy -Confirm:$false -ErrorAction SilentlyContinue
```

## Post-deployment tasks

There are several tasks to complete following a Network ATC deployment. Following an ATC deployment you should:

### Add non-APIPA addresses to storage adapters

This can be accomplished using DHCP on the storage VLANs if available or by using the `NetIPAddress` cmdlets.

### Set storage vNIC Jumbo Frame properties

Physical adapter Jumbo Frames can be configured using a physical adapter override. However, if your storage adapters were provisioned as host virtual NICs, you may optionally (in addition to the adapter override) configure the Jumbo Frame settings on the host vNIC using the `NetAdapterAdvancedProperty` cmdlets.

Before you do this, ensure that both the physical switch and the physical adapter have been configured to carry the size packets (or greater) configured on the host vNIC.

> [!NOTE]
> We don't recommend configuring Jumbo Frames on the management vNIC.

### Set SMB bandwidth limits

If live migration uses SMB Direct (RDMA), configure a bandwidth limit to ensure that live migration does not consume all the bandwidth used by Storage Spaces Direct and Failover Clustering.

### Stretch cluster configuration

Stretch cluster requires additional configuration beyond what Network ATC performs. This must be manually added following provisioning success of a specified intent. For stretch clusters, all nodes in the cluster must use the same intent.


## Next Steps
