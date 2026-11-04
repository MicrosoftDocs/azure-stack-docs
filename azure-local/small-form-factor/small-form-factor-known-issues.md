---
title: Known Issues for Small Form Factor Deployments of Azure Local (preview)
description: Read about the known issues and limitations for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 10/28/2026
ms.author: sipastak
---

# Known issues for small form factor deployments of Azure Local (preview)

This article lists the known issues and limitations for small form factor deployments of Azure Local.

For issues fixed in version 2610, see [Release notes for small form factor deployments](small-form-factor-release-notes.md#fixed-issues-in-version-2610).

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Known issues in version 2610

The following known issues apply to Azure Local small form factor deployments running or updating to version 2610.

| Feature area | Issue | Impact | Workaround |
|---|---|---|---|
| Subscription policy | Azure policies that restrict publicly accessible storage accounts can block deployment. | Provisioned machine creation can fail during storage account-related steps. | If you hit storage account errors, review subscription policies that restrict publicly accessible storage accounts. |
| OS update | Updating from version 2607 to 2610 can fail with **Failed to initialize resource**. This issue has been observed on devices running Azure Arc-enabled K3s and Azure IoT Operations. | The update doesn't complete, and the device can lose Azure Arc connectivity. | Contact Microsoft Support for assistance with mitigation. |
| Wi-Fi configuration | On NVIDIA Jetson Thor devices running Ubuntu, the Azure portal can report that Wi-Fi configuration succeeded even though NetworkManager overrides the configuration and the device doesn't join the wireless network. | Wi-Fi connectivity isn't established despite the successful portal status. | Contact Microsoft Support for assistance with mitigation. |
| Security configuration | Security configurations might not work on NVIDIA Jetson devices after reprovisioning with an updated image. | The security configuration feature might be unavailable on affected devices. | Contact Microsoft Support for assistance with mitigation. |

## Related content

- [What are small form factor deployments of Azure Local (preview)?](small-form-factor-overview.md)
