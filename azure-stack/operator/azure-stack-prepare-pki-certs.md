---
title: Prepare Azure Stack Hub PKI certificates for deployment or rotation 
titleSuffix: Azure Stack Hub
description: Learn how to prepare PKI certificates for Azure Stack Hub deployment or for rotating secrets.
author: IngridAtMicrosoft
ms.topic: how-to
ms.date: 03/04/2020
ms.author: inhenkel
ms.reviewer: ppacent
ms.lastreviewed: 09/16/2019

# Intent: As an Azure Stack operator, I want to prepare my PKI certificates for Azure Stack deployment.
# Keyword: prepare PKI certificates azure stack

---


# Prepare Azure Stack Hub PKI certificates for deployment or rotation

> [!NOTE]
> This article pertains to the preparation of external certificates only, which are used to secure endpoints on external infrastructure and services. Internal certificates are managed separately, by the [certificate rotation process](azure-stack/operator/azure-stack-rotate-secrets.md)

The certificate files [obtained from the certificate authority (CA)](azure-stack-get-pki-certs.md) must be imported and exported with properties matching Azure Stack Hub's certificate requirements.

In this article you learn how to import, package, and validate external certificates, to prepare for Azure Stack Hub deployment or secrets rotation. 

## Prerequisites

Your system should meet the following prerequisites before packaging PKI certificates for an Azure Stack Hub deployment:

- Certificates returned from Certificate Authority are stored in a single directory, in .cer format (other configurable formats such as .cert, .sst or .pfx).
- Windows 10, or Windows Server 2016 or later
- Use the same system that generated the Certificate Signing Request (unless you're targeting a certificate prepackaged into PFXs).

Continue to the appropriate [Prepare certificates (Azure Stack readiness checker)](#prepare-certificates-azure-stack-readiness-checker) or [Prepare certificates (manual steps)](#prepare-certificates-manual-steps) section.

## Prepare certificates (Azure Stack readiness checker)

Use these steps to package certificates using the Azure Stack readiness checker PowerShell cmdlets:

1. Install the Azure Stack readiness checker module from a PowerShell prompt (5.1 or above), by running the following cmdlet:

    ```powershell  
        Install-Module Microsoft.AzureStack.ReadinessChecker
    ```
2. Specify the **Path** to the certificate files. For example:

    ```powershell  
        $Path = "$env:USERPROFILE\Documents\AzureStack"
    ```

3. Declare the **pfxPassword**. For example:

    ```powershell  
        $pfxPassword = Read-Host -AsSecureString -Prompt "PFX Password"
    ```
4. Declare the **ExportPath** where the resulting PFXs will be exported to. For example:

    ```powershell  
        $ExportPath = "$env:USERPROFILE\Documents\AzureStack"
    ```

5. Convert certificates to Azure Stack Hub Certificates. For example:

    ```powershell  
        ConvertTo-AzsPFX -Path $Path -pfxPassword $pfxPassword -ExportPath $ExportPath
    ```
8.  Review the output:

    ```powershell  
    ConvertTo-AzsPFX v1.2005.1286.272 started.

    Stage 1: Scanning Certificates
        Path: C:\Users\[*redacted*]\Documents\AzureStack Filter: CER Certificate count: 11
        adminmanagement_east_azurestack_contoso_com_CertRequest_20200710235648.cer
        adminportal_east_azurestack_contoso_com_CertRequest_20200710235645.cer
        management_east_azurestack_contoso_com_CertRequest_20200710235644.cer
        portal_east_azurestack_contoso_com_CertRequest_20200710235646.cer
        wildcard_adminhosting_east_azurestack_contoso_com_CertRequest_20200710235649.cer
        wildcard_adminvault_east_azurestack_contoso_com_CertRequest_20200710235642.cer
        wildcard_blob_east_azurestack_contoso_com_CertRequest_20200710235653.cer
        wildcard_hosting_east_azurestack_contoso_com_CertRequest_20200710235652.cer
        wildcard_queue_east_azurestack_contoso_com_CertRequest_20200710235654.cer
        wildcard_table_east_azurestack_contoso_com_CertRequest_20200710235650.cer
        wildcard_vault_east_azurestack_contoso_com_CertRequest_20200710235647.cer

    Detected ExternalFQDN: east.azurestack.contoso.com

    Stage 2: Exporting Certificates
        east.azurestack.contoso.com\Deployment\ARM Admin\ARMAdmin.pfx
        east.azurestack.contoso.com\Deployment\Admin Portal\AdminPortal.pfx
        east.azurestack.contoso.com\Deployment\ARM Public\ARMPublic.pfx
        east.azurestack.contoso.com\Deployment\Public Portal\PublicPortal.pfx
        east.azurestack.contoso.com\Deployment\Admin Extension Host\AdminExtensionHost.pfx
        east.azurestack.contoso.com\Deployment\KeyVaultInternal\KeyVaultInternal.pfx
        east.azurestack.contoso.com\Deployment\ACSBlob\ACSBlob.pfx
        east.azurestack.contoso.com\Deployment\Public Extension Host\PublicExtensionHost.pfx
        east.azurestack.contoso.com\Deployment\ACSQueue\ACSQueue.pfx
        east.azurestack.contoso.com\Deployment\ACSTable\ACSTable.pfx
        east.azurestack.contoso.com\Deployment\KeyVault\KeyVault.pfx

    Stage 3: Validating Certificates.

    Validating east.azurestack.contoso.com-Deployment-AAD certificates in C:\Users\[*redacted*]\Documents\AzureStack\east.azurestack.contoso.com\Deployment 

    Testing: KeyVaultInternal\KeyVaultInternal.pfx
    Thumbprint: E86699****************************4617D6
        PFX Encryption: OK
        Expiry Date: OK
        Signature Algorithm: OK
        DNS Names: OK
        Key Usage: OK
        Key Length: OK
        Parse PFX: OK
        Private Key: OK
        Cert Chain: OK
        Chain Order: OK
        Other Certificates: OK
    Testing: ARM Public\ARMPublic.pfx
        ...
    Log location (contains PII): C:\Users\[*redacted*]\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessChecker.log
    ConvertTo-AzsPFX Completed
    ```
    > [!NOTE]
    > For additional usage use Get-help ConvertTo-AzsPFX -Full for further usage such as disabling validation or filtering for different certificate formats.

    Following a successful validation certificates can be presented for Deployment or Rotation without any additional steps.

## Prepare certificates (manual steps)

Use these steps to package certificates for new Azure Stack Hub PKI certificates using manual steps.

### Import the certificate

1. Copy the original certificate versions [obtained from your CA of choice](azure-stack-get-pki-certs.md) into a directory on the deployment host. 
   > [!WARNING]
   > Don't copy files that have already been imported, exported, or altered in any way from the files provided directly by the CA.

1. Right-click on the certificate and select **Install Certificate** or **Install PFX**, depending on how the certificate was delivered from your CA.

1. In the **Certificate Import Wizard**, select **Local Machine** as the import location. Select **Next**. On the following screen, select next again.

    ![Local machine import location for certificate](./media/prepare-pki-certs/1.png)

1. Choose **Place all certificate in the following store** and then select **Enterprise Trust** as the location. Select **OK** to close the certificate store selection dialog box and then select **Next**.

   ![Configure the certificate store for certificate import](./media/prepare-pki-certs/3.png)

   a. If you're importing a PFX, you'll be presented with an additional dialog. On the **Private key protection** page, enter the password for your certificate files and then enable the **Mark this key as exportable.** option, allowing you to back up or transport your keys later. Select **Next**.

   ![Mark key as exportable](./media/prepare-pki-certs/2.png)

1. Select **Finish** to complete the import.

> [!NOTE]
> After you import a certificate for Azure Stack Hub, the private key of the certificate is stored as a PKCS 12 file (PFX) on clustered storage.

### Export the certificate

Open Certificate Manager MMC console and connect to the Local Machine certificate store.

1. Open the Microsoft Management Console. To open the console in Windows 10, right-click on the **Start Menu**, select **Run**, then type **mmc** and press enter.

2. Select **File** > **Add/Remove Snap-In**, then select **Certificates** and select **Add**.

    ![Add Certificates Snap-in in Microsoft Management Console](./media/prepare-pki-certs/mmc-2.png)

3. Select **Computer account**, then select **Next**. Select **Local computer** and then **Finish**. Select **OK** to close the Add/Remove Snap-In page.

    ![Select account for Add Certificates Snap-in in Microsoft Management Console](./media/prepare-pki-certs/mmc-3.png)

4. Browse to **Certificates** > **Enterprise Trust** > **Certificate location**. Verify that you see your certificate on the right.

5. From the Certificate Manager Console taskbar, select **Actions** > **All Tasks** > **Export**. Select **Next**.

   > [!NOTE]
   > Depending on how many Azure Stack Hub certificates you have, you may need to complete this process more than once.

6. Select **Yes, Export the Private Key**, and then select **Next**.

7. In the Export File Format section:
    
   - Select **Include all certificates in the certificate if possible**.  
   - Select **Export all Extended Properties**.  
   - Select **Enable certificate privacy**.  
   - Select **Next**.  
    
     ![Certificate export wizard with selected options](./media/prepare-pki-certs/azure-stack-save-cert.png)

8. Select **Password** and provide a password for the certificates. Create a password that meets the following password complexity requirements:

    * A minimum length of eight characters.
    * At least three of the following characters: uppercase letter, lowercase letter, numbers from 0-9, special characters, alphabetical character that's not uppercase or lowercase.

    Make note of this password. You'll use it as a deployment parameter.

9. Select **Next**.

10. Choose a file name and location for the PFX file to export. Select **Next**.

11. Select **Finish**.

## Next steps

[Validate PKI certificates](azure-stack-validate-pki-certs.md)
