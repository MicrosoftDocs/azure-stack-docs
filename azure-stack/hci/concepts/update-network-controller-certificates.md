---
title: Renew Network Controller certificates before they expire
description: This article describes how to renew Network Controller certificates before they expire.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: conceptual
ms.date: 08/22/2022
---

# Renew Network Controller certificates before they expire

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022 and Windows Server 2019

This article provides instructions on how to renew or change Network Controller certificates before they expire.

> [!IMPORTANT]
> If Network Controller certificates have already expired, don't use instructions in this article to renew them.

In your Software Defined Networking (SDN) infrastructure, the Network Controller uses certificate-based authentication to secure Northbound communication channels with management clients and Southbound communications with network devices, such as the Software Load Balancer. The Network Controller certificates come with a validity period, after which they become invalid and can no longer be trusted for use. You must renew them before they expire.

For an overview information about Network Controller, see [What is Network Controller?](../concepts/network-controller-overview.md)

## When to renew or change Network Controller certificates

You can renew or change Network Controller certificates when:

- The certificates are nearing expiry. You can indeed renew Network Controller certificates at any point before they expire.

  > [!NOTE]
  > If you renew existing certificates with the same key, you are all set and don't need to do anything.

- You want to replace a self-signed certificate with a Certificate Authority (CA)-signed certificate.

   > [!NOTE]
   > While changing the certificates, ensure that you use the same subject name as of the old certificate.

## Types of Network Controller certificates

In Azure Stack HCI, each Network Controller VM uses two types of certificates:

- REST certificate. A single certificate for Northbound communication with REST clients (such as Windows Admin Center) and Southbound communication with Hyper-V hosts and software load balancers. This same certificate is present on all Network Controller VMs. To renew REST certificates, see [Renew REST certificates](#renew-rest-certificates).

- Network Controller node certificate. A certificate on each Network Controller VM for inter-node authentication. To renew Network Controller node certificates, see [Renew node certificates](#renew-node-certificates).

> [!WARNING]
> Don't let these certificate expire. Renew them before expiry to avoid any authentication issues. Also, don't remove any existing expired certificates before renewing them. To find out the expiration date of a certificate, see [View certificate expiry](#view-certificate-expiry), below.

## View certificate expiry

Use the following cmdlet on each Network Controller VM to check the expiration date of a certificate:

```powershell
Get-ChildItem Cert:\LocalMachine\My | where{$_.Subject -eq "CN=<Certificate-subject-name>"}|Select-Object NotAfter, Subject
```

- To get the expiry of a REST certificate, replace "Certificate-subject-name" with the IP address of the Network Controller REST endpoint. You can get this value from the `Get-NetworkController` cmdlet.

- To get the expiry of a node certificate, replace "Certificate-subject-name" with the fully qualified domain name (FQDN) of the Network Controller VM. You can get this value from the `Get-NetworkController` cmdlet.

## Renew REST certificates

You use the Network Controller's REST certificate for:

- Northbound communication with REST clients 
- Encryption of credentials
- Southbound communication to hosts and Software Load Balancer VMs

When you update a REST certificate, you must update the management clients and network devices to use the new certificate.

To renew REST certificate, complete the following steps:

1. Make sure that the certificate on the Network Controller VMs isn't expired before renewing it. See [View certificate expiry](#view-certificate-expiry).
   
   > [!NOTE]
   > If the certificate is already expired, don't use these steps.

1. Procure the new certificate and place it in the personal store of the local machine (LocalMachine\My). If it's a self-signed certificate, place it in the Root store (LocalMachine\Root) of every Network Controller VM. For information about how to a create new certificate or issue it from a Certification Authority, see [Manage certificates for Software Defined Networking](/windows-server/networking/sdn/security/sdn-manage-certs).

1. Assign the new certificate to a variable:

   ```powershell
   \$cert= Get-ChildItem Cert:\LocalMachine\My | where{$_.Thumbprint -eq "<thumbprint of the new certificate>"}
   ```

1. Provide Read and Allow permissions for NT Authority/Network Service on the certificate:
   
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

1. [Copy the certificate to all Network Controller VMs](#copy-the-certificate-to-all-network-controller-vms).

1. [(Only for self-signed certificate) Copy the certificate public key to all the hosts and Software Load Balancer VMs](#copy-the-certificate-public-key-to-all-the-hosts-and-software-load-balancer-vms-only-for-self-signed-certificate).

1. [Modify Network Controller settings to use the new certificate](#modify-network-controller-settings-to-use-the-new-certificate).

### Copy the certificate to all Network Controller VMs

Follow these steps for copying one certificate to all Network Controller VMs.

1. Ensure that you procure the new certificate and place it in the local machine personal store (My – cert:\localmachine\my).

1. On the first Network Controller VM, export the certificate to a Personal Information Exchange (PFX) file.

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

### Copy the certificate public key to all the hosts and Software Load Balancer VMs (only for self-signed certificate)

If you're using a self-signed certificate, place it in the root store of the local machine (LocalMachine\Root) for each of the following:

- Every Network Controller VM.
- Every Azure Stack HCI host machine and Software Load Balancer VMs. This ensures that the certificate is trusted by the peer entities.

Here's a sample command to import the certificate public key that has already been exported:

```powershell
Import-Certificate -FilePath "\\sa18fs\SU1_LibraryShare1\RestCert.cer\" -CertStoreLocation
cert:\localMachine\Root
```

### Modify Network Controller settings to use the new certificate

Modify Network Controller node, cluster, and application settings to use the new certificate.

**For Northbound communication**

To change the certificate that Network Controller uses for Northbound communication, run the following command on any of the Network Controller VMs:

```powershell
Set-NetworkController -ServerCertificate \$cert
```

**For encryption of credentials**

To change the certificate that Network Controller uses to encrypt the credentials, run the following command on any of the Network Controller VMs:

```powershell
Set-NetworkControllerCluster -CredentialEncryptionCertificate \$cert
```

**For Southbound communication**

To change the certificate that Network Controller uses for communicating with hosts and Software Load Balancers, run the following command:

```powershell
$certCred = Get-NetworkControllerCredential -ConnectionUri <REST uri of deployment> |where-object { $_.properties.type -eq "X509Certificate" }
$certCred[0].Properties.Value ="<Thumbprint of the new certificate>"

New-NetworkControllerCredential -ConnectionUri <REST uri of deployment> -ResourceId $certCred[0].ResourceId -Properties $certCred[0].Properties -Force
```

## Renew node certificates

To renew the Network Controller node certificate, perform the following steps on each Network Controller VM:

1. Procure the new certificate and put it in the Personal store of the Local Machine (LocalMachine\My). If it's a self-signed certificate, it must also be placed in the (LocalMachine\Root) store of every Network Controller VM. For information about how to a create new certificate or issue it from a Certification Authority, see [Manage certificates for Software Defined Networking](/windows-server/networking/sdn/security/sdn-manage-certs).

1. Assign the new certificate to a variable:

   ```powershell
   $cert= Get-ChildItem Cert:\LocalMachine\My | where{\$_.Thumbprint-eq "<thumbprint of the new certificate>"}
   ```

1. Provide Read and Allow permissions for NT Authority/Network Service on the certificate:
   
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

1. Execute the following command to change the node certificate:

   ```powershell
   Set-NetworkControllerNode -Name <Name of the Network Controller node> -NodeCertificate $cert
   ```