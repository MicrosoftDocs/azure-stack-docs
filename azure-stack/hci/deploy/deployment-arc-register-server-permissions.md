--- 
title: Register your Azure Stack HCI servers with Azure Arc and assign permissions for deployment (preview) 
description: Learn how to Register your Azure Stack HCI servers with Azure Arc and assign permissions for deployment (preview). 
author: alkohli
ms.topic: how-to
ms.date: 10/26/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Register your servers and assign permissions for Azure Stack HCI, version 23H2 deployment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to register your Azure Stack HCI servers and then set up the required permissions to deploy an Azure Stack HCI, version 23H2 cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](./deployment-prerequisites.md).
- Complete the [deployment checklist](./deployment-checklist.md).
- Prepare your [Active Directory](./deployment-prep-active-directory.md) environment.
- [Install the Azure Stack HCI, version 23H2 operating system](./deployment-install-os.md) on each server.

- If you are registering the servers, make sure that you have `Contributor` permissions and `User Access Administrator` permissions for the subscription. To verify, follow these steps in the Azure portal:
    - Go to the subscription that you will use for Azure Stack HCI deployment.
    - In the left pane, select **Access control (IAM)**.
    - In the right pane, go to **Check access > View my access > Role assignments**. Verify that you have the `Contributor` and `User Access Administrator` roles assigned.

    :::image type="content" source="media/deployment-arc-register-server-permissions/contributor-user-access-administrator-permissions.png" alt-text="Screenshot of the permissions in deployment subscription." lightbox="./media/deployment-arc-register-server-permissions/contributor-user-access-administrator-permissions.png":::


- If you are registering the servers, make sure that you have the **Cloud Application Administrator** role in the tenant used for the deployment. To get the tenant ID and assign the Cloud Application Administrator role to the user, follow these steps: 
    1. In the Azure portal, go to the **Microsoft Entra ID** resource. In the right pane, select **Tenant ID**.
        :::image type="content" source="media/deployment-arc-register-server-permissions/tenantid.png" alt-text="Screenshot of the tenant ID in Microsoft Entra ID in Azure portal." lightbox="./media/deployment-arc-register-server-permissions/tenantid.png":::
    1. Go to the **Users** section. Select the user and go to **Assigned roles**. 
    1. Select **+ Add assignments** and assign the **Cloud Application Administrator** role.

## Register servers with Azure Arc

> [!NOTE]
> Run these steps on every server of your cluster.

1. Download and install the [Arc registration script](https://www.powershellgallery.com/packages/AzSHCI.ARCInstaller/0.1.2489.42) from PSGallery.

    ```powershell
    #Install Arc registration script from PSGallery
    Install-Module AzsHCI.ARCinstaller
    ```
1. Run the script. The script takes in the following parameters: 
    
    |Parameters  |Description  |
    |------------|-------------|
    |`SubscriptionID`    |The ID of the subscription used to register your servers with Azure Arc.         |
    |`TenantID`          |The tenant ID used to register your servers with Azure Arc. Go to your Microsoft Entra ID and copy the tenant ID property.       |
    |`ResourceGroup`     |The resource group precreated for Arc registration of the servers. A resource group is created if one does not exist.         |
    |`Region`            |The Azure region used for registration. For this release, only `eastus` is supported.          |
    |`AccountID`         |The user who will register and deploy the cluster.         |
    |`DeviceCode`        |The device code displayed in the console at `https://microsoft.com/devicelogin` and is used to sign in to the device.         |
    
   Here's a sample output from a successful run of the script:

   ```powershell
   #Install required PowerShell modules in your node for the Azure registration
   Install-Module Az.Accounts -Force
   Install-Module Az.ConnectedMachine -Force
   Install-Module Az.Resources -Force

   #Define the subscription where you want to register your server as Arc device
   $Subscription = "YourSubscriptionID"

   #Define the resource group where you want to register your server as Arc device
   $RG = "YourResourceGroupName"

   #Define the tenant you will use to register your server as Arc device
   $Tenant = "YourTenantID"

   #Connect to your Azure account and Subscription
   Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode

   #Get the Access Token and Account ID for the registration
   $ARMtoken = (Get-AzAccessToken).Token

   #Get the Account ID for the registration
   $id = (Get-AzContext).Account.Id

   #Invoke the registration script. For this preview release, only eastus region is supported.
   Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region eastus -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Force
   ```

## Assign required permissions for deployment

This section describes how to assign Azure permissions for deployment from the Azure portal.


1. In the Azure portal, go to the resource group used to register the servers on your subscription. In the left pane, select **Access control (IAM)**. In the right pane, select + Add and from the dropdown list, select **Add role assignment**.

    :::image type="content" source="media/deployment-arc-register-server-permissions/add-role-assignment.png" alt-text="Screenshot of the Add role assignment in Access control in resource group for Azure Stack HCI deployment." lightbox="./media/deployment-arc-register-server-permissions/add-role-assignment.png":::

1. Assign `Key Vault Administrator` permissions to the user who will deploy the cluster.

    :::image type="content" source="media/deployment-arc-register-server-permissions/add-role-assignment-4.png" alt-text="Screenshot of the Current role assignment in Access control in resource group for Azure Stack HCI deployment." lightbox="./media/deployment-arc-register-server-permissions/add-role-assignment-4.png":::



## Next steps

After setting up the first server in your cluster, you're ready to deploy using Azure portal:

- [Deploy using Azure portal](./deploy-via-portal.md).


