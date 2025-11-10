---
title: Azure Resource Manager template deployment for Azure Local, version 23H2
description: Learn how to prepare and then deploy Azure Local instance, version 23H2 using the Azure Resource Manager template.
author: alkohli
ms.topic: how-to
ms.date: 10/16/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
ms.custom:
  - devx-track-arm-template
  - sfi-image-nochange
---

# Deploy Azure Local via Azure Resource Manager deployment template

This article details how to use an Azure Resource Manager (ARM) template in the Azure portal to deploy an Azure Local in your environment. The article also contains the prerequisites and the preparation steps required to begin the deployment.

> [!IMPORTANT]
> ARM template deployment of Azure Local systems is targeted for deployments-at-scale. The intended audience for this deployment is IT administrators who have experience deploying Azure Local instances. We recommend that you deploy a system via the Azure portal first, and then perform subsequent deployments via the ARM template.

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

[!INCLUDE [create-service-principal-client-secret](../includes/create-service-principal-client-secret.md)]

::: moniker-end

[!INCLUDE [get-object-id-azure-local-resource-provider](../includes/get-object-id-azure-local-resource-provider.md)]

You use the **Object ID** against the `hciResourceProviderObjectID` parameter in the ARM template.

## Step 2: Deploy using ARM template

An ARM template creates and assigns all the resource permissions required for deployment.

With all the prerequisite and preparation steps complete, you're ready to deploy using a known good and tested ARM deployment template and corresponding parameters JSON file. Use the parameters contained in the JSON file to fill out all values, including the values generated previously.

For an example of a parameter JSON file, see [azuredeploy.parameters.json](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster/azuredeploy.parameters.json). For detailed descriptions of the parameters defined in this file, see [ARM template parameters reference](#arm-template-parameters-reference).

> [!IMPORTANT]
> Ensure that all parameters in the JSON file are filled out, including placeholders that appear as `[“”]`, which indicate that the parameter expects an array structure. Replace these with actual values based on your deployment environment, or validation will fail.

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

15. Verify that all the fields for the ARM deployment template are filled in by the Parameters JSON.

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

## ARM template parameters reference

[!INCLUDE [template-parameter-table](../includes/template-parameter-table.md)]

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
