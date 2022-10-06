---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 06/08/2021
ms.reviewer: sethm
ms.lastreviewed: 06/08/2021
---
<!-- TODO - For each release: add AzS Hub build number, Event Hubs RP version number, & corresponding Event Hubs release notes text/link -->
> [!IMPORTANT]
> Before deploying or updating the Event Hubs resource provider (RP), you may need to update Azure Stack Hub to a supported version (or deploy the latest Azure Stack Development Kit). Be sure to read the RP release notes first, to learn about new functionality, fixes, and any known issues that could affect your deployment.
>
> | Supported Azure Stack Hub version(s) | Event Hubs RP release |
> |-----|---|
> | 2102 and higher | 1.2102.2.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2102-20.md) |
> | 2102 and higher | 1.2102.1.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2102-10.md) |
> | 2102 and higher | 1.2102.0.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2102-00.md) |
> | 2008 and higher | 1.2012.2.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2012-20.md) |
> | 2008 and higher | 1.2012.1.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) \| [Release notes](../operator/event-hubs-rp-release-1-2012-10.md) |
> | 2005, 2008 | 1.2012.0.0 [Install](../operator/event-hubs-rp-install.md) \| [Update](../operator/resource-provider-apply-updates.md) |
> 
> If you've installed a preview version not listed above, upgrading to one of the versions above is also recommended.

> [!WARNING]
> Failure to rotate secrets on a regular basis can result in your [data plane clusters entering an unhealthy state](#data-plane-clusters-are-in-an-unhealthy-state-with-all-nodes-in-warning-state), and possibly redeployment of the Event Hubs on Azure Stack Hub resource provider. As such, it is *critical* that you proactively [rotate the secrets used by Event Hubs on Azure Stack Hub](../operator/event-hubs-rp-rotate-secrets.md). **Secrets should be rotated after completing an install/update to a new release, and on a regular basis, ideally every 6 months.** 
> Proactive rotation is required as secret expiration [does not trigger administrative alerts](#secret-expiration-doesnt-trigger-an-alert). 
