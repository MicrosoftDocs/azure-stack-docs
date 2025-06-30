---
title:  Azure Local security book security assurance
description: Security assurance for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Security assurance

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

:::image type="content" source="./media/security-foundation/security-foundation-security-diagram.png" alt-text="Diagram illustrating Security Foundation layer." lightbox="./media/security-foundation/security-foundation-security-diagram.png":::

Microsoft is committed to continuously investing in improving our software development process, building highly secure-by-design software, and addressing security compliance requirements. We build in security from the ground up for powerful defense in today’s threat environment. Every component of Azure Local, from machine core to cloud, is purposefully designed to help ensure ultimate security. 
 
## Microsoft Security Development Lifecycle (SDL)

The Microsoft Security Development Lifecycle (SDL) introduces security best practices, tools, and processes throughout all phases of engineering and development. A range of tools and techniques - such as threat modeling, static analysis, fuzzing, and code quality checks—enable continued security value to be embedded into Windows by every engineer on the team from day one. Through the SDL practices, Microsoft engineers are continuously provided with actionable and up-to-date methods to improve development workflows and overall product security before the code has been released. Additionally, Microsoft Offensive Research and Security Engineering (MORSE) performs targeted design reviews, audits, and deep penetration testing of select Windows features. Microsoft’s open source OneFuzz platform allows developers to fuzz features for Windows at scale as part of their development and testing cycle. 
 
## Security assessment activities

As part of our SDL, products like Azure Local are reviewed by our  MORSE Edge team. MORSE works with other Microsoft security teams to perform comprehensive security assessments of the product. The goal of the security assessment activities is to:

- Ensure security promises the product makes are valid and effective.
- Identify insecure configurations, vulnerabilities, and design flaws in the Azure Local platform and its dependencies and ensure they are corrected before shipping. 
- Review the product against Microsoft’s SDL security requirements. 
- Ensure the product meets Microsoft’s standard of shipping a secure solution from inception. 
- Ensure that the product can also be managed to maintain and enhance security during the product's lifecycle. 
 
Comprehensive product security assessments will be done as new features are included and as the product continues through its lifecycle. The consistency in a comprehensive approach to securing edge products, staying current with best practices, customer needs, and regulatory and compliance requirements is the strongest indicator of the commitment Microsoft has made to developing a security-first product in Azure Local. 

## Related content

- [Certifications](security-foundation-certifications.md)
- [Secure supply chain](security-foundation-secure-supply-chain.md)