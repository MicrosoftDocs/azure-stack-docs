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

> [!IMPORTANT]
> The instructions in this article work only if the Network Controller certificates haven't expired. If the certificates have already expired, DO NOT use these instructions.

> [!WARNING]
> Don't remove any existing Network Controller certificates.

If you are using Software Defined Networking (SDN), Network Controller is one of the three major components that you deploy. You can deploy Network Controller in both domain and non-domain environments. In domain environments, Network Controller authenticates users and network devices by using Kerberos; in nondomain environments, you must deploy certificates for authentication. 

This article describes how to change or update your Network Controller certificates. You must update the certificates before they expire.

## When to update Network Controller certificates

You can change or update the certificates when:

- The certificate is nearing expiry. You can renew the certificates at any point before they expire.
  > [!NOTE]
  > If you renew existing certificates with the same key, you are all set and don't need to do anything.

- You want to replace a self-signed certificate with a Certificate Authority (CA)-signed certificate.
   > [!NOTE]
   > While changing the certificates, ensure that you use the same subject name as of the old certificate.

## Certificate usage for SDN

In Azure Stack HCI, Network Controller uses two types of certificates:

- REST certificate: A single certificate for Northbound communication with REST clients (such as Windows Admin Center) and Southbound communication with Hyper-V hosts and software load balancers. This same certificate is present on all Network Controller Virtual Machines (VMs).

- Network Controller node certificate: A certificate on each Network Controller VM for inter-node authentication.

## Check for certificate expiry

You can check for certificate expiry by running the following command on the Network Controller VMs:

```powershell
Get-ChildItem Cert:\\LocalMachine\\My \| where{\$\_.Subject -eq "CN=\<Certificate-subject-name\>\"}\|Select-Object NotAfter, Subject
```

- To get the expiry of the REST certificate, replace "Certificate-subject-name" with the REST name of the deployment. You can get this value from the `Get-NetworkController` command.

- To get the expiry of the node certificate, replace "Certificate-subject-name" with the fully qualified domain name (FQDN) of the Network Controller VM. You can get this value from the `Get-NetworkController` command.

## Renew REST certificate

You can use the Network Controller's REST certificate for:

- Northbound communication with REST clients 
- Encryption of credentials
- Southbound communication to hosts, Gateway VMs, and Software Load Balancer (SLB) VMs

When you update the certificate, you must update these communication channels and devices to use the new certificate.

To renew REST certificate, complete the following steps:

1. [Assign the new certificate to a variable](#assign-the-new-certificate-to-a-variable)
1. [Set permissions on the certificate for Network Service to Read and Allow](#set-permissions-on-the-certificate-for-network-service-to-read-and-allow)
1. [Copy the certificate to all Network Controller VMs](#copy-the-certificate-to-all-network-controller-vms)
1. [(Only for self-signed certificate) Copy the certificate public key to all the hosts and Software Load Balancer VMs](#copy-the-certificate-public-key-to-all-the-hosts-and-software-load-balancer-vms)

### Assign the new certificate to a variable

```powershell
\$cert= Get-ChildItem Cert:\\LocalMachine\\My \| where{\$\_.Thumbprint -eq \"512D56994E40D97C9BC07A52BB3E74D54CF76EA0\"}
```

### Set permissions on the certificate for Network Service to Read and Allow

You need to provide some permissions for NT Authority/Network Service on the certificate. This can be done as follows: 

```powershell
\$targetCertPrivKey = \$Cert.PrivateKey
\$privKeyCertFile = Get-Item -path
\"\$ENV:ProgramData\\Microsoft\\Crypto\\RSA\\MachineKeys\\\*\" \|where-object {\$\_.Name -eq
\$targetCertPrivKey.CspKeyContainerInfo.UniqueKeyContainerName}
\$privKeyAcl = Get-Acl \$privKeyCertFile
\$permission = \"NT AUTHORITY\\NETWORK SERVICE\",\"Read\",\"Allow\"
\$accessRule = new-object
System.Security.AccessControl.FileSystemAccessRule \$permission\$privKeyAcl.AddAccessRule(\$accessRule)
Set-Acl \$privKeyCertFile.FullName \$privKeyAcl
```

### Copy the certificate to all Network Controller VMs

Ensure that you procure the new certificate and put it in the Personal store of the Local Machine (LocalMachine\\My). Replace the same certificate (with private key) in the LocalMachine/My store of all the Network Controller VMs. 

Here are the sample commands to export and then import the certificate:

On the first Network Controller VM:

```powershell
\$mypwd = ConvertTo-SecureString -String \"1234\" -Force -AsPlainText
Export-PfxCertificate -FilePath C:\\newpfx.pfx -Password \$mypwd -Cert
\$cert
//Here, \$cert is the new certificate
```

On other Network Controller VMs:

```powershell
\$mypwd = ConvertTo-SecureString -String \"1234\" -Force -AsPlainText

Import-PfxCertificate -FilePath C:\\newpfx.pfx -CertStoreLocation
Cert:\\LocalMachine\\My -Password \$mypwd

//Ensure that you copy the pfx file into the local machine before
importing the cert
```

### Copy the certificate public key to all the hosts and Software Load Balancer VMs

If the certificate is a self-signed certificate, it must also be placed in the (LocalMachine\\Root) store of every NC VM. It must also be placed in the (LocalMachine\\Root) store of every Azure Stack HCI host machine, Gateway VMs and the SLB VMs. This is to ensure that the certificate is trusted by the peer entities.

Sample command to import the certificate public key that has already been exported:

```powershell
Import-Certificate -FilePath
\"\\\\sa18fs\\SU1_LibraryShare1\\RestCert.cer\" -CertStoreLocation
cert:\\localMachine\\Root
```

### Renew certificate for REST communication

To renew the certificate, execute the following command:

```powershell
Set-NetworkController -ServerCertificate \$cert
```

### Renew certificate for encryption of credentials

To renew the certificate, execute the following command on any of the NC VMs:

```powershell
Set-NetworkControllerCluster -CredentialEncryptionCertificate \$cert
```

### Renew certificate for southbound communication

Then, we need to update the Credential REST resource for the certificate. This certificate is also used for communicating with hosts and Software Load Balancers, and the certificate thumbprint must be changed in the Credential REST resource.

```powershell
> \$certCred = Get-NetworkControllerCredential -ConnectionUri \<REST uri
> of deployment\> \| where-object { \$\_.properties.type -eq
> \"X509Certificate\" }

\$certCred\[0\].Properties.Value =
\"DC34C416E20AACE0851B11371B803EB74AA7A51D\"

//This is the thumbprint of the new certificate

> New-NetworkControllerCredential -ConnectionUri \<REST uri of
> deployment\> -ResourceId \$certCred\[0\].ResourceId -Properties
> \$certCred\[0\].Properties -Force
```

## Renew NC node certificate

To renew the NC node certificate, perform the following steps on each Network Controller VM:

1. Procure the new certificate and put it in the Personal store of the Local Machine (LocalMachine\\My). If it is a self-signed certificate, it must also be placed in the (LocalMachine\\Root) store of every NC VM.

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