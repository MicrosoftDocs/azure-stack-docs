--- 
title: Register your Azure Local machines with Azure Arc and assign permissions for deployment 
description: Learn how to Register your Azure Local machines with Azure Arc and assign permissions for deployment. 
author: alkohli
ms.topic: how-to
ms.date: 05/06/2025
ms.author: alkohli
ms.service: azure-local
ms.custom: devx-track-azurepowershell
---

# Register your machines and assign permissions for Azure Local deployment

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to register your Azure Local machines and then set up the required permissions to deploy Azure Local.

## Prerequisites

Before you begin, make sure you complete the following prerequisites:

### Azure Local machine prerequisites

[!INCLUDE [hci-registration-azure-local-machine-prerequisites](../includes/hci-registration-azure-local-machine-prerequisites.md)]

### Azure prerequisites

[!INCLUDE [hci-registration-azure-prerequisites](../includes/hci-registration-azure-prerequisites.md)]

## Register machines with Azure Arc

> [!IMPORTANT]
> Run these steps as a local administrator on every Azure Local machine that you intend to cluster.


1. Set the parameters. The script takes in the following parameters:

    |Parameters  |Description  |
    |------------|-------------|
    |`SubscriptionID`    |The ID of the subscription used to register your machines with Azure Arc.         |
    |`TenantID`          |The tenant ID used to register your machines with Azure Arc. Go to your Microsoft Entra ID and copy the tenant ID property.       |
    |`ResourceGroup`     |The resource group precreated for Arc registration of the machines. A resource group is created if one doesn't exist.         |
    |`Region`            |The Azure region used for registration. See the [Supported regions](../concepts/system-requirements-23h2.md#azure-requirements) that can be used.          |
    |`AccountID`         |The user who registers and deploys the instance.         |
    |`ProxyServer`       |Optional parameter. Proxy Server address when is required for outbound connectivity. |
    |`DeviceCode`        |The device code displayed in the console at `https://microsoft.com/devicelogin` and is used to sign in to the device.         |

    
    # [PowerShell](#tab/powershell)

    ```powershell
    #Define the subscription where you want to register your machine as Arc device
    $Subscription = "YourSubscriptionID"
    
    #Define the resource group where you want to register your machine as Arc device
    $RG = "YourResourceGroupName"

    #Define the region to use to register your server as Arc device
    #Do not use spaces or capital letters when defining region
    $Region = "eastus"
    
    #Define the tenant you will use to register your machine as Arc device
    $Tenant = "YourTenantID"
    
    #Define the proxy address if your Azure Local deployment accesses the internet via proxy
    $ProxyServer = "http://proxyaddress:port"
    ```
 
    # [Output](#tab/output)

    Here's a sample output of the parameters:

    ```output
    PS C:\Users\SetupUser> $Subscription = "<Subscription ID>"
    PS C:\Users\SetupUser> $RG = "myashcirg"
    PS C:\Users\SetupUser> $Tenant = "<Tenant ID>"
    PS C:\Users\SetupUser> $Region = "eastus"
    PS C:\Users\SetupUser> $ProxyServer = "<http://proxyserver:tcpPort>"
    ```

    ---
2. Connect to your Azure account and set the subscription. Open a browser on the client that you're using to connect to the machine and open this page: `https://microsoft.com/devicelogin` and enter the provided code in the Azure CLI output to authenticate. Get the access token and account ID for the registration.  

    # [PowerShell](#tab/powershell)

    ```azurecli
    #Connect to your Azure account and Subscription
    Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode

    #Get the Access Token for the registration
    $ARMtoken = (Get-AzAccessToken -WarningAction SilentlyContinue).Token

    #Get the Account ID for the registration
    $id = (Get-AzContext).Account.Id   
    ```

    # [Output](#tab/output)

    Here's a sample output of setting the subscription and authentication:

    ```output
    PS C:\Users\SetupUser> Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode
    WARNING: To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code A44KHK5B5
    to authenticate.
    
    Account               SubscriptionName      TenantId                Environment
    -------               ----------------      --------                ----------- 
    guspinto@contoso.com AzureStackHCI_Content  <Tenant ID>             AzureCloud

    PS C:\Users\SetupUser> $ARMtoken = (Get-AzAccessToken).Token
    PS C:\Users\SetupUser> $id = (Get-AzContext).Account.Id
    ```

    ---

3. Finally run the Arc registration script. The script takes a few minutes to run.

    # [PowerShell](#tab/powershell)

    ```powershell
    #Invoke the registration script. Use a supported region.
    Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region $Region -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id
    ```

    If you're accessing the internet using a proxy server, you need to add the `-Proxy` parameter and provide the proxy server in the format `http://<Proxy server FQDN or IP address>:Port` when running the script.

    For a list of supported Azure regions, see [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements).

    # [Output](#tab/output)

    Here's a sample output of a successful registration of your machines:

    ```output
    PS C:\Users\Administrator> Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region $Region -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id
    >>
    Configuration saved to: C:\Users\ADMINI~1\AppData\Local\Temp\bootstrap.json
    Triggering bootstrap on the device...
    Waiting for bootstrap to complete... Current Status: InProgress
    =========SNIPPED=========SNIPPED=============
    Waiting for bootstrap to complete... Current Status: InProgress
    Waiting for bootstrap to complete... Current Status: Succeeded
    Bootstrap succeeded.
    
    Triggering bootstrap log collection as a best effort.
    Version Response                                                    
    ------- --------                                                    
    V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response
    V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response


    PS C:\Users\Administrator>
    ```
    ---

4. After the script completes successfully on all the machines, verify that:

    1. Your machines are registered with Arc. Go to the Azure portal and then go to the resource group associated with the registration. The machines appear within the specified resource group as **Machine - Azure Arc** type resources.

        :::image type="content" source="media/deployment-arc-register-server-permissions/arc-servers-registered-1.png" alt-text="Screenshot of the Azure Local machines in the resource group after the successful registration." lightbox="./media/deployment-arc-register-server-permissions/arc-servers-registered-1.png":::

> [!NOTE]
> Once an Azure Local machine is registered with Azure Arc, the only way to undo the registration is to install the operating system again on the machine.

## Assign required permissions for deployment

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
