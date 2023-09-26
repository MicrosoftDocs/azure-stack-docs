---
description: "Learn more about: Health Service actions"
title: Track Health Service actions
ms.author: sethm
ms.topic: article
author: sethmanheim
ms.date: 04/17/2023
---
# Track Health Service actions

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

The Health Service, first released in Windows Server 2016, improves the day-to-day monitoring and operational experience for clusters running Storage Spaces Direct. This topic describes workflows that the Health Service automates.

The Health Service generates "Actions" to verify that they are taken autonomously, or to track their progress or outcome. Unlike logs, Actions disappear shortly after they have completed. They are intended primarily to provide insight into ongoing activity that may impact performance or capacity, such as restoring resiliency or rebalancing data.

## Usage
One PowerShell cmdlet displays all Actions:

```PowerShell
Get-StorageHealthAction
```

## Coverage
The **Get-StorageHealthAction** cmdlet can return any of the following information:

- Retiring failed, lost connectivity, or unresponsive physical disk
- Switching storage pool to use replacement physical disk
- Restoring full resiliency to data
- Rebalancing storage pool

## Additional References
- [Health Service in Windows Server 2016](health-service-overview.md)
- [Developer documentation, sample code, and API reference on MSDN](https://msdn.microsoft.com/windowshealthservice)
