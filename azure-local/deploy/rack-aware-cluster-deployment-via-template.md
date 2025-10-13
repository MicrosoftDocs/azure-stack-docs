---
title: Azure Resource Manager template deployment for Rack Aware Cluster (Preview)
description: Learn how to prepare and then deploy Rack Aware Cluster using the Azure Resource Manager template (Preview).
author: alkohli
ms.topic: how-to
ms.date: 10/13/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Deploy Rack Aware Cluster using Azure Resource Manager deployment template (Preview)

This article describes how to use an Azure Resource Manager (ARM) template in the Azure portal to deploy a Rack Aware Cluster.

[!INCLUDE [important](../includes/hci-preview.md)]

> [!IMPORTANT]
> ARM template deployment of Rack Aware Cluster is targeted for deployments-at-scale. The intended audience for this deployment is IT administrators who have experience deploying Rack Aware Clusters. We recommend that you deploy a system via the Azure portal first, and then perform subsequent deployments via the ARM template.

## Prerequisites

<!--- Confirm if this prereq applies. Completion of [Register your machines with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md). Make sure that:
  - All machines are running the same version of OS.
  - All the machines have the same network adapter configuration.-->

- Make sure to select the **create-cluster-rac-enabled** template for deployment.

## Step 1: Prepare Azure resources

Follow these steps to prepare the Azure resources you need for deployment:

### Get the object ID for Azure Local Resource Provider

<!--Use include once the public PR gets merged-->

This object ID for the Azure Local Resource Provide (RP) is unique per Azure tenant.

1. In the Azure portal, search for and go to Microsoft Entra ID.  
1. Go to the **Overview** tab and search for *Microsoft.AzureStackHCI Resource Provider*.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/search-azure-stackhci-resource-provider-1a.png" alt-text="Screenshot showing the search for the Azure Local Resource Provider service principal." lightbox="./media/deployment-azure-resource-manager-template/search-azure-stackhci-resource-provider-1a.png":::

1. Select the Service Principal Name that is listed and copy the **Object ID**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/get-azure-stackhci-object-id-1a.png" alt-text="Screenshot showing the object ID for the Azure Local Resource Provider service principal." lightbox="./media/deployment-azure-resource-manager-template/get-azure-stackhci-object-id-1a.png":::

    Alternatively, you can use PowerShell to get the object ID of the Azure Local RP service principal. Run the following command in PowerShell:

    ```powershell
    Get-AzADServicePrincipal -DisplayName "Microsoft.AzureStackHCI Resource Provider"
    ```

    You use the **Object ID** against the `hciResourceProviderObjectID` parameter in the ARM template.

## Step 2: Deploy using ARM template

An ARM template is a JSON file where you define what you want to deploy to Azure. It creates and assigns all the resource permissions required for deployment.

Once all prerequisite and preparation steps are complete, you're ready to deploy using a validated ARM template and its corresponding parameters JSON file. This file contains all required values, including those generated previously.

ARM template deployment involves two modes:

- **Validate:** Confirms that all parameters are correctly configured and validates your system's readiness to deploy.
- **Deploy:** Performs the actual deployment after successful validation.

### Step 2.1: Deploy the template in Validate mode

This step ensures that all parameters are configured correctly and validates your system's readiness to deploy.

1. In the Azure portal, go to **Home** and then select **+ Create a resource**.

1. Under **Template deployment (deploy using custom templates)**, select **Create**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png" alt-text="Screenshot showing the template deployment (deploy using custom template)." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png":::

1. On the **Custom deployment** page, proceed through the tabs described in the following sections.

#### Select a template tab
  
Use the **Select a template** tab to choose the template for your deployment.
  
1. On the **Select a template** tab, under the **Start with a quickstart template or template spec** section, select the **Quickstart template** option.
  
1. From the **Quickstart template (disclaimer)** dropdown, select the **create-cluster-rac-enabled** template.
  
1. Select the **Select template** button to continue to the **Basics** tab.
  
    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/select-a-template-tab.png" alt-text="Screenshot showing template to deploy Rack Aware Cluster." lightbox="./media/rack-aware-cluster-deployment-via-template/select-a-template-tab.png":::
  
#### Basics tab
  
Use the **Basics** tab to provide the essential information to initiate the deployment.

This section describes how to configure the **Basics** tab using the following sample Rack Aware Cluster configuration:
  
You deploy a Rack Aware Cluster with four machines, two in each rack:
  
- **node1** and **node2** are physically located in the same rack (**Zone1**).
- **node3** and **node4** are located in a different rack (**Zone2**).

For an example of a parameter JSON file that shows the format of various inputs, such as `ArcNodeResourceId`, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster/azuredeploy.parameters.json).

> [!IMPORTANT]
> - Ensure that all parameters in the JSON file are filled out.
> - Replace any placeholder values such as `[“”]`, with actual data. These placeholders indicate that the parameter expects an array structure.
> - If required values are missing or incorrectly formatted, the validation will fail.
  
1. On the **Basics** tab, select the required parameters from the dropdown list, or select **Edit parameters** to modify them manually.
  
    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/basics-tab.png" alt-text="Screenshot showing the Edit parameters button on the Basics tab." lightbox="./media/rack-aware-cluster-deployment-via-template/basics-tab.png":::
  
1. Configure all required parameters. Configure the following extra parameters required for Rack Aware Cluster deployment. You can use the sample JSON snippets to deploy the cluster described in the example configuration.
    
    - **Arc node resource IDs.**
      
        ```json
        "arcNodeResourceIds": {
        "value": [
        "/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node1",
        "/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node2",
        "/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node3",
        "/subscriptions/SubID/resourcegroup/providers/Microsoft.HybridCompute/machines/node4"
        ]
        }
        ```
  
    - **Cluster pattern and local Availability Zones.**
        Verify that the `clusterPattern` parameter is **RackAware**.
        Ensure that **node1** and **node2** are physically located in **Zone1** (same rack), and **node3** and **node4** are in **Zone2** (different rack).
  
        ```json
        "clusterPattern": {
        "value": "RackAware"
        },
        "localAvailabilityZones": {
            "value": [
            {
                "localAvailabilityZoneName": "Zone1",
                "nodes": ["node1inRack1","node2inRack1"]  
            },
            {
                "localAvailabilityZoneName": "Zone2",
                "nodes": ["node1inRack2","node2inRack2"]
            }
            ]
        },
        ```
  
    - **Cloud witness configuration.**
      Rack Aware Cluster requires cloud witness. Enter the name of the cloud witness, which is created during the deployment process.
      
        ```json
        "witnessType": {
        "value": "Cloud"
        },
        "clusterWitnessStorageAccountName": {
        "value": "yourcloudwitness"
        },
        ```
  
    - **Network intent configuration.**
      The storage network intent must be a dedicated network intent. vlanIDs 711 and 712 are defaults and can be customized for your environment.
 
        ```json
        "networkingType": {
        "value" : "switchedMultiserverDeployment"
        },
        "networkingPattern": {
        "value" : "convergedManagementCompute"
        },
        "intentList" : {
        "value": [
        {
        "name": "ManagementCompute",
        "trafficType" : ["Management","Compute"],
        "adapter": ["ethernet","ethernet 2"],
        "overridevirtualswitchConfiguration" : false,
        "virtualswitchConfigurationoverrides" : {
        "enableIov" : "",
        "loadBalancingAlgorithm": ""
        },
        "overrideQosPolicy": false,
        "qosPolicyoverrides" : {
        "priorityvalue8021Action_SMB" : "",
        "priorityvalues8021Action_Cluster" : "",
        "bandwidthPercentage_SMB" : ""
        },
        "overrideAdapterProperty" : false,
        "adapterPropertyoverrides": {
        "jumboPacket": "",
        "networkDirect": "",
        "networkDirectTechnology" : ""
        }
        }
        ]
        }    
        ```
  
1. After configuring all parameters, select **Save** to save the parameters file.
  
1. Select the appropriate resource group for your environment.
  
1. Confirm that **Deployment Mode** is set to **Validate**.
  
1. Select **Review + create** to continue.
  
    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/review-and-create-button.png" alt-text="Screenshot showing Review + Create selected on Basics tab." lightbox="./media/rack-aware-cluster-deployment-via-template/review-and-create-button.png":::
  
#### Review + create tab
  
Use the **Review + create** tab to review your deployment settings and accept the legal terms before creating the resources.
  
1. On the **Review + Create** tab, review the deployment summary and legal terms.
  
1. Select **Create** to begin validation. This action creates the remaining prerequisite resources and validates the deployment. Validation takes about 10 minutes to complete.
  
    :::image type="content" source="./media/rack-aware-cluster-deployment-via-template/review-and-create-tab.png" alt-text="Screenshot showing Create selected on Review + Create tab." lightbox="./media/rack-aware-cluster-deployment-via-template/review-and-create-tab.png":::
  
1. After validation completes, continue to the **Deploy** phase to provision the full environment.
  
### Step 2.2: Deploy the template in Deploy mode

After successful validation, you're ready to proceed with the actual deployment using the validated ARM template and its corresponding parameters JSON file.

1. Once validation is complete, select **Redeploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png" alt-text="Screenshot showing Redeploy selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png":::

1. On the **Custom deployment** screen, select **Edit parameters**. Load up the previously saved parameters and select **Save**.

1. Verify that all fields for the ARM template are filled in by the parameters JSON file.

1. Select the appropriate resource group for your environment.

1. Confirm that **Deployment Mode** is set to **Deploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png" alt-text="Screenshot showing deploy selected for deployment mode." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png":::

1. Select **Review + create**.

1. Select **Create** to begin deployment. The deployment uses the existing prerequisite resources created during the [Deploy the template in Validate mode](#step-21-deploy-the-template-in-validate-mode) step.

    The Deployment screen cycles on the cluster resource during deployment.

    Once deployment initiates, there's a limited Environment Checker run, a full Environment Checker run, and cloud deployment starts.

    After a few minutes, you can monitor deployment progress in the Azure portal.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png" alt-text="Screenshot showing the status of environment checker validation." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png":::

### Monitor deployment

1. In a new browser window, navigate to the resource group for your environment. Select the cluster resource.

1. Select **Deployments**.

1. Refresh and watch the deployment progress from the first machine (also known as the seed machine and is the first machine where you deployed the cluster). Deployment takes between 2.5 and 3 hours. Several steps take 40-50 minutes or more.

1. The step in deployment that takes the longest is **Deploy Moc and ARB Stack**. This step takes 40-45 minutes.

    Once complete, the task at the top updates with status and end time.

<!--## ARM template parameters reference

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
| domainFqdn | Fully-qualified domain name (FQDN) for the Active Directory Domain Services prepared for deployment. |
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
<!--| clusterPattern | Supported storage type for the Azure Local cluster: <br/>- **Standard**<br/>- **RackAware** |
| localAvailabilityZones | Local Availability Zone information for the Azure Local cluster. |-->

<!--## Troubleshoot deployment issues

If the deployment fails, you should see an error message on the deployments page.

1. On the **Deployment details**, select the **error details**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/select-view-error-details-1.png" alt-text="Screenshot showing the selection of error details." lightbox="./media/deployment-azure-resource-manager-template/select-view-error-details-1.png":::

2. Copy the error message from the **Errors** blade. You can provide this error message to Microsoft support for further assistance.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/select-view-error-details-2.png" alt-text="Screenshot showing the summary in the Errors blade." lightbox="./media/deployment-azure-resource-manager-template/select-view-error-details-2.png":::

### Known issues for ARM template deployment

This section contains known issues and workarounds for ARM template deployment.

#### Role assignment already exists

**Issue**: In this release, you may see *Role assignment already exists* error. This error occurs if the Azure Local instance deployment was attempted from the portal first and the same resource group was used for ARM template deployment. You see this error on the **Overview > Deployment details** page for the applicable resource. This error indicates that an equivalent role assignment was already done by another identity for the same resource group scope and the ARM template deployment is unable to perform role assignment.

:::image type="content" source="./media/deployment-azure-resource-manager-template/select-view-error-details-3.png" alt-text="Screenshot showing the role assignment error in the Errors blade." lightbox="./media/deployment-azure-resource-manager-template/select-view-error-details-3.png":::

**Workaround**: The failed resource on the Deployment details page specifies the role assignment name. If the resource name is **AzureStackHCIDeviceManagementRole-RoleAssignment** then role assignment failed for the **Azure Stack HCI Device Management Role**. Note this role name and go to **Resource Group > Access Control (IAM) > Role Assignments**. Search for the corresponding name and delete the existing role assignments there. Redeploy your template.

:::image type="content" source="./media/deployment-azure-resource-manager-template/workaround-details-2.png" alt-text="Screenshot showing the role assignment name on the Details page." lightbox="./media/deployment-azure-resource-manager-template/workaround-details-2.png":::

#### Tenant ID, application ID, principal ID, and scope aren't allowed to be updated

**Issue**: Role assignment fails with error *Tenant ID, application ID, principal ID, and scope aren't allowed to be updated*. You see this error on the **Overview > Deployment details** page for the applicable resource. This error could show up when there are zombie role assignments in the same resource group. For example, when a prior deployment was performed and the resources corresponding to that deployment were deleted but the role assignment resources were left around.

:::image type="content" source="./media/deployment-azure-resource-manager-template/error-tenantid-applicationid-principalid-not-allowed-to-update-1.png" alt-text="Screenshot showing the tenant ID, application ID, principal ID, and scope can't be updated message in the Errors blade." lightbox="./media/deployment-azure-resource-manager-template/error-tenantid-applicationid-principalid-not-allowed-to-update-1.png":::

**Workaround**: To identify the zombie role assignments, go to **Access control (IAM) > Role assignments > Type : Unknown** tab. These assignments are listed as *Identity not found. Unable to find identity.* Delete such role assignments and then retry ARM template deployment.

:::image type="content" source="./media/deployment-azure-resource-manager-template/error-identity-not-found-1.png" alt-text="Screenshot showing the identity not found message in the Errors blade." lightbox="./media/deployment-azure-resource-manager-template/error-identity-not-found-1.png":::

#### License sync issue

**Issue**: In this release, you may encounter license sync issue when using ARM template deployment.

**Workaround**: After the system completes the validation stage, we recommend that you don't initiate another ARM template deployment in **Validate** mode if your system is in **Deployment failed** state. Starting another deployment resets the system properties, which could result in license sync issues.-->

## Next steps

<!--Add next steps-->
