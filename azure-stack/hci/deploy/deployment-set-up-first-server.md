--- 
title: Set up the first server for new Azure Stack HCI 23H2 deployments (preview) 
description: Learn how to set up the first server before you deploy Azure Stack HCI 23H2 (preview).
author: alkohli
ms.topic: how-to
ms.date: 10/04/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Set up the first server for new Azure Stack HCI 23H2 deployment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to set up the first server in the cluster for a new Azure Stack HCI version 23H2 deployment. The first server listed for the cluster acts as a staging server in the deployment.

The deployment tool is part of the preview package that you have downloaded. You need to install and set up the deployment tool only on the first server in the cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment. Make sure to use the [version 10.2306 of the AsHciADArtifactsPreCreationTool](https://www.powershellgallery.com/packages/AsHciADArtifactsPreCreationTool/10.2306) to prepare your Active Directory.
- [Install version 23H2 OS](deployment-tool-install-os.md) in English on each server.
- Register your subscription against the `Microsoft.ResourceConnector` resource provider. Run the following PowerShell cmdlet to register your subscription:

    ```powershell
    Register-AzResourceProvider -ProviderNamespace Microsoft.ResourceConnector
    ```

- Before you start the deployment, run the following command to check for any mapped drives and then remove those:

    ```powershell
    (Get-PSDrive -PSProvider FileSystem).Root 
    ```

The installation could potentially fail if there are mapped drives other than the drive where the package is being installed. 

## Download 23H2 preview

When you try out this new deployment tool, make sure that you do not run production workloads  while it's in preview. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.  

Follow these steps to download the preview files:

1. Go to Microsoft Collaborate site and download the 23H2 preview package.

1. Download the following files:  

[!INCLUDE [hci-deployment-23h2](../../includes/hci-set-up-deployment-23h2.md)]

## Connect to the first server

Follow these steps to connect to the first server:

1. Select the first server listed for the cluster to act as a staging server during deployment.

1. Sign in to the first server using local administrative credentials.

1. Copy the preview package that you downloaded previously from [Collaborate].

## Set up the deployment tool

[!INCLUDE [hci-deployment-23h2](../../includes/hci-set-up-deployment-23h2.md)]

## Assign Azure permissions for deployment

This section describes how to assign Azure permissions for deployment from the Azure portal or using PowerShell.

### Assign Azure permissions from the Azure portal

If your Azure subscription is through an Enterprise Agreement (EA) or Cloud Solution Provider (CSP), ask your Azure subscription admin to assign Azure subscription level privileges of:

- **User Access Administrator** role: Required to Arc-enable each server of an Azure Stack HCI cluster.
- **Contributor** role: Required to register and unregister the Azure Stack HCI cluster.

   :::image type="content" source="media/deployment-tool/first-server/access-control.png" alt-text="Screenshot of assign permissions screen." lightbox="media/deployment-tool/first-server/access-control.png":::

### Assign Azure permissions using PowerShell

Some admins may prefer a more restrictive option. In this case, it's possible to create a custom Azure role specific for Azure Stack HCI deployment. To create this custom role, you need to be either an Owner or a User Access Administrator on the subscription. For more information about how to create a custom role including the various manage operations, see [Tutorial: Create an Azure custom role using Azure PowerShell](/azure/role-based-access-control/tutorial-custom-role-powershell).

The following procedure provides a typical set of permissions to the custom role.

1. Create a **customHCIRole.json** with the following content. Make sure to change `<subscriptionID>` to your Azure subscription ID. To get your Azure subscription ID, use the [`Get-AzSubscription`](/powershell/module/az.accounts/get-azsubscription) command.

    ```jason
    {
	    "Name": "Azure Stack HCI registration role - Custom",
	    "Id": null,
	    "IsCustom": true,
	    "Description": "Custom Azure role to allow subscription-level access to register Azure Stack HCI",
	    "Actions": [
		"Microsoft.Resources/subscriptions/resourceGroups/read",
		"Microsoft.Resources/subscriptions/resourceGroups/write",
		"Microsoft.Resources/subscriptions/resourceGroups/delete",
		"Microsoft.AzureStackHCI/register/action",
		"Microsoft.AzureStackHCI/Unregister/Action",
		"Microsoft.AzureStackHCI/clusters/*",
		"Microsoft.Authorization/roleAssignments/write",
		"Microsoft.Authorization/roleAssignments/read",
		"Microsoft.HybridCompute/register/action",
		"Microsoft.GuestConfiguration/register/action",
		"Microsoft.HybridConnectivity/register/action",
		"Microsoft.HybridCompute/machines/extensions/write",
		"Microsoft.HybridCompute/machines/extensions/read",
		"Microsoft.HybridCompute/machines/read",
		"Microsoft.HybridCompute/machines/write",
		"Microsoft.HybridCompute/privateLinkScopes/read",
		"Microsoft.GuestConfiguration/guestConfigurationAssignments/read",
		"Microsoft.ResourceConnector/register/action",
		"Microsoft.Kubernetes/register/action",
		"Microsoft.KubernetesConfiguration/register/action",
		"Microsoft.ExtendedLocation/register/action",
		"Microsoft.HybridContainerService/register/action",
		"Microsoft.ResourceConnector/appliances/write"
	    ],
	    "NotActions": [],
	    "AssignableScopes": [
		"/subscriptions/<Azure Subscription ID>"
	    ]
    }
    ```
1. Create the custom role:

    ```powershell
    New-AzRoleDefinition -InputFile "C:\CustomRoles\customHciRole.json"
    ```

1. Assign the custom role to the user:

    ```powershell
    $user = Get-AzADUser -DisplayName <userdisplayname>
    $role = Get-AzRoleDefinition -Name "Azure Stack HCI registration role"
    New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionId $role.Id -Scope /subscriptions/<Azure Subscription ID>
    ```

    The following table explains why these permissions are required:

    | Operation | Description |
    |--|--|
    | "Microsoft.Resources/subscriptions/resourceGroups/read"<br>"Microsoft.Resources/subscriptions/resourceGroups/write"<br>"Microsoft.Resources/subscriptions/resourceGroups/delete"<br>"Microsoft.AzureStackHCI/register/action"<br>"Microsoft.AzureStackHCI/Unregister/Action"<br>"Microsoft.AzureStackHCI/clusters/\*"<br>"Microsoft.Authorization/roleAssignments/read" | To register and unregister the Azure Stack HCI cluster. |
    | "Microsoft.Authorization/roleAssignments/write"<br>"Microsoft.HybridCompute/register/action"<br>"Microsoft.GuestConfiguration/register/action"<br>"Microsoft.HybridConnectivity/register/action" | To register and unregister the Arc for server resources. |
    | "Microsoft.HybridCompute/machines/extensions/write" <br> "Microsoft.HybridCompute/machines/extensions/read" | To list and enable Arc Extensions on Azure Stack HCI cluster. |
    | "Microsoft.HybridCompute/machines/read" <br> "Microsoft.HybridCompute/machines/write" | To enable Arc for Servers on each node of your Azure Stack HCI cluster. |
    | "Microsoft.HybridCompute/privateLinkScopes/read" | To enable private endpoints. |
    | "Microsoft.GuestConfiguration/guestConfigurationAssignments/read" <br> "Microsoft.ResourceConnector/register/action" <br> "Microsoft.Kubernetes/register/action" <br> "Microsoft.KubernetesConfiguration/register/action" <br> "Microsoft.ExtendedLocation/register/action" <br> "Microsoft.HybridContainerService/register/action" <br> "Microsoft.ResourceConnector/appliances/write" | For Azure Arc Resource Bridge installation. |

To set more restrictive permissions, see [How do I use a more restricted custom permissions role?](../manage/manage-cluster-registration.md#how-do-i-use-a-more-restricted-custom-permissions-role)

## Next steps

After setting up the first server in your cluster, you're ready to run the deployment tool. You can either create a new deployment configuration file interactively or use an existing configuration file you created:

- [Deploy using a new configuration file](deployment-tool-new-file.md).
- [Deploy using an existing configuration file](deployment-tool-existing-file.md).
- If preferred, you can also [deploy using PowerShell](deployment-tool-powershell.md).