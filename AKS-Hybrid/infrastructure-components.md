---
title: Infrastructure component updates for AKS on Azure Stack HCI
description: Learn about cloud-based updates for infrastructure components in AKS on Azure Stack HCI.
ms.topic: overview
author: sethmanheim
ms.date: 01/29/2024
ms.author: sethm 
ms.lastreviewed: 11/28/2023
ms.reviewer: guanghu

---

# Infrastructure component updates for AKS on Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article provides a brief overview of infrastructure component updates for AKS on Azure Stack HCI 23H2.

## Cloud-based updates for infrastructure components

Azure Stack HCI 23H2 consolidates all the relevant updates for the OS, software agents, Azure Arc infrastructure, and OEM drivers and firmware
into a unified monthly update package. This comprehensive update package is identified and applied from the cloud through the Azure Update Manager tool.

AKS is now part of Azure Stack HCI starting from version 23H2. The whole lifecycle management of AKS Arc infrastructure follows
the same approach as any other components on Azure Stack HCI 23H2. This approach provides a flexible foundation to integrate and manage various
aspects of the Azure Stack HCI solution in one place, including the management of the OS, core agents and services, and the solution
extension. AKS Arc infrastructure components, as part of solution extensions, will be updated through the update package of Azure Stack HCI 23H2.

For more information, see the [Update overview for Azure Stack HCI, version 23H2](/azure-stack/hci/update/whats-the-lifecycle-manager-23h2).

## Next steps

- [How to update via the Azure portal](/azure-stack/hci/update/azure-update-manager-23h2)
- [How to update via PowerShell](/azure-stack/hci/update/update-via-powershell-23h2)
- [Understand different update phases](/azure-stack/hci/update/update-phases-23h2)
