---
title: Network fabric overview for Azure Local multi-rack deployments
description: Learn about network fabric resources for Azure Local multi-rack deployments.
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: conceptual
ms.date: 11/19/2025
---

# Network fabric overview for Azure Local multi-rack deployments

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes the capabilities of the network fabric used to manage the infrastructure and workload networking required to run Azure Local multi-rack deployments.

The network fabric enables you to:

- Use a single pane of glass to manage your on-premises networking devices and their configuration.

- Create infrastructure and workload networks that are isolated.

- Configure route policies to import and export specific routes to and from your existing infrastructure network.

- Monitor and audit device performance, health, and configuration changes and take action against them via metrics, logs, and alerts.

- Set access policies to govern who can manage the network.

- Manage the lifecycle of the network devices.

- Get highly available and robust control plane for your network infrastructure.

:::image type="content" source="./media/multi-rack-network-fabric-overview/network-fabric-diagram.png" alt-text="Diagram showing network fabric components." lightbox="./media/network-fabric-overview/multi-rack-network-fabric-diagram.png":::

Key capabilities offered in the network fabric:

* **Bootstrapping and lifecycle management** - Automated bootstrapping & provisioning of network fabric resources based on network function use-cases. It provides various controls to manage network devices in operator premises via Azure APIs.

* **Tenant network configuration** - Automated network configuration in Network Fabric for Container Network Functions (CNFs) and Virtual Network Functions (VNFs) that are deployed on the compute nodes. The network configuration enables east-west communication between network functions as well as north-south communication between external networks and VNFs/CNFs. 

* **Observability** - Monitor the health and performance of the network fabric in real-time with metrics and logs.

* **Network Policy Automation** - Automating the management of consistent network policies across the fabric to ensure security, performance, and access controls are enforced uniformly.

* **Networking features built for Operators** - Support for unique features like multicast, SCTP, and jumbo frames.

## Next steps

- See [Network Fabric Controller overview]
