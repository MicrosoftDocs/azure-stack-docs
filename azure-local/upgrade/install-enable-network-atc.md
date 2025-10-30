---
title:  Configure Network ATC on Azure Local
description: Learn how to configure Network ATC on Azure Local.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: alkohli
ms.date: 06/05/2025
ms.service: azure-local
---

# Configure Network ATC on Azure Local

This article describes how to configure Network ATC on an existing Azure Local cluster that doesn't already have it configured.

> [!IMPORTANT]
> In Azure Local upgrade scenarios where Network ATC isn't already configured, we recommend upgrading the operating system first, then configuring Network ATC, and then proceeding with the solution upgrade.
> If Network ATC is already configured on your cluster, skip this article.
> For more information on upgrades, see [About Azure Local upgrades](./about-upgrades-23h2.md).

## About Network ATC

Network ATC stores information in the cluster database, which is then replicated to other machines in the cluster. From the initial machine, other machines in the cluster see the change in the cluster database and apply the new intent. Here, we set up the system to receive a new intent. Additionally, we control the rollout of the new intent by stopping or disabling the Network ATC service on machines that have virtual machines (VM) on them. For more information, see [Network ATC overview](../concepts/network-atc-overview.md).

## Benefits

Network ATC provides the following benefits for Azure Local:

- Reduces host networking deployment time, complexity, and errors.
- Deploys the latest Microsoft validated and supported best practices.
- Ensures configuration consistency across the instance.
- Eliminates configuration drift.

## Key considerations

Before you configure Network ATC on your existing Azure Local, ensure the following conditions are met:

- The host doesn't have any running VM on it.
- The cluster is actively running workloads. If there are no running workloads on your Azure Local cluster, you can optionally remove all virtual switches and QoS policies, then add your intents using the standard procedures described in [Deploy host networking with Network ATC](/windows-server/networking/network-atc/network-atc).
- All checkpoints associated with your VMs are removed. Failure to do so will result in live migration failure between hosts.

## Step 1: Install Network ATC

In this step, you install Network ATC and the required FS-SMBBW feature on every machine in the cluster using the following command. No reboot is required.

```powershell
Install-WindowsFeature -Name NetworkATC
Install-WindowsFeature -Name FS-SMBBW
```

## Step 2: Pause one machine in the cluster

When you pause one machine in the cluster, all workloads are moved to other machines, making your machine available for changes. The paused machine is then migrated to Network ATC.

To pause your machine, use the following command:

```powershell
Suspend-ClusterNode -Drain -Wait
```

## Step 3: Stop the Network ATC service

To prevent Network ATC from applying the intent while VMs are running, stop and disable the Network ATC service on all machines that aren't paused.

To stop and disable the Network ATC service, use the following commands:

```powershell
Stop-Service -Name NetworkATC
Set-Service -Name NetworkATC -StartupType Disabled
```

## Step 4: Remove previous configurations

Remove any previous configurations from the paused machine that could interfere with Network ATC’s ability to apply the new intent. The previous configurations include:

- Data Center Bridging (NetQos) policies for RDMA traffic
- Load Balancing Failover (LBFO)

Although Network ATC attempts to adopt existing configurations with matching names, including NetQos and other settings, it’s easier to remove the current configuration and allow Network ATC to redeploy the necessary configuration items and more.

> [!IMPORTANT]
> Do not delete the Switch Embedded Teaming (SET) virtual switch and allow Network ATC to recreate it. Deleting the virtual switch can result in unexpected connectivity loss and will disrupt existing Software Defined Networking (SDN) deployments.
> Instead, we recommend renaming the SET virtual switch and virtual NICs to the expected Network ATC convention, which is performed in a later step.

To remove your existing NetQos configurations, use the following commands:

```PowerShell
Get-NetQosTrafficClass | Remove-NetQosTrafficClass
Get-NetQosPolicy | Remove-NetQosPolicy -Confirm:$false
Get-NetQosFlowControl | Disable-NetQosFlowControl
```

LBFO isn't supported in Azure Local. However, if you accidentally deployed an LBFO team, you can remove it by using the following command:

```powershell
Get-NetLBFOTeam | Remove-NetLBFOTeam -Confirm:$false
```

If your machines were configured via Virtual Machine Manager (VMM), you may also need to remove any associated configuration objects.

## Step 5: Convert VLAN settings

Some Azure Local deployments require a VLAN to be configured on the management or storage virtual network adapters. Network ATC requires the VLAN ID to be set using the `VMNetworkAdapterIsolation` method. However, Hyper-V also allows VLANs to be set using the `VMNetworkAdapterVlan` method.

1. Use the following commands to check if your virtual adapter has a VLAN and reconfigure it if necessary.

    ```powershell
    # Use the command below to list the virtual adapters present on the system
    Get-VMNetworkAdapter -ManagementOS

    # Add the name of the VMNetworkAdapter below to check for a VLAN configuration
    Get-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "vNICName"
    Get-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vNICName"
    ```

    Output from `Get-VMNetworkAdapterVlan`:
    - If `Mode` is `Access` and `VlanList` has a numeric value, the adapter is tagged with a VLAN and needs to be updated.
    - If `Mode` is `Untagged`, no VLAN is configured using this method.

    Output from `Get-VMNetworkAdapterIsolation`:
    - If `IsolationMode` is `Vlan` and `DefaultIsolationID` has a numeric value other than `0`, the adapter is tagged with a VLAN and doesn't need to be updated.
    - If `IsolationMethod` is `None`, no VLAN is configured using this method.

1. To convert a VLAN from the `VMNetworkAdapterVlan` method to the `VMNetworkAdapterIsolation` method, use the following commands:

    > [!IMPORTANT]
    > Running the following commands disconnects the cluster node from the network until the VLAN is reconfigured. It's recommended to run these commands from a BMC console.

    ```powershell
    Set-VMNetworkAdapterVlan -ManagementOS -VMNetworkAdapterName "vNICName" -Untagged

    # Use the VLAN ID from above for the DefaultIsolationID parameter in the below command
    Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vNICName" -IsolationMode Vlan -AllowUntaggedTraffic $true -DefaultIsolationID 100
    ```

1. Complete these steps for all management and storage virtual network adapters present on the cluster node. If neither output had a VLAN configured, move to the next step.

## Step 6: Plan and deploy the intents

There are various intents that you can add. Identify the intents you'd like by using the examples in the [Example intents](#example-intents) section.

Once you identify the example that matches your environment, use the commands provided in that example to perform the required steps on the paused node only.

## Step 7: Verify the deployment on one machine

The `Get-NetIntentStatus` command shows the deployment status of the requested intents. The result returns one object per intent for each machine in the cluster.

To verify your machine's successful deployment of the intents submitted in [step 6](#step-6-plan-and-deploy-the-intents), run the following command:

```powershell
Get-NetIntentStatus -Name <IntentName>
```

Here's an example of the output:

```console
PS C:\Users\administrator.CONTOSO> Get-NetlntentStatus

IntentName                  : mgmt_compute_storage
Host                        : node1
IsComputelntentSet          : True
IsManagementlntentSet       : True
IsStoragelntentSet          : True
IsStretchlntentSet          : False
LastUpdated                 : 05/13/2025 11:11:15
LastSuccess                 : 05/13/2025 11:11:15
RetryCount                  : 0
LastConfigApplied           : 1
Error                       :
Progress                    : 1 of 1
ConfigurationStatus         : Success
ProvisioningStatus          : Completed
```

Ensure that each intent added has an entry for the host you're working on. Also, make sure `ConfigurationStatus` shows **Success**.

If `ConfigurationStatus` shows **Failed**, check if the error message indicates the reason for the failure. You can also review the Microsoft-Windows-Networking-NetworkATC/Admin event logs for more details on the reason for the failure. For some examples of failure resolutions, see [Common Error Messages](../deploy/network-atc.md#common-error-messages).

## Step 8: Resume the paused node

With the Network ATC configuration completed on the first node, resume the node and allow it to come back into the cluster.

1. To reenter or put your cluster node back in service, run the following command:

    ```powershell
    Resume-ClusterNode
    ```

1. Run `Get-StorageJob` to check for any running storage jobs. Allow them to complete before moving to the next step.

## Step 9: Rename the virtual components on other machines

In this step, you move from the machine deployed with Network ATC to the next machine and migrate the VMs from this second machine. You must verify that the second machine has the same VMSwitch name as the machine deployed with Network ATC.

> [!IMPORTANT]
> After the virtual switch is renamed, you must disconnect and reconnect each VM so that it can appropriately cache the new name of the virtual switch. Because this step affects VM connectivity, it's considered a disruptive action that requires planning to complete. If you skip this step, live migrations will fail with an error indicating the virtual switch doesn't exist on the destination.

1. Renaming the virtual switch is a nondisruptive change and can be done on all the machines simultaneously. Run the following command:

    ```powershell
    #Run on the machine where you configured Network ATC
    Get-VMSwitch | ft Name

    #Run on the next machine to rename the virtual switch
    Rename-VMSwitch -Name 'ExistingName' -NewName 'NewATCName'
    ```

1. After your switch is renamed, disconnect and reconnect your vNICs for the VMSwitch name change to go through. The following command can be used to perform this action for all VMs:

    > [!IMPORTANT]
    > The following commands assume the host has only one virtual switch and all virtual machines are connected to that virtual switch. If your environment differs, you need to modify the commands, or manually disconnect and reconnect your VMs.

    ```powershell
    $VMSW = Get-VMSwitch
    $VMs = Get-VM
    $VMs | %{Get-VMNetworkAdapter -VMName $_.name | Disconnect-VMNetworkAdapter ; Get-VMNetworkAdapter -VMName $_.name | Connect-VMNetworkAdapter -SwitchName $VMSW.name}
    ```

You don't change the Network ATC `VMSwitch` for two reasons:

- Network ATC ensures that all machines in the cluster have the same name to support live migration and symmetry.
- Network ATC implements and controls the names of configuration objects. Otherwise, you'd need to ensure this configuration artifact is perfectly deployed.

## Step 10: Apply the required changes to the remaining cluster nodes

With the virtual switch renamed and VMs reconnected, virtual machines can be live migrated between cluster nodes. Follow these steps, repeating for each additional node in the cluster until all nodes are completed.

> [!NOTE]
> Network ATC should manage the live migration networks. If live migrations fail due to an error `Cluster network not found`, you may need to manually update the live migration networks. You can use the following script to set the storage networks as available live migration networks and exclude the management network. Alternatively, these networks can be updated via Failover Cluster Manager.

```powershell
# Configure the Virtual Machine ClusterResourceType not to use the management network for live migration
$mgmtID = (Get-ClusterNetwork | where "Name" -match "Management").ID
Get-ClusterResourceType "Virtual Machine" | Set-ClusterParameter -Name "MigrationExcludeNetworks" -Value $mgmtID
# Configure the Virtual Machine ClusterResourceType to use the storage networks for live migration
$storageID = (Get-ClusterNetwork | where "Name" -match "Storage").ID
$storageIDs = $storageID -join ";"
Get-ClusterResourceType "Virtual Machine" | Set-ClusterParameter -Name "MigrationNetworkOrder" -Value $storageIDs
```

1. Pause and drain the cluster node using the command `Suspend-ClusterNode -Drain -Wait`.

1. Remove existing NetQos configurations using the commands in [Step 4](#step-4-remove-previous-configurations).

1. If necessary, update the VLAN ID of the virtual adapters using the commands in [Step 5](#step-5-convert-vlan-settings).

1. Rename the virtual network adapters using the `Rename-VMNetworkAdapter` and `Rename-NetAdapter` commands used in [Step 6](#step-6-plan-and-deploy-the-intents). You don't need to run any of the `Rename-VMSwitch` or `Add-NetIntent` commands.

1. Enable and start the Network ATC service on the paused node using the following commands:

    ```powershell
    Set-Service -Name NetworkATC -StartupType Automatic
    Start-Service -Name NetworkATC
    ```

1. Verify your machine's successful deployment of the intents by running the `Get-NetIntentStatus` command used in [Step 7](#step-7-verify-the-deployment-on-one-machine). Make sure the `ConfigurationStatus` shows **Success** for all intents.

1. Resume the paused node using the `Resume-ClusterNode` command.

1. Ensure all storage jobs complete by using the `Get-StorageJob` command.

## Example intents

Network ATC modifies how you deploy host networking, not what you deploy. You can deploy multiple scenarios if each scenario is supported by Microsoft. Here are some examples of common host networking patterns and the corresponding PowerShell commands for Azure Local.

These examples aren't the only combinations available, but they should give you an idea of the possibilities.

> [!IMPORTANT]
> The following commands deploy the intents with their default best practice configurations. Before deploying your intents, review your adapter advanced property settings using the `Get-NetAdapterAdvancedProperty` command. If you have unique advanced adapter settings, refer to Network ATC overrides to override Network ATC defaults and keep your existing settings consistent with Network ATC. It's important that these overrides get configured when the intent is created to avoid unexpected changes.

Reference articles:

- For information on the default values, see [Deploy host networking with Network ATC](/windows-server/networking/network-atc/network-atc).
- For information on configuring overrides, see [Manage Network ATC](/windows-server/networking/network-atc/manage-network-atc).
- For information on Network ATC commands, see [NetworkATC](/powershell/module/networkatc).

For simplicity, the examples demonstrate only two physical adapters per SET team, however it's possible to add more. For more information, see [Network reference patterns overview for Azure Local](../plan/network-patterns-overview.md).

### Example intent: Group management and compute in one intent with a separate intent for storage

In this example, there are two intents that are managed across machines.

- **Management and compute**: This intent uses a dedicated pair of network adapter ports.
- **Storage**: This intent uses a dedicated pair of network adapter ports.

    :::image type="content" source="media/install-enable-network-atc/group-management-and-compute.png" alt-text="Screenshot of an Azure Local instance with a grouped management and compute intent." lightbox="media/install-enable-network-atc/group-management-and-compute.png":::

Here's an example to implement this host network pattern:

> [!IMPORTANT]
> The following commands assume your environment has only one virtual switch and one virtual network adapter present. The commands return an error if multiple virtual switches or virtual network adapters are present. If your environment has more than one virtual switch or one virtual network adapter present, replace the variable in the commands with the full name of the virtual switch or virtual network adapter you want to modify in double quotes. Don't change any other part of the commands.

```powershell
# These commands rename the virtual components to the Network ATC naming convention
Rename-VMSwitch -Name (Get-VMSwitch).Name -NewName "ConvergedSwitch(mgmt_compute)"
Rename-VMNetworkAdapter -ManagementOS -Name (Get-VMNetworkAdapter -ManagementOS).Name -NewName "vManagement(mgmt_compute)"
Rename-NetAdapter -Name "vEthernet (vManagement(mgmt_compute))" -NewName "vManagement(mgmt_compute)"

# This command adds the management and compute intent.  Update the -AdapterName parameter with the appropriate names of the network adapters
# Note that if you had to configure a VLAN in Step 5, you will need to add that into the -ManagementVlan parameter below.
# If you do not need to configure a management VLAN, remove the -ManagementVlan parameter before running the command
Add-NetIntent -Name mgmt_compute -Management -Compute -AdapterName "pNIC1","pNIC2" -ManagementVlan 100

# These commands add the storage intent.  Automatic storage IP addressing is disabled to allow your existing storage IP addresses to continue to be used.
# Update the -AdapterName parameter with the appropriate names of the network adapters.
# Update the -StorageVlans parameter below to the VLAN IDs used by your network adapters.  If you want to use the default Network ATC VLAN IDs (711, 712, etc.), remove the -StorageVlans parameter.
$override = New-NetIntentStorageOverrides
$override.EnableAutomaticIPGeneration = 0
Add-NetIntent -Name storage -Storage -StorageOverrides $override -AdapterName "pNIC3","pNIC4" -StorageVlans 200,201
```

### Example intent: Group all traffic on a single intent

In this example, there's a single intent managed across machines.

- **Management, Compute, and Storage**: This intent uses a dedicated pair of network adapter ports.

    :::image type="content" source="media/install-enable-network-atc/group-all-traffic.png" alt-text="Screenshot of an Azure Local instance with all traffic on a single intent." lightbox="media/install-enable-network-atc/group-all-traffic.png":::

Here's an example to implement this host network pattern:

> [!IMPORTANT]
> - The following commands assume your environment has only one virtual switch present. The commands return error if multiple virtual switches are present. If your environment has more than one virtual switch, replace the variable in the commands with the full name of the virtual switch you want to modify in double quotes. Don't change any other part of the commands.
> - Use extra caution when implementing these commands.

```powershell
# This command renames the virtual switch to the Network ATC naming convention
Rename-VMSwitch -Name (Get-VMSwitch).Name -NewName "ConvergedSwitch(mgmt_compute_storage)"

# These commands rename the virtual network adapters.  Note that each adapter must be renamed to a very specific naming convention.
# First, collect the output from Get-VMNetworkAdapter -ManagementOS to get a list of the current virtual adapters.
# The management virtual network adapter can be renamed using the two commands below.  
# You must update the -Name parameter in the Rename-VMNetworkAdapter command with the name of the management virtual adapter from the output above.
Rename-VMNetworkAdapter -ManagementOS -Name "mgmtVNICname" -NewName "vManagement(mgmt_compute_storage)"
Rename-NetAdapter -Name "vEthernet (vManagement(mgmt_compute_storage))" -NewName "vManagement(mgmt_compute_storage)"

# The storage virtual network adapters can be renamed using the two commands below.
# You must update the -Name parameter in the Rename-VMNetworkAdapter command with the name of the storage virtual adapter from the output above.
# You must also update each parameter with the name of the physical adapter after the # sign.  In the example below, "pNIC1" is the name of the physical adapter associated with the first storage virtual adapter.
# These two commands need to be executed for each storage virtual adapter present on the cluster node.  For example, if you have two physical adapters for storage, you would need to run 4 total commands.
Rename-VMNetworkAdapter -ManagementOS -Name "storagevNIC1" -NewName "vSMB(mgmt_compute_storage#pNIC1)"
Rename-NetAdapter -Name "vEthernet (vSMB(mgmt_compute_storage#pNIC1))" -NewName "vSMB(mgmt_compute_storage#pNIC1)"
Rename-VMNetworkAdapter -ManagementOS -Name "storagevNIC2" -NewName "vSMB(mgmt_compute_storage#pNIC2)"
Rename-NetAdapter -Name "vEthernet (vSMB(mgmt_compute_storage#pNIC2))" -NewName "vSMB(mgmt_compute_storage#pNIC2)"    
  
# This command adds the management, compute, and storage intent.  Update the -AdapterName parameter with the appropriate names of the network adapters
# Note that if you had to configure a VLAN in Step 5, you will need to add that into the -ManagementVlan parameter below.
# If you do not need to configure a management VLAN, remove the -ManagementVlan parameter before running the command    
# Automatic storage IP addressing is disabled to allow your existing storage IP addresses to continue to be used.
# Update the -StorageVlans parameter below to the VLAN IDs used by your network adapters.  If you want to use the default Network ATC VLAN IDs (711, 712, etc.), remove the -StorageVlans parameter.
$override = New-NetIntentStorageOverrides
$override.EnableAutomaticIPGeneration = 0
Add-NetIntent -Name mgmt_compute_storage -Management -Compute -Storage -StorageOverrides $override -AdapterName "pNIC1","pNIC2" -ManagementVlan 100 -StorageVlans 200,201
```

### Example intent: Group compute and storage traffic on one intent with a separate management intent

In this example, there are two intents that are managed across machines.

- **Management**: This intent uses a dedicated pair of network adapter ports.
- **Compute and Storage**: This intent uses a dedicated pair of network adapter ports.

    :::image type="content" source="media/install-enable-network-atc/group-compute-and-storage.png" alt-text="Screenshot of an Azure Local instance with a grouped compute and storage intent." lightbox="media/install-enable-network-atc/group-compute-and-storage.png":::

Here's an example to implement this host network pattern:

```powershell
# These commands rename the virtual switches to the Network ATC naming convention
# First rename the management virtual switch, then the compute/storage virtual switch
Rename-VMSwitch -Name "management_vSwitch_name" -NewName "ConvergedSwitch(mgmt)"
Rename-VMSwitch -Name "compute_storage_vSwitch_name" -NewName "ConvergedSwitch(compute_storage)"

# These commands rename the virtual network adapters.  Note that each adapter must be renamed to a very specific naming convention.
# First, collect the output from Get-VMNetworkAdapter -ManagementOS to get a list of the current virtual adapters.
# The management virtual network adapter can be renamed using the two commands below.  
# You must update the -Name parameter in the Rename-VMNetworkAdapter command with the name of the management virtual adapter from the output above.
Rename-VMNetworkAdapter -ManagementOS -Name "mgmtVNICname" -NewName "vManagement(mgmt_compute_storage)"
Rename-NetAdapter -Name "vEthernet (vManagement(mgmt_compute_storage))" -NewName "vManagement(mgmt_compute_storage)"

# The storage virtual network adapters can be renamed using the two commands below.
# You must update the -Name parameter in the Rename-VMNetworkAdapter command with the name of the storage virtual adapter from the output above.
# You must also update each parameter with the name of the physical adapter after the # sign.  In the example below, "pNIC1" is the name of the physical adapter associated with the first storage virtual adapter.
# These two commands need to be executed for each storage virtual adapter present on the cluster node.  For example, if you have two physical adapters for storage, you would need to run 4 total commands.
Rename-VMNetworkAdapter -ManagementOS -Name "storagevNIC1" -NewName "vSMB(mgmt_compute_storage#pNIC1)"
Rename-NetAdapter -Name "vEthernet (vSMB(mgmt_compute_storage#pNIC1))" -NewName "vSMB(mgmt_compute_storage#pNIC1)"
Rename-VMNetworkAdapter -ManagementOS -Name "storagevNIC2" -NewName "vSMB(mgmt_compute_storage#pNIC2)"
Rename-NetAdapter -Name "vEthernet (vSMB(mgmt_compute_storage#pNIC2))" -NewName "vSMB(mgmt_compute_storage#pNIC2)"    

# This command adds the management intent.  Update the -AdapterName parameter with the appropriate names of the network adapters
# Note that if you had to configure a VLAN in Step 5, you will need to add that into the -ManagementVlan parameter below.
# If you do not need to configure a management VLAN, remove the -ManagementVlan parameter before running the command    
Add-NetIntent -Name mgmt -Management -AdapterName "pNIC1","pNIC2" -ManagementVlan 100

# This command adds the compute and storage intent.  Update the -AdapterName parameter with the appropriate names of the network adapters
# Automatic storage IP addressing is disabled to allow your existing storage IP addresses to continue to be used.
# Update the -StorageVlans parameter below to the VLAN IDs used by your network adapters.  If you want to use the default Network ATC VLAN IDs (711, 712, etc.), remove the -StorageVlans parameter.
$override = New-NetIntentStorageOverrides
$override.EnableAutomaticIPGeneration = 0
Add-NetIntent -Name compute_storage -Compute -Storage -StorageOverrides $override -AdapterName "pNIC1","pNIC2" -StorageVlans 200,201
```

### Example intent: Fully disaggregated host networking

In this example, there are three intents that are managed across machines.

- **Management**: This intent uses a dedicated pair of network adapter ports.
- **Compute**: This intent uses a dedicated pair of network adapter ports.
- **Storage**: This intent uses a dedicated pair of network adapter ports.

    :::image type="content" source="media/install-enable-network-atc/fully-disaggregated.png" alt-text="Screenshot of an Azure Local instance with a fully disaggregated intent." lightbox="media/install-enable-network-atc/fully-disaggregated.png":::

Here's an example to implement this host network pattern:

```powershell
# These commands rename the virtual switches to the Network ATC naming convention
# First rename the management virtual switch, then the compute/storage virtual switch
Rename-VMSwitch -Name "management_vSwitch_name" -NewName "ConvergedSwitch(mgmt)"
Rename-VMSwitch -Name "compute_vSwitch_name" -NewName "ConvergedSwitch(compute)"

# These commands rename the virtual network adapters.  Note that each adapter must be renamed to a very specific naming convention.
# First, collect the output from Get-VMNetworkAdapter -ManagementOS to get a list of the current virtual adapters.
# The management virtual network adapter can be renamed using the two commands below.  
# You must update the -Name parameter in the Rename-VMNetworkAdapter command with the name of the management virtual adapter from the output above.
Rename-VMNetworkAdapter -ManagementOS -Name "mgmtVNICname" -NewName "vManagement(mgmt)"
Rename-NetAdapter -Name "vEthernet (vManagement(mgmt))" -NewName "vManagement(mgmt)"

# This command adds the management intent.  Update the -AdapterName parameter with the appropriate names of the network adapters
# Note that if you had to configure a VLAN in Step 5, you will need to add that into the -ManagementVlan parameter below.
# If you do not need to configure a management VLAN, remove the -ManagementVlan parameter before running the command    
Add-NetIntent -Name mgmt -Management -AdapterName "pNIC1","pNIC2" -ManagementVlan 100

# These commands add the storage intent.  Automatic storage IP addressing is disabled to allow your existing storage IP addresses to continue to be used.
# Update the -AdapterName parameter with the appropriate names of the network adapters.
# Update the -StorageVlans parameter below to the VLAN IDs used by your network adapters.  If you want to use the default Network ATC VLAN IDs (711, 712, etc.), remove the -StorageVlans parameter.
$override = New-NetIntentStorageOverrides
$override.EnableAutomaticIPGeneration = 0
Add-NetIntent -Name storage -Storage -StorageOverrides $override -AdapterName "pNIC3","pNIC4" -StorageVlans 200,201

# This command adds the compute intent.  Update the -AdapterName parameter with the appropriate names of the network adapters  
Add-NetIntent -Name compute -Compute -AdapterName "pNIC5","pNIC6"
```

## Next step

- Learn how to [Assess solution upgrade readiness for Azure Local](./validate-solution-upgrade-readiness.md).
