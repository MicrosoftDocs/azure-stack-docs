---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 11/16/2020
ms.reviewer: sijuman
ms.lastreviewed: 11/16/2020

---

### When installing Az module falsly throws Admin rights required error

- Applicable: This issue applies to 2002 and later
- Cause: When installing the module from an elevated prompt, an error is thrown. The error says, `Administrator rights required`.
- Remediation: Close your session and start a new elevated PowerShell session. Make sure there isn't an existing Az.Accounts module loaded in the session.
- Occurrence: Common