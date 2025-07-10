---
title: Prepare for an extension host in Azure Stack Hub 
description: Learn how to prepare for an extension host in Azure Stack Hub, which is automatically enabled through an Azure Stack Hub update package after version 1808.
author: sethmanheim
ms.author: sethm
ms.date: 1/17/2025
ms.topic: how-to
ms.reviewer: thoroet
ms.lastreviewed: 03/07/2019

# Intent: As an Azure Stack operator, I want to prepare my Azure Stack for extension host, which comes in an update package after version 1808.
# Keyword: azure stack extension host

---

# Prepare for extension host in Azure Stack Hub

The extension host secures Azure Stack Hub by reducing the number of required TCP/IP ports. This article describes how to prepare Azure Stack Hub for the extension host that's automatically enabled through an Azure Stack Hub update package after the 1808 update. This article applies to Azure Stack Hub updates 1808, 1809, and 1811.

## Certificate requirements

The extension host implements two new domain namespaces to guarantee unique host entries for each portal extension. The new domain namespaces require two additional wildcard certificates to ensure secure communication.

The table shows the new namespaces and the associated certificates:

| Deployment Folder | Required certificate subject and subject alternative names (SAN) | Scope (per region) | Subdomain namespace |
|-----------------------|------------------------------------------------------------------|-----------------------|------------------------------|
| Admin extension host | *.adminhosting.\<region>.\<fqdn> (Wildcard SSL Certificates) | Admin extension host | adminhosting.\<region>.\<fqdn> |
| Public extension host | *.hosting.\<region>.\<fqdn> (Wildcard SSL Certificates) | Public extension host | hosting.\<region>.\<fqdn> |

For detailed certificate requirements, see [Azure Stack Hub public key infrastructure certificate requirements](azure-stack-pki-certs.md).

## Create certificate signing request

The Azure Stack Hub Readiness Checker tool lets you create a certificate signing request for the two new and required SSL certificates. Follow the steps in the article [Azure Stack Hub certificates signing request generation](azure-stack-get-pki-certs.md).

> [!NOTE]  
> You can skip this step, depending on how you requested your SSL certificates.

## Validate new certificates

1. Open PowerShell with elevated permission on the hardware lifecycle host or the Azure Stack Hub management workstation.
1. Run the following cmdlet to install the Azure Stack Hub Readiness Checker tool:

   ```powershell  
   Install-Module -Name Microsoft.AzureStack.ReadinessChecker
   ```

1. Run the following script to create the required folder structure:

   ```powershell  
   New-Item C:\Certificates -ItemType Directory

   $directories = 'ACSBlob','ACSQueue','ACSTable','Admin Portal','ARM Admin','ARM Public','KeyVault','KeyVaultInternal','Public Portal', 'Admin extension host', 'Public extension host'

   $destination = 'c:\certificates'

   $directories | % { New-Item -Path (Join-Path $destination $PSITEM) -ItemType Directory -Force}
   ```

   > [!NOTE]  
   > If you deploy with Microsoft Entra ID Federated Services (AD FS), the following directories must be added to **$directories** in the script: `ADFS`, `Graph`.

1. Place the existing certificates, which you're currently using in Azure Stack Hub, in appropriate directories. For example, put the **Admin ARM** certificate in the `Arm Admin` folder. And then put the newly created hosting certificates in the `Admin extension host` and `Public extension host` directories.
1. Run the following cmdlet to start the certificate check:

   ```powershell  
   $pfxPassword = Read-Host -Prompt "Enter PFX Password" -AsSecureString 

   Start-AzsReadinessChecker -CertificatePath c:\certificates -pfxPassword $pfxPassword -RegionName east -FQDN azurestack.contoso.com -IdentitySystem AAD
   ```

1. Check the output to see if all certificates pass all tests.

## Import extension host certificates

Use a computer that can connect to the Azure Stack Hub privileged endpoint for the next steps. Make sure you have access to the new certificate files from that computer.

1. Use a computer that can connect to the Azure Stack Hub privileged endpoint for the next steps. Make sure you access to the new certificate files from that computer.
1. Open PowerShell ISE to execute the next script blocks.
1. Import the certificate for the admin hosting endpoint.

   ```powershell  

   $CertPassword = read-host -AsSecureString -prompt "Certificate Password"

   $CloudAdminCred = Get-Credential -UserName <Privileged endpoint credentials> -Message "Enter the cloud domain credentials to access the privileged endpoint."

   [Byte[]]$AdminHostingCertContent = [Byte[]](Get-Content c:\certificate\myadminhostingcertificate.pfx -Encoding Byte)

   Invoke-Command -ComputerName <PrivilegedEndpoint computer name> `
   -Credential $CloudAdminCred `
   -ConfigurationName "PrivilegedEndpoint" `
   -ArgumentList @($AdminHostingCertContent, $CertPassword) `
   -ScriptBlock {
           param($AdminHostingCertContent, $CertPassword)
           Import-AdminHostingServiceCert $AdminHostingCertContent $certPassword
   }
   ```

1. Import the certificate for the hosting endpoint:

   ```powershell  
   $CertPassword = read-host -AsSecureString -prompt "Certificate Password"

   $CloudAdminCred = Get-Credential -UserName <Privileged endpoint credentials> -Message "Enter the cloud domain credentials to access the privileged endpoint."

   [Byte[]]$HostingCertContent = [Byte[]](Get-Content c:\certificate\myhostingcertificate.pfx  -Encoding Byte)

   Invoke-Command -ComputerName <PrivilegedEndpoint computer name> `
   -Credential $CloudAdminCred `
   -ConfigurationName "PrivilegedEndpoint" `
   -ArgumentList @($HostingCertContent, $CertPassword) `
   -ScriptBlock {
           param($HostingCertContent, $CertPassword)
           Import-UserHostingServiceCert $HostingCertContent $certPassword
   }
   ```

### Update DNS configuration

> [!NOTE]  
> This step isn't required if you used DNS Zone delegation for DNS Integration.

If individual host A records have been configured to publish Azure Stack Hub endpoints, you need to create two additional host A records:

| IP | Hostname | Type |
|----|------------------------------|------|
| \<IP> | *.Adminhosting.\<Region>.\<FQDN> | A |
| \<IP> | *.Hosting.\<Region>.\<FQDN> | A |

Allocated IPs can be retrieved using the privileged endpoint by running the cmdlet **Get-AzureStackStampInformation**.

### Ports and protocols

The article [Azure Stack Hub datacenter integration - Publish endpoints](azure-stack-integrate-endpoints.md) covers the ports and protocols that require inbound communication to publish Azure Stack Hub before the extension host rollout.

### Publish new endpoints

There are two new endpoints required to be published through your firewall. The allocated IPs from the public VIP pool can be retrieved using the following code that must be run from your Azure Stack Hub [environment's privileged endpoint](azure-stack-privileged-endpoint.md).

```powershell
# Create a PEP Session
winrm s winrm/config/client '@{TrustedHosts= "<IpOfERCSMachine>"}'
$PEPCreds = Get-Credential
$PEPSession = New-PSSession -ComputerName <IpOfERCSMachine> -Credential $PEPCreds -ConfigurationName "PrivilegedEndpoint" -SessionOption (New-PSSessionOption -Culture en-US -UICulture en-US)

# Obtain DNS Servers and extension host information from Azure Stack Hub Stamp Information and find the IPs for the Host Extension Endpoints
$StampInformation = Invoke-Command $PEPSession {Get-AzureStackStampInformation} | Select-Object -Property ExternalDNSIPAddress01, ExternalDNSIPAddress02, @{n="TenantHosting";e={($_.TenantExternalEndpoints.TenantHosting) -replace "https://*.","testdnsentry"-replace "/"}},  @{n="AdminHosting";e={($_.AdminExternalEndpoints.AdminHosting)-replace "https://*.","testdnsentry"-replace "/"}},@{n="TenantHostingDNS";e={($_.TenantExternalEndpoints.TenantHosting) -replace "https://",""-replace "/"}},  @{n="AdminHostingDNS";e={($_.AdminExternalEndpoints.AdminHosting)-replace "https://",""-replace "/"}}
If (Resolve-DnsName -Server $StampInformation.ExternalDNSIPAddress01 -Name $StampInformation.TenantHosting -ErrorAction SilentlyContinue) {
    Write-Host "Can access AZS DNS" -ForegroundColor Green
    $AdminIP = (Resolve-DnsName -Server $StampInformation.ExternalDNSIPAddress02 -Name $StampInformation.AdminHosting).IPAddress
    Write-Host "The IP for the Admin Extension Host is: $($StampInformation.AdminHostingDNS) - is: $($AdminIP)" -ForegroundColor Yellow
    Write-Host "The Record to be added in the DNS zone: Type A, Name: $($StampInformation.AdminHostingDNS), Value: $($AdminIP)" -ForegroundColor Green
    $TenantIP = (Resolve-DnsName -Server $StampInformation.ExternalDNSIPAddress01 -Name $StampInformation.TenantHosting).IPAddress
    Write-Host "The IP address for the Tenant Extension Host is $($StampInformation.TenantHostingDNS) - is: $($TenantIP)" -ForegroundColor Yellow
    Write-Host "The Record to be added in the DNS zone: Type A, Name: $($StampInformation.TenantHostingDNS), Value: $($TenantIP)" -ForegroundColor Green
}
Else {
    Write-Host "Cannot access AZS DNS" -ForegroundColor Yellow
    $AdminIP = (Resolve-DnsName -Name $StampInformation.AdminHosting).IPAddress
    Write-Host "The IP for the Admin Extension Host is: $($StampInformation.AdminHostingDNS) - is: $($AdminIP)" -ForegroundColor Yellow
    Write-Host "The Record to be added in the DNS zone: Type A, Name: $($StampInformation.AdminHostingDNS), Value: $($AdminIP)" -ForegroundColor Green
    $TenantIP = (Resolve-DnsName -Name $StampInformation.TenantHosting).IPAddress
    Write-Host "The IP address for the Tenant Extension Host is $($StampInformation.TenantHostingDNS) - is: $($TenantIP)" -ForegroundColor Yellow
    Write-Host "The Record to be added in the DNS zone: Type A, Name: $($StampInformation.TenantHostingDNS), Value: $($TenantIP)" -ForegroundColor Green
}
Remove-PSSession -Session $PEPSession
```

#### Sample output

```output
Can access AZS DNS
The IP for the Admin Extension Host is: *.adminhosting.\<region>.\<fqdn> - is: xxx.xxx.xxx.xxx
The Record to be added in the DNS zone: Type A, Name: *.adminhosting.\<region>.\<fqdn>, Value: xxx.xxx.xxx.xxx
The IP address for the Tenant Extension Host is *.hosting.\<region>.\<fqdn> - is: xxx.xxx.xxx.xxx
The Record to be added in the DNS zone: Type A, Name: *.hosting.\<region>.\<fqdn>, Value: xxx.xxx.xxx.xxx
```

> [!NOTE]  
> Make this change before you enable the extension host. This allows the Azure Stack Hub portals to be continuously accessible.

| Endpoint (VIP) | Protocol | Ports |
|----------------|----------|-------|
| Admin Hosting | HTTPS | 443 |
| Hosting | HTTPS | 443 |

### Update existing publishing Rules (Post enablement of extension host)

> [!NOTE]  
> The 1808 Azure Stack Hub Update Package does not enable extension host yet. It lets you prepare for extension host by importing the required certificates. Don't close any ports before the extension host is automatically enabled through an Azure Stack Hub update package after the 1808 update.

The following existing endpoint ports must be closed in your existing firewall rules.

> [!NOTE]  
> It's recommended that you close those ports after successful validation.

| Endpoint (VIP) | Protocol | Ports |
|----------------------------------------|----------|-------------------------------------------------------------------------------------------------------------------------------------|
| Portal (administrator) | HTTPS | 12495<br>12499<br>12646<br>12647<br>12648<br>12649<br>12650<br>13001<br>13003<br>13010<br>13011<br>13012<br>13020<br>13021<br>13026<br>30015 |
| Portal (user) | HTTPS | 12495<br>12649<br>13001<br>13010<br>13011<br>13012<br>13020<br>13021<br>30015<br>13003 |
| Azure Resource Manager (administrator) | HTTPS | 30024 |
| Azure Resource Manager (user) | HTTPS | 30024 |

## Next steps

- Learn about [Firewall integration](azure-stack-firewall.md).
- Learn about [Azure Stack Hub certificates signing request generation](azure-stack-get-pki-certs.md).
