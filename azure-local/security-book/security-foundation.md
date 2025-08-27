---
title: Security foundation for the Azure Local security book
description: Learn about the ecurity foundation for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 08/11/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Security foundation in Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

Azure Local is built on a strong security foundation, including the Microsoft Security Development Lifecycle (SDL), certifications, and a secure supply chain.

## Security assurance

Microsoft is committed to continuously investing in improving our software development process, building highly secure-by-design software, and addressing security compliance requirements. We build in security from the ground up for powerful defense in today’s threat environment. Every component of Azure Local, from machine core to cloud, is purposefully designed to help ensure ultimate security. 
 
### Microsoft Security Development Lifecycle (SDL)

The Microsoft Security Development Lifecycle (SDL) introduces security best practices, tools, and processes throughout all phases of engineering and development. A range of tools and techniques - such as threat modeling, static analysis, fuzzing, and code quality checks—enable continued security value to be embedded into Windows by every engineer on the team from day one. Through the SDL practices, Microsoft engineers are continuously provided with actionable and up-to-date methods to improve development workflows and overall product security before the code has been released. Additionally, Microsoft Offensive Research and Security Engineering (MORSE) performs targeted design reviews, audits, and deep penetration testing of select Windows features. Microsoft’s open source OneFuzz platform allows developers to fuzz features for Windows at scale as part of their development and testing cycle. 
 
### Security assessment activities

As part of our SDL, products like Azure Local are reviewed by our  MORSE Edge team. MORSE works with other Microsoft security teams to perform comprehensive security assessments of the product. The goal of the security assessment activities is to:

- Ensure security promises the product makes are valid and effective.
- Identify insecure configurations, vulnerabilities, and design flaws in the Azure Local platform and its dependencies and ensure they are corrected before shipping. 
- Review the product against Microsoft’s SDL security requirements. 
- Ensure the product meets Microsoft’s standard of shipping a secure solution from inception. 
- Ensure that the product can also be managed to maintain and enhance security during the product's lifecycle. 
 
Comprehensive product security assessments will be done as new features are included and as the product continues through its lifecycle. The consistency in a comprehensive approach to securing edge products, staying current with best practices, customer needs, and regulatory and compliance requirements is the strongest indicator of the commitment Microsoft has made to developing a security-first product in Azure Local. 

## Certifications

Microsoft is committed to supporting product security standards and certifications, including FIPS 140 and Common Criteria as an external validation of security assurance. The Federal Information Processing Standard (FIPS) Publication 140 is a U.S. government standard that defines minimum security requirements for cryptographic modules in IT products. Microsoft maintains an active commitment to meeting the requirements of the FIPS 140 standard, having validated cryptographic modules in Windows operating systems against FIPS 140-2 since it was first established in 2001.
 
Common Criteria (CC) is an international standard currently maintained by national governments who participate in the Common Criteria Recognition Arrangement. CC defines a common taxonomy for security functional requirements, security assurance requirements, and an evaluation methodology used to ensure products undergoing evaluation satisfy the functional and assurance requirements. Microsoft ensures that products incorporate the features and functions required by relevant Common Criteria Protection Profiles and completes Common Criteria certifications of Microsoft Windows products.
 
Microsoft publishes the list of FIPS 140 and CC certified products at [Federal Information Processing Standard (FIPS) 140 Validation and Common Criteria Certifications](/windows/security/security-foundations/certification/fips-140-validation).
 
Microsoft provides Azure Local as a commercial-off-the-shelf hybrid infrastructure platform that not only has a comprehensive set of industry-recognized certifications and audits but also gives you an array of platform capabilities to help you fulfill the stringent compliance requirements in both on-premises and cloud settings. Below are some certifications and compliance guidance we provide for Azure Local platform:

- Federal Information Processing Standard (FIPS) 140.
- Common Criteria for Information Technology Security Evaluation (CC).
- Payment Card Industry (PCI) Data Security Standards (DSS).
- Health Insurance Portability and Accountability Act of 1996 (HIPAA).
- U.S. Federal Risk and Authorization Management Program (FedRAMP).
- International Organization for Standardization (ISO) 27001:2022.

## Secure supply chain

The work to secure the supply chain for software is important to Microsoft and the world. The changing landscape and speed of technology has warranted efforts by Governments, organizations, and corporations alike to improve oversight and build in new capabilities. Microsoft is actively involved in developing standards (such as IETF and OpenSSF) and working with others to produce innovative changes. The initial focus is on how we and others produce products but with an eye towards running systems. 
 
Work started with the development of Software Bill of Materials (SBOM) from which the third-party dependencies (ingredients) must be listed. This includes binding of evidence claims and Common Vulnerabilities and Exposure (CVE) reports. The latter will enable a broader ability to assess risk and issues in dependent products. 

## Related content

[Conclusion](conclusion.md)