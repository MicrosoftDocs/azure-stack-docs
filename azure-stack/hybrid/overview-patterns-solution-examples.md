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

Design patterns cull generalized and repeatable design guidance, from real world customer scenarios and experiences. A pattern is abstract, allowing it to be applicable to different types of scenarios, or vertical industries. Each pattern documents the problem, an associated solution architecture, and an optional solution example. 

There are two types of patterns:

- Base pattern: provides design guidance for a single general-purpose scenario.
- Aggregate pattern: provides design guidance where the application of multiple patterns is used, to solve a scenario or industry-specific problem.

## Solution examples

Solution examples provide implementation guidance, demonstrating a solution for a given pattern. Step-by-step deployment guides assist in deploying each solution example. The guide may also refer to a companion code sample, stored in the GitHub [solutions sample repo](https://github.com/Azure-Samples/azure-intelligent-edge-patterns). 

## Next steps

- Explore the "Patterns" and "Solution examples" sections of the TOC, to learn more about each.
- Read the about [Design Considerations for Hybrid Applications](overview-app-design-considerations.md) to review pillars of software quality for designing, deploying, and operating hybrid applications.
- [Set up a development environment on Azure Stack](../user/azure-stack-dev-start.md) and [deploy your first app](../user/azure-stack-dev-start-deploy-app.md) on Azure Stack.
