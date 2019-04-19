---
title: Azure Stack release notes - known issues | Microsoft Docs
description: Learn about known issues in Azure Stack.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/10/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 04/10/2019
---

# Azure Stack known issues

This article describes important considerations while applying the Azure Stack 1904 update.

> [!IMPORTANT]  
> Review this section before applying the update.

(optional and ideally rare. Only required if there are known issues that the customer will hit DURING update that may generate a support call or customer dissatisfaction.)

## Known issues with Azure Stack

This section lists known issues with supported releases of Azure Stack. The list is updated as new releases and hotfixes are released.

<!-- EXAMPLE -->
### Infrastructure backup

<!--Bug 3615401 - scheduler config lost; new issue in YYMM;  hectorl-->
After enabling automatic backups, the scheduler service goes into disabled state unexpectedly. The backup controller service will detect that automatic backups are disabled and raise a warning in the administrator portal. This warning is expected when automatic backups are disabled.

- Applicable: This is a new issue with release YYMM
- Cause: This issue is due to a bug in the service that results in loss of scheduler configuration. This bug does not change the storage location, user name, password, or encryption key.
- Remediation: To mitigate this issue, open the backup controller settings blade in the Infrastructure Backup resource provider and select **Enable Automatic Backups**. Make sure to set the desired frequency and retention period.
- Occurrence: Low

<!-- TEMPLATE -->
### (Feature area)

<!--Bug xxxxxxx: bug title; new issue or existing issue,  PM owner-->
<!-- Issues that drop off this list better make it in as an improvement or a fix on release notes page -->
(Detailed customer facing description of the issue)  

<!-- PICK ONE -->
- Applicable: (All supported releases of Azure Stack - carry over); (Starting in YYMM release of Azure Stack, new issue)
- Cause: (cause of the issue)
- Remediation: (how to work around this, if there is one)
- Occurrence: (rate of occurrence)

<!-- ### Portal -->
<!-- ### Compute -->
<!-- ### Storage -->
<!-- ### Networking -->
<!-- ### SQL and MySQL-->
<!-- ### App Service -->
<!-- ### Usage -->
<!-- #### Identity -->
<!-- #### Marketplace -->

## Next Steps

- [Review update activity checklist](azure-stack-release-notes-checklist.md)
- [Review list of security updates](azure-stack-release-notes-security-updates-1904.md)
