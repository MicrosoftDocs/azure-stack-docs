---
title:  Azure Local security book introduction
description: Introduction for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Introduction

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

Security affects everyone in your organization from upper-level management to the information worker. Inadequate security is a real risk for organizations as a security breach can disrupt all normal business and bring your organization to a halt. Information technology infrastructure is susceptible to a wide variety of attacks. Attackers typically take advantage of vulnerabilities in the hardware, firmware, operating system, or the application layer. Once they gain a foothold, they use techniques such as privilege escalation to move laterally to other systems in the organization. Azure Local supports security capabilities that can help protect as well as detect and respond to such attacks as quickly as possible.

Approximately 80% of security decision makers say that software alone is not enough protection from emerging threats ([Microsoft Security Signals](https://query.prod.cms.rt.microsoft.com/cms/api/am/binary/RWPb70)). With Azure Local, both hardware and software work together to help protect sensitive data from the core of your machine all the way to the cloud. This level of protection helps keep your organization’s data and IT infrastructure secure. See the layers of protection in the following diagram to get a brief overview of our security priorities.

:::image type="content" source="./media/introduction/security-diagram.png" alt-text="Diagram illustrating process to add a node." lightbox="./media/introduction/security-diagram.png":::

Azure Local is designed to help defend against modern threats and was built to meet the requirements of a wide variety of security standards (see [Certifications](security-foundation-certifications.md)). The security posture of the Azure Local infrastructure is built on the following pillars:

- **Security rooted in hardware** – Secured-core certified hardware enables strong security rooted in hardware.

- **Security by default** – Security baselines and essential security features are enabled by default, right from the start. This ensures that the system is deployed in a known good state.

- **Security posture continuously monitored** – Verify that the system remains in a known good state. This is achieved through a protect, detect, and respond framework that allows for continuous monitoring of system security state and remediation of configuration drifts.

## Trustworthy addition

Our customers face the significant burden of getting their infrastructure to meet a wide variety of security standards and be compliant with industry specific compliance requirements. They may spend several millions of dollars on external tools to get their infrastructure to meet those requirements. This is a tall order for many customers as they need to identify and enable various security capabilities. Even when they do, how those various security capabilities work together is yet another challenge to deal with. 

Our goal is to empower customers to achieve their security requirements, regardless of industry regulations or compliance, more easily and in a flexible manner. Azure Local builds on industry-leading security features such as Windows Defender Application Control and BitLocker. With Azure Local, we have enabled security right from the start, where the system is by default deployed in a known good state in accordance with the [Microsoft Cloud Security Benchmark](/security/benchmark/azure/overview).

With Azure Locl, customers do not have to burden themselves with the mechanics of enabling the various security capabilities, at least not for most of the well-known security requirements. From a customer standpoint, security "just works".
