---
title:  Azure Local security book overview
description: Overview of the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 08/11/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Azure Local security book overview

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

## Layered, built-in security from core to cloud

Security threats are evolving in new ways, new vulnerabilities are emerging for organizations all the time, making it imperative to choose an infrastructure that is protected from these threats. Azure Local, a Microsoft Azure Arc-enabled infrastructure, is designed and built to help secure workloads, data, and operations with built-in capabilities inspired by Azure hyper scaled security.

## Scope

Azure Stack HCI is now part of Azure Local. Microsoft renamed Azure Stack HCI to Azure Local to communicate a single brand that unifies the entire distributed infrastructure portfolio. As such, this security book is a rebrand only of the Azure Stack HCI Security Book, and applies to features available in Azure Stack HCI, version 23H2 generally available on Feb 1, 2024.

## Introduction

Security affects everyone in your organization from upper-level management to the information worker. Inadequate security is a real risk for organizations as a security breach can disrupt all normal business and bring your organization to a halt. Information technology infrastructure is susceptible to a wide variety of attacks. Attackers typically take advantage of vulnerabilities in the hardware, firmware, operating system, or the application layer. Once they gain a foothold, they use techniques such as privilege escalation to move laterally to other systems in the organization. Azure Local supports security capabilities that can help protect as well as detect and respond to such attacks as quickly as possible.

Approximately 80% of security decision makers say that software alone is not enough protection from emerging threats ([Microsoft Security Signals](https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWPb70)). With Azure Local, both hardware and software work together to help protect sensitive data from the core of your machine all the way to the cloud. This level of protection helps keep your organization’s data and IT infrastructure secure. See the layers of protection in the following diagram to get a brief overview of our security priorities.

:::image type="content" source="./media/introduction/security-diagram.png" alt-text="Diagram illustrating process to add a node." lightbox="./media/introduction/security-diagram.png":::

Azure Local is designed to help defend against modern threats and was built to meet the requirements of a wide variety of security standards (see [Certifications](security-foundation-certifications.md)). The security posture of the Azure Local infrastructure is built on the following pillars:

- **Security rooted in hardware** – Secured-core certified hardware enables strong security rooted in hardware.

- **Security by default** – Security baselines and essential security features are enabled by default, right from the start. This ensures that the system is deployed in a known good state.

- **Security posture continuously monitored** – Verify that the system remains in a known good state. This is achieved through a protect, detect, and respond framework that allows for continuous monitoring of system security state and remediation of configuration drifts.

## Related content

- [Trustworthy addition](trustworthy-addition.md)
