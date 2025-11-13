---
title: What Is Azure Local? Overview and Key Benefits
description: Learn how Azure Local accelerates cloud and AI innovation by delivering applications, workloads, and services from cloud to edge with Azure Arc as the control plane.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 11/10/2025
ms.topic: overview
---

# What is Azure Local?

Azure Local is Microsoft’s distributed infrastructure solution that extends Azure capabilities to customer-owned environments. It facilitates the local deployment of both modern and legacy applications across distributed or sovereign locations. Azure Local accelerates cloud and AI innovation by seamlessly delivering new applications, workloads, and services from cloud to edge, using Azure Arc as the unifying control plane.

The solution offers a cloud-native management experience and supports deployments that are connected or disconnected from the cloud. It uses a broad partner ecosystem by providing a comprehensive catalog and prescriptive Bill of Materials (BOMs) across hardware solution categories.

Azure Local includes all the familiar Azure management plane tooling via Azure portal, Azure CLI, and ARM templates to provision and manage resources. You can also onboard Azure services such as Azure Policy, Microsoft Defender for Cloud, Azure Monitor, and Copilot for Azure. Manage, govern, and secure your infrastructure and the workloads running on them from a single pane of glass.

Azure Local is priced per physical core on your on-premises machines, plus any consumption-based charges for additional Azure services you use. All charges roll up to your existing Azure subscription.

## Key benefits of Azure Local

Azure Local serves several key business needs such as compute needing to remain on-premises, resiliency of mission critical applications, low-latency decision-making, or adhering to specific compliance requirements.

Some examples are:

- **Local AI inferencing** where data needs to be processed at the source. Examples include retail stores implementing self-checkouts and loss prevention apps, or pipeline leak detection systems in the energy sectors.
- **Mission critical business continuity** required for systems that must continue to run through network outages. Examples include production line operations in factories or warehouses, ticketing and access controls systems in stadiums, amusement parks, and transit stations.
- **Control systems and near real-time operations** that have extreme latency requirements. Examples include manufacturing execution systems, industrial quality assurance, and financial infrastructure.
- **Strict sovereignty and regulatory requirements** requiring that data be kept and controlled locally. Examples include highly regulated industries such as defense and intelligence sectors and energy infrastructure.

Azure Local is part of Microsoft’s [adaptive cloud](https://azure.microsoft.com/solutions/adaptive-cloud) approach - bringing the cloud to you so you can build and innovate anywhere, without limits.

## Next steps

To learn more about Azure Local, see the following articles:
- Read Azure Local blog posts: [Azure Local blog](https://aka.ms/ignite25/blog/azurelocal).
- [Azure Local scalability and deployments](./scalability-deployments.md)
- [What are hyperconverged deployments for Azure Local?](./overview/hyperconverged-overview.md)
- [What are multi-rack deployments for Azure Local?](./multi-rack/multi-rack-overview.md)