--- 
title: Register your Azure Local machines with Azure Arc and assign permissions for deployment 
description: Learn how to Register your Azure Local machines with Azure Arc and assign permissions for deployment. 
author: alkohli
ms.topic: how-to
ms.date: 12/13/2024
ms.author: alkohli
ms.service: azure-stack-hci
ms.custom: devx-track-azurepowershell
---

# Register your machines and assign permissions for Azure Local, version 23H2 deployment

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to register your Azure Local machines and then set up the required permissions to deploy Azure Local, version 23H2.

## Prerequisites

::: moniker range="<=azloc-2408"
Before you begin, make sure you've completed the following prerequisites:

- Satisfy the [prerequisites and complete deployment checklist](./deployment-prerequisites.md).
- Prepare your [Active Directory](./deployment-prep-active-directory.md) environment.
- [Install the Azure Stack HCI operating system, version 23H2](./deployment-install-os.md) on each machine.
::: moniker-end

::: moniker range="azloc-24111"
Don't do anything!
::: moniker-end

- Register your subscription with the required resource providers (RPs). You can use either the [Azure portal](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider-1) or the [Azure PowerShell](/azure/azure-resource-manager/management/resource-providers-and-types#azure-powershell) to register. You need to be an owner or contributor on your subscription to register the following resource RPs:

    - *Microsoft.HybridCompute*
    - *Microsoft.GuestConfiguration*
    - *Microsoft.HybridConnectivity*
    - *Microsoft.AzureStackHCI*

    > [!NOTE]
    > The assumption is that the person registering the Azure subscription with the resource providers is a different person than the one who is registering the Azure Local machines with Arc.

- If you're registering the machines as Arc resources, make sure that you have the following permissions on the resource group where the machines were provisioned:

    - Azure Connected Machine Onboarding
    - Azure Connected Machine Resource Administrator

    To verify that you have these roles, follow these steps in the Azure portal:

    1. Go to the subscription that you use for the Azure Local deployment.
    1. Go to the resource group where you're planning to register the machines.
    1. In the left-pane, go to **Access Control (IAM)**.
    1. In the right-pane, go the **Role assignments**. Verify that you have the **Azure Connected Machine Onboarding** and **Azure Connected Machine Resource Administrator** roles assigned.

    <!--:::image type="content" source="media/deployment-arc-register-server-permissions/contributor-user-access-administrator-permissions.png" alt-text="Screenshot of the roles and permissions assigned in the deployment subscription." lightbox="./media/deployment-arc-register-server-permissions/contributor-user-access-administrator-permissions.png":::-->

- Check your Azure policies. Make sure that:
    - The Azure policies aren't blocking the installation of extensions.
    - The Azure policies aren't blocking the creation of certain resource types in a resource group.
    - The Azure policies aren't blocking the resource deployment in certain locations.

## Register machines with Azure Arc

> [!IMPORTANT]
> Run these steps as a local administrator on every Azure Local machine that you intend to cluster.

<!-- 1. Install the [Arc registration script](https://www.powershellgallery.com/packages/AzSHCI.ARCInstaller) from PSGallery. **This step is only required if you're using an OS ISO that's older than 2408**. For more information, see [What's new in 2408](../whats-new.md#features-and-improvements-in-2408).

    # [PowerShell](#tab/powershell)
    ```powershell
    #Register PSGallery as a trusted repo
    Register-PSRepository -Default -InstallationPolicy Trusted

    #Install required PowerShell modules in your machine for registration
    Install-Module Az.Accounts -RequiredVersion 3.0.0
    Install-Module Az.Resources -RequiredVersion 6.12.0
    Install-Module Az.ConnectedMachine -RequiredVersion 0.8.0
    

    #Install Arc registration script from PSGallery 
    Install-Module AzsHCI.ARCinstaller
    ```
    # [Output](#tab/output)
    Here's a sample output of the installation:

    ```output
    PS C:\Users\SetupUser> Install-Module Az.Accounts -RequiredVersion 3.0.0
    PS C:\Users\SetupUser> Install-Module Az.Resources -RequiredVersion 6.12.0
    PS C:\Users\SetupUser> Install-Module Az.ConnectedMachine -RequiredVersion 0.8.0
    PS C:\Users\SetupUser> Install-Module -Name AzSHCI.ARCInstaller                                           
    NuGet provider is required to continue                                                                                  
    PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based repositories. The NuGet  provider must be available in 'C:\Program Files\PackageManagement\ProviderAssemblies' or
    'C:\Users\SetupUser\AppData\Local\PackageManagement\ProviderAssemblies'. You can also install the NuGet provider by
    running 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'. Do you want PowerShellGet to install
    and import the NuGet provider now?
    [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y
    PS C:\Users\SetupUser>
    ``` -->

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
2. Connect to your Azure account and set the subscription. You'll need to open browser on the client that you're using to connect to the machine and open this page: `https://microsoft.com/devicelogin` and enter the provided code in the Azure CLI output to authenticate. Get the access token and account ID for the registration.  

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
    Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region $Region -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Proxy $ProxyServer
    ```

    If you're accessing the internet via a proxy server, you need to pass the `-proxy` parameter and provide the proxy server as `http://<Proxy server FQDN or IP address>:Port` when running the script.

    For a list of supported Azure regions, see [Azure requirements](../concepts/system-requirements-23h2.md#azure-requirements).

    # [Output](#tab/output)

    Here's a sample output of a successful registration of your machines:
    
    ```output
    PS C:\Users\Administrator> Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region $Region -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id
    >>
    Starting AzStackHci ArcIntegration Initialization
    Constructing node config using ARM Access Token
    Waiting for bootstrap to complete: InProgress
    =========SNIPPED=========SNIPPED=============
    Waiting for bootstrap to complete: InProgress
    Waiting for bootstrap to complete: InProgress
    Waiting for bootstrap to complete: Succeeded

    Log location: C:\Users\Administrator\.AzStackHci\AzStackHciArcIntegration.log
    Version Response
    ------- --------
    V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response
    V1      Microsoft.Azure.Edge.Bootstrap.ServiceContract.Data.Response
    Successfully triggered Arc boostrap support log collection. Waiting for 600 seconds to complete.
    Waiting for Arc bootstrap support logs to complete on '', retry count: 0.
    Arc bootstrap support log collection status is InProgress. Sleep for 10 seconds.
    Waiting for Arc bootstrap support logs to complete on '', retry count: 1.
    Arc bootstrap support log collection status is InProgress. Sleep for 10 seconds.
    Waiting for Arc bootstrap support logs to complete on '', retry count: 2.
    Arc boostrap support log collection completed successfully.

    PS C:\Users\Administrator>
    ```
    ---

4. After the script completes successfully on all the machines, verify that:


    1. Your machines are registered with Arc. Go to the Azure portal and then go to the resource group associated with the registration. The machines appear within the specified resource group as **Machine - Azure Arc** type resources.

        :::image type="content" source="media/deployment-arc-register-server-permissions/arc-servers-registered-1.png" alt-text="Screenshot of the Azure Local machines in the resource group after the successful registration." lightbox="./media/deployment-arc-register-server-permissions/arc-servers-registered-1.png":::

    1. The mandatory Azure Local extensions are installed on your machines. From the resource group, select the registered machine. Go to the **Extensions**. The mandatory extensions show up in the right pane.

        :::image type="content" source="media/deployment-arc-register-server-permissions/mandatory-extensions-installed-registered-servers.png" alt-text="Screenshot of the Azure Local registered machines with mandatory extensions installed." lightbox="./media/deployment-arc-register-server-permissions/mandatory-extensions-installed-registered-servers.png":::

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
 
    <!--:::image type="content" source="media/deployment-arc-register-server-permissions/add-role-assignment-3.png" alt-text="Screenshot of the review + Create tab in Add role assignment for Azure Local deployment." lightbox="./media/deployment-arc-register-server-permissions/add-role-assignment-3.png":::-->

1. In the right pane, go to **Role assignments**. Verify that the deployment user has all the configured roles.

    <!--:::image type="content" source="media/deployment-arc-register-server-permissions/add-role-assignment-4.png" alt-text="Screenshot of the Current role assignment in Access control in resource group for Azure Local deployment." lightbox="./media/deployment-arc-register-server-permissions/add-role-assignment-4.png":::-->

1. In the Azure portal go to **Microsoft Entra Roles and Administrators** and assign the **Cloud Application Administrator** role permission at the Microsoft Entra tenant level.

    :::image type="content" source="media/deployment-arc-register-server-permissions/cloud-application-administrator-role-at-tenant.png" alt-text="Screenshot of the Cloud Application Administrator permission at the tenant level." lightbox="./media/deployment-arc-register-server-permissions/cloud-application-administrator-role-at-tenant.png":::

    > [!NOTE]
    > The Cloud Application Administrator permission is temporarily needed to create the service principal. After deployment, this permission can be removed.

## Next steps

After setting up the first machine in your instance, you're ready to deploy using Azure portal:

- [Deploy using Azure portal](./deploy-via-portal.md).
