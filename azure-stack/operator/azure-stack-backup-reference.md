---
title: Infrastructure Backup Service reference | Microsoft Docs
description: Reference material for the Infrastructure Backup Service in Azure Stack.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid: D6EC0224-97EA-446C-BC95-A3D32F668E2C
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 02/12/2019
ms.author: justinha
ms.reviewer: hectorl
ms.lastreviewed: 10/25/2018

---
# Infrastructure Backup Service reference

## Azure backup infrastructure

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

Azure Stack consists of many services that comprise the portal (Azure Resource Manager) and the overall infrastructure management experience. The app-like management experience of Azure Stack focuses on reducing the complexity exposed to the operator of the solution.

Infrastructure Backup Service is designed to internalize the complexity of backing up and restoring data for infrastructure services, ensuring operators can focus on managing the solution and maintaining an SLA to users.

Exporting the backup data to an external share is required to avoid storing backups on the same system. Requiring an external share gives the admin the flexibility to determine where to store the data based on existing company BC/DR policies.

### Infrastructure Backup Service components

Infrastructure Backup Service includes the following components:

 - **Infrastructure Backup Controller**  
 The Infrastructure Backup Controller is instantiated with and resides in every Azure Stack Cloud.
 - **Backup Resource Provider**  
 The Backup Resource Provider (Backup RP) is composed of the user interface and APIs exposing basic backup functionality for Azure Stack infrastructure.

#### Infrastructure Backup Controller

The Infrastructure Backup Controller is a Service Fabric service that gets instantiated for an Azure Stack Cloud. Backup resources are created at a regional level and capture region-specific service data from AD, CA, Azure Resource Manager, CRP, SRP, NRP, Key Vault, RBAC.

### Backup Resource Provider

The Backup Resource Provider presents a user interface in the Azure Stack portal for basic configuration and listing of backup resources. Operators can do the following actions in the user interface:

 - Enable backup for the first time by providing external storage location, credentials, and encryption key.
 - View completed created backup resources and status resources under creation.
 - Modify the storage location where Backup Controller places backup data.
 - Modify the credentials that Backup Controller uses to access external storage location.
 - Modify the encryption key that Backup Controller uses to encrypt backups.


## Backup Controller requirements

This section describes the important requirements for Infrastructure Backup Service. We recommend you review the info carefully before you enable backup for your Azure Stack instance, and then refer back to it as necessary during deployment and subsequent operation.

The requirements include:

  - **Software requirements** - describes supported storage locations and sizing guidance. 
  - **Network requirements** - describes network requirements for different storage locations.  

### Software requirements

#### Supported storage locations

| Storage location                                                                 | Details                                                                                                                                                  |
|----------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| SMB file share hosted on a storage device within the trusted network environment. | SMB share in the same datacenter where Azure Stack is deployed or in a different datacenter. Multiple Azure Stack instances can use the same file share. |
| SMB file share on Azure.                                                          | Not currently supported.                                                                                                                                 |
| Blob storage on Azure.                                                            | Not currently supported.                                                                                                                                 |

#### Supported SMB versions

| SMB | Version |
|-----|---------|
| SMB | 3.x     |

#### SMB encryption

**1907 and beyond**

Infrastructure Backup Service supports transferring backup data to an external storage location with SMB encryption enabled on the server side. If the server doesn't support SMB Encryption or doesn't have the feature enabled, Infrastructure Backup Service will fall back to unencrypted data transfer. Backup data placed on the external storage location is always encrypted at rest and isn't dependent on SMB encryption.

#### Storage location sizing

We recommend you back up at last two times a day and keep at most seven days of backups. This is the default behavior when you enable infrastructure backups on Azure Stack.

**1907 and beyond**

***System connected to Azure AD identity provider***

| Environment Scale | Projected size of backup | Total amount of space required |
|-------------------|--------------------------|--------------------------------|
| 4-16 nodes/ASDK   | 1 GB                     | 20 GB                          |

***System connected to corporate AD identity provider via ADFS***

| Environment Scale | Projected size of backup | Total amount of space required |
|-------------------|--------------------------|--------------------------------|
| 4-16 nodes        | 20 GB                    | 280 GB                        |
| ASDK              | 10 GB                    | 140 GB                        |

**Pre-1907**

| Environment Scale | Projected size of backup | Total amount of space required |
|-------------------|--------------------------|--------------------------------|
| 4-16 nodes        | 20 GB                    | 280 GB                        |
| ASDK              | 10 GB                    | 140 GB                        |

### Network requirements

| Storage location                                                                 | Details                                                                                                                                                                                 |
|----------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| SMB file share hosted on a storage device within the trusted network environment. | Port 445 is required if the Azure Stack instance resides in a firewalled environment. Infrastructure Backup Controller will initiate a connection to the SMB file server over port 445. |
| To use FQDN of file server, the name must be resolvable from the PEP.             |                                                                                                                                                                                         |

> [!Note]  
> No inbound ports need to be opened.

### Encryption Requirements

Starting in 1901, the Infrastructure Backup Service will use a certificate with a public key (.CER) to encrypt backup data and a certificate with the private key (.PFX) to decrypt backup data during cloud recovery.

 - The certificate is used for transport of keys and isn't used to establish secure authenticated communication. For this reason, the certificate can be a self-signed certificate. Azure Stack doesn't need to verify root or trust for this certificate so external internet access isn't required.

The self-signed certificate comes in two parts, one with the public key and one with the private key:

 - Encrypt backup data: Certificate with the public key (exported to .CER file) is used to encrypt backup data.
 - Decrypt backup data: Certificate with the private key (exported to .PFX file) is used to decrypt backup data.

The certificate with the public key (.CER) isn't managed by internal secret rotation. To rotate the certificate, you need to create a new self-signed certificate and update backup settings with the new file (.CER). 
 
 - All existing backups remain encrypted using the previous public key. New backups use the new public key.
 
The certificate used during cloud recovery with the private key (.PFX) is not persisted by Azure Stack for security reasons. This file will need to be provided explicitly during cloud recovery.  

**Backwards compatibility mode**
Starting in 1901, encryption key support is deprecated and will be removed in a future release. If you updated from 1811 with backup already enabled using an encryption key, Azure Stack will continue to use the encryption key. Backwards compatibility mode will be supported for at least three releases. After that time, a certificate will be required.

 * Updating from encryption key to certificate is a one-way operation.  
 * All existing backups will remain encrypted using the encryption key. New backups will use the certificate. 

## Infrastructure Backup Limits

Consider these limits as you plan, deploy, and operate your Microsoft Azure Stack instances. The following table describes these limits.

### Infrastructure Backup limits

| Limit identifier                                                 | Limit        | Comments                                                                                                                                    |
|------------------------------------------------------------------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| Backup type                                                      | Full only    | Infrastructure Backup Controller only supports full backups. Incremental backups aren't supported.                                          |
| Scheduled backups                                                | Scheduled and manual  | Backup controller supports scheduled and on-demand backups.                                                                                 |
| Maximum concurrent backup jobs                                   | 1            | Only one active backup job is supported per instance of Backup Controller.                                                                  |
| Network switch configuration                                     | Not in scope | Admin must back up network switch configuration using OEM tools. Refer to documentation for Azure Stack provided by each OEM vendor. |
| Hardware Lifecycle Host                                          | Not in scope | Admin must back up Hardware Lifecycle Host using OEM tools. Refer to documentation for Azure Stack provided by each OEM vendor.      |
| Maximum number of file shares                                    | 1            | Only one file share can be used to store backup data.                                                                                        |
| Backup App Services, Function, SQL, mysql resource provider data | Not in scope | Refer to guidance published for deploying and managing value-add RPs created by Microsoft.                                                  |
| Backup third-party resource providers                              | Not in scope | Refer to guidance published for deploying and managing value-add RPs created by third-party vendors.                                          |

## Next steps

 - To learn more about the Infrastructure Backup Service, see [Backup and data recovery for Azure Stack with the Infrastructure Backup Service](azure-stack-backup-infrastructure-backup.md).
