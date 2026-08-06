---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 07/08/2026
ms.reviewer: raymondl
ms.lastreviewed: 12/9/2020

---

### Installing the Az module falsely throws an admin rights required error

- Applies to: 2002 and later.
- Cause: When you install the module from an elevated prompt, the process returns an error. The error message says, `Administrator rights required`.
- Remediation: Close your session and start a new elevated PowerShell session. Make sure the session doesn't already have the Az.Accounts module loaded.
- Occurrence: Common