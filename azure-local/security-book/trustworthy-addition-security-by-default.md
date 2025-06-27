---
title:  Azure Local security book security by default
description: Security by default for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Security by default

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

:::image type="content" source="./media/trustworthy/security-diagram-trustworthy.png" alt-text="Diagram illustrating system security layer." lightbox="./media/trustworthy/security-diagram-trustworthy.png":::

## Security baselines

By default, Azure Local enables [security baseline settings](/azure/azure-local/manage/manage-secure-baseline) and security best practices based on Microsoft recommended security baselines and industry best practices. A tailored security baseline with over 300 security settings is enforced with a drift control mechanism which ensures that the system starts and remains in a known good security state.

This security baseline enables you to closely meet the Center for Internet Security (CIS) Benchmark, Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG), and Federal Information Processing Standards (FIPS 140-2) requirements for the operating system (OS), and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-windows). The security baseline settings have been verified for compatibility and performance impact. The default enablement of those security baselines is intended to make it easier for customers to meet their compliance and regulatory requirements. 

## Insecure protocols disabled by default

Insecure protocols such as TLS versions less than 1.2, DTLS versions less than 1.2, SMB 1.0, and WDigest which have inherent vulnerabilities are disabled by default in Azure Local.  

## Secure protocols and standards

Azure Local uses secure protocols such as Transport Layer Security (TLS) versions 1.2 or higher, Datagram Transport Layer Security (DTLS) versions 1.2 or higher, and Server Messaging Blok (SMB) 2.0 or higher. It supports National Institute of Standards and Technology (NIST) [guidelines for cryptographic standards](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-175Br1.pdf).

## Speculative side-channel vulnerabilities

Modern CPUs achieve performance by using idle CPU cycles to perform speculative and out of order execution of instructions. For instance, the CPU may predict the target of a branch instruction and speculatively execute the instructions at the predicted branch target.

If the CPU later discovers that the branch prediction was incorrect, all the machine state that was computed speculatively is discarded. However, this operation can leave residual traces in various caches that are used by the CPU. These residual traces can leave observable side effects (side channel) which attackers may be able to use to extract information about private data using a timing attack. Spectre and Meltdown are some of the original transient execution CPU vulnerabilities. Azure Local enables mitigations for known speculative execution [side channel hardware vulnerabilities](https://support.microsoft.com/topic/kb4072698-windows-server-and-azure-stack-hci-guidance-to-protect-against-silicon-based-microarchitectural-and-speculative-execution-side-channel-vulnerabilities-2f965763-00e2-8f98-b632-0d96f30c8c8e) by default.


## Related content
