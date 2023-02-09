---
title: Known issues in Azure Managed Lustre (Preview)
description: TK
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/09/2023
ms.reviewer: sethm
ms.date: 02/09/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Known issues in Azure Managed Lustre (Preview)

<!--SOURCE: Managed Lustre private preview known issues. Updated title only.-->

These problems or feature change requests are being tracked by the Azure Managed Lustre private preview team.

This list does not necessarily include all known issues.

<!--Add public preview disclaimer. Replaces private preview disclaimer inserted by include file.-->

## Provide feedback

To provide feedback or log a new issue, email the team at ``amlfs@microsoft.com``. This email alias is monitored by Azure Managed Lustre PM, Service Engineering, and Development teams.

Read [Azure Managed Lustre private preview support](preview-support.md) for information about response times and expected outcomes during this private preview.

## Known issues

These items are being tracked and investigated by the team.

| Area | Description | Date | Resolution/workaround |
|---|---|---|---|
| Prerequisites | Storage accounts must have a public endpoint | 2022/03/29 | Documented limitation for private preview |
| Archive | Archive of a single file times out after two days | 2022/03/29 | The maximum file size that can be archived is approximately 86TB, assuming 500 MB/s throughput |
| Archive | Archive task might show "complete" before all background tasks have finished | 2022/03/29 | To check if all files have been archived, run this command on a lustre client to walk the tree: ``find {lustre_dir} -type f | xargs -n1 lfs hsm_state | grep -v archived`` |
| Archive | Updated file permissions attributes on unmodified files are omitted from archive jobs | 2022/03/29 | This seems to be a limitation of Lustre HSM - this kind of metadata change doesn't change a file's ``hsm_state`` value. A possible workaround is to use a "touch" command to mark the file as modified. |
| Archive | Archive task status (percent complete) might be calculated incorrectly | 2022/04/06 | Awaiting a software fix |
| Archive | Export prefix path is not used correctly in archive job | 2022/04/13 | 2022/08/17 - Export prefix is deprecated. To prevent archive jobs from overwriting original data in the integrated blob container, store changed files in a unique path in the Azure Managed Lustre system instead of storing them in their original locations. |
| Mount | Lustre client mounts may take several minutes | 2022/04/13 | <!--Clients might be unable to mount for up to three minutes after the file system is created.--> **Resolved** 2022/04/20 |
| Create | "Your unsaved edits will be discarded" pop up warning shows when trying to create an Azure Managed Lustre file system. | 2022/05/04 | Deployment has already started; click OK to remove the message. |
| Create | If you type values into the Storage Capacity or Throughput fields, they are not saved and the corresponding value is not calculated. | 2022/05/04 | Use arrow keys to select values. **TIP:** You might be able to enter a number and then use arrow keys to find the next closest selectable value. |
| Performance | The Lustre 2.12 client is known to be significantly less performant than the Lustre 2.14 client | 2022/06/09 | If performance is less than desired and you're using 2.12, upgrade to Lustre 2.14 client |
| Management | "Delete Network Interface" errors exist in the Activity log | 2022/05/12 | Awaiting software fix. Errors are related to deleting NICs that don't exist or are attached to existing resources |

This information is provided for test user awareness only.
