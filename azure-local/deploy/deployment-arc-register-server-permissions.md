--- 
title: Register your Azure Local machines with Azure Arc and assign permissions for deployment 
description: Learn how to register your Azure Local machines with Azure Arc and assign permissions for deployment. 
author: alkohli
ms.topic: how-to
ms.date: 07/25/2025
ms.author: alkohli
ms.service: azure-local
ms.custom: devx-track-azurepowershell
---

# Assign required permissions for Azure Local deployment

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to set up the required permissions to deploy Azure Local.

## Prerequisites

Before you begin, make sure you complete the following prerequisites:

### Azure Local machine prerequisites

- Make sure that your Azure Local machines are registered with Azure Arc.

## Assign required permissions

This section describes how to assign Azure permissions for deployment from the Azure portal.

1. In [the Azure portal](https://portal.azure.com/), go to the subscription used to register the machines. In the left pane, select **Access control (IAM)**. In the right pane, select **+ Add** and from the dropdown list, select **Add role assignment**.

    :::image type="content" source="media/deployment-arc-register-server-permissions/add-role-assignment-a.png" alt-text="Screenshot of the Add role assignment in Access control in subscription for Azure Local deployment." lightbox="./media/deployment-arc-register-server-permissions/add-role-assignment-a.png":::

1. Go through the tabs and assign the following role permissions to the user who deploys the instance:

    - **Azure Stack HCI Administrator**
    - **Reader**

1. In the Azure portal, go to the resource group used to register the machines on your subscription. In the left pane, select **Access control (IAM)**. In the right pane, select **+ Add** and from the dropdown list, select **Add role assignment**.

    :::image type="content" source="media/deployment-arc-register-server-permissions/add-role-assignment.png" alt-text="Screenshot of the Add role assignment in Access control in resource group for Azure Local deployment." lightbox="./media/deployment-arc-register-server-permissions/add-role-assignment.png":::

1. Go through the tabs and assign the following permissions to the user who deploys the instance:

    - **Key Vault Data Access Administrator**: This permission is required to manage data plane permissions to the key vault used for deployment.
    - **Key Vault Secrets Officer**: This permission is required to read and write secrets in the key vault used for deployment.
    - **Key Vault Contributor**: This permission is required to create the key vault used for deployment.
    - **Storage Account Contributor**: This permission is required to create the storage account used for deployment.

1. In the right pane, go to **Role assignments**. Verify that the deployment user has all the configured roles.

1. In the Azure portal, go to **Microsoft Entra Roles and Administrators** and assign the **Cloud Application Administrator** role permission at the Microsoft Entra tenant level.

    :::image type="content" source="media/deployment-arc-register-server-permissions/cloud-application-administrator-role-at-tenant.png" alt-text="Screenshot of the Cloud Application Administrator permission at the tenant level." lightbox="./media/deployment-arc-register-server-permissions/cloud-application-administrator-role-at-tenant.png":::

    > [!NOTE]
    > The Cloud Application Administrator permission is temporarily needed to create the service principal. After deployment, this permission can be removed.

## Next steps

After setting up the first machine in your instance, you're ready to deploy using Azure portal:

- [Deploy using Azure portal](./deploy-via-portal.md).
