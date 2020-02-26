---
title: Fix common issues with PKI certificates
titleSuffix: Azure Stack Hub
description: Fix common issues with Azure Stack Hub PKI certificates using the Azure Stack Hub Readiness Checker.
author: IngridAtMicrosoft
ms.topic: conceptual
ms.date: 10/03/2019
ms.author: inhenkel
ms.reviewer: unknown
ms.lastreviewed: 11/19/2

# Intent: As an Azure Stack operator, I want to fix common issues with PKI certificates.
# Keyword: fix issues pki certificates

---


# Fix common issues with Azure Stack Hub PKI certificates

The information in this article helps you understand and resolve common issues with Azure Stack Hub PKI certificates. You can discover issues when you use the Azure Stack Hub Readiness Checker tool to [validate Azure Stack Hub PKI certificates](azure-stack-validate-pki-certs.md). The tool checks if the certificates meet the PKI requirements of an Azure Stack Hub deployment and Azure Stack Hub secret rotation, and then logs the results to a [report.json file](azure-stack-validation-report.md).  

## PFX Encryption

**Issue** - PFX encryption isn't TripleDES-SHA1.

**Fix** - Export PFX files with **TripleDES-SHA1** encryption. This is the default encryption for all Windows 10 clients when exporting from certificate snap-in or using `Export-PFXCertificate`.

## Read PFX

**Warning** - Password only protects the private information in the certificate.  

**Fix** - Export PFX files with the optional setting for **Enable certificate privacy**.  

**Issue** - PFX file invalid.  

**Fix** - Re-export the certificate using the steps in [Prepare Azure Stack Hub PKI certificates for deployment](azure-stack-prepare-pki-certs.md).

## Signature algorithm

**Issue** - Signature algorithm is SHA1.

**Fix** - Use the steps in Azure Stack Hub certificates signing request generation to regenerate the certificate signing request (CSR) with the signature algorithm of SHA256. Then resubmit the CSR to the certificate authority to reissue the certificate.

## Private key

**Issue** - The private key is missing or doesn't contain the local machine attribute.  

**Fix** - From the computer that generated the CSR, re-export the certificate using the steps in [Prepare Azure Stack Hub PKI certificates for deployment](azure-stack-prepare-pki-certs.md#prepare-certificates-for-deployment). These steps include exporting from the local machine certificate store.

## Certificate chain

**Issue** - Certificate chain isn't complete.  

**Fix** - Certificates should contain a complete certificate chain. Re-export the certificate using the steps in [Prepare Azure Stack Hub PKI certificates for deployment](azure-stack-prepare-pki-certs.md#prepare-certificates-for-deployment) and select the option **Include all certificates in the certification path if possible**.

## DNS names

**Issue** - The **DNSNameList** on the certificate doesn't contain the Azure Stack Hub service endpoint name or a valid wildcard match. Wildcard matches are only valid for the left-most namespace of the DNS name. For example, `*.region.domain.com` is only valid for `portal.region.domain.com`, not `*.table.region.domain.com`.

**Fix** - Use the steps in Azure Stack Hub certificates signing request generation to regenerate the CSR with the correct DNS names to support Azure Stack Hub endpoints. Resubmit the CSR to a certificate authority. Then follow the steps in [Prepare Azure Stack Hub PKI certificates for deployment](azure-stack-prepare-pki-certs.md#prepare-certificates-for-deployment) to export the certificate from the machine that generated the CSR.  

## Key usage

**Issue** - Key usage is missing digital signature or key encipherment, or enhanced key usage is missing server authentication or client authentication.  

**Fix** - Use the steps in [Azure Stack Hub certificates signing request generation](azure-stack-get-pki-certs.md) to regenerate the CSR with the correct key usage attributes. Resubmit the CSR to the certificate authority and confirm that a certificate template isn't overwriting the key usage in the request.

## Key size

**Issue** - Key size is smaller than 2048.

**Fix** - Use the steps in [Azure Stack Hub certificates signing request generation](azure-stack-get-pki-certs.md) to regenerate the CSR with the correct key length (2048), and then resubmit the CSR to the certificate authority.

## Chain order

**Issue** - The order of the certificate chain is incorrect.  

**Fix** - Re-export the certificate using the steps in [Prepare Azure Stack Hub PKI certificates for deployment](azure-stack-prepare-pki-certs.md#prepare-certificates-for-deployment) and select the option **Include all certificates in the certification path if possible**. Ensure that only the leaf certificate is selected for export.

## Other certificates

**Issue** - The PFX package contains certificates that aren't the leaf certificate or part of the certificate chain.  

**Fix** - Re-export the certificate using the steps in [Prepare Azure Stack Hub PKI certificates for deployment](azure-stack-prepare-pki-certs.md#prepare-certificates-for-deployment), and select the option **Include all certificates in the certification path if possible**. Ensure that only the leaf certificate is selected for export.

## Fix common packaging issues

The **AzsReadinessChecker** tool contains a helper cmdlet called **Repair-AzsPfxCertificate**, which can import and then export a PFX file to fix common packaging issues, including:

- **PFX encryption** isn't TripleDES-SHA1.
- **Private key** is missing local machine attribute.
- **Certificate chain** is incomplete or wrong. The local machine must contain the certificate chain if the PFX package doesn't.
- **Other certificates**

**Repair-AzsPfxCertificate** can't help if you need to generate a new CSR and reissue a certificate.

### Prerequisites

The following prerequisites must be in place on the computer on which the tool runs:

- Windows 10 or Windows Server 2016, with internet connectivity.
- PowerShell 5.1 or later. To check your version, run the following PowerShell cmdlet and then review the **Major** and **Minor** versions:

   ```powershell
   $PSVersionTable.PSVersion
   ```

- Configure [PowerShell for Azure Stack Hub](azure-stack-powershell-install.md).
- Download the latest version of the [Azure Stack Hub readiness checker](https://aka.ms/AzsReadinessChecker) tool.

### Import and export an existing PFX File

1. On a computer that meets the prerequisites, open an elevated PowerShell prompt, and then run the following command to install the Azure Stack Hub readiness checker:

   ```powershell
   Install-Module Microsoft.AzureStack.ReadinessChecker -Force
   ```

2. From the PowerShell prompt, run the following cmdlet to set the PFX password. Replace `PFXpassword` with the actual password:

   ```powershell
   $password = Read-Host -Prompt PFXpassword -AsSecureString
   ```

3. From the PowerShell prompt, run the following command to export a new PFX file:

   - For `-PfxPath`, specify the path to the PFX file you're working with. In the following example, the path is `.\certificates\ssl.pfx`.
   - For `-ExportPFXPath`, specify the location and name of the PFX file for export. In the following example, the path is `.\certificates\ssl_new.pfx`:

   ```powershell
   Repair-AzsPfxCertificate -PfxPassword $password -PfxPath .\certificates\ssl.pfx -ExportPFXPath .\certificates\ssl_new.pfx
   ```  

4. After the tool completes, review the output for success:

   ```shell
   Repair-AzsPfxCertificate v1.1809.1005.1 started.
   Starting Azure Stack Hub Certificate Import/Export
   Importing PFX .\certificates\ssl.pfx into Local Machine Store
   Exporting certificate to .\certificates\ssl_new.pfx
   Export complete. Removing certificate from the local machine store.
   Removal complete.
   Log location (contains PII): C:\Users\username\AppData\Local\Temp\AzsReadinessChecker\AzsReadinessChecker.log
   Repair-AzsPfxCertificate Completed
   ```

## Next steps

- [Learn more about Azure Stack Hub security](azure-stack-rotate-secrets.md)
