---
title: Rotate App Service on Azure Stack Hub secrets and certificates 
description: Learn how to rotate secrets and certificates used by Azure App Service on Azure Stack Hub
author: anwestg
manager: stefsch

ms.topic: article
ms.date: 04/09/2020
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 04/09/2020

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# Rotate App Service on Azure Stack Hub secrets and certificates

These instructions only apply to Azure App Service on Azure Stack Hub.  Rotation of Azure App Service on Azure Stack Hub secrets is not included in the centralized secret rotation procedure for Azure Stack Hub.  Operators can monitor the validity of secrets within the system, the date on which they were last updated and the time remaining until the secrets expire.

> [!Important]
> Operators will not receive alerts for secret expiration on the Azure Stack Hub dashboard as Azure App Service on Azure Stack Hub is not integrated with the Azure Stack Hub alerting service.  Operators must regularly monitor their secrets using the Azure App Service on Azure Stack Hub administration experience in the Azure Stack Hub Administrators portal.

This document contains the procedure for rotating the following secrets:

* Encryption Keys used within Azure App Service on Azure Stack Hub;
* Database connection credentials used by Azure App Service on Azure Stack Hub to interact with the hosting and metering databases;
* Certificates used by Azure App Service on Azure Stack Hub to secure endpoints;
* System credentials for Azure App Service on Azure Stack Hub infrastructure roles.

## Rotate encryption keys

To rotate the encryption keys used within Azure App Service on Azure Stack Hub, complete the following steps:

1. Go to the App Service Administration experience in the Azure Stack Hub Administrators Portal.

1. Navigate to the **Secrets** menu option

1. Click the **Rotate** button in the Encryption Keys section

1. Click **OK** to start the rotation procedure.

1. The encryption keys are rotated and all role instances are updated. Operators can monitor the Status of the procedure using the **Status** button.

## Rotate connection strings

To update the credentials for the database connection string for the App Service hosting and metering databases, complete the following steps:

1. Go to the App Service Administration experience in the Azure Stack Hub Administrators Portal.

1. Navigate to the **Secrets** menu option

1. Click the **Rotate** button in the Connection Strings section

1. Provide the **SQL SA Username** and **Password** and click **OK** to start the rotation procedure. 

1. The credentials will be rotated throughout the Azure App Service role instances. Operators can monitor the Status of the procedure using the **Status** button.

## Rotate certificates

To rotate the certificates used within Azure App Service on Azure Stack Hub, complete the following steps:

1. Go to the App Service Administration experience in the Azure Stack Hub Administrators Portal.

1. Navigate to the **Secrets** menu option

1. Click the **Rotate** button in the Certificates section

1. Provide the **certificate file** and associated **password** for the certificates you wish to rotate and click **OK**.

1. The certificates will be rotated as required throughout the Azure App Service on Azure Stack Hub role instances.  Operators can monitor the status of the procedure using the **Status** button.

When the identity application certificate is rotated the corresponding application in AAD or ADFS must also be updated with the new certificate.

> [!IMPORTANT]
> Failure to update the identity application with the new certificate, after rotation, will break the user portal experience for Azure Functions, prevent users from being able to use the KUDU Developer tools, and prevent Administrators from managing worker tier scale sets from the App Service administration experience.

### Rotate credential for the AAD identity application 

The identity application is created by the operator before deployment of Azure App Service on Azure Stack Hub.  If the Application ID is unknown, follow these steps to discover it:

1. Go to the **Azure Stack Hub Administration Portal**

1. Go to **Subscriptions** and select **Default Provider Subscription**

1. Select **Access Control (IAM)** and select the **App Service** application

1. Take a note of the **APP ID**, this value is the Application ID of the identity application that must be updated in Azure Active Directory.

To rotate the certificate for the application in Active Directory, follow these steps:

1. Go to the **Azure portal** and sign in using the Global Admin used to deploy Azure Stack Hub

1. Go to **Azure Active Directory** and browse to **App Registrations**

1. Search for the **Application ID**,  specify the identity Application ID

1. Select the application and then go to **Certificates & Secrets**

1. Click **Upload certificate** and upload the new certificate for the identity application with one of the following file types: .cer, .pem, .crt

1. Confirm the **thumbprint** matches that listed in the App Service administration experience in the Azure Stack Hub Admin portal

1. Delete the old certificate

### Rotate certificate for ADFS Identity Application

The identity application is created by the operator before deployment of Azure App Service on Azure Stack Hub.  If the Application's Object ID is unknown, follow these steps to discover it:

1. Go to the **Azure Stack Hub Administration Portal**

1. Go to **Subscriptions** and select **Default Provider Subscription**

1. Select **Access Control (IAM)** and select the **AzureStack-AppService-<guid>** application

1. Take a note of the **Object ID**, this value is the ID of the Service Principal that must be updated in ADFS.

To rotate the certificate for the application in ADFS, you will need to have access to the privileged endpoint (PEP), and then update the certificate credential using PowerShell, substituting your own values for the following placeholders:

| Placeholder | Description | Example |
| ----------- | ----------- | ------- |
| \<PepVM\> | The name of the privileged endpoint VM on your Azure Stack Hub instance. | "AzS-ERCS01" |
| \<CertificateFileLocation\> | The location of your X509 certificate on disk. | "d:\certs\sso.cer" |
| \<ApplicationObjectId\> | The identifier assigned to the identity application. | "S-1-5-21-401916501-2345862468-1451220656-1451" |

 in an elevated Windows PowerShell session

1. Open an elevated Windows PowerShell session, and run the following script

    ```powershell
    # Sign in to PowerShell interactively, using credentials that have access to the VM running the Privileged Endpoint
    $Creds = Get-Credential

    # Create a new Certificate object from the identity application certificate exported as .cer file
    $Cert = New-Object System.Security.Cryptography.X509Certificates.X509Certificate2("<CertificateFileLocation>")

    # Create a new PSSession to the PrivelegedEndpoint VM
    $Session = New-PSSession -ComputerName "<PepVm>" -ConfigurationName PrivilegedEndpoint -Credential $Creds

    # Use the privileged endpoint to update the certificate thumbprint, used by the service principal associated with the App Service identity application
    $SpObject = Invoke-Command -Session $Session -ScriptBlock {Set-GraphApplication -ApplicationIdentifier "<ApplicationObjectId>" -ClientCertificates $using:Cert}
    $Session | Remove-PSSession

    # Output the updated service principal details
    $SpObject

    ```

1. After the script finishes, it displays the updated app registration info, including the thumbprint value for the certificate

    ```shell
    ApplicationIdentifier : S-1-5-21-401916501-2345862468-1451220656-1451
    ClientId              : 
    Thumbprint            : FDAA679BF9EDDD0CBB581F978457A37BFD73CA3B
    ApplicationName       : Azurestack-AppService-d93601c2-1ec0-4cac-8d1c-8ccde63ef308
    ClientSecret          : 
    PSComputerName        : AzS-ERCS01
    RunspaceId            : cb471c79-a0d3-40ec-90ba-89087d104510
    ```


## Rotate system credentials

To rotate the System Credentials used within Azure App Service on Azure Stack Hub, complete the following steps:

1. Go to the App Service Administration experience in the Azure Stack Hub Administrators Portal.

1. Navigate to the **Secrets** menu option

1. Click the **Rotate** button in the System Credentials section

1. Select the **Scope** of the System Credential you are rotating.  Operators can choose to rotate the System Credentials for All roles or individual roles.

1. Specify a **new Local Admin User Name**, new **Password** and confirm the **Password** and click **OK**

1. The credential(s) will be rotated as required throughout the corresponding Azure App Service on Azure Stack Hub role instance.  Operators can monitor the status of the procedure using the **Status** button.



