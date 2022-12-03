---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 12/03/2022
---

The new installations with Azure Stack HCI, Supplemental Package release start with a *secure-by-default* strategy. The new version has a tailored security baseline coupled with a security drift control mechanism and a set of well-known security features enabled by default.

To summarize, this release provides:

- A tailored security baseline with over 200 security settings configured and enforced with a security drift control mechanism that ensures the cluster always starts and remains in a known good security state.

    The security baseline enables you to closely meet the Center for Internet Security (CIS) Benchmark, Defense Information Systems Agency Security Technical Implementation Guides (DISA STIG), Common Criteria, and  Federal Information Processing Standards (FIPS) requirements for the OS and [Azure Compute Security baselines](/azure/governance/policy/samples/guest-configuration-baseline-windows).

    For more information, see [Security baseline settings for Azure Stack HCI](../hci/concepts/secure-baseline.md).

- Improved security posture achieved through a stronger set of protocols and cipher suites enabled by default.

- Secured-Core Server that achieves higher protection by advancing a combination of hardware, firmware, and driver capabilities. For more information, see [What is Secured-core server?](windows-server/security/secured-core-server).

- Out-of-box protection for data and network with SMB signing and BitLocker encryption for OS and Cluster Shared Volumes. For more information, see [BitLocker encryption for Azure Stack HCI](../hci/concepts/security-bitlocker.md).

- Reduced attack surface as Windows Defender Application Control is enabled by default and limits the applications and the code that you can run on the core platform. For more information, see [Windows Defender Application Control for Azure Stack HCI](../hci/concepts/security-windows-defender-application-control.md).
