---
title: Install solution upgrade on Azure Local using Azure Resource Manager template
description: Learn how to install the solution upgrade on your Azure Local instance using Azure Resource Manager template.
author: alkohli
ms.topic: how-to
ms.date: 07/16/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---


# Install solution upgrade on Azure Local using Azure Resource Manager template

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

This article describes how to install the solution upgrade on your Azure Local instance using Azure Resource Manager (ARM) template after upgrading the operating system (OS) from version 22H2 to version 23H2.

> [!IMPORTANT]
> While the OS upgrade is generally available, the solution upgrade is rolled out in phases. Additionally, the solution upgrade isn't available to customers in Azure China.

To install the solution upgrade via the Azure portal, see [Install solution upgrade on Azure Local](./install-solution-upgrade.md).

## Prerequisites

Before you install the solution upgrade, make sure that you:

- Validate the system using the Environment Checker as per the instructions in [Assess solution upgrade readiness](./validate-solution-upgrade-readiness.md#run-the-validation).
- Have failover cluster name between 3 to 15 characters.
- Create an Active Directory Lifecycle Manager (LCM) user account that's a member of the local Administrator group. For instructions, see [Prepare Active Directory for Azure Local deployment](../deploy/deployment-prep-active-directory.md).
- Have IPv4 network range that matches your host IP address subnet with six, contiguous IP addresses available for new Azure Arc services. Work with your network administrator to ensure that the IP addresses aren't in use and meet the outbound connectivity requirement.
- Have Azure subscription permissions for [Azure Stack HCI Administrator and Reader](../manage/assign-vm-rbac-roles.md#about-built-in-rbac-roles).  

    :::image type="content" source="media/install-solution-upgrade-azure-resource-manager-template/verify-subscription-permissions-roles.png" alt-text="Screenshot of subscription with permissions assigned to required roles for upgrade." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/verify-subscription-permissions-roles.png":::

::: moniker range="<=azloc-24113"

- For Azure Local 2411.3 and earlier versions, make sure to select the **upgrade-cluster-2411.3** template for upgrade.

::: moniker-end

::: moniker range=">=azloc-2503"

- For Azure Local 2503 and later versions, make sure to select the **upgrade-cluster** template for upgrade.

::: moniker-end

## Before you begin

There are a few things to consider before you begin the solution upgrade process:

- The solution upgrade isn't yet supported on OS version 26100.xxxx.
<!--Confirm if this point is valid for ARM upgrade-- Microsoft only supports upgrade applied from Azure Local resource page. Use of third party tools to install upgrades isn't supported.-->
- We recommend you perform the solution upgrade during a maintenance window. After the upgrade, host machine might reboot and the workloads will be live migrated, causing brief disconnections.
<!--Confirm if this point is valid for ARM upgrade- If you have Azure Kubernetes Service (AKS) workloads on Azure Local, wait for the solution upgrade banner to appear on the Azure Local resource page. Then, remove AKS and all AKS hybrid settings before you apply the solution upgrade.-->
- By installing the solution upgrade, existing Hyper-V VMs won't automatically become Azure Arc VMs.

## Step 1: Prepare Azure resources

Follow these steps to prepare the Azure resources you need for the upgrade:

::: moniker range="<=azloc-24113"

### Create a service principal and client secret

To authenticate your system, you need to create a service principal and a corresponding **Client secret** for Arc Resource Bridge (ARB).

### Create a service principal for ARB

Follow the steps in [Create a Microsoft Entra application and service principal that can access resources via Azure portal](/entra/identity-platform/howto-create-service-principal-portal) to create the service principal and assign the roles. Alternatively, use the PowerShell procedure to [Create an Azure service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps).

The steps are also summarized here:

1. Sign in to the [Microsoft Entra admin center](https://entra.microsoft.com/) as at least a Cloud Application Administrator. Browse to **Identity > Applications > App registrations** then select **New registration**.

1. Provide a **Name** for the application, select a **Supported account type**, and then select **Register**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/create-service-principal-register.png" alt-text="Screenshot showing Register an application for service principal creation." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/create-service-principal-register.png":::

1. Once the service principal is created, go to the **Enterprise applications** page. Search for and select the SPN you created.

   :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/create-service-principal-search.png" alt-text="Screenshot showing search results for the service principal created." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/create-service-principal-search.png":::

1. Under properties, copy the **Application (client) ID**  and the **Object ID** for this service principal.

   :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/create-service-principal-id.png" alt-text="Screenshot showing Application (client) ID and the object ID for the service principal created." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/create-service-principal-id.png":::

    You use the **Application (client) ID** against the `arbDeploymentAppID` parameter and the **Object ID** against the `arbDeploymentSPNObjectID` parameter in the Resource Manager template.

### Create a client secret for ARB service principal

1. Go to the application registration that you created and browse to **Certificates & secrets > Client secrets**.
1. Select **+ New client** secret.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/create-client-secret-new.png" alt-text="Screenshot showing creation of a new client secret." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/create-client-secret-new.png":::

1. Add a **Description** for the client secret and provide a timeframe when it **Expires**. Select **Add**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/create-client-secret-add.png" alt-text="Screenshot showing Add a client secret blade." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/create-client-secret-add.png":::

1. Copy the **client secret value** as you use it later.

    > [!Note]
    > For the application client ID, you will need it's secret value. Client secret values can't be viewed except for immediately after creation. Be sure to save this value when created before leaving the page.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/create-client-secret-value.png" alt-text="Screenshot showing client secret value." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/create-client-secret-value.png":::

    You use the **client secret value** against the `arbDeploymentAppSecret` parameter in the Resource Manager template.

::: moniker-end

### Get the object ID for Azure Local Resource Provider

This object ID for the Azure Local Resource Provide (RP) is unique per Azure tenant.

1. In the Azure portal, search for and go to Microsoft Entra ID.  
1. Go to the **Overview** tab and search for *Microsoft.AzureStackHCI Resource Provider*.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/search-azure-stackhci-resource-provider-overview.png" alt-text="Screenshot showing the search for the Azure Local Resource Provider service principal." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/search-azure-stackhci-resource-provider-overview.png":::

1. Select the Service Principal Name that is listed and copy the **Object ID**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/get-azure-stackhci-object-id.png" alt-text="Screenshot showing the object ID for the Azure Local Resource Provider service principal." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/get-azure-stackhci-object-id.png":::

    Alternatively, you can use PowerShell to get the object ID of the Azure Local RP service principal. Run the following command in PowerShell:

    ```powershell
    Get-AzADServicePrincipal -DisplayName "Microsoft.AzureStackHCI Resource Provider"
    ```

    You use the **Object ID** against the `hciResourceProviderObjectID` parameter in the Resource Manager template.

## Install the solution upgrade using Azure Resource Manager template

Follow these steps to install the solution upgrade:

1. In the Azure portal, go to **Home** and select **+ Create a resource**.

2. Select **Create** under **Template deployment (deploy using custom templates)**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template.png" alt-text="Screenshot showing the template deployment (deploy using custom template)." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template.png":::

3. From the **Start with a quickstart template or template spec** section, select **Quickstart template** option.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-quickstart.png" alt-text="Screenshot showing the quickstart template selected." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-quickstart.png":::

::: moniker range="<=azloc-24113"

4. From the **Quickstart template (disclaimer)** dropdown list, select the **azurestackhci/upgrade-cluster-2411.3** template.

5. When finished, select the **Select template** button.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-cluster-24113-arm-template.png" alt-text="Screenshot showing the upgrade-cluster-2411.3 template selected for the solution upgrade." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-cluster-24113-arm-template.png":::

6. On the **Basics** tab, you see the **Custom deployment** page. You can select the various parameters through the dropdown lists or select **Edit parameters**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-cluster-24113-arm-template-parameters.png" alt-text="Screenshot showing Custom deployment page on the Basics tab for the upgrade-cluster-2411.3 template." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-cluster-24113-arm-template-parameters.png":::

    > [!NOTE]
    > For an example parameter file that shows the format of various inputs, such as `ArcNodeResourceId`, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/upgrade-cluster-2411.3/azuredeploy.parameters.json).

::: moniker-end

::: moniker range=">=azloc-2503"

4. From the **Quickstart template (disclaimer)** dropdown list, select the **azurestackhci/upgrade-cluster** template.

5. When finished, select the **Select template** button.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-cluster-arm-template.png" alt-text="Screenshot showing template selected for the solution upgrade." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-cluster-arm-template.png":::

6. On the **Basics** tab, you see the **Custom deployment** page. You can select the various parameters through the dropdown lists or select **Edit parameters**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-cluster-template-parameters.png" alt-text="Screenshot showing Custom deployment page on the Basics tab." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/upgrade-cluster-template-parameters.png":::

    > [!NOTE]
    > For an example parameter file that shows the format of various inputs, such as `ArcNodeResourceId`, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/upgrade-cluster/azuredeploy.parameters.json).

::: moniker-end

7. Edit parameters such as network intent or storage network intent. Once the parameters are all filled out, **Save** the parameters file.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/edit-parameters-file.png" alt-text="Screenshot showing parameters filled out for the template." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/edit-parameters-file.png":::

8. Select the appropriate resource group for your environment.

9. Confirm that **Deployment Mode = Validate**.

10. Select **Review + create**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-review-create.png" alt-text="Screenshot showing Review + Create selected on Basics tab." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-review-create.png":::

11. On the **Review + Create** tab, select **Create**. This creates the remaining prerequisite resources and validates the deployment. Validation takes about 10 minutes to complete.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-create.png" alt-text="Screenshot showing Create selected on Review + Create tab." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-create.png":::

12. Once validation is complete, select **Redeploy**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-redeploy.png" alt-text="Screenshot showing Redeploy selected." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-redeploy.png":::

13. On the **Custom deployment** screen, select **Edit parameters**. Load up the previously saved parameters and select **Save**.

14. At the bottom of the workspace, change the final value in the JSON from **Validate** to **Deploy**, where **Deployment Mode = Deploy**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-deploy.png" alt-text="Screenshot showing deploy selected for deployment mode." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-deploy.png":::

15. Verify that all the fields for the Resource Manager deployment template are filled in by the Parameters JSON.

16. Select the appropriate resource group for your environment.

17. Scroll to the bottom, and confirm that **Deployment Mode = Deploy**.

18. Select **Review + create**.

19. Select **Create**. The upgrade begins, using the existing prerequisite resources that were created during the **Validate** step.

    The Deployment screen cycles on the cluster resource during upgrade.

    Once the upgrade initiates, there's a limited Environment Checker run, a full Environment Checker run, and cloud upgrade starts. After a few minutes, you can monitor upgrade in the portal.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-environment-checker.png" alt-text="Screenshot showing the status of environment checker validation." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-environment-checker.png":::

20. In a new browser window, navigate to the resource group for your environment. Select the cluster resource.

21. Select **Deployments**.

22. Refresh and watch the deployment progress from the first machine (also known as the seed machine and is the first machine where you deployed the cluster). Deployment takes between 2.5 and 3 hours. Several steps take 40-50 minutes or more.

## ARM template parameters reference

The following table describes the parameters that you define in the ARM template's parameters file:

| Parameter | Description |
|--|--|
| deploymentMode | Determines if the upgrade process should only validate or proceed with full upgrade:<br/>- **Validate**: Validates your system's readiness to upgrade.<br/>- **Deploy**: Performs the actual upgrade after successful validation. |
| keyVaultName | Name of the Azure Key Vault to be used for storing secrets.<br/>For naming conventions, see [Microsoft.KeyVault](/azure/azure-resource-manager/management/resource-name-rules#microsoftkeyvault) in the Naming rules and restrictions for Azure resources article. |
| softDeleteRetentionDays | Number of days that deleted items (such as secrets, keys, or certificates) are retained in an Azure Key Vault before they are permanently deleted.<br/>Specify a value between 7 and 90 days. You can’t change the retention period later. |
| diagnosticStorageAccountName | Name of the Azure Storage Account used to store key vault audit logs. This account is a locally redundant storage (LRS) account with a lock. <br/>For more information, see [Azure Storage Account](/azure/storage/common/storage-account-create?tabs=azure-portal). For naming conventions, see [Azure Storage account names](/azure/storage/common/storage-account-overview#storage-account-name).|
| logsRetentionInDays | Number of days that logs are retained. <br/> If you don't want to apply any retention policy and retain data forever, specify 0. |
| storageAccountType | Type of the Azure Storage Account to be used in the deployment. For example, Standard_LRS. |
| clusterName | Name of the Azure Local instance being deployed.<br/> This is the name that represents your cluster on cloud. It must be different from any of the node names. |
| failoverClusterName | |
| location | Deployment location, typically derived from the resource group.  <br/>For a list of supported Azure regions, see [Azure requirements](../concepts/system-requirements-23h2.md?tabs=azure-public#azure-requirements). |
| tenantId | Azure subscription tenant ID. <br/>For more information, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id#find-your-microsoft-entra-tenant).|
| AzureStackLCMAdminUsername | Username for the LCM admin.<br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md).|
| AzureStackLCMAdminPasssword | Password for the LCM admin. <br/> For more information, see [Review deployment prerequisites for Azure Local](../deploy/deployment-prerequisites.md).|
| hciResourceProviderObjectID | |
| arcNodeResourceIds | Array of resource IDs of the Azure Arc-enabled servers that are part of this Azure Local cluster. |
| domainFqdn | Fully-qualified domain name (FQDN) for the Active Directory Domain Services prepared for deployment. |
| adouPath | Path of the Organizational Unit (OU) created for this deployment. The OU can't be at the top level of the domain. For example: OU=Local001,DC=contoso,DC=com. |
| securityLevel | Security configuration profile to be applied to the Azure Local cluster during deployment. The default is **Recommended**. |
| subnetMask | The subnet mask for the management network used by the Azure Local deployment. |
| defaultGateway | The default gateway for deploying an Azure Local cluster. |
| startingIPAddress | The first IP address in a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.<br/>These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid. |
| endingIPAddress | The last IP address in a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.<br/>These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid. |
| dnsServers | List of DNS server IPs. |
| physicalNodesSettings | Array of physical nodes with their IP addresses. |
| customLocation | Custom location for deployment. |

## Next steps

If you run into issues during the upgrade process, see [Troubleshoot solution upgrade on Azure Local](./troubleshoot-upgrade-to-23h2.md).
