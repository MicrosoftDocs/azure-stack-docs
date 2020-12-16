---
title: Infrastructure Backup Service best practices for Azure Stack - MDC | Microsoft Docs
description: Follow these best practices when you deploy and manage Azure Stack for an MDC to help mitigate data loss if there's a catastrophic failure.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: tzl
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/26/2020
ms.author: sethm
ms.reviewer: avishwan
ms.lastreviewed: 10/26/2020

---

# Infrastructure Backup Service best practices - Modular Data Center (MDC)

*Applies to: Modular Data Center, Azure Stack Hub ruggedized*

Review these best practices regularly to verify that your installation is still in compliance when changes are made to the operation flow. If you encounter any issues while implementing these best practices, contact Microsoft Support for help.

## Configuration best practices

Infrastructure backup is enabled by default during deployment of a new system and stored internally. Using the Azure Stack portal or PowerShell, you can provide an external storage location to export the backups to a secondary location.

### Networking

The Universal Naming Convention (UNC) string for the path must use a fully qualified domain name (FQDN). IP address can be used if name resolution isn\'t possible. A UNC string specifies the location of resources such as shared files or devices.

### Encryption

The encryption certificate is used to encrypt backup data that gets exported to external storage. The certificate can be a self-signed certificate since the certificate is only used to transport keys. Refer to New-SelfSignedCertificate for more info on how to create a certificate.

The certificate must be stored in a secure location. The CER format of the certificate is used to encrypt data only and not used to establish communication.

## Operational best practices

### Backups

- Backup jobs execute while the system is running so there\'s no downtime to the management experiences or user apps. Expect the backup jobs to take 20-40 minutes for a solution that\'s under reasonable load.

- Additional instructions provided to manually back up network switches and the hardware lifecycle host (HLH).

### Folder names

- Infrastructure creates MASBACKUP folder automatically. This is a Microsoft-managed share. You can create shares at the same level as MASBACKUP. It\'s not recommended to create folders or storage data inside of MASBACKUP that Azure Stack doesn\'t create.

- User FQDN and region in your folder name to differentiate backup data from different clouds. The FQDN of your Azure Stack deployment and endpoints is the combination of the Region parameter and the External Domain Name parameter. For more info, see [Azure Stack datacenter integration - DNS](../../operator/azure-stack-integrate-dns.md).

For example, the backup share is AzSBackups hosted on fileserver01.contoso.com. In that file share there may be a folder per Azure Stack deployment using the external domain name and a subfolder that uses the region name.

- FQDN: contoso.com
- Region: nyc

```shell
\\fileserver01.contoso.com\AzSBackups
\\fileserver01.contoso.com\AzSBackups\contoso.com
\\fileserver01.contoso.com\AzSBackups\contoso.com\nyc
\\fileserver01.contoso.com\AzSBackups\contoso.com\nyc\MASBackup
```

The `MASBackup` folder is where Azure Stack stores its backup data. Don't use this folder to store your own data. OEMs should also not use this folder to store any backup data.

OEMs are encouraged to store backup data for their components under the region folder. Each network switch, hardware lifecycle host (HLH), and so on, may be stored in its own subfolder. For example:

```shell
\\fileserver01.contoso.com\AzSBackups\contoso.com\nyc\HLH
\\fileserver01.contoso.com\AzSBackups\contoso.com\nyc\Switches
\\fileserver01.contoso.com\AzSBackups\contoso.com\nyc\DeploymentData
\\fileserver01.contoso.com\AzSBackups\contoso.com\nyc\Registration
```

### Monitoring

The following alerts are supported by the system:

| Alert                                                   | Description                                                                                     | Remediation                                                                                                                                |
|---------------------------------------------------------|-------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------|
| Backup failed because the file share is out of capacity. | File share is out of capacity and backup controller can't export backup files to the location. | Add more storage capacity and try back up again. Delete existing backups (starting from oldest first) to free up space.                    |
| Backup failed due to connectivity problems.             | Network between Azure Stack and the file share is experiencing issues.                          | Address the network issue and try backup again.                                                                                            |
| Backup failed due to a fault in the path.                | The file share path can't be resolved.                                                          | Map the share from a different computer to ensure the share is accessible. You may need to update the path if it's no longer valid.       |
| Backup failed due to authentication issue.               | There might be an issue with the credentials or a network issue that impacts authentication.    | Map the share from a different computer to ensure the share is accessible. You may need to update credentials if they're no longer valid. |
| Backup failed due to a general fault.                    | The failed request could be due to an intermittent issue. Try to back up again.                    | Call support.                                                                                                                               |

### Infrastructure Backup Service components

The Infrastructure Backup Service includes the following components:

- **Infrastructure Backup Controller**: The Infrastructure Backup Controller is instantiated with and resides in every Azure Stack cloud.

- **Backup Resource Provider**: The Backup Resource Provider (Backup RP) is composed of the user interface and APIs exposing basic backup functionality for the Azure Stack infrastructure.

### Infrastructure Backup Controller

The Infrastructure Backup Controller is a Service Fabric service that gets instantiated for an Azure Stack Cloud. Backup resources are created at a regional level and capture region-specific service data from AD, CA, Azure Resource Manager, CRP, SRP, NRP, Key Vault, and RBAC.

### Backup Resource Provider

The Backup Resource Provider presents a user interface in the Azure Stack portal for basic configuration and listing of backup resources. Operators can do the following actions in the user interface:

- Enable backup for the first time by providing external storage location, credentials, and encryption key.
- View completed created backup resources and status resources under creation.
- Modify the storage location where Backup Controller places backup data.
- Modify the credentials that Backup Controller uses to access external storage location.
- Modify the encryption certificate that Backup Controller uses to encrypt backups.

## Backup Controller requirements

This section describes important requirements for the Infrastructure Backup Service. We recommend that you review the info carefully before you enable backup for your Azure Stack instance, and then refer back to it as necessary during deployment and subsequent operation.

The requirements include:

- **Software requirements**: Describes supported storage locations and sizing guidance.
- **Network requirements**: Describes network requirements for different storage locations.

### Software requirements

#### Supported storage locations

| Storage location                                                                  | Details                                                                                                                                                  |
|-----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| SMB file share hosted on a storage device within the trusted network environment. | SMB share in the same datacenter where Azure Stack is deployed or in a different datacenter. Multiple Azure Stack instances can use the same file share. |
| SMB file share on Azure.                                                          | Not currently supported.                                                                                                                                 |
| Blob storage on Azure.                                                            | Not currently supported.                                                                                                                                 |

#### Supported SMB versions

|SMB  |Version  |
|---------|---------|
|SMB     |   3.x      |

#### SMB encryption

The Infrastructure Backup Service supports transferring backup data to an external storage location with SMB encryption enabled on the server side. If the server doesn't support SMB Encryption or doesn't have the feature enabled, the Infrastructure Backup Service falls back to unencrypted data transfer. Backup data placed on the external storage location is always encrypted at rest and is not dependent on SMB encryption.

#### Storage location sizing

We recommend you back up at least twice a day, and keep at most seven days of backups. This is the default behavior when you enable infrastructure backups on Azure Stack.


|Environment Scale  |Projected size of backup  |Total amount of space required  |
|---------|---------|---------|
|4-16 nodes     |  20 GB       |  280 GB       |
<!-- TZLASDKFIX 
|ASDK     |   10 GB      |   140 GB     |
-->
### Network requirements

|Storage location  |Details  |
|---------|---------|
|SMB file share hosted on a storage device within the trusted network environment.     |  Port 445 is required if the Azure Stack instance resides in a firewalled environment. Infrastructure Backup Controller will initiate a connection to the SMB file server over port 445.       |
| To use the FQDN of the file server, the name must be resolvable from the PEP.     |         |

> [!NOTE]
> No inbound ports need to be opened.

### Encryption requirements

The Infrastructure Backup Service uses a certificate with a public key (.CER) to encrypt backup data. The certificate is used for transport of keys and is not used to establish secure authenticated communication. For this reason, the certificate can be a self-signed certificate. Azure Stack doesn't need to verify root or trust for this certificate, so external internet access is not required.

The self-signed certificate comes in two parts, one with the public key and one with the private key:

- Encrypt backup data: Certificate with the public key (exported to .CER file) is used to encrypt backup data.
- Decrypt backup data: Certificate with the private key (exported to .PFX file) is used to decrypt backup data.

The certificate with the public key (.CER) is not managed by internal secret rotation. To rotate the certificate, you must create a new self-signed certificate and update backup settings with the new file (.CER).

All existing backups remain encrypted using the previous public key. New backups use the new public key.

For security reasons, the certificate used during cloud recovery with the private key (.PFX) is not persisted by Azure Stack.

## Infrastructure Backup limits

Consider these limits as you plan, deploy, and operate your Microsoft Azure Stack instances. The following table describes these limits.

|Limit identifier  |Limit  |Comments  |
|---------|---------|---------|
|Backup type     | Full only        | Infrastructure Backup Controller only supports full backups. Incremental backups are not supported.        |
|Scheduled backups     | Scheduled and manual        | Backup controller supports scheduled and on-demand backups.        |
|Maximum concurrent backup jobs      | 1        | Only one active backup job is supported per instance of Backup Controller.        |
|Network switch configuration     | Not in scope         | Admin must back up network switch configuration using OEM tools. Refer to documentation for Azure Stack provided by each OEM vendor.        |
|Hardware Lifecycle Host     | Not in scope         | Admin must back up Hardware Lifecycle Host using OEM tools. Refer to documentation for Azure Stack provided by each OEM vendor.        |
|Maximum number of file shares     | 1        | Only one file share can be used to store backup data.        |
|Backup value-add resource providers     | In scope        | Infrastructure backup includes backup for Event Hubs RP, IoT Hub RP, Data Box Edge RP.        |

## Next steps

- Learn more about the [Infrastructure Backup Service](../../operator/azure-stack-backup-reference.md).
