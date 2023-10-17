---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 10/13/2023
ms.reviewer: kalkeea
ms.lastreviewed: 10/13/2023
---
<!-- TODO - For each release: add AzS Hub build number, Event Hubs RP version number, & corresponding Event Hubs release notes text/link -->
> [!IMPORTANT]
> Before deploying or updating the Event Hubs resource provider (RP), you may need to update Azure Stack Hub to a supported version (or deploy the latest Azure Stack Development Kit). Be sure to read the RP release notes first, to learn about new functionality, fixes, and any known issues that could affect your deployment.
>
> | Supported Azure Stack Hub version(s) | Event Hubs RP release |
> |-----|---|
> | 2306 and higher | 1.2102.4.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2102-40.md) |
> | 2206 and higher | 1.2102.3.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2102-30.md) |
> | 2206 and higher | 1.2102.2.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2102-20.md) |
> | 2108 and higher | 1.2102.2.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2102-20.md) |
> 
> If you've installed a preview version not listed above, upgrading to one of the versions above is also recommended.

> [!WARNING]
> Failure to rotate secrets on a regular basis can result in your [data plane clusters entering an unhealthy state](#data-plane-clusters-are-in-an-unhealthy-state-with-all-nodes-in-warning-state), and possibly redeployment of the Event Hubs on Azure Stack Hub resource provider. As such, it is *critical* that you proactively [rotate the secrets used by Event Hubs on Azure Stack Hub](../operator/event-hubs-rp-rotate-secrets.md). **Secrets should be rotated after completing an install/update to a new release, and on a regular basis, ideally every 6 months.**
