---
title: Get remote support for Azure Stack HCI (preview)
description: This topic provides guidance on how to get remote support for the Azure Stack HCI operating system.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.date: 04/26/2022
---

# Get remote support for Azure Stack HCI (preview)

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

> [!IMPORTANT]
> Remote support for Azure Stack HCI is currently in preview.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

This topic provides guidance on how to get remote support for your Azure Stack HCI operating system.

You can use remote support to allow a Microsoft support professional to solve your support case faster by permitting access to your device remotely and performing limited troubleshooting and repair. You can enable this feature by granting consent while controlling the access level and
duration of access. Microsoft support can access your device only after a [support request is submitted](/azure/azure-portal/supportability/how-to-create-azure-support-request).

Once enabled, Microsoft support gets just-in-time (JIT) limited time access to your device over a secure, audited, and compliant channel. Remote support uses the HTTPS protocol over port 443. The traffic is encrypted with TLS 1.2. Operations performed are restricted based on the
access level granted using [just enough administration](/powershell/scripting/learn/remoting/jea/overview) (JEA).

:::image type="content" source="media/remote-support/remote-support-workflow.png" alt-text="Process flow of authenticated access between customer and Microsoft support for diagnostics, troubleshooting, and remediation actions." border="false":::

## Why use remote support?

Remote support gives you the ability to:

- Improve the speed to resolution as Microsoft support no longer needs to arrange a meeting with you for troubleshooting.
- View the detailed transcript of all executed operations at any time.
- Grant just-in-time authenticated access on an incident-by-incident basis. You can define the access level and duration for each incident.
- Revoke consent at any time, which in turn terminates the remote session. Access is automatically disabled once the consent duration expires.

## Before you begin

Before you begin using remote support, you must:

- [Install PowerShell module](#install-powershell-module)
- [Configure proxy settings](#configure-proxy-settings)
- [Install JEA configurations](#install-jea-configurations-before-azure-registration)
- [Install Remote Support extension](#grant-remote-support-access)
- [Grant remote support access](#grant-remote-support-access)

### Install PowerShell module

Install the Az.StackHCI PowerShell module. Make sure that the module is updated to the latest version if already installed:

```powershell
Install-Module -Name Az.StackHCI
```

### Configure proxy settings

If you are using a proxy with Azure Stack HCI, include the following endpoints in your allowlist:

- \*.servicebus.windows.net
- \*.core.windows.net
- login.microsoftonline.com
- https://edgesupprdwestuufrontend.westus2.cloudapp.azure.com
- https://edgesupprdwesteufrontend.westeurope.cloudapp.azure.com
- https://edgesupprdeastusfrontend.eastus.cloudapp.azure.com
- https://edgesupprdwestcufrontend.westcentralus.cloudapp.azure.com
- https://edgesupprdasiasefrontend.southeastasia.cloudapp.azure.com
- https://edgesupprd.trafficmanager.net

### Install JEA configurations (before Azure registration)

A local domain administrator must install the following JEA configurations to grant remote support access. If the cluster is not registered with Azure, Microsoft support will provide you with the shared access signature (SAS) token required to enable remote support.

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

:::image type="content" source="media/remote-support/remote-support-extension-installed.png" alt-text="Screenshot to verify that the remote support extension is installed" border="false":::

### Grant remote support access

Before remote support is enabled, you must provide consent to authorize Microsoft support to execute diagnostic or repair commands. Carefully read the [remote support terms and conditions](#remote-support-terms-and-conditions) before granting access.

:::image type="content" source="media/remote-support/remote-support-grant-access.png" alt-text="Screenshot of grant remote support access options" border="false":::

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

- **Diagnostics:** To view diagnostic info and logs
- **Diagnostics and repair:** To view diagnostic info and logs in addition to perform software repairs

The following sections list the allowed diagnostic or repair commands that Microsoft support can execute during a remote support session.

### Access level: Diagnostics

The **Diagnostics** access level includes the following commands that Microsoft support can execute during a remote support session:

```powershell
Confirm-SddcDiagnosticModule 
Export-CauReport 
Export-HealthAgentConfig 
Get-AzStackHCIVMAttestation 
Get-AzureStackHCI 
Get-AzureStackHCIArcIntegration 
Get-AzureStackHCIAttestation 
Get-AzureStackHCIBillingRecord 
Get-AzureStackHCIRegistrationCertificate 
Get-AzureStackHCISubscriptionStatus 
Get-CauClusterRole 
Get-CauDeviceInfoForFeatureUpdates 
Get-CauPlugin 
Get-CauReport 
Get-CauReport 
Get-CauRun 
Get-CauRun 
Get-Cluster 
Get-ClusterAccess 
Get-ClusterAffinityRule 
Get-ClusterAvailableDisk 
Get-ClusterBitLockerProtector 
Get-ClusterCheckpoint 
Get-ClusterDiagnosticInfo 
Get-ClusterFaultDomain 
Get-ClusterFaultDomainXML 
Get-ClusterGroup 
Get-ClusterGroupSet 
Get-ClusterGroupSetDependency 
Get-ClusterHCSVM 
Get-ClusterLog 
Get-ClusterNetwork 
Get-ClusterNetworkInterface 
Get-ClusterNode 
Get-ClusterNodeSupportedVersion 
Get-ClusterOwnerNode 
Get-ClusterParameter 
Get-ClusterPerf 
Get-ClusterPerformanceHistory 
Get-ClusterQuorum 
Get-ClusterResource 
Get-ClusterResourceDependency 
Get-ClusterResourceDependencyReport 
Get-ClusterResourceType 
Get-ClusterS2D 
Get-ClusterSharedVolume 
Get-ClusterSharedVolumeState 
Get-ClusterStorageNode 
Get-ClusterStorageSpacesDirect 
Get-ClusterVMMonitoredItem 
Get-ClusteredScheduledTask 
Get-DAConnectionStatus 
Get-DAPolicyChange 
Get-DedupProperties 
Get-Disk 
Get-DiskImage 
Get-DiskSNV 
Get-DiskStorageNodeView 
Get-DscConfiguration 
Get-DscConfigurationStatus 
Get-DscLocalConfigurationManager 
Get-DscResource 
Get-FileIntegrity 
Get-FileShare 
Get-FileShareAccessControlEntry 
Get-FileStorageTier 
Get-HealthFault 
Get-Hotfix 
Get-InitiatorId 
Get-InitiatorPort 
Get-JobTrigger 
Get-LogProperties 
Get-MaskingSet 
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
Get-NetAdapterVPort 
Get-NetAdapterVmq 
Get-NetAdapterVmqQueue 
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
Get-NetIPConfiguration 
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
Get-NetNatSession 
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
Get-NetVirtualizationCustomerRoute 
Get-NetVirtualizationGlobal 
Get-NetVirtualizationLookupRecord 
Get-NetVirtualizationProviderAddress 
Get-NetVirtualizationProviderRoute 
Get-OffloadDataTransferSetting 
Get-PCStorageDiagnosticInfo 
Get-PCStorageReport 
Get-Partition 
Get-PartitionSupportedSize 
Get-PhysicalDisk 
Get-PhysicalDiskSNV 
Get-PhysicalDiskStorageNodeView 
Get-PhysicalExtent 
Get-PhysicalExtentAssociation 
Get-RDAvailableApp 
Get-RDCertificate 
Get-RDConnectionBrokerHighAvailability 
Get-RDDeploymentGatewayConfiguration 
Get-RDFileTypeAssociation 
Get-RDLicenseConfiguration 
Get-RDPersonalSessionDesktopAssignment 
Get-RDPersonalVirtualDesktopAssignment 
Get-RDPersonalVirtualDesktopPatchSchedule 
Get-RDRemoteApp 
Get-RDRemoteDesktop 
Get-RDServer 
Get-RDSessionCollection 
Get-RDSessionCollectionConfiguration 
Get-RDSessionHost 
Get-RDUserSession 
Get-RDVirtualDesktop 
Get-RDVirtualDesktopCollection 
Get-RDVirtualDesktopCollectionConfiguration 
Get-RDVirtualDesktopCollectionJobStatus 
Get-RDVirtualDesktopConcurrency 
Get-RDVirtualDesktopIdleCount 
Get-RDVirtualDesktopTemplateExportPath 
Get-RDWorkspace 
Get-ResiliencySetting 
Get-SRAccess 
Get-SRDelegation 
Get-SRGroup 
Get-SRNetworkConstraint 
Get-SRPartnership 
Get-ScheduledJob 
Get-ScheduledJobOption 
Get-ScheduledTask 
Get-ScheduledTaskInfo 
Get-SddcDiagnosticArchiveJobParameters 
Get-SddcDiagnosticInfo 
Get-SecureBootPolicy 
Get-SecureBootUEFI 
Get-SmbBandwidthLimit 
Get-SmbClientConfiguration 
Get-SmbClientNetworkInterface 
Get-SmbConnection 
Get-SmbDelegation 
Get-SmbGlobalMapping 
Get-SmbMapping 
Get-SmbMultichannelConnection 
Get-SmbMultichannelConstraint 
Get-SmbOpenFile 
Get-SmbServerCertProps 
Get-SmbServerCertificateMapping 
Get-SmbServerConfiguration 
Get-SmbServerNetworkInterface 
Get-SmbSession 
Get-SmbShare 
Get-SmbShareAccess 
Get-SmbWitnessClient 
Get-SpacesTimeline 
Get-StorageAdvancedProperty 
Get-StorageBusBinding 
Get-StorageBusCache 
Get-StorageBusClientDevice 
Get-StorageBusDisk 
Get-StorageBusTargetCacheStore 
Get-StorageBusTargetCacheStoresInstance 
Get-StorageBusTargetDevice 
Get-StorageBusTargetDeviceInstance 
Get-StorageChassis 
Get-StorageDataCollection 
Get-StorageDiagnosticInfo 
Get-StorageEnclosure 
Get-StorageEnclosureSNV 
Get-StorageEnclosureStorageNodeView 
Get-StorageEnclosureVendorData 
Get-StorageExtendedStatus 
Get-StorageFaultDomain 
Get-StorageFileServer 
Get-StorageFirmwareInformation 
Get-StorageHealthAction 
Get-StorageHealthReport 
Get-StorageHealthSetting 
Get-StorageHistory 
Get-StorageJob
Get-StorageJob 
Get-StorageNode 
Get-StoragePool 
Get-StorageProvider 
Get-StorageQoSFlow 
Get-StorageQosPolicy 
Get-StorageQosPolicyStore 
Get-StorageQosVolume 
Get-StorageRack 
Get-StorageReliabilityCounter 
Get-StorageScaleUnit 
Get-StorageSetting 
Get-StorageSite 
Get-StorageSubSystem 
Get-StorageSubsystem 
Get-StorageTier 
Get-StorageTierSupportedSize 
Get-SupportedClusterSizes 
Get-SupportedFileSystems 
Get-TargetPort 
Get-TargetPortal 
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
Get-VMRemoteFXPhysicalVideoAdapter 
Get-VMRemoteFx3dVideoAdapter 
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
Get-VirtualDisk 
Get-VirtualDiskSupportedSize 
Get-Volume 
Get-VolumeCorruptionCount 
Get-VolumeScrubPolicy 
Get-WindowsErrorReporting 
Install-SddcDiagnosticModule 
Invoke-CauScan 
Save-CauDebugTrace 
Show-SddcDiagnosticArchiveJob 
Show-SddcDiagnosticReport 
Show-SddcDiagnosticStorageLatencyReport 
Show-StorageCounters 
Show-StorageHistory 
Show-VirtualDisk 
Test-AzStackHCIConnection 
Test-CauSetup 
Test-Cluster 
Test-ClusterResourceFailure 
Test-DscConfiguration 
Test-RDOUAccess 
Test-SRTopology
```

### Access level: Diagnostics and Repair

The **Diagnostics and Repair** access level includes the following repair commands in addition to the commands listed in the [Access level: Diagnostics](#access-level-diagnostics) section:

```powershell
Add-AzStackHCIVMAttestation 
Disable-AzStackHCIAttestation 
Enable-AzStackHCIAttestation 
Remove-AzStackHCIVMAttestation 
Remove-AzureStackHCIRegistration 
Remove-AzureStackHCIRegistrationCertificate 
Set-AzureStackHCIRegistration 
Set-AzureStackHCIRegistrationCertificate 
Sync-AzureStackHCI 
Update-AzureStackHCIRegistrationCertificate
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
