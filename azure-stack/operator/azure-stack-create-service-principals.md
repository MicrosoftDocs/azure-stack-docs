---
title: Use an app identity to access resources
description: Learn how to use an app identity to access Azure Stack Hub resources. An app identity can be used with role-based access control for sign-in and access to resources.
author: BryanLa
ms.author: bryanla
ms.topic: how-to
ms.date: 05/07/2020
ms.lastreviewed: 05/07/2020

# Intent: As an Azure Stack operator, I want to use an app identity to access resources. 
# Keyword: azure stack hub app identity service principal

---
# Use an app identity to access Azure Stack Hub resources
An application that needs to deploy or configure resources through Azure Resource Manager must be represented by its own identity. Just as a user is represented by a security principal called a user principal, an app is represented by a service principal. The service principal provides an identity for your app, allowing you to delegate only the necessary permissions to the app.  

As an example, you may have a configuration management app that uses Azure Resource Manager to inventory Azure resources. In this scenario, you can create a service principal, grant the "reader" role to that service principal, and limit the configuration management app to read-only access.

## Overview

Like a user, an app must present credentials during authentication. This authentication consists of two elements:

- An **Application ID**, sometimes referred to as a Client ID. A GUID that uniquely identifies the app's registration in your Active Directory tenant.
- A **secret** associated with the application ID. You can either generate a client secret string (similar to a password), or specify an X509 certificate (which uses its public key).

Running an app under its own identity is preferable to running it under the user's identity for the following reasons:

 - **Stronger credentials** - an app can sign in using an X509 certificate, instead of a textual shared secret/password.  
 - **More restrictive permissions** can be assigned to an app. Typically, these permissions are restricted to only what the app needs to do, known as the *principle of least privilege*.
 - **Credentials and permissions don't change as frequently** for an app as user credentials. For example, when the user's responsibilities change, password requirements dictate a change, or when a user leaves the company.

You start by creating a new app registration in your directory, which creates an associated [service principal object](/azure/active-directory/develop/developer-glossary#service-principal-object) to represent the app's identity within the directory. 

This article begins with the process of creating and managing a service principal, depending on the directory you chose for your Azure Stack Hub instance:

- **Azure Active Directory (Azure AD)**. Azure AD is a multi-tenant, cloud-based directory, and identity management service. You can use Azure AD with a connected Azure Stack Hub instance.
- **Active Directory Federation Services (AD FS)**. AD FS provides simplified, secured identity federation, and web single sign-on (SSO) capabilities. You can use AD FS with both connected and disconnected Azure Stack Hub instances.

Then you learn how to assign the service principal to a role, limiting its resource access.

## Manage an Azure AD app identity

If you deployed Azure Stack Hub with Azure AD as your identity management service, you create service principals just like you do for Azure. This section shows you how to perform the steps through the Azure portal. Check that you have the [required Azure AD permissions](/azure/active-directory/develop/howto-create-service-principal-portal#required-permissions) before beginning.

### Create a service principal that uses a client secret credential

In this section, you register your app using the Azure portal, which creates the service principal object in your Azure AD tenant. In this example, you specify a client secret credential, but the portal also supports X509 certificate-based credentials.

1. Sign in to the [Azure portal](https://portal.azure.com) using your Azure account.
2. Select **Azure Active Directory** > **App registrations** > **New registration**.
3. Provide a **name** for the app.
4. Select the appropriate **Supported account types**.
5. Under **Redirect URI**, select **Web**  as the app type, and (optionally) specify a redirect URI if your app requires it.
6. After setting the values, select **Register**. The app registration is created and the **Overview** page displays.
7. Copy the **Application ID** for use in your app code. This value is also referred to as the Client ID.
8. To generate a client secret, select the **Certificates & secrets** page. Select **New client secret**.
9. Provide a **description** for the secret, and an **expires** duration.
10. When done, select **Add**.
11. The value of the secret displays. Copy and save this value in another location, because you can't retrieve it later. You provide the secret with the Application ID in your client app for sign-in.

    ![Saved key in client secrets](./media/azure-stack-create-service-principal/create-service-principal-in-azure-stack-secret.png)

Now proceed to [Assign a role](#assign-a-role) to learn how to establish role-based access control for the app's identity.

## Manage an AD FS app identity

If you deployed Azure Stack Hub with AD FS as your identity management service, you must use PowerShell to manage your app's identity. Examples are provided below for managing service principal credentials, demonstrating both an X509 certificate and a client secret.

The scripts must be run in an elevated ("Run as administrator") PowerShell console, which opens another session to a VM that hosts a privileged endpoint for your Azure Stack Hub instance. Once the privileged endpoint session has been established, additional cmdlets will execute and manage the service principal. For more information about the privileged endpoint, see [Using the privileged endpoint in Azure Stack Hub](azure-stack-privileged-endpoint.md).

### Create a service principal that uses a certificate credential

When creating a certificate credential, the following requirements must be met:

 - For production, the certificate must be issued from either an internal Certificate Authority or a Public Certificate Authority. When using a public authority, you must include the authority in the base operating system image as part of the Microsoft Trusted Root Authority Program. You can find the full list at [Microsoft Trusted Root Certificate Program: Participants](https://gallery.technet.microsoft.com/Trusted-Root-Certificate-123665ca). An example of creating a "self-signed" test certificate will also be shown later during [Update a certificate credential](#update-a-certificate-credential). 
 - The cryptographic provider must be specified as a Microsoft legacy Cryptographic Service Provider (CSP) key provider.
 - The certificate format must be in PFX file, as both the public and private keys are required. Windows servers use .pfx files that contain the public key file (TLS/SSL certificate file) and the associated private key file.
 - Your Azure Stack Hub infrastructure must have network access to the certificate authority's Certificate Revocation List (CRL) location published in the certificate. This CRL must be an HTTP endpoint.

Once you have a certificate, use the PowerShell script below to register your app and create a service principal. You also use the service principal to sign in to Azure. Substitute your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack Hub instance. | "AzS-ERCS01" |
| \<YourCertificateLocation\> | The location of your X509 certificate in the local certificate store. | "Cert:\CurrentUser\My\AB5A8A3533CC7AA2025BF05120117E06DE407B34" |
| \<YourAppName\> | A descriptive name for the new app registration. | "My management tool" |

1. Open an elevated Windows PowerShell session, and run the following script:

   ```powershell  
    # Sign in to PowerShell interactively, using credentials that have access to the VM running the Privileged Endpoint (typically <domain>\cloudadmin)
    $Creds = Get-Credential

    # Create a PSSession to the Privileged Endpoint VM
    $Session = New-PSSession -ComputerName "<PepVm>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

    # Use the Get-Item cmdlet to retrieve your certificate.
    # If you don't want to use a managed certificate, you can produce a self signed cert for testing purposes: 
    # $Cert = New-SelfSignedCertificate -CertStoreLocation "cert:\CurrentUser\My" -Subject "CN=<YourAppName>" -KeySpec KeyExchange
    $Cert = Get-Item "<YourCertificateLocation>"
    
    # Use the privileged endpoint to create the new app registration (and service principal object)
    $SpObject = Invoke-Command -Session $Session -ScriptBlock {New-GraphApplication -Name "<YourAppName>" -ClientCertificates $using:cert}
    $AzureStackInfo = Invoke-Command -Session $Session -ScriptBlock {Get-AzureStackStampInformation}
    $Session | Remove-PSSession

    # Using the stamp info for your Azure Stack Hub instance, populate the following variables:
    # - AzureRM endpoint used for Azure Resource Manager operations 
    # - Audience for acquiring an OAuth token used to access Graph API 
    # - GUID of the directory tenant
    $ArmEndpoint = $AzureStackInfo.TenantExternalEndpoints.TenantResourceManager
    $GraphAudience = "https://graph." + $AzureStackInfo.ExternalDomainFQDN + "/"
    $TenantID = $AzureStackInfo.AADTenantID

    # Register and set an AzureRM environment that targets your Azure Stack Hub instance
    Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint $ArmEndpoint

    # Sign in using the new service principal
    $SpSignin = Connect-AzureRmAccount -Environment "AzureStackUser" `
    -ServicePrincipal `
    -CertificateThumbprint $SpObject.Thumbprint `
    -ApplicationId $SpObject.ClientId `
    -TenantId $TenantID

    # Output the service principal details
    $SpObject

   ```
   
2. After the script finishes, it displays the app registration info, including the service principal's credentials. The `ClientID` and `Thumbprint` are authenticated, and later authorized for access to resources managed by Azure Resource Manager.

   ```shell
   ApplicationIdentifier : S-1-5-21-1512385356-3796245103-1243299919-1356
   ClientId              : 3c87e710-9f91-420b-b009-31fa9e430145
   Thumbprint            : 30202C11BE6864437B64CE36C8D988442082A0F1
   ApplicationName       : Azurestack-MyApp-c30febe7-1311-4fd8-9077-3d869db28342
   ClientSecret          :
   PSComputerName        : azs-ercs01
   RunspaceId            : a78c76bb-8cae-4db4-a45a-c1420613e01b
   ```

Keep your PowerShell console session open, as you use it with the `ApplicationIdentifier` value in the next section.

### Update a certificate credential

Now that you created a service principal, this section will show you how to:

1. Create a new self-signed X509 certificate for testing.
2. Update the service principal's credentials, by updating its **Thumbprint** property to match the new certificate.

Update the certificate credential using PowerShell, substituting your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack Hub instance. | "AzS-ERCS01" |
| \<YourAppName\> | A descriptive name for the new app registration. | "My management tool" |
| \<YourCertificateLocation\> | The location of your X509 certificate in the local certificate store. | "Cert:\CurrentUser\My\AB5A8A3533CC7AA2025BF05120117E06DE407B34" |
| \<AppIdentifier\> | The identifier assigned to the application registration. | "S-1-5-21-1512385356-3796245103-1243299919-1356" |

1. Using your elevated Windows PowerShell session, run the following cmdlets:

     ```powershell
     # Create a PSSession to the PrivilegedEndpoint VM
     $Session = New-PSSession -ComputerName "<PepVM>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

     # Create a self-signed certificate for testing purposes. 
     $NewCert = New-SelfSignedCertificate -CertStoreLocation "cert:\CurrentUser\My" -Subject "CN=<YourAppName>" -KeySpec KeyExchange
     # In production, use Get-Item and a managed certificate instead.
     # $Cert = Get-Item "<YourCertificateLocation>"

     # Use the privileged endpoint to update the certificate thumbprint, used by the service principal associated with <AppIdentifier>
     $SpObject = Invoke-Command -Session $Session -ScriptBlock {Set-GraphApplication -ApplicationIdentifier "<AppIdentifier>" -ClientCertificates $using:NewCert}
     $Session | Remove-PSSession

     # Output the updated service principal details
     $SpObject
     ```

2. After the script finishes, it displays the updated app registration info, including the thumbprint value for the new self-signed certificate.

     ```Shell  
     ApplicationIdentifier : S-1-5-21-1512385356-3796245103-1243299919-1356
     ClientId              : 
     Thumbprint            : AF22EE716909041055A01FE6C6F5C5CDE78948E9
     ApplicationName       : Azurestack-MyApp-c30febe7-1311-4fd8-9077-3d869db28342
     ClientSecret          : 
     PSComputerName        : azs-ercs01
     RunspaceId            : a580f894-8f9b-40ee-aa10-77d4d142b4e5
     ```

### Create a service principal that uses client secret credentials

> [!WARNING]
> Using a client secret is less secure than using an X509 certificate credential. Not only is the authentication mechanism less secure, but it also typically requires embedding the secret in the client app source code. As such, for production apps, you're strongly encouraged to use a certificate credential.

Now you create another app registration, but this time specify a client secret credential. Unlike a certificate credential, the directory has the ability to generate a client secret credential. Instead of specifying the client secret, you use the `-GenerateClientSecret` switch to request that it be generated. Substitute your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack Hub instance. | "AzS-ERCS01" |
| \<YourAppName\> | A descriptive name for the new app registration. | "My management tool" |

1. Open an elevated Windows PowerShell session, and run the following cmdlets:

     ```powershell  
     # Sign in to PowerShell interactively, using credentials that have access to the VM running the Privileged Endpoint (typically <domain>\cloudadmin)
     $Creds = Get-Credential

     # Create a PSSession to the Privileged Endpoint VM
     $Session = New-PSSession -ComputerName "<PepVM>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

     # Use the privileged endpoint to create the new app registration (and service principal object)
     $SpObject = Invoke-Command -Session $Session -ScriptBlock {New-GraphApplication -Name "<YourAppName>" -GenerateClientSecret}
     $AzureStackInfo = Invoke-Command -Session $Session -ScriptBlock {Get-AzureStackStampInformation}
     $Session | Remove-PSSession

     # Using the stamp info for your Azure Stack Hub instance, populate the following variables:
     # - AzureRM endpoint used for Azure Resource Manager operations 
     # - Audience for acquiring an OAuth token used to access Graph API 
     # - GUID of the directory tenant
     $ArmEndpoint = $AzureStackInfo.TenantExternalEndpoints.TenantResourceManager
     $GraphAudience = "https://graph." + $AzureStackInfo.ExternalDomainFQDN + "/"
     $TenantID = $AzureStackInfo.AADTenantID

     # Register and set an AzureRM environment that targets your Azure Stack Hub instance
     Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint $ArmEndpoint

     # Sign in using the new service principal
     $securePassword = $SpObject.ClientSecret | ConvertTo-SecureString -AsPlainText -Force
     $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $SpObject.ClientId, $securePassword
     $SpSignin = Connect-AzureRmAccount -Environment "AzureStackUser" -ServicePrincipal -Credential $credential -TenantId $TenantID

     # Output the service principal details
     $SpObject
     ```

2. After the script finishes, it displays the app registration info, including the service principal's credentials. The `ClientID` and `ClientSecret` are authenticated, and later authorized for access to resources managed by Azure Resource Manager.

     ```shell  
     ApplicationIdentifier : S-1-5-21-1634563105-1224503876-2692824315-2623
     ClientId              : 8e0ffd12-26c8-4178-a74b-f26bd28db601
     Thumbprint            : 
     ApplicationName       : Azurestack-YourApp-6967581b-497e-4f5a-87b5-0c8d01a9f146
     ClientSecret          : 6RUWLRoBw3EebBLgaWGiowCkoko5_j_ujIPjA8dS
     PSComputerName        : azs-ercs01
     RunspaceId            : 286daaa1-c9a6-4176-a1a8-03f543f90998
     ```

Keep your PowerShell console session open, as you use it with the `ApplicationIdentifier` value in the next section.

### Update a client secret

Update the client secret credential using PowerShell, using the **ResetClientSecret** parameter, which immediately changes the client secret. Substitute your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack Hub instance. | "AzS-ERCS01" |
| \<AppIdentifier\> | The identifier assigned to the application registration. | "S-1-5-21-1634563105-1224503876-2692824315-2623" |

1. Using your elevated Windows PowerShell session, run the following cmdlets:

     ```powershell
     # Create a PSSession to the PrivilegedEndpoint VM
     $Session = New-PSSession -ComputerName "<PepVM>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

     # Use the privileged endpoint to update the client secret, used by the service principal associated with <AppIdentifier>
     $SpObject = Invoke-Command -Session $Session -ScriptBlock {Set-GraphApplication -ApplicationIdentifier "<AppIdentifier>" -ResetClientSecret}
     $Session | Remove-PSSession

     # Output the updated service principal details
     $SpObject
     ```

2. After the script finishes, it displays the updated app registration info, including the newly generated client secret.

     ```shell  
     ApplicationIdentifier : S-1-5-21-1634563105-1224503876-2692824315-2623
     ClientId              : 8e0ffd12-26c8-4178-a74b-f26bd28db601
     Thumbprint            : 
     ApplicationName       : Azurestack-YourApp-6967581b-497e-4f5a-87b5-0c8d01a9f146
     ClientSecret          : MKUNzeL6PwmlhWdHB59c25WDDZlJ1A6IWzwgv_Kn
     PSComputerName        : azs-ercs01
     RunspaceId            : 6ed9f903-f1be-44e3-9fef-e7e0e3f48564
     ```

### Remove a service principal

Now you'll see how to remove/delete an app registration from your directory, and its associated service principal object, using PowerShell. 

Substitute your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack Hub instance. | "AzS-ERCS01" |
| \<AppIdentifier\> | The identifier assigned to the application registration. | "S-1-5-21-1634563105-1224503876-2692824315-2623" |

```powershell  
# Sign in to PowerShell interactively, using credentials that have access to the VM running the Privileged Endpoint (typically <domain>\cloudadmin)
$Creds = Get-Credential

# Create a PSSession to the PrivilegedEndpoint VM
$Session = New-PSSession -ComputerName "<PepVM>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

# OPTIONAL: Use the privileged endpoint to get a list of applications registered in AD FS
$AppList = Invoke-Command -Session $Session -ScriptBlock {Get-GraphApplication}

# Use the privileged endpoint to remove the application and associated service principal object for <AppIdentifier>
Invoke-Command -Session $Session -ScriptBlock {Remove-GraphApplication -ApplicationIdentifier "<AppIdentifier>"}
```

There will be no output returned from calling the Remove-GraphApplication cmdlet on the privileged endpoint, but you'll see verbatim confirmation output to the console during execution of the cmdlet:

```shell
VERBOSE: Deleting graph application with identifier S-1-5-21-1634563105-1224503876-2692824315-2623.
VERBOSE: Remove-GraphApplication : BEGIN on AZS-ADFS01 on ADFSGraphEndpoint
VERBOSE: Application with identifier S-1-5-21-1634563105-1224503876-2692824315-2623 was deleted.
VERBOSE: Remove-GraphApplication : END on AZS-ADFS01 under ADFSGraphEndpoint configuration
```

## Assign a role

Access to Azure resources by users and apps is authorized through Role-Based Access Control (RBAC). To allow an app to access resources in your subscription, you must *assign* its service principal to a *role* for a specific *resource*. First decide which role represents the right *permissions* for the app. To learn about the available roles, see [Built-in roles for Azure resources](/azure/role-based-access-control/built-in-roles).

The type of resource you choose also establishes the *access scope* for the app. You can set the access scope at the subscription, resource group, or resource level. Permissions are inherited to lower levels of scope. For example, adding an app to the "Reader" role for a resource group, means it can read the resource group and any resources it contains.

1. Sign in to the appropriate portal, based on the directory you specified during Azure Stack Hub installation (the Azure portal for Azure AD, or the Azure Stack Hub user portal for AD FS, for example). In this example, we show a user signed in to the Azure Stack Hub user portal.

   > [!NOTE]
   > To add role assignments for a given resource, your user account must belong to a role that declares the `Microsoft.Authorization/roleAssignments/write` permission. For example, either the [Owner](/azure/role-based-access-control/built-in-roles#owner) or [User Access Administrator](/azure/role-based-access-control/built-in-roles#user-access-administrator) built-in roles.  
2. Navigate to the resource you wish to allow the app to access. In this example, assign the app's service principal to a role at the subscription scope, by selecting **Subscriptions**, then a specific subscription. You could instead select a resource group, or a specific resource like a virtual machine.

     ![Select subscription for assignment](./media/azure-stack-create-service-principal/select-subscription.png)

3. Select the **Access Control (IAM)** page, which is universal across all resources that support RBAC.
4. Select **+ Add**
5. Under **Role**, pick the role you wish to assign to the app.
6. Under **Select**, search for your app using a full or partial Application Name. During registration, the Application Name is generated as *Azurestack-\<YourAppName\>-\<ClientId\>*. For example, if you used an application name of *App2*, and ClientId *2bbe67d8-3fdb-4b62-87cf-cc41dd4344ff* was assigned during creation, the full name would be  *Azurestack-App2-2bbe67d8-3fdb-4b62-87cf-cc41dd4344ff*. You can search for either the exact string, or a portion, like *Azurestack* or *Azurestack-App2*.
7. Once you find the app, select it and it will show under **Selected members**.
8. Select **Save** to finish assigning the role.

     [![Assign role](media/azure-stack-create-service-principal/assign-role.png)](media/azure-stack-create-service-principal/assign-role.png#lightbox)

9. When finished, the app will show in the list of principals assigned for the current scope, for the given role.

     [![Assigned role](media/azure-stack-create-service-principal/assigned-role.png)](media/azure-stack-create-service-principal/assigned-role.png#lightbox)

Now that you've given your app an identity and authorized it for resource access, you can enable your script or code to sign in and securely access Azure Stack Hub resources.  

## Next steps

[Manage user permissions](azure-stack-manage-permissions.md)  
[Azure Active Directory Documentation](https://docs.microsoft.com/azure/active-directory)  
[Active Directory Federation Services](https://docs.microsoft.com/windows-server/identity/active-directory-federation-services)
