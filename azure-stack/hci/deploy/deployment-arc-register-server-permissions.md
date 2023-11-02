--- 
title: Register your Azure Stack HCI servers with Azure Arc and assign permissions for deployment (preview) 
description: Learn how to Register your Azure Stack HCI servers with Azure Arc and assign permissions for deployment (preview). 
author: alkohli
ms.topic: how-to
ms.date: 11/02/2023
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


- If you are registering the servers, make sure that you have the **Cloud Application Administrator** role in the tenant used for the deployment. To get the tenant ID and assign the Cloud Application Administrator role, follow these steps: 
    1. In the Azure portal, go to the **Microsoft Entra ID** resource. In the right pane, select **Tenant ID**.
        :::image type="content" source="media/deployment-arc-register-server-permissions/tenant-id.png" alt-text="Screenshot of the tenant ID in Microsoft Entra ID in Azure portal." lightbox="./media/deployment-arc-register-server-permissions/tenant-id.png":::
    1. Go to the **Users** section. Select the user and go to **Assigned roles**. 
    1. Select **+ Add assignments** and assign the **Cloud Application Administrator** role.

## Register servers with Azure Arc

> [!IMPORTANT]
> Run these steps on every Azure Stack HCI server that you intend to cluster.

1. Install the [Arc registration script](https://www.powershellgallery.com/packages/AzSHCI.ARCInstaller/0.1.2489.42) from PSGallery.

    ```powershell
    #Install Arc registration script from PSGallery
    Install-Module AzsHCI.ARCinstaller

    #Install required PowerShell modules in your node for registration
    Install-Module Az.Accounts -Force
    Install-Module Az.ConnectedMachine -Force
    Install-Module Az.Resources -Force
    ```
    
    Here's a sample output of the installation:

    ```output
    PS C:\Users\SetupUser> Install-Module -Name AzSHCI.ARCInstaller                                                                                                                                                                                 
    NuGet provider is required to continue                                                                                  
    PowerShellGet requires NuGet provider version '2.8.5.201' or newer to interact with NuGet-based repositories. The NuGet  provider must be available in 'C:\Program Files\PackageManagement\ProviderAssemblies' or
    'C:\Users\SetupUser\AppData\Local\PackageManagement\ProviderAssemblies'. You can also install the NuGet provider by
    running 'Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force'. Do you want PowerShellGet to install
    and import the NuGet provider now?
    [Y] Yes  [N] No  [S] Suspend  [?] Help (default is "Y"): Y
    
    Untrusted repository
    You are installing the modules from an untrusted repository. If you trust this repository, change its
    InstallationPolicy value by running the Set-PSRepository cmdlet. Are you sure you want to install the modules from
    'PSGallery'?
    [Y] Yes  [A] Yes to All  [N] No  [L] No to All  [S] Suspend  [?] Help (default is "N"): Y
    PS C:\Users\SetupUser>
    
    PS C:\Users\SetupUser> Install-Module Az.Accounts -Force
    PS C:\Users\SetupUser> Install-Module Az.ConnectedMachine -Force
    PS C:\Users\SetupUser> Install-Module Az.Resources -Force
    ```

1. Set the parameters. The script takes in the following parameters:
    
    |Parameters  |Description  |
    |------------|-------------|
    |`SubscriptionID`    |The ID of the subscription used to register your servers with Azure Arc.         |
    |`TenantID`          |The tenant ID used to register your servers with Azure Arc. Go to your Microsoft Entra ID and copy the tenant ID property.       |
    |`ResourceGroup`     |The resource group precreated for Arc registration of the servers. A resource group is created if one does not exist.         |
    |`Region`            |The Azure region used for registration. For this release, only `eastus` is supported.          |
    |`AccountID`         |The user who will register and deploy the cluster.         |
    |`DeviceCode`        |The device code displayed in the console at `https://microsoft.com/devicelogin` and is used to sign in to the device.         |
    

   ```powershell
    #Define the subscription where you want to register your server as Arc device
    $Subscription = "YourSubscriptionID"
    
    #Define the resource group where you want to register your server as Arc device
    $RG = "YourResourceGroupName"
    
    #Define the tenant you will use to register your server as Arc device
    $Tenant = "YourTenantID"
    ```

    Here's a sample output of the parameters:

    ```output
    PS C:\Users\SetupUser> $Subscription = "<Subscription ID>"
    PS C:\Users\SetupUser> $RG = "myashcirg"
    PS C:\Users\SetupUser> $Tenant = "<Tenant ID>"
    ```

1. Connect to your Azure account and set the subscription. Get the access token and account ID for the registration.  

    ```powershell
    #Connect to your Azure account and Subscription
    Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode

    #Get the Access Token for the registration
    $ARMtoken = (Get-AzAccessToken).Token

    #Get the Account ID for the registration
    $id = (Get-AzContext).Account.Id   
    ``` 

    Here's a sample output of the parameters and authentication:

    ```output
    PS C:\Users\SetupUser> Connect-AzAccount -SubscriptionId $Subscription -TenantId $Tenant -DeviceCode
    WARNING: To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code A44KHK5B5
    to authenticate.
    
    Account               SubscriptionName      TenantId                             Environment
    -------               ----------------      --------                             -----------
    guspinto@contoso.com AzureStackHCI_Content <Tenant ID> AzureCloud

    PS C:\Users\SetupUser> $ARMtoken = (Get-AzAccessToken).Token
    PS C:\Users\SetupUser> $id = (Get-AzContext).Account.Id
    ```
 
1. Finally run the Arc registration script.

    ```powershell
    #Invoke the registration script. For this preview release, only eastus region is supported.
    Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region eastus -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Force  
    ```

Here is a sample output of a successful registration of your servers:

```output
PS C:\Users\SetupUser> Invoke-AzStackHciArcInitialization -SubscriptionID $Subscription -ResourceGroup $RG -TenantID $Tenant -Region eastus -Cloud "AzureCloud" -ArmAccessToken $ARMtoken -AccountID $id -Force
Installing and Running Azure Stack HCI Environment Checker

==================================SNIPPED=========================SNIPPED===============================
Installing Hyper-V Management Tools 
Starting AzStackHci ArcIntegration Initialization
Installing Azure Connected Machine Agent
Total Physical Memory:         261,800 MB  
PowerShell version: 5.1.25398.469
.NET Framework version: 4.8.9032 
Downloading agent package from https://aka.ms/AzureConnectedMachineAgent to C:\Users\SETUPU~1\AppData\Local\Temp\2\AzureConnectedMachineAgent.msi
Installing agent package
Installation of azcmagent completed successfully
0  
Connecting to Azure using ARM Access Token
Connected to Azure successfully
Microsoft.HybridCompute RP already registered, skipping registration
Microsoft.GuestConfiguration RP already registered, skipping registration
Microsoft.HybridConnectivity RP already registered, skipping registration
Microsoft.AzureStackHCI RP already registered, skipping                                                     
INFO    Connecting machine to Azure... This might take a few minutes.
INFO    Testing connectivity to endpoints that are needed to connect to Azure... This might take a few minutes.
20% [==>            ]                                                                                                   
30% [===>           ]                                                                                                   
INFO    Creating resource in Azure...                 
Correlation ID=6ba25d07-e1a4-4b25-bcd9-117eed925fae Resource ID=/subscriptions/bf83292c-7cb3-40e4-949a-c9c4caa79b3e/resourceGroups/myashcirg/providers/Microsoft.HybridCompute/machines/ms309host                   
60% [========>      ]         
80% [===========>   ]              
100% [===============]              
INFO    Connected machine to Azure
INFO    Machine overview page: https://portal.azure.com/#@72f988bf-86f1-41af-91ab-2d7cd011db47/resource/subscriptions/bf83292c-7cb3-40e4-949a-c9c4caa79b3e/resourceGroups/myashcirg/providers/Microsoft.HybridCompute/machines/ms309host/overview
Connected Azure ARC agent successfully
Successfully got the content from IMDS endpoint
Successfully got Object Id for Arc Installation 224366fa-xxxx-xxxx-xxxx-6495878da7af
$Checking if Azure Stack HCI Device Management Role is assigned already for SPN with Object ID: 224366fa-xxxx-xxxx-xxxx-6495878da7af
Assigning Azure Stack HCI Device Management Role to Object : 224366fa-xxxx-xxxx-xxxx-6495878da7af
$Successfully assigned Azure Stack HCI Device Management Role to Object Id 224366fa-xxxx-xxxx-xxxx-6495878da7af
Successfully assigned permission Azure Stack HCI Device Management Service Role to create or update Edge Devices on the resource group
$Checking if Azure Connected Machine Resource Manager is assigned already for SPN with Object ID: 224366fa-xxxx-xxxx-xxxx-6495878da7af
Assigning Azure Connected Machine Resource Manager to Object : 224366fa-xxxx-xxxx-xxxx-6495878da7af
$Successfully assigned Azure Connected Machine Resource Manager to Object Id 224366fa-xxxx-xxxx-xxxx-6495878da7af
Successfully assigned the Azure Connected Machine Resource Nanager role on the resource group
$Checking if Reader is assigned already for SPN with Object ID: 224366fa-xxxx-xxxx-xxxx-6495878da7af
Assigning Reader to Object : 224366fa-xxxx-xxxx-xxxx-6495878da7af
$Successfully assigned Reader to Object Id 224366fa-xxxx-xxxx-xxxx-6495878da7af
Successfully assigned the reader Resource Nanager role on the resource group
Installing  TelemetryAndDiagnostics Extension
Successfully triggered  TelemetryAndDiagnostics Extension installation
Installing  DeviceManagement Extension
Successfully triggered  DeviceManagementExtension installation
Installing LcmController Extension
Successfully triggered  LCMController Extension installation
Please verify that the extensions are successfully installed before continuing...

Log location: C:\Users\SetupUser\.AzStackHci\AzStackHciEnvironmentChecker.log
Report location: C:\Users\SetupUser\.AzStackHci\AzStackHciEnvironmentReport.json
Use -Passthru parameter to return results as a PSObject.
PS C:\Users\SetupUser>
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


