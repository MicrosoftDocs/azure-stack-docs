---
title: Azure Resource Manager template deployment for Azure Stack HCI, version 23H2 (preview)
description: Learn how to prepare and then deploy Azure Stack HCI, version 23H2 using the Azure Resource Manager template (preview).
author: alkohli
ms.topic: how-to
ms.date: 12/15/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
ms.custom: devx-track-arm-template
---

# Deploy an Azure Stack HCI, version 23H2 via Azure Resource Manager deployment template (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article details the prerequisites and preparation required before you use an Azure Resource Manager template (ARM template) in Azure portal to deploy Azure Stack HCI in your environment.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

- Completion of [Register your servers with Azure Arc and assign deployment permissions](./deployment-arc-register-server-permissions.md). Make sure that:
    - All the mandatory extensions have installed successfully. The mandatory extensions include: Azure Edge Lifecycle Manager, Azure Edge Device Management, and Telemetry and Diagnostics.
    - All servers are running the same version of OS.
    - All the servers have the same network adapter configuration.


## Prepare Azure resources

Follow these steps to prepare the Azure resources you need for the deployment:

### Create service principal

To authenticate your cluster, you need to create a service principal. You must also assign user access administrator and contributor roles to the service principal. Follow the steps in one of these procedures to create the service principal and assign the roles:

- [Create a Microsoft Entra application and service principal that can access resources via Azure portal](/entra/identity-platform/howto-create-service-principal-portal).
- [Create an Azure service principal with Azure PowerShell](/powershell/azure/create-azure-service-principal-azureps).

### Create cloud witness storage account

First, create a storage account contained within the cloud witness account. You then need to get the access key for this storage account, and then use it in an encoded format with the ARM deployment template.

Follow these steps to get and encode the access key for the ARM deployment template:

1. In the Azure portal, go to the storage account that you created and then go to **Access keys**.

1. For **key1, Key**, select **Show**. Select the **Copy to clipboard** button at the right side of the **Key** field.

    <!--:::image type="content" source="media/.png" alt-text="Screenshot of access keys in the cloud witness storage account" lightbox="media/.png":::-->

1. For **key1, Key**, select **Hide**.

1. In PowerShell, encode the **Key** value string with the following script:

    ```PowerShell
    $secret="examplesecretkeyvaluethatwillbelongerthanthisandoutputwilllookdifferent" 
    [Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($secret))
    ```

    The encoded output will look similar to this, and is based on the secret value for the cloud witness storage account for your environment:

    ```PowerShell
    ZXhhbXBsZXNlY3JldGtleXZhbHVldGhhdHdpbGxiZWxvbmdlcnRoYW50aGlzYW5kb3V0cHV0d2lsbGxvb2tkaWZmZXJlbnQ= 
    ```

1. The encoded output value you generate is what the ARM deployment template expects. Make a note of this value as well as the name of the storage account. You will use these values later in the deployment process.

### Assign resource permissions

You need to create and assign the needed resource permissions before you use the deployment template. 

#### Verify access to the resource group

Verify access to the resource group for your registered Azure Stack HCI servers as follows:

1. In Azure portal, go to the appropriate resource group.

1. Select **Access control (IAM)** from the left-hand side of the screen and then select **Check access**.

1. In the **Check access**, select **Managed identity**.

1. Select the appropriate subscription from the drop-down list.

1. Select **All system-assigned managed identities**.

1. Filter the list by typing the prefix and name of the registered server(s) for this deployment. Select one of the servers in your Azure Stack HCI cluster.

1. Under **Current role assignments**, verify the selected server has the following roles enabled:

    - **Azure Connected Machine Resource Manager**.

    - **Azure Stack HCI Device Management Role**.

    - **Reader**.

1. Select the **X** on the upper right to go back to the server selection screen.

1. Select another server in your Azure Stack HCI cluster. Verify the selected server has the same roles enabled as you verified on the earlier server.

    <!--:::image type="content" source="media/.png" alt-text="alt test" lightbox="media/.png":::-->

#### Add access to the resource group

Add access to the resource group for your registered Azure Stack HCI servers as follows:

1. Under **Current role assignments**, select **Azure Connected Machine Resource Manager**.

1. Go to the appropriate resource group for your Azure Stack HCI environment.

1. Select **Access control (IAM)** from the left-hand side of the screen.

1. Select **+ Add** and then select **Add role assignment**.

1. Search for and select **Azure Connected Machine Resource Manager**.

1. Select **Next**.

1. Leave the selection on **User, group, or service principal**.

1. Select **+ Select** members.

1. Filter the list by typing `Microsoft.AzureStackHCI Resource Provider`.

1. Select the **Microsoft.AzureStackHCI Resource Provider** option.

1. Select **Select**.

1. Select **Review + assign**, then select this again.

1. Once the role assignment is added, you'll be able to see it in the **Notifications activity** log:

    <!--:::image type="content" source="media/.png" alt-text="alt test" lightbox="media/.png":::

    :::image type="content" source="media/.png" alt-text="alt test" lightbox="media/.png":::-->

#### Add the Key Vault Secrets User

1. Go to the appropriate resource group for Azure Stack HCI environment.

1. Select **Access control (IAM)** from the left-hand side of the screen.

1. Select **+ Add**.

1. Select **Add role assignment**.

1. Search for and select **Key Vault Secrets User**.

1. Select **Next**.

1. Select **Managed identity**.

1. Select **+ Select** members.

1. Select the appropriate subscription.

1. Select **All system-assigned managed identities**.

1. Filter the list by typing the prefix and name of the registered servers for your deployment.

1. Select both servers for your environment.

1. Choose **Select**.

1. Select **Review + assign**, then select this again.

1. Once the roles are assigned as **Key Vault Secrets User**, you'll be able to see them in the **Notifications activity** log.

    <!--:::image type="content" source="media/.png" alt-text="alt test" lightbox="media/.png":::

    :::image type="content" source="media/.png" alt-text="alt test" lightbox="media/.png":::-->

#### Verify new role assignments

1. Select **Access Control (IAM) Check Access** to verify the role assignments you just created.

1. Go to **Azure Connected Machine Resource Manager > Microsoft.AzureStackHCI Resource Provider** for the appropriate resource group for your environment.

    <!--:::image type="content" source="media/.png" alt-text="alt test" lightbox="media/.png":::-->

1. Go to **Key Vault Secrets User** for the appropriate resource group for the first server in your environment.

    <!--:::image type="content" source="media/.png" alt-text="alt test" lightbox="media/.png":::-->

1. Go to **Key Vault Secrets User** for the appropriate resource group for the second server in your environment.

## Deploy using ARM template

With all the prerequisite and preparation steps complete, you are ready to deploy using a known good and tested ARM deployment template and corresponding parameters JSON file.

1. In Azure portal, go to **Home**.

1. Select **Create a resource**.

1. Select **Create** under **Template deployment (deploy using custom templates)**.
    <!--A screenshot of a computer-->

1. Near the bottom of the page, find **Start with a quickstart template or template spec** section.

1. Use the **Quickstart template (disclaimer)** field to filter for the appropriate template. Type *azurestackhci/create-cluster* for the filter.

1. **Select template**.

1. You'll see the **Custom deployment** page.

1. On the **Custom deployment** page, select **Edit parameters**.

1. Paste the Secret value from the clipboard you previously saved to the workspace, where **Deployment Mode = Validate**.
    <!--A screenshot of a computer program-->

1. Select **Save**.

1. Verify that the field for the ARM deployment template has been filled in by the Parameters JSON you just pasted from the special Params KeyVault for your environment. All should be filled in except for the resource group.

1. Select the appropriate resource group for your environment.

1. Scroll to the bottom, and confirm that **Deployment Mode = Validate**.
A screenshot of a computer

1. Select **Review + create**.

1. Select  **Create**. This will create the remaining prerequisite resources and validate the deployment. Validation takes about 10 minutes to complete.
A screenshot of a computer

1. Once validation is complete, select **Redeploy**. 
A screenshot of a computer

1. On the **Custom deployment** screen, select **Edit parameters**.

1. Paste the contents of the special Params KeyVault for your environment.

1. At the bottom of the workspace, change the final value in the JSON from **Validate** to **Deploy**, where **Deployment Mode = Deploy**.
    <!--A screen shot of a computer program-->

1. Verify that all the fields for the ARM deployment template have been filled in by the Parameters JSON you just pasted from the special Params KeyVault for your environment.

1. Select the appropriate resource group for your environment.

1. Scroll to the bottom, and confirm that **Deployment Mode = Deploy**.
    <!--A screenshot of a computer-->

1. Select **Review + create**. 

1. Select **Create**. This will begin deployment, using the existing prerequisite resources that were created during the **Validate** step.
    <!--A screenshot of a computer-->

    The Deployment screen will cycle on the Cluster resource for the duration of deployment.

    Once deployment initiates, there is a limited Environment Checker run, a Full Environment Checker run, and Cloud Deployment starts. After a few minutes, you can monitor deployment in the portal.

1. In a new browser window, navigate to the resource group for your environment.

1. Select the cluster resource.

1. Select **Deployments (preview)**.

    <!--A screenshot of a computer-->

1. Refresh and watch the deployment progress from the seed server. Deployment takes between 2.5 and 3 hours.

    > [!Note]
    > If you check back on the template deployment, you will see that it eventually times out. This is a known issue, so watching **Deployments (preview)** is the best way to monitor the progress of deployment.

    <!--A screenshot of a computer-->

1. The step in deployment that takes the longest is **Deploy Moc and ARB Stack**. This step takes 40-45 minutes.
    <!--A screenshot of a computer-->

1. Once complete, the task at the top will update with status and end time.
    <!--A screenshot of a computer-->

## Next steps

Learn more:
- [About Arc VM management](../manage/azure-arc-vm-management-overview.md)
- About how to [Deploy Azure Arc VMs on Azure Stack HCI](../manage/create-arc-virtual-machines.md).
