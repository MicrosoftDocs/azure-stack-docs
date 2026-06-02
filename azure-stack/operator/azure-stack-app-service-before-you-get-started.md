---
title: Prerequisites to Deploy Azure App Service on Azure Stack Hub 
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

# Intent: As an Azure Stack operator, I want to know the prerequisite steps to complete before deploying App Service so that I can ensure a successful deployment.
# Keyword: app service prerequisites azure stack
---

# Prerequisites for deploying App Service on Azure Stack Hub

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

Before you deploy Azure App Service on Azure Stack Hub, complete the prerequisite steps in this article.

## Azure Stack Hub integrated system deployments

### Resource provider prerequisites

[!INCLUDE [Common RP prerequisites](../includes/resource-provider-prerequisites.md)]

### Installer and helper scripts

1. Download the [helper scripts for deployment of App Service on Azure Stack Hub](https://aka.ms/appsvconmashelpers).

   The deployment helper scripts require the AzureRM PowerShell module. For installation details, see [Install PowerShell Az and Azure Stack modules for Azure Stack Hub](azure-stack-powershell-install.md).

1. Download the [installer for App Service on Azure Stack Hub](https://aka.ms/appsvconmasinstaller).

1. Extract the contents of the .zip file for the helper scripts. The following files and folders are extracted:

   - Common.ps1
   - Create-AADIdentityApp.ps1
   - Create-ADFSIdentityApp.ps1
   - Create-AppServiceCerts.ps1
   - Get-AzureStackRootCert.ps1
   - BCDR
     - ReACL.cmd
   - Modules folder
     - GraphAPI.psm1

### Certificate requirements

To run the resource provider in production, you must provide the following certificates:

- Default domain certificate
- API certificate
- Publishing certificate
- Identity certificate

In addition to the specific requirements listed in the following sections, you use a tool later to test for general requirements. For the complete list of validations, see [Validate Azure Stack Hub PKI certificates](azure-stack-validate-pki-certs.md). The validations include:

- File format of .pfx.
- Key usage set to server and client authentication.
- Several others.

#### Default domain certificate

Place the default domain certificate on the front-end role. User apps for wildcard or default domain requests to Azure App Service use this certificate. The certificate also secures source control operations (Kudu).

The certificate must be in .pfx format and should be a three-subject wildcard certificate. This requirement allows one certificate to cover both the default domain and the `scm` endpoint for source control operations.

| Format | Example |
| --- | --- |
| `*.appservice.<region>.<DomainName>.<extension>` | `*.appservice.redmond.azurestack.external` |
| `*.scm.appservice.<region>.<DomainName>.<extension>` | `*.scm.appservice.redmond.azurestack.external` |
| `*.sso.appservice.<region>.<DomainName>.<extension>` | `*.sso.appservice.redmond.azurestack.external` |

#### API certificate

Place the API certificate on the management role. The resource provider uses it to help secure API calls. The certificate for publishing must contain a subject that matches the API DNS entry.

| Format | Example |
| --- | --- |
| `api.appservice.<region>.<DomainName>.<extension>` | `api.appservice.redmond.azurestack.external` |

#### Publishing certificate

The certificate for the publisher role helps secure the FTPS traffic for app owners when they upload content. The certificate for publishing must contain a subject that matches the FTPS DNS entry.

| Format | Example |
| --- | --- |
| `ftp.appservice.<region>.<DomainName>.<extension>` | `ftp.appservice.redmond.azurestack.external` |

#### Identity certificate

The certificate for the identity app enables:

- Integration between the Microsoft Entra or Active Directory Federation Services (AD FS) directory, Azure Stack Hub, and App Service to support integration with the compute resource provider.
- Single sign-on (SSO) scenarios for advanced developer tools within Azure App Service on Azure Stack Hub.

The identity certificate must contain a subject that matches the following format.

| Format | Example |
| --- | --- |
| `sso.appservice.<region>.<DomainName>.<extension>` | `sso.appservice.redmond.azurestack.external` |

### Certificate validation

Before you deploy the App Service resource provider, [validate the certificates](azure-stack-validate-pki-certs.md) by using the Azure Stack Hub Readiness Checker tool available from the [PowerShell Gallery](https://aka.ms/AzsReadinessChecker). The Azure Stack Hub Readiness Checker Tool validates that the generated PKI certificates are suitable for App Service deployment.

When you're working with any of the necessary [Azure Stack Hub PKI certificates](azure-stack-pki-certs.md), plan enough time to test and reissue certificates if necessary.

### <a name = "prepare-the-file-server"></a>Preparation of the file server

Azure App Service requires a file server. For production deployments, you must configure the file server to be highly available and capable of handling failures.

#### Use a quickstart template for a file server and SQL Server

A [quickstart template for a reference architecture](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/appservice-fileserver-sqlserver-ha) is available for deploying a highly available file server and SQL Server. This template supports Active Directory infrastructure in a virtual network that's configured to support a highly available deployment of Azure App Service on Azure Stack Hub.

The Azure Stack Hub operator manages these servers, especially in production environments. Configure the template as needed or required for your organization.

> [!NOTE]
> The integrated system instance must be able to download resources from GitHub to complete the deployment.

#### Deploy a custom file server

If you choose to deploy App Service in an existing virtual network, deploy the file server into a separate subnet from App Service.

If you choose to deploy a file server by using either of the quickstart templates mentioned earlier, you can skip this section. The file servers are configured as part of the template deployment.

##### Provision groups and accounts in Active Directory

1. Create the following Active Directory global security groups:

   - **FileShareOwners**
   - **FileShareUsers**

1. Create the following Active Directory accounts as service accounts:

   - **FileShareOwner**
   - **FileShareUser**

   As a security best practice, use unique users for these accounts (and for all web roles). Also use strong usernames and passwords. Set the passwords with the following conditions:

   - Enable **Password never expires**.
   - Enable **User cannot change password**.
   - Disable **User must change password at next logon**.

1. Add the accounts to the group memberships as follows:

   - Add **FileShareOwner** to the **FileShareOwners** group.
   - Add **FileShareUser** to the **FileShareUsers** group.

##### Provision groups and accounts in a workgroup

When you configure a file server, run all the following commands from an administrator command prompt. Don't use PowerShell.

When you use the Azure Resource Manager template, the users are already created.

1. Run the following commands to create the **FileShareOwner** and **FileShareUser** accounts. Replace `<password>` with your own values.

   ```bash
   net user FileShareOwner <password> /add /expires:never /passwordchg:no
   net user FileShareUser <password> /add /expires:never /passwordchg:no
   ```

1. Set the passwords for the accounts to never expire by running the following `WMIC` commands:

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

On a single file server for Active Directory or a workgroup, run the following commands in an elevated command prompt. Replace the value for `C:\WebSites` with the corresponding paths in your environment.

```bash
set WEBSITES_SHARE=WebSites
set WEBSITES_FOLDER=C:\WebSites
md %WEBSITES_FOLDER%
net share %WEBSITES_SHARE% /delete
net share %WEBSITES_SHARE%=%WEBSITES_FOLDER% /grant:Everyone,full
```

### Configuration of access control to the shares

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

### <a name = "prepare-the-sql-server-instance"></a>Preparation of the SQL Server instance

> [!NOTE]
> If you chose to deploy the quickstart template for a highly available file server and SQL Server, you can skip this section. The template deploys and configures SQL Server in a highly available configuration.

For the hosting and metering databases for Azure App Service on Azure Stack Hub, you must prepare a SQL Server instance to hold the App Service databases.

For production and high-availability purposes, use a full version of SQL Server 2016 SP3 or later, enable mixed-mode authentication, and deploy in a [highly available configuration](/sql/sql-server/failover-clusters/high-availability-solutions-sql-server).

All App Service roles must access the SQL Server instance for Azure App Service on Azure Stack Hub. You can deploy SQL Server within the default provider subscription in Azure Stack Hub. Or you can use the existing infrastructure within your organization, as long as there's connectivity to Azure Stack Hub. If you're using a Microsoft Marketplace image, remember to configure the firewall accordingly.

> [!NOTE]
> SQL infrastructure as a service (IaaS) images for virtual machines (VMs) are available through the Marketplace Management feature. Be sure to always download the latest version of the SQL IaaS extension before you deploy a VM by using a Marketplace item. The SQL images are the same as the SQL VMs that are available in Azure. For SQL VMs created from these images, the IaaS extension and corresponding portal enhancements provide features such as automatic patching and backup capabilities.
>
> For any of the SQL Server roles, you can use a default instance or a named instance. If you use a named instance, be sure to manually start the SQL Server browser service and open port 1434.

The App Service installer checks to ensure that SQL Server has database containment enabled. To enable database containment on the SQL Server instance that hosts the App Service databases, run these SQL commands:

```sql
sp_configure 'contained database authentication', 1;
GO
RECONFIGURE;
GO
```

## <a name = "licensing-concerns-for-required-file-server-and-sql-server"></a>Licensing concerns for the required file server and SQL Server

Azure App Service on Azure Stack Hub requires a file server and SQL Server to operate. You can use preexisting resources located outside your Azure Stack Hub deployment or deploy resources within your Azure Stack Hub default provider subscription.

If you choose to deploy the resources within your Azure Stack Hub default provider subscription, the cost of Azure App Service on Azure Stack Hub includes the licenses for those resources (Windows Server licenses and SQL Server licenses). The licenses are subject to the following constraints:

- You deploy the infrastructure into the default provider subscription.
- The resource provider for Azure App Service on Azure Stack Hub exclusively uses the infrastructure. No other administrative (other resource providers, such as SQL-RP) workloads or tenant (for example, tenant apps that require a database) workloads are permitted to use this infrastructure.

## Operational responsibility for the file server and SQL Server

Cloud operators are responsible for the maintenance and operation of the file server and SQL Server. The resource provider doesn't manage these resources. The cloud operator is responsible for backing up the App Service databases and the tenant's content file share.

## Script for retrieving the Azure Resource Manager root certificate for Azure Stack Hub

Open an elevated PowerShell session on a computer that can reach the privileged endpoint on the Azure Stack Hub integrated system.

Run the `Get-AzureStackRootCert.ps1` script from the folder where you extracted the helper scripts. The script creates a root certificate in the same folder as the script that App Service needs for creating certificates.

When you run the following PowerShell command, provide the privileged endpoint and the credentials for `AzureStack\CloudAdmin`:

```powershell
Get-AzureStackRootCert.ps1
```

### Get-AzureStackRootCert.ps1 script parameters

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| `PrivilegedEndpoint` | Required | `AzS-ERCS01` | Privileged endpoint |
| `CloudAdminCredential` | Required | `AzureStack\CloudAdmin` | Domain account credential for Azure Stack Hub cloud admins |

## Network and identity configuration

The network and identity configuration for Azure App Service on Azure Stack Hub involves setting up the necessary network infrastructure and identity management to support the resource provider.

### <a name = "virtual-network"></a>Configure a virtual network

With Azure App Service on Azure Stack Hub, you can deploy the resource provider to an existing virtual network or create a virtual network as part of the deployment. If you use an existing virtual network, you can use internal IPs to connect to the file server and SQL Server instance that App Service on Azure Stack Hub requires.

Before you install App Service on Azure Stack Hub, configure the virtual network with the following address range and subnets:

- Virtual network, /16

- Subnets:

  - ControllersSubnet, /24
  - ManagementServersSubnet, /24
  - FrontEndsSubnet, /24
  - PublishersSubnet, /24
  - WorkersSubnet, /21

Creating a custom virtual network in advance is optional. Azure App Service on Azure Stack Hub can create the required virtual network, but then it must communicate with SQL Server and the file server through public IP addresses. If you use the quickstart template for the App Service highly available file server and SQL Server to deploy the prerequisite server resources, the template also deploys a virtual network.

> [!IMPORTANT]
> If you choose to deploy App Service in an existing virtual network, deploy SQL Server into a separate subnet from App Service and the file server.

### Create an identity application to enable SSO scenarios

Azure App Service uses an identity application (service principal) to support the following operations:

- Integration of virtual machine scale sets on worker tiers
- SSO for the Azure Functions portal and advanced developer tools (Kudu)

Depending on which identity provider Azure Stack Hub uses (Microsoft Entra ID or AD FS), follow the appropriate steps to create the service principal that Azure App Service will use on the Azure Stack Hub resource provider.

::: zone pivot="state-connected"

#### Create a Microsoft Entra app

Follow these steps to create the service principal in your Microsoft Entra tenant:

1. Open a PowerShell instance as **azurestack\AzureStackAdmin**.

1. Go to the location of the scripts that you downloaded and extracted [earlier in this article](#installer-and-helper-scripts).

1. [Install PowerShell for Azure Stack Hub](powershell-install-az-module.md).

1. Run the [Create-AADIdentityApp.ps1](#create-aadidentityapp-powershell-script) script. When you're prompted, enter the Microsoft Entra tenant ID that you're using for your Azure Stack Hub deployment. For example, enter **myazurestack.onmicrosoft.com**.

1. In the **Credential** window, enter your Microsoft Entra service admin account and password. Select **OK**.

1. Enter the certificate file path and certificate password for the [certificate that you created earlier](#certificate-requirements). The certificate for this step is **sso.appservice.local.azurestack.external.pfx** by default.

1. Make a note of the application ID in the PowerShell output. You use the ID in the following steps to provide consent for the application's permissions, and during installation.

1. Open a new browser window, and sign in to the [Azure portal](https://portal.azure.com) as the Microsoft Entra service admin.

1. Open the Microsoft Entra service.

1. In the left pane, select **App Registrations**.

1. Search for the application ID that you noted in step 7.

1. Select the App Service application registration from the list.

1. In the left pane, select **API permissions**.

1. Select **Grant admin consent for** *tenant*, where *tenant* is the name of your Microsoft Entra tenant. Select **Yes** to confirm the consent grant.

1. For multitenancy scenarios, run the following PowerShell script to grant the **Directory.Read.All** and **user_impersonation** permissions to the App Service app registration by using the Azure Resource Manager admin endpoint.

   ```powershell
   # Build the admin endpoint by replacing the region and the FQDN with the values specific to your system
   $adminarmendpoint = https://adminmanagement.<region>.<FQDN>/
   Add-AzEnvironment -Name "AzureStackAdmin" -ArmEndpoint $userarmendpoint
   # Home directory
   $AADTenantName = "xxx"
   $authEndpoint = (Get-AzEnvironment -Name "AzureStackAdmin").ActiveDirectoryAuthority.TrimEnd('/')
   $TenantId = (invoke-restmethod "$($AuthEndpoint)/$($AADTenantName)/.well-known/openid-configuration").issuer.TrimEnd('/').Split('/')[-1]
   Login-AzAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantID
   
   # Enter the region name of your Azure Stack Hub system
   $Location = '<region>'
   $AppServicesAppId = '' # The identity app's application ID; use the Azure portal to get it - Entra ID - App Registration - App Services - Application ID
   $AppServicesObjectId = '' # The identity app's object ID; use the Azure portal to get it - Entra ID - App Registration - App Services - Object ID

   # The applicationId property in the JSON returned from https://<AdminArmEndpoint>/metadata/identity?api-version=2015-01-01
   $TenantArmAppId = (Invoke-WebRequest "$adminarmendpoint/metadata/identity?api-version=2015-01-01" -UseBasicParsing | select -ExpandProperty Content | ConvertFrom-Json | select applicationId).applicationId

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
               roleId = ([guid]('00000002-0000-0000-c000-000000000000')).ToString() # Well-known value for the Directory.Read.All permission
               resource = ([guid]('00000002-0000-0000-c000-000000000000')).ToString() # Well-known value for Microsoft.Azure.ActiveDirectory
           })
           oAuth2PermissionGrants = @(@{
               client = $AppServicesAppId
               resource = ([guid]('00000002-0000-0000-c000-000000000000')).ToString() # Well-known value for Microsoft.Azure.ActiveDirectory
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

   After you run this script, each tenant that needs to use App Service must rerun the registration script. See [Configure multi-tenancy in Azure Stack Hub](enable-multitenancy.md?view=azs-2601&pivots=management-tool-powershell&preserve-view=true).

#### Create-AADIdentityApp PowerShell script

```powershell
Create-AADIdentityApp.ps1
```

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| `DirectoryTenantName` | Required | `Null` | Microsoft Entra tenant ID. Provide the GUID or string. An example is `myazureaaddirectory.onmicrosoft.com`. |
| `AdminArmEndpoint` | Required | `Null` | Admin Azure Resource Manager endpoint. An example is `adminmanagement.local.azurestack.external`. |
| `TenantARMEndpoint` | Required | `Null` | Tenant Azure Resource Manager endpoint. An example is `management.local.azurestack.external`. |
| `AzureStackAdminCredential` | Required | `Null` | Microsoft Entra service admin credential. |
| `CertificateFilePath` | Required | `Null` | Full path to the identity application's certificate file generated earlier. |
| `CertificatePassword` | Required | `Null` | Password that helps protect the certificate private key. |
| `Environment` | Optional | `AzureCloud` | Name of the supported cloud environment in which the target Microsoft Graph service is available. Allowed values: `AzureCloud`, `AzureChinaCloud`, `AzureUSGovernment`, `AzureGermanCloud`. |

::: zone-end

#### Create an AD FS app

1. Open a PowerShell instance as **azurestack\AzureStackAdmin**.

1. Go to the location of the scripts that you downloaded and extracted [earlier in this article](azure-stack-app-service-before-you-get-started.md#installer-and-helper-scripts).

1. [Install PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).

1. Run the **Create-ADFSIdentityApp.ps1** script.

1. In the **Credential** window, enter your AD FS cloud admin account and password. Select **OK**.

1. Provide the certificate file path and certificate password for the [certificate that you created earlier](#certificate-requirements). The certificate for this step is **sso.appservice.local.azurestack.external.pfx** by default.

```powershell
Create-ADFSIdentityApp.ps1
```

| Parameter | Required or optional | Default value | Description |
| --- | --- | --- | --- |
| `AdminArmEndpoint` | Required | `Null` | Admin Azure Resource Manager endpoint. An example is `adminmanagement.local.azurestack.external`. |
| `PrivilegedEndpoint` | Required | `Null` | Privileged endpoint. An example is `AzS-ERCS01`. |
| `CloudAdminCredential` | Required | `Null` | Domain account credential for Azure Stack Hub cloud admins. An example is `Azurestack\CloudAdmin`. |
| `CertificateFilePath` | Required | `Null` | Full path to the identity application's certificate PFX file. |
| `CertificatePassword` | Required | `Null` | Password that helps protect the certificate private key. |

### <a name = "download-items-from-the-azure-marketplace"></a>Download items from Microsoft Marketplace

Azure App Service on Azure Stack Hub requires you to [download items from Microsoft Marketplace](azure-stack-download-azure-marketplace-item.md) to make them available in the Azure Stack Hub marketplace. Before you start the deployment or upgrade of Azure App Service on Azure Stack Hub, download the following items.

> [!IMPORTANT]
> Windows Server Core isn't a supported platform image for use with Azure App Service on Azure Stack Hub.
>
> Don't use evaluation images for production deployments.

::: zone pivot="state-connected"

# [Azure App Service on Azure Stack 2022 H1](#tab/2022H1-connected)

- Latest version of the Windows Server 2022 Datacenter VM image.

# [Previous versions](#tab/previous-connected)

- Latest version of Windows Server 2016 Datacenter VM image.

::: zone-end

::: zone pivot="state-disconnected"

# [Azure App Service on Azure Stack 2022 H1](#tab/2022H1-disconnected)

- Windows Server 2022 Datacenter full VM image with Microsoft .NET 3.5.1 SP1 activated. Azure App Service on Azure Stack Hub requires that Microsoft .NET 3.5.1 SP1 is activated on the image that you use for deployment. Marketplace-syndicated Windows Server 2022 images don't have this feature enabled. In disconnected environments, the image can't reach Microsoft Update to download the packages to install by using DISM. You must create and use a Windows Server 2022 image with this feature pre-enabled for disconnected deployments.

  For information about creating a custom image and adding it to Marketplace, see [Add a custom VM image to Azure Stack Hub](azure-stack-add-vm-image.md). Be sure to specify the following properties when you add the image to Marketplace:

  - **Publisher**: Enter **MicrosoftWindowsServer**.
  - **Offer**: Enter **WindowsServer**.
  - **SKU**: Enter **AppService**.
  - **Version**: Specify the latest version.

# [Previous versions](#tab/previous-disconnected)

- Windows Server 2016 Datacenter full VM image with Microsoft .NET 3.5.1 SP1 activated. Azure App Service on Azure Stack Hub requires that Microsoft .NET 3.5.1 SP1 is activated on the image that you use for deployment. Marketplace-syndicated Windows Server 2016 images don't have this feature enabled. In disconnected environments, the image can't reach Microsoft Update to download the packages to install by using DISM. You must create and use a Windows Server 2016 image with this feature pre-enabled for disconnected deployments.

  For information about creating a custom image and adding it to Marketplace, see [Add a custom VM image to Azure Stack Hub](azure-stack-add-vm-image.md). Be sure to specify the following properties when you add the image to Marketplace:

  - **Publisher**: Enter **MicrosoftWindowsServer**.
  - **Offer**: Enter **WindowsServer**.
  - **SKU**: Enter **2016-Datacenter**.
  - **Version**: Specify the latest version.

::: zone-end

- Custom Script Extension v1.9.1 or later. This item is a VM extension.

## Related content

- [Install the App Service resource provider](azure-stack-app-service-deploy.md)
