---
title: Renew certificates for Software Defined Networking infrastructure
description: This article describes how to renew or change SDN server and Software Load Balancer multiplexer certificates.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 06/26/2023
---

# Renew certificates for Software Defined Networking infrastructure

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022 and Windows Server 2019

This article provides instructions on how to renew or change Software Defined Networking (SDN) server and Software Load Balancer (SLB) multiplexer (MUX) certificates. If you face any issues in renewing your certificates, contact Microsoft Support.

For information about how to renew Network Controller certificates, see [Renew Network Controller certificates before they expire](./update-network-controller-certificates.md).

In your SDN infrastructure, the Network Controller uses certificate-based authentication to secure Southbound communications with network devices, such as the SLB and the physical hosts. The certificates for the SLB and server come with a validity period, after which they become invalid and can no longer be trusted for use. You must renew them before they expire.

## When to renew or change certificates

You can renew or change SDN server and SLB MUX certificates when:

- The certificates are nearing expiry. You can indeed renew these certificates at any point before they expire.

  > [!NOTE]
  > If you renew existing certificates with the same key, you are all set and don't need to do anything.

- You want to replace a self-signed certificate with a Certificate Authority (CA)-signed certificate.

   > [!NOTE]
   > While changing the certificates, ensure that you use the same subject name as of the old certificate.

## Types of certificates

In Azure Stack HCI and Windows Server, physical hosts and SLB MUX virtual machines (VMs) use one certificate each to secure southbound communication with the Network Controller. Network Controller pushes policy to the physical hosts and the SLB MUX VMs.

## View certificate expiry

Use the following cmdlet on each physical host and SLB MUX VM to check the expiration date of a certificate:

```powershell
Get-ChildItem Cert:\LocalMachine\My | where{$_.Subject -eq "CN=<Certificate-subject-name>"} | Select-Object NotAfter, Subject
```

where:
- `Certificate-subject-name` is the fully qualified domain name (FQDN) of the server and the SLB MUX VMs.

## Renew SDN server and SLB MUX certificates

Use the [`Start-SdnServerCertificateRotation`](https://github.com/microsoft/SdnDiagnostics/wiki/Start-SdnServerCertificateRotation) and [`Start-SdnMuxCertificateRotation`](https://github.com/microsoft/SdnDiagnostics/wiki/Start-SdnMuxCertificateRotation) cmdlets to generate new self-signed certificates and automatically renew them to all the servers and SLB MUX VMs respectively. By default, the cmdlets generate certificates with a validity period of three years, but you can specify a different validity period. Certificate automatic renewal helps minimize any downtime or unplanned outages caused due to certificate expiry issues.

> [!NOTE]
> The functionality to renew bring-your-own-certificates and pre-installed certificates isn't yet available.

### Requirements

Here are the requirements for renewal of certificates:

- You must run the cmdlets on any machine that has access to the management network. For installation instructions, see [Install SdnDiagnostics module](https://github.com/microsoft/SdnDiagnostics/wiki#installation).

- You must have credentials for the `Credential` account to specify a user account with local admin privileges on Network Controller, SLB MUXes, and servers.

### Renew self-signed certificate automatically

Perform these steps to generate self-signed certificates and automatically renew them:

1. To generate self-signed certificates on the physical hosts, run the `Start-SdnServerCertificateRotation` cmdlet. You can use the `-Force` parameter with the cmdlet to avoid any prompts for confirmation or manual inputs during the rotation process.

   > [!NOTE]
   > To renew the SLB MUX certificates, replace the cmdlet name with `Start-SdnMuxCertificateRotation` in the following commands.

   - To generate self-signed certificates with the default three years validity period, run the following commands:

        ```powershell
        Import-Module -Name SdnDiagnostics -Force
        Start-SdnServerCertificateRotation -GenerateCertificate -CertPassword (Get-Credential).Password -Credential (Get-Credential)
        ```

   - To generate self-signed certificates with a specific validity period, use the `NotAfter` parameter to specify the validity period. For example, to generate self-signed certificates with a validity period of five years, run the following commands:

        ```powershell
        Import-Module -Name SdnDiagnostics -Force
        Start-SdnServerCertificateRotation -GenerateCertificate -CertPassword (Get-Credential).Password -NotAfter (Get-Date).AddYears(5) -Credential (Get-Credential)
        ```

1. After you confirm to continue with the certificate rotation, you can view the status of the ongoing operations in the PowerShell command window.

   > [!Important]
   > Don't close the PowerShell window until the cmdlet finishes. Depending on your environment, such as the number of physical servers in the cluster, it may take several minutes or more than an hour to finish.

## Next steps

- [Update SDN infrastructure for Azure Stack HCI](./update-sdn.md)