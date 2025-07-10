---
title: Azure Stack Hub security controls
titleSuffix: Azure Stack Hub
description: Learn about the security posture and controls applied to Azure Stack Hub.
author: sethmanheim

ms.topic: how-to
ms.date: 04/25/2024
ms.author: sethm
ms.reviewer: fiseraci
ms.lastreviewed: 04/01/2021

# Intent: As an Azure Stack operator, I want to learn about the security controls applied in Azure Stack.
# Keyword: security controls azure stack

---

# Azure Stack Hub infrastructure security controls

Security considerations and compliance regulations are among the main drivers for using hybrid clouds. Azure Stack Hub is designed for these scenarios. This article explains the security controls in place for Azure Stack Hub.

Two security posture layers coexist in Azure Stack Hub. The first layer is the Azure Stack Hub infrastructure, which includes the hardware components up to the Azure Resource Manager. The first layer includes the administrator and the user portals. The second layer consists of the workloads created, deployed, and managed by tenants. The second layer includes items like virtual machines and App Services web sites.

## Security approach

The security posture for Azure Stack Hub is designed to defend against modern threats and was built to meet the requirements from the major compliance standards. As a result, the security posture of the Azure Stack Hub infrastructure is built on two pillars:

- **Assume Breach**  
    Starting from the assumption that the system has already been breached, focus on *detecting and limiting the impact of breaches* versus only trying to prevent attacks.

- **Hardened by Default**  
    Since the infrastructure runs on well-defined hardware and software, Azure Stack Hub *enables, configures, and validates all the security features* by default.

Because Azure Stack Hub is delivered as an integrated system, the security posture of the Azure Stack Hub infrastructure is defined by Microsoft. Just like in Azure, tenants are responsible for defining the security posture of their tenant workloads. This document provides foundational knowledge on the security posture of the Azure Stack Hub infrastructure.

## Data at rest encryption

All Azure Stack Hub infrastructure and tenant data are encrypted at rest using BitLocker. This encryption protects against physical loss or theft of Azure Stack Hub storage components. For more information, see [data at rest encryption in Azure Stack Hub](azure-stack-security-bitlocker.md).

## Data in transit encryption

The Azure Stack Hub infrastructure components communicate using channels encrypted with TLS 1.2. Encryption certificates are self-managed by the infrastructure.

All external infrastructure endpoints, like the REST endpoints or the Azure Stack Hub portal, support TLS 1.2 for secure communications. Encryption certificates, either from a third party or your enterprise Certificate Authority, must be provided for those endpoints.

While self-signed certificates can be used for these external endpoints, Microsoft strongly advises against using them.
For more information on how to enforce TLS 1.2 on the external endpoints of Azure Stack Hub, see [Configure Azure Stack Hub security controls](azure-stack-security-configuration.md).

## Secret management

Azure Stack Hub infrastructure uses a multitude of secrets, like passwords and certificates, to function. Most of the passwords associated with the internal service accounts are automatically rotated every 24 hours because they're [group Managed Service Accounts (gMSA)](/windows-server/security/group-managed-service-accounts/group-managed-service-accounts-overview), a type of domain account managed directly by the internal domain controller.

Azure Stack Hub infrastructure uses 4096-bit RSA keys for all its internal certificates. Same key-length certificates can also be used for the external endpoints. For more information on secrets and certificate rotation, please refer to [Rotate secrets in Azure Stack Hub](azure-stack-rotate-secrets.md).

## Windows Defender Application Control

Azure Stack Hub makes use of the latest Windows Server security features. One of them is Windows Defender Application Control (WDAC, formerly known as Code Integrity), which provides executables filtering and ensures that only authorized code runs within the Azure Stack Hub infrastructure.

Authorized code is signed by either Microsoft or the OEM partner. The signed authorized code is included in the list of allowed software specified in a policy defined by Microsoft. In other words, only software that has been approved to run in the Azure Stack Hub infrastructure can be executed. Any attempt to execute unauthorized code is blocked and an alert is generated. Azure Stack Hub enforces both User Mode Code Integrity (UMCI) and Hypervisor Code Integrity (HVCI).

The WDAC policy also prevents third-party agents or software from running in the Azure Stack Hub infrastructure.
For more information on WDAC, please refer to [Windows Defender Application Control and virtualization-based protection of code integrity](/windows/security/application-security/application-control/introduction-to-virtualization-based-security-and-appcontrol).

## Antimalware

Every component in Azure Stack Hub (both Hyper-V hosts and virtual machines) is protected with Windows Defender Antivirus.

In connected scenarios, antivirus definition and engine updates are applied multiple times a day. 
In disconnected scenarios, antimalware updates are applied as part of monthly Azure Stack Hub updates. In case a more frequent update to the Windows Defender's definitions is required in disconnected scenarios, Azure Stack Hub also support importing  Windows Defender updates. For more information, see [update Windows Defender Antivirus on Azure Stack Hub](azure-stack-security-av.md).

## Secure Boot

Azure Stack Hub enforces Secure Boot on all the Hyper-V hosts and infrastructure virtual machines. 

## Constrained administration model

Administration in Azure Stack Hub is controlled through three entry points, each with a specific purpose:

- The [administrator portal](azure-stack-manage-portals.md) provides a point-and-click experience for daily management operations.
- Azure Resource Manager exposes all the management operations of the administrator portal via a REST API, used by PowerShell and Azure CLI.
- For specific low-level operations (for example, datacenter integration or support scenarios), Azure Stack Hub exposes a PowerShell endpoint called [privileged endpoint](azure-stack-privileged-endpoint.md). This endpoint exposes only an allowed set of cmdlets and it's heavily audited.

## Network controls

Azure Stack Hub infrastructure comes with multiple layers of network Access Control List (ACL). The ACLs prevent unauthorized access to the infrastructure components and limit infrastructure communications to only the paths that are required for its functioning.

Network ACLs are enforced in three layers:

- Layer 1: Top of Rack switches
- Layer 2: Software Defined Network
- Layer 3: Host and VM operating system firewalls

## Regulatory compliance

Azure Stack Hub has gone through a formal capability assessment by a third party-independent auditing firm. As a result, documentation on how the Azure Stack Hub infrastructure meets the applicable controls from several major compliance standards is available. The documentation isn't a certification of Azure Stack Hub because the standards include several personnel-related and process-related controls. Rather, customers can use this documentation to jump-start their certification process.

The assessments include the following standards:

- [PCI-DSS](https://www.pcisecuritystandards.org/pci_security/) addresses the payment card industry.
- [CSA Cloud Control Matrix](https://cloudsecurityalliance.org/group/cloud-controls-matrix/#_overview) is a comprehensive mapping across multiple standards, including FedRAMP Moderate, ISO27001, HIPAA, HITRUST, ITAR, NIST SP800-53, and others.
- [FedRAMP High](https://www.fedramp.gov/understanding-baselines-and-impact-levels/) for government customers.

The compliance documentation can be found on the [Microsoft Service Trust Portal](https://aka.ms/azurestackcompliance). The compliance guides are a protected resource and require you to sign in with your Azure cloud service credentials.

::: moniker range=">=azs-2206"
### EU Schrems II initiative for Azure Stack Hub

Microsoft has announced its intention to surpass existing data storage commitments by enabling EU-based customers to process and store all their data in the EU; you will no longer have to store data outside the EU. This enhanced commitment includes Azure Stack Hub customers. See [Answering Europe's Call: Storing and Processing EU Data in the EU](https://blogs.microsoft.com/eupolicy/2021/05/06/eu-data-boundary/) for more information.

Starting with version 2206, you can select your geographical preference for data processing on existing Azure Stack Hub deployments. After downloading the hotfix, you will receive the following alert.

:::image type="content" source="media/azure-stack-security-foundations/geo-region-alert.png" alt-text="Screenshot that shows Azure Stack Hub Admin portal Dashboard Alerts window with the Geographical Region Not Provided alert listed." lightbox="media/azure-stack-security-foundations/geo-region-alert.png":::

> [!NOTE]  
> Disconnected environments may also be required to select a data geolocation. This is a one-time setup that impacts the data residency location if the operator is providing diagnostic data to Microsoft. If the operator does not provide any diagnostic data to Microsoft this setting does not have any ramifications.

You can resolve this alert for your existing Azure Stack Hub deployment in one of two ways, depending on your geographical preference for storing and processing your data.

- If you opt to have your data stored and processed **within the EU**, run the following PowerShell cmdlet to set geographical preference. The residency location for the data will be updated and all data will be stored and processed in the EU.

  ```powershell
  Set-DataResidencyLocation -Europe
  ```

- If you opt to have your data stored and processed outside the EU, run the following PowerShell cmdlet to set geographical preference. The residency location for the data will be updated and all data will be processed outside the EU.

  ```powershell
  Set-DataResidencyLocation -Europe:$false
  ```

After you resolve this alert, you can verify your geographical region preference in the Admin portal Properties window.

:::image type="content" source="media/azure-stack-security-foundations/data-geolocation-set.png" alt-text="Screenshot that shows Azure Stack Hub Admin portal Properties window with the Data Geolocation property now set to Europe." lightbox="media/azure-stack-security-foundations/data-geolocation-set.png":::

New Azure Stack hub deployments can set geographical region during set up and deployment. 
::: moniker-end

## Next steps

- [Configure Azure Stack Hub security controls](azure-stack-security-configuration.md)
- [Learn how to rotate your secrets in Azure Stack Hub](azure-stack-rotate-secrets.md)
- [PCI-DSS and the CSA-CCM documents for Azure Stack Hub](https://aka.ms/azurestackcompliance)
