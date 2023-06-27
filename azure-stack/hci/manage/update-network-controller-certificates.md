---
title: Renew certificates for Network Controller
description: This article describes how to renew Network Controller certificates.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 06/27/2023
---

# Renew certificates for Network Controller

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022 and Windows Server 2019

This article provides instructions on how to renew or change Network Controller certificates, both automatically and manually. If you face any issues in renewing your Network Controller certificates, contact Microsoft Support.

In your Software Defined Networking (SDN) infrastructure, the Network Controller uses certificate-based authentication to secure Northbound communication channels with management clients and Southbound communications with network devices, such as the Software Load Balancer. The Network Controller certificates come with a validity period, after which they become invalid and can no longer be trusted for use. It is highly recommended that you renew them before they expire.

For an overview of Network Controller, see [What is Network Controller?](../concepts/network-controller-overview.md)

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
> Don't let these certificate expire. Renew them before expiry to avoid any authentication issues. Also, don't remove any existing expired certificates before renewing them. To find out the expiration date of a certificate, see [View certificate expiry](#view-certificate-expiry).

## View certificate expiry

Use the following cmdlet on each Network Controller VM to check the expiration date of a certificate:

```powershell
Get-ChildItem Cert:\LocalMachine\My | where{$_.Subject -eq "CN=<Certificate-subject-name>"} | Select-Object NotAfter, Subject
```

- To get the expiry of a REST certificate, replace "Certificate-subject-name" with the RestIPAddress or RestName of the Network Controller. You can get this value from the `Get-NetworkController` cmdlet.

- To get the expiry of a node certificate, replace "Certificate-subject-name" with the fully qualified domain name (FQDN) of the Network Controller VM. You can get this value from the `Get-NetworkController` cmdlet.

## Renew Network Controller certificates

You can renew your Network Controller certificates either automatically or manually.

### [Automatic renewal](#tab/automatic-renewal)

The [`Start-SdnCertificateRotation`](https://github.com/microsoft/SdnDiagnostics/wiki/Start-SdnCertificateRotation) cmdlet enables you to automate renewal of your Network Controller certificates. Certificate automatic renewal helps minimize any downtime or unplanned outages caused due to certificate expiry issues.

Here are the scenarios where you can use the `Start-SdnCertificateRotation` cmdlet  to automatically renew Network Controller certificates:

- [Self-signed certificates](#renew-self-signed-certificates-automatically). Use the `Start-SdnCertificateRotation` cmdlet to generate self-signed certificates and renew those certificates in all the Network Controller nodes.
- [Bring your own certificates](#renew-your-own-certificates-automatically). You bring your own certificates, either self-signed or CA-signed and use the `Start-SdnCertificateRotation` cmdlet for certificate renewal. The cmdlet installs the certificates on all the Network Controller nodes and distributes them to other SDN infrastructure components.
- [Preinstalled certificates](#renew-preinstalled-certificates-automatically). You have the required certificates already installed on the Network Controller nodes. Use the `Start-SdnCertificateRotation` cmdlet to renew those certificates to other SDN infrastructure components.

For more information about how to create and manage SDN certificates, see [Manage certificates for Software Defined Networking](./sdn-manage-certs.md).

### Requirements

Here are the requirements for automatic renewal of certificate:

- You must run the `Start-SdnCertificateRotation` cmdlet on one of the Network Controller nodes. For installation instructions, see [Install SdnDiagnostics module](https://github.com/microsoft/SdnDiagnostics/wiki#installation).

- You must have credentials for the following two types of accounts to authorize communication between Network Controller nodes:

   - `Credential` to specify a user account with local admin privileges on Network Controller.

   - `NcRestCredential` to specify a user account with access to Network Controller REST API. It's a member of `ClientSecurityGroup` from [`Get-NetworkController`](/powershell/module/networkcontroller/get-networkcontroller). This account is used to call REST API to update credential resource with the new certificate.

   For more information about configuring authorization for Network Controller Northbound communication, see [Authorization](./nc-security.md#authorization) for Northbound communication.

### Renew self-signed certificates automatically

You can use the `Start-SdnCertificateRotation` cmdlet to generate new self-signed certificates and automatically renew them to all the Network Controller nodes. By default, the cmdlet generates certificates with a validity period of three years, but you can specify a different validity period.

Perform these steps on one of the Network Controller nodes to generate self-signed certificates and automatically renew them:

1. To generate self-signed certificates, run the `Start-SdnCertificateRotation` cmdlet. You can use the `-Force` parameter with the cmdlet to avoid any prompts for confirmation or manual inputs during the rotation process.

   - To generate self-signed certificates with the default three years validity period, run the following commands:
   
      ```powershell
      Import-Module -Name SdnDiagnostics -Force
      Start-SdnCertificateRotation -GenerateCertificate -CertPassword (Get-Credential).Password -Credential (Get-Credential)
      ```

   - To generate self-signed certificates with a specific validity period, use the `NotAfter` parameter to specify the validity period.

      For example, to generate self-signed certificates with a validity period of five years, run the following commands:

      ```powershell
      Import-Module -Name SdnDiagnostics -Force
      Start-SdnCertificateRotation -GenerateCertificate -CertPassword (Get-Credential).Password -NotAfter (Get-Date).AddYears(5) -Credential (Get-Credential)
      ```

1. Enter the credentials. You get two prompts to provide two types of credentials:

   - In the first prompt, enter the password to protect the generated certificate. The username can be anything and isn't used.
   - In the second prompt, use the credential that has admin access to all the Network Controller nodes.

1. After the new certificates are generated, you get a warning to confirm if you want to continue with the certificate rotation process. The warning text displays the list of Network Controller certificates that will be replaced with the newly generated ones. Type `Y` to confirm.

   Here's a sample screenshot of the warning:

   :::image type="content" source="./media/network-controller-certificates/warning-after-certificates-generate.png" alt-text="Screenshot of the warning that displays after the certificates are generated." lightbox="./media/network-controller-certificates/warning-after-certificates-generate.png" :::

1. After you confirm to continue with the certificate rotation, you can view the status of the ongoing operations in the PowerShell command window.

   > [!Important]
   > Don't close the PowerShell window until the cmdlet finishes. Depending on your environment, such as the number of Network Controller nodes in the cluster, it may take several minutes or more than an hour to finish.

   Here's a sample screenshot of the PowerShell command window showing the status of ongoing operations:
  
   :::image type="content" source="./media/network-controller-certificates/screenshot-powershell-window-status.png" alt-text="Screenshot of the PowerShell command window showing the status of ongoing operations." lightbox="./media/network-controller-certificates/screenshot-powershell-window-status.png" :::

### Renew your own certificates automatically

In addition to generating self-signed Network Controller certificates, you can also bring your own certificates, either self-signed or CA-signed, and use the `Start-SdnCertificateRotation` cmdlet to renew those certificates.

Perform these steps on one of the Network Controller nodes to automatically renew your own certificates:

1. Prepare your certificates in `.pfx` format and save in a folder on one of the Network Controller nodes from where you run the `Start-SdnCertificateRotation` cmdlet. You can use the `-Force` parameter with the cmdlet to avoid any prompts for confirmation or manual inputs during the rotation process.

1. To start certificate renewal, run the following commands:

   ```powershell
   Import-Module -Name SdnDiagnostics -Force
   Start-SdnCertificateRotation -CertPath "<Path where you put your certificates>" -CertPassword (Get-Credential).Password -Credential (Get-Credential)
   ```

1. Enter the credentials. You get two prompts to provide two types of credentials:

   - In the first prompt, enter the password of your certificate. The username can be anything and isn't used.
   - In the second prompt, use the credential that has admin access to all the Network Controller nodes.

1. You get a warning to confirm if you want to continue with the certificate rotation process. The warning text displays the list of Network Controller certificates that will be replaced with the newly generated ones. Type `Y` to confirm.

   Here's a sample screenshot of the warning:

   :::image type="content" source="./media/network-controller-certificates/warning-after-certificates-generate.png" alt-text="Screenshot of the warning that displays after the certificates are generated." lightbox="./media/network-controller-certificates/warning-after-certificates-generate.png" :::

1. After you confirm to continue with the certificate rotation, you can view the status of the ongoing operations in the PowerShell command window.

   > [!Important]
   > Don't close the PowerShell window until the cmdlet finishes. Depending on your environment, such as the number of Network Controller nodes in the cluster, it may take several minutes or more than an hour to finish.

### Renew preinstalled certificates automatically

In this scenario, you have the required certificates installed on the Network Controller nodes. Use the `Start-SdnCertificateRotation` cmdlet to renew those certificates on other SDN infrastructure components.

Perform these steps on one of the Network Controller nodes to automatically renew the preinstalled certificates:

1. Install the Network Controller certificates on all the Network Controller nodes as per your preferred method. Ensure the certificates are trusted by other SDN infrastructure components, including SDN MUX servers and SDN hosts.

1. Create certificate rotation configuration:

   1. To generate the default certificate rotation configuration, run the following commands:
      
      ```powershell
      Import-Module -Name SdnDiagnostics -Force
      $certConfig = New-SdnCertificateRotationConfig
      $certConfig
      ```
    
   1. Review the default certificate rotation configuration to confirm if the auto-detected certificates are the ones that you want to use. By default, it retrieves the latest issued certificate to be used.
   
      Here's a sample certificate rotation configuration:

      ```output
      PS C:\Users\LabAdmin> $certConfig

      Name					Value
      ----					-----
      ws22ncl.corp.contoso.com 	F4AAF14991DAF282D9056E147AE60C2C5FE80A49
      ws22nc3.corp.contoso.com 	BC3E6B090E2AA80220B7BAED7F8F981A1E1DD115
      ClusterCredentialType 		X509
      ws22nc2.corp.contoso.corn 	75DC229A8E61AD855CC445C42482F9F919CC1077
      NcRestCert				029D7CA0067A60FB24827D8434566787114AC30C
      ```

      where:

      - **ws22nc*x*.corp.contoso.com** shows the certificate's thumbprint for each Network Controller node.
      - **ClusterCredentialType** shows the Network Controller Cluster authentication type. If the authentication type isn't X509, the node certificate isn't used and isn't shown in the output.
      - **NcRestCert** shows the thumbprint of the Network Controller Rest certificate.

   1. (Optional) If the generated `$certConfig` isn't correct, you can change it by specifying a new certificate's thumbprint. For example, to change the thumbprint of the Network Controller Rest certificate, run the following command:

      ```powershell
      $certConfig.NcRestCert = <new certificate thumbprint>
      ```

1. Start certificate rotation. You can use the `-Force` parameter with the cmdlet to avoid any prompts for confirmation or manual inputs during the rotation process.

   ```powershell
   Import-Module -Name SdnDiagnostics -Force
   Start-SdnCertificateRotation -CertRotateConfig $certConfig -Credential (Get-Credential)
   ```

1. When prompted for credentials, enter the credential that has admin access all Network Controller Nodes.

1. You get a warning to confirm if you want to continue with auto rotation of certificates. The warning displays the list of Network Controller certificates that will be replaced with your own certificates. Type `Y` to confirm.

   Here's a sample screenshot of the warning that prompts you to confirm the rotation of certificates:

   :::image type="content" source="./media/network-controller-certificates/warning-after-certificates-generate.png" alt-text="Screenshot of the warning that displays after the certificates are generated." lightbox="./media/network-controller-certificates/warning-after-certificates-generate.png" :::

1. After you confirm to continue with the certificate rotation, you can view the status of the ongoing operations in the PowerShell command window.

   > [!Important]
   > Don't close the PowerShell window until the cmdlet finishes. Depending on your environment, such as the number of Network Controller nodes in the cluster, it may take several minutes or more than an hour to finish.

### [Manual renewal](#tab/manual-renewal)

Use the following instructions to manually renew REST certificates and Network Controller node certificates.

> [!IMPORTANT]
> If your Network Controller certificates have already expired, use the instructions in the [automatic renewal](update-network-controller-certificates.md?tabs=automatic-renewal#renew-network-controller-certificates) section to renew the certificates.

## Renew REST certificates

You use the Network Controller's REST certificate for:

- Northbound communication with REST clients
- Encryption of credentials
- Southbound communication to hosts and Software Load Balancer VMs

When you update a REST certificate, you must update the management clients and network devices to use the new certificate.

To renew REST certificate, complete the following steps:

1. Make sure that the certificate on the Network Controller VMs isn't expired before renewing it. See [View certificate expiry](#view-certificate-expiry).
   
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

1. Procure the new certificate and put it in the Personal store of the Local Machine (LocalMachine\My). If it's a self-signed certificate, it must also be placed in the (LocalMachine\Root) store of every Network Controller VM. For information about how to create a new certificate or issue it from a Certification Authority, see [Manage certificates for Software Defined Networking](/windows-server/networking/sdn/security/sdn-manage-certs).

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

---

## Re-import certificates in Windows Admin Center

If you have renewed the Network Controller REST certificate and you are using Windows Admin Center to manage SDN, you must remove the Azure Stack HCI cluster from Windows Admin Center and add it again. By doing this, you ensure that Windows Admin Center imports the renewed certificate and uses it for SDN management.

Follow these steps to re-import the renewed certificate in Windows Admin Center:

1. In Windows Admin Center, select **Cluster Manager** from the top drop-down menu.
1. Select the cluster you want to remove and then select **Remove**.
1. Select **Add**, enter the cluster name, and then select **Add**.
1. Once the cluster is loaded, select **SDN Infrastructure**. This forces Windows Admin Center to automatically re-import the renewed certificate.

## Next steps

- [Update SDN infrastructure for Azure Stack HCI](./update-sdn.md)