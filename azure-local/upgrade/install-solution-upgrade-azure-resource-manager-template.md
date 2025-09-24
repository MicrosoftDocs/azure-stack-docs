---
title: Install solution upgrade on Azure Local using Azure Resource Manager template
description: Learn how to install the solution upgrade on your Azure Local instance using Azure Resource Manager template.
author: alkohli
ms.topic: how-to
ms.date: 09/24/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---


# Install solution upgrade on Azure Local using Azure Resource Manager template

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

This article describes how to install the solution upgrade on your Azure Local instance using Azure Resource Manager (ARM) template, after upgrading the operating system (OS) build from 20349.xxxx (22H2) to 25398.xxxx (23H2).

> [!IMPORTANT]
> - While the OS upgrade is generally available, the solution upgrade is rolled out in phases. Additionally, the solution upgrade isn't available to customers in Azure China.
> - Installing solution upgrade using ARM template is targeted for at-scale upgrades. This method is intended for IT administrators who have experience managing Azure Local instances. We recommend that you upgrade a system via the Azure portal first, and then use ARM template for subsequent upgrades. To install the solution upgrade via the Azure portal, see [Install solution upgrade on Azure Local](./install-solution-upgrade.md).

## About End of Support (EOS) for version 22H2

[!INCLUDE [end-of-service-22H2](../includes/end-of-service-22h2.md)]

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

- Microsoft supports upgrade applied from Azure Local resource page or by using an ARM template. Use of third-party tools to install upgrades isn't supported.
- We recommend you perform the solution upgrade during a maintenance window. After the upgrade, host machine might reboot and the workloads will be live migrated, causing brief disconnections.
<!--Confirm if this point is valid for ARM upgrade- If you have Azure Kubernetes Service (AKS) workloads on Azure Local, wait for the solution upgrade banner to appear on the Azure Local resource page. Then, remove AKS and all AKS hybrid settings before you apply the solution upgrade.-->
- By installing the solution upgrade, existing unmanaged VMs won't automatically become Azure Arc VMs. For more information about VMs on Azure Local, see [Types of VMs on Azure Local](../concepts/compare-vm-management-capabilities.md#types-of-vms-on-azure-local).

## Step 1: Prepare Azure resources

Follow these steps to prepare the Azure resources you need for the upgrade:

::: moniker range="<=azloc-24113"

[!INCLUDE [create-service-principal-and-client-secret](../includes/create-service-principal-and-client-secret.md)]

::: moniker-end

[!INCLUDE [get-object-id-azure-local-resource-provider](../includes/get-object-id-azure-local-resource-provider.md)]

## Step 2: Install the solution upgrade using Azure Resource Manager template

An ARM template creates and assigns all the resource permissions required for the upgrade.
With all the prerequisite and preparation steps complete, you're ready to upgrade using a known good and tested ARM template and corresponding parameters JSON file. Use the parameters contained in the JSON file to fill out all values, including the values generated previously.
For an example of a parameter JSON file, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/upgrade-cluster/azuredeploy.parameters.json). For detailed descriptions of the parameters defined in this file, see [ARM template parameters reference](#arm-template-parameters-reference).
> [!IMPORTANT]
> Ensure that all parameters in the JSON file are filled out, including placeholders that appear as `[“”]`, which indicate that the parameter expects an array structure. Replace these with actual values based on your deployment environment, or validation will fail.

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

7. Edit parameters. Once the parameters are all filled out, **Save** the parameters file.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/edit-parameters-file.png" alt-text="Screenshot showing parameters filled out for the template." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/edit-parameters-file.png":::

8. Select the appropriate resource group for your environment.

9. Confirm that **Deployment Mode = Validate**.

10. Select **Review + create**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-review-create.png" alt-text="Screenshot showing Review + Create selected on Basics tab." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-review-create.png":::

11. On the **Review + Create** tab, select **Create**. This creates the remaining prerequisite resources and validates the upgrade. Validation takes about 10 minutes to complete.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-create.png" alt-text="Screenshot showing Create selected on Review + Create tab." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-create.png":::

12. Once validation is complete, select **Redeploy**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-redeploy.png" alt-text="Screenshot showing Redeploy selected." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-redeploy.png":::

13. On the **Custom deployment** screen, select **Edit parameters**. Load up the previously saved parameters and select **Save**.

14. Change the final value in the JSON from **Validate** to **Deploy**, where **Deployment Mode = Deploy**.

    :::image type="content" source="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-deploy.png" alt-text="Screenshot showing deploy selected for deployment mode." lightbox="./media/install-solution-upgrade-azure-resource-manager-template/deploy-arm-template-deploy.png":::

15. Verify that all the fields for the ARM template are filled in by the parameters JSON.

16. Select the appropriate resource group for your environment.

17. Confirm that **Deployment Mode = Deploy**.

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
| createNewKeyVault | Specifies whether the template should create a new Key Vault or use an existing one. Set this value as false if you are reusing an existing Key Vault. |
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
| arcNodeResourceIds | Array of resource IDs of the Azure Arc-enabled servers that are part of this Azure Local cluster. |
| domainFqdn | Fully-qualified domain name (FQDN) for the Active Directory Domain Services prepared for deployment. |
| subnetMask | The subnet mask for the management network used by the Azure Local deployment. |
| defaultGateway | The default gateway for deploying an Azure Local cluster. |
| startingIPAddress | The first IP address in a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.<br/>These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid. |
| endingIPAddress | The last IP address in a contiguous block of at least six static IP addresses on your management network's subnet, omitting addresses already used by the machines.<br/>These IPs are used by Azure Local and internal infrastructure (Arc Resource Bridge) that's required for Arc VM management and AKS Hybrid. |
| dnsServers | List of DNS server IPs. |
| physicalNodesSettings | Array of physical nodes with their IP addresses. |
| customLocation | Custom location for deployment. |

## Next steps

If you run into issues during the upgrade process, see [Troubleshoot solution upgrade on Azure Local](./troubleshoot-upgrade-to-23h2.md).
