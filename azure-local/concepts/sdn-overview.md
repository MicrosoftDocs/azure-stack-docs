---
title: Arc-based Software defined networking (SDN) in Azure Local, version 24H2
description: Software defined networking (SDN) provides a way to centrally configure and manage networks and network services such as switching, routing, and load balancing in Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-local
ms.date: 04/14/2025
---

# Software Defined Networking (SDN) in Azure Local

> Applies to: Azure Local 2504 and later

Software defined networking (SDN) provides a way to centrally configure and manage networks and network services such as switching, routing, and load balancing in your datacenter. You can use SDN to dynamically create, secure, and connect your network to meet the evolving needs of your apps. Operating global-scale datacenter networks for services like Microsoft Azure, which efficiently performs tens of thousands of network changes every day, is possible only because of SDN.

For Azure Local solution, two types of SDN is available:

- **Cloud-based SDN**: This is the SDN solution that is available in Azure Local 2504 and later. It is based on the Azure Arc-enabled SDN solution. For cloud-based SDN, SLB and gateway are not supported. For more information, see [Cloud-based SDN](../index.yml).

    This solution is in preview and is not recommended for production use. It is intended for testing and evaluation purposes only.

- **Out-of-band SDN**: This is the SDN solution that is available in Azure Local 2311.2 and later. It is based on the Windows Server SDN solution. There are three major SDN components, and you can choose which you want to deploy: Network Controller, Software Load Balancer, and Gateway. For more information, see [Out-of-band SDN](../index.yml). 



## Next steps

For related information, see also:

- [Enable Arc-based SDN via ECE action plan](./enable-sdn-action-plan.md)
- [Deploy traditional SDN infrastructure using SDN Express](../deploy/sdn-express-23h2.md)
