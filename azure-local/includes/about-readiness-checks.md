---
author: ronmiab
ms.author: robess
ms.service: azure-local
ms.topic: include
ms.date: 12/05/2024
ms.reviewer: alkohli
ms.lastreviewed: 12/11/2024
---

Readiness checks are essential to ensure that you apply updates smoothly, keep your systems up-to-date, and maintain correct system functionality. Readiness checks are performed and reported separately in two scenarios:

- System health checks that run once **every 24 hours**.

- Update readiness checks that run after downloading the update content and before beginning the installation.

It is common for the results of system health checks and update readiness checks to differ. This happens because update readiness checks use the latest validation logic from the solution update to be installed, while system health checks always use validation logic from the installed version.

Both system and pre-update readiness checks perform similar validations and categorize three types of readiness checks: Critical, Warning, and Informational.

- **Critical**: Readiness checks that prevent you from applying the update. This status indicates issues that you must resolve before proceeding with the update.
- **Warning**: Readiness checks that also prevent you from applying the update, but you can bypass these using [PowerShell](../update/update-via-powershell-23h2.md). This status indicates potential issues that might not be severe enough to stop the update but should be addressed to ensure a smooth update process.
- **Informational**: Readiness checks that don't block the update. This status provides information about the system's state and any potential issues that shouldn't affect the update process directly. These checks are for your awareness and might not require immediate action.