---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 10/13/2023
ms.reviewer: kalkeea
ms.lastreviewed: 10/13/2023
---

### Data plane clusters are in an unhealthy state with all nodes in warning state

- Applicable: This issue applies to all supported releases of Event Hubs on Azure Stack Hub.
- Cause: Internal infrastructure secrets may be nearing expiration.
- Remediation: Update to the latest Event Hubs on Azure Stack Hub release, then complete the process in [How to rotate secrets for Event Hubs on Azure Stack Hubs](../operator/event-hubs-rp-rotate-secrets.md).

### Data plane clusters' health isn't getting updated in admin portal or scale-out of clusters results in access denied

- Applicable: This issue applies to all supported releases of Event Hubs on Azure Stack Hub.
- Cause: Internal components haven't refreshed their cache with new secrets, after secret rotation is completed.
- Remediation: [Open a support request](../operator/azure-stack-help-and-support-overview.md) to receive assistance.

### Azure Stack Hub backup fails

- Applicable: This issue applies to all supported releases of Event Hubs on Azure Stack Hub.
- Cause: Internal infrastructure secrets may have expired.
- Remediation: [Open a support request](../operator/azure-stack-help-and-support-overview.md) to receive assistance.
