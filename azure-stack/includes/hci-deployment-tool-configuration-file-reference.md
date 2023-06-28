---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.topic: include
ms.date: 06/28/2023
ms.subservice: azure-stack-hci
ms.reviewer: alkohli
ms.lastreviewed: 12/05/2022
---

The following table gives descriptions for the settings listed in the configuration file:

|Setting|Description|
|---|---|
|**SecuritySettings**|Section name|
|SecurityModeSealed|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|SecuredCoreEnforced|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|VBSProtection|By default, Virtualization-based Security (VBS) is enabled on your Azure Stack HCI cluster. For more information, see [Virtualization-based Security](/windows-hardware/design/device-experiences/oem-vbs).|
|HVCIProtection|By default, Hypervisor-protected Code Integrity (HVCI) is enabled on your Azure HCI cluster. For more information, see [Hypervisor-protected Code Integrity](/windows-hardware/design/device-experiences/oem-hvci-enablement).|
|DRTMProtection|By default, Secure Boot is enabled on your Azure HCI cluster. This setting is hardware dependent. For more information, see [Secure Boot with Dynamic Root of Trust for Measurement (DRTM)](/windows-server/security/secured-core-server#2-advanced-protection).|
|KernelDMAProtection|By default, Pre-boot Kernel Direct Memory Access (DMA) protection is enabled on your Azure HCI cluster. This setting is hardware dependent. For more information, see [Kernel Direct Memory Access protection](/windows-server/security/secured-core-server#2-advanced-protection).|
|DriftControlEnforced|When set to `true`, the security baseline is re-applied regularly. For more information, see [Security baseline settings for Azure Stack HCI](../hci/concepts/secure-baseline.md)|
|CredentialGuardEnforced|When set to `true`, Credential Guard is enabled. For more information, see [Manage Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/credential-guard-manage).|
|SMBSigningEnforced|When set to `true`, the SMB default instance requires sign in for the client and server services. For more information, see [Overview of Server Message Block signing](/troubleshoot/windows-server/networking/overview-server-message-block-signing).|
|SMBClusterEncryption|When set to `true`, cluster east-west traffic is encrypted. For more information, see [SMB encryption](/windows-server/storage/file-server/smb-security#smb-encryption).|
|SideChannelMitigationEnforced|When set to `true`, all the side channel mitigations are enabled, see [KB4072698](https://support.microsoft.com/topic/kb4072698-windows-server-and-azure-stack-hci-guidance-to-protect-against-silicon-based-microarchitectural-and-speculative-execution-side-channel-vulnerabilities-2f965763-00e2-8f98-b632-0d96f30c8c8e).|
|BitLockerBootVolume|When set to `true`, BitLocker XTS_AES 256-bit encryption is enabled for all data-at-rest on the OS volume of your Azure Stack HCI cluster. This setting is TPM-hardware dependent. For more information, see [BitLocker encryption for Azure Stack HCI](../hci/concepts/security-bitlocker.md).|
|BitLockerDataVolumes|When set to `true`, BitLocker XTS-AES 256-bit encryption is enabled for all data-at-rest on your Azure Stack HCI cluster shared volumes. For more information, see [BitLocker encryption for Azure Stack HCI](../hci/concepts/security-bitlocker.md).|
|SEDProtectionEnforced|Not used for Azure Stack HCI version 22H2.|
|WDACEnforced|Windows Defender Application Control (WDAC) is enabled by default and limits the applications and the code that you can run on your Azure Stack HCI cluster. For more information, see [Windows Defender Application Control](../hci/concepts/security-windows-defender-application-control.md).|
|**Observability**|Section name|
|StreamingDataClient|Enables telemetry data to be sent to Microsoft.|
|EULocation|Location of your cluster. The log and diagnostic data is sent to the appropriate diagnostics servers depending upon where your cluster resides. Setting this to `false` results in all data sent to Microsoft to be stored outside of the EU.|
|EpisodicDataUpload|When set to `true`, collects log data to facilitate quicker issue resolution.|
|**Cluster**|Section name|
|Name|The cluster name provided when preparing Active Directory.|
|StaticAddress| This value is not used during deployment and will be removed in future releases.|
|WitnessType|Specify the witness type as `cloud` or local `fileshare` for your Azure Stack HCI cluster. <br><br> Use a cloud witness if you have internet access and if you use an Azure Storage account to provide a vote on cluster quorum. A cloud witness uses Azure Blob Storage to read or write a blob file and then uses it to arbitrate in split-brain resolution. For more information on cloud witness, see [Deploy a cloud witness for Failover cluster](/windows-server/failover-clustering/deploy-cloud-witness). <br><br> Use a file share witness if you use a local SMB file share to provide a vote in the cluster quorum. You should also use a file share witness if all the servers in a cluster have spotty internet connectivity or can't use disk witness as there aren't any shared drives.|
|WitnessPath|Specify the fileshare path for the local witness for your Azure Stack HCI cluster.|
|CloudAccountName|Specify the Azure Storage account name for cloud witness for your Azure Stack HCI cluster.|
|AzureServiceEndpoint|For Azure blob service endpoint type, select either **Default** or **Custom domain**. If you selected **Custom domain, enter the domain for the blob service in this format `core.windows.net`.|
|**Storage**|Section name|
|ConfigurationMode|By default, this mode is set to `Express` and your storage is configured as per best practices based on the number of nodes in the cluster. For more information, see step [4. 1 Set up cluster storage in Deploy Azure Stack HCI interactively](../hci/deploy/deployment-tool-new-file.md).|
|**OptionalServices**|Section name|
|VirtualSwitchName| This value is not used during deployment and will be removed in future releases.|
|CSVPath| This value is not used during deployment and will be removed in future releases.|
|ARBRegion| This value is not used during deployment and will be removed in future releases.|
|**ActiveDirectorySettings**|Section name|
|NamingPrefix|The prefix used for all AD objects created for the Azure Stack HCI deployment. The prefix must not exceed eight characters.|
|DomainFQDN|The fully qualified domain name (FQDN) for the Active Directory domain used by your cluster.|
|ExternalDomainFQDN| This value is not used during deployment and will be removed in future releases.|
|ADOUPath|The path to the Active Directory Organizational Unit (ADOU) container object prepared for the deployment. Format must be that for a distinguished name (including domain components). For example: "OU=OUName,DC=contoso,DC=com".|
|DNSForwarder|Name of the server used to forward DNS queries for external DNS names. This value is not used during deployment and will be removed in future releases.|
|**InfrastructureNetwork**|Section name|
|VlanId|Only supported value in version 2210 is `0`.|
|SubnetMask|Subnet mask that matches the provided IP address space.|
|Gateway|Default gateway that should be used for the provided IP address space.|
|IPPools|Range of IP addresses from which addresses are allocated for nodes within a subnet.|
|StartingAddress|Starting IP address for the management network. A minimum of six free, contiguous IPv4 addresses (excluding your host IPs) are needed for infrastructure services such as clustering.|
|EndingAddress|Ending IP address for the management network. A minimum of six free, contiguous IPv4 addresses (excluding your host IPs) are needed for infrastructure services such as clustering.|
|DNSServers| IPv4 address of the DNS servers in your environment. DNS servers are required as they're used when your server attempts to communicate with Azure or to resolve your server by name in your network. The DNS server you configure must be able to resolve the Active Directory domain.|
|**PhysicalNodes**|Section name|
|Name|NETBIOS name of each physical server on your Azure Stack HCI cluster.|
|IPv4Address|The IPv4 address assigned to each physical server on your Azure Stack HCI cluster.|
|**HostNetwork**|Section name|
|Intents|The network intents assigned to the network reference pattern used for the deployment. Each intent will define its own name, traffic type, adapter names, and overrides as recommended by your OEM.|
|Name|Name of the network intent you wish to create.|
|TrafficType|Type of network traffic. Examples include compute, storage, and management traffic.|
|Adapter|Array of network interfaces used for the network intent.|
|OverrideVirtualSwitchConfigurationOverrides|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|OverrideQoSPolicy|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|QoSPolicyOverrides|List of QoS policy overrides as specified by your OEM. Do not modify this parameter without OEM validation.|
|PriorityValue8021Action_Cluster|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|PriorityValue8021Action_SMB|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|BandwidthPercentage_SMB|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|OverrideAdapterProperty|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|AdapterPropertyOverrides|List of adapter property overrides as specified by your OEM. Do not modify this parameter without OEM validation.|
|JumboPacket|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|NetworkDirect|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|NetworkDirectTechnology|This parameter should only be modified based on your OEM guidance. Do not modify this parameter without OEM validation.|
|**StorageNetworks**|Section name|
|Name|Name of the storage network.|
|NetworkAdapterName|Name of the storage network adapter.|
|VlanID|ID specified for the VLAN storage network. This setting is applied to the network interfaces that route the storage and VM migration traffic. Network ATC uses VLANs 711 and 712 for the first two storage networks. Additional storage networks will use the next VLAN ID on the sequence.|