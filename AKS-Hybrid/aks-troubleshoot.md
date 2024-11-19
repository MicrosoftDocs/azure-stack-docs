---
title: Troubleshoot common issues in AKS enabled by Azure Arc
description: Learn about common issues and workarounds in AKS enabled by Arc.
ms.topic: how-to
author: sethmanheim
ms.date: 02/27/2024
ms.author: sethm 
ms.lastreviewed: 02/27/2024
ms.reviewer: guanghu

---

# Troubleshoot common issues in AKS enabled by Azure Arc

This article describes how to find solutions for issues you encounter when using AKS enabled by Azure Arc. Known issues and errors are organized by functional area. You can use the links provided in this article to find solutions and workarounds to resolve them.

## Open a support request

See the [get support](/azure/aks/hybrid/help-support?tabs=aksee) article for information about how to use the Azure portal to get support or open a support request for AKS Arc.

## Upgrade

### Azure Advisor upgrade recommendation

If you continually see an [Azure Advisor](/azure/advisor/) upgrade recommendation that says "Upgrade to the latest version of AKS enabled by Azure Arc," follow these steps to disable the recommendation:

- Ensure that you update your Azure Local solution to the latest version. For more information, see [About updates for Azure Local, version 23H2](/azure-stack/hci/update/about-updates-23h2).
- If you use any of the Azure SDKs, ensure that you are using the latest version of that SDK. You can find the Azure SDKs by searching for "HybridContainerService" on the [Azure SDK releases](https://azure.github.io/azure-sdk/) page.

## Next steps
- [Troubleshoot K8sVersionValidation error](cluster-k8s-version.md)
- [Use diagnostic checker](aks-arc-diagnostic-checker.md)
