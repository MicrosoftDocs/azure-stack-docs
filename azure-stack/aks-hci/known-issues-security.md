---
title: Troubleshoot security and identity issues and errors in Azure Kubernetes Service on Azure Stack HCI 
description: Get help to troubleshoot security and identity issues and errors in Azure Kubernetes Service on Azure Stack HCI.
author: mattbriggs
ms.topic: troubleshooting
ms.date: 02/04/2022
ms.author: mabrigg 
ms.lastreviewed: 02/04/2022
ms.reviewer: abha

---

# Fix security and identity known issues and errors

Use this topic to help you troubleshoot and resolve security and identity-related issues in AKS on Azure Stack HCI.

## Delete KVA certificate if expired after 60 days

KVA certificate expires after 60 day if no upgrade is performed.

`Update-AksHci` and any command involving `kvactl` will throw the following error.

`Error: failed to get new provider: failed to create azurestackhci session: Certificate has expired: Expired`

To resolve this error, delete the expired certificate file at `\kvactl\cloudconfig` and try `Update-AksHci` again on the node seeing the certificate expiry issue. You can use the following command:

```bash
$env:UserProfile.wssd\kvactl\cloudconfig
```

You can find a discussion about the issue at [KVA certificate needs to be deleted if KVA Certificate expired after 60 days](https://github.com/Azure/aks-hci/issues/146)

## Uninstall-AksHciAdAuth fails with the error `[Error from server (NotFound): secrets "keytab-akshci-scale-reliability" not found]`
If [Uninstall-AksHciAdAuth](./reference/ps/./uninstall-akshciadauth.md) displays this error, you should ignore it for now as this issue will be fixed.
## Special Active Directory permissions are needed for domain joined Azure Stack HCI nodes 
Users deploying and configuring Azure Kubernetes Service on Azure Stack HCI need to have **Full Control** permission to create AD objects in the Active Directory container the server and service objects are created in. 

## Next steps
- [Troubleshooting overview](troubleshoot-overview.md)
- [Networking issues and errors](known-issues-networking.md)
- [storage known issues](known-issues-storage.md)