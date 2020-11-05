---
title: Rotate secrets
titleSuffix: Azure Stack Hub
description: Learn how to rotate your secrets in Azure Stack Hub.
author: BryanLa
ms.topic: how-to
ms.date: 06/29/2020
ms.reviewer: ppacent
ms.author: bryanla
ms.lastreviewed: 08/15/2020
monikerRange: '>=azs-1803'

# Intent: As an Azure Stack Hub operator, I want to rotate secrets in Azure Stack Hub.
# Keyword: rotate secrets azure stack

---

# Rotate secrets in Azure Stack Hub

This article provides guidance for performing secret rotation, to help maintain secure communication with Azure Stack Hub infrastructure resources and services.

## Overview

Azure Stack Hub uses secrets to maintain secure communication with infrastructure resources and services. To maintain the integrity of the Azure Stack Hub infrastructure, operators need the ability to rotate secrets at frequencies that are consistent with their organization's security requirements.

When secrets are within 30 days of expiration, the following alerts are generated in the administrator portal. Completing secret rotation will resolve these alerts:

- Pending service account password expiration
- Pending internal certificate expiration
- Pending external certificate expiration

::: moniker range="<azs-1811"  
> [!Note]
> Azure Stack Hub environments on pre-1811 versions may see alerts for pending internal certificate or secret expirations. These alerts are inaccurate and should be ignored without running internal secret rotation. Inaccurate internal secret expiration alerts are a known issue that's resolved in 1811. Internal secrets won't expire unless the environment has been active for two years.
::: moniker-end

## Prerequisites

1. It's highly recommended that you first update your Azure Stack Hub instance to the [latest version](release-notes.md).

    ::: moniker range="<azs-1811"  
    >[!IMPORTANT]
    > For pre-1811 versions:
    > - If secret rotation has already been performed, you must update to version 1811 or later before you perform secret rotation again. Secret Rotation must be executed via the [Privileged Endpoint](azure-stack-privileged-endpoint.md) and requires Azure Stack Hub Operator credentials. If you don't know whether secret rotation has been run on your environment, update to 1811 before performing secret rotation.
    > - You don't need to rotate secrets to add extension host certificates. You should follow the instructions in the article [Prepare for extension host for Azure Stack Hub](azure-stack-extension-host-prepare.md) to add extension host certificates.
    ::: moniker-end

2. Notify your users of planned maintenance operations. Schedule normal maintenance windows, as much as possible,  during non-business hours. Maintenance operations may affect both user workloads and portal operations.

3. During rotation of secrets, operators may notice alerts open and automatically close. This behavior is expected and the alerts can be ignored. Operators can verify the validity of these alerts using the [Test-AzureStack PowerShell cmdlet](azure-stack-diagnostic-test.md). For operators using System Center Operations Manager to monitor Azure Stack Hub systems, placing a system in maintenance mode will prevent these alerts from reaching their ITSM systems but will continue to alert if the Azure Stack Hub system becomes unreachable.

::: moniker range=">=azs-1811"
## Rotate external secrets

> [!Important]
> External secret rotation for:
> - **Non-certificate secrets such as secure keys and strings** must be done manually by the administrator. This includes user and administrator account passwords, and [network switch passwords](azure-stack-customer-defined.md).
> - **Value-add resource provider (RP) secrets** is covered under seperate guidance:
>    - [App Service on Azure Stack Hub](app-service-rotate-certificates.md)
>    - [IoT Hub on Azure Stack Hub](iot-hub-rp-rotate-secrets.md)
>    - [MySQL on Azure Stack Hub](azure-stack-mysql-resource-provider-maintain.md#secrets-rotation)
>    - [SQL on Azure Stack Hub](azure-stack-sql-resource-provider-maintain.md#secrets-rotation)
> - **Baseboard management controller (BMC) credentials** is also a manual process, [covered later in this article](#update-the-bmc-credential). 

This section covers rotation of certificates used to secure external-facing services. These certificates are provided by the Azure Stack Hub Operator, for the following services:

- Administrator portal
- Public portal
- Administrator Azure Resource Manager
- Global Azure Resource Manager
- Administrator Key Vault
- Key Vault
- Admin Extension Host
- ACS (including blob, table, and queue storage)
- ADFS<sup>*</sup>
- Graph<sup>*</sup>

<sup>*</sup>Applicable when identity provider is Active Directory Federated Services (AD FS).

### Preparation

Prior to rotation of external secrets:

1. Run the **[`Test-AzureStack`](azure-stack-diagnostic-test.md)** PowerShell cmdlet using the `-group SecretRotationReadiness` parameter, to confirm all test outputs are healthy before rotating secrets.
2. Prepare a new set of replacement external certificates:
    - The new set must match the certificate specifications outlined in the [Azure Stack Hub PKI certificate requirements](azure-stack-pki-certs.md). 
    - Generate a certificate signing request (CSR) to submit to your Certificate Authority (CA) using the steps outlined in [Generate certificate signing requests](azure-stack-get-pki-certs.md) and prepare them for use in your Azure Stack Hub environment using the steps in [Prepare PKI certificates](azure-stack-prepare-pki-certs.md). Azure Stack Hub supports secret rotation for external certificates from a new Certificate Authority (CA) in the following contexts:

       |Installed Certificate CA|CA to Rotate To|Supported|Azure Stack Hub versions supported|
       |-----|-----|-----|-----|
       |From Self-Signed|To Enterprise|Supported|1903 & Later|
       |From Self-Signed|To Self-Signed|Not Supported||
       |From Self-Signed|To Public<sup>*</sup>|Supported|1803 & Later|
       |From Enterprise|To Enterprise|Supported. From 1803-1903: supported so long as customers use the SAME enterprise CA as used at deployment|1803 & Later|
       |From Enterprise|To Self-Signed|Not Supported||
       |From Enterprise|To Public<sup>*</sup>|Supported|1803 & Later|
       |From Public<sup>*</sup>|To Enterprise|Supported|1903 & Later|
       |From Public<sup>*</sup>|To Self-Signed|Not Supported||
       |From Public<sup>*</sup>|To Public<sup>*</sup>|Supported|1803 & Later|
       <sup>*</sup>Indicates that the Public Certificate Authorities are part of the Windows Trusted Root Program. You can find the full list in the article [List of Participants - Microsoft Trusted Root Program](/security/trusted-root/participants-list).

    - Be sure to validate the certificates you prepare with the steps outlined in [Validate PKI Certificates](azure-stack-validate-pki-certs.md)
    - Make sure there are no special characters in the password, like `*` or `)`.
    - Make sure the PFX encryption is **TripleDES-SHA1**. If you run into an issue, see [Fix common issues with Azure Stack Hub PKI certificates](azure-stack-remediate-certs.md#pfx-encryption).

3. Store a backup to the certificates used for rotation in a secure backup location. If your rotation runs and then fails, replace the certificates in the file share with the backup copies before you rerun the rotation. Keep backup copies in the secure backup location.
4. Create a fileshare you can access from the ERCS VMs. The file share must be  readable and writable for the **CloudAdmin** identity.
5. Open a PowerShell ISE console from a computer where you have access to the fileshare. Navigate to your fileshare, where you create directories to place your external certificates.
6. Download **[CertDirectoryMaker.ps1](https://www.aka.ms/azssecretrotationhelper)** to a network file share that can be accessed during rotation, and run the script. The script will create a folder structure that adheres to ***.\Certificates\AAD*** or ***.\Certificates\ADFS***, depending on your identity provider. Your folder structure must begin with a **\\Certificates** folder, followed by ONLY an **\\AAD** or **\\ADFS** folder. All additional subdirectories are contained within the preceding structure. For example:
    - File share = **\\\\\<IPAddress>\\\<ShareName>**
    - Certificate root folder for Azure AD provider = **\\Certificates\AAD**
    - Full path = **\\\\\<IPAddress>\\\<ShareName>\Certificates\AAD**

    > [!IMPORTANT]
    > When you run `Start-SecretRotation` later, it will validate the folder structure. A folder structure that is not compliant will throw the following error:
    >
    > ```powershell
    > Cannot bind argument to parameter 'Path' because it is null.
    > + CategoryInfo          : InvalidData: (:) [Test-Certificate], ParameterBindingValidationException
    > + FullyQualifiedErrorId : ParameterArgumentValidationErrorNullNotAllowed,Test-Certificate
    > + PSComputerName        : xxx.xxx.xxx.xxx
    > ```

7. Copy the new set of replacement external certificates created in step #2, to the **\Certificates\\\<IdentityProvider>** directory created in step #6. Be sure to follow the `cert.<regionName>.<externalFQDN>` format for \<CertName\>. 

    Here's an example of a folder structure for the Azure AD Identity Provider:
    ```powershell
        <ShareName>
            │
            └───Certificates
                  └───AAD
                      ├───ACSBlob
                      │       <CertName>.pfx
                      │
                      ├───ACSQueue
                      │       <CertName>.pfx
                      │
                      ├───ACSTable
                      │       <CertName>.pfx
                      │
                      ├───Admin Extension Host
                      │       <CertName>.pfx
                      │
                      ├───Admin Portal
                      │       <CertName>.pfx
                      │
                      ├───ARM Admin
                      │       <CertName>.pfx
                      │
                      ├───ARM Public
                      │       <CertName>.pfx
                      │
                      ├───KeyVault
                      │       <CertName>.pfx
                      │
                      ├───KeyVaultInternal
                      │       <CertName>.pfx
                      │
                      ├───Public Extension Host
                      │       <CertName>.pfx
                      │
                      └───Public Portal
                              <CertName>.pfx

    ```

### Rotation

Complete the following steps to rotate external secrets:

1. Use the following PowerShell script to rotate the secrets. The script requires access to a Privileged EndPoint (PEP) session. The PEP is accessed through a remote PowerShell session on the virtual machine (VM) that hosts the PEP. If you're using an integrated system, there are three instances of the PEP, each running inside a VM (Prefix-ERCS01, Prefix-ERCS02, or Prefix-ERCS03) on different hosts. If you're using the ASDK, this VM is named AzS-ERCS01. Update the `<placeholder>` values before running:

    ```powershell
    # Create a PEP Session
    winrm s winrm/config/client '@{TrustedHosts= "<IP_address_of_ERCS>"}'
    $PEPCreds = Get-Credential
    $PEPSession = New-PSSession -ComputerName <IP_address_of_ERCS_Machine> -Credential $PEPCreds -ConfigurationName "PrivilegedEndpoint"

    # Run Secret Rotation
    $CertPassword = ConvertTo-SecureString "<Cert_Password>" -AsPlainText -Force
    $CertShareCreds = Get-Credential
    $CertSharePath = "<Network_Path_Of_CertShare>"
    Invoke-Command -Session $PEPSession -ScriptBlock {
        Start-SecretRotation -PfxFilesPath $using:CertSharePath -PathAccessCredential $using:CertShareCreds -CertificatePassword $using:CertPassword
    }
    Remove-PSSession -Session $PEPSession
    ```

    The script performs the following steps:

    - Creates a PowerShell Session with the [Privileged endpoint](azure-stack-privileged-endpoint.md) using the **CloudAdmin** account, and stores the session as a variable. This variable is used as a parameter in the next step. 

    - Runs [Invoke-Command](/powershell/module/microsoft.powershell.core/Invoke-Command), passing the PEP session variable as the `-Session` parameter.

    - Runs `Start-SecretRotation` in the PEP session, using the following parameters:
        - `-PfxFilesPath`: The network path to your Certificates directory created earlier.  
        - `-PathAccessCredential`: The PSCredential object for credentials to the share.
        - `-CertificatePassword`: A secure string of the password used for all of the pfx certificate files created.

2. External secret rotation takes approximately one hour. After successful completion, your console will display `ActionPlanInstanceID ... CurrentStatus: Completed`, followed by a `DONE`. Remove your certificates from the share created in the prerequisites section and store them in their secure backup location.

    > [!Note]
    > If secret rotation fails, follow the instructions in the error message and re-run `Start-SecretRotation` with the `-ReRun` parameter.
    >
    >```powershell
    >Start-SecretRotation -ReRun
    >```  
    >
    >Contact support if you experience repeated secret rotation failures.
::: moniker-end

## Rotate internal secrets

Internal secrets include certificates, passwords, secure strings, and keys used by the Azure Stack Hub infrastructure, without intervention of the Azure Stack Hub Operator. Internal secret rotation is only required if you suspect one has been compromised, or you've received an expiration alert. Internal secrets won't expire unless the environment has been active for two years.
::: moniker range="<azs-1811"  
Pre-1811 deployments may see alerts for pending internal certificate or secret expirations. These alerts are inaccurate and should be ignored, and are a known issue resolved in 1811.
::: moniker-end

Complete the following steps to rotate external secrets:

1. Run the following PowerShell script. Notice for internal secret rotation, the "Run Secret Rotation" section uses only the `-Internal` parameter to the [Start-SecretRotation cmdlet](../reference/pep-2002/start-secretrotation.md):

    ```powershell
    # Create a PEP Session
    winrm s winrm/config/client '@{TrustedHosts= "<IP_address_of_ERCS>"}'
    $PEPCreds = Get-Credential
    $PEPSession = New-PSSession -ComputerName <IP_address_of_ERCS_Machine> -Credential $PEPCreds -ConfigurationName "PrivilegedEndpoint"

    # Run Secret Rotation
    $CertPassword = ConvertTo-SecureString "<Cert_Password>" -AsPlainText -Force
    $CertShareCreds = Get-Credential
    $CertSharePath = "<Network_Path_Of_CertShare>"
    Invoke-Command -Session $PEPSession -ScriptBlock {
        Start-SecretRotation -Internal
    }
    Remove-PSSession -Session $PEPSession
    ```

    ::: moniker range="<azs-1811"
    > [!Note]
    > Pre-1811 versions don't require the `-Internal` flag. 
    ::: moniker-end


2. After successful completion, your console will display `ActionPlanInstanceID ... CurrentStatus: Completed`, followed by a `DONE`

    > [!Note]
    > If secret rotation fails, follow the instructions in the error message and rerun `Start-SecretRotation` with the  `-Internal` and `-ReRun` parameters.  
    >
    >```powershell
    >Start-SecretRotation -Internal -ReRun
    >```
    >
    > Contact support if you experience repeated secret rotation failures.

## Update the BMC credential

The baseboard management controller monitors the physical state of your servers. Refer to your original equipment manufacturer (OEM) hardware vendor for instructions to update the user account name and password of the BMC.

>[!NOTE]
> Your OEM may provide additional management apps. Updating the user name or password for other management apps has no effect on the BMC user name or password. 

::: moniker range="<azs-1910"
1. Update the BMC on the Azure Stack Hub physical servers by following your OEM instructions. The user name and password for each BMC in your environment must be the same. The BMC user names can't exceed 16 characters.
::: moniker-end

::: moniker range=">=azs-1910"
1. It's no longer required that you first update the BMC credentials on the Azure Stack Hub physical servers by following your OEM instructions. The user name and password for each BMC in your environment must be the same, and can't exceed 16 characters. 
::: moniker-end

2. Open a privileged endpoint in Azure Stack Hub sessions. For instructions, see [Using the privileged endpoint in Azure Stack Hub](azure-stack-privileged-endpoint.md). 

3. After opening a privileged endpoint session, run one of the PowerShell scripts below, which use Invoke-Command to run Set-BmcCredential. If you use the optional -BypassBMCUpdate parameter with Set-BMCCredential, credentials in the BMC aren't updated. Only the Azure Stack Hub internal datastore is updated.Pass your privileged endpoint session variable as a parameter.

    Here's an example PowerShell script that will prompt for user name and password: 

    ```powershell
    # Interactive Version
    $PEPIp = "<Privileged Endpoint IP or Name>" # You can also use the machine name instead of IP here.
    $PEPCreds = Get-Credential "<Domain>\CloudAdmin" -Message "PEP Credentials"
    $NewBmcPwd = Read-Host -Prompt "Enter New BMC password" -AsSecureString
    $NewBmcUser = Read-Host -Prompt "Enter New BMC user name"

    $PEPSession = New-PSSession -ComputerName $PEPIp -Credential $PEPCreds -ConfigurationName "PrivilegedEndpoint"

    Invoke-Command -Session $PEPSession -ScriptBlock {
        # Parameter BmcPassword is mandatory, while the BmcUser parameter is optional.
        Set-BmcCredential -BmcPassword $using:NewBmcPwd -BmcUser $using:NewBmcUser
    }
    Remove-PSSession -Session $PEPSession
    ```

    You can also encode the user name and password in variables, which may be less secure:

    ```powershell
    # Static Version
    $PEPIp = "<Privileged Endpoint IP or Name>" # You can also use the machine name instead of IP here.
    $PEPUser = "<Privileged Endpoint user for example Domain\CloudAdmin>"
    $PEPPwd = ConvertTo-SecureString "<Privileged Endpoint Password>" -AsPlainText -Force
    $PEPCreds = New-Object System.Management.Automation.PSCredential ($PEPUser, $PEPPwd)
    $NewBmcPwd = ConvertTo-SecureString "<New BMC Password>" -AsPlainText -Force
    $NewBmcUser = "<New BMC User name>"

    $PEPSession = New-PSSession -ComputerName $PEPIp -Credential $PEPCreds -ConfigurationName "PrivilegedEndpoint"

    Invoke-Command -Session $PEPSession -ScriptBlock {
        # Parameter BmcPassword is mandatory, while the BmcUser parameter is optional.
        Set-BmcCredential -BmcPassword $using:NewBmcPwd -BmcUser $using:NewBmcUser
    }
    Remove-PSSession -Session $PEPSession
    ```

## Reference: Start-SecretRotation cmdlet

[Start-SecretRotation cmdlet](../reference/pep-2002/start-secretrotation.md) rotates the infrastructure secrets of an Azure Stack Hub system. This cmdlet can only be executed against the Azure Stack Hub privileged endpoint, by using an  `Invoke-Command` script block passing the PEP session in the `-Session` parameter. By default, it rotates only the certificates of all external network infrastructure endpoints.

| Parameter | Type | Required | Position | Default | Description |
|--|--|--|--|--|--|
| `PfxFilesPath` | String  | False  | Named  | None  | The fileshare path to the **\Certificates** directory containing all external network endpoint certificates. Only required when rotating external secrets. End directory must be **\Certificates**. |
| `CertificatePassword` | SecureString | False  | Named  | None  | The password for all certificates provided in the -PfXFilesPath. Required value if PfxFilesPath is provided when external secrets are rotated. |
| `Internal` | String | False | Named | None | Internal flag must be used anytime an Azure Stack Hub operator wishes to rotate internal infrastructure secrets. |
| `PathAccessCredential` | PSCredential | False  | Named  | None  | The PowerShell credential for the fileshare of the **\Certificates** directory containing all external network endpoint certificates. Only required when rotating external secrets.  |
| `ReRun` | SwitchParameter | False  | Named  | None  | Must be used anytime secret rotation is reattempted after a failed attempt. |

### Syntax

#### For external secret rotation

```powershell
Start-SecretRotation [-PfxFilesPath <string>] [-PathAccessCredential <PSCredential>] [-CertificatePassword <SecureString>]  
```

#### For internal secret rotation

```powershell
Start-SecretRotation [-Internal]  
```

#### For external secret rotation rerun

```powershell
Start-SecretRotation [-ReRun]
```

#### For internal secret rotation rerun

```powershell
Start-SecretRotation [-ReRun] [-Internal]
```

### Examples

#### Rotate only internal infrastructure secrets

This command must be run via your Azure Stack Hub [environment's privileged endpoint](azure-stack-privileged-endpoint.md).

```powershell
PS C:\> Start-SecretRotation -Internal
```

This command rotates all of the infrastructure secrets exposed to the Azure Stack Hub internal network.

#### Rotate only external infrastructure secrets  

```powershell
# Create a PEP Session
winrm s winrm/config/client '@{TrustedHosts= "<IP_address_of_ERCS>"}'
$PEPCreds = Get-Credential
$PEPSession = New-PSSession -ComputerName <IP_address_of_ERCS> -Credential $PEPCreds -ConfigurationName "PrivilegedEndpoint"

# Create Credentials for the fileshare
$CertPassword = ConvertTo-SecureString "<CertPasswordHere>" -AsPlainText -Force
$CertShareCreds = Get-Credential
$CertSharePath = "<NetworkPathOfCertShare>"
# Run Secret Rotation
Invoke-Command -Session $PEPSession -ScriptBlock {  
    Start-SecretRotation -PfxFilesPath $using:CertSharePath -PathAccessCredential $using:CertShareCreds -CertificatePassword $using:CertPassword
}
Remove-PSSession -Session $PEPSession
```

This command rotates the TLS certificates used for Azure Stack Hub's external network infrastructure endpoints.

::: moniker range="<azs-1811"
#### Rotate internal and external infrastructure secrets (**pre-1811** only)

> [!IMPORTANT]
> This command only applies to Azure Stack Hub **pre-1811** as the rotation has been split for internal and external certificates.
>
> **From *1811+* you can't rotate both internal and external certificates anymore!**

```powershell
# Create a PEP Session
winrm s winrm/config/client '@{TrustedHosts= "<IP_address_of_ERCS>"}'
$PEPCreds = Get-Credential
$PEPSession = New-PSSession -ComputerName <IP_address_of_ERCS> -Credential $PEPCreds -ConfigurationName "PrivilegedEndpoint"

# Create Credentials for the fileshare
$CertPassword = ConvertTo-SecureString "<CertPasswordHere>" -AsPlainText -Force
$CertShareCreds = Get-Credential
$CertSharePath = "<NetworkPathOfCertShare>"
# Run Secret Rotation
Invoke-Command -Session $PEPSession -ScriptBlock {
    Start-SecretRotation -PfxFilesPath $using:CertSharePath -PathAccessCredential $using:CertShareCreds -CertificatePassword $using:CertPassword
}
Remove-PSSession -Session $PEPSession
```

This command rotates the infrastructure secrets exposed to Azure Stack Hub internal network, and the TLS certificates used for Azure Stack Hub's external network infrastructure endpoints. Start-SecretRotation rotates all stack-generated secrets, and because there are provided certificates, external endpoint certificates will also be rotated.  
::: moniker-end

## Next steps

[Learn more about Azure Stack Hub security](azure-stack-security-foundations.md)