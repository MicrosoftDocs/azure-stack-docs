---
title:  Azure Local Remote Support Arc extension and remote support overview
description: This article describes the remote support arc extension and remote support in Azure Local.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: shisab
ms.lastreviewed: 07/31/2025
ms.date: 07/31/2025
---

# Azure Local Remote Support Arc extension overview

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article gives an overview of the Remote Support Arc extension and remote support in Azure Local. Learn about the benefits, scenarios, and commands that Microsoft support uses during a remote support session.

## About the Remote Support Arc extension

The Remote Support Arc extension, listed as **AzureEdgeRemoteSupport** in the Azure portal, simplifies setup and improves support efficiency. It's preinstalled on all system nodes and lets you set up scheduled tasks for [Just Enough Administration](/powershell/scripting/security/remoting/jea/overview?view=powershell-7.5&preserve-view=true). This extension sets the foundation for secure, streamlined support interactions.

Remote support is the process where a Microsoft support professional connects to your device to help fix issues. With the extension, support personnel can securely access your system, do limited troubleshooting or repair tasks, and fix your case faster.

For more information about remote support and how to turn it on, see [Get remote support](./get-remote-support.md).

## Benefits

Remote support and using the extension lets you:

- **Resolve issues faster**: Don't wait for scheduled meetings. Microsoft support fixes your problems right away.
- **Stay informed**: View detailed records of all actions anytime.
- **Manage access**: Grant just-in-time authenticated access for each incident, and specify the level and duration of access.
- **Revoke access anytime**: Withdraw consent anytime to end the remote session. Access automatically ends when the consent period ends.

## Scenarios for remote support

The scenarios in this list highlight the critical role of remote support in efficiently managing and troubleshooting complex systems.

|Scenario | Description|
|---------|------------|
|Log collection initiation | Use remote support to initiate log collection for diagnostic purposes. This includes the initiation of the command `Send-Diagnosticdata`. |
|Azure Local information retrieval | Obtain details related to Azure Local, including node connections, Arc integration, billing, licensing, registration, subscription information, and test connections to Azure Local. |
|Hyper-V troubleshooting | Get comprehensive information about Hyper-V issues, such as virtual hard disks, Hyper-V hosts, virtual switches, virtual hard disk sets, BIOS settings, VMConnect, firmware details, GPU configuration, virtual network adapters, CPU settings, security configurations, and virtual machine settings.<br></br> Additionally, address Access Control Lists (ACL) settings for network adapters.|
|Observability pipeline testing | Check the functionality of the observability pipeline to ensure the ability to send data to Microsoft.|
|Cluster information retrieval | Get relevant details about clusters, cluster groups, cluster nodes, cluster resources, shared volumes, and Cluster-Aware Updating (CAU) specifics. |
| Network adapter details | Access basic properties of network adapters, configure Remote Direct Memory Access (RDMA) settings, examine path configurations, review network connection specifics, gather virtual port information, capture packet details, manage firewall settings, and explore NAT configuration details. <br></br> Additionally, get information about VM switches and IPsec settings. |
|Storage, clusters, and networking insights | Gather information related to storage enclosures, storage jobs, storage nodes, storage subsystems, virtual disks, volumes, Storage Spaces Direct (S2D) Clusters, fault domain, cluster group sets, available disks, cluster network details, server message block client information, and disk images. |

## List of Microsoft support operations

For remote support, you can grant Microsoft support one of the following access levels for remote support:

- [**Diagnostics**](#access-level-diagnostics): View diagnostic info and logs
- [**Diagnostics and repair**](#access-level-diagnostics-and-repair): View diagnostic info and logs plus perform software repairs.

### Access level: Diagnostics

The **Diagnostics** access level includes commands that Microsoft support can run during a remote support session. The commands are listed alphabetically and grouped by module or functionality.

#### Default

<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Clear-Host            
    Exit-PSSession
    Format-List
    Format-Table
    Get-Command
    Get-Date
    Get-FormatData
    Get-Help
    Get-Process
    Get-Service
    Measure-Object        
    Select-Object
    Sort-Object
    Out-Default
    Where-Object
```

</details>

#### Azure Local

<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Get-AzureStackHCI
    Get-AzureStackHCIArcIntegration
    Get-AzureStackHCIBillingRecord
    Get-AzureStackHCIRegistrationCertificate
    Get-AzureStackHCISubscriptionStatus
    Send-DiagnosticData
    Test-AzStackHCIConnection
```

</details>

#### Hyper-V

<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Get-VHD
    Get-VHDSet
    Get-VHDSnapshot
    Get-VM
    Get-VMAssignableDevice
    Get-VMBios
    Get-VMCheckpoint
    Get-VMComPort
    Get-VMConnectAccess
    Get-VMDvdDrive
    Get-VMFibreChannelHba
    Get-VMFirmware
    Get-VMFloppyDiskDrive
    Get-VMGpuPartitionAdapter
    Get-VMGroup
    Get-VMHardDiskDrive
    Get-VMHost
    Get-VMHostAssignableDevice
    Get-VMHostCluster
    Get-VMHostNumaNode
    Get-VMHostNumaNodeStatus
    Get-VMHostPartitionableGpu
    Get-VMHostSupportedVersion
    Get-VMIdeController
    Get-VMIntegrationService
    Get-VMKeyProtector
    Get-VMKeyStorageDrive
    Get-VMMemory
    Get-VMMigrationNetwork
    Get-VMNetworkAdapter
    Get-VMNetworkAdapterAcl
    Get-VMNetworkAdapterExtendedAcl
    Get-VMNetworkAdapterFailoverConfiguration
    Get-VMNetworkAdapterIsolation
    Get-VMNetworkAdapterRdma
    Get-VMNetworkAdapterRoutingDomainMapping
    Get-VMNetworkAdapterTeamMapping
    Get-VMNetworkAdapterVlan
    Get-VMPartitionableGpu
    Get-VMPmemController
    Get-VMProcessor
    Get-VMRemoteFx3dVideoAdapter
    Get-VMRemoteFXPhysicalVideoAdapter
    Get-VMReplication
    Get-VMReplicationAuthorizationEntry
    Get-VMReplicationServer
    Get-VMResourcePool
    Get-VMSan
    Get-VMScsiController
    Get-VMSecurity
    Get-VMSnapshot
    Get-VMStoragePath
    Get-VMStorageSettings
    Get-VMSwitch
    Get-VMSwitchExtension
    Get-VMSwitchExtensionPortData
    Get-VMSwitchExtensionPortFeature
    Get-VMSwitchExtensionSwitchData
    Get-VMSwitchExtensionSwitchFeature
    Get-VMSwitchTeam
    Get-VMSystemSwitchExtension
    Get-VMSystemSwitchExtensionPortFeature
    Get-VMSystemSwitchExtensionSwitchFeature
    Get-VMVideo
```

</details>

#### Failover cluster

<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Export-CauReport
    Get-CauClusterRole
    Get-CauDeviceInfoForFeatureUpdates
    Get-CauPlugin
    Get-CauRun
    Get-Cluster
    Get-ClusterGroup
    Get-ClusterNode
    Get-ClusterOwnerNode
    Get-ClusterResource
    Get-ClusterSharedVolume
    Test-CauSetup
```

</details>

#### Net Adapter

<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Get-ClusteredScheduledTask
    Get-DscConfiguration
    Get-DscConfigurationStatus
    Get-DscLocalConfigurationManager
    Get-DscResource
    Get-JobTrigger
    Get-LogProperties
    Get-NCSIPolicyConfiguration
    Get-Net6to4Configuration
    Get-NetAdapter
    Get-NetAdapterAdvancedProperty
    Get-NetAdapterBinding
    Get-NetAdapterChecksumOffload
    Get-NetAdapterDataPathConfiguration
    Get-NetAdapterEncapsulatedPacketTaskOffload
    Get-NetAdapterHardwareInfo
    Get-NetAdapterIPsecOffload
    Get-NetAdapterLso
    Get-NetAdapterPacketDirect
    Get-NetAdapterPowerManagement
    Get-NetAdapterQos
    Get-NetAdapterRdma
    Get-NetAdapterRsc
    Get-NetAdapterRss
    Get-NetAdapterSriov
    Get-NetAdapterSriovVf
    Get-NetAdapterStatistics
    Get-NetAdapterUso
    Get-NetAdapterVmq
    Get-NetAdapterVmqQueue
    Get-NetAdapterVPort
    Get-NetCompartment
    Get-NetConnectionProfile
    Get-NetDnsTransitionConfiguration
    Get-NetDnsTransitionMonitoring
    Get-NetEventNetworkAdapter
    Get-NetEventPacketCaptureProvider
    Get-NetEventProvider
    Get-NetEventSession
    Get-NetEventVFPProvider
    Get-NetEventVmNetworkAdapter
    Get-NetEventVmSwitch
    Get-NetEventVmSwitchProvider
    Get-NetEventWFPCaptureProvider
    Get-NetFirewallAddressFilter
    Get-NetFirewallApplicationFilter
    Get-NetFirewallDynamicKeywordAddress
    Get-NetFirewallInterfaceFilter
    Get-NetFirewallInterfaceTypeFilter
    Get-NetFirewallPortFilter
    Get-NetFirewallProfile
    Get-NetFirewallRule
    Get-NetFirewallSecurityFilter
    Get-NetFirewallServiceFilter
    Get-NetFirewallSetting
    Get-NetIPAddress
    Get-NetIPHttpsConfiguration
    Get-NetIPHttpsState
    Get-NetIPInterface
    Get-NetIPsecDospSetting
    Get-NetIPsecMainModeCryptoSet
    Get-NetIPsecMainModeRule
    Get-NetIPsecMainModeSA
    Get-NetIPsecPhase1AuthSet
    Get-NetIPsecPhase2AuthSet
    Get-NetIPsecQuickModeCryptoSet
    Get-NetIPsecQuickModeSA
    Get-NetIPsecRule
    Get-NetIPv4Protocol
    Get-NetIPv6Protocol
    Get-NetIsatapConfiguration
    Get-NetLbfoTeam
    Get-NetLbfoTeamMember
    Get-NetLbfoTeamNic
    Get-NetNat
    Get-NetNatExternalAddress
    Get-NetNatGlobal
    Get-NetNatStaticMapping
    Get-NetNatTransitionConfiguration
    Get-NetNatTransitionMonitoring
    Get-NetNeighbor
    Get-NetOffloadGlobalSetting
    Get-NetPrefixPolicy
    Get-NetQosPolicy
    Get-NetRoute
    Get-NetSwitchTeam
    Get-NetSwitchTeamMember
    Get-NetTCPConnection
    Get-NetTCPSetting
    Get-NetTeredoConfiguration
    Get-NetTeredoState
    Get-NetTransportFilter
    Get-NetUDPEndpoint
    Get-NetUDPSetting
    Get-NetView
    Get-ScheduledJob
    Get-ScheduledJobOption
    Get-ScheduledTask
    Get-ScheduledTaskInfo
    Get-SecureBootPolicy
    Get-SecureBootUEFI
    Test-DscConfiguration
```

</details>

#### Storage

<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Get-ClusterAccess
    Get-ClusterAffinityRule
    Get-ClusterAvailableDisk
    Get-ClusterFaultDomain
    Get-ClusterFaultDomainXML
    Get-ClusterGroupSet
    Get-ClusterGroupSetDependency
    Get-ClusterHCSVM
    Get-ClusterNetwork
    Get-ClusterNetworkInterface
    Get-ClusterNodeSupportedVersion
    Get-ClusterParameter
    Get-ClusterQuorum
    Get-ClusterResourceDependency
    Get-ClusterResourceDependencyReport
    Get-ClusterResourceType
    Get-ClusterS2D
    Get-ClusterSharedVolumeState
    Get-ClusterStorageNode
    Get-ClusterStorageSpacesDirect
    Get-Disk
    Get-DiskImage
    Get-FileShare
    Get-InitiatorId
    Get-InitiatorPort
    Get-MaskingSet
    Get-OffloadDataTransferSetting
    Get-Partition
    Get-PartitionSupportedSize
    Get-ResiliencySetting
    Get-SmbClientConfiguration
    Get-SmbClientNetworkInterface
    Get-SmbConnection
    Get-SmbGlobalMapping
    Get-SmbMapping
    Get-SmbMultichannelConnection
    Get-SmbMultichannelConstraint
    Get-SmbOpenFile
    Get-SmbServerCertificateMapping
    Get-SmbServerCertProps
    Get-SmbServerConfiguration
    Get-SmbServerNetworkInterface
    Get-SmbSession
    Get-SmbShare
    Get-SmbShareAccess
    Get-SmbWitnessClient
    Get-StorageBusCache
    Get-StorageBusClientDevice
    Get-StorageBusTargetCacheStore
    Get-StorageBusTargetCacheStoresInstance
    Get-StorageBusTargetDevice
    Get-StorageBusTargetDeviceInstance
    Get-StorageEnclosure
    Get-StorageFileServer
    Get-StorageJob
    Get-StorageNode
    Get-StoragePool
    Get-StorageProvider
    Get-StorageSetting
    Get-StorageSubsystem
    Get-StorageTier
    Get-StorageTierSupportedSize
    Get-SupportedClusterSizes
    Get-SupportedFileSystems
    Get-TargetPort
    Get-TargetPortal
    Get-VirtualDisk
    Get-VirtualDiskSupportedSize
    Get-Volume
    Get-VolumeCorruptionCount
    Get-VolumeScrubPolicy
    Get-WindowsErrorReporting
    Test-ClusterResourceFailure
```

</details>

#### Log Collection

<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Send-DiagnosticData
```

</details>

#### Diagnostic test
<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Test-Observability
```

</details>

#### NetworkATC
<details> 
<summary>Expand this section to see the commands.</summary>

```powershell
    Get-NetIntentStatus
```

</details>

#### UpdateService
<details>
<summary>Expand this section to see the commands.</summary>

```powershell
    Get-SolutionDiscoveryDiagnosticInfo
    Get-SolutionUpdate
    Get-SolutionUpdateEnvironment
    Get-SolutionUpdateRun
    Add-SolutionUpdate
    Start-SolutionUpdate
    Invoke-SolutionUpdatePrecheck
    Set-SolutionDiscovery
    Set-UpdateConfiguration
    Set-OverrideUpdateConfiguration
```

</details>

### Access level: Diagnostics and repair

The **Diagnostics and Repair** access level includes the following commands in addition to the commands listed in the [Access level: Diagnostics](#access-level-diagnostics) section. The commands are listed alphabetically and grouped by module or functionality.

**Default types**

```powershell
    Start-Service
    Stop-Service
```

## Next step

- Learn more about [Azure Arc extension management on Azure Local](../manage/arc-extension-management.md).
- Learn how to [Get remote support](../manage/get-remote-support.md).
