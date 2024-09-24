---
title: Azure Resource Manager template deployment for Azure Stack HCI, version 23H2
description: Learn how to prepare and then deploy Azure Stack HCI, version 23H2 using the Azure Resource Manager template.
author: alkohli
ms.topic: how-to
ms.date: 06/04/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
ms.custom: devx-track-arm-template
---

# Deploy an Azure Stack HCI, version 23H2 via Azure Resource Manager deployment template

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article details how to use an Azure Resource Manager template in the Azure portal to deploy an Azure Stack HCI in your environment. The article also contains the prerequisites and the preparation steps required to begin the deployment.

> [!IMPORTANT]
> Azure Resource Manager template deployment of Azure Stack HCI, version 23H2 systems is targeted for deployments-at-scale. The intended audience for this deployment is IT administrators who have experience deploying Azure Stack HCI clusters. We recommend that you deploy a version 23H2 system via the Azure portal first, and then perform subsequent deployments via the Resource Manager template.

## Prerequisites

- Completion of [Register your servers with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md). Make sure that:
  - All the mandatory extensions are installed successfully. The mandatory extensions include: **Azure Edge Lifecycle Manager**, **Azure Edge Device Management**, **Telemetry and Diagnostics**, and **Azure Edge Remote Support**.
  - All servers are running the same version of OS.
  - All the servers have the same network adapter configuration.

## Step 1: Prepare Azure resources

Follow these steps to prepare the Azure resources you need for the deployment:

### Create a service principal and client secret

To authenticate your cluster, you need to create a service principal and a corresponding **Client secret** for Arc Resource Bridge (ARB).

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

### Get the object ID for Azure Stack HCI Resource Provider

This object ID for the Azure Stack HCI RP is unique per Azure tenant.

1. In the Azure portal, search for and go to Microsoft Entra ID.  
1. Go to the **Overview** tab and search for *Microsoft.AzureStackHCI Resource Provider*.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/search-azure-stackhci-resource-provider-1a.png" alt-text="Screenshot showing the search for the Azure Stack HCI Resource Provider service principal." lightbox="./media/deployment-azure-resource-manager-template/search-azure-stackhci-resource-provider-1a.png":::

1. Select the SPN that is listed and copy the **Object ID**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/get-azure-stackhci-object-id-1a.png" alt-text="Screenshot showing the object ID for the Azure Stack HCI Resource Provider service principal." lightbox="./media/deployment-azure-resource-manager-template/get-azure-stackhci-object-id-1a.png":::

    Alternatively, you can use PowerShell to get the object ID of the Azure Stack HCI RP service principal. Run the following command in PowerShell:

    ```powershell
    Get-AzADServicePrincipal -DisplayName "Microsoft.AzureStackHCI Resource Provider"
    ```

    You use the **Object ID** against the `hciResourceProviderObjectID` parameter in the Resource Manager template.

## Step 2: Deploy using Azure Resource Manager template

A Resource Manager template creates and assigns all the resource permissions required for deployment.

With all the prerequisite and preparation steps complete, you're ready to deploy using a known good and tested Resource Manager deployment template and corresponding parameters JSON file. Use the parameters contained in the JSON file to fill out all values, including the values generated previously.

> [!IMPORTANT]
> In this release, make sure that all the parameters contained in the JSON value are filled out including the ones that have a null value. If there are null values, then those need to be populated or the validation fails.

1. In the Azure portal, go to **Home** and select **+ Create a resource**.

1. Select **Create** under **Template deployment (deploy using custom templates)**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png" alt-text="Screenshot showing the template deployment (deploy using custom template)." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png":::

1. Near the bottom of the page, find **Start with a quickstart template or template spec** section. Select **Quickstart template** option.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-2.png" alt-text="Screenshot showing the quickstart template selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-2.png":::

1. Use the **Quickstart template (disclaimer)** field to filter for the appropriate template. Type *azurestackhci/create-cluster* for the filter.

1. When finished, **Select template**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-3a.png" alt-text="Screenshot showing template selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-3a.png":::

1. On the **Basics** tab, you see the **Custom deployment** page. You can select the various parameters through the dropdown list or select **Edit parameters**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-4a.png" alt-text="Screenshot showing Custom deployment page on the Basics tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-4a.png":::

1. Edit parameters such as network intent or storage network intent. Once the parameters are all filled out, **Save** the parameters file.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-5.png" alt-text="Screenshot showing parameters filled out for the template." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-5.png":::

1. Select the appropriate resource group for your environment.

1. Scroll to the bottom, and confirm that **Deployment Mode = Validate**.

1. Select **Review + create**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-6.png" alt-text="Screenshot showing Review + Create selected on Basics tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-6.png":::

1. On the **Review + Create** tab, select **Create**. This creates the remaining prerequisite resources and validates the deployment. Validation takes about 10 minutes to complete.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7.png" alt-text="Screenshot showing Create selected on Review + Create tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7.png":::

1. Once validation is complete, select **Redeploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png" alt-text="Screenshot showing Redeploy selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png":::

1. On the **Custom deployment** screen, select **Edit parameters**. Load up the previously saved parameters and select **Save**.

1. At the bottom of the workspace, change the final value in the JSON from **Validate** to **Deploy**, where **Deployment Mode = Deploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png" alt-text="Screenshot showing deploy selected for deployment mode." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png":::

1. Verify that all the fields for the Resource Manager deployment template are filled in by the Parameters JSON.

1. Select the appropriate resource group for your environment.

1. Scroll to the bottom, and confirm that **Deployment Mode = Deploy**.

1. Select **Review + create**.

1. Select **Create**. The deployment begins, using the existing prerequisite resources that were created during the **Validate** step.

    The Deployment screen cycles on the Cluster resource during deployment.

    Once deployment initiates, there's a limited Environment Checker run, a full Environment Checker run, and cloud deployment starts. After a few minutes, you can monitor deployment in the portal.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png" alt-text="Screenshot showing the status of environment checker validation." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png":::

1. In a new browser window, navigate to the resource group for your environment. Select the cluster resource.

1. Select **Deployments**.

1. Refresh and watch the deployment progress from the first server (also known as the seed server and is the first server where you deployed the cluster). Deployment takes between 2.5 and 3 hours. Several steps take 40-50 minutes or more.

1. The step in deployment that takes the longest is **Deploy Moc and ARB Stack**. This step takes 40-45 minutes.

    Once complete, the task at the top updates with status and end time.

You can also check out this community sourced template to [Deploy an Azure Stack HCI, version 23H2 cluster using Bicep](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-with-prereqs/README.md).

## Troubleshoot deployment issues

If the deployment fails, you should see an error message on the deployments page.

1. On the **Deployment details**, select the **error details**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/select-view-error-details-1.png" alt-text="Screenshot showing the selection of error details." lightbox="./media/deployment-azure-resource-manager-template/select-view-error-details-1.png":::

2. Copy the error message from the **Errors** blade. You can provide this error message to Microsoft support for further assistance.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/select-view-error-details-2.png" alt-text="Screenshot showing the summary in the Errors blade." lightbox="./media/deployment-azure-resource-manager-template/select-view-error-details-2.png":::

### Known issues for ARM template deployment

This section contains known issues and workarounds for ARM template deployment.

<!--|Issue|Workaround/Comments|
|------|-------|
|In this release, you may see *Role assignment already exists* error. This error occurs if the Azure Stack HCI cluster deployment was attempted from the portal first and the same resource group was used for ARM template deployment.<br><br>You see this error on the **Overview > Deployment details** page for the applicable resource. <br><br>This error indicates that an equivalent role assignment was already done by another identity for the same resource group scope and the ARM template deployment is unable to perform role assignment.| Although these errors can be disregarded and deployment can proceed via the ARM template, we strongly recommend that you don't interchange deployment modes between the portal and ARM template.|
|Role assignment fails with error *Tenant ID, application ID, principal ID, and scope aren't allowed to be updated.* <br><br>You see this error on the **Overview > Deployment details** page for the applicable resource. <br><br>This error could show up when there are zombie role assignments in the same resource group. For example, when a prior deployment was performed and the resources corresponding to that deployment were deleted but the role assignment resources were left around.| To identify the zombie role assignments, go to **Access control (IAM) > Role assignments > Type : Unknown** tab. These assignments are listed as **Identity not found. Unable to find identity.* Delete such role assignments and then retry ARM template deployment.|
|In this release, you may encounter license sync issue when using ARM template deployment. |After the cluster completes the validation stage, we recommend that you don't initiate another ARM template deployment in **Validate** mode if your cluster is in **Deployment failed** state. Starting another deployment resets the cluster properties, which could result in license sync issues. |-->

#### Role assignment already exists

**Issue**: In this release, you may see *Role assignment already exists* error. This error occurs if the Azure Stack HCI cluster deployment was attempted from the portal first and the same resource group was used for ARM template deployment. You see this error on the **Overview > Deployment details** page for the applicable resource. This error indicates that an equivalent role assignment was already done by another identity for the same resource group scope and the ARM template deployment is unable to perform role assignment.

:::image type="content" source="./media/deployment-azure-resource-manager-template/error-role-assignment-already-exists-1.png" alt-text="Screenshot showing the role assignment exists message in the Errors blade." lightbox="./media/deployment-azure-resource-manager-template/error-role-assignment-already-exists-1.png":::

**Workaround**: Although these errors can be disregarded and deployment can proceed via the ARM template, we strongly recommend that you don't interchange deployment modes between the portal and ARM template.

#### Tenant ID, application ID, principal ID, and scope aren't allowed to be updated

**Issue**: Role assignment fails with error *Tenant ID, application ID, principal ID, and scope aren't allowed to be updated*. You see this error on the **Overview > Deployment details** page for the applicable resource. This error could show up when there are zombie role assignments in the same resource group. For example, when a prior deployment was performed and the resources corresponding to that deployment were deleted but the role assignment resources were left around.

:::image type="content" source="./media/deployment-azure-resource-manager-template/error-tenantid-applicationid-principalid-not-allowed-to-update-1.png" alt-text="Screenshot showing the tenant ID, application ID, principal ID, and scope can't be updated message in the Errors blade." lightbox="./media/deployment-azure-resource-manager-template/error-tenantid-applicationid-principalid-not-allowed-to-update-1.png":::

**Workaround**: To identify the zombie role assignments, go to **Access control (IAM) > Role assignments > Type : Unknown** tab. These assignments are listed as **Identity not found. Unable to find identity.* Delete such role assignments and then retry ARM template deployment.

:::image type="content" source="./media/deployment-azure-resource-manager-template/error-identity-not-found-1.png" alt-text="Screenshot showing the identity not found message in the Errors blade." lightbox="./media/deployment-azure-resource-manager-template/error-identity-not-found-1.png":::

#### License sync issue

**Issue**: In this release, you may encounter license sync issue when using ARM template deployment.

**Workaround**: After the cluster completes the validation stage, we recommend that you don't initiate another ARM template deployment in **Validate** mode if your cluster is in **Deployment failed** state. Starting another deployment resets the cluster properties, which could result in license sync issues.

## Next steps

- [About Arc VM management](../manage/azure-arc-vm-management-overview.md)
- [Deploy Azure Arc VMs on Azure Stack HCI](../manage/create-arc-virtual-machines.md)
