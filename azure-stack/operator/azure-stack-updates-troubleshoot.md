---
title: Troubleshoot updates in Azure Stack | Microsoft Docs
description: As an Azure Stack operator, learn how to resolve issues with update so that Azure Stack can return to production as quickly as possible. 
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 09/23/2019
ms.author: mabrigg
ms.lastreviewed: 09/23/2019
ms.reviewer: ppacent 

# Intent: As an Azure Stack operator, I want to resolve issues with my update so that Azure Stack can return to production as quickly as possible. 
# Keywords: update azure stack troubleshoot

---

# Troubleshooting patch and update issues for Azure Stack

*Applies to: Azure Stack integrated systems*

You can use the guidance in this article to resolve issues you're having when updating Azure Stack.

## PreparationFailed

**Applicable**: This issue applies to all supported releases.

**Cause**: When attempting to install the Azure Stack update, the status for the update might fail and change state to `PreparationFailed`. This is caused by the update resource provider (URP) being unable to properly transfer the files from the storage container to an internal infrastructure share for processing.

**Remediation**: Starting with version 1901 (1.1901.0.95), you can work around this issue by clicking **Update** now again (not **Resume**). The URP then cleans up the files from the previous attempt, and restarts the download. If the problem persists, we recommend manually uploading the update package by following the [Install updates](azure-stack-apply-updates.md?#install-updates-and-monitor-progress) section.

**Occurrence**: Common

## Next steps

- [Update Azure Stack](azure-stack-updates.md)  
- [Microsoft Azure Stack help and support](azure-stack-help-and-support-overview.md)
