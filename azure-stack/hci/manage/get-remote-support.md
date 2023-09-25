---
title: Get remote support for Azure Stack HCI
description: Learn how to get remote support for the Azure Stack HCI operating system.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.custom: devx-track-azurepowershell
ms.date: 07/17/2023
---

# Get remote support for Azure Stack HCI

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article provides guidance on how to get remote support for your Azure Stack HCI operating system.

You can use remote support to allow a Microsoft support professional to solve your support case faster by permitting access to your device remotely and performing limited troubleshooting and repair. You can enable this feature by granting consent while controlling the access level and
duration of access. Microsoft support can access your device only after a [support request is submitted](/azure/azure-portal/supportability/how-to-create-azure-support-request).

Once enabled, Microsoft support gets just-in-time (JIT) limited time access to your device over a secure, audited, and compliant channel. Remote support uses the HTTPS protocol over port 443. The traffic is encrypted with TLS 1.2. Operations performed are restricted based on the
access level granted using [just enough administration](/powershell/scripting/learn/remoting/jea/overview) (JEA).

:::image type="content" source="media/remote-support/remote-support-workflow.png" alt-text="Process flow of authenticated access between customer and Microsoft support for diagnostics, troubleshooting, and remediation actions." lightbox="media/remote-support/remote-support-workflow.png" :::

## Why use remote support?

Remote support gives you the ability to:

- Improve the speed to resolution as Microsoft support no longer needs to arrange a meeting with you for troubleshooting.
- View the detailed transcript of all executed operations at any time.
- Grant just-in-time authenticated access on an incident-by-incident basis. You can define the access level and duration for each incident.
- Revoke consent at any time, which in turn terminates the remote session. Access is automatically disabled once the consent duration expires.

## Remote support terms and conditions

The following are the data handling terms and conditions for remote access. Carefully read them before granting access.

> By approving this request, the Microsoft support organization or the Azure engineering team supporting this feature ("Microsoft Support Engineer") will be given direct access to your device for troubleshooting purposes and/or resolving the technical issue described in the Microsoft support case.
>
> During a remote support session, a Microsoft Support Engineer may need to collect logs. By enabling remote support, you have agreed to a diagnostics log collection by a Microsoft Support Engineer to address a support case. You also acknowledge and consent to the upload and retention of those logs in an Azure storage account managed and controlled by Microsoft. These logs may be accessed by Microsoft in the context of a support case and to improve the health of Azure Stack HCI.
> 
> The data will be used only to troubleshoot failures that are subject to a support ticket, and will not be used for marketing, advertising, or any other commercial purposes without your consent. The data may be retained for up to ninety (90) days and will be handled following our standard privacy practices.
> 
> Any data previously collected with your consent will not be affected by the revocation of your permission.

For more information about the personal data that Microsoft processes, how Microsoft processes it, and for what purposes, review [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement).

## Prerequisites

For several remote support actions, you must have a domain administrator account. Make sure your administrator account is a member of the Domain Administrative group.

## Workflow

The high-level workflow to enable remote support is as follows:

- [Submit a support request](#submit-a-support-request)
- [Install the Az.StackHCI PowerShell module](#install-powershell-module)
- [Configure proxy settings](#configure-proxy-settings)
- [Install JEA configurations](#install-jea-configurations-before-azure-registration)
- [Install Remote Support extension](#grant-remote-support-access)
- [Grant remote support access](#grant-remote-support-access)

### Submit a support request

Microsoft support can access your device only after a support request is submitted. For information about how to create and manage support requests, see [Create an Azure support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).

### Install PowerShell module

Install the Az.StackHCI PowerShell module. Make sure that the module is updated to the latest version if already installed:

```powershell
Install-Module -Name Az.StackHCI
```

If not already installed, run the following cmdlet as a domain admin:

```powershell
Install-WindowsFeature -Name "RSAT-AD-PowerShell" -IncludeAllSubFeature
```

### Configure proxy settings

If you are using a proxy with Azure Stack HCI, include the following endpoints in your allowlist:

- \*.servicebus.windows.net
- \*.core.windows.net
- login.microsoftonline.com
- https\://asztrsprod.westus2.cloudapp.azure.com
- https\://asztrsprod.westeurope.cloudapp.azure.com
- https\://asztrsprod.eastus.cloudapp.azure.com
- https\://asztrsprod.westcentralus.cloudapp.azure.com
- https\://asztrsprod.southeastasia.cloudapp.azure.com
- https\://edgesupprd.trafficmanager.net

### Install JEA configurations (before Azure registration)

A domain administrator must install the following JEA configurations to grant remote support access. If the cluster is not registered with Azure, Microsoft support will provide you with the shared access signature (SAS) token required to enable remote support.

| Name | Description |
|--|--|
| Install-AzStackHCIRemoteSupport | Install remote support agent |
|Enable-AzStackHCIRemoteSupport -AccessLevel `<Access Diagnostics or DiagnosticsRepair>` -AgreeToRemoteSupportConsent -ExpireInMinutes `<NumberOfMinutes>` -SasCredential `<SAS>`  | Grant remote support access by providing consent details and SAS token |
| Disable-AzStackHCIRemoteSupport | Disable remote support access by revoking consent |
| Get-AzStackHCIRemoteSupportAccess -Cluster  -IncludeExpired | Check the current remote support access status |
| Get-AzStackHCIRemoteSupportSessionHistory –FromDate `<DateTime>` -IncludeSessionTranscript –SessionId `<ID>` | View the remote support session history  |
| Remove-AzStackHCIRemoteSupport | Uninstall remote support agent |

For example scenarios that show how to perform various operations to grant remote support access for Microsoft support, see the [Remote support examples](#remote-support-examples) section later in this article.  

### Install Remote Support extension (after Azure registration)

Install the Remote Support extension from the Windows Admin Center Extensions feed. Make sure that the Remote Support extension is updated to the latest version if already installed.

:::image type="content" source="media/remote-support/remote-support-extension-feed.png" alt-text="Screenshot of the Extensions page that displays Remote Support as available extension." lightbox="media/remote-support/remote-support-extension-feed.png":::

### Grant remote support access

Before remote support is enabled, you must provide consent to authorize Microsoft support to execute diagnostic or repair commands. You must have domain admin account to complete this step. Carefully read the [remote support terms and conditions](#remote-support-terms-and-conditions) before granting access.

:::image type="content" source="media/remote-support/remote-support-hci-grant-access.png" alt-text="Screenshot of grant remote support access options" lightbox="media/remote-support/remote-support-hci-grant-access.png":::

## Remote support examples

The following example scenarios show you how to perform various operations to grant remote support access for Microsoft support.

### Enable remote support for diagnostics

In this example, you grant remote support access for diagnostic-related operations only. The consent expires in 1,440 minutes (one day) after which remote access cannot be established.

```powershell
Enable-AzStackHCIRemoteSupport -AccessLevel Diagnostics -ExpireInMinutes 1440
```

Use **ExpireInMinutes** parameter to set the duration of the session. In the example, consent expires in 1,440 minutes (one day). After one day, remote access cannot be established.

You can set **ExpireInMinutes** a minimum duration of 60 minutes (one hour) and a maximum of 20,160 minutes (14 days).

If duration is not defined, the remote session expires in 480 (8 hours) by default.

### Enable remote support for diagnostics and repair

In this example, you grant remote support access for diagnostic and repair related operations only. Because expiration was not explicitly provided, it expires in eight hours by default.

```powershell
Enable-AzStackHCIRemoteSupport -AccessLevel DiagnosticsRepair
```

### Retrieve existing consent grants

In this example, you retrieve any previously granted consent. The result includes expired consent in the last 30 days.

```powershell
Get-AzStackHCIRemoteSupportAccess -IncludeExpired
```

### Revoke remote access consent

In this example, you revoke remote access consent. Any existing sessions are terminated and new sessions can no longer be established.

```powershell
Disable-AzStackHCIRemoteSupport
```

### List existing remote sessions

In this example, you list all the remote sessions that were made to the device since *FromDate*.

```powershell
Get-AzStackHCIRemoteSupportSessionHistory -FromDate <Date>
```

### Get details on a specific remote session

In this example, you get the details for remote session with the ID *SessionID*.

```powershell
Get-AzStackHCIRemoteSupportSessionHistory -IncludeSessionTranscript -SessionId <SessionId>
```

> [!NOTE]
> Session transcript details are retained for ninety days. You can retrieve detail for a remote session within ninety days after the session.

## List of Microsoft support operations

You can grant Microsoft support one of the following access levels for remote support:

- [**Diagnostics**](#access-level-diagnostics): To view diagnostic info and logs
- [**Diagnostics and repair**](#access-level-diagnostics-and-repair): To view diagnostic info and logs plus perform software repairs

The following section lists the allowed commands that Microsoft support can execute during a remote support session.

### Access level: Diagnostics

The **Diagnostics** access level includes the following commands that Microsoft support can execute during a remote support session. The commands are listed alphabetically and grouped by module or functionality.

**Default types**

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

**Azure Stack HCI**

```powershell
    Get-AzureStackHCI
    Get-AzureStackHCIArcIntegration
    Get-AzureStackHCIBillingRecord
    Get-AzureStackHCIRegistrationCertificate
    Get-AzureStackHCISubscriptionStatus
    Send-DiagnosticData
    Test-AzStackHCIConnection
```

**Hyper-V**

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

**Failover Cluster**

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

**Net Adapter**

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

**Storage**

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

### Access level: Diagnostics and repair

The **Diagnostics and Repair** access level includes the following commands in addition to the commands listed in the [Access level: Diagnostics](#access-level-diagnostics) section. The commands are listed alphabetically and grouped by module or functionality.

**Default types**

```powershell
    Start-Service
    Stop-Service
```

## Next steps

Learn about [Azure Stack HCI Support](get-support.md)
