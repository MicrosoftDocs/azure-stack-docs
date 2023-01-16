---
title: Prerequisites to deploy Azure App Service on Azure Stack Hub 
description: Learn the prerequisite steps to complete before you deploy Azure App Service on Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 10/24/2022
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 10/28/2019
zone_pivot_groups: state-connected-disconnected

# Intent: As an Azure Stack operator, I want to know the prerequisites steps to complete before deploying App Service.
# Keyword: app service prerequisites azure stack

---

# Prerequisites for deploying App Service on Azure Stack Hub

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

Before you deploy Azure App Service on Azure Stack Hub, you must complete the prerequisite steps in this article.

## Before you get started 

This section lists the prerequisites for both integrated system and Azure Stack Development Kit (ASDK) deployments.

### Resource provider prerequisites

[!INCLUDE [Common RP prerequisites](../includes/resource-provider-prerequisites.md)]

### Installer and helper scripts

1. Download the [App Service on Azure Stack Hub deployment helper scripts](https://aka.ms/appsvconmashelpers).
   > [!NOTE]
   > The deployment helper scripts require the AzureRM PowerShell module. See [Install PowerShell AzureRM module for Azure Stack Hub](azure-stack-powershell-install.md) for installation details.

2. Download the [App Service on Azure Stack Hub installer](https://aka.ms/appsvconmasinstaller).
3. Extract the files from the helper scripts .zip file. The following files and folders are extracted:

   - Common.ps1
   - Create-AADIdentityApp.ps1
   - Create-ADFSIdentityApp.ps1
   - Create-AppServiceCerts.ps1
   - Get-AzureStackRootCert.ps1
   - BCDR
     - ReACL.cmd
   - Modules folder
     - GraphAPI.psm1

<!-- MultiNode Only --->
## Certificates and server configuration (Integrated Systems)

This section lists the prerequisites for integrated system deployments.

### Certificate requirements

To run the resource provider in production, you must provide the following certificates:

- Default domain certificate
- API certificate
- Publishing certificate
- Identity certificate

In addition to specific requirements listed in the following sections, you'll also use a tool later to test for general requirements. See [Validate Azure Stack Hub PKI certificates](azure-stack-validate-pki-certs.md) for the complete list of validations, including:
- **File format** of .PFX
- **Key usage** set to server and client authentication
- and several others

#### Default domain certificate

The default domain certificate is placed on the front-end role. User apps for wildcard or default domain request to Azure App Service use this certificate. The certificate is also used for source control operations (Kudu).

The certificate must be in .pfx format and should be a three-subject wildcard certificate. This requirement allows one certificate to cover both the default domain and the SCM endpoint for source control operations.

| Format | Example |
| --- | --- |
| `*.appservice.<region>.<DomainName>.<extension>` | `*.appservice.redmond.azurestack.external` |
| `*.scm.appservice.<region>.<DomainName>.<extension>` | `*.scm.appservice.redmond.azurestack.external` |
| `*.sso.appservice.<region>.<DomainName>.<extension>` | `*.sso.appservice.redmond.azurestack.external` |

#### API certificate

The API certificate is placed on the Management role. The resource provider uses it to help secure API calls. The certificate for publishing must contain a subject that matches the API DNS entry.

| Format | Example |
| --- | --- |
| api.appservice.\<region\>.\<DomainName\>.\<extension\> | api.appservice.redmond.azurestack.external |

#### Publishing certificate

The certificate for the Publisher role secures the FTPS traffic for app owners when they upload content. The certificate for publishing must contain a subject that matches the FTPS DNS entry.

| Format | Example |
| --- | --- |
| ftp.appservice.\<region\>.\<DomainName\>.\<extension\> | ftp.appservice.redmond.azurestack.external |

#### Identity certificate

The certificate for the identity app enables:

- Integration between the Azure Active Directory (Azure AD) or Active Directory Federation Services (AD FS) directory, Azure Stack Hub, and App Service to support integration with the compute resource provider.
- Single sign-on scenarios for advanced developer tools within Azure App Service on Azure Stack Hub.

The certificate for identity must contain a subject that matches the following format.

| Format | Example |
| --- | --- |
| sso.appservice.\<region\>.\<DomainName\>.\<extension\> | sso.appservice.redmond.azurestack.external |

### Validate certificates

Before deploying the App Service resource provider, you should [validate the certificates to be used](azure-stack-validate-pki-certs.md) by using the Azure Stack Hub Readiness Checker tool available from the [PowerShell Gallery](https://aka.ms/AzsReadinessChecker). The Azure Stack Hub Readiness Checker Tool validates that the generated PKI certificates are suitable for App Service deployment.

As a best practice, when working with any of the necessary [Azure Stack Hub PKI certificates](azure-stack-pki-certs.md), you should plan enough time to test and reissue certificates if necessary.

### Prepare the file server

Azure App Service requires the use of a file server. For production deployments, the file server must be configured to be highly available and capable of handling failures.

#### Quickstart template for Highly Available file server and SQL Server

A [reference architecture quickstart template](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/appservice-fileserver-sqlserver-ha) is now available that will deploy a file server and SQL Server. This template supports Active Directory infrastructure in a virtual network configured to support a highly available deployment of Azure App Service on Azure Stack Hub.

>[!IMPORTANT]
> This template is offered as a reference or example of how you can deploy the prerequisites. Because the Azure Stack Hub Operator manages these servers, especially in production environments, you should configure the template as needed or required by your organization.

> [!NOTE]
> The integrated system instance must be able to download resources from GitHub in order to complete the deployment.

#### Steps to deploy a custom file server

>[!IMPORTANT]
> If you choose to deploy App Service in an existing virtual network, the file server should be deployed into a separate Subnet from App Service.

>[!NOTE]
> If you have chosen to deploy a file server using either of the Quickstart templates mentioned above, you can skip this section as the file servers are configured as part of the template deployment.

##### Provision groups and accounts in Active Directory

1. Create the following Active Directory global security groups:

   - FileShareOwners
   - FileShareUsers

2. Create the following Active Directory accounts as service accounts:

   - FileShareOwner
   - FileShareUser

   As a security best practice, the users for these accounts (and for all web roles) should be unique  and have strong usernames and passwords. Set the passwords with the following conditions:

   - Enable **Password never expires**.
   - Enable **User cannot change password**.
   - Disable **User must change password at next logon**.

3. Add the accounts to the group memberships as follows:

   - Add **FileShareOwner** to the **FileShareOwners** group.
   - Add **FileShareUser** to the **FileShareUsers** group.

##### Provision groups and accounts in a workgroup

>[!NOTE]
> When you're configuring a file server, run all the following commands from an **Administrator Command Prompt**. <br>***Don't use PowerShell.***

When you use the Azure Resource Manager template, the users are already created.

1. Run the following commands to create the FileShareOwner and FileShareUser accounts. Replace `<password>` with your own values.

   ``` DOS
   net user FileShareOwner <password> /add /expires:never /passwordchg:no
   net user FileShareUser <password> /add /expires:never /passwordchg:no
   ```

2. Set the passwords for the accounts to never expire by running the following WMIC commands:

   ``` DOS
   WMIC USERACCOUNT WHERE "Name='FileShareOwner'" SET PasswordExpires=FALSE
   WMIC USERACCOUNT WHERE "Name='FileShareUser'" SET PasswordExpires=FALSE
   ```

3. Create the local groups FileShareUsers and FileShareOwners, and add the accounts in the first step to them:

   ``` DOS
   net localgroup FileShareUsers /add
   net localgroup FileShareUsers FileShareUser /add
   net localgroup FileShareOwners /add
   net localgroup FileShareOwners FileShareOwner /add
   ```

#### Provision the content share

The content share contains tenant website content. The procedure to provision the content share on a single file server is the same for both Active Directory and workgroup environments. But it's different for a failover cluster in Active Directory.

#### Provision the content share on a single file server (Active Directory or workgroup)

On a single file server, run the following commands at an elevated command prompt. Replace the value for `C:\WebSites` with the corresponding paths in your environment.

```DOS
set WEBSITES_SHARE=WebSites
set WEBSITES_FOLDER=C:\WebSites
md %WEBSITES_FOLDER%
net share %WEBSITES_SHARE% /delete
net share %WEBSITES_SHARE%=%WEBSITES_FOLDER% /grant:Everyone,full
```

### Configure access control to the shares

Run the following commands at an elevated command prompt on the file server or on the failover cluster node, which is the current cluster resource owner. Replace values in italics with values that are specific to your environment.

#### Active Directory

```DOS
set DOMAIN=<DOMAIN>
set WEBSITES_FOLDER=C:\WebSites
icacls %WEBSITES_FOLDER% /reset
icacls %WEBSITES_FOLDER% /grant Administrators:(OI)(CI)(F)
icacls %WEBSITES_FOLDER% /grant %DOMAIN%\FileShareOwners:(OI)(CI)(M)
icacls %WEBSITES_FOLDER% /inheritance:r
icacls %WEBSITES_FOLDER% /grant %DOMAIN%\FileShareUsers:(CI)(S,X,RA)
icacls %WEBSITES_FOLDER% /grant *S-1-1-0:(OI)(CI)(IO)(RA,REA,RD)
```

#### Workgroup

```DOS
set WEBSITES_FOLDER=C:\WebSites
icacls %WEBSITES_FOLDER% /reset
icacls %WEBSITES_FOLDER% /grant Administrators:(OI)(CI)(F)
icacls %WEBSITES_FOLDER% /grant FileShareOwners:(OI)(CI)(M)
icacls %WEBSITES_FOLDER% /inheritance:r
icacls %WEBSITES_FOLDER% /grant FileShareUsers:(CI)(S,X,RA)
icacls %WEBSITES_FOLDER% /grant *S-1-1-0:(OI)(CI)(IO)(RA,REA,RD)
```

### Prepare the SQL Server instance

> [!NOTE]
> If you've chosen to deploy the Quickstart template for Highly Available File Server and SQL Server, you can skip this section as the template deploys and configures SQL Server in a HA configuration.

For the Azure App Service on Azure Stack Hub hosting and metering databases, you must prepare a SQL Server instance to hold the App Service databases.

For production and high-availability purposes, you should use a full version of SQL Server 2014 SP2 or later, enable mixed-mode authentication, and deploy in a [highly available configuration](/sql/sql-server/failover-clusters/high-availability-solutions-sql-server).

The SQL Server instance for Azure App Service on Azure Stack Hub must be accessible from all App Service roles. You can deploy SQL Server within the Default Provider Subscription in Azure Stack Hub. Or you can make use of the existing infrastructure within your organization (as long as there's connectivity to Azure Stack Hub). If you're using an Azure Marketplace image, remember to configure the firewall accordingly.

> [!NOTE]
> A number of SQL IaaS VM images are available through the Marketplace Management feature. Make sure you always download the latest version of the SQL IaaS Extension before you deploy a VM using a Marketplace item. The SQL images are the same as the SQL VMs that are available in Azure. For SQL VMs created from these images, the IaaS extension and corresponding portal enhancements provide features such as automatic patching and backup capabilities.
>
> For any of the SQL Server roles, you can use a default instance or a named instance. If you use a named instance, be sure to manually start the SQL Server Browser service and open port 1434.

The App Service installer will check to ensure the SQL Server has database containment enabled. To enable database containment on the SQL Server that will host the App Service databases, run these SQL commands:

```sql
sp_configure 'contained database authentication', 1;
GO
RECONFIGURE;
GO
```

<!-- ASDK Only --->
## Certificates and server configuration (ASDK)

This section lists the prerequisites for ASDK deployments. 

### Certificates required for ASDK deployment of Azure App Service

The *Create-AppServiceCerts.ps1* script works with the Azure Stack Hub certificate authority to create the four certificates that App Service needs.

| File name | Use |
| --- | --- |
| _.appservice.local.azurestack.external.pfx | App Service default SSL certificate |
| api.appservice.local.azurestack.external.pfx | App Service API SSL certificate |
| ftp.appservice.local.azurestack.external.pfx | App Service publisher SSL certificate |
| sso.appservice.local.azurestack.external.pfx | App Service identity application certificate |

To create the certificates, follow these steps:

1. Sign in to the ASDK host using the AzureStack\AzureStackAdmin account.
2. Open an elevated PowerShell session.
3. Run the *Create-AppServiceCerts.ps1* script from the folder where you extracted the helper scripts. This script creates four certificates in the same folder as the script that App Service needs for creating certificates.
4. Enter a password to secure the .pfx files, and make a note of it. You must enter it later, in the App Service on Azure Stack Hub installer.

#### Create-AppServiceCerts.ps1 script parameters

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| pfxPassword | Required | Null | Password that helps protect the certificate private key |
| DomainName | Required | local.azurestack.external | Azure Stack Hub region and domain suffix |

### Quickstart template for file server for deployments of Azure App Service on ASDK.

For ASDK deployments only, you can use the [example Azure Resource Manager deployment template](https://aka.ms/appsvconmasdkfstemplate) to deploy a configured single-node file server. The single-node file server will be in a workgroup.  

> [!NOTE]
> The ASDK instance must be able to download resources from GitHub in order to complete the deployment.

### SQL Server instance

For the Azure App Service on Azure Stack Hub hosting and metering databases, you must prepare a SQL Server instance to hold the App Service databases.

For ASDK deployments, you can use SQL Server Express 2014 SP2 or later. SQL Server must be configured to support **Mixed Mode** authentication because App Service on Azure Stack Hub **DOES NOT** support Windows Authentication.

The SQL Server instance for Azure App Service on Azure Stack Hub must be accessible from all App Service roles. You can deploy SQL Server within the Default Provider Subscription in Azure Stack Hub. Or you can make use of the existing infrastructure within your organization (as long as there's connectivity to Azure Stack Hub). If you're using an Azure Marketplace image, remember to configure the firewall accordingly.

> [!NOTE]
> A number of SQL IaaS VM images are available through the Marketplace Management feature. Make sure you always download the latest version of the SQL IaaS Extension before you deploy a VM using a Marketplace item. The SQL images are the same as the SQL VMs that are available in Azure. For SQL VMs created from these images, the IaaS extension and corresponding portal enhancements provide features such as automatic patching and backup capabilities.
>
> For any of the SQL Server roles, you can use a default instance or a named instance. If you use a named instance, be sure to manually start the SQL Server Browser service and open port 1434.

The App Service installer will check to ensure the SQL Server has database containment enabled. To enable database containment on the SQL Server that will host the App Service databases, run these SQL commands:

```sql
sp_configure 'contained database authentication', 1;
GO
RECONFIGURE;
GO

```

## Licensing concerns for required file server and SQL Server

Azure App Service on Azure Stack Hub requires a file server and SQL Server to operate. You're free to use pre-existing resources located outside of your Azure Stack Hub deployment or deploy resources within their Azure Stack Hub Default Provider Subscription.

If you choose to deploy the resources within your Azure Stack Hub Default Provider Subscription, the licenses for those resources (Windows Server Licenses and SQL Server Licenses) are included in the cost of Azure App Service on Azure Stack Hub subject to the following constraints:

- the infrastructure is deployed into the Default Provider Subscription;
- the infrastructure is exclusively used by the Azure App Service on Azure Stack Hub resource provider. No other workloads, administrative (other resource providers, for example: SQL-RP) or tenant (for example: tenant apps, which require a database), are permitted to make use of this infrastructure.

## Operational responsibility of file and sql servers

Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server.  The resource provider does not manage these resources.  The cloud operator is responsible for backing up the App Service databases and tenant content file share.

## Retrieve the Azure Resource Manager root certificate for Azure Stack Hub

Open an elevated PowerShell session on a computer that can reach the privileged endpoint on the Azure Stack Hub Integrated System or ASDK Host.

Run the *Get-AzureStackRootCert.ps1* script from the folder where you extracted the helper scripts. The script creates a root certificate in the same folder as the script that App Service needs for creating certificates.

When you run the following PowerShell command, you have to provide the privileged endpoint and the credentials for the AzureStack\CloudAdmin.

```powershell
    Get-AzureStackRootCert.ps1
```

#### Get-AzureStackRootCert.ps1 script parameters

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| PrivilegedEndpoint | Required | AzS-ERCS01 | Privileged endpoint |
| CloudAdminCredential | Required | AzureStack\CloudAdmin | Domain account credential for Azure Stack Hub cloud admins |

## Network and identity configuration

### Virtual network

> [!NOTE]
> The precreation of a custom virtual network is optional as the Azure App Service on Azure Stack Hub can create the required virtual network but will then need to communicate with SQL and File Server via public IP addresses.  Should you use the App Service HA File Server and SQL Server Quickstart template to deploy the pre-requisite SQL and File Server resources, the template will also deploy a virtual network.

Azure App Service on Azure Stack Hub lets you deploy the resource provider to an existing virtual network or lets you create a virtual network as part of the deployment. Using an existing virtual network enables the use of internal IPs to connect to the file server and SQL Server required by Azure App Service on Azure Stack Hub. The virtual network must be configured with the following address range and subnets before installing Azure App Service on Azure Stack Hub:

Virtual network - /16

Subnets

- ControllersSubnet /24
- ManagementServersSubnet /24
- FrontEndsSubnet /24
- PublishersSubnet /24
- WorkersSubnet /21

>[!IMPORTANT]
> If you choose to deploy App Service in an existing virtual network the SQL Server should be deployed into a separate Subnet from App Service and the File Server.
>

### Create an Identity Application to Enable SSO Scenarios

Azure App Service uses an Identity Application (Service Principal) to support the following operations:

- Virtual machine scale set integration on worker tiers.
- SSO for the Azure Functions portal and advanced developer tools (Kudu).

Depending on which identity provider the Azure Stack Hub is using, Azure Active Directory (Azure AD) or Active Directory Federation Services (ADFS) you must follow the appropriate steps below to create the service principal for use by the Azure App Service on Azure Stack Hub resource provider.

::: zone pivot="state-connected"
#### Create an Azure AD App

Follow these steps to create the service principal in your Azure AD tenant:

1. Open a PowerShell instance as azurestack\AzureStackAdmin.
1. Go to the location of the scripts that you downloaded and extracted in the [prerequisite step](azure-stack-app-service-before-you-get-started.md#installer-and-helper-scripts).
1. [Install PowerShell for Azure Stack Hub](powershell-install-az-module.md).
1. Run the **Create-AADIdentityApp.ps1** script. When you're prompted, enter the Azure AD tenant ID that you're using for your Azure Stack Hub deployment. For example, enter **myazurestack.onmicrosoft.com**.
1. In the **Credential** window, enter your Azure AD service admin account and password. Select **OK**.
1. Enter the certificate file path and certificate password for the [certificate created earlier](azure-stack-app-service-before-you-get-started.md). The certificate created for this step by default is **sso.appservice.local.azurestack.external.pfx**.
1. Make note of the application ID that's returned in the PowerShell output. You use the ID in the following steps to provide consent for the application's permissions, and during installation. 
1. Open a new browser window, and sign in to the [Azure portal](https://portal.azure.com) as the Azure Active Directory service admin.
1. Open the Azure Active Directory service.
1. Select **App Registrations** in the left pane.
1. Search for the application ID you noted in step 7. 
1. Select the App Service application registration from the list.
1. Select **API permissions** in the left pane.
1. Select **Grant admin consent for \<tenant\>**, where \<tenant\> is the name of your Azure AD tenant. Confirm the consent grant by selecting **Yes**.

```powershell
    Create-AADIdentityApp.ps1
```

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| DirectoryTenantName | Required | Null | Azure AD tenant ID. Provide the GUID or string. An example is myazureaaddirectory.onmicrosoft.com. |
| AdminArmEndpoint | Required | Null | Admin Azure Resource Manager endpoint. An example is adminmanagement.local.azurestack.external. |
| TenantARMEndpoint | Required | Null | Tenant Azure Resource Manager endpoint. An example is management.local.azurestack.external. |
| AzureStackAdminCredential | Required | Null | Azure AD service admin credential. |
| CertificateFilePath | Required | Null | **Full path** to the identity application certificate file generated earlier. |
| CertificatePassword | Required | Null | Password that helps protect the certificate private key. |
| Environment | Optional | AzureCloud | The name of the supported Cloud Environment in which the target Azure Active Directory Graph Service is available.  Allowed values: 'AzureCloud', 'AzureChinaCloud', 'AzureUSGovernment', 'AzureGermanCloud'.|
::: zone-end

#### Create an ADFS app

1. Open a PowerShell instance as azurestack\AzureStackAdmin.
1. Go to the location of the scripts that you downloaded and extracted in the [prerequisite step](azure-stack-app-service-before-you-get-started.md#installer-and-helper-scripts).
1. [Install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).
1. Run the **Create-ADFSIdentityApp.ps1** script.
1. In the **Credential** window, enter your AD FS cloud admin account and password. Select **OK**.
1. Provide the certificate file path and certificate password for the [certificate created earlier](azure-stack-app-service-before-you-get-started.md). The certificate created for this step by default is **sso.appservice.local.azurestack.external.pfx**.

```powershell
    Create-ADFSIdentityApp.ps1
```

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| AdminArmEndpoint | Required | Null | Admin Azure Resource Manager endpoint. An example is adminmanagement.local.azurestack.external. |
| PrivilegedEndpoint | Required | Null | Privileged endpoint. An example is AzS-ERCS01. |
| CloudAdminCredential | Required | Null | Domain account credential for Azure Stack Hub cloud admins. An example is Azurestack\CloudAdmin. |
| CertificateFilePath | Required | Null | **Full path** to the identity application's certificate PFX file. |
| CertificatePassword | Required | Null | Password that helps protect the certificate private key. |

<!--Connected/Disconnected-->

### Download items from the Azure Marketplace

Azure App Service on Azure Stack Hub requires items to be [downloaded from the Azure Marketplace](azure-stack-download-azure-marketplace-item.md), making them available in the Azure Stack Hub Marketplace. These items must be downloaded before you start the deployment or upgrade of Azure App Service on Azure Stack Hub:

> [!IMPORTANT]
> Windows Server Core is not a supported platform image for use with Azure App Service on Azure Stack Hub.
>
> Do not use evaluation images for production deployments.
>

<!-- Connected --->
::: zone pivot="state-connected"
# [Azure App Service on Azure Stack 2022 H1](#tab/2022H1-connected)
1. The **latest version of Windows Server 2022 Datacenter VM image**.

# [Previous versions](#tab/previous-connected)
1. The **latest version of Windows Server 2016 Datacenter VM image**.
::: zone-end

::: zone pivot="state-disconnected"
<!-- Disconnected --->
# [Azure App Service on Azure Stack 2022 H1](#tab/2022H1-disconnected)
1. **Windows Server 2022 Datacenter Full VM image with Microsoft.Net 3.5.1 SP1 activated**.  Azure App Service on Azure Stack Hub requires that Microsoft .NET 3.5.1 SP1 is activated on the image used for deployment. Marketplace-syndicated Windows Server 2022 images don't have this feature enabled and in disconnected environments are unable to reach Microsoft Update to download the packages to install via DISM. Therefore, you must create and use a Windows Server 2022 image with this feature pre-enabled with disconnected deployments.

   See [Add a custom VM image to Azure Stack Hub](azure-stack-add-vm-image.md) for details on creating a custom image and adding to Marketplace. Be sure to specify the following properties when adding the image to Marketplace:

   - Publisher = MicrosoftWindowsServer
   - Offer = WindowsServer
   - SKU = AppService
   - Version = Specify the "latest" version

# [Previous versions](#tab/previous-disconnected)
1. **Windows Server 2016 Datacenter Full VM image with Microsoft.Net 3.5.1 SP1 activated**.  Azure App Service on Azure Stack Hub requires that Microsoft .NET 3.5.1 SP1 is activated on the image used for deployment. Marketplace-syndicated Windows Server 2016 images don't have this feature enabled and in disconnected environments are unable to reach Microsoft Update to download the packages to install via DISM. Therefore, you must create and use a Windows Server 2016 image with this feature pre-enabled with disconnected deployments.

   See [Add a custom VM image to Azure Stack Hub](azure-stack-add-vm-image.md) for details on creating a custom image and adding to Marketplace. Be sure to specify the following properties when adding the image to Marketplace:

   - Publisher = MicrosoftWindowsServer
   - Offer = WindowsServer
   - SKU = 2016-Datacenter
   - Version = Specify the "latest" version

::: zone-end

<!-- For All --> 
2. **Custom Script Extension v1.9.1 or greater**. This item is a VM extension.

## Next steps

[Install the App Service resource provider](azure-stack-app-service-deploy.md)
