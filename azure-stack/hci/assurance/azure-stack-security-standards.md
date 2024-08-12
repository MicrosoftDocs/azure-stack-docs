---
title: Azure Stack HCI and security standards
description: Learn about Azure Stack HCI, security standards, and security assurance.
ms.date: 2/5/2024
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.author: nguyenhung
author: dv00000
ms.reviewer: alkohli
---

# Azure Stack HCI and security standards

This article provides information about security standards related to Azure Stack HCI. The resources detailed in this article, including certifications and evaluation reports, could be used as sources to help you in your compliance planning.

Azure Stack products, including Azure Stack HCI, Azure Stack Hub, and Azure Stack Edge, have a wide range of security features and services across the hybrid environment that can help meet stringent compliance requirements both in cloud and on premises. Each section in this article provides information on Azure Stack HCI and a particular security standard, together with any completed certifications.

## Federal Information Processing Standard (FIPS) 140

The *Federal Information Processing Standard (FIPS) 140* is a U.S. government security standard that specifies minimum-security requirements for cryptographic modules in information technology products and systems. Azure Stack is built on Windows Server Datacenter, which has a long history of FIPS 140 validation.

The following table lists the current status of Azure Stack FIPS 140 validations. For more information about the related FIPS 140 validation of Windows Server Datacenter's cryptographic modules and algorithms, see [FIPS 140 validation](/windows/security/security-foundations/certification/fips-140-validation).

|Products |Evaluation status |Details |
|---------|---------|---------|
|Azure Stack HCIv2, version 22H2 (Azure Stack HCI, version 22H2. Evaluation also includes Azure Stack Hub and Azure Stack Edge.) |**In process** (listed on [NIST Modules in Process](https://csrc.nist.gov/Projects/cryptographic-module-validation-program/modules-in-process/Modules-In-Process-List)) |Includes the cryptographic modules BitLocker Dump Filter, Boot Manager, Code Integrity, Cryptographic Primitives Library, Kernel Mode Cryptographic Primitives Library, Secure Kernel Code Integrity, and Windows OS Loader. |
|Azure Stack HCIv2, version 21H2 Azure Stack HCIv2, version 22H2 (Azure Stack HCI, version 22H2. Evaluation also includes Azure Stack Hub and Azure Stack Edge.) |**In process** (listed on [NIST Modules in Process](https://csrc.nist.gov/Projects/cryptographic-module-validation-program/modules-in-process/Modules-In-Process-List)) |Includes the cryptographic modules BitLocker Dump Filter, Boot Manager, Code Integrity, Cryptographic Primitives Library, Kernel Mode Cryptographic Primitives Library, Secure Kernel Code Integrity, and Windows OS Loader. |
|Azure Data Box Edge, version 1809 (Azure Stack Edge) |**Complete** |See the linked CMVP cryptographic module certificates for evaluation dates and cryptographic module Security Policy documents: Cryptographic Primitives Library [#3197](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3197), Kernel Mode Cryptographic Primitives Library [#3196](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3196), Code Integrity [#3644](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3644), Windows OS Loader [#3615](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3615), Secure Kernel Code Integrity [#3651](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3651), BitLocker Dump Filter [#3092](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3092), and Boot Manager [#3089](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/3089). |

## Common Criteria for Information Technology Security Evaluation (CC)

Microsoft is committed to optimizing the security of its products and services. As part of that commitment, Microsoft supports the *Common Criteria for Information Technology Security Evaluation* program (CC), ensures that products incorporate the features and functions required by relevant Common Criteria *Protection Profiles*, and completes Common Criteria certifications of several operating system products.

The following table lists the current status of Azure Stack Common Criteria certifications, together with relevant certification documentation. Learn more about Microsoft's approach to Common Criteria certifications at [Common Criteria certifications](/windows/security/security-foundations/certification/windows-platform-common-criteria).

|Products |Evaluation status |Details |
|---------|---------|---------|
|Azure Stack HCIv2, version 22H2 (Azure Stack HCI, version 22H2. Evaluation also includes Azure Stack Hub and Azure Stack Edge.) |**Completed** January 17, 2024 |Includes the Protection Profile for General Purpose Operating Systems, the PP-Module for VPN Client, the PP-Module for Wireless Local Area Network Client, and the PP-Module for Bluetooth. Certification documents: [Security Target](https://download.microsoft.com/download/2/6/c/26c2c205-db9f-474b-9ac7-bd8bf6ae463c/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Security%20Target%20(22H2).pdf), [Administrative Guide](https://download.microsoft.com/download/c/8/3/c83090c7-d299-4d26-a1c3-fb2bf2d77a7b/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Administrative%20Guide%20(22H2).pdf), [Assurance Activity Report](https://download.microsoft.com/download/1/7/f/17fac352-5c93-4e4b-9866-3c0df4080164/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Public%20Assurance%20Activity%20Report%20(22H2).pdf), and [Certification Report](https://download.microsoft.com/download/6/9/1/69101f35-1373-4262-8c5b-75e08bc2e365/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Validation%20Report%20(22H2).pdf) |
|Azure Stack HCIv2, version 21H2 (Azure Stack HCI, version 22H2. Evaluation also includes Azure Stack Hub and Azure Stack Edge.) |**Completed** November 21, 2022 |Includes the General Purpose Operating Systems Protection Profile, the Extended Package for WLAN Clients, and the PP Module for VPN Clients. Certification documents: [Security Target](https://download.microsoft.com/download/c/5/9/c59832ff-414b-4f15-8273-d0c349a0b154/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Security%20Target%20(21H2%20et%20al).pdf), [Administrative Guide](https://download.microsoft.com/download/9/1/7/9178ce6a-8117-42e7-be0d-186fc4a89ca6/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Administrative%20Guide%20(21H2%20et%20al).pdf), [Assurance Activity Report](https://download.microsoft.com/download/4/1/6/416151fe-63e7-48c0-a485-1d87148c71fe/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Assurance%20Activity%20Report%20(21H2%20et%20al).pdf), and [Certification Report](https://download.microsoft.com/download/e/3/7/e374af1a-3c5d-42ee-8e19-df47d2c0e3d6/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Validation%20Report%20(21H2%20et%20al).pdf) |
|Azure Stack |**Completed** January 12, 2022 | Includes the General Purpose Operating Systems Protection Profile, the Extended Package for WLAN Clients, and the PP Module for VPN Clients. Certification documents: [Security Target](https://download.microsoft.com/download/a/5/6/a5650848-e86a-4554-bb13-1ad6ff2d45d2/Windows%2010%202004%20GP%20OS%20Security%20Target.pdf), [Administrative Guide](https://download.microsoft.com/download/4/a/6/4a66a459-3c73-4c34-84bb-92cb20301206/Windows%2010%202004%20GP%20OS%20Administrative%20Guide.pdf), [Assurance Activity Report](https://download.microsoft.com/download/3/2/4/324562b6-0917-4708-8f9d-8d2d12859839/Windows%2010%202004%20GP%20OS%20Assurance%20Activity%20Report-Public%20.pdf), and [Certification Report](https://download.microsoft.com/download/1/c/b/1cb65e32-f87d-41dd-bc29-88dc943fad9d/Windows%2010%202004%20GP%20OS%20Validation%20Reports.pdf) |

## International Organization for Standardization (ISO/IEC) 27001:2022

ISO/IEC 27001 is a standard that formally specifies an Information Security Management System (ISMS) that is intended to bring information security under explicit management control. This standard provides assurance that an organization manages and safeguards data according to global standards and mitigates the risk of data leaks. Certification to ISO/IEC 27001 helps organizations comply with numerous regulatory and legal requirements that relate to information security.

The following guidance provides more information about how the security capabilities of Azure Stack HCI can enable you to maintain compliance with ISO/IEC 27001:2022.

> [!div class="nextstepaction"]
> [Azure Stack HCI and ISO/IEC 27001](azure-stack-iso27001-guidance.md)

## Payment Card Industry (PCI) Data Security Standards (DSS)

The *Payment Card Industry (PCI) Data Security Standards (DSS)* is a global information security standard designed to prevent fraud through increased control of credit card data. PCI DSS is required for organizations of any size if they store, process, or transmit cardholder data. These organizations include (but aren't limited to): merchants, payment processors, issuers, acquirers, and service providers.

Azure cloud services not only have PCI DSS validation for Azure Stack HCI but also offer an array of features across the hybrid environment to help you reduce the associated effort and costs of getting your own PCI DSS validation. For more information, see the following guidance.

> [!div class="nextstepaction"]
> [Azure Stack HCI and PCI DSS](azure-stack-pci-dss-guidance.md)

## Health Insurance Portability and Accountability Act of 1996 (HIPAA)

The *Health Insurance Portability and Accountability Act of 1996 (HIPAA)* is a set of rules and regulations set forth by the U.S. Department of Health and Human Services (HHS) to protect the privacy, security, and integrity of patients' sensitive health information. HIPAA applies to any organization or individual that creates, receives, maintains, or transmits electronic protected health information (PHI), including (but not limited to) doctors' offices, hospitals, health insurers, and other healthcare companies.

Complying with HIPAA is essential but challenging work for healthcare solutions companies. If you choose Azure Stack HCI to develop your hybrid IT environment, you can utilize its built-in capabilities and the cloud-integrated services to automate many aspects of achieving and maintaining HIPAA compliance. For more information, see the following guidance.

> [!div class="nextstepaction"]
> [Azure Stack HCI and HIPAA](azure-stack-hipaa-guidance.md)
