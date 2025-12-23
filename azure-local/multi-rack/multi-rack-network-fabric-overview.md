---
title: Network Fabric Overview For Azure Local Multi-Rack Deployments (preview)
description: Learn about network fabric resources for Azure Local multi-rack deployments (preview).
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: concept-article
ms.date: 12/19/2025
---

# Network fabric overview for multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes the capabilities of the network fabric used for infrastructure management for multi-rack deployments of Azure Local. The article also covers the workload networking required for these deployments.

The network fabric instance is a single deployed physical network infrastructure - including racks, switches, terminal server connections, and cabling - that Azure represents and manages as a Network Fabric (NF) resource.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Benefits of network fabric

The network fabric enables you to:

- Use a single pane of glass to manage your on-premises networking devices and their configuration.

- Create infrastructure networks and workload networks that are isolated.

- Configure route policies to import and export specific routes to and from your existing infrastructure network.

- Monitor and audit network device performance, health, and configuration changes through metrics, logs, and alerts.

- Set access policies to govern who can manage the network.

- Manage the lifecycle of the network devices.

- Get a highly available and robust control plane for your network infrastructure.

:::image type="content" source="./media/multi-rack-network-fabric-overview/network-fabric-diagram.png" alt-text="Diagram showing network fabric components." lightbox="./media/multi-rack-network-fabric-overview/network-fabric-diagram.png":::

## Key capabilities of network fabric

Key capabilities offered in the network fabric are:

* **Bootstrapping and lifecycle management** - Automated bootstrapping and provisioning of network fabric resources based on workload use cases. It provides various controls to manage network devices in enterprise environments through Azure APIs.

* **Workload network configuration** - Automated network configuration in Network Fabric for workloads that are deployed on the compute servers. The network configuration enables east-west communication between workloads as well as north-south communication between external networks and workloads.

* **Observability** - Monitor the health and performance of the network fabric in real time through metrics and logs.

* **Network policy automation** - Automating the management of consistent network policies across the fabric to ensure security, performance, and access controls are enforced uniformly.

* **Networking features built for enterprise customers** - Support for unique features like multicast, Stream Control Transmission Protocol (SCTP), and jumbo frames.

## Next steps

See [Complete deployment prerequisites](./multi-rack-prerequisites.md).
