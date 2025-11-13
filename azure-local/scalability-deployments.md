---
title: Azure Local Deployment Types and Scalability
description: Discover how Azure Local offers scalable on-premises solutions for critical workloads, from single machines to hundreds of machines, tailored to your needs.
#customer intent: As an IT admin, I want to understand the different Azure Local deployment types so that I can choose the best option for my organization's needs.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 11/12/2025
ms.topic: conceptual
ms.service: azure-local
---

# Azure Local scalability and deployment types

Azure Local offers you a consistent on-premises experience for your critical workloads and Arc services across a wide spectrum of scale points and use cases, from a single machine up to hundreds of machines.

This article provides an overview of the different Azure Local deployment types and their scalability options to help you choose the right solution for your organization's needs.

## About Azure Local deployment types

You can deploy Azure Local in different ways depending on your use case and needs. The following table summarizes the various Azure Local deployment types.

| Deployment type | Description |
|---|---|
| Hyperconverged deployments | Clusters of 1-16 machines using hyperconverged storage. <br><br>You can also attach an external SAN (Preview) for more storage capacity. |
| Multi-rack deployments (Preview) | Integrated racks of compute, storage, and networking that expand up to hundreds of machines. |
| Microsoft 365 Local deployments | Deployments for hosting Microsoft 365 Local workloads. |

## Hyperconverged deployments

Hyperconverged deployments are the most common type of Azure Local deployment. They provide maximum flexibility, a range of sizes, and various networking architectures. The minimum footprint is a single machine. Most customers choose to deploy Azure Local to a cluster of machines for increased scale and resiliency.

You can select hardware that suits your needs in the Azure Local Catalog from leading Original Equipment Manufacturer (OEM) partners.

For more information on hyperconverged deployments, see [What are hyperconverged deployments for Azure Local?](./overview/hyperconverged-overview.md)

## Multi-rack deployments (Preview)

For very large workloads, Azure Local now provides multi-rack deployments that can accommodate hundreds of machines in a single instance. Such deployments require a prescriptive set of hardware that includes compute, storage, and networking that comes in preintegrated racks with built-in fault tolerance.

For more information on multi-rack deployments, see [What are multi-rack deployments for Azure Local?](./multi-rack/multi-rack-overview.md)

## Microsoft 365 Local deployments

Specific reference architectures exist for Azure Local deployments that run Microsoft 365 Local applications. For more information about Microsoft 365 Local, see [Microsoft 365 Local](./concepts/microsoft-365-local-overview.md).


## Disconnected operations for Azure Local

Azure Local is typically deployed as a cloud-connected solution with the control plane running in an Azure cloud region. For customers with the strictest sovereignty or security requirements, you can also deploy Azure Local as a disconnected solution. Disconnected operations for Azure Local provides a local instance of the control plane, with a subset of Azure capabilities - enabling you to operate without a connection to the cloud.

For more information, see [Disconnected operations for Azure Local](./manage/disconnected-operations-overview.md).

## Next steps

Read about the different Azure Local deployment types:
- [What are hyperconverged deployments for Azure Local?](./overview/hyperconverged-overview.md)
- [What are multi-rack deployments for Azure Local?](./multi-rack/multi-rack-overview.md)
