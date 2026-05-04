---
title: Azure Local Deployment Types and Scalability
description: Discover how Azure Local offers scalable on-premises solutions for critical workloads, from single machines to hundreds of machines, tailored to your needs.
#customer intent: As an IT admin, I want to understand the different Azure Local deployment types so that I can choose the best option for my organization's needs.
author: ronmiab
ms.author: robess
ms.date: 04/29/2026
ms.topic: concept-article
ms.service: azure-local
---

# Azure Local scalability and deployment types

Azure Local offers a consistent on-premises experience for your critical workloads and Arc services. It supports a wide spectrum of scale points and use cases, from a single machine up to hundreds of machines.

This article provides an overview of the different Azure Local deployment types and their scalability options to help you choose the right solution for your organization's needs.

## About Azure Local deployment types

You can deploy Azure Local in different ways depending on your use case and needs. The following table summarizes the various Azure Local deployment types.

| Deployment type | Description |
| --- | --- |
| Hyperconverged deployments | Clusters of 1-16 machines using hyperconverged storage. <br><br>You can also attach an external SAN for more storage capacity. |
| Disaggregated deployments | Disaggregated deployments come in different sizes, from a single machine footprint to a maximum of 64 machines that use SAN storage. |
| Multi-rack deployments | Integrated racks of compute, storage, and networking that expand up to hundreds of machines. |
| Disconnected deployments | Disconnected operations for Azure Local enable you to deploy and manage Azure Local instances without a connection to the Azure public cloud. |
| Microsoft 365 Local deployments | Deployments for hosting Microsoft 365 Local workloads. |

## Hyperconverged deployments

Hyperconverged deployments are the most common type of Azure Local deployment. They provide maximum flexibility, a range of sizes, and various networking architectures. The minimum footprint is a single machine. Most customers choose to deploy Azure Local to a cluster of machines for increased scale and resiliency. Hyperconverged deployments support cluster sizes of up to 16 machines for standard clusters, and up to 8 machines for rack aware clusters.

You can select hardware that suits your needs in the Azure Local Catalog from leading Original Equipment Manufacturer (OEM) partners.

For more information about hyperconverged deployments, see [What are hyperconverged deployments of Azure Local?](./overview/hyperconverged-overview.md)

## Disaggregated deployments

Disaggregated deployments separate compute and storage, so you can scale each independently based on your workload requirements. These deployments can range from a single machine to a maximum of 64 machines that use SAN storage.

For more information about disaggregated deployments, see [What are disaggregated deployments of Azure Local?](./overview/disaggregated-overview.md)

## Multi-rack deployments

For large workloads, Azure Local provides multi-rack deployments that can accommodate hundreds of machines in a single instance. These deployments require a prescriptive set of hardware that includes compute, storage, and networking. The hardware comes in preintegrated racks with built-in fault tolerance.

For more information about multi-rack deployments, see [What are multi-rack deployments of Azure Local?](./multi-rack/multi-rack-overview.md)

## Disconnected deployments

Azure Local is typically deployed as a cloud-connected solution with the control plane running in an Azure cloud region. For customers with the strictest sovereignty or security requirements, you can also deploy Azure Local as a disconnected solution. Disconnected operations for Azure Local provides a local instance of the control plane, with a subset of Azure capabilities - enabling you to operate without a connection to the cloud.

For more information about disconnected operations, see [Disconnected operations for Azure Local](./manage/disconnected-operations-overview.md).

## Microsoft 365 Local deployments

Specific reference architectures exist for Azure Local deployments that run Microsoft 365 Local applications. For more information about Microsoft 365 Local, see [Microsoft 365 Local](/azure/azure-sovereign-clouds/private/m365-local/microsoft-365-local-overview).

## Next steps

Read about the different Azure Local deployment types:

- [What are hyperconverged deployments of Azure Local?](./overview/hyperconverged-overview.md)
- [What are disaggregated deployments of Azure Local?](./overview/disaggregated-overview.md)
- [What are multi-rack deployments of Azure Local?](./multi-rack/multi-rack-overview.md)
- [Disconnected operations for Azure Local overview](./manage/disconnected-operations-overview.md)
- [Microsoft 365 Local overview](/azure/azure-sovereign-clouds/private/m365-local/microsoft-365-local-overview)
