---
title:  Azure Local security book memory integrity protection
description: Memory integrity protection for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Memory integrity protection

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

Kernel Mode Code Integrity is the Windows process that checks whether all kernel code is properly signed and has not been tampered with before it is allowed to run. [Hypervisor-protected code integrity (HVCI)](/windows-hardware/design/device-experiences/oem-hvci-enablement), also called memory integrity, uses virtualization-based security (VBS) to run Kernel Mode Code Integrity inside the secure VBS environment instead of the main Windows kernel. This helps prevent attacks that attempt to modify kernel mode code such as drivers.

Memory integrity also restricts kernel memory allocations that could be used to compromise the system, ensuring that kernel memory pages are only made executable after passing code integrity checks inside the secure VBS environment, and executable pages themselves are never writable. That way, even if there are vulnerabilities like buffer overflow that allows malware to attempt to modify memory, executable code pages cannot be modified, and modified memory cannot be made executable. Memory integrity helps protect against attacks that rely on the ability to inject malicious code into the kernel using bugs in kernel-mode software. Memory integrity protection is enabled by default in Azure Local.


## Related content

- [Trustworthy addition overview](trustworthy-addition-overview.md)
