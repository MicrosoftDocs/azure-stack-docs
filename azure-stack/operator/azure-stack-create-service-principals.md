---
title: Use an app identity to access resources
description: Describes how to manage a service principal that can be used with the role-based access control in Azure Resource Manager to manage access to resources.
services: azure-resource-manager
documentationcenter: na
author: PatAltimore
manager: femila

ms.service: azure-resource-manager
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: na
ms.date: 06/18/2019
ms.author: patricka
ms.lastreviewed: 06/18/2019

---
# Use an app identity to access resources

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit (ASDK)*

An application that needs to deploy or configure resources through Azure Resource Manager in Azure Stack requires a service principal. Just as a user is represented by a user principal, a service principal is a type of security principal that represents an application. The service principal provides an identity for your application, allowing you to delegate only the necessary permissions to that service principal.  

As an example, you may have a configuration management application that uses Azure Resource Manager to inventory Azure resources. In this scenario, you can create a service principal, grant the reader role to that service principal, and limit the configuration management application to read-only access. 

## Overview

Running an app under the identity of a service principal is preferable to running it under a user principal because:

 - You can assign permissions to the service principal that are different than a user principal's permissions. Typically, these permissions are restricted to only what the app needs to do (known as the principle of least privilege).
 - You do not have to change a service principal's credentials, as you would a user's credentials when the user's responsibilities change.
 - You can use an X509 certificate for stronger service principal credentials.  

Similar to a user principal, a service principal must present credentials during authentication, which consist of 2 elements:

- An **Application ID**, sometimes referred to as a Client ID. This is a GUID that uniquely identifies the application's registration.
- A **secret** associated with the application ID. You can either generate a client secret string (similar to a password), or specify an X509 certificate (which uses its public key). 

You start by creating a new app registration in your directory, which creates an associated [service principal object](/azure/active-directory/develop/developer-glossary#service-principal-object) to represent the app's identity. This document describes the process of creating and managing a service principal, depending on the directory you chose for your Azure Stack instance:

- Azure Active Directory (Azure AD). Azure AD is a multi-tenant, cloud-based directory, and identity management service. You can use Azure AD with a connected Azure Stack instance.
- Active Directory Federation Services (AD FS). AD FS provides simplified, secured identity federation, and Web single sign-on (SSO) capabilities. You can use AD FS with both connected and disconnected Azure Stack instances.

Once you learn how to manage a service principal, you learn how to assign the service principal to a role, limiting its resource access.

## Manage an Azure AD service principal 

If you have deployed Azure Stack with Azure Active Directory (Azure AD) as your identity management service, you can create service principals just like you do for Azure. This section shows you how to perform the steps through the Azure portal. Check that you have the [required Azure AD permissions](/azure/active-directory/develop/howto-create-service-principal-portal#required-permissions) before beginning.

### Create a service principal that uses a client secret credential

In this section, you register your application using the Azure portal, which creates the service principal object in your Azure AD tenant. In this example, the service principal will be created with a client secret credential, but the portal also supports X509 certificate based credentials.

1. Sign in to your Azure Account through the [Azure portal](https://portal.azure.com).
2. Select **Azure Active Directory** > **App registrations** > **New registration**.
3. Provide a **name** for the application. 
4. Select the appropriate **Supported account types**.
5. Under **Redirect URI**, select **Web**  as the application type, and (optionally) specify a redirect URI if your application requires it. 
6. After setting the values, select **Register**. The application registration is created and the **Overview** page is presented.
7. Copy the **Application ID** and store it in your application code. The applications in the sample applications section refer to this value as the Client ID.
8. To generate a client secret, select the **Certificates & secrets** page. Select **New client secret**.
9. Provide a **description** for the secret, and an **expires** duration. 
10. When done, select **Add**.
11. The value of the secret is displayed. Copy this value to Notepad or some other temporary location, because you cannot retrieve it later. You provide the secret with the application ID for service principal sign-in. 

    ![Saved key](./media/azure-stack-create-service-principal/create-service-principal-in-azure-stack-secret.png)

## Manage an AD FS service principal

If you deployed Azure Stack with Active Directory Federation Services (AD FS) as your identity management service, you must use PowerShell to manage the service principal (instead of the portal). Script examples are provided below for managing service principal credentials that use both an X509 certificate, and a client secret.

The scripts are run in an elevated ("Run as administrator") PowerShell console, which opens another session to a VM that hosts a privileged endpoint for your Azure Stack instance. Once the privileged endpoint session has been established, additional cmdlets will execute and manage the service principal. For more information about the privileged endpoint, see [Using the privileged endpoint in Azure Stack](azure-stack-privileged-endpoint.md).

### Create a service principal that uses a certificate credential

When creating a certificate for a service principal credential, the following requirements must be met:

 - The Cryptographic Service Provider (CSP) must be legacy key provider.
 - The certificate format must be in PFX file, as both the public and private keys are required. Windows servers use .pfx files that contain the public key file (SSL certificate file) and the associated private key file.
 - For production, the certificate must be issued from either an internal Certificate Authority or a Public Certificate Authority. If you use a public certificate authority, you must included the authority in the base operating system image as part of the Microsoft Trusted Root Authority Program. You can find the full list at [Microsoft Trusted Root Certificate Program: Participants](https://gallery.technet.microsoft.com/Trusted-Root-Certificate-123665ca).
 - Your Azure Stack infrastructure must have network access to the certificate authority's Certificate Revocation List (CRL) location published in the certificate. This CRL must be an HTTP endpoint.

Once you have a certificate, use the PowerShell script below to register your application and create a service principal, substituting your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack instance. | "AzS-ERCS01" |
| \<YourCertificateLocation\> | The location of your X509 certificate in the local certificate store. | "Cert:\CurrentUser\My\AB5A8A3533CC7AA2025BF05120117E06DE407B34" |
| \<YourAppName\> | A descriptive name for the new app registration | "My management tool" |

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

    # Using the stamp info for your Azure Stack instance, populate the following variables:
    # - AzureRM endpoint used for Azure Resource Manager operations 
    # - Audience for acquiring an OAuth token used to access Graph API 
    # - GUID of the directory tenant
    $ArmEndpoint = $AzureStackInfo.TenantExternalEndpoints.TenantResourceManager
    $GraphAudience = "https://graph." + $AzureStackInfo.ExternalDomainFQDN + "/"
    $TenantID = $AzureStackInfo.AADTenantID

    # Register and set an AzureRM environment that targets your Azure Stack instance
    Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint $ArmEndpoint
    Set-AzureRmEnvironment -Name "AzureStackUser" -GraphAudience $GraphAudience -EnableAdfsAuthentication:$true

    # Sign in using the new service principal identity
    $SpSignin = Connect-AzureRmAccount -Environment "AzureStackUser" `
    -ServicePrincipal `
    -CertificateThumbprint $SpObject.Thumbprint `
    -ApplicationId $SpObject.ClientId `
    -TenantId $TenantID

    # Output the service principal details
    $SpObject

   ```
   
2. After the script finishes, it displays the application registration info, including the service principal's credentials. As demonstrated, the `ClientID` and `Thumbprint` is used to sign in under the service principal's identity. Keep your PowerShell console session open, as you use it with the `ApplicationIdentifier` value in the next section. 

   For example:

   ```shell
   ApplicationIdentifier : S-1-5-21-1512385356-3796245103-1243299919-1356
   ClientId              : 3c87e710-9f91-420b-b009-31fa9e430145
   Thumbprint            : 30202C11BE6864437B64CE36C8D988442082A0F1
   ApplicationName       : Azurestack-MyApp-c30febe7-1311-4fd8-9077-3d869db28342
   ClientSecret          :
   PSComputerName        : azs-ercs01
   RunspaceId            : a78c76bb-8cae-4db4-a45a-c1420613e01b
   ```

### Update a service principal's certificate credential

Now that you created a service principal, this section will show you how to:

1. Create a new self-signed X509 certificate for testing.
2. Update the service principal's credentials, by updating its **Thumbprint** property to match the new certificate.

Update the certificate credential using PowerShell, substituting your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack instance. | "AzS-ERCS01" |
| \<YourAppName\> | A descriptive name for the new app registration | "My management tool" |
| \<YourCertificateLocation\> | The location of your X509 certificate in the local certificate store. | "Cert:\CurrentUser\My\AB5A8A3533CC7AA2025BF05120117E06DE407B34" |
| \<AppIdentifier\> | The identifier assigned to the application registration | S-1-5-21-1512385356-3796245103-1243299919-1356 |

1. Open an elevated Windows PowerShell session, and run the following cmdlets:

     ```powershell
     # Creating a PSSession to the PrivilegedEndpoint VM
     $Session = New-PSSession -ComputerName "<PepVM>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

     # Create a self-signed certificate for testing purposes. 
     $NewCert = New-SelfSignedCertificate -CertStoreLocation "cert:\CurrentUser\My" -Subject "CN=<YourAppName>" -KeySpec KeyExchange
     # In production, use Get-Item and a managed certificate instead.
     # $Cert = Get-Item "<YourCertificateLocation>"

     $SpObject = Invoke-Command -Session $Session -ScriptBlock {Set-GraphApplication -ApplicationIdentifier "<AppIdentifier>" -ClientCertificates $using:NewCert}
     $Session | Remove-PSSession

     # Output the updated service principal details
     $SpObject
     ```

2. After the script finishes, it displays the updated application registration info, including the thumbprint value for the new self-signed certificate.

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

> [!IMPORTANT]
> Because a client secret is typically embedded in the source code of the client app that uses it for sign-in, it is less secure than using an X509 certificate for credentials.
> As such, for production applications, you are strongly encouraged to use a certificate credential.

Now create a client secret credential using PowerShell. Unlike a certificate credential, the directory has the ability to generate a client secret credential. So instead of specifying the client secret, you use the `-GenerateClientSecret` switch below to request that it be generated. Substitute your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack instance. | "AzS-ERCS01" |
| \<YourAppName\> | A descriptive name for the new app registration | "My management tool" |



1. Open an elevated Windows PowerShell session, and run the following cmdlets:

     ```powershell  
     # Sign in to PowerShell interactively, using credentials that have access to the VM running the Privileged Endpoint (typically <domain>\cloudadmin)
     $Creds = Get-Credential

     # Create a PSSession to the Privileged Endpoint VM
     $Session = New-PSSession -ComputerName "<PepVM>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

     # Use the privileged endpoint to create the new app registration (and service principal object)
     $SpObject = Invoke-Command -Session $Session -ScriptBlock {New-GraphApplication -Name "<YourAppName>" -GenerateClientSecret}
     $Session | Remove-PSSession

    # Output the service principal details
     $SpObject
     ```

2. After the cmdlet runs, the application registration details are display. You use the ClientID and ClientSecret when authenticating with your service principal. TODO - keep session open, used in next section!

     ```shell  
     ApplicationIdentifier : S-1-5-21-1634563105-1224503876-2692824315-2623
     ClientId              : 8e0ffd12-26c8-4178-a74b-f26bd28db601
     Thumbprint            : 
     ApplicationName       : Azurestack-YourApp-6967581b-497e-4f5a-87b5-0c8d01a9f146
     ClientSecret          : 6RUWLRoBw3EebBLgaWGiowCkoko5_j_ujIPjA8dS
     PSComputerName        : azs-ercs01
     RunspaceId            : 286daaa1-c9a6-4176-a1a8-03f543f90998
     ```

### Update a service principal's client secret

Update the client secret credential using PowerShell, using the **ResetClientSecret** parameter, which immediately changes the client secret. Substitute your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack instance. | "AzS-ERCS01" |
| \<YourAppName\> | A descriptive name for the new app registration | "My management tool" |
| \<AppIdentifier\> | The identifier assigned to the application registration | S-1-5-21-1512385356-3796245103-1243299919-1356 |

1. Open an elevated Windows PowerShell session, and run the following cmdlets:

     ```powershell  
     # Creating a PSSession to the PrivilegedEndpoint VM
     $Session = New-PSSession -ComputerName "<PepVM>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

     $UpdateServicePrincipal = Invoke-Command -Session $Session -ScriptBlock {Set-GraphApplication -ApplicationIdentifier "<AppIdentifier>" -ResetClientSecret}

     $Session | Remove-PSSession
     ```

2. After the script finishes, it displays the newly generated secret required for SPN authentication. Make sure you store the new client secret.

     ```shell  
          ApplicationIdentifier : S-1-5-21-1634563105-1224503876-2692824315-2120
          ClientId              :  
          Thumbprint            : 
          ApplicationName       : Azurestack-Yourapp-6967581b-497e-4f5a-87b5-0c8d01a9f146
          ClientSecret          : MKUNzeL6PwmlhWdHB59c25WDDZlJ1A6IWzwgv_Kn
          RunspaceId            : 6ed9f903-f1be-44e3-9fef-e7e0e3f48564
     ```

### Remove a service principal for AD FS

Remove the service principal using PowerShell, substituting your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack instance. | "AzS-ERCS01" |



|Parameter|Description|Example|
|---------|---------|---------|
| Parameter | Description | Example |
| ApplicationIdentifier | Unique identifier | S-1-5-21-1634563105-1224503876-2692824315-2119 |

> [!Note]  
> To view a list of all existing service principals and their Application Identifier, the get-graphapplication command can be used.


```powershell  
# Sign in to PowerShell interactively, using credentials that have access to the VM running the Privileged Endpoint (typically <domain>\cloudadmin)
$Creds = Get-Credential

# Creating a PSSession to the PrivilegedEndpoint VM
$Session = New-PSSession -ComputerName "<PepVM>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

$UpdateServicePrincipal = Invoke-Command -Session $Session -ScriptBlock {Remove-GraphApplication -ApplicationIdentifier S-1-5-21-1634563105-1224503876-2692824315-2119}

$Session | Remove-PSSession
```

## Assign a role

To access resources in your subscription, you must assign the application to a role. Decide which role represents the right permissions for the application. To learn about the available roles, see [RBAC: Built in Roles](/azure/role-based-access-control/built-in-roles).

You can set the scope at the level of the subscription, resource group, or resource. Permissions are inherited to lower levels of scope. For example, adding an application to the Reader role for a resource group means it can read the resource group and any resources it contains.

1. In the Azure Stack portal, navigate to the level of scope you wish to assign the application to. For example, to assign a role at the subscription scope, select **Subscriptions**. You could instead select a resource group or resource.

2. Select the particular subscription (resource group or resource) to assign the application to.

     ![Select subscription for assignment](./media/azure-stack-create-service-principal/image16.png)

3. Select **Access Control (IAM)**.

     ![Select access](./media/azure-stack-create-service-principal/image17.png)

4. Select **Add role assignment**.

5. Select the role you wish to assign to the application.

6. Search for your application, and select it.

7. Select **OK** to finish assigning the role. You see your application in the list of users assigned to a role for that scope.

Now that you've created a service principal and assigned a role, you can begin using this within your application to access Azure Stack resources.  

## Next steps

[Add users for AD FS](azure-stack-add-users-adfs.md)  
[Manage user permissions](azure-stack-manage-permissions.md)  
[Azure Active Directory Documentation](https://docs.microsoft.com/azure/active-directory)  
[Active Directory Federation Services](https://docs.microsoft.com/windows-server/identity/active-directory-federation-services)
