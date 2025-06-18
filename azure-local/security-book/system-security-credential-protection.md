---
title:  Azure Local security book credential protection
description: Credential protection for the Azure Local security book.
author: alkohli
ms.topic: conceptual
ms.date: 06/16/2025
ms.author: alkohli
ms.reviewer: alkohli
---

# Credential protection

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

:::image type="content" source="./media/trustworthy/security-diagram-trustworthy.png" alt-text="Diagram illustrating system security layer." lightbox="./media/trustworthy/security-diagram-trustworthy.png":::

Preventing unwanted or malicious applications from running is an important part of an effective security strategy. Application control is one of the most effective means for addressing the threat of executable file-based malware. Application control helps mitigate security threats by restricting the applications that users are allowed to run.  

While most customers inherently understand the value of application control, the reality is that only some have been able to employ application control solutions in a manageable way. Windows [Defender Application Control](/windows/security/application-security/application-control/app-control-for-business/appcontrol) (WDAC) provides powerful control over what applications are allowed to run and the code that runs in the OS (kernel).

WDAC is enabled by default on Azure Local, and out of the box it includes a set of base policies to ensure that only known platform components and applications are allowed to run. You can extend and customize this application control policy. For more information on base policies included in Azure Local and how to create supplemental policies, see [Windows Defender Application Control for Azure Local](/azure/azure-local/manage/manage-wdac).


## Related content
