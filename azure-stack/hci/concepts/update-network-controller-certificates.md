---
title: Update the Network Controller certificates
description: This article describes how to update Network Controller certificates that haven't expired.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: conceptual
ms.date: 08/16/2022
---

# Update the Network Controller certificates

> Applies to: Azure Stack HCI, versions 21H2 and 20H2

This article provides instructions on how to change or update your Network Controller certificates if they haven't expired.

> [!IMPORTANT]
> Don't use instructions in this article if your Network Controller certificates have already expired.

> [!WARNING]
> Don't remove any existing Network Controller certificates.

If you are using Software Defined Networking (SDN), Network Controller is one of the three major components that you deploy. You can deploy Network Controller in both domain and non-domain environments. In domain environments, Network Controller authenticates users and network devices by using Kerberos; in nondomain environments, you must deploy certificates for authentication. 

## When to update Network Controller certificates

You can change or update the certificates when:

- The certificates are nearing expiry. You can renew the certificates at any point before they expire.
  > [!NOTE]
  > If you renew existing certificates with the same key, you are all set and don't need to do anything.

- You want to replace a self-signed certificate with a Certificate Authority (CA)-signed certificate.
   > [!NOTE]
   > While changing the certificates, ensure that you use the same subject name as of the old certificate.

## Types of Network Controller certificates

In Azure Stack HCI, each Network Controller virtual machine (VM) uses two types of certificates. 

- REST certificate: A single certificate for Northbound communication with REST clients (such as Windows Admin Center) and Southbound communication with Hyper-V hosts and software load balancers. This same certificate is present on all the Network Controller virtual machines (VMs).

- Network Controller node certificate: A certificate on each Network Controller VM for inter-node authentication.

You must update the certificates before they expire. See [How to check a certificate's expiration date](#how-to-check-a-certificates-expiration-date), below.

## How to check a certificate's expiration date

Use the following command on each Network Controller VM to check the expiration date of a certificate placed in the local machine personal store:

```powershell
Get-ChildItem Cert:\LocalMachine\My | where{$_.Subject -eq "CN=<Certificate-subject-name>"}|Select-Object NotAfter, Subject
```

- To get the expiry of the REST certificate, replace "Certificate-subject-name" with the REST name of the deployment. You can get this value from the `Get-NetworkController` command.

- To get the expiry of the node certificate, replace "Certificate-subject-name" with the fully qualified domain name (FQDN) of the Network Controller VM. You can get this value from the `Get-NetworkController` command.

## Renew REST certificate

You can use the Network Controller's REST certificate for:

- Northbound communication with REST clients 
- Encryption of credentials
- Southbound communication to hosts, Gateway VMs, and Software Load Balancer (SLB) VMs

When you update the REST certificate, you must update these communication channels and devices to use the new certificate.

To renew REST certificate, complete the following steps:

1. Make sure that the certificate on the Network Controller VMs is not expired before you proceed to renew it. See [Check the expiration date of the certificate]. If the certificate is already expired, don't proceed further.
1. Procure the new certificate and place it in the personal store of the local machine (LocalMachine\My). If it is a self-signed certificate, place it in the Root store (LocalMachine\Root) of every Network Controller VM.

1. [Assign the new certificate to a variable](#assign-the-new-certificate-to-a-variable).

1. [Set permissions on the certificate for Network Service](#set-permissions-on-the-certificate-for-network-service).

1. [Copy the certificate to all Network Controller VMs](#copy-the-certificate-to-all-network-controller-vms).

1. [(Only for self-signed certificate) Copy the certificate public key to all the hosts and Software Load Balancer VMs](#copy-the-certificate-public-key-to-all-the-hosts-and-software-load-balancer-vms).

1. [Renew REST certificates](#renew-rest-certificate).

### Assign the new certificate to a variable

Use the following cmdlet to assign the new certificate to a variable:

```powershell
\$cert= Get-ChildItem Cert:\LocalMachine\My | where{$_.Thumbprint -eq "<thumbprint of the new certificate>"}
```

### Set permissions on the certificate for Network Service

Provide Read and Allow permissions for NT Authority/Network Service on the certificate.

Enter the following command to provide the required permissions: 

```powershell
$targetCertPrivKey = $Cert.PrivateKey
$privKeyCertFile = Get-Item -path
"$ENV:ProgramData\Microsoft\Crypto\RSA\MachineKeys\*" | where-object {$_.Name -eq
$targetCertPrivKey.CspKeyContainerInfo.UniqueKeyContainerName}
$privKeAcl = Get-Acl $privKeyCertFile
$permission = "NT AUTHORITY\NETWORK SERVICE","Read","Allow"
$accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
$privKeyAcl.AddAccessRule($accessRule)
Set-Acl $privKeyCertFile.FullName $privKeyAcl
```

### Copy the certificate to all Network Controller VMs

Follow these steps for copying one certificate into all Network Controller VMs. 

1. Ensure that you procure the new certificate and place it in the local machine personal store (My – cert:\localmachine\my).
1.  On the first Network Controller VM, export the certificate to a Personal Information Exchange (PFX) file.

   ```powershell
   $mypwd = ConvertTo-SecureString -String "<password>" -Force -AsPlainText
   Export-PfxCertificate -FilePath C:\newpfx.pfx -Password \$mypwd -Cert $cert    
   //Here, $cert is the new certificate
   ```

1. On other Network Controller VMs, import the certificate and private keys from a PFX file to the destination store:

   ```powershell
   $mypwd = ConvertTo-SecureString -String "<password>" -Force -AsPlainText
   Import-PfxCertificate -FilePath C:\newpfx.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd
   //Ensure that you copy the pfx file into the local machine before importing the cert
   ```

### Copy the certificate public key to all the hosts and Software Load Balancer VMs

If the certificate is a self-signed certificate, you must place it in the root store of the local machine (LocalMachine\Root) for each of the following:

- Every Network Controller VM.
- Every Azure Stack HCI host machine, Gateway VMs and the SLB VMs. This ensures that the certificate is trusted by the peer entities.

Here's a sample command to import the certificate public key that has already been exported:

```powershell
Import-Certificate -FilePath "\\sa18fs\SU1_LibraryShare1\RestCert.cer\" -CertStoreLocation
cert:\localMachine\Root
```

### Renew REST certificate 

Renew the certificate for different communication channels:

**Renew certificate for Northbound communication**

To renew the certificate, execute the following command:

```powershell
Set-NetworkController -ServerCertificate \$cert
```

**Renew REST certificate for encryption of credentials**

To renew the certificate, execute the following command on any of the Network Controller VMs:

```powershell
Set-NetworkControllerCluster -CredentialEncryptionCertificate \$cert
```

**Renew REST certificate for Southbound communication**

Then, we need to update the Credential REST resource for the certificate. This certificate is also used for communicating with hosts and Software Load Balancers, and the certificate thumbprint must be changed in the Credential REST resource.

```powershell
> \$certCred = Get-NetworkControllerCredential -ConnectionUri \<REST uri
> of deployment\> \| where-object { \$\_.properties.type -eq
> \"X509Certificate\" }

\$certCred\[0\].Properties.Value =
\"DC34C416E20AACE0851B11371B803EB74AA7A51D\"

//This is the thumbprint of the new certificate

> New-NetworkControllerCredential -ConnectionUri <REST uri of deployment> -ResourceId $certCred[0].ResourceId -Properties $certCred[0].Properties -Force
```

## Renew Network Controller node certificate

To renew the NC node certificate, perform the following steps on each Network Controller VM:

1. Procure the new certificate and put it in the Personal store of the Local Machine (LocalMachine\My). If it is a self-signed certificate, it must also be placed in the (LocalMachine\Root) store of every NC VM.

1. Assign the new certificate to a variable

   ```powershell
   \$cert= Get-ChildItem Cert:\\LocalMachine\\My \| where{\$\_.Thumbprint-eq \"\<thumbprint of the new certificate\>\"}
   ```

1. [Set permissions on the certificate for Network Service to Read and Allow](#set-permissions-on-the-certificate-for-network-service-to-read-and-allow).

1. Execute the following command to change the node certificate:

   ```powershell
   Set-NetworkControllerNode -Name \<Name of the Network Controller node\>-NodeCertificate \$cert
   ```
1. Repeat the above steps on all the Network Controller VMs.