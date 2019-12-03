---
title: Azure Stack security controls
titleSuffix: Azure Stack
description: Learn about the security posture and controls applied to Azure Stack.
services: azure-stack
documentationcenter: ''
author: PatAltimore
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 06/10/2019
ms.author: patricka
ms.reviewer: fiseraci
ms.lastreviewed: 06/10/2019

---
# Azure Stack infrastructure security controls

*Applies to: Azure Stack integrated systems*

Security considerations and compliance regulations are among the main drivers for using hybrid clouds. Azure Stack is designed for these scenarios. This article explains the security controls in place for Azure Stack.

Two security posture layers coexist in Azure Stack. The first layer is the Azure Stack infrastructure, which includes the hardware components up to the Azure Resource Manager. The first layer includes the administrator and the tenant portals. The second layer consists of the workloads created, deployed, and managed by tenants. The second layer includes items like virtual machines and App Services web sites.

## Security approach

The security posture for Azure Stack is designed to defend against modern threats and was built to meet the requirements from the major compliance standards. As a result, the security posture of the Azure Stack infrastructure is built on two pillars:

- **Assume Breach**  
    Starting from the assumption that the system has already been breached, focus on *detecting and limiting the impact of breaches* versus only trying to prevent attacks.

- **Hardened by Default**  
    Since the infrastructure runs on well-defined hardware and software, Azure Stack *enables, configures, and validates all the security features* by default.

Because Azure Stack is delivered as an integrated system, the security posture of the Azure Stack infrastructure is defined by Microsoft. Just like in Azure, tenants are responsible for defining the security posture of their tenant workloads. This document provides foundational knowledge on the security posture of the Azure Stack infrastructure.

## Data at rest encryption

All Azure Stack infrastructure and tenant data are encrypted at rest using BitLocker. This encryption protects against physical loss or theft of Azure Stack storage components. For more information, see [data at rest encryption in Azure Stack](azure-stack-security-bitlocker.md).

## Data in transit encryption

The Azure Stack infrastructure components communicate using channels encrypted with TLS 1.2. Encryption certificates are self-managed by the infrastructure.

All external infrastructure endpoints, like the REST endpoints or the Azure Stack portal, support TLS 1.2 for secure communications. Encryption certificates, either from a third party or your enterprise Certificate Authority, must be provided for those endpoints.

While self-signed certificates can be used for these external endpoints, Microsoft strongly advises against using them.

## Secret management

Azure Stack infrastructure uses a multitude of secrets, like passwords, to function. Most of them are automatically rotated frequently because they're group Managed Service Accounts (gMSA), which rotate every 24 hours.

The remaining secrets that aren't gMSA can be rotated manually with a script in the privileged endpoint.

## Code integrity

Azure Stack makes use of the latest Windows Server 2016 security features. One of them is Windows Defender Device Guard, which provides app whitelisting and ensures that only authorized code runs within the Azure Stack infrastructure.

Authorized code is signed by either Microsoft or the OEM partner. The signed authorized code is included in the list of allowed software specified in a policy defined by Microsoft. In other words, only software that has been approved to run in the Azure Stack infrastructure can be executed. Any attempt to execute unauthorized code is blocked and an audit is generated.

The Device Guard policy also prevents third-party agents or software from running in the Azure Stack infrastructure.

## Credential Guard

Another Windows Server 2016 security feature in Azure Stack is Windows Defender Credential Guard, which is used to protect Azure Stack infrastructure credentials from Pass-the-Hash and Pass-the-Ticket attacks.

## Antimalware

Every component in Azure Stack (both Hyper-V hosts and virtual machines) is protected with Windows Defender Antivirus.

In connected scenarios, antivirus definition and engine updates are applied multiple times a day. In disconnected scenarios, antimalware updates are applied as part of monthly Azure Stack updates. For more information, see [update Windows Defender Antivirus on Azure Stack](azure-stack-security-av.md).

## Constrained administration model

Administration in Azure Stack is controlled through three entry points, each with a specific purpose:

- The [administrator portal](azure-stack-manage-portals.md) provides a point-and-click experience for daily management operations.
- Azure Resource Manager exposes all the management operations of the administrator portal via a REST API, used by PowerShell and Azure CLI.
- For specific low-level operations (for example, data center integration or support scenarios), Azure Stack exposes a PowerShell endpoint called [privileged endpoint](azure-stack-privileged-endpoint.md). This endpoint exposes only a whitelisted set of cmdlets and it's heavily audited.

## Network controls

Azure Stack infrastructure comes with multiple layers of network Access Control List (ACL). The ACLs prevent unauthorized access to the infrastructure components and limit infrastructure communications to only the paths that are required for its functioning.

Network ACLs are enforced in three layers:

- Layer 1: Top of Rack switches
- Layer 2: Software Defined Network
- Layer 3: Host and VM operating system firewalls

## Regulatory compliance

Azure Stack has gone through a formal assessment by a third party-independent auditing firm. As a result, documentation on how the Azure Stack infrastructure meets the applicable controls from several major compliance standards is available. The documentation isn't a certification of Azure Stack because the standards include several personnel-related and process-related controls. Rather, customers can use this documentation to jump-start their certification process.

The assessments include the following standards:

- [PCI-DSS](https://www.pcisecuritystandards.org/pci_security/) addresses the payment card industry.
- [CSA Cloud Control Matrix](https://cloudsecurityalliance.org/group/cloud-controls-matrix/#_overview) is a comprehensive mapping across multiple standards, including FedRAMP Moderate, ISO27001, HIPAA, HITRUST, ITAR, NIST SP800-53, and others.
- [FedRAMP High](https://www.fedramp.gov/fedramp-releases-high-baseline/) for government customers.

The compliance documentation can be found on the [Microsoft Service Trust Portal](https://servicetrust.microsoft.com/ViewPage/Blueprint). The compliance guides are a protected resource and require you to sign in with your Azure cloud service credentials.

## Next steps

- [Configure Azure Stack security controls](azure-stack-security-configuration.md)
- [Learn how to rotate your secrets in Azure Stack](azure-stack-rotate-secrets.md)
- [PCI-DSS and the CSA-CCM documents for Azure Stack](https://servicetrust.microsoft.com/ViewPage/TrustDocuments)
- [DoD and NIST documents for Azure Stack](https://servicetrust.microsoft.com/ViewPage/Blueprint)
