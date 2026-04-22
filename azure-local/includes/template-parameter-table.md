---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 10/16/2025
ms.reviewer: alkohli
---

The following table describes the parameters that you define in the ARM template's parameters file:

| Parameter | Description |
|--|--|
| deploymentMode | Determines if the deployment process should only validate or proceed with full deployment:<br/>- **Validate**: Creates Azure resources for this system and validates your system's readiness to deploy.<br/>- **Deploy**: Performs the actual deployment after successful validation. |
| keyVaultName | Name of the Azure Key Vault to be used for storing secrets.<br/>For naming conventions, see [Microsoft.KeyVault](/azure/azure-resource-manager/management/resource-name-rules#microsoftkeyvault) in the Naming rules and restrictions for Azure resources article. |
| softDeleteRetentionDays | Number of days that deleted items (such as secrets, keys, or certificates) are retained in an Azure Key Vault before they are permanently deleted.<br/>Specify a value between 7 and 90 days. You can’t change the retention period later. |
| diagnosticStorageAccountName | Name of the Azure Storage Account used to store key vault audit logs. This account is a locally redundant storage (LRS) account with a lock. <br/>For more information, see [Azure Storage Account](/azure/storage/common/storage-account-create?tabs=azure-portal). For naming conventions, see [Azure Storage account names](/azure/storage/common/storage-account-overview#storage-account-name).|
| logsRetentionInDays | Number of days that logs are retained. <br/> If you don't want to apply any retention policy and retain data forever, specify 0. |
| storageAccountType | Type of the Azure Storage Account to be used in the deployment. For example, Standard_LRS. |
| clusterName | Name of the Azure Local instance being deployed.<br/> This is the name that represents your cluster on cloud. It must be different from any of the node names. |
| location | Deployment location, typically derived from the resource group.  <br/>For a list of supported Azure regions, see [Azure requirements](../concepts/system-requirements-23h2.md?tabs=azure-public#azure-requirements). |
| tenantId | Azure subscription tenant ID. <br/>For more information, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id#find-your-microsoft-entra-tenant).|
| witnessType | Witness type for your Azure Local cluster. </br>Witness type must be Cloud for a two-node cluster. It can  be empty for other cluster sizes.<br/>For more information on cloud witness, see [Deploy a quorum witness](/windows-server/failover-clustering/deploy-quorum-witness?tabs=domain-joined-witness%2Cfailovercluster%2Cfailovercluster1&pivots=cloud-witness). |
| clusterWitnessStorageAccountName | Name of the storage account used for cluster witness.<br/>For more information, see [Azure Storage Account](/azure/storage/common/storage-account-create?tabs=azure-portal). For naming conventions, see [Azure Storage account names](/azure/storage/common/storage-account-overview#storage-account-name). |
| localAdminUserName | Username for the local administrator for all the machines in your system. The credentials are identical for all the machines in your system. <br/>For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md).|
| localAdminPassword | Password for the local administrator for all the machines in your system. The credentials are identical for all the machines in your system.<br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md). |
| AzureStackLCMAdminUsername | Username for the LCM admin.<br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md).|
| AzureStackLCMAdminPasssword | Password for the LCM admin. <br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md).|
| hciResourceProviderObjectID | Object ID of the Azure Local Resource Provider. <br/> For more information, see [Get the object ID for Azure Local Resource Provider](#get-the-object-id-for-azure-local-resource-provider).|
| arcNodeResourceIds | Array of resource IDs of the Azure Arc-enabled servers that are part of this Azure Local cluster. |
| domainFqdn | Fully qualified domain name (FQDN) for the Active Directory Domain Services prepared for deployment. |
| namingPrefix | Prefix used for all objects created for the Azure Local deployment. |
| adouPath | Path of the Organizational Unit (OU) created for this deployment. The OU can't be at the top level of the domain. For example: OU=Local001,DC=contoso,DC=com. |
| securityLevel | Security configuration profile to be applied to the Azure Local cluster during deployment. The default is **Recommended**. |
| driftControlEnforced | Drift control setting to reapply the security defaults regularly. <br/>For more information, see [Security features for Azure Local](../concepts/security-features.md). |
| credentialGuardEnforced | Credential Guard setting that uses virtualization-based security to isolate secrets from credential-theft attacks. <br/> For more information, see [Manage security defaults for Azure Local](../manage/manage-secure-baseline.md).|
| smbSigningEnforced | Setting for signing SMB traffic between this Azure Local cluster and others to help prevent relay attacks.<br/>For more information, see [Overview of Server Message Block signing](/troubleshoot/windows-server/networking/overview-server-message-block-signing). |
| smbClusterEncryption | SMB cluster traffic setting for encrypting traffic between servers in the cluster on your storage network.<br/>For more information, see [SMB encryption](/windows-server/storage/file-server/smb-security#smb-encryption). |
| bitlockerBootVolume | BitLocker encryption setting for encrypting OS volume on each server.<br/>For more information, see [Manage BitLocker encryption on Azure Local](../manage/manage-bitlocker.md). |
| bitlockerDataVolumes | BitLocker encryption setting for encrypting cluster shared volumes (CSVs) created on this system during deployment.<br/>For more information, see [Manage BitLocker encryption on Azure Local](../manage/manage-bitlocker.md). |
| wdacEnforced | Application Control setting to control which drivers and apps are allowed to run directly on each server.<br/>For more information, see [Manage Application Control for Azure Local](../manage/manage-wdac.md). |
| streamingDataClient | Specifies whether telemetry data streaming from the Azure Local cluster to Microsoft is enabled. |
| euLocation | Specifies whether to send and store telemetry and diagnostic data within the European Union (EU). |
| episodicDataUpload | Episodic diagnostic data setting to specify whether to collect log data and upload to Microsoft to assist with troubleshooting and support.<br/>For more information, see [Crash dump collection](../concepts/observability.md#crash-dump-collection). |
| configurationMode | Storage volume configuration mode. The supported values are:<br/>- **Express**: Creates one thinly provisioned volume and storage path per machine for workloads to use. This is in addition to the required one infrastructure volume per cluster. <br/>- **InfraOnly**: Creates only the required one infrastructure volume per cluster. You need to create workload volumes and storage paths later.<br/>- **KeepStorage**: Preserves existing data drives that contain a Storage Spaces pool and volumes.  |
| subnetMask | The subnet mask for the management network used by the Azure Local deployment. |
| defaultGateway | The default gateway for deploying an Azure Local cluster. |
| startingIPAddress | The first IP address in a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.<br/>These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid. |
| endingIPAddress | The last IP address in a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.<br/>These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid. |
| dnsServers | List of DNS server IPs. |
| useDhcp | Indicates whether to use Dynamic Host Configuration Protocol (DHCP) for hosts and cluster IPs. <br/>If not declared, the deployment will default to static IPs. If TRUE, gateway and DNS servers are not required. |
| physicalNodesSettings | Array of physical nodes with their IP addresses. |
| networkingType | Type of networking. For example, switchedMultiServerDeployment.<br/>For more information, see [Specify network settings](../deploy/deploy-via-portal.md#specify-network-settings). |
| networkingPattern | Pattern used for networking. For example, hyperConverged. |
| intentList | List of deployment intents. |
| storageNetworkList | List of storage networks. |
| storageConnectivitySwitchless | Specifies whether storage connectivity is configured without network switches. |
| enableStorageAutoIp | Specifies whether automatic IP assignment is enabled. |
| customLocation | Custom location for deployment. |
| sbeVersion | Version of the Solution Builder Extension (SBE) to be used during an Azure Local deployment. |
| sbeFamily | Family or category of the SBE package being applied during deployment. |
| sbePublisher | Publisher or vendor of the SBE. |
| sbeManifestSource | Source location of the SBE manifest file. |
| sbeManifestCreationDate | Creation date of the SBE manifest. |
| partnerProperties | List of partner-specific properties. |
| partnerCredentiallist | List of partner credentials. |