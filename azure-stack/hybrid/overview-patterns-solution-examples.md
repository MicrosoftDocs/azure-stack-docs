---
title: Hybrid patterns and solution examples for Azure and Azure Stack
description: An overview of hybrid patterns and solution examples, useful for learning and building hybrid solutions on Azure and Azure Stack.
author: BryanLa
ms.topic: overview
ms.date: 11/05/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 11/05/

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---


# Hybrid patterns and solution examples for Azure and Azure Stack

Microsoft provides Azure and Azure Stack products and solutions as one consistent Azure ecosystem. The Microsoft Azure Stack family is an extension of Azure. 

## The hybrid cloud and hybrid apps

Azure Stack brings the agility of cloud computing to your on-premises environment and the edge, by enabling a *hybrid cloud*. Azure Stack Hub, Azure Stack HCI, and Azure Stack Edge extend Azure from the cloud into your sovereign datacenters, branch offices, field, and beyond. With this diverse set of capabilities, you can:

- Reuse code and run cloud-native apps consistently across Azure and your on-premises environments.
- Run traditional virtualized workloads with optional connections to Azure services.
- Transfer data to the cloud, or keep it in your sovereign datacenter to maintain compliance.
- Run hardware-accelerated machine-learning, containerized, or virtualized workloads, all at the intelligent edge.

Applications that span clouds are also referred to as *hybrid applications*. You can build hybrid cloud apps in Azure and deploy them to your connected or disconnected datacenter located anywhere.

Hybrid application scenarios vary greatly with the resources that are available for development. They also span considerations such as geography, security, Internet access, and others. Although the patterns and solutions described here may not address all requirements, they provide guidelines and examples to explore and reuse while implementing hybrid solutions.

## Design patterns

Design patterns cull generalized repeatable design guidance, from real world customer scenarios and experiences. A pattern is abstract, allowing it to be applicable to different types of scenarios or vertical industries. Each pattern documents the context and problem, and provides an overview of a solution example. The solution example is meant as a possible implementation of the pattern.

There are two types of pattern articles:

- Single pattern: provides design guidance for a single general-purpose scenario.
- Multi-pattern: provides design guidance where the application of multiple patterns is used. This is frequently required for solving more complex scenarios, or industry-specific problems.

## Solution deployment guides

Step-by-step deployment guides assist in deploying a solution example. The guide may also refer to a companion code sample, stored in the GitHub [solutions sample repo](https://github.com/Azure-Samples/azure-intelligent-edge-patterns). 

## Next steps

- See the [Azure Stack family of products and solutions](/azure-stack), to learn more about the entire portfolio of products and solutions.
- Explore the "Patterns" and the "Solution deployment guides" sections of the TOC, to learn more about each.
- Read about [Hybrid application design considerations](overview-app-design-considerations.md) to review pillars of software quality for designing, deploying, and operating hybrid applications.
- [Set up a development environment on Azure Stack](../user/azure-stack-dev-start.md) and [deploy your first app](../user/azure-stack-dev-start-deploy-app.md) on Azure Stack.
