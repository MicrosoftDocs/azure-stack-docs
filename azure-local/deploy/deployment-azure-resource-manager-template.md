---
title: Azure Resource Manager template deployment for Azure Local, version 23H2
description: Learn how to prepare and then deploy Azure Local instance, version 23H2 using the Azure Resource Manager template.
author: alkohli
ms.topic: how-to
ms.date: 07/08/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
ms.custom: devx-track-arm-template
---

# Deploy Azure Local via Azure Resource Manager deployment template

This article details how to use an Azure Resource Manager template in the Azure portal to deploy an Azure Local in your environment. The article also contains the prerequisites and the preparation steps required to begin the deployment.

> [!IMPORTANT]
> Azure Resource Manager template deployment of Azure Local systems is targeted for deployments-at-scale. The intended audience for this deployment is IT administrators who have experience deploying Azure Local instances. We recommend that you deploy a system via the Azure portal first, and then perform subsequent deployments via the Resource Manager template.

## Prerequisites

- Completion of [Register your machines with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md). Make sure that:
  - All machines are running the same version of OS.
  - All the machines have the same network adapter configuration.

::: moniker range="<=azloc-24113"

- For Azure Local 2411.3 and earlier versions, make sure to select the **create-cluster-2411.3** template for deployment.

::: moniker-end

::: moniker range=">=azloc-2503"

- For Azure Local 2503 and later versions, make sure to select the **create-cluster** template for deployment.

::: moniker-end

## Step 1: Prepare Azure resources

Follow these steps to prepare the Azure resources you need for the deployment:

::: moniker range="<=azloc-24113"

### Create a service principal and client secret

To authenticate your system, you need to create a service principal and a corresponding **Client secret** for Arc Resource Bridge (ARB).

### Create a service principal for ARB

Follow the steps in [Create a Microsoft Entra application and service principal that can access resources via Azure portal](/entra/identity-platform/howto-create-service-principal-portal) to create the service principal and assign the roles. Alternatively, use the PowerShell procedure to [Create an Azure service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps).

The steps are also summarized here:

1. Sign in to the [Microsoft Entra admin center](https://entra.microsoft.com/) as at least a Cloud Application Administrator. Browse to **Identity > Applications > App registrations** then select **New registration**.

1. Provide a **Name** for the application, select a **Supported account type**, and then select **Register**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/create-service-principal-1a.png" alt-text="Screenshot showing Register an application for service principal creation." lightbox="./media/deployment-azure-resource-manager-template/create-service-principal-1a.png":::

1. Once the service principal is created, go to the **Enterprise applications** page. Search for and select the SPN you created.

   :::image type="content" source="./media/deployment-azure-resource-manager-template/create-service-principal-2a.png" alt-text="Screenshot showing search results for the service principal created." lightbox="./media/deployment-azure-resource-manager-template/create-service-principal-2a.png":::

1. Under properties, copy the **Application (client) ID**  and the **Object ID** for this service principal.

   :::image type="content" source="./media/deployment-azure-resource-manager-template/create-service-principal-2b.png" alt-text="Screenshot showing Application (client) ID and the object ID for the service principal created." lightbox="./media/deployment-azure-resource-manager-template/create-service-principal-2b.png":::

    You use the **Application (client) ID** against the `arbDeploymentAppID` parameter and the **Object ID** against the `arbDeploymentSPNObjectID` parameter in the Resource Manager template.

### Create a client secret for ARB service principal

1. Go to the application registration that you created and browse to **Certificates & secrets > Client secrets**.
1. Select **+ New client** secret.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/create-client-secret-1.png" alt-text="Screenshot showing creation of a new client secret." lightbox="./media/deployment-azure-resource-manager-template/create-client-secret-1.png":::

1. Add a **Description** for the client secret and provide a timeframe when it **Expires**. Select **Add**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/create-client-secret-2.png" alt-text="Screenshot showing Add a client secret blade." lightbox="./media/deployment-azure-resource-manager-template/create-client-secret-2.png":::

1. Copy the **client secret value** as you use it later.

    > [!Note]
    > For the application client ID, you will need it's secret value. Client secret values can't be viewed except for immediately after creation. Be sure to save this value when created before leaving the page.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/create-client-secret-3.png" alt-text="Screenshot showing client secret value." lightbox="./media/deployment-azure-resource-manager-template/create-client-secret-3.png":::

    You use the **client secret value** against the `arbDeploymentAppSecret` parameter in the Resource Manager template.

::: moniker-end

### Get the object ID for Azure Local Resource Provider

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

    You use the **Object ID** against the `hciResourceProviderObjectID` parameter in the Resource Manager template.

## Step 2: Deploy using Azure Resource Manager template

An Azure Resource Manager (ARM) creates and assigns all the resource permissions required for deployment.

With all the prerequisite and preparation steps complete, you're ready to deploy using a known good and tested Resource Manager deployment template and corresponding parameters JSON file. Use the parameters contained in the JSON file to fill out all values, including the values generated previously.

For an example of a parameter JSON file, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster/azuredeploy.parameters.json). For detailed descriptions of the parameters defined in this file, see [ARM template parameters reference](#arm-template-parameters-reference).

> [!IMPORTANT]
> In this release, make sure that all the parameters contained in the JSON value are filled out including the ones that have a null value. If there are null values, then those parameters need to be populated or the validation fails.

1. In the Azure portal, go to **Home** and select **+ Create a resource**.

2. Select **Create** under **Template deployment (deploy using custom templates)**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png" alt-text="Screenshot showing the template deployment (deploy using custom template)." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png":::

3. Near the bottom of the page, find **Start with a quickstart template or template spec** section. Select **Quickstart template** option.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-2.png" alt-text="Screenshot showing the quickstart template selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-2.png":::

::: moniker range="<=azloc-24113"

4. From the **Quickstart template (disclaimer)** dropdown list, select the **create-cluster-2411.3** template.

5. When finished, select the **Select template** button.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-24113-and-earlier.png" alt-text="Screenshot showing template selected for version 2411.3 and earlier." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-24113-and-earlier.png":::

6. On the **Basics** tab, you see the **Custom deployment** page. You can select the various parameters through the dropdown list or select **Edit parameters**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-4a.png" alt-text="Screenshot showing Custom deployment page on the Basics tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-4a.png":::

    > [!NOTE]
    > For an example parameter file that shows the format of various inputs, such as `ArcNodeResourceId`, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-2411.3/azuredeploy.parameters.json).

::: moniker-end

::: moniker range=">=azloc-2503"

4. Use the **Quickstart template (disclaimer)** field to filter for the appropriate template. Type *azurestackhci/create-cluster* for the filter.

5. When finished, select the **Select template** button.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-3a.png" alt-text="Screenshot showing template selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-3a.png":::

6. On the **Basics** tab, you see the **Custom deployment** page. You can select the various parameters through the dropdown list or select **Edit parameters**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-4a.png" alt-text="Screenshot showing Custom deployment page on the Basics tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-4a.png":::

    > [!NOTE]
    > For an example parameter file that shows the format of various inputs, such as `ArcNodeResourceId`, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster/azuredeploy.parameters.json).

::: moniker-end

7. Edit parameters such as network intent or storage network intent. Once the parameters are all filled out, **Save** the parameters file.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-5.png" alt-text="Screenshot showing parameters filled out for the template." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-5.png":::

8. Select the appropriate resource group for your environment.

9. Scroll to the bottom, and confirm that **Deployment Mode = Validate**.

10. Select **Review + create**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-6.png" alt-text="Screenshot showing Review + Create selected on Basics tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-6.png":::

11. On the **Review + Create** tab, select **Create**. This creates the remaining prerequisite resources and validates the deployment. Validation takes about 10 minutes to complete.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7.png" alt-text="Screenshot showing Create selected on Review + Create tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7.png":::

12. Once validation is complete, select **Redeploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png" alt-text="Screenshot showing Redeploy selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png":::

13. On the **Custom deployment** screen, select **Edit parameters**. Load up the previously saved parameters and select **Save**.

14. At the bottom of the workspace, change the final value in the JSON from **Validate** to **Deploy**, where **Deployment Mode = Deploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png" alt-text="Screenshot showing deploy selected for deployment mode." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png":::

15. Verify that all the fields for the Resource Manager deployment template are filled in by the Parameters JSON.

16. Select the appropriate resource group for your environment.

17. Scroll to the bottom, and confirm that **Deployment Mode = Deploy**.

18. Select **Review + create**.

19. Select **Create**. The deployment begins, using the existing prerequisite resources that were created during the **Validate** step.

    The Deployment screen cycles on the cluster resource during deployment.

    Once deployment initiates, there's a limited Environment Checker run, a full Environment Checker run, and cloud deployment starts. After a few minutes, you can monitor deployment in the portal.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png" alt-text="Screenshot showing the status of environment checker validation." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png":::

20. In a new browser window, navigate to the resource group for your environment. Select the cluster resource.

21. Select **Deployments**.

22. Refresh and watch the deployment progress from the first machine (also known as the seed machine and is the first machine where you deployed the cluster). Deployment takes between 2.5 and 3 hours. Several steps take 40-50 minutes or more.

23. The step in deployment that takes the longest is **Deploy Moc and ARB Stack**. This step takes 40-45 minutes.

    Once complete, the task at the top updates with status and end time.

You can also check out this community sourced template to [Deploy an Azure Local instance using Bicep](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs/README.md).

## ARM template parameters reference

The following table describes the parameters that you define in the ARM template's parameters file:

| Parameter | Description |
|--|--|
| deploymentMode | Determines if the deployment process should only validate or proceed with full deployment:<br/>- **Validate**: Creates Azure resources for this system and validates your system's readiness to deploy.<br/>- **Deploy**: Performs the actual deployment after successful validation. |
| keyVaultName | Name of the Azure Key Vault to be used for storing secrets.<br/><br/>For naming conventions, see [Microsoft.KeyVault](/azure/azure-resource-manager/management/resource-name-rules#microsoftkeyvault) in the Naming rules and restrictions for Azure resources article. |
| softDeleteRetentionDays | Number of days that deleted items (such as secrets, keys, or certificates) are retained in an Azure Key Vault before they are permanently deleted.<br/>Specify a value between 7 and 90 days. You can’t change the retention period later. |
| diagnosticStorageAccountName | Name of the Azure Storage Account used to store key vault audit logs. This account is a locally redundant storage (LRS) account with a lock. <br/><br/>For more information, see [Azure Storage Account](/azure/storage/common/storage-account-create?tabs=azure-portal). For naming conventions, see [Azure Storage account names](/azure/storage/common/storage-account-overview#storage-account-name).|
| logsRetentionInDays | <br/><br/>Number of days that logs are retained. <br/> If you don't want to apply any retention policy and retain data forever, specify 0. |
| storageAccountType | Type of the Azure Storage Account to be used in the deployment. For example, Standard_LRS. |
| clusterName | Name of the Azure Local instance being deployed. This name must be different from any of the node names. |
| location | Deployment location, typically derived from the resource group.  <br/><br/>For a list of supported Azure regions, see [Azure requirements](../concepts/system-requirements-23h2.md?tabs=azure-public#azure-requirements). |
| tenantId | Azure subscription tenant ID. <br/><br/>For more information, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id#find-your-microsoft-entra-tenant).|
| witnessType | Witness type for your Azure Local cluster. </br>Witness type must be Cloud for a two-node cluster. It can  be empty for other cluster sizes.<br/><br/>For more information on cloud witness, see [Deploy a quorum witness](/windows-server/failover-clustering/deploy-quorum-witness?tabs=domain-joined-witness%2Cfailovercluster%2Cfailovercluster1&pivots=cloud-witness). |
| clusterWitnessStorageAccountName | Name of the storage account used for cluster witness.<br/><br/>For more information, see [Azure Storage Account](/azure/storage/common/storage-account-create?tabs=azure-portal). For naming conventions, see [Azure Storage account names](/azure/storage/common/storage-account-overview#storage-account-name). |
| localAdminUserName | Username for the local administrator for all the machines in your system. The credentials are identical for all the machines in your system. <br/><br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md).|
| localAdminPassword | Password for the local administrator for all the machines in your system. The credentials are identical for all the machines in your system.<br/><br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md). |
| AzureStackLCMAdminUsername | Username for the LCM admin.<br/><br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md).|
| AzureStackLCMAdminPasssword | Password for the LCM admin. <br/><br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md).|
| hciResourceProviderObjectID | Object ID of the Azure Local Resource Provider. <br/><br/> For more information, see [Get the object ID for Azure Local Resource Provider](#get-the-object-id-for-azure-local-resource-provider).|
| arcNodeResourceIds | Array of resource IDs of the Azure Arc-enabled servers that are part of the Azure Local cluster. |
| domainFqdn | Fully-qualified domain name (FQDN) for the Active Directory Domain Services prepared for deployment. |
| namingPrefix | Prefix used for all objects created for the Azure Local deployment. |
| adouPath | Path of the Organizational Unit (OU) created for this deployment. The OU can't be at the top level of the domain. For example: OU=Local001,DC=contoso,DC=com. |
| securityLevel | Security configuration profile to be applied to the Azure Local cluster during deployment. The default is **Recommended**. |
| driftControlEnforced | Drift control setting to reapply the security defaults regularly. <br/><br/>For more information, see [Security features for Azure Local](../concepts/security-features.md). |
| credentialGuardEnforced | Credential Guard setting that uses virtualization-based security to isolate secrets from credential-theft attacks. <br/><br/> For more information, see [Manage security defaults for Azure Local](../manage/manage-secure-baseline.md).|
| smbSigningEnforced | Setting for signing SMB traffic between this Azure Local cluster and others to help prevent relay attacks.<br/><br/>For more information, see [Overview of Server Message Block signing](/troubleshoot/windows-server/networking/overview-server-message-block-signing). |
| smbClusterEncryption | SMB cluster traffic setting for encrypting traffic between servers in the cluster on your storage network.<br/><br/>For more information, see [SMB encryption](/windows-server/storage/file-server/smb-security#smb-encryption). |
| bitlockerBootVolume | BitLocker encyrption setting for encrypting OS volume on each server.<br/><br/>For more information, see [Manage BitLocker encryption on Azure Local](../manage/manage-bitlocker.md). |
| bitlockerDataVolumes | BitLocker encryption setting for encrypting cluster shared volumes (CSVs) created on this system during deployment.<br/> <br/>For more information, see [Manage BitLocker encryption on Azure Local](../manage/manage-bitlocker.md). |
| wdacEnforced | Application Control setting to control which drivers and apps are allowed to run directly on each server.<br/><br/>For more information, see [Manage Application Control for Azure Local](../manage/manage-wdac.md). |
| streamingDataClient | Specifies whether telemetry data streaming from the Azure Local cluster to Microsoft is enabled. |
| euLocation | Specifies whether to send and store telemetry and diagnostic data within the European Union (EU). |
| episodicDataUpload | Episodic diagnostic data setting to specify whether to collect log data and upload to Microsoft to assist with troubleshooting and support.<br/><br/>For more information, see [Crash dump collection](../concepts/observability.md#crash-dump-collection). |
| configurationMode | Storage volume configuration mode. For example, Express.<br/> |
| subnetMask | The subnet mask for the management network used by the Azure Local deployment. |
| defaultGateway | The default gateway for deploying an Azure Local cluster. |
| startingIPAddress | The first IP address in a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.<br/>These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid. |
| endingIPAddress | The last IP address in a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.<br/>These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid. |
| dnsServers | List of DNS server IPs. |
| useDhcp | Indicates whether to use Dynamic Host Configuration Protocol (DHCP) for hosts and cluster IPs. If not declared, the deployment will default to static IPs. If TRUE, gateway and DNS servers are not required. |
| physicalNodesSettings | Array of physical nodes with their IP addresses. |
| networkingType | Type of networking. For example, switchedMultiServerDeployment.<br/><br/>For more information, see [Specify network settings](../deploy/deploy-via-portal.md#specify-network-settings). |
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
| clusterPattern | Supported storage type for the Azure Local cluster: <br/>- **Standard**<br/>- **RackAware** |
| localAvailabilityZones | Local Availability Zone information for the Azure Local cluster. |

## Troubleshoot deployment issues

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

**Workaround**: After the system completes the validation stage, we recommend that you don't initiate another ARM template deployment in **Validate** mode if your system is in **Deployment failed** state. Starting another deployment resets the system properties, which could result in license sync issues.

## Next steps

- [About Azure Local VM management](../manage/azure-arc-vm-management-overview.md)
- [Create Azure Local VMs enabled by Azure Arc](../manage/create-arc-virtual-machines.md)
