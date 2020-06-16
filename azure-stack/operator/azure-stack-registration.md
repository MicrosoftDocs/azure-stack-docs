---
title: Register Azure Stack Hub with Azure
titleSuffix: Azure Stack Hub
description: Learn how to register Azure Stack Hub integrated systems with Azure so you can download Azure Marketplace items and set up data reporting. 
author: IngridAtMicrosoft

ms.topic: how-to
ms.date: 04/06/2020
ms.author: inhenkel
ms.reviewer: avishwan
ms.lastreviewed: 03/04/2019
zone_pivot_groups: state-connected-disconnected

# Intent: As an Azure Stack operator, I want to register my Azure Stack with Azure so I can download marketplace items and set up data reporting.
# Keyword: register azure stack (registration)

---


# Register Azure Stack Hub with Azure

Register Azure Stack Hub with Azure so you can download Azure Marketplace items from Azure and set up commerce data reporting back to Microsoft. After you register Azure Stack Hub, usage is reported to Azure commerce and you can see it under the Azure billing Subscription ID used for registration.

The information in this article describes registering Azure Stack Hub integrated systems with Azure. For information about registering the ASDK with Azure, see [Azure Stack Hub registration](../asdk/asdk-register.md) in the ASDK documentation.

> [!IMPORTANT]  
> Registration is required to support full Azure Stack Hub functionality, including offering items in the marketplace. You'll be in violation of Azure Stack Hub licensing terms if you don't register when using the pay-as-you-use billing model. To learn more about Azure Stack Hub licensing models, see the [How to buy page](https://azure.microsoft.com/overview/azure-stack/how-to-buy/).

## Prerequisites

Complete the following prerequisites before you register:

- Verify your credentials.
- Set the PowerShell language mode.
- Install PowerShell for Azure Stack Hub.
- Download the Azure Stack Hub tools.
- Determine your billing model.
- Determine your unique registration name.

### Verify your credentials

Before registering Azure Stack Hub with Azure, you must have:

- The subscription ID for an Azure subscription. Only EA, CSP, or CSP shared services subscriptions are supported for registration. CSPs need to decide whether to [use a CSP or APSS subscription](azure-stack-add-manage-billing-as-a-csp.md#create-a-csp-or-apss-subscription).<br><br>To get the ID, sign in to Azure, click **All services**. Then, under the **GENERAL** category, select **Subscriptions**, click the subscription you want to use, and under **Essentials** you can find the Subscription ID. As a best practice, use separate subscriptions for production and dev or test environments. 

  > [!Note]  
  > Germany cloud subscriptions aren't currently supported.

- The username and password for an account that's an owner for the subscription.

- The user account needs to have access to the Azure subscription and have permissions to create identity apps and service principals in the directory associated with that subscription. We recommend that you register Azure Stack Hub with Azure using least-privilege administration. For more information on how to create a custom role definition that limits access to your subscription for registration, see [create a registration role for Azure Stack Hub](azure-stack-registration-role.md).

- Registered the Azure Stack Hub resource provider (see the following Register Azure Stack Hub Resource Provider section for details).

After registration, Azure Active Directory (Azure AD) global administrator permission isn't required. However, some operations may require the global admin credential (for example, a resource provider installer script or a new feature requiring a permission to be granted). You can either temporarily reinstate the account's global admin permissions or use a separate global admin account that's an owner of the *default provider subscription*.

The user who registers Azure Stack Hub is the owner of the service principal in Azure AD. Only the user who registered Azure Stack Hub can modify the Azure Stack Hub registration. If a non-admin user that's not an owner of the registration service principal attempts to register or re-register Azure Stack Hub, they may come across a 403 response. A 403 response indicates the user has insufficient permissions to complete the operation.

If you don't have an Azure subscription that meets these requirements, you can [create a free Azure account here](https://azure.microsoft.com/free/?b=17.06). Registering Azure Stack Hub incurs no cost on your Azure subscription.

> [!NOTE]
> If you have more than one Azure Stack Hub, a best practice is to register each Azure Stack Hub to its own subscription. This makes it easier for you to track usage.

### Set the PowerShell language mode

To successfully register Azure Stack Hub, the PowerShell language mode must be set to **FullLanguageMode**.  To verify that the current language mode is set to full, open an elevated PowerShell window and run the following PowerShell cmdlets:

```powershell  
$ExecutionContext.SessionState.LanguageMode
```

Ensure the output returns **FullLanguageMode**. If any other language mode is returned, registration needs to be run on another machine or the language mode needs to be set to **FullLanguageMode** before continuing.

### Install PowerShell for Azure Stack Hub

Use the latest PowerShell for Azure Stack Hub to register with Azure.

If the latest version isn't already installed, see [install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).

### Download the Azure Stack Hub tools

The Azure Stack Hub tools GitHub repository contains PowerShell modules that support Azure Stack Hub functionality, including registration functionality. During the registration process, you need to import and use the **RegisterWithAzure.psm1** PowerShell module (found in the Azure Stack Hub tools repository) to register your Azure Stack Hub instance with Azure.

To ensure you're using the latest version, delete any existing versions of the Azure Stack Hub tools and [download the latest version from GitHub](azure-stack-powershell-download.md) before registering with Azure.

### Determine your billing model
::: zone pivot="state-connected"
 A connected deployment allows Azure Stack Hub to connect to the internet, and to Azure. You can also use either Azure AD or Active Directory Federation Services (AD FS) as your identity store, and choose from two billing models: pay-as-you-use or capacity-based. You specify the billing model later, while running the registration script.
::: zone-end

::: zone pivot="state-disconnected"
 A disconnected deployment allows you to use Azure Stack Hub without a connection to the internet. With a disconnected deployment, you're limited to an AD FS identity store and the capacity-based billing model. You specify the billing model later, while running the registration script.
::: zone-end

### Determine your unique registration name

When you run the registration script, you must provide a unique registration name. An easy way to associate your Azure Stack Hub subscription with an Azure registration is to use your Azure Stack Hub **Cloud ID**.

> [!NOTE]
> Azure Stack Hub registrations using the capacity-based billing model will need to change the unique name when re-registering after those yearly subscriptions expire unless you [delete the expired registration](#renew-or-change-registration) and re-register with Azure.

To determine the Cloud ID for your Azure Stack Hub deployment, open PowerShell as an admin on a computer that can access the Privileged Endpoint, run the following commands, and then record the **CloudID** value:

```powershell
Run: Enter-PSSession -ComputerName <privileged endpoint computer name> -ConfigurationName PrivilegedEndpoint
Run: Get-AzureStackStampInformation
```

::: zone pivot="state-connected"
## Register with pay-as-you-use billing

Use these steps to register Azure Stack Hub with Azure using the pay-as-you-use billing model.

> [!Note]  
> All these steps must be run from a computer that has access to the privileged endpoint (PEP). For details about the PEP, see [Using the privileged endpoint in Azure Stack Hub](azure-stack-privileged-endpoint.md).

Connected environments can access the internet and Azure. For these environments, you need to register the Azure Stack Hub resource provider with Azure and then configure your billing model.

1. To register the Azure Stack Hub resource provider with Azure, start PowerShell ISE as an administrator and use the following PowerShell cmdlets with the **EnvironmentName** parameter set to the appropriate Azure subscription type (see parameters below).

2. Add the Azure account that you used to register Azure Stack Hub. To add the account, run the **Add-AzureRmAccount** cmdlet. You're prompted to enter your Azure account credentials and you may have to use two-factor authentication based on your account's configuration.

   ```powershell
   Add-AzureRmAccount -EnvironmentName "<environment name>"
   ```

   | Parameter | Description |  
   |-----|-----|
   | EnvironmentName | The Azure cloud subscription environment name. Supported environment names are **AzureCloud**, **AzureUSGovernment**, or if using a China Azure Subscription, **AzureChinaCloud**.  |

   >[!Note]
   > If your session expires, your password has changed, or you simply wish to switch accounts, run the following cmdlet before you sign in using Add-AzureRmAccount: `Remove-AzureRmAccount-Scope Process`

3. If you have multiple subscriptions, run the following command to select the one you want to use:  

   ```powershell  
   Get-AzureRmSubscription -SubscriptionID '<Your Azure Subscription GUID>' | Select-AzureRmSubscription
   ```

4. Run the following command to register the Azure Stack Hub resource provider in your Azure subscription:

   ```powershell  
   Register-AzureRmResourceProvider -ProviderNamespace Microsoft.AzureStack
   ```

5. Start PowerShell ISE as an administrator and navigate to the **Registration** folder in the **AzureStack-Tools-master** directory created when you downloaded the Azure Stack Hub tools. Import the **RegisterWithAzure.psm1** module using PowerShell:

   ```powershell  
   Import-Module .\RegisterWithAzure.psm1
   ```

6. Next, in the same PowerShell session, ensure you're signed in to the correct Azure PowerShell context. This context would be the Azure account that was used to register the Azure Stack Hub resource provider previously. PowerShell to run:

   ```powershell  
   Connect-AzureRmAccount -Environment "<environment name>"
   ```

   | Parameter | Description |  
   |-----|-----|
   | EnvironmentName | The Azure cloud subscription environment name. Supported environment names are **AzureCloud**, **AzureUSGovernment**, or if using a China Azure Subscription, **AzureChinaCloud**.  |

7. In the same PowerShell session, run the **Set-AzsRegistration** cmdlet. PowerShell to run:  

   ```powershell  
   $CloudAdminCred = Get-Credential -UserName <Privileged endpoint credentials> -Message "Enter the cloud domain credentials to access the privileged endpoint."
   $RegistrationName = "<unique-registration-name>"
   Set-AzsRegistration `
      -PrivilegedEndpointCredential $CloudAdminCred `
      -PrivilegedEndpoint <PrivilegedEndPoint computer name> `
      -BillingModel PayAsYouUse `
      -RegistrationName $RegistrationName
   ```
   For more information on the Set-AzsRegistration cmdlet, see [Registration reference](#registration-reference).

   The process takes between 10 and 15 minutes. When the command completes, you see the message **"Your environment is now registered and activated using the provided parameters."**

## Register with capacity billing

Use these steps to register Azure Stack Hub with Azure using the capacity billing model.

> [!Note]  
> All these steps must be run from a computer that has access to the privileged endpoint (PEP). For details about the PEP, see [Using the privileged endpoint in Azure Stack Hub](azure-stack-privileged-endpoint.md).

Connected environments can access the internet and Azure. For these environments, you need to register the Azure Stack Hub resource provider with Azure and then configure your billing model.

1. To register the Azure Stack Hub resource provider with Azure, start PowerShell ISE as an administrator and use the following PowerShell cmdlets with the **EnvironmentName** parameter set to the appropriate Azure subscription type (see parameters below).

2. Add the Azure account that you used to register Azure Stack Hub. To add the account, run the **Add-AzureRmAccount** cmdlet. You're prompted to enter your Azure account credentials and you may have to use two-factor authentication based on your account's configuration.

   ```powershell  
   Connect-AzureRmAccount -Environment "<environment name>"
   ```

   | Parameter | Description |  
   |-----|-----|
   | EnvironmentName | The Azure cloud subscription environment name. Supported environment names are **AzureCloud**, **AzureUSGovernment**, or if using a China Azure Subscription, **AzureChinaCloud**.  |

3. If you have multiple subscriptions, run the following command to select the one you want to use:  

   ```powershell  
   Get-AzureRmSubscription -SubscriptionID '<Your Azure Subscription GUID>' | Select-AzureRmSubscription
   ```

4. Run the following command to register the Azure Stack Hub resource provider in your Azure subscription:

   ```powershell  
   Register-AzureRmResourceProvider -ProviderNamespace Microsoft.AzureStack
   ```

5. Start PowerShell ISE as an administrator and navigate to the **Registration** folder in the **AzureStack-Tools-master** directory created when you downloaded the Azure Stack Hub tools. Import the **RegisterWithAzure.psm1** module using PowerShell:

   ```powershell  
   $CloudAdminCred = Get-Credential -UserName <Privileged endpoint credentials> -Message "Enter the cloud domain credentials to access the privileged endpoint."
   $RegistrationName = "<unique-registration-name>"
   Set-AzsRegistration `
      -PrivilegedEndpointCredential $CloudAdminCred `
      -PrivilegedEndpoint <PrivilegedEndPoint computer name> `
      -AgreementNumber <EA agreement number> `
      -BillingModel Capacity `
      -RegistrationName $RegistrationName
   ```
   > [!Note]  
   > You can disable usage reporting with the UsageReportingEnabled parameter for the **Set-AzsRegistration** cmdlet by setting the parameter to false. 
   
   For more information on the Set-AzsRegistration cmdlet, see [Registration reference](#registration-reference).
::: zone-end

::: zone pivot="state-disconnected"
## Register with capacity billing

If you're registering Azure Stack Hub in a disconnected environment (with no internet connectivity), you need to get a registration token from the Azure Stack Hub environment. Then use that token on a computer that can connect to Azure and has PowerShell for Azure Stack Hub installed.  

### Get a registration token from the Azure Stack Hub environment

1. Start PowerShell ISE as an administrator and navigate to the **Registration** folder in the **AzureStack-Tools-master** directory created when you downloaded the Azure Stack Hub tools. Import the **RegisterWithAzure.psm1** module:  

   ```powershell  
   Import-Module .\RegisterWithAzure.psm1
   ```

2. To get the registration token, run the following PowerShell cmdlets:  

   ```Powershell
   $FilePathForRegistrationToken = "$env:SystemDrive\RegistrationToken.txt"
   $RegistrationToken = Get-AzsRegistrationToken -PrivilegedEndpointCredential $YourCloudAdminCredential -UsageReportingEnabled:$False -PrivilegedEndpoint $YourPrivilegedEndpoint -BillingModel Capacity -AgreementNumber '<EA agreement number>' -TokenOutputFilePath $FilePathForRegistrationToken
   ```
   For more information on the Get-AzsRegistrationToken cmdlet, see [Registration reference](#registration-reference).

   > [!Tip]  
   > The registration token is saved in the file specified for *$FilePathForRegistrationToken*. You can change the filepath or filename at your discretion.

3. Save this registration token for use on the Azure-connected machine. You can copy the file or the text from *$FilePathForRegistrationToken*.

### Connect to Azure and register

On the computer that is connected to the internet, do the same steps to import the RegisterWithAzure.psm1 module and sign in to the correct Azure PowerShell context. Then call Register-AzsEnvironment. Specify the registration token to register with Azure. If you're registering more than one instance of Azure Stack Hub using the same Azure Subscription ID, specify a unique registration name.

You need your registration token and a unique token name.

1. Start PowerShell ISE as an administrator and navigate to the **Registration** folder in the **AzureStack-Tools-master** directory created when you downloaded the Azure Stack Hub tools. Import the **RegisterWithAzure.psm1** module:  

   ```powershell  
   Import-Module .\RegisterWithAzure.psm1
   ```

2. Then run the following PowerShell cmdlets:  

    ```powershell  
    $RegistrationToken = "<Your Registration Token>"
    $RegistrationName = "<unique-registration-name>"
    Register-AzsEnvironment -RegistrationToken $RegistrationToken -RegistrationName $RegistrationName
    ```

Optionally, you can use the Get-Content cmdlet to point to a file that contains your registration token.

You need your registration token and a unique token name.

1. Start PowerShell ISE as an administrator and navigate to the **Registration** folder in the **AzureStack-Tools-master** directory created when you downloaded the Azure Stack Hub tools. Import the **RegisterWithAzure.psm1** module:  

    ```powershell  
    Import-Module .\RegisterWithAzure.psm1
    ```

2. Then run the following PowerShell cmdlets:  

    ```powershell  
    $RegistrationToken = Get-Content -Path '<Path>\<Registration Token File>'
    Register-AzsEnvironment -RegistrationToken $RegistrationToken -RegistrationName $RegistrationName
    ```

  > [!Note]  
  > Save the registration resource name and the registration token for future reference.

### Retrieve an Activation Key from Azure Registration Resource

Next, you need to retrieve an activation key from the registration resource created in Azure during Register-AzsEnvironment.

To get the activation key, run the following PowerShell cmdlets:  

  ```Powershell
  $RegistrationResourceName = "<unique-registration-name>"
  $KeyOutputFilePath = "$env:SystemDrive\ActivationKey.txt"
  $ActivationKey = Get-AzsActivationKey -RegistrationName $RegistrationResourceName -KeyOutputFilePath $KeyOutputFilePath
  ```

  > [!Tip]  
  > The activation key is saved in the file specified for *$KeyOutputFilePath*. You can change the filepath or filename at your discretion.

### Create an Activation Resource in Azure Stack Hub

Return to the Azure Stack Hub environment with the file or text from the activation key created from Get-AzsActivationKey. Next create an activation resource in Azure Stack Hub using that activation key. To create an activation resource, run the following PowerShell cmdlets:

  ```Powershell
  $ActivationKey = "<activation key>"
  New-AzsActivationResource -PrivilegedEndpointCredential $YourCloudAdminCredential -PrivilegedEndpoint $YourPrivilegedEndpoint -ActivationKey $ActivationKey
  ```

Optionally, you can use the Get-Content cmdlet to point to a file that contains your registration token:

  ```Powershell
  $ActivationKey = Get-Content -Path '<Path>\<Activation Key File>'
  New-AzsActivationResource -PrivilegedEndpointCredential $YourCloudAdminCredential -PrivilegedEndpoint $YourPrivilegedEndpoint -ActivationKey $ActivationKey
  ```
::: zone-end

## Verify Azure Stack Hub registration

You can use the **Region management** tile to verify that the Azure Stack Hub registration was successful. This tile is available on the default dashboard in the administrator portal. The status can be registered, or not registered. If registered, it also shows the Azure subscription ID that you used to register your Azure Stack Hub along with the registration resource group and name.

1. Sign in to the Azure Stack Hub administrator portal `https://adminportal.local.azurestack.external`.

2. From the Dashboard, select **Region management**.

3. Select **Properties**. This blade shows the status and details of your environment. The status can be **Registered**, **Not registered**, or **Expired**.

    [![Region management tile in Azure Stack Hub administrator portal](media/azure-stack-registration/admin1sm.png "Region management tile")](media/azure-stack-registration/admin1.png#lightbox)

    If registered, the properties include:
    
    - **Registration subscription ID**: The Azure subscription ID registered and associated to Azure Stack Hub.
    - **Registration resource group**: The Azure resource group in the associated subscription containing the Azure Stack Hub resources.

4. You can use the Azure portal to view Azure Stack Hub registration resources, and then verify that the registration succeeded. Sign in to the [Azure portal](https://portal.azure.com) using an account associated to the subscription you used to register Azure Stack Hub. Select **All resources**, enable the **Show hidden types** checkbox, and select the registration name.

5. If the registration didn't succeed, you must re-register by following the [steps here](#change-the-subscription-you-use) to resolve the issue.  

Alternatively, you can verify if your registration was successful by using the Marketplace management feature. If you see a list of marketplace items in the Marketplace management blade, your registration was successful. However, in disconnected environments, you can't see marketplace items in Marketplace management.

> [!NOTE]
> After registration is complete, the active warning for not registering will no longer appear. In Azure Stack Hub releases before 1904, in disconnected scenarios, you see a message in Marketplace management asking you to register and activate your Azure Stack Hub, even if you have registered successfully. This message doesn't appear in release 1904 and later.

## Renew or change registration

::: zone pivot="state-connected"
You need to update or renew your registration in the following circumstances:

- After you renew your capacity-based yearly subscription.
- When you change your billing model.
- When you scale changes (add/remove nodes) for capacity-based billing.

### Prerequisites

You need the following information from the [administrator portal](#verify-azure-stack-hub-registration) to renew or change registration:

| Administrator portal | Cmdlet parameter | Notes | 
|-----|-----|-----|
| REGISTRATION SUBSCRIPTION ID | Subscription | Subscription ID used during previous registration |
| REGISTRATION RESOURCE GROUP | ResourceGroupName | Resource group under which the previous registration resource exists |
| REGISTRATION NAME | RegistrationName | Registration name used during previous registration |

### Change the subscription you use

If you want to change the subscription you use, you must first run the **Remove-AzsRegistration** cmdlet, then ensure you're signed in to the correct Azure PowerShell context. Then run **Set-AzsRegistration** with any changed parameters, including `<billing model>`. While running **Remove-AzsRegistration**, you must be signed in to the subscription used during the registration and use values of the `RegistrationName` and `ResourceGroupName` parameters as shown in the [administrator portal](#verify-azure-stack-hub-registration):

  ```powershell  
  # select the subscription used during the registration (shown in portal)
  Select-AzureRmSubscription -Subscription '<Registration subscription ID from portal>'
  # unregister using the parameter values from portal
  Remove-AzsRegistration -PrivilegedEndpointCredential $YourCloudAdminCredential -PrivilegedEndpoint $YourPrivilegedEndpoint -RegistrationName '<Registration name from portal>' -ResourceGroupName '<Registration resource group from portal>'
  # switch to new subscription id
  Select-AzureRmSubscription -Subscription '<New subscription ID>'
  # register 
  Set-AzsRegistration -PrivilegedEndpointCredential $YourCloudAdminCredential -PrivilegedEndpoint $YourPrivilegedEndpoint -BillingModel '<Billing model>' -RegistrationName '<Registration name>' --ResourceGroupName '<Registration resource group name>'
  ```

### Change billing model, how features are offered, or re-register your instance

This section applies if you want to change the billing model, how features are offered, or you want to re-register your instance. For all of these cases, you call the registration function to set the new values. You don't need to first remove the current registration. Sign in to the subscription ID shown in the [administrator portal](#verify-azure-stack-hub-registration), and then rerun registration with a new `BillingModel` value while keeping the `RegistrationName` and `ResourceGroupName` parameters values same as shown in the [administrator portal](#verify-azure-stack-hub-registration):

  ```powershell  
  # select the subscription used during the registration
  Select-AzureRmSubscription -Subscription '<Registration subscription ID from portal>'
  # rerun registration with new BillingModel (or same billing model in case of re-registration) but using other parameters values from portal
  Set-AzsRegistration -PrivilegedEndpointCredential $YourCloudAdminCredential -PrivilegedEndpoint $YourPrivilegedEndpoint -BillingModel '<New billing model>' -RegistrationName '<Registration name from portal>' -ResourceGroupName '<Registration resource group from portal>'
  ```
::: zone-end

::: zone pivot="state-disconnected"
You need to update or renew your registration in the following circumstances:

- After you renew your capacity-based yearly subscription.
- When you change your billing model.
- When you scale changes (add/remove nodes) for capacity-based billing.

### Remove the activation resource from Azure Stack Hub

You first need to remove the activation resource from Azure Stack Hub, and then the registration resource in Azure.  

To remove the activation resource in Azure Stack Hub, run the following PowerShell cmdlets in your Azure Stack Hub environment:  

  ```powershell
  Remove-AzsActivationResource -PrivilegedEndpointCredential $YourCloudAdminCredential -PrivilegedEndpoint $YourPrivilegedEndpoint
  ```

Next, to remove the registration resource in Azure, ensure you're on an Azure-connected computer, sign in to the correct Azure PowerShell context, and run the appropriate PowerShell cmdlets as described below.

You can use the registration token used to create the resource:  

  ```powershell
  $RegistrationToken = "<registration token>"
  Unregister-AzsEnvironment -RegistrationToken $RegistrationToken
  ```

Or you can use the registration name and registration resource group name from the [administrator portal](#verify-azure-stack-hub-registration):

  ```powershell
  Unregister-AzsEnvironment -RegistrationName '<Registration name from portal>' -ResourceGroupName '<Registration resource group from portal>'
  ```

### Re-register using connected steps

If changing your billing model from capacity billing in a disconnected state to consumption billing in a connected state, you will re-register following the [connected model steps](azure-stack-registration.md?pivots=state-connected#change-billing-model-how-features-are-offered-or-re-register-your-instance). 

>[!Note] 
>This does not change your identity model, only the billing mechanism, and you will still use ADFS as your identity source.

### Re-register using disconnected steps

You've now completely unregistered in a disconnected scenario and must repeat the steps for registering an Azure Stack Hub environment in a disconnected scenario.
::: zone-end

### Disable or enable usage reporting

For Azure Stack Hub environments that use a capacity billing model, turn off usage reporting with the **UsageReportingEnabled** parameter using either the **Set-AzsRegistration** or the **Get-AzsRegistrationToken** cmdlets. Azure Stack Hub reports usage metrics by default. Operators with capacity uses or supporting a disconnected environment need to turn off usage reporting.

::: zone pivot="state-connected"
Run the following PowerShell cmdlets:

   ```powershell  
   $CloudAdminCred = Get-Credential -UserName <Privileged endpoint credentials> -Message "Enter the cloud domain credentials to access the privileged endpoint."
   $RegistrationName = "<unique-registration-name>"
   Set-AzsRegistration `
      -PrivilegedEndpointCredential $CloudAdminCred `
      -PrivilegedEndpoint <PrivilegedEndPoint computer name> `
      -BillingModel Capacity
      -RegistrationName $RegistrationName
      -UsageReportingEnabled:$false
   ```
::: zone-end
::: zone pivot="state-disconnected"
1. To change the registration token, run the following PowerShell cmdlets:  

   ```Powershell
   $FilePathForRegistrationToken = $env:SystemDrive\RegistrationToken.txt
   $RegistrationToken = Get-AzsRegistrationToken -PrivilegedEndpointCredential -UsageReportingEnabled:$False
   $YourCloudAdminCredential -PrivilegedEndpoint $YourPrivilegedEndpoint -BillingModel Capacity -AgreementNumber '<EA agreement number>' -TokenOutputFilePath $FilePathForRegistrationToken
   ```

   > [!Tip]  
   > The registration token is saved in the file specified for *$FilePathForRegistrationToken*. You can change the filepath or filename at your discretion.

2. Save this registration token for use on the Azure connected machine. You can copy the file or the text from *$FilePathForRegistrationToken*.
::: zone-end

## Move a registration resource

Moving a registration resource between resource groups under the same subscription **is** supported for all environments. However, moving a registration resource between subscriptions is only supported for CSPs when both subscriptions resolve to the same Partner ID. For more information about moving resources to a new resource group, see [Move resources to new resource group or subscription](/azure/azure-resource-manager/resource-group-move-resources).

> [!IMPORTANT]
> To prevent accidental deletion of registration resources on the portal, the registration script automatically adds a lock to the resource. You must remove this lock before moving or deleting it. It's recommended that you add a lock to your registration resource to prevent accidental deletion.

## Registration reference

### Set-AzsRegistration

You can use **Set-AzsRegistration** to register Azure Stack Hub with Azure and enable or disable the offer of items in the marketplace and usage reporting.

To run the cmdlet, you need:

- A global Azure subscription of any type.
- To be signed in to Azure PowerShell with an account that's an owner or contributor to that subscription.

```powershell
Set-AzsRegistration [-PrivilegedEndpointCredential] <PSCredential> [-PrivilegedEndpoint] <String> [[-AzureContext]
    <PSObject>] [[-ResourceGroupName] <String>] [[-ResourceGroupLocation] <String>] [[-BillingModel] <String>]
    [-MarketplaceSyndicationEnabled] [-UsageReportingEnabled] [[-AgreementNumber] <String>] [[-RegistrationName]
    <String>] [<CommonParameters>]
```

| Parameter | Type | Description |
|-------------------------------|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| PrivilegedEndpointCredential | PSCredential | The credentials used to [access the privileged endpoint](azure-stack-privileged-endpoint.md#access-the-privileged-endpoint). The username is in the format **AzureStackDomain\CloudAdmin**. |
| PrivilegedEndpoint | String | A pre-configured remote PowerShell console that provides you with capabilities like log collection and other post deployment tasks. To learn more, refer to the [using the privileged endpoint](azure-stack-privileged-endpoint.md#access-the-privileged-endpoint) article. |
| AzureContext | PSObject |  |
| ResourceGroupName | String |  |
| ResourceGroupLocation | String |  |
| BillingModel | String | The billing model that your subscription uses. Allowed values for this parameter are: Capacity, PayAsYouUse, and Development. |
| MarketplaceSyndicationEnabled | True/False | Determines if the marketplace management feature is available in the portal. Set to true if registering with internet connectivity. Set to false if registering in disconnected environments. For disconnected registrations, the [offline syndication tool](azure-stack-download-azure-marketplace-item.md?pivots=state-disconnected) can be used for downloading marketplace items. |
| UsageReportingEnabled | True/False | Azure Stack Hub reports usage metrics by default. Operators with capacity uses or supporting a disconnected environment need to turn off usage reporting. Allowed values for this parameter are: True, False. |
| AgreementNumber | String | The number of the EA agreement under which the Capacity SKU for this Azure Stack was ordered. |
| RegistrationName | String | Set a unique name for the registration if you're running the registration script on more than one instance of Azure Stack Hub using the same Azure Subscription ID. The parameter has a default value of **AzureStackRegistration**. However, if you use the same name on more than one instance of Azure Stack Hub, the script fails. |

### Get-AzsRegistrationToken

Get-AzsRegistrationToken generates a registration token from the input parameters.

```powershell  
Get-AzsRegistrationToken [-PrivilegedEndpointCredential] <PSCredential> [-PrivilegedEndpoint] <String>
    [-BillingModel] <String> [[-TokenOutputFilePath] <String>] [-UsageReportingEnabled] [[-AgreementNumber] <String>]
    [<CommonParameters>]
```
| Parameter | Type | Description |
|-------------------------------|--------------|-------------|
| PrivilegedEndpointCredential | PSCredential | The credentials used to [access the privileged endpoint](azure-stack-privileged-endpoint.md#access-the-privileged-endpoint). The username is in the format **AzureStackDomain\CloudAdmin**. |
| PrivilegedEndpoint | String |  A pre-configured remote PowerShell console that provides you with capabilities like log collection and other post deployment tasks. To learn more, refer to the [using the privileged endpoint](azure-stack-privileged-endpoint.md#access-the-privileged-endpoint) article. |
| AzureContext | PSObject |  |
| ResourceGroupName | String |  |
| ResourceGroupLocation | String |  |
| BillingModel | String | The billing model that your subscription uses. Allowed values for this parameter are: Capacity, PayAsYouUse, and Development. |
| MarketplaceSyndicationEnabled | True/False |  |
| UsageReportingEnabled | True/False | Azure Stack Hub reports usage metrics by default. Operators with capacity uses or supporting a disconnected environment need to turn off usage reporting. Allowed values for this parameter are: True, False. |
| AgreementNumber | String |  |

## Registration failures

You might see one of the errors below while attempting to register your Azure Stack Hub:

- Could not retrieve mandatory hardware info for `$hostName`. Check physical host and connectivity, then try to rerun registration.

- Cannot connect to `$hostName` to get hardware info. Check physical host and connectivity, then try to rerun registration.

   Cause: this is typically because we try to obtain hardware details such as UUID, Bios, and CPU from the hosts to attempt activation and weren't able to due to the inability to connect to the physical host.

- Cloud identifier [`GUID`] is already registered. Reusing cloud identifiers is not allowed.

   Cause: this happens if your Azure Stack environment is already registered. If you want to re-register your environment with a different subscription or billing model, follow the [Renew or change registration steps](#renew-or-change-registration).

- When trying to access Marketplace management, an error occurs when trying to syndicate products.

   Cause: this usually happens when Azure Stack Hub is unable to access the registration resource. One common reason for this is that when an Azure subscription's directory tenant changes, it resets the registration. You can't access the Azure Stack Hub Marketplace or report usage if you've changed the subscription's directory tenant. You need to re-register to fix this issue.
::: zone pivot="state-disconnected"
- Marketplace management still asks you to register and activate your Azure Stack Hub even when you've already registered your stamp using the disconnected process.

   Cause: this is a known issue for disconnected environments, and requires you to [verify your registration status](#verify-azure-stack-hub-registration). In order to use Marketplace management, use [the offline tool](azure-stack-download-azure-marketplace-item.md?pivots=state-disconnected).
::: zone-end

## Next steps

[Download marketplace items from Azure](azure-stack-download-azure-marketplace-item.md)
