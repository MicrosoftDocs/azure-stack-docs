---
title: Deploy ASDK from the command line using Powershell | Microsoft Docs
description: Learn how to deploy the ASDK from the command line using PowerShell.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.custom: 
ms.date: 05/06/2019
ms.author: justinha
ms.reviewer: misainat
ms.lastreviewed: 02/08/2019


---

# Deploy ASDK from the command line using Powershell

The Azure Stack Development Kit (ASDK) is a testing and development environment that you can deploy to evaluate and demonstrate Azure Stack features and services. To get it up and running, you need to prepare the environment hardware and run some scripts. The scripts take several hours to run. After that, you can sign in to the admin and user portals to start using Azure Stack.

## Prerequisites

Prepare the ASDK host computer. Plan your hardware, software, and network. The computer that hosts the ASDK must meet hardware, software, and network requirements. Choose between using Azure Active Directory (Azure AD) or Active Directory Federation Services (AD FS). Be sure to follow these prerequisites before starting your deployment so that the installation process runs smoothly.

Before you deploy the ASDK, make sure your planned ASDK host computer's hardware, operating system, account, and network configurations meet the minimum requirements for installing the ASDK.

**[Review the ASDK deployment requirements and considerations](asdk-deploy-considerations.md)**.

> [!TIP]
> You can use the [Azure Stack deployment requirements check tool](https://gallery.technet.microsoft.com/Deployment-Checker-for-50e0f51b) after installing the operating system to confirm that your hardware meets all requirements.

## Download and extract the deployment package
After ensuring that your ASDK host computer meets the basic requirements for installing the ASDK, the next step is to download and extract the ASDK deployment package. The deployment package includes the Cloudbuilder.vhdx file, which is a virtual hard drive that includes a bootable operating system and the Azure Stack installation files.

You can download the deployment package to the ASDK host or to another computer. The extracted deployment files take up 60 GB of free disk space, so using another computer can help reduce the hardware requirements for the ASDK host.

**[Download and extract the Azure Stack Development Kit (ASDK)](asdk-download.md)**

## Prepare the ASDK host computer
Before you can install the ASDK on the host computer, the environment must be prepared and the system configured to boot from VHD. After this step, the ASDK host will boot to the Cloudbuilder.vhdx (a virtual hard drive that includes a bootable operating system and the Azure Stack installation files).

Use PowerShell to configure the ASDK host computer to boot from CloudBuilder.vhdx. These commands configure your ASDK host computer to boot from the downloaded and extracted Azure Stack virtual harddisk (CloudBuilder.vhdx). After completing these steps, restart the ASDK host computer.

To configure the ASDK host computer to boot from CloudBuilder.vhdx:

  1. Launch a command prompt as admin.
  2. Run `bcdedit /copy {current} /d "Azure Stack"`.
  3. Copy (CTRL+C) the CLSID value returned, including the required curly brackets (`{}`). This value is referred to as `{CLSID}` and needs to be pasted in (CTRL+V or right-click) in the remaining steps.
  4. Run `bcdedit /set {CLSID} device vhd=[C:]\CloudBuilder.vhdx`.
  5. Run `bcdedit /set {CLSID} osdevice vhd=[C:]\CloudBuilder.vhdx`.
  6. Run `bcdedit /set {CLSID} detecthal on`.
  7. Run `bcdedit /default {CLSID}`.
  8. To verify boot settings, run `bcdedit`.
  9. Ensure that the CloudBuilder.vhdx file has been moved to the root of the C:\ drive (`C:\CloudBuilder.vhdx`) and restart the ASDK host computer. When the ASDK host computer is restarted, it should boot from the CloudBuilder.vhdx virtual machine (VM) hard drive to begin ASDK deployment.

> [!IMPORTANT]
> Ensure that you have direct physical or KVM access to the ASDK host computer before restarting it. When the VM first starts, it prompts you to complete Windows Server Setup. Provide the same admin credentials you used to log into the ASDK host computer.

### Prepare the ASDK host using PowerShell 
After the ASDK host computer successfully boots into the CloudBuilder.vhdx image, sign in with the same local admin credentials you used to log into the ASDK host computer. These are also the same credentials you provided as part of completing the Windows Server Setup when the host computer booted from VHD.

> [!NOTE]
> Optionally, you can also configure [Azure Stack telemetry settings](asdk-telemetry.md#set-telemetry-level-in-the-windows-registry) *before* installing the ASDK.

Open an elevated PowerShell console and run the commands in this section to deploy the ASDK on the ASDK host.

> [!IMPORTANT]
> ASDK installation supports exactly one network interface card (NIC) for networking. If you have multiple NICs, make sure that only one is enabled (and all others are disabled) before running the deployment script.

You can deploy Azure Stack with Azure AD or Windows Server AD FS as the identity provider. Azure Stack, resource providers, and other apps work the same way with both.

> [!TIP]
> If you don't supply any setup parameters (see InstallAzureStackPOC.ps1 optional parameters and examples below), you're prompted for the required parameters.

### Deploy Azure Stack using Azure AD 
To deploy Azure Stack **using Azure AD as the identity provider**, you must have internet connectivity either directly or through a transparent proxy. 

Run the following PowerShell commands to deploy the ASDK using Azure AD:

  ```powershell
  cd C:\CloudDeployment\Setup     
  $adminpass = Get-Credential Administrator     
  .\InstallAzureStackPOC.ps1 -AdminPassword $adminpass.Password
  ```

A few minutes into ASDK installation you'll be prompted for Azure AD credentials. Provide the global admin credentials for your Azure AD tenant.

After deployment, Azure Active Directory global admin permission isn't required. However, some operations may require the global admin credential. Examples of such operations include a resource provider installer script or a new feature requiring a permission to be granted. You can either temporarily reinstate the account's global admin permissions or use a separate global admin account that's an owner of the *default provider subscription*.

### Deploy Azure Stack using AD FS 
To deploy the ASDK  **using AD FS as the identity provider**, run the following PowerShell commands (you just need to add the -UseADFS parameter):

  ```powershell
  cd C:\CloudDeployment\Setup     
  $adminpass = Get-Credential Administrator 
  .\InstallAzureStackPOC.ps1 -AdminPassword $adminpass.Password -UseADFS
  ```

In AD FS deployments, the default stamp Directory Service is used as the identity provider. The default account to sign in with is azurestackadmin@azurestack.local, and the password is set to what you provided as part of the PowerShell setup commands.

The deployment process can take a few hours, during which time the system automatically reboots once. When the deployment succeeds, the PowerShell console displays: **COMPLETE: Action ‘Deployment'**. If the deployment fails, try running the script again using the -rerun parameter. Or, you can [redeploy ASDK](asdk-redeploy.md) from scratch.

> [!IMPORTANT]
> If you want to monitor the deployment progress after the ASDK host reboots, you must sign in as AzureStack\AzureStackAdmin. If you sign in as a local admin after the host computer is restarted (and joined to the azurestack.local domain), you won't see the deployment progress. Don't rerun deployment, instead sign in as AzureStack\AzureStackAdmin with the same password as the local admin to validate that the setup is running.


#### Azure AD deployment script examples
You can script the entire Azure AD deployment. Here are a few commented examples that include some optional parameters.

If your Azure AD identity is only associated with **one** Azure AD directory:
```powershell
cd C:\CloudDeployment\Setup 
$adminpass = Get-Credential Administrator 
$aadcred = Get-Credential "<Azure AD global administrator account name>" 
.\InstallAzureStackPOC.ps1 -AdminPassword $adminpass.Password -InfraAzureDirectoryTenantAdminCredential $aadcred -TimeServer 52.168.138.145 #Example time server IP address.
```

If your Azure AD identity is associated with **greater than one** Azure AD directory:
```powershell
cd C:\CloudDeployment\Setup 
$adminpass = Get-Credential Administrator 
$aadcred = Get-Credential "<Azure AD global administrator account name>" #Example: user@AADDirName.onmicrosoft.com 
.\InstallAzureStackPOC.ps1 -AdminPassword $adminpass.Password -InfraAzureDirectoryTenantAdminCredential $aadcred -InfraAzureDirectoryTenantName "<Azure AD directory in the form of domainname.onmicrosoft.com or an Azure AD verified custom domain name>" -TimeServer 52.168.138.145 #Example time server IP address.
```

If your environment doesn't have DHCP enabled, then you must include the following additional parameters to one of the options above (example usage provided): 

```powershell
.\InstallAzureStackPOC.ps1 -AdminPassword $adminpass.Password -InfraAzureDirectoryTenantAdminCredential $aadcred -TimeServer 10.222.112.26
```

### ASDK InstallAzureStackPOC.ps1 optional parameters

|Parameter|Required/Optional|Description|
|-----|-----|-----|
|AdminPassword|Required|Sets the local admin account and all other user accounts on all the VMs created as part of ASDK deployment. This password must match the current local admin password on the host.|
|InfraAzureDirectoryTenantName|Required|Sets the tenant directory. Use this parameter to specify a specific directory where the Azure AD account has permissions to manage multiple directories. Full name of an Azure AD tenant in the format of .onmicrosoft.com or an Azure AD verified custom domain name.|
|TimeServer|Required|Use this parameter to specify a specific time server. This parameter must be provided as a valid time server IP address. Server names aren't supported.|
|InfraAzureDirectoryTenantAdminCredential|Optional|Sets the Azure Active Directory user name and password. These Azure credentials must be an Org ID.|
|InfraAzureEnvironment|Optional|Select the Azure Environment with which you want to register this Azure Stack deployment. Options include global Azure, Azure - China, Azure - US Government.|
|DNSForwarder|Optional|A DNS server is created as part of the Azure Stack deployment. To allow computers inside the solution to resolve names outside of the stamp, provide your existing infrastructure DNS server. The in-stamp DNS server forwards unknown name resolution requests to this server.|
|Rerun|Optional|Use this flag to rerun deployment. All previous input is used. Reentering data previously provided isn't supported because several unique values are generated and used for deployment.|


## Perform post-deployment configurations
After installing the ASDK, there are a few recommended post-installation checks and configuration changes that should be made. Validate your installation was installed successfully by using the test-AzureStack cmdlet, then install Azure Stack PowerShell and GitHub tools.

We recommend you reset the password expiration policy to make sure that the password for the ASDK host doesn't expire before your evaluation period ends.

> [!NOTE]
> Optionally, you can also configure [Azure Stack telemetry settings](asdk-telemetry.md#enable-or-disable-telemetry-after-deployment) *after* installing the ASDK.

**[Post ASDK deployment tasks](asdk-post-deploy.md)**

## Register with Azure
You must register Azure Stack with Azure so that you can [download Azure Marketplace items](../operator/azure-stack-create-and-publish-marketplace-item.md) to Azure Stack.

**[Register Azure Stack with Azure](asdk-register.md)**

## Next steps
Congratulations! After completing these steps, you'll have an ASDK environment with both [admin](https://adminportal.local.azurestack.external) and [user](https://portal.local.azurestack.external) portals. 

[Post ASDK installation configuration tasks](asdk-post-deploy.md)

