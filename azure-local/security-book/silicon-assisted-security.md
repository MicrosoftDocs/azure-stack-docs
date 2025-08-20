---
title:  Silicon assisted security for the Azure Local security book 
description: Learn about silicon assisted security for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 08/11/2025
ms.author: alkohli
ms.reviewer: alkohli
---


# Silicon assisted security for Azure Local security book

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

Silicon assisted security for Azure Local means using secured core hardware and approved Azure Local solutions.

## Secured core hardware

There are two clear trends emerging in the server space today. First, organizations around the world are embracing digital transformation using technologies across cloud and edge to better serve their customers and thrive in fast-paced environments. Second, attackers are constantly evolving their attack strategies and targeting these organizations' high-value infrastructure with advanced technical capabilities connected to both cybercrime and espionage.

The [MagBo marketplace](https://www.zdnet.com/article/a-cybercrime-store-is-selling-access-to-more-than-43000-hacked-servers/), which sells access to more than 43,000 hacked servers, exemplifies the ever-expanding cybercrime threat. Compromised servers are being exploited to [mine cryptocurrency](https://www.bleepingcomputer.com/news/security/coinminer-campaigns-target-redis-apache-solr-and-windows-servers/) and are being hit with [ransomware attacks](https://www.zdnet.com/article/hackers-target-unpatched-citrix-servers-to-deploy-ransomware/). The Security Signals report shows that more than 80% of enterprises have experienced at least one firmware attack in the past two years.

Given these factors, continuing to raise the security bar for critical infrastructure against attackers and making it easy for organizations to meet that higher bar is a clear priority for both customers and Microsoft. Using our learnings from the [Secured-core PC initiative](/windows-hardware/design/device-experiences/oem-highly-secure), Microsoft has teamed up with the ecosystem partners to expand Secured-core to Azure Local.

Following Secured-core PC, we're introducing Secured-core Server, which is built on three key pillars: simplified security, advanced protection, and preventative defense. Secured-core Servers come with the assurance that manufacturing partners have built hardware and firmware that satisfy the requirements of the operating system (OS) security features.

### Simplified security

The security extension in Windows Admin Center makes it easy for you to configure the OS security features of Secured-core for 
Azure Local. The extension enables advanced security with a click of the button from a web browser anywhere in the world. With Azure Local Integrated Systems, manufacturing partners have further simplified the configuration experience for you so that Microsoft’s best server security is available right out of the box.

### Advanced protection

Secured-core Servers maximize hardware, firmware, and OS capabilities to help protect against current and future threats. These safeguards create a platform with added security for critical applications and data used on the hosts and VMs that run on them. Secured-core functionality spans the following areas:

#### Hardware root-of-trust

Trusted Platform Module 2.0 (TPM 2.0) comes standard with Secured-core Servers, providing a protected store for sensitive keys and data, such as measurements of the components loaded during boot. Being able to verify that firmware that runs during boot is validly signed by the expected author and not tampered with helps improve supply chain security. This hardware root-of-trust elevates the protection provided by capabilities like BitLocker, which uses TPM 2.0 and facilitates the creation of attestation-based workflows that can be incorporated into zero-trust security strategies.

#### Firmware protection

In the last few years, there has been a significant [uptick in firmware vulnerabilities](https://www.microsoft.com/security/blog/2019/10/21/microsoft-and-partners-design-new-device-security-requirements-to-protect-against-targeted-firmware-attacks/), in large part due to the inherently higher level of privileges with which firmware runs combined with the limited visibility into firmware by traditional antivirus solutions. Using processor support for Dynamic Root of Trust of Measurement (DRTM) technology, Secured-core systems put firmware in a hardware-based sandbox helping to limit the impact of vulnerabilities in millions of lines of highly privileged firmware code. Along with preboot DMA protection, Secured-core systems provide protection throughout the boot process.

#### Virtualization-based security (VBS)

Secured-core machines support VBS and hypervisor-based code integrity (HVCI). The cryptocurrency mining attack mentioned earlier used the [EternalBlue exploit](https://www.cisecurity.org/wp-content/uploads/2019/01/Security-Primer-EternalBlue.pdf). VBS and HVCI help protect against this entire class of vulnerabilities by isolating privileged parts of the OS, like the kernel, from the rest of the system. This helps to ensure that machines remain devoted to running critical workloads and helps protect related applications and data from attack and exfiltration.
 
Enabling Secured-core functionality helps proactively defend against and disrupt many of the paths attackers may use to exploit a system. These defenses also enable IT and SecOps teams to better use their time across the many areas that need their attention.

## Azure Local solutions

Secured-core machines can be easily identified in the [Azure Local catalog](https://azurelocalsolutions.azure.microsoft.com/#/catalog) as well as in the [Windows Server catalog](https://www.windowsservercatalog.com/). Azure Local solutions supporting Secured-core capabilities are available from industry leading solution builders today. Furthermore, starting with Azure Local, version 22H2, Secured-core support is required on all new solutions based on Gen 3 or newer CPU. Thus, customers will benefit from host protection that is available with Microsoft OS platforms.

Microsoft Hardware Solution Partners provide [Azure Local solution categories](https://azurelocalsolutions.azure.microsoft.com/#/Learn) (Premier Solutions, Integrated Systems and Validated Nodes) with hardware service, support, and security updates for at least five years.

## Related content

[Security foundation](security-foundation.md)