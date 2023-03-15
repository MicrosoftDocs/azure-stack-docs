---
title: Renew Network Controller certificates before they expire
description: This article describes how to renew Network Controller certificates before they expire.
author: ManikaDhiman
ms.author: v-mandhiman
ms.topic: how-to
ms.date: 03/10/2023
---

# Renew Network Controller certificates before they expire

> Applies to: Azure Stack HCI, versions 22H2, 21H2, and 20H2; Windows Server 2022 and Windows Server 2019

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
Get-ChildItem Cert:\LocalMachine\My | where{$_.Subject -eq "CN=<Certificate-subject-name>"} | Select-Object NotAfter, Subject
```

- To get the expiry of a REST certificate, replace "Certificate-subject-name" with the RestIPAddress or RestName of the Network Controller. You can get this value from the `Get-NetworkController` cmdlet.

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

1. Procure the new certificate and place it in the personal store of the local machine (LocalMachine\My). If it's a self-signed certificate, place it in the Root store (LocalMachine\Root) of every Network Controller VM. For information about how to create a new certificate or issue it from a Certification Authority, see [Manage certificates for Software Defined Networking](/windows-server/networking/sdn/security/sdn-manage-certs).

1. Assign the new certificate to a variable:

   ```powershell
   $cert= Get-ChildItem Cert:\LocalMachine\My | where{$_.Thumbprint -eq "<thumbprint of the new certificate>"}
   ```

1. [Copy the certificate to all Network Controller VMs](#copy-the-certificate-to-all-network-controller-vms).

1. Provide Read and Allow permissions for NT Authority/Network Service on the certificate:
   
   ```powershell
   $targetCertPrivKey = $Cert.PrivateKey
   $privKeyCertFile = Get-Item -path
   "$ENV:ProgramData\Microsoft\Crypto\RSA\MachineKeys\*" | where-object {$_.Name -eq $targetCertPrivKey.CspKeyContainerInfo.UniqueKeyContainerName}
   $privKeyAcl = Get-Acl $privKeyCertFile
   $permission = "NT AUTHORITY\NETWORK SERVICE","Read","Allow"
   $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
   $privKeyAcl.AddAccessRule($accessRule)
   Set-Acl $privKeyCertFile.FullName $privKeyAcl
   ```

1. [(Only for self-signed certificate) Copy the certificate public key to all the hosts and Software Load Balancer VMs](#copy-the-certificate-public-key-to-all-the-hosts-and-software-load-balancer-vms-only-for-self-signed-certificate).

1. [Modify Network Controller settings to use the new certificate](#modify-network-controller-settings-to-use-the-new-certificate).

### Copy the certificate to all Network Controller VMs

Follow these steps for copying one certificate to all Network Controller VMs.

1. Ensure that you procure the new certificate and place it in the local machine personal store (My – cert:\localmachine\my).

1. On the first Network Controller VM, export the certificate to a Personal Information Exchange (PFX) file.

   ```powershell
   $mypwd = ConvertTo-SecureString -String "<password>" -Force -AsPlainText
   Export-PfxCertificate -FilePath "C:\newpfx.pfx" -Password $mypwd -Cert $cert    
   # Here, $cert is the new certificate
   ```

1. On other Network Controller VMs, import the certificate and private keys from a PFX file to the destination store:

   ```powershell
   $mypwd = ConvertTo-SecureString -String "<password>" -Force -AsPlainText
   Import-PfxCertificate -FilePath C:\newpfx.pfx -CertStoreLocation Cert:\LocalMachine\My -Password $mypwd
   # Ensure that you copy the pfx file into the local machine before importing the cert
   ```

### Copy the certificate public key to all the hosts and Software Load Balancer VMs (only for self-signed certificate)

If you're using a self-signed certificate, place it in the root store of the local machine (LocalMachine\Root) for each of the following:

- Every Network Controller VM.
- Every Azure Stack HCI host machine and Software Load Balancer VMs. This ensures that the certificate is trusted by the peer entities.

Here's a sample command to import the certificate public key that has already been exported:

```powershell
Import-Certificate -FilePath "\\sa18fs\SU1_LibraryShare1\RestCert.cer\" -CertStoreLocation cert:\localMachine\Root
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
Set-NetworkControllerCluster -CredentialEncryptionCertificate $cert
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
   $cert = Get-ChildItem Cert:\LocalMachine\My | where{$_.Thumbprint -eq "<thumbprint of the new certificate>"}
   ```

1. Provide Read and Allow permissions for NT Authority/Network Service on the certificate:
   
   ```powershell
   $targetCertPrivKey = $Cert.PrivateKey
   $privKeyCertFile = Get-Item -path
   "$ENV:ProgramData\Microsoft\Crypto\RSA\MachineKeys\*" | where-object {$_.Name -eq $targetCertPrivKey.CspKeyContainerInfo.UniqueKeyContainerName}
   $privKeyAcl = Get-Acl $privKeyCertFile
   $permission = "NT AUTHORITY\NETWORK SERVICE","Read","Allow"
   $accessRule = new-object System.Security.AccessControl.FileSystemAccessRule $permission
   $privKeyAcl.AddAccessRule($accessRule)
   Set-Acl $privKeyCertFile.FullName $privKeyAcl
   ```

1. Execute the following command to change the node certificate:

   ```powershell
   Set-NetworkControllerNode -Name "<Name of the Network Controller node>" -NodeCertificate $cert
   ```

## Configure automatic rotation for Network Controller certificates

The `Start-SdnCertificateRotation` cmdlet allows you to automate rotation of your Network Controller certificates. Certificate auto-rotation helps minimize any downtime or unplanned outages caused due to certificate expiry issues.

Here are the scenarios where you can use the `Start-SdnCertificateRotation` cmdlet  to auto rotate Network Controller certificates:

- Self-signed certificates. Use the `Start-SdnCertificateRotation` cmdlet to generate self-sgined certificate with the default validity period or a specific validity period.
- Bring your own certificates. Use the `Start-SdnCertificateRotation` cmdlet to install the CA-signed certificates to all the Network Controller nodes and distribute to other devices in the SDN infrastructure.
- Pre-installed certificates. You can have the required certificates installed on Network Controller nodes and use them for rotation.

## Required credentials

The `Start-SdnCertificateRotation` cmdlet requires you to provide credentials for two types of accounts to authorize access. See NC Security for more information.

-`Credential` is used to specify account that have local admin privilege on Network Controller.
-`NcRestCredential` is used to specify account that have access to Network Controller REST API. It is member of ClientSecurityGroup from Get-NetworkController. This account will be used to call REST API to update credential resource with new certificate.

### Generate self-signed certificates

All self-signed certificates on your Network Controller nodes are rotated automatically three years after they are created. Three years is the default validity period of a self-signed certificate, but you can change it if you want. 

Perform these steps on each Network Controller node to generate a self-signed certificate:

1. To generate a self-signed certificate with the default 3 years validity period, run the following commands:

```powershell
Import-Module -Name SdnDiagnostics -Force
Start-SdnCertificateRotation -GenerateCertificate -CertPassword (Get-Credential).Password -Credential (Get-Credential)
```

1. (Optional) To generate a self-signed certificate with a specific validity period, use the `NotAfter` parameter and specify the validity period.

For example, to create a self-signed certificate with a validity period of 5 years, run the following command:

```powershell
Import-Module -Name SdnDiagnostics -Force
Start-SdnCertificateRotation -GenerateCertificate -CertPassword (Get-Credential).Password -NotAfter (Get-Date).AddYears(5) -Credential (Get-Credential)
```

1. Enter the credentials. You get two prompts to provide credentials:
   - In the first prompt, enter the password to protect the generated certificate. The username part can be anything and won't be used.
   - In the second prompt, use a credential that have admin access to all the Network Controller nodes.

1. You receive the following warning after certificates are generated. Press `Y` to continue. You can avoid any prompt for confirmation by specifying `-Force` in `Start-SdnCertificateRotation`:

:::image type="content" source="./media/network-controller-certificates/warning-after-certificates-generate.png" alt-text="Screenshot of the warning that displays after the certificates are generated." lightbox="./media/network-controller-certificates/warning-after-certificates-generate.png" :::

1. Wait until the cmdlet finishes.

### Rotate your own certificates

In addition to auto generating the Network Controller certificates, you can also bring your own certificates from CA and then use those certificates for rotation.

Run these commands to auto-rotate your own certificates:

1. Prepare your certificates in `.pfx` format to a folder on one of the Network Controller nodes from where you'll run the `Start-SdnCertificateRotation` cmdlet.

1. To configure auto-rotation, run the following command: 

```powershell
Import-Module -Name SdnDiagnostics -Force
Start-SdnCertificateRotation -CertPath "<Path where you put your certificates>" -CertPassword (Get-Credential).Password -Credential (Get-Credential)
```

The cmdlet will install the certificates to all Network Controller nodes and seed to other Infrastructure nodes like SDN Mux Servers, SDN hosts. See Manage Certificates for SDN for the certificate requirements.

1. Enter the credentials. You get two prompts to provide credentials:
   - In the first prompt, enter the password to protect the generated certificate. The username part can be anything and won't be used.
   - In the second prompt, use a credential that=have admin access to all Network Controller nodes.

1. You receive the following warning after certificates are generated. Press `Y` to continue. You can avoid any prompt for confirmation by specifying `-Force` in `Start-SdnCertificateRotation`:

:::image type="content" source="./media/network-controller-certificates/warning-after-certificates-generate.png" alt-text="Screenshot of the warning that displays after the certificates are generated." lightbox="./media/network-controller-certificates/warning-after-certificates-generate.png" :::

1. Wait until the cmdlet finishes.

### Rotate the pre-installed certificates

1. Install the Network Controller certificates on all the Network Controller nodes as per your preferred method. Ensure the certificates are trusted by other SDN infrastructure nodes, including SDN Mux Servers and SDN hosts.

1. Create certificate rotation configuration:

   1. Generate the default certificate rotation configuration:
      
      ```powershell
      Import-Module -Name SdnDiagnostics -Force
      $certConfig = New-SdnCertificateRotationConfig
      $certConfig
      ```
    
   1. Review the default certificate rotation configuration to confirm if the auto-detected certificates are the ones you want to use. By default, it retrieves the latest issued certificate to be used.

   :::image type="content" source="./media/network-controller-certificates/screenshot-certconfig-cmdlet.png" alt-text="Screenshot showing the output of the CertConfig cmdlet." lightbox="./media/network-controller-certificates/screenshot-certconfig-cmdlet.png" :::

   where:

   - **ws22nc*x*.corp.contoso.com** is the certificate's thumbprint for each node
   - **ClusterCredentialType** is the Network Controller Cluster authentication type. If this is not X509, the node certificate won't be used and won't be shown in the output
   - **NcRestCert** is the thumbprint of the Network Controller Rest certificate

   1. (Optional) If the generated `$certConfig` isn't correct, you can change it by specifying. For example, to change the thumbprint of the Network Controller Rest certificate, run the following cmdlet:

   ```powershell
   $certConfig.NcRestCert = <new certificate thumbprint>
   ```   

1. Start certificate rotation, enter the credential that have admin access all Network Controller Nodes.

Import-Module -Name SdnDiagnostics -Force
Start-SdnCertificateRotation -CertRotateConfig $certConfig -Credential (Get-Credential)
You will receive below warning after certificates generated. Press Y to continue. You can avoid any prompt for confirmation by specify -Force in Start-SdnCertificateRotation



Wait until the cmdlet finish.

