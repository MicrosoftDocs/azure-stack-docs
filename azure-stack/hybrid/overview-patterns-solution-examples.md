---
title: Hybrid patterns and solution examples for Azure and Azure Stack
description: An overview of hybrid design patterns and solution examples, which are useful for learning about and building hybrid solutions on Azure and Azure Stack.
author: BryanLa
ms.service: azure-stack
ms.topic: overview
ms.date: 10/31/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 10/31/2019
---

# Hybrid patterns and solution examples for Azure and Azure Stack

Microsoft Azure Stack is an extension of Azure. Azure Stack brings the agility of cloud computing to your on-premises environment, and to the edge by enabling a hybrid cloud. You can build hybrid cloud apps in Azure and deploy them to your connected or disconnected datacenter located anywhere.

Microsoft Azure is a consistent hybrid cloud. Azure allows you to reuse code developed in Azure and deploy your app to sovereign Azure clouds and Azure Stack. Applications that span clouds are also referred to as *hybrid applications*.

Hybrid scenarios vary greatly with the resources that are available for development. They also span considerations such as geography, security, Internet access, and others. Although the patterns and solutions presented may not address all requirements, they can provide key guidelines and examples to explore in implementing hybrid solutions.

## Design patterns

Design patterns cull generalized and repeatable design guidance, from real world customer scenarios and experiences. A pattern is abstract, and can be applicable to several scenarios and industries. 

- [Cross-cloud scaling pattern](solution-overview-cross-cloud-scaling.md)
- [Geo-distributed pattern](solution-overview-geo-distributed.md)
- [DevOps hybrid CI/CD pattern](solution-overview-cicd-pipeline.md)

## Solution examples

Solution examples provide implementation guidance, which demonstrates a solution based on one or more patterns. The table of contents (TOC) provides content to assist in learning about and deploying each solution example:

- An overview of the solution example.
- A step-by-step deployment guide. The guide may also refer to a companion code sample, stored in the GitHub [solutions sample repo](https://github.com/Azure-Samples/azure-intelligent-edge-patterns). 

There are two types of solution examples:

- Single-pattern: demonstrates the implementation of a general-purpose solution based on a single pattern.
- Multi-pattern: demonstrate the implementation of an industry-specific solution, based on multiple patterns.

### Single-pattern

- [Deploy apps across both Azure and Azure Stack](solution-deployment-guide-cicd-pipeline.md)
- [Deploy apps to Azure Stack and Azure](solution-deployment-guide-hybrid.md)
- [Configure hybrid cloud identity with Azure and Azure Stack apps](solution-deployment-guide-identity.md)
- [Configure hybrid cloud connectivity with Azure and Azure Stack](solution-deployment-guide-connectivity.md)
- [Create a tiered data solution with Azure and Azure Stack](solution-deployment-guide-tiered-data.md)
- [Create cross-cloud scaling solutions with Azure](solution-deployment-guide-cross-cloud-scaling.md)
- [Create a geo-distributed app solution with Azure and Azure Stack](solution-deployment-guide-geo-distributed.md)
- [Deploy a hybrid cloud solution with Azure and Azure Stack](solution-deployment-guide-hybrid.md)
- [Deploy MongoDB in Azure and Azure Stack](solution-deployment-guide-mongodb-ha.md)
- [Deploy SQL Server 2016 in Azure and Azure Stack](solution-deployment-guide-sql-ha.md)

### Multi-pattern

- [Footfall detection solution for analyzing visitor traffic in retail stores](solution-overview-retail-footfall-detection.md)

## Next steps

- Explore the "Patterns" and "Solution examples" sections of the TOC, to learn more about each.
- Read the about [Design Considerations for Hybrid Applications](overview-app-design-considerations.md) to review pillars of software quality for designing, deploying, and operating hybrid applications.
- [Set up a development environment on Azure Stack](../user/azure-stack-dev-start.md) and [deploy your first app](../user/azure-stack-dev-start-deploy-app.md) on Azure Stack.
