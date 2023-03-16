---
title: Get remote support for Azure Stack HCI (preview)
description: This topic provides guidance on how to get remote support for the Azure Stack HCI operating system.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.custom: devx-track-azurepowershell
ms.date: 03/16/2023
---

# Get remote support for Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

> [!IMPORTANT]
> Remote support for Azure Stack HCI is currently in preview.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

This topic provides guidance on how to get remote support for your Azure Stack HCI operating system.

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

## Workflow

The high-level workflow to enable remote support is as follows:

- [Submit a support request](#submit-a-support-request)
- [Create a KDS root key](#create-a-kds-root-key)
- [Install the Az.StackHCI PowerShell module](#install-powershell-module)
- [Configure proxy settings](#configure-proxy-settings)
- [Install JEA configurations](#install-jea-configurations-before-azure-registration)
- [Install Remote Support extension](#grant-remote-support-access)
- [Grant remote support access](#grant-remote-support-access)

## Prerequisites

- For several remote support actions, you must have a domain administrator account. Make sure your administrator account is a member of the Domain Administrative group.

### Submit a support request

Microsoft support can access your device only after a support request is submitted. For information about how to create and manage support requests, see [Create an Azure support request](/azure/azure-portal/supportability/how-to-create-azure-support-request).

### Create a KDS root key

Your Active Directory environment must contain a Key Distribution Services (KDS) root key in order to host gMSA accounts.

Run the following cmdlet to determine if your environment contains a KDS root key:

```powershell
Get-KDSRootKey
```

If the results are null, follow the steps given in the [Create the Key Distribution Services KDS Root Key](/windows-server/security/group-managed-service-accounts/create-the-key-distribution-services-kds-root-key#to-create-the-kds-root-key-using-the-add-kdsrootkey-cmdlet) article to create a KDS root key.

> [!NOTE]
> It could take several hours for full Active Directory replication before you can successfully grant remote support access.

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
- https\://edgesupprdwestuufrontend.westus2.cloudapp.azure.com
- https\://edgesupprdwesteufrontend.westeurope.cloudapp.azure.com
- https\://edgesupprdeastusfrontend.eastus.cloudapp.azure.com
- https\://edgesupprdwestcufrontend.westcentralus.cloudapp.azure.com
- https\://edgesupprdasiasefrontend.southeastasia.cloudapp.azure.com
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

Install the Remote Support extension from the Windows Admin Center Extensions feed. You must have domain admin account to complete this step. Make sure that the Remote Support extension is updated to the latest version if already installed.

:::image type="content" source="media/remote-support/remote-support-extension-installed.png" alt-text="Screenshot to verify that the remote support extension is installed" lightbox="media/remote-support/remote-support-extension-installed.png":::

### Grant remote support access

Before remote support is enabled, you must provide consent to authorize Microsoft support to execute diagnostic or repair commands. Carefully read the [remote support terms and conditions](#remote-support-terms-and-conditions) before granting access.

:::image type="content" source="media/remote-support/remote-support-hci-grant-access.png" alt-text="Screenshot of grant remote support access options" lightbox="media/remote-support/remote-support-hci-grant-access.png":::

## Remote support examples

The following example scenarios show you how to perform various operations to grant remote support access for Microsoft support.

### Enable remote support for diagnostics

In this example, you grant remote support access for diagnostic related operations only. The consent expires in 1,440 minutes (one day) after which remote access cannot be established.

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
- [**Diagnostics and repair**](#access-level-diagnostics-and-repair): To view diagnostic info and logs in addition to perform software repairs

The following section lists the allowed commands that Microsoft support can execute during a remote support session.

### Access level: Diagnostics

The **Diagnostics** access level includes the following commands that Microsoft support can execute during a remote support session:

- **Default types**

    ```powershell
        Clear-Host
        Exit-PSSession
        Format-Table
        Format-List
        Get-Command
        Get-FormatData
        Get-Date
        Get-Help
        Get-Service
        Get-Process
        Measure-Object        
        Out-Default
        Select-Object
        Sort-Object
        Where-Object
    ```

- **Azure Stack HCI**

```powershell
    Get-AzureStackHCI
    Get-AzureStackHCIArcIntegration
    Get-AzureStackHCIBillingRecord
    Get-AzureStackHCIRegistrationCertificate
    Get-AzureStackHCISubscriptionStatus
    Test-AzStackHCIConnection
``` 

- **Hyper-V**

```powershell
    Get-VHD
    Get-VM
    Get-VMHost
    Get-VMSwitch
    Get-VMCheckpoint
    Get-VHDSet
    Get-VHDSnapshot
    Get-VMAssignableDevice
    Get-VMBios
    Get-VMComPort
    Get-VMConnectAccess
    Get-VMDvdDrive
    Get-VMFibreChannelHba
    Get-VMFirmware
    Get-VMFloppyDiskDrive
    Get-VMGpuPartitionAdapter
    Get-VMGroup
    Get-VMHardDiskDrive
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

- **Failover Cluster**

```powershell
    Get-Cluster
    Get-ClusterGroup
    Get-ClusterNode
    Get-ClusterOwnerNode
    Get-ClusterResource
    Get-ClusterSharedVolume
    Export-CauReport
    Get-CauClusterRole
    Get-CauDeviceInfoForFeatureUpdates
    Get-CauPlugin
    Get-CauRun
    Test-CauSetup
```

- **Net Adapter**

```powershell
    Get-NetAdapter
    Get-NetAdapterRdma
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
    Get-NetAdapterRsc
    Get-NetAdapterRss
    Get-NetAdapterSriov
    Get-NetAdapterSriovVf
    Get-NetAdapterStatistics
    Get-NetAdapterUso
    Get-NetAdapterVmq
    Get-NetAdapterVmqQueue
    Get-NetAdapterVPort
    Get-NetConnectionProfile
    Get-NetEventNetworkAdapter
    Get-NetEventPacketCaptureProvider
    Get-NetEventProvider
    Get-NetEventSession
    Get-NetEventVFPProvider
    Get-NetEventVmNetworkAdapter
    Get-NetEventVmSwitch
    Get-NetEventVmSwitchProvider
    Get-NetEventWFPCaptureProvider
    Get-NetLbfoTeam
    Get-NetLbfoTeamMember
    Get-NetLbfoTeamNic
    Get-NetNat
    Get-NetNatExternalAddress
    Get-NetNatGlobal
    Get-NetNatStaticMapping
    Get-NetQosPolicy
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
    Get-NetIPsecDospSetting
    Get-NetIPsecMainModeCryptoSet
    Get-NetIPsecMainModeRule
    Get-NetIPsecMainModeSA
    Get-NetIPsecPhase1AuthSet
    Get-NetIPsecPhase2AuthSet
    Get-NetIPsecQuickModeCryptoSet
    Get-NetIPsecQuickModeSA
    Get-NetIPsecRule
    Get-NetSwitchTeam
    Get-NetSwitchTeamMember
    Get-NetCompartment
    Get-NetIPAddress
    Get-NetIPInterface
    Get-NetIPv4Protocol
    Get-NetIPv6Protocol
    Get-NetNeighbor
    Get-NetOffloadGlobalSetting
    Get-NetPrefixPolicy
    Get-NetRoute
    Get-NetTCPConnection
    Get-NetTCPSetting
    Get-NetTransportFilter
    Get-NetUDPEndpoint
    Get-NetUDPSetting
    Get-NetView
    Get-NCSIPolicyConfiguration
    Get-Net6to4Configuration
    Get-NetDnsTransitionConfiguration
    Get-NetDnsTransitionMonitoring
    Get-NetIPHttpsConfiguration
    Get-NetIPHttpsState
    Get-NetIsatapConfiguration
    Get-NetNatTransitionConfiguration
    Get-NetNatTransitionMonitoring
    Get-NetTeredoConfiguration
    Get-NetTeredoState
    Get-DscConfiguration
    Get-DscConfigurationStatus
    Get-DscLocalConfigurationManager
    Get-DscResource
    Test-DscConfiguration
    Get-LogProperties
    Get-JobTrigger
    Get-ScheduledJobOption
    Get-ScheduledJob
    Get-ScheduledTask
    Get-ScheduledTaskInfo
    Get-ClusteredScheduledTask
    Get-SecureBootUEFI
    Get-SecureBootPolicy
```

- **Storage**

```powershell
    Get-StorageEnclosure
    Get-StorageJob
    Get-StorageNode
    Get-StorageSubsystem
    Get-VirtualDisk
    Get-Volume
    Get-ClusterS2D
    Get-ClusterAffinityRule
    Get-ClusterFaultDomain
    Get-ClusterFaultDomainXML
    Get-ClusterGroupSet
    Get-ClusterGroupSetDependency
    Get-ClusterHCSVM
    Get-ClusterNodeSupportedVersion
    Get-ClusterStorageNode
    Get-ClusterStorageSpacesDirect
    Get-ClusterAccess
    Get-ClusterAvailableDisk
    Get-ClusterNetwork
    Get-ClusterNetworkInterface
    Get-ClusterParameter
    Get-ClusterQuorum
    Get-ClusterResourceDependency
    Get-ClusterResourceDependencyReport
    Get-ClusterResourceType
    Get-ClusterSharedVolumeState
    Test-ClusterResourceFailure
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
    Get-StorageFileServer
    Get-StoragePool
    Get-StorageProvider
    Get-StorageSetting
    Get-StorageTier
    Get-StorageTierSupportedSize
    Get-SupportedClusterSizes
    Get-SupportedFileSystems
    Get-TargetPort
    Get-TargetPortal
    Get-VirtualDiskSupportedSize
    Get-VolumeCorruptionCount
    Get-VolumeScrubPolicy
    Get-StorageBusCache
    Get-StorageBusClientDevice
    Get-StorageBusTargetCacheStore
    Get-StorageBusTargetCacheStoresInstance
    Get-StorageBusTargetDevice
    Get-StorageBusTargetDeviceInstance
    Get-WindowsErrorReporting
```

### Access level: Diagnostics and repair

The **Diagnostics and repair** access level includes the following commands that Microsoft support can execute during a remote support session:

- **Default types**

```powershell
    Start-Service
    Stop-Service
```

## Remote support terms and conditions

The following are the data handling terms and conditions for remote access. Carefully read them before granting access.

> By approving this request, the Microsoft support organization or the Azure engineering team supporting this feature ("Microsoft Support Engineer") will be given direct access to your device for troubleshooting purposes and/or resolving the technical issue described
in the Microsoft support case.
>
> During a remote support session, a Microsoft Support Engineer may need to collect logs. By enabling remote support, you have agreed to a diagnostics log collection by a Microsoft Support Engineer to address a support case. You also acknowledge and consent to the upload and
retention of those logs in an Azure storage account managed and controlled by Microsoft. These logs may be accessed by Microsoft in the context of a support case and to improve the health of Azure Stack HCI.
> 
> The data will be used only to troubleshoot failures that are subject to a support ticket, and will not be used for marketing, advertising, or any other commercial purposes without your consent. The data may be retained for up to ninety (90) days and will be handled following our
standard privacy practices.
> 
> Any data previously collected with your consent will not be affected by the revocation of your permission.

## Next steps

Learn about [Azure Stack HCI Support](get-support.md)
