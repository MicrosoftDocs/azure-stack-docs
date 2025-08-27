---
title: Azure Local and security standards
description: Learn about Azure Local, security standards, and security assurance.
ms.date: 12/27/2024
ms.topic: article
ms.service: azure-local
ms.author: nguyenhung
author: dv00000
ms.reviewer: alkohli
---

# Azure Local and security standards

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article provides information about security standards related to Azure Local. The resources detailed in this article, including certifications and evaluation reports, could be used as sources to help you in your compliance planning.

Each section in this article provides information on Azure Local and a particular security standard, together with any completed certifications.

## Federal Information Processing Standard (FIPS) 140

The *Federal Information Processing Standard (FIPS) 140* is a U.S. government security standard that specifies minimum-security requirements for cryptographic modules in information technology products and systems. Azure Local is built on Windows Server Datacenter, which has a long history of FIPS 140 validation.

The following table lists the current status of Azure Local FIPS 140 validations. For more information about the related FIPS 140 validation of Windows Server Datacenter's cryptographic modules and algorithms, see [FIPS 140 validation](/windows/security/security-foundations/certification/fips-140-validation).

|Products |Evaluation status |Details |
|---------|---------|---------|
|Azure Local, version 22H2 |**In process** | listed on [NIST Modules in Process](https://csrc.nist.gov/Projects/cryptographic-module-validation-program/modules-in-process/Modules-In-Process-List)|
|Azure Local, version 21H2 |**In process** |Kernel Mode Cryptographic Primitives Library [#4766](https://csrc.nist.gov/projects/cryptographic-module-validation-program/certificate/4766) |

## Common Criteria for Information Technology Security Evaluation (CC)

Microsoft is committed to optimizing the security of its products and services. As part of that commitment, Microsoft supports the *Common Criteria for Information Technology Security Evaluation* program (CC), ensures that products incorporate the features and functions required by relevant Common Criteria *Protection Profiles*, and completes Common Criteria certifications of several operating system products.

The following table lists the current status of Azure Local Common Criteria certifications, together with relevant certification documentation. Learn more about Microsoft's approach to Common Criteria certifications at [Common Criteria certifications](/windows/security/security-foundations/certification/windows-platform-common-criteria).

|Products |Evaluation status |Details |
|---------|---------|---------|
|Azure Local, version 22H2 |**Completed** January 17, 2024 |Includes the Protection Profile for General Purpose Operating Systems, the PP-Module for VPN Client, the PP-Module for Wireless Local Area Network Client, and the PP-Module for Bluetooth. Certification documents: [Security Target](https://download.microsoft.com/download/2/6/c/26c2c205-db9f-474b-9ac7-bd8bf6ae463c/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Security%20Target%20(22H2).pdf), [Administrative Guide](https://download.microsoft.com/download/c/8/3/c83090c7-d299-4d26-a1c3-fb2bf2d77a7b/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Administrative%20Guide%20(22H2).pdf), [Assurance Activity Report](https://download.microsoft.com/download/1/7/f/17fac352-5c93-4e4b-9866-3c0df4080164/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Public%20Assurance%20Activity%20Report%20(22H2).pdf), and [Certification Report](https://download.microsoft.com/download/6/9/1/69101f35-1373-4262-8c5b-75e08bc2e365/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Validation%20Report%20(22H2).pdf) |
|Azure Local, version 21H2 |**Completed** November 21, 2022 |Includes the General Purpose Operating Systems Protection Profile, the Extended Package for WLAN Clients, and the PP Module for VPN Clients. Certification documents: [Security Target](https://download.microsoft.com/download/c/5/9/c59832ff-414b-4f15-8273-d0c349a0b154/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Security%20Target%20(21H2%20et%20al).pdf), [Administrative Guide](https://download.microsoft.com/download/9/1/7/9178ce6a-8117-42e7-be0d-186fc4a89ca6/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Administrative%20Guide%20(21H2%20et%20al).pdf), [Assurance Activity Report](https://download.microsoft.com/download/4/1/6/416151fe-63e7-48c0-a485-1d87148c71fe/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Assurance%20Activity%20Report%20(21H2%20et%20al).pdf), and [Certification Report](https://download.microsoft.com/download/e/3/7/e374af1a-3c5d-42ee-8e19-df47d2c0e3d6/Microsoft%20Windows,%20Windows%20Server,%20Azure%20Stack%20Validation%20Report%20(21H2%20et%20al).pdf) |
|Azure Local, version 21H2 |**Completed** January 12, 2022 | Includes the General Purpose Operating Systems Protection Profile, the Extended Package for WLAN Clients, and the PP Module for VPN Clients. Certification documents: [Security Target](https://download.microsoft.com/download/a/5/6/a5650848-e86a-4554-bb13-1ad6ff2d45d2/Windows%2010%202004%20GP%20OS%20Security%20Target.pdf), [Administrative Guide](https://download.microsoft.com/download/4/a/6/4a66a459-3c73-4c34-84bb-92cb20301206/Windows%2010%202004%20GP%20OS%20Administrative%20Guide.pdf), [Assurance Activity Report](https://download.microsoft.com/download/3/2/4/324562b6-0917-4708-8f9d-8d2d12859839/Windows%2010%202004%20GP%20OS%20Assurance%20Activity%20Report-Public%20.pdf), and [Certification Report](https://download.microsoft.com/download/1/c/b/1cb65e32-f87d-41dd-bc29-88dc943fad9d/Windows%2010%202004%20GP%20OS%20Validation%20Reports.pdf) |

## International Organization for Standardization (ISO/IEC) 27001:2022

ISO/IEC 27001 is a standard that formally specifies an Information Security Management System (ISMS) that is intended to bring information security under explicit management control. This standard provides assurance that an organization manages and safeguards data according to global standards and mitigates the risk of data leaks. Certification to ISO/IEC 27001 helps organizations comply with numerous regulatory and legal requirements that relate to information security.

The following guidance provides more information about how the security capabilities of Azure Local can enable you to maintain compliance with ISO/IEC 27001:2022.

> [!div class="nextstepaction"]
> [Azure Local and ISO/IEC 27001](azure-stack-iso27001-guidance.md)

## Payment Card Industry (PCI) Data Security Standards (DSS)

The *Payment Card Industry (PCI) Data Security Standards (DSS)* is a global information security standard designed to prevent fraud through increased control of credit card data. PCI DSS is required for organizations of any size if they store, process, or transmit cardholder data. These organizations include (but aren't limited to): merchants, payment processors, issuers, acquirers, and service providers.

Azure cloud services not only have PCI DSS validation for Azure Local but also offer an array of features across the hybrid environment to help you reduce the associated effort and costs of getting your own PCI DSS validation. For more information, see the following guidance.

> [!div class="nextstepaction"]
> [Azure Local and PCI DSS](azure-stack-pci-dss-guidance.md)

## Health Insurance Portability and Accountability Act of 1996 (HIPAA)

The *Health Insurance Portability and Accountability Act of 1996 (HIPAA)* is a set of rules and regulations set forth by the U.S. Department of Health and Human Services (HHS) to protect the privacy, security, and integrity of patients' sensitive health information. HIPAA applies to any organization or individual that creates, receives, maintains, or transmits electronic protected health information (PHI), including (but not limited to) doctors' offices, hospitals, health insurers, and other healthcare companies.

Complying with HIPAA is essential but challenging work for healthcare solutions companies. If you choose Azure Local to develop your hybrid IT environment, you can utilize its built-in capabilities and the cloud-integrated services to automate many aspects of achieving and maintaining HIPAA compliance. For more information, see the following guidance.

> [!div class="nextstepaction"]
> [Azure Local and HIPAA](azure-stack-hipaa-guidance.md)

## US Federal Risk and Authorization Management Program (FedRAMP)

FedRAMP offers a standardized process for evaluating, overseeing, and approving cloud computing products and services. It simplifies the adoption of secure cloud solutions for US federal agencies and enables providers like Microsoft to offer their services to these agencies. While obtaining FedRAMP authorization is crucial, it poses a significant challenge for cloud service providers seeking to work with federal agencies. To address this, we offer guidance that clarifies the relevant services and other pertinent information to support your accreditation efforts.

> [!div class="nextstepaction"]
> [Azure Local and FedRAMP](azure-stack-fedramp-guidance.md)
