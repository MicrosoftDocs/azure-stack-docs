---
title: Azure Resource Manager template deployment for Azure Stack HCI, version 23H2
description: Learn how to prepare and then deploy Azure Stack HCI, version 23H2 using the Azure Resource Manager template.
author: alkohli
ms.topic: how-to
ms.date: 01/31/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
ms.custom: devx-track-arm-template
---

# Deploy an Azure Stack HCI, version 23H2 via Azure Resource Manager deployment template

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article details how to use an Azure Resource Manager template (ARM template) in the Azure portal to deploy an Azure Stack HCI in your environment. The article also contains the prerequisites and the preparation steps required to begin the deployment.

> [!IMPORTANT]
> ARM template deployment of Azure Stack HCI, version 23H2 systems is targeted for deployments-at-scale. The intended audience for this deployment are IT Administrators who have experience deploying Azure Stack HCI clusters. We recommend that you deploy a version 23H2 system via the Azure portal first and then perform subsequent deployments via the ARM template.

## Prerequisites

- Completion of [Register your servers with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md). Make sure that:
    - All the mandatory extensions have installed successfully. The mandatory extensions include: **Azure Edge Lifecycle Manager**, **Azure Edge Device Management**, and **Telemetry and Diagnostics**.
    - All servers are running the same version of OS.
    - All the servers have the same network adapter configuration.


## Step 1: Prepare Azure resources

Follow these steps to prepare the Azure resources you need for the deployment:

### Create a service principal and client secret

To authenticate your cluster, you need to create a service principal and a corresponding **Client secret**. You must also assign *Azure Resource Bridge Deployment Role* to the service principal.


#### Create a service principal

Follow the steps in [Create a Microsoft Entra application and service principal that can access resources via Azure portal](/entra/identity-platform/howto-create-service-principal-portal) to create the service principal and assign the roles. Alternatively, use the PowerShell procedure to [Create an Azure service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps).

The steps are also summarized here:

1. Sign in to the [Microsoft Entra admin center](https://entra.microsoft.com/) as at least a Cloud Application Administrator. Browse to **Identity > Applications > App registrations** then select **New registration**.

1. Provide a **Name** for the application, select a **Supported account type** and then select **Register**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/create-service-principal-1.png" alt-text="Screenshot showing Register an application for service principal creation." lightbox="./media/deployment-azure-resource-manager-template/create-service-principal-1.png":::

1. Once the service principal is created, go to the **Overview** page. Copy the **Application (client) ID** for this service principal. You encode and use this value later.

   :::image type="content" source="./media/deployment-azure-resource-manager-template/create-service-principal-2.png" alt-text="Screenshot showing Application (client) ID for the service principal created." lightbox="./media/deployment-azure-resource-manager-template/create-service-principal-2.png":::

#### Create a client secret

1. Go to the service principal that you created and browse to **Certificates & secrets > Client secrets**.
1. Select **+ New client** secret.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/create-client-secret-1.png" alt-text="Screenshot showing creation of a new client secret." lightbox="./media/deployment-azure-resource-manager-template/create-client-secret-1.png":::

1. Add a **Description** for the client secret and provide a timeframe when it **Expires**. Select **Add**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/create-client-secret-2.png" alt-text="Screenshot showing Add a client secret blade." lightbox="./media/deployment-azure-resource-manager-template/create-client-secret-2.png":::

1. Copy the **client secret value** as you encode and use it later.

    > [!Note]
    > For the application client ID, you will need it's secret value. Client secret values can't be viewed except for immediately after creation. Be sure to save this value when created before leaving the page.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/create-client-secret-3.png" alt-text="Screenshot showing client secret value." lightbox="./media/deployment-azure-resource-manager-template/create-client-secret-3.png":::


### Create a cloud witness storage account

First, create a storage account to serve as a cloud witness. You then need to get the access key for this storage account, and then use it in an encoded format with the ARM deployment template.

Follow these steps to get and encode the access key for the ARM deployment template:

1. In the Azure portal, create a storage account in the same resource group that you would use for deployment. 

    :::image type="content" source="./media/deployment-azure-resource-manager-template/cloud-witness-storage-account-1.png" alt-text="Screenshot showing creation of storage account for cloud witness." lightbox="./media/deployment-azure-resource-manager-template/cloud-witness-storage-account-1.png":::

1. Once the Storage account is created, verify that you can see the account in the resource group.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/cloud-witness-storage-account-6.png" alt-text="Screenshot showing storage account for cloud witness in the deployment resource group." lightbox="./media/deployment-azure-resource-manager-template/cloud-witness-storage-account-6.png":::
 
1. Go to the storage account that you created and then go to **Access keys**.

1. For **key1, Key**, select **Show**. Select the **Copy to clipboard** button at the right side of the **Key** field.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/cloud-witness-storage-account-access-key-1.png" alt-text="Screenshot showing the access keys for the cloud witness storage account." lightbox="./media/deployment-azure-resource-manager-template/cloud-witness-storage-account-access-key-1.png":::

    After you copy the key, select **Hide**.


### Encode parameter values

1. On a management computer, run PowerShell as administrator. Encode the copied **Key** value string with the following script:

    ```PowerShell
    $secret="<Key value string coped earlier>" 
    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($secret))
    ```

    The encoded output looks similar to this, and is based on the secret value for the cloud witness storage account for your environment:

    ```PowerShell
    ZXhhbXBsZXNlY3JldGtleXZhbHVldGhhdHdpbGxiZWxvbmdlcnRoYW50aGlzYW5kb3V0cHV0d2lsbGxvb2tkaWZmZXJlbnQ= 
    ```

1. The encoded output value you generate is what the ARM deployment template expects. Make a note of this value and the name of the storage account. You'll use these values later in the deployment process.

In addition to the storage witness access key, you also need to similarly encode the values for the following parameters.

|Parameter  |Description  |
|---------|---------|
|`localaccountname`, `localaccountpassword`     |Username and password for the local administrator for all the servers in your cluster. The credentials are identical for all the servers in your system.         |
|`domainaccountname`, `domainaccountpassword`      |The new username and password that were created with the appropriate permissions for deployment during the Active Directory preparation step for the `AzureStackLCMUserCredential` object. This account is the same as the user account used by the Azure Stack HCI deployment. <br> For more information, see [Prepare the Active Directory](./deployment-prep-active-directory.md#prepare-active-directory) to get these credentials.        |
|`clientId`, `clientSecretValue`       |The application (client) ID for the SPN that you created as a prerequisite to this deployment and the corresponding client secret value for the application ID.          |

Run the PowerShell script used in the earlier step to encode these values:

- **Local account password**. This corresponds to the `localAdminSecretValue` in the parameters JSON. Encode `localaccountname:localacountpassword` to get this value for the template.
- **Domain account password**. This corresponds to the `domainAdminSecretValue` in the parameters JSON. Encode `domainaccountname:domainaccountpassword` to get this value for the template.
- **Application client ID secret value**. This corresponds to the `arbDeploymentSpnValue` in the parameters JSON. Encode `clientId:clientSecretValue` to get this value for the template.


## Step 2: Assign resource permissions

You need to create and assign the needed resource permissions before you use the deployment template. 

#### Verify access to the resource group

Verify access to the resource group for your registered Azure Stack HCI servers as follows:

1. In Azure portal, go to the appropriate resource group.

1. Select **Access control (IAM)** from the left-hand side of the screen and then select **Check access**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/assign-resource-permissions-1.png" alt-text="Screenshot showing check access in the access control for the resource group." lightbox="./media/deployment-azure-resource-manager-template/assign-resource-permissions-1.png":::

1. In the **Check access**, input or select the following: 

    1. Select **Managed identity**.

    1. Select the appropriate subscription from the drop-down list.

    1. Select **All system-assigned managed identities**.

    1. Filter the list by typing the prefix and name of the registered server(s) for this deployment. Select one of the servers in your Azure Stack HCI cluster.

    1. Under **Current role assignments**, verify the selected server has the following roles enabled:

        - **Azure Connected Machine Resource Manager**.
    
        - **Azure Stack HCI Device Management Role**.
    
        - **Reader**.

        :::image type="content" source="./media/deployment-azure-resource-manager-template/assign-resource-permissions-2.png" alt-text="Screenshot showing server roles that are enabled on first server." lightbox="./media/deployment-azure-resource-manager-template/assign-resource-permissions-2.png":::

    1. Select the **X** on the upper right to go back to the server selection screen.

1. Select another server in your Azure Stack HCI cluster. Verify the selected server has the same roles enabled as you verified on the earlier server.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/assign-resource-permissions-3.png" alt-text="Screenshot showing server roles that are enabled on second server." lightbox="./media/deployment-azure-resource-manager-template/assign-resource-permissions-3.png":::

#### Add access to the resource group

Add access to the resource group for your registered Azure Stack HCI servers as follows:

1. Go to the appropriate resource group for your Azure Stack HCI environment.

1. Select **Access control (IAM)** from the left-hand side of the screen.

1. Select **+ Add** and then select **Add role assignment**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-resource-group-access-1.png" alt-text="Screenshot showing Add role assignment flow for access to the resource group." lightbox="./media/deployment-azure-resource-manager-template/add-resource-group-access-1.png":::

1. Search for and select **Azure Connected Machine Resource Manager**. Select **Next**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-resource-group-access-2.png" alt-text="Screenshot showing Azure Connected Machine Resource Manager for the resource group." lightbox="./media/deployment-azure-resource-manager-template/add-resource-group-access-2.png":::


1. Leave the selection on **User, group, or service principal**. Select **+ Select** members.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-resource-group-access-3.png" alt-text="Screenshot showing Members selection." lightbox="./media/deployment-azure-resource-manager-template/add-resource-group-access-3.png":::

1. Filter the list by typing `Microsoft.AzureStackHCI Resource Provider`. Select the **Microsoft.AzureStackHCI Resource Provider** option.

1. Select **Select**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-resource-group-access-4.png" alt-text="Screenshot showing Select members." lightbox="./media/deployment-azure-resource-manager-template/add-resource-group-access-4.png":::

1. Select **Review + assign**, then select this again.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-resource-group-access-6.png" alt-text="Screenshot showing Review + assign." lightbox="./media/deployment-azure-resource-manager-template/add-resource-group-access-6.png":::

1. Once the role assignment is added, you are able to see it in the **Notifications activity** log:

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-resource-group-access-7.png" alt-text="Screenshot showing a notification for the role assignments." lightbox="./media/deployment-azure-resource-manager-template/add-resource-group-access-7.png":::

#### Add the Key Vault Secrets User

1. Go to the appropriate resource group for Azure Stack HCI environment.

1. Select **Access control (IAM)** from the left-hand side of the screen.

1. In the right-pane, select **+ Add** and then select **Add role assignment**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-1.png" alt-text="Screenshot showing Add role assignment." lightbox="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-1.png":::

1. Search for and select **Key Vault Secrets User** and select **Next**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-2.png" alt-text="Screenshot showing Key Vault Secrets user." lightbox="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-2.png":::

1. Select **Managed identity**.

1. Select **+ Select** members and input the following:

    1. Select the appropriate subscription.

    1. Select **All system-assigned managed identities**.

    1. Filter the list by typing the prefix and name of the registered servers for your deployment.

    1. Select both servers for your environment and choose **Select**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-3.png" alt-text="Screenshot showing Managed identity selection." lightbox="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-3.png":::

1. Select **Review + assign**, then select this again.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-4.png" alt-text="Screenshot showing Review + assign selected." lightbox="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-4.png":::

1. Once the roles are assigned as **Key Vault Secrets User**, you are able to see them in the **Notifications activity** log.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-5.png" alt-text="Screenshot showing the notification for Key Vault Secrets user role assignment." lightbox="./media/deployment-azure-resource-manager-template/add-key-vault-secrets-user-5.png":::

#### Verify new role assignments

Optionally verify the role assignments you created.

1. Select **Access Control (IAM) Check Access** to verify the role assignments you created.

1. Go to **Azure Connected Machine Resource Manager > Microsoft.AzureStackHCI Resource Provider** for the appropriate resource group for your environment.

1. Go to **Key Vault Secrets User** for the appropriate resource group for the first server in your environment.

1. Go to **Key Vault Secrets User** for the appropriate resource group for the second server in your environment.

## Step 3: Deploy using ARM template

With all the prerequisite and preparation steps complete, you're ready to deploy using a known good and tested ARM deployment template and corresponding parameters JSON file. Use the parameters contained in the JSON file to fill out all values, including the encoded values generated previously. 

> [!IMPORTANT] 
> In this release, make sure that all the parameters contained in the JSON value are filled out including the ones that have a null value. If there are null values, then those need to be populated or the validation fails.

1. In Azure portal, go to **Home** and select **+ Create a resource**.

1. Select **Create** under **Template deployment (deploy using custom templates)**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png" alt-text="Screenshot showing the template deployment (deploy using custom template)." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-1.png":::

1. Near the bottom of the page, find **Start with a quickstart template or template spec** section. Select **Quickstart template** option.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-2.png" alt-text="Screenshot showing the quickstart template selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-2.png":::

1. Use the **Quickstart template (disclaimer)** field to filter for the appropriate template. Type *azurestackhci/create-cluster* for the filter.

1. When finished, **Select template**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-3.png" alt-text="Screenshot showing template selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-3.png":::


1. On the **Basics** tab, you see the **Custom deployment** page. You can select the various parameters through the dropdown list or select **Edit parameters**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-4.png" alt-text="Screenshot showing Custom deployment page on the Basics tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-4.png":::

1. Edit parameters such as network intent or storage network intent. Once the parameters are all filled out, **Save** the parameters file.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-5.png" alt-text="Screenshot showing parameters filled out for the template." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-5.png":::

    > [!TIP]
    > [Download a sample parameters file](https://databoxupdatepackages.blob.core.windows.net/documentation/EXAMPLE-cl-Parameters-2Node-Switchless-Compute_Management_withAdapterOverride.json) to understand the format in which you must provide the inputs.

1. Select the appropriate resource group for your environment.

1.  Scroll to the bottom, and confirm that **Deployment Mode = Validate**.

1. Select **Review + create**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-6.png" alt-text="Screenshot showing Review + Create selected on Basics tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-6.png":::

1. On the **Review + Create** tab, select **Create**. This will create the remaining prerequisite resources and validate the deployment. Validation takes about 10 minutes to complete.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7.png" alt-text="Screenshot showing Create selected on Review + Create tab." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7.png":::

1.  Once validation is complete, select **Redeploy**.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png" alt-text="Screenshot showing Redeploy selected." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7a.png":::

1. On the **Custom deployment** screen, select **Edit parameters**. Load up the previously saved parameters and select **Save**.

1. At the bottom of the workspace, change the final value in the JSON from **Validate** to **Deploy**, where **Deployment Mode = Deploy**. 

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png" alt-text="Screenshot showing deploy selected for deployment mode." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-7b.png":::


1. Verify that all the fields for the ARM deployment template have been filled in by the Parameters JSON.

1. Select the appropriate resource group for your environment.

1. Scroll to the bottom, and confirm that **Deployment Mode = Deploy**.

1. Select **Review + create**.

1. Select **Create**. This begins deployment, using the existing prerequisite resources that were created during the **Validate** step.

    The Deployment screen cycles on the Cluster resource during deployment.

    Once deployment initiates, there's a limited Environment Checker run, a full Environment Checker run, and cloud deployment starts. After a few minutes, you can monitor deployment in the portal.

    :::image type="content" source="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png" alt-text="Screenshot showing the status of environment checker validation." lightbox="./media/deployment-azure-resource-manager-template/deploy-arm-template-9.png":::

1. In a new browser window, navigate to the resource group for your environment. Select the cluster resource.

1. Select **Deployments**.

1. Refresh and watch the deployment progress from the first server (also known as the seed server and is the first server where you deployed the cluster). Deployment takes between 2.5 and 3 hours. Several steps take 40-50 minutes or more.

    > [!NOTE]
    > If you check back on the template deployment, you will see that it eventually times out. This is a known issue, so watching **Deployments** is the best way to monitor the progress of deployment.

1. The step in deployment that takes the longest is **Deploy Moc and ARB Stack**. This step takes 40-45 minutes.

    Once complete, the task at the top updates with status and end time.


## Next steps

Learn more:
- [About Arc VM management](../manage/azure-arc-vm-management-overview.md)
- About how to [Deploy Azure Arc VMs on Azure Stack HCI](../manage/create-arc-virtual-machines.md).
