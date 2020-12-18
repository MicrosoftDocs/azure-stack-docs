---
title: Validate Azure Identity
titleSuffix: Azure Stack Hub
description: Use the Azure Stack Hub Readiness Checker to validate Azure identity.
author: BryanLa
ms.topic: how-to
ms.date: 10/19/2020
ms.author: bryanla
ms.reviewer: jerskine
ms.lastreviewed: 10/19/2020

# Intent: As an Azure Stack Hub operator, I want to use the Azure Stack Hub Readiness Checker to validate Azure identity.
# Keyword:  azure stack hub azure identity readiness checker

---

# Validate Azure identity

Use the Azure Stack Hub Readiness Checker tool (**AzsReadinessChecker**) to validate that your Azure Active Directory (Azure AD) is ready to use with Azure Stack Hub. Validate your Azure identity solution before you begin an Azure Stack Hub deployment.  

The readiness checker validates:

- Azure AD as an identity provider for Azure Stack Hub.
- The Azure AD account that you plan to use can sign in as a global administrator of your Azure AD.

Validation ensures your environment is ready for Azure Stack Hub to store information about users, applications, groups, and service principals from Azure Stack Hub in your Azure AD.

## Get the readiness checker tool

Download the latest version of the Azure Stack Hub Readiness Checker tool (AzsReadinessChecker) from the [PowerShell Gallery](https://aka.ms/AzsReadinessChecker).

## Install and configure

### [Az PowerShell](#tab/az)

### Prerequisites

The following prerequisites are required:

#### Az PowerShell modules

You will need to have the Az PowerShell modules installed. For instructions, see [Install PowerShell Az preview module](powershell-install-az-module.md).

#### Azure Active Directory (Azure AD) environment

- Identify the Azure AD account to use for Azure Stack Hub and ensure it's an Azure AD global administrator.
- Identify your Azure AD tenant name. The tenant name must be the primary domain name for your Azure AD. For example, **contoso.onmicrosoft.com**.

### Steps to validate Azure identity

1. On a computer that meets the prerequisites, open an elevated PowerShell command prompt, and then run the following command to install **AzsReadinessChecker**:  

   ```powershell
   Install-Module -Name Az.BootStrapper -Force -AllowPrerelease
   Install-AzProfile -Profile 2019-03-01-hybrid -Force
   Install-Module -Name Microsoft.AzureStack.ReadinessChecker
   ```

2. From the PowerShell prompt, run the following command. Replace `contoso.onmicrosoft.com` with your Azure AD tenant name:

   ```powershell
   Connect-AzAccount -tenant contoso.onmicrosoft.com
   ```

3. From the PowerShell prompt, run the following command to start validation of your Azure AD. Replace `contoso.onmicrosoft.com` with your Azure AD tenant name:

   ```powershell
   Invoke-AzsAzureIdentityValidation -AADDirectoryTenantName contoso.onmicrosoft.com 
   ```

4. After the tool runs, review the output. Confirm the status is **OK** for installation requirements. A successful validation appears like the following example:

   ```powershell
   Invoke-AzsAzureIdentityValidation v1.2100.1448.484 started.
   Starting Azure Identity Validation

   Checking Installation Requirements: OK

   Finished Azure Identity Validation

   Log location (contains PII): C:\Users\[*redacted*]\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessChecker.log
   Report location (contains PII): C:\Users\[*redacted*]\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessCheckerReport.json
   Invoke-AzsAzureIdentityValidation Completed
   ```


### [AzureRM PowerShell](#tab/rm)

## Prerequisites

The following prerequisites are required:

#### AzureRM PowerShell modules

You will need to have the Az PowerShell modules installed. For instructions, see [Install PowerShell AzureRM module](powershell-install-az-module.md).

#### The computer on which the tool runs

- Windows 10 or Windows Server 2016 with internet connectivity.
- PowerShell 5.1 or later. To check your version, run the following PowerShell command, and then review the **Major** version and **Minor** versions:  
  ```powershell
  $PSVersionTable.PSVersion
  ```
- [PowerShell configured for Azure Stack Hub](powershell-install-az-module.md).
- The latest version of [Microsoft Azure Stack Hub Readiness Checker](https://aka.ms/AzsReadinessChecker) tool.

#### Azure AD environment

- Identify the Azure AD account to use for Azure Stack Hub and ensure it's an Azure AD global administrator.
- Identify your Azure AD tenant name. The tenant name must be the primary domain name for your Azure AD. For example, **contoso.onmicrosoft.com**.
- Identify the Azure environment you'll use. Supported values for the environment name parameter are **AzureCloud**, **AzureChinaCloud**, or **AzureUSGovernment**, depending on which Azure subscription you use.

## Steps to validate Azure identity

1. On a computer that meets the prerequisites, open an elevated PowerShell command prompt, and then run the following command to install **AzsReadinessChecker**:  

   ```powershell
   Install-Module Microsoft.AzureStack.ReadinessChecker -RequiredVersion 1.2100.1396.426
   ```

2. From the PowerShell prompt, run the following command to set `$serviceAdminCredential` as the service administrator for your Azure AD tenant.  Replace `serviceadmin\@contoso.onmicrosoft.com` with your account and tenant name:

   ```powershell
   $serviceAdminCredential = Get-Credential serviceadmin@contoso.onmicrosoft.com -Message "Enter credentials for service administrator of Azure Active Directory tenant"
   ```

3. From the PowerShell prompt, run the following command to start validation of your Azure AD:

   - Specify the environment name value for **AzureEnvironment**. Supported values for the environment name parameter are **AzureCloud**, **AzureChinaCloud**, or **AzureUSGovernment**, depending on which Azure subscription you use.
   - Replace `contoso.onmicrosoft.com` with your Azure AD tenant name.

   ```powershell
   Invoke-AzsAzureIdentityValidation -AADServiceAdministrator $serviceAdminCredential -AzureEnvironment <environment name> -AADDirectoryTenantName contoso.onmicrosoft.com
   ```

4. After the tool runs, review the output. Confirm the status is **OK** for installation requirements. A successful validation appears like the following example:

   ```powershell
   Invoke-AzsAzureIdentityValidation v1.2100.1396.426 started.
   Starting Azure Identity Validation

   Checking Installation Requirements: OK

   Finished Azure Identity Validation

   Log location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessChecker.log
   Report location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessCheckerReport.json
   Invoke-AzsAzureIdentityValidation Completed
   ```
--- 


## Report and log file

Each time validation runs, it logs results to **AzsReadinessChecker.log** and **AzsReadinessCheckerReport.json**. The location of these files displays with the validation results in PowerShell.

These files can help you share validation status before you deploy Azure Stack Hub or investigate validation problems. Both files persist the results of each subsequent validation check. The report provides your deployment team confirmation of the identity configuration. The log file can help your deployment or support team investigate validation issues.

By default, both files are written to `C:\Users\<username>\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessCheckerReport.json`.  

- Use the `-OutputPath <path>` parameter at the end of the run command line to specify a different report location.
- Use the `-CleanReport` parameter at the end of the run command to clear information about previous runs of the tool from **AzsReadinessCheckerReport.json**.

For more information, see [Azure Stack Hub validation report](azure-stack-validation-report.md).

## Validation failures

If a validation check fails, details about the failure display in the PowerShell window. The tool also logs information to the AzsReadinessChecker.log file.

The following examples provide guidance on common validation failures.

### Expired or temporary password

```powershell
Invoke-AzsAzureIdentityValidation v1.1809.1005.1 started.
Starting Azure Identity Validation

Checking Installation Requirements: Fail
Error Details for Service Administrator Account admin@contoso.onmicrosoft.com
The password for account  has expired or is a temporary password that needs to be reset before continuing. Run Login-AzureRMAccount, login with  credentials and follow the prompts to reset.
Additional help URL https://aka.ms/AzsRemediateAzureIdentity

Finished Azure Identity Validation

Log location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessChecker.log
Report location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessCheckerReport.json
Invoke-AzsAzureIdentityValidation Completed
```

**Cause** - The account can't sign in because the password is either expired or temporary.

**Resolution** - In PowerShell, run the following command and then follow the prompts to reset the password:

```powershell
Login-AzureRMAccount
```

Another way is to sign in to the [Azure portal](https://portal.azure.com) as the account owner and the user will be forced to change the password.

### Unknown user type 
 
```powershell
Invoke-AzsAzureIdentityValidation v1.1809.1005.1 started.
Starting Azure Identity Validation

Checking Installation Requirements: Fail
Error Details for Service Administrator Account admin@contoso.onmicrosoft.com
Unknown user type detected. Check the account  is valid for AzureChinaCloud
Additional help URL https://aka.ms/AzsRemediateAzureIdentity

Finished Azure Identity Validation

Log location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessChecker.log
Report location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessCheckerReport.json
Invoke-AzsAzureIdentityValidation Completed
```

**Cause** - The account can't sign in to the specified Azure AD (**AADDirectoryTenantName**). In this example, **AzureChinaCloud** is specified as the **AzureEnvironment**.

**Resolution** - Confirm that the account is valid for the specified Azure environment. In PowerShell, run the following command to verify the account is valid for a specific environment:

```powershell
Login-AzureRmAccount -EnvironmentName AzureChinaCloud
```

### Account is not an administrator

```powershell
Invoke-AzsAzureIdentityValidation v1.1809.1005.1 started.
Starting Azure Identity Validation

Checking Installation Requirements: Fail
Error Details for Service Administrator Account admin@contoso.onmicrosoft.com
The Service Admin account you entered 'admin@contoso.onmicrosoft.com' is not an administrator of the Azure Active Directory tenant 'contoso.onmicrosoft.com'.
Additional help URL https://aka.ms/AzsRemediateAzureIdentity

Finished Azure Identity Validation

Log location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessChecker.log
Report location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessCheckerReport.json
Invoke-AzsAzureIdentityValidation Completed
```

**Cause** -  Although the account can successfully sign in, the account isn't an admin of the Azure AD (**AADDirectoryTenantName**).  

**Resolution** - Sign in into the [Azure portal](https://portal.azure.com) as the account owner, go to **Azure Active Directory**, then **Users**, then **Select the User**. Then select **Directory Role** and ensure the user is a **Global administrator**. If the account is a **User**, go to **Azure Active Directory** > **Custom domain names** and confirm that the name you supplied for **AADDirectoryTenantName** is marked as the primary domain name for this directory. In this example, that's **contoso.onmicrosoft.com**.

Azure Stack Hub requires that the domain name is the primary domain name.

## Next Steps

[Validate Azure registration](azure-stack-validate-registration.md)  
[View the readiness report](azure-stack-validation-report.md)  
[General Azure Stack Hub integration considerations](azure-stack-datacenter-integration.md)  
