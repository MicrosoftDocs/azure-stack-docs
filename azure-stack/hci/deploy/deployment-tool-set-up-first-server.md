--- 
title: Set up the first server for new Azure Stack HCI deployments (preview) 
description: Learn how to set up the first server before you deploy Azure Stack HCI (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/29/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Set up the first server for new Azure Stack HCI deployment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes how to set up the first server in the cluster for a new Azure Stack HCI deployment. The first server listed for the cluster acts as a staging server in the deployment.

The deployment tool is included in the Azure Stack HCI Supplemental Package. You need to install and set up the deployment tool only on the first server in the cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install version 22H2 OS](deployment-tool-install-os.md) in English on each server.

## Download the Supplemental Package

The Supplemental Package supports only the English version of the Azure Stack HCI operating system. Make sure that you've installed Azure Stack HCI, version 22H2 OS in English on each server before downloading the Supplemental Package.

[!INCLUDE [hci-deployment-tool-sp](../../includes/hci-deployment-tool-sp.md)]

## Connect to the first server

Follow these steps to connect to the first server:

1. Select the first server listed for the cluster to act as a staging server during deployment.

1. Sign in to the first server using local administrative credentials.

1. Copy the [Supplemental Package that you downloaded previously](#download-the-supplemental-package) to a local drive on the first server.

## Set up the deployment tool

[!INCLUDE [hci-set-up-deployment-tool](../../includes/hci-set-up-deployment-tool.md)]

## Assign Azure permissions for deployment

This section describes how to assign Azure permissions for deployment from the Azure portal or using PowerShell.

### Assign Azure permissions from the Azure portal

If your Azure subscription is through an EA or CSP, ask your Azure subscription admin to assign Azure subscription level privileges of:

- **User Access Administrator** role: Required to Arc-enable each server of an Azure Stack HCI cluster.
- **Contributor** role: Required to register and unregister the Azure Stack HCI cluster.

   :::image type="content" source="media/deployment-tool/first-server/access-control.png" alt-text="Screenshot of assign permissions screen." lightbox="media/deployment-tool/first-server/access-control.png":::

### Assign Azure permissions using PowerShell

Some admins may prefer a more restrictive option. In this case, it's possible to create a custom Azure role specific for Azure Stack HCI deployment. The following procedure provides a typical set of permissions to the custom role.  To set more restrictive permissions, see [How do I use a more restricted custom permissions role?](../manage/manage-cluster-registration.md#how-do-i-use-a-more-restricted-custom-permissions-role)

1. Create a json file called **customHCIRole.json** with following content. Make sure to change `<subscriptionID>` to your Azure subscription ID. To get your subscription ID, go to [the Azure portal](https://portal.azure.com/) > **Subscriptions**, and copy/paste your subscription ID from the list.

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
		"/subscriptions/$SubscriptionID"
	    ]
    }
    ```
1. Create the custom role:

    ```powershell
    New-AzRoleDefinition -InputFile <path to customHCIRole.json>
    ```

1. Assign the custom role to the user:

    ```powershell
    $user = get-AzAdUser -DisplayName <userdisplayname>
    $role = Get-AzRoleDefinition -Name "Azure Stack HCI registration role"
    New-AzRoleAssignment -ObjectId $user.Id -RoleDefinitionId $role.Id -Scope /subscriptions/<subscriptionid>
    ```

    The following table explains why these permissions are required:

    | Operation | Description |
    |--|--|
    | "Microsoft.Resources/subscriptions/resourceGroups/read"<br>"Microsoft.Resources/subscriptions/resourceGroups/write"<br>"Microsoft.Resources/subscriptions/resourceGroups/delete"<br>"Microsoft.AzureStackHCI/register/action"<br>"Microsoft.AzureStackHCI/Unregister/Action"<br>"Microsoft.AzureStackHCI/clusters/\*"<br>"Microsoft.Authorization/roleAssignments/read" | To register and unregister the Azure Stack HCI cluster. |
    | "Microsoft.Authorization/roleAssignments/write"<br>"Microsoft.HybridCompute/register/action"<br>"Microsoft.GuestConfiguration/register/action"<br>"Microsoft.HybridConnectivity/register/action" | To register and unregister the Arc for server resources. |
    | "Microsoft.HybridCompute/machines/extensions/write" <br> "Microsoft.HybridCompute/machines/extensions/read" | To list and enable Arc Extensions on Azure Stack HCI cluster. |
    | "Microsoft.HybridCompute/machines/read" <br> "Microsoft.HybridCompute/machines/write" | To enable Arc for Servers on each node of your Azure Stack HCI cluster. |
    | "Microsoft.HybridCompute/privateLinkScopes/read" | To enable private endpoints. |
    | "Microsoft.GuestConfiguration/guestConfigurationAssignments/read" <br> "Microsoft.ResourceConnector/register/action" <br> "Microsoft.Kubernetes/register/action" <br> "Microsoft.KubernetesConfiguration/register/action" <br> "Microsoft.ExtendedLocation/register/action" <br> "Microsoft.HybridContainerService/register/action" <br> "Microsoft.ResourceConnector/appliances/write" | For Azure Resource Bridge installation. |

## Next steps

After setting up the first server in your cluster, you're ready to run the deployment tool. You can either create a new deployment configuration file interactively or use an existing configuration file you created:

- [Deploy using a new configuration file](deployment-tool-new-file.md).
- [Deploy using an existing configuration file](deployment-tool-existing-file.md).
- If preferred, you can also [deploy using PowerShell](deployment-tool-powershell.md).