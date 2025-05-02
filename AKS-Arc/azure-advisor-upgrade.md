---
title: Azure Advisor upgrade recommendation
description: Learn how to disable Azure Advisor upgrade recommendation alerts.
author: sethmanheim
ms.author: sethm
ms.topic: troubleshooting
ms.date: 02/28/2025

---

# Azure Advisor upgrade recommendation

This article describes how to disable recurring Azure Advisor upgrade recommendation alerts for AKS enabled by Azure Arc.

## Symptoms

You continually see an Azure Advisor upgrade recommendation that says **Upgrade to the latest version of AKS enabled by Azure Arc**.

## Workaround

Follow these steps to disable the recommendation:

- Ensure that you update your Azure Local solution to the latest version. For more information, see [About updates for Azure Local](/azure/azure-local/update/about-updates-23h2).
- If you use any of the Azure SDKs, ensure that you're using the latest version of that SDK. You can find the Azure SDKs by searching for "HybridContainerService" on the [Azure SDK releases](https://azure.github.io/azure-sdk/) page.

## Next steps

[Troubleshoot issues in AKS enabled by Azure Arc](aks-troubleshoot.md)
