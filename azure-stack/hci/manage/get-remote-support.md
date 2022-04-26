---
title: Get remote support for Azure Stack HCI
description: This topic provides guidance on how to get remote support for the Azure Stack HCI operating system.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.date: 04/26/2022
---

# Get remote support for Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

This topic provides guidance on how to get remote support for your Azure Stack HCI operating system.

You can use remote support to allow a Microsoft support professional to solve your support case faster by permitting access to your device remotely and performing limited troubleshooting and repair. You can enable this feature by granting consent while controlling the access level and
duration of access. Microsoft support can access your device only after a support request is submitted.

Once enabled, Microsoft support gets just-in-time (JIT) limited time access to your device over a secure, audited, and compliant channel. Remote support uses the HTTPS protocol over port 443. The traffic is encrypted with TLS 1.2. Operations performed are restricted based on the
access level granted using [just enough administration](/powershell/scripting/learn/remoting/jea/overview) (JEA).

:::image type="content" source="media/remote-support/remote-support-workflow.png" alt-text="Diagram shows how the remote support works" border="true":::

## Why use remote support?

Remote support gives you the ability to:

- Improve the speed to resolution as Microsoft support no longer needs to arrange a meeting with you for troubleshooting.
- View the detailed transcript of all executed operations at any time.
- Grant just-in-time authenticated access on an incident-by-incident basis. You can define the access level and duration for each incident.
- Revoke consent at any time, which in turn terminates the remote session. Access is automatically disabled once the consent duration expires.

## Before you begin

Before you begin using remote support, complete the following:

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

If you are using a proxy with Azure Stack HCI, include the following endpoints in your allow list:

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

A local domain administrator must install the following JEA (just enough administration) configurations to grant remote support access. If the cluster is not registered with Azure, Microsoft support will provide you with the shared access signature (SAS) token required
to enable remote support.

| Name | Description |
|--|--|
| Install-AzStackHCIRemoteSupport | Install remote support agent |
|Enable-AzStackHCIRemoteSupport -AccessLevel `<Access Diagnostics or DiagnosticsRepair>` -AgreeToRemoteSupportConsent -ExpireInMinutes `<NumberOfMinutes>` -SasCredential `<SAS>`  | Enable remote support access by providing consent details and SAS token |
| Disable-AzStackHCIRemoteSupport | Disable remote support access by revoking consent |
| Get-AzStackHCIRemoteSupportAccess -Cluster  -IncludeExpired | Check the current remote support access status |
| Get-AzStackHCIRemoteSupportSessionHistory –FromDate `<DateTime>` -IncludeSessionTranscript –SessionId `<ID>` | View the remote support session history  |
| Remove-AzStackHCIRemoteSupport | Uninstall remote support agent |

### Install Remote Support extension (after Azure registration)

Install the Remote Support extension from the Windows Admin Center Extensions feed. Make sure that the Remote Support extension is updated to the latest version if already installed.

:::image type="content" source="media/remote-support/remote-support-extension-installed.png" alt-text="Screenshot to verify that the remote support extension is installed" border="false":::

### Grant remote support access

Before remote support is enabled, you must provide consent to authorize Microsoft support to execute diagnostic or repair commands.

:::image type="content" source="media/remote-support/remote-support-grant-access.png" alt-text="Screenshot of grant remote support access options" border="false":::

The following are the data handling terms and conditions for remote access. Carefully read these before granting access:

**By approving this request, the Microsoft support organization or the Azure engineering team supporting this feature ("Microsoft Support Engineer") will be given direct access to your device for troubleshooting purposes and/or resolving the technical issue described
in the Microsoft support case.**

**During a remote support session, a Microsoft Support Engineer may need to collect logs. By enabling remote support, you have agreed to a diagnostics log collection by a Microsoft Support Engineer to address a support case. You also acknowledge and consent to the upload and
retention of those logs in an Azure storage account managed and controlled by Microsoft. These logs may be accessed by Microsoft in the context of a support case and to improve the health of Azure Stack HCI.**

**The data will be used only to troubleshoot failures that are subject to a support ticket, and will not be used for marketing, advertising, or any other commercial purposes without your consent. The data may be retained for up to ninety (90) days and will be handled following our
standard privacy practices.**

**Any data previously collected with your consent will not be affected by the revocation of your permission.**

## Allowed Microsoft support operations

This section lists the allowed diagnostic or repair commands that Microsoft support can execute during a remote support session.

### Access level: Diagnostics

```powershell
Get-AzureStackHCI 
Get-AzureStackHCIArcIntegration 
Get-AzureStackHCIBillingRecord 
Get-AzureStackHCIRegistrationCertificate 
Get-AzureStackHCISubscriptionStatus 
Test-AzStackHCIConnection 
Get-PCStorageDiagnosticInfo 
Get-PCStorageReport 
Confirm-SddcDiagnosticModule 
Get-SddcDiagnosticArchiveJobParameters 
Get-SddcDiagnosticInfo 
Get-SpacesTimeline 
Show-SddcDiagnosticArchiveJob 
Show-SddcDiagnosticReport 
Show-SddcDiagnosticStorageLatencyReport 
Show-StorageCounters 
Install-SddcDiagnosticModule 
Get-AzStackHCIVMAttestation 
Get-AzureStackHCIAttestation 
Export-CauReport 
Get-CauClusterRole 
Get-CauDeviceInfoForFeatureUpdates 
Get-CauPlugin 
Get-CauReport 
Get-CauRun 
Test-CauSetup 
Get-ClusterPerf 
Get-ClusterS2D 
Export-HealthAgentConfig 
Get-ClusterAffinityRule 
Get-ClusterDiagnosticInfo 
Get-ClusterFaultDomain 
Get-ClusterFaultDomainXML 
Get-ClusterGroupSet 
Get-ClusterGroupSetDependency 
Get-ClusterHCSVM 
Get-ClusterNodeSupportedVersion 
Get-ClusterPerformanceHistory 
Get-ClusterStorageNode 
Get-ClusterStorageSpacesDirect 
Get-HealthFault 
Get-Cluster 
Get-ClusterAccess 
Get-ClusterAvailableDisk 
Get-ClusterBitLockerProtector 
Get-ClusterCheckpoint 
Get-ClusterGroup 
Get-ClusterLog 
Get-ClusterNetwork 
Get-ClusterNetworkInterface 
Get-ClusterNode 
Get-ClusterOwnerNode 
Get-ClusterParameter 
Get-ClusterQuorum 
Get-ClusterResource 
Get-ClusterResourceDependency 
Get-ClusterResourceDependencyReport 
Get-ClusterResourceType 
Get-ClusterSharedVolume 
Get-ClusterSharedVolumeState 
Get-ClusterVMMonitoredItem 
Test-Cluster 
Test-ClusterResourceFailure 
Get-VMCheckpoint 
Get-VHD 
Get-VHDSet 
Get-VHDSnapshot 
Get-VM 
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
Get-NetNatSession 
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
Get-DAPolicyChange 
Get-NetSwitchTeam 
Get-NetSwitchTeamMember 
Get-NetCompartment 
Get-NetIPAddress 
Get-NetIPConfiguration 
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
Get-NetVirtualizationProviderAddress 
Get-NetVirtualizationGlobal 
Get-NetVirtualizationLookupRecord 
Get-NetVirtualizationCustomerRoute 
Get-NetVirtualizationProviderRoute 
Get-NetView 
Get-DAConnectionStatus 
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
Get-RDCertificate 
Get-RDLicenseConfiguration 
Get-RDSessionCollection 
Get-RDSessionHost 
Get-RDVirtualDesktopCollection 
Get-RDVirtualDesktop 
Get-RDVirtualDesktopCollectionJobStatus 
Get-RDPersonalVirtualDesktopAssignment 
Get-RDSessionCollectionConfiguration 
Get-RDRemoteApp 
Get-RDServer 
Get-RDFileTypeAssociation 
Get-RDAvailableApp 
Get-RDWorkspace 
Get-RDRemoteDesktop 
Get-RDVirtualDesktopCollectionConfiguration 
Get-RDDeploymentGatewayConfiguration 
Get-RDVirtualDesktopTemplateExportPath 
Get-RDPersonalVirtualDesktopPatchSchedule 
Test-RDOUAccess 
Get-RDUserSession 
Get-RDConnectionBrokerHighAvailability 
Get-RDVirtualDesktopConcurrency 
Get-RDVirtualDesktopIdleCount 
Get-RDPersonalSessionDesktopAssignment 
Get-ScheduledTask 
Get-ScheduledTaskInfo 
Get-ClusteredScheduledTask 
Get-SecureBootUEFI 
Get-SecureBootPolicy 
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
Get-SmbServerCertificateMapping 
Get-SmbServerCertProps 
Get-SmbServerConfiguration 
Get-SmbServerNetworkInterface 
Get-SmbSession 
Get-SmbShare 
Get-SmbShareAccess 
Get-SmbWitnessClient 
Get-DiskSNV 
Get-PhysicalDiskSNV 
Get-StorageEnclosureSNV 
Get-DedupProperties 
Get-Disk 
Get-DiskImage 
Get-DiskStorageNodeView 
Get-FileIntegrity 
Get-FileShare 
Get-FileShareAccessControlEntry 
Get-FileStorageTier 
Get-InitiatorId 
Get-InitiatorPort 
Get-MaskingSet 
Get-OffloadDataTransferSetting 
Get-Partition 
Get-PartitionSupportedSize 
Get-PhysicalDisk 
Get-PhysicalDiskStorageNodeView 
Get-PhysicalExtent 
Get-PhysicalExtentAssociation 
Get-ResiliencySetting 
Get-StorageAdvancedProperty 
Get-StorageChassis 
Get-StorageDataCollection 
Get-StorageDiagnosticInfo 
Get-StorageEnclosure 
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
Get-StorageNode 
Get-StoragePool 
Get-StorageProvider 
Get-StorageRack 
Get-StorageReliabilityCounter 
Get-StorageScaleUnit 
Get-StorageSetting 
Get-StorageSite 
Get-StorageSubSystem 
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
Show-StorageHistory 
Show-VirtualDisk 
Get-StorageBusBinding 
Get-StorageBusCache 
Get-StorageBusClientDevice 
Get-StorageBusDisk 
Get-StorageBusTargetCacheStore 
Get-StorageBusTargetCacheStoresInstance 
Get-StorageBusTargetDevice 
Get-StorageBusTargetDeviceInstance 
Get-StorageQoSFlow 
Get-StorageQosPolicy 
Get-StorageQosPolicyStore 
Get-StorageQosVolume 
Test-SRTopology 
Get-SRGroup 
Get-SRPartnership 
Get-SRAccess 
Get-SRDelegation 
Get-SRNetworkConstraint 
Get-WindowsErrorReporting 
Get-Hotfix 
Get-StorageSubsystem 
Get-CauRun 
Save-CauDebugTrace 
Invoke-CauScan 
Get-CauReport 
Get-StorageJob
```

### Access level: Diagnostics and Repair

Includes all the diagnostics commands listed in the [Access level: Diagnostics](#access-level-diagnostics) section in addition to the following repair
commands:

```powershell
Add-AzStackHCIVMAttestation 
Disable-AzStackHCIAttestation 
Enable-AzStackHCIAttestation 
Remove-AzureStackHCIRegistration 
Remove-AzureStackHCIRegistrationCertificate 
Remove-AzStackHCIVMAttestation 
Set-AzureStackHCIRegistration 
Set-AzureStackHCIRegistrationCertificate 
Sync-AzureStackHCI 
Update-AzureStackHCIRegistrationCertificate 
```

## Next steps

Learn about [Azure Stack HCI Support](get-support.md)
