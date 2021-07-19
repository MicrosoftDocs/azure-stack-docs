---
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: include
ms.date: 07/19/2021
ms.reviewer: bryanla
ms.lastreviewed: 07/19/2021
---

### Secret expiration does not trigger an alert

- Applicable: all versions
- Cause: Administrative alerts are not currently integrated
- Remediation: Complete the process in [How to rotate secrets for Event Hubs on Azure Stack Hubs](../operator/event-hubs-rp-rotate-secrets.md) regularly, ideally every six months.

### Data plane clusters are in an unhealthy state with all nodes in warning state

- Applicable: all versions
- Cause: Internal infrastructure secrets may be nearing expiration
- Remediation: Update to the latest Event Hubs on Azure Stack Hub release, then complete the process in [How to rotate secrets for Event Hubs on Azure Stack Hubs](../operator/event-hubs-rp-rotate-secrets.md).

### Azure Stack Hub backup fails

- Applicable: all versions
- Cause: Internal infrastructure secrets may have expired
- Remediation: [Open a support request](../operator/azure-stack-help-and-support-overview.md) to receive assistance.
