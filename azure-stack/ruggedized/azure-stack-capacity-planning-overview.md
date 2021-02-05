---
title: Overview of capacity planning for Azure Stack Hub | Microsoft Docs
description: Learn about capacity planning for Azure Stack Hub deployments. See specifications for high and low models of the Azure Stack Hub ruggedized.
services: azure-stack
documentationcenter: ''
author: PatAltimore
manager: femila
editor: ''

ms.assetid:
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/14/2020
ms.author: patricka
ms.reviewer: prchint
ms.lastreviewed: 10/14/2020
---

# Overview of Azure Stack Hub capacity planning

[!INCLUDE [capacity-planning-overview](../includes/capacity-planning-overview.md)]

## Azure Stack Hub ruggedized high and low models

The following table lists specifications for high and low models of the Azure Stack Hub ruggedized.

| Component               | Specification |
|-------------------------|---------------|
| CPU                     |High: 284 vCPU cores<br>Low: 184 vCPU cores  |
| Memory                  |High: 1,037 GB<br>Low: 547 GB                |
| Storage                 |High: 34.2 TB<br>Low: 15.4 TB                |
| Acceleration            |N/A                                          |
| Size/Weight             |Compute: 31.5" L x 23.8" W x 15.33" H<br>Weight 120 lbs. (qty 2)<br>Networking: 31.5" L x 23.8" W x 17.12" H<br>Weight 145 lbs. (qty 1)              |
| Optional configurations |Pre-Heater<br>High or Low configurations     |

## Next steps

[Azure Stack Hub compute](../operator/azure-stack-capacity-planning-compute.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)
[Azure Stack Hub storage](../operator/azure-stack-capacity-planning-storage.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)
[Azure Stack Hub Capacity Planner](../operator/azure-stack-app-service-capacity-planning.md?toc=/azure-stack/tdc/toc.json&bc=/azure-stack/breadcrumb/toc.json)
