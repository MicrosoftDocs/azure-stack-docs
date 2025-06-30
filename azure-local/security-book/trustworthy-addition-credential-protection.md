---
title:  Azure Local security book credential protection
description: Credential protection for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/30/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Credential protection

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

:::image type="content" source="./media/trustworthy/security-diagram-trustworthy.png" alt-text="Diagram illustrating system security layer." lightbox="./media/trustworthy/security-diagram-trustworthy.png":::

[Windows Defender Credential Guard](/windows/security/identity-protection/credential-guard/how-it-works) uses virtualization-based security (VBS) to protect against credential theft. With Windows Credential Guard, the Local Security Authority (LSA) stores and protects Active Directory secrets in an isolated environment that is not accessible to the rest of the operating system. By protecting the LSA process with virtualization-based security, Windows Defender Credential Guard shields systems from credential theft attack techniques like pass-the-hash or pass-the-ticket. It also helps prevent malware from accessing system secrets even if the process is running with admin privileges. Windows Defender Credential Guard is enabled by default in Azure Local. 


## Related content

- [Trustworthy addition overview](trustworthy-addition-overview.md)
