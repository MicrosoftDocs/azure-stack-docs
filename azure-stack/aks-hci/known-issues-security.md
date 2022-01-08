---
title: Troubleshoot security and identity issues and errors in Azure Kubernetes Service on Azure Stack HCI 
description: Get help to troubleshoot security and identity issues and errors in Azure Kubernetes Service on Azure Stack HCI.
author: v-susbo
ms.topic: troubleshooting
ms.date: 12/13/2021
ms.author: v-susbo
ms.reviewer: 
---

# Fix security and identity known issues and errors

Use this topic to help you troubleshoot and resolve security and identity-related issues in AKS on Azure Stack HCI.

## Uninstall-AksHciAdAuth fails with the error `[Error from server (NotFound): secrets "keytab-akshci-scale-reliability" not found]`
If [Uninstall-AksHciAdAuth](./reference/ps/./uninstall-akshciadauth.md) displays this error, you should ignore it for now as this issue will be fixed.

## Special Active Directory permissions are needed for domain joined Azure Stack HCI nodes 
Users deploying and configuring Azure Kubernetes Service on Azure Stack HCI need to have **Full Control** permission to create AD objects in the Active Directory container the server and service objects are created in. 

## Next steps
- [Troubleshooting overview](troubleshoot-overview.md)
- [Networking issues and errors](known-issues-networking.md)
- [storage known issues](known-issues-storage.md)