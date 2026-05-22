---
title: Prerequisites to deploy Azure App Service on Azure Stack Hub 
description: Learn the prerequisite steps to complete before you deploy Azure App Service on Azure Stack Hub.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.custom:
  - devx-track-arm-template
ms.date: 05/22/2026
ms.author: sethm
ms.reviewer: anwestg
ms.lastreviewed: 10/28/2019
zone_pivot_groups: state-connected-disconnected

# Intent: As an Azure Stack operator, I want to know the prerequisites steps to complete before deploying App Service.
# Keyword: app service prerequisites azure stack
---

# Prerequisites for deploying App Service on Azure Stack Hub

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

Before you deploy Azure App Service on Azure Stack Hub, complete the prerequisite steps in this article.

## Before you get started 

This section lists the prerequisites for Azure Stack Hub integrated systems deployments.

### Resource provider prerequisites

[!INCLUDE [Common RP prerequisites](../includes/resource-provider-prerequisites.md)]

### Installer and helper scripts

1. Download the [App Service on Azure Stack Hub deployment helper scripts](https://aka.ms/appsvconmashelpers).

   > [!NOTE]
   > The deployment helper scripts require the AzureRM PowerShell module. For installation details, see [Install PowerShell AzureRM module for Azure Stack Hub](azure-stack-powershell-install.md).

1. Download the [App Service on Azure Stack Hub installer](https://aka.ms/appsvconmasinstaller).
1. Extract the files from the helper scripts .zip file. The following files and folders are extracted:

   - Common.ps1
   - Create-AADIdentityApp.ps1
   - Create-ADFSIdentityApp.ps1
   - Create-AppServiceCerts.ps1
   - Get-AzureStackRootCert.ps1
   - BCDR
     - ReACL.cmd
   - Modules folder
     - GraphAPI.psm1

<!-- MultiNode only --->
## Certificates and server configuration (integrated systems)

This section lists the prerequisites for integrated system deployments.

### Certificate requirements

To run the resource provider in production, you must provide the following certificates:

- Default domain certificate
- API certificate
- Publishing certificate
- Identity certificate

In addition to the specific requirements listed in the following sections, you also use a tool later to test for general requirements. See [Validate Azure Stack Hub PKI certificates](azure-stack-validate-pki-certs.md) for the complete list of validations, including:

- File format of .PFX
- Key usage set to server and client authentication
- And several others.

#### Default domain certificate

Place the default domain certificate on the front-end role. User apps for wildcard or default domain request to Azure App Service use this certificate. The certificate also secures source control operations (Kudu).

The certificate must be in .pfx format and should be a three-subject wildcard certificate. This requirement allows one certificate to cover both the default domain and the SCM endpoint for source control operations.

| Format | Example |
| --- | --- |
| `*.appservice.<region>.<DomainName>.<extension>` | `*.appservice.redmond.azurestack.external` |
| `*.scm.appservice.<region>.<DomainName>.<extension>` | `*.scm.appservice.redmond.azurestack.external` |
| `*.sso.appservice.<region>.<DomainName>.<extension>` | `*.sso.appservice.redmond.azurestack.external` |

#### API certificate

Place the API certificate on the management role. The resource provider uses it to help secure API calls. The certificate for publishing must contain a subject that matches the API DNS entry.

| Format | Example |
| --- | --- |
| api.appservice.\<region\>.\<DomainName\>.\<extension\> | api.appservice.redmond.azurestack.external |

#### Publishing certificate

The certificate for the publisher role secures the FTPS traffic for app owners when they upload content. The certificate for publishing must contain a subject that matches the FTPS DNS entry.

| Format | Example |
| --- | --- |
| ftp.appservice.\<region\>.\<DomainName\>.\<extension\> | ftp.appservice.redmond.azurestack.external |

#### Identity certificate

The certificate for the identity app enables:

- Integration between the Microsoft Entra ID or Active Directory Federation Services (AD FS) directory, Azure Stack Hub, and App Service to support integration with the compute resource provider.
- Single sign-on scenarios for advanced developer tools within Azure App Service on Azure Stack Hub.

The certificate for identity must contain a subject that matches the following format.

| Format | Example |
| --- | --- |
| sso.appservice.\<region\>.\<DomainName\>.\<extension\> | sso.appservice.redmond.azurestack.external |

### Validate certificates

Before you deploy the App Service resource provider, [validate the certificates to use](azure-stack-validate-pki-certs.md) by using the Azure Stack Hub Readiness Checker tool available from the [PowerShell Gallery](https://aka.ms/AzsReadinessChecker). The Azure Stack Hub Readiness Checker Tool validates that the generated PKI certificates are suitable for App Service deployment.

As a best practice, when working with any of the necessary [Azure Stack Hub PKI certificates](azure-stack-pki-certs.md), plan enough time to test and reissue certificates if necessary.

### Prepare the file server

Azure App Service requires a file server. For production deployments, you must configure the file server to be highly available and capable of handling failures.

#### Quickstart template for highly available file server and SQL Server

A [reference architecture quickstart template](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/appservice-fileserver-sqlserver-ha) is now available that deploys a file server and SQL Server. This template supports Active Directory infrastructure in a virtual network configured to support a highly available deployment of Azure App Service on Azure Stack Hub.

>[!IMPORTANT]
> The Azure Stack Hub operator manages these servers, especially in production environments. You should configure the template as needed or required by your organization.

> [!NOTE]
> The integrated system instance must be able to download resources from GitHub to complete the deployment.

#### Steps to deploy a custom file server

> [!IMPORTANT]
> If you choose to deploy App Service in an existing virtual network, deploy the file server into a separate subnet from App Service.

> [!NOTE]
> If you chose to deploy a file server by using either of the Quickstart templates mentioned earlier, you can skip this section as the file servers are configured as part of the template deployment.

##### Provision groups and accounts in Active Directory

1. Create the following Active Directory global security groups:

   - FileShareOwners
   - FileShareUsers

1. Create the following Active Directory accounts as service accounts:

   - FileShareOwner
   - FileShareUser

   As a security best practice, use unique users for these accounts (and for all web roles) and use strong usernames and passwords. Set the passwords with the following conditions:

   - Enable **Password never expires**.
   - Enable **User cannot change password**.
   - Disable **User must change password at next logon**.

1. Add the accounts to the group memberships as follows:

   - Add **FileShareOwner** to the **FileShareOwners** group.
   - Add **FileShareUser** to the **FileShareUsers** group.

##### Provision groups and accounts in a workgroup

> [!NOTE]
> When you configure a file server, run all the following commands from an administrator command prompt. Don't use PowerShell.

When you use the Azure Resource Manager template, the users are already created.

1. Run the following commands to create the **FileShareOwner** and **FileShareUser** accounts. Replace `<password>` with your own values.

   ```bash
   net user FileShareOwner <password> /add /expires:never /passwordchg:no
   net user FileShareUser <password> /add /expires:never /passwordchg:no
   ```

1. Set the passwords for the accounts to never expire by running the following WMIC commands:

   ```bash
   WMIC USERACCOUNT WHERE "Name='FileShareOwner'" SET PasswordExpires=FALSE
   WMIC USERACCOUNT WHERE "Name='FileShareUser'" SET PasswordExpires=FALSE
   ```

1. Create the local groups **FileShareUsers** and **FileShareOwners**, and add the accounts in the first step to them:

   ```bash
   net localgroup FileShareUsers /add
   net localgroup FileShareUsers FileShareUser /add
   net localgroup FileShareOwners /add
   net localgroup FileShareOwners FileShareOwner /add
   ```

#### Provision the content share

The content share contains tenant website content. The procedure to provision the content share on a single file server is the same for both Active Directory and workgroup environments. It's different for a failover cluster in Active Directory.

#### Provision the content share on a single file server (Active Directory or workgroup)

On a single file server, run the following commands in an elevated command prompt. Replace the value for `C:\WebSites` with the corresponding paths in your environment.

```bash
set WEBSITES_SHARE=WebSites
set WEBSITES_FOLDER=C:\WebSites
md %WEBSITES_FOLDER%
net share %WEBSITES_SHARE% /delete
net share %WEBSITES_SHARE%=%WEBSITES_FOLDER% /grant:Everyone,full
```

### Configure access control to the shares

Run the following commands in an elevated command prompt on the file server or on the failover cluster node, which is the current cluster resource owner. Replace variables with the values that are specific to your environment.

#### Active Directory

```bash
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

```bash
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
> If you chose to deploy the Quickstart template for Highly Available File Server and SQL Server, you can skip this section as the template deploys and configures SQL Server in a HA configuration.

For the Azure App Service on Azure Stack Hub hosting and metering databases, you must prepare a SQL Server instance to hold the App Service databases.

For production and high-availability purposes, use a full version of SQL Server 2016 SP3 or later, enable mixed-mode authentication, and deploy in a [highly available configuration](/sql/sql-server/failover-clusters/high-availability-solutions-sql-server).

All App Service roles must access the SQL Server instance for Azure App Service on Azure Stack Hub. You can deploy SQL Server within the default provider subscription in Azure Stack Hub. Or you can use the existing infrastructure within your organization, as long as there's connectivity to Azure Stack Hub. If you're using an Azure Marketplace image, remember to configure the firewall accordingly.

> [!NOTE]
> A number of SQL IaaS VM images are available through the Marketplace Management feature. Make sure you always download the latest version of the SQL IaaS Extension before you deploy a VM using a Marketplace item. The SQL images are the same as the SQL VMs that are available in Azure. For SQL VMs created from these images, the IaaS extension and corresponding portal enhancements provide features such as automatic patching and backup capabilities.
>
> For any of the SQL Server roles, you can use a default instance or a named instance. If you use a named instance, be sure to manually start the SQL Server browser service and open port 1434.

The App Service installer checks to ensure the SQL Server has database containment enabled. To enable database containment on the SQL Server that hosts the App Service databases, run these SQL commands:

```sql
sp_configure 'contained database authentication', 1;
GO
RECONFIGURE;
GO
```

## Licensing concerns for required file server and SQL Server

Azure App Service on Azure Stack Hub requires a file server and SQL Server to operate. You can use pre-existing resources located outside of your Azure Stack Hub deployment or deploy resources within your Azure Stack Hub default provider subscription.

If you choose to deploy the resources within your Azure Stack Hub default provider subscription, the cost of Azure App Service on Azure Stack Hub includes the licenses for those resources (Windows Server licenses and SQL Server licenses) subject to the following constraints:

- You deploy the infrastructure into the default provider subscription.
- The Azure App Service on Azure Stack Hub resource provider exclusively uses the infrastructure. No other workloads, administrative (other resource providers, for example: SQL-RP), or tenant (for example tenant apps, which require a database) workloads are permitted to use this infrastructure.

## Operational responsibility of file and SQL servers

Cloud operators are responsible for the maintenance and operation of the file server and SQL Server. The resource provider doesn't manage these resources. The cloud operator is responsible for backing up the App Service databases and tenant content file share.

## Retrieve the Azure Resource Manager root certificate for Azure Stack Hub

Open an elevated PowerShell session on a computer that can reach the privileged endpoint on the Azure Stack Hub integrated system.

Run the `Get-AzureStackRootCert.ps1` script from the folder where you extracted the helper scripts. The script creates a root certificate in the same folder as the script that App Service needs for creating certificates.

When you run the following PowerShell command, provide the privileged endpoint and the credentials for the AzureStack\CloudAdmin:

```powershell
Get-AzureStackRootCert.ps1
```

#### Get-AzureStackRootCert.ps1 script parameters

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| `PrivilegedEndpoint` | Required | AzS-ERCS01 | Privileged endpoint |
| `CloudAdminCredential` | Required | AzureStack\CloudAdmin | Domain account credential for Azure Stack Hub cloud admins |

## Network and identity configuration

The network and identity configuration for Azure App Service on Azure Stack Hub involves setting up the necessary network infrastructure and identity management to support the resource provider.

### Virtual network

> [!NOTE]
> Precreating a custom virtual network is optional. Azure App Service on Azure Stack Hub can create the required virtual network but then must communicate with SQL and the file server through public IP addresses. If you use the App Service HA file server and SQL Server quickstart template to deploy the prerequisite SQL and file server resources, the template also deploys a virtual network.

Azure App Service on Azure Stack Hub enables you to deploy the resource provider to an existing virtual network or create a virtual network as part of the deployment. If you use an existing virtual network, you can use internal IPs to connect to the file server and SQL Server that Azure App Service on Azure Stack Hub requires. Before you install Azure App Service on Azure Stack Hub, configure the virtual network with the following address range and subnets:

Virtual network - /16

Subnets

- ControllersSubnet /24
- ManagementServersSubnet /24
- FrontEndsSubnet /24
- PublishersSubnet /24
- WorkersSubnet /21

> [!IMPORTANT]
> If you choose to deploy App Service in an existing virtual network, deploy SQL Server into a separate subnet from App Service and the file server.

### Create an identity application to enable SSO scenarios

Azure App Service uses an identity application (service principal) to support the following operations:

- Virtual machine scale set integration on worker tiers.
- SSO for the Azure Functions portal and advanced developer tools (Kudu).

Depending on which identity provider Azure Stack Hub uses, Microsoft Entra ID or Active Directory Federation Services (AD FS), follow the appropriate steps to create the service principal for use by Azure App Service on the Azure Stack Hub resource provider.

::: zone pivot="state-connected"

#### Create a Microsoft Entra App

Follow these steps to create the service principal in your Microsoft Entra tenant:

1. Open a PowerShell instance as **azurestack\AzureStackAdmin**.
1. Go to the location of the scripts that you downloaded and extracted in the [prerequisite step](#installer-and-helper-scripts).
1. [Install PowerShell for Azure Stack Hub](powershell-install-az-module.md).
1. Run the [**Create-AADIdentityApp.ps1**](#create-aadidentityapp-powershell-script) script. When prompted, enter the Microsoft Entra tenant ID that you're using for your Azure Stack Hub deployment. For example, enter **myazurestack.onmicrosoft.com**.
1. In the **Credential** window, enter your Microsoft Entra service admin account and password. Select **OK**.
1. Enter the certificate file path and certificate password for the [certificate you created earlier](#certificates-and-server-configuration-integrated-systems). The certificate you created for this step by default is **sso.appservice.local.azurestack.external.pfx**.
1. Make a note of the application ID that's returned in the PowerShell output. You use the ID in the following steps to provide consent for the application's permissions, and during installation. 
1. Open a new browser window, and sign in to the [Azure portal](https://portal.azure.com) as the Microsoft Entra service admin.
1. Open the Microsoft Entra service.
1. Select **App Registrations** in the left pane.
1. Search for the application ID you noted in step 7. 
1. Select the App Service application registration from the list.
1. Select **API permissions** in the left pane.
1. Select **Grant admin consent for \<tenant\>**, where `<tenant>` is the name of your Microsoft Entra tenant. Confirm the consent grant by selecting **Yes**.
1. For multitenancy scenarios, run the following PowerShell script to grant the **Directory.Read.All** and **user_impersonation** permissions to the App Services App Registration using the Azure Resource Manager admin endpoint.

   ```powershell
   $adminarmendpoint = "https://adminmanagement.xxx.xxx.ro/"
   Add-AzEnvironment -Name "AzureStackAdmin" -ArmEndpoint $userarmendpoint
   #Home directory
   $AADTenantName = "xxx"
   $authEndpoint = (Get-AzEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
   $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
   Login-AzAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantID
   $Location = 'xxxx'
   $AppServicesAppId = '' # the identity app's application id, use Azure portal to obtain it - Entra ID - App Registration - App Services   Application ID
   $AppServicesObjectId = '' # the identity app's object id, use Azure portal to get it - Entra ID - App Registration - App Services  Object ID
   
   #The property 'applicationId' in the json returned from 'https://<AdminArmEndpoint>/metadata/identity?api-version=2015-01-01'
   $TenantArmAppId = (Invoke-WebRequest https://adminmanagement.xxxx.xxx.ro/metadata/identity?api-version=2015-01-01 -UseBasicParsing | select -ExpandProperty Content | ConvertFrom-Json | select applicationId).applicationId

    $params = @{
       ResourceGroupName = "system.$Location"
       ResourceType = 'Microsoft.Subscriptions.Providers/applicationRegistrations'
       ResourceName = 'AppService'
       ApiVersion = '2018-05-01'
       Location = $Location
       Properties = @{
           appId = $AppServicesAppId
           objectId = $AppServicesObjectId
           appRoleAssignments = @(@{
               client = $AppServicesAppId
               roleId = ([guid]('5778995a-e1bf-45b8-affa-663a9f3f4d04')).ToString() # Well known value for the 'Directory.Read.All' permission
               resource = ([guid]('00000002-0000-0000-c000-000000000000')).ToString() # Well known value for Microsoft.Azure.ActiveDirectory
           })
           oAuth2PermissionGrants = @(@{
               client = $AppServicesAppId
               resource = ([guid]('00000002-0000-0000-c000-000000000000')).ToString() # Well known value for Microsoft.Azure.ActiveDirectory
               scope = 'User.Read Directory.Read.All'
           }, @{
               client = $AppServicesAppId
               resource = $tenantArmAppId
               scope = 'user_impersonation'
           })
       }
   }
   New-AzResource @params -Verbose -Force
   ```

   Once this script is executed, each tenant that needs to use App Services must re-run the registration script. See [Configure multi-tenancy in Azure Stack Hub](enable-multitenancy.md?view=azs-2601&pivots=management-tool-powershell&preserve-view=true).

#### Create-AADIdentityApp PowerShell script

```powershell
Create-AADIdentityApp.ps1
```

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| `DirectoryTenantName` | Required | Null | Microsoft Entra tenant ID. Provide the GUID or string. An example is `myazureaaddirectory.onmicrosoft.com`. |
| `AdminArmEndpoint` | Required | Null | Admin Azure Resource Manager endpoint. An example is `adminmanagement.local.azurestack.external`. |
| `TenantARMEndpoint` | Required | Null | Tenant Azure Resource Manager endpoint. An example is `management.local.azurestack.external`. |
| `AzureStackAdminCredential` | Required | Null | Microsoft Entra service admin credential. |
| `CertificateFilePath` | Required | Null | Full path to the identity application certificate file generated earlier. |
| `CertificatePassword` | Required | Null | Password that helps protect the certificate private key. |
| `Environment` | Optional | AzureCloud | The name of the supported cloud environment in which the target Azure Active Directory Graph Service is available. Allowed values: `AzureCloud`, `AzureChinaCloud`, `AzureUSGovernment`, `AzureGermanCloud`.|
::: zone-end

#### Create an ADFS app

1. Open a PowerShell instance as **azurestack\AzureStackAdmin**.
1. Go to the location of the scripts that you downloaded and extracted in the [prerequisite step](azure-stack-app-service-before-you-get-started.md#installer-and-helper-scripts).
1. [Install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).
1. Run the **Create-ADFSIdentityApp.ps1** script.
1. In the **Credential** window, enter your AD FS cloud admin account and password. Select **OK**.
1. Provide the certificate file path and certificate password for the [certificate you created earlier](#certificates-and-server-configuration-integrated-systems). The certificate created for this step by default is **sso.appservice.local.azurestack.external.pfx**.

```powershell
Create-ADFSIdentityApp.ps1
```

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| `AdminArmEndpoint` | Required | Null | Admin Azure Resource Manager endpoint. An example is `adminmanagement.local.azurestack.external`. |
| `PrivilegedEndpoint` | Required | Null | Privileged endpoint. An example is `AzS-ERCS01`. |
| `CloudAdminCredential` | Required | Null | Domain account credential for Azure Stack Hub cloud admins. An example is `Azurestack\CloudAdmin`. |
| `CertificateFilePath` | Required | Null | Full path to the identity application's certificate PFX file. |
| `CertificatePassword` | Required | Null | Password that helps protect the certificate private key. |

<!--Connected/Disconnected-->

### Download items from the Azure Marketplace

Azure App Service on Azure Stack Hub requires you to [download items from the Azure Marketplace](azure-stack-download-azure-marketplace-item.md) to make them available in the Azure Stack Hub Marketplace. Before you start the deployment or upgrade of Azure App Service on Azure Stack Hub, download these items:

> [!IMPORTANT]
> Windows Server Core isn't a supported platform image for use with Azure App Service on Azure Stack Hub.
>
> Don't use evaluation images for production deployments.
>

<!-- Connected --->
::: zone pivot="state-connected"
# [Azure App Service on Azure Stack 2022 H1](#tab/2022H1-connected)
1. The latest version of Windows Server 2022 Datacenter VM image.

# [Previous versions](#tab/previous-connected)
1. The latest version of Windows Server 2016 Datacenter VM image.
::: zone-end

::: zone pivot="state-disconnected"
<!-- Disconnected --->
# [Azure App Service on Azure Stack 2022 H1](#tab/2022H1-disconnected)
1. Windows Server 2022 Datacenter full VM image with Microsoft .NET 3.5.1 SP1 activated. Azure App Service on Azure Stack Hub requires that Microsoft .NET 3.5.1 SP1 is activated on the image used for deployment. Marketplace-syndicated Windows Server 2022 images don't have this feature enabled. In disconnected environments, the image can't reach Microsoft Update to download the packages to install using DISM. Therefore, you must create and use a Windows Server 2022 image with this feature pre-enabled for disconnected deployments.

   For information about creating a custom image and adding it to the Marketplace, see [Add a custom VM image to Azure Stack Hub](azure-stack-add-vm-image.md). Be sure to specify the following properties when adding the image to Marketplace:

   - Publisher = MicrosoftWindowsServer
   - Offer = WindowsServer
   - SKU = AppService
   - Version = Specify the "latest" version

# [Previous versions](#tab/previous-disconnected)
1. Windows Server 2016 Datacenter full VM image with Microsoft .NET 3.5.1 SP1 activated. Azure App Service on Azure Stack Hub requires that Microsoft .NET 3.5.1 SP1 is activated on the image used for deployment. Marketplace-syndicated Windows Server 2016 images don't have this feature enabled. In disconnected environments, the image can't reach Microsoft Update to download the packages to install by using DISM. Therefore, you must create and use a Windows Server 2016 image with this feature pre-enabled for disconnected deployments.

   For information about creating a custom image and adding it to the Marketplace, see [Add a custom VM image to Azure Stack Hub](azure-stack-add-vm-image.md). Be sure to specify the following properties when adding the image to Marketplace:

   - Publisher = MicrosoftWindowsServer
   - Offer = WindowsServer
   - SKU = 2016-Datacenter
   - Version = Specify the "latest" version

::: zone-end

<!-- For All --> 
2. Custom Script Extension v1.9.1 or greater. This item is a VM extension.

## Next steps

[Install the App Service resource provider](azure-stack-app-service-deploy.md)
