---
title: Tips and troubleshooting for Azure Managed Lustre (Preview)
description: How to troubleshoot some common problems with Azure Managed Lustre file systems.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/09/2023
ms.reviewer: sethm
ms.date: 02/09/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---
# Tips and troubleshooting for Azure Managed Lustre (Preview)

<!--STATUS: Ported as is from private preview.-->

This article documents workarounds and gives help for common problems.

You also can check the list of [known issues](amlfs-known-issues-preview.md) to see if your issue is a reported bug.

## Auto-mount conflict (port 988 already in use)

When mounting NFS volumes and the Azure Managed Lustre file system automatically, a race condition can occur that prevents the file system from being mounted. This issue can give the error message `Can't start acceptor on port 988: port already in use.`

To work around the problem, set the NFS mount parameters `noresvport` and `noauto` for each of the NFS mounts.
