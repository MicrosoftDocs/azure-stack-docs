---
title: Cross-cloud scaling pattern in Azure Stack Hub
description: Learn how to build a scalable cross-cloud app on Azure and Azure Stack Hub.
author: ronmiab 
ms.topic: article
ms.date: 04/25/2025
ms.author: robess
ms.reviewer: anajod
ms.lastreviewed: 04/05/2019

# Intent: As an Azure Stack Hub user, I want to build a scalable cross-cloud app on Azure and Azure Stack Hub.
# Keyword: cross-cloud scaling pattern azure stack hub
---

# Cross-cloud scaling pattern

Automatically add resources to an existing app to accommodate an increase in load.

## Context and problem

Your app can't increase capacity to meet unexpected increases in demand. This lack of scalability results in users not reaching the app during peak usage times. The app can service a fixed number of users.

Global enterprises require secure, reliable, and available cloud-based apps. Meeting increases in demand and using the right infrastructure to support that demand is critical. Businesses struggle to balance costs and maintenance with business data security, storage, and real-time availability.

You may not be able to run your app in the public cloud. However, it may not be economically feasible for the business to maintain the capacity required in their on-premises environment to handle spikes in demand for the app. With this pattern, you can use the elasticity of the public cloud with your on-premises solution.

## Solution

The cross-cloud scaling pattern extends an app located in a local cloud with public cloud resources. The pattern is triggered by an increase or decrease in demand, and respectively adds or removes resources in the cloud. These resources provide redundancy, rapid availability, and geo-compliant routing.

![Cross-cloud scaling pattern](media/pattern-cross-cloud-scale/cross-cloud-scaling.png)

> [!NOTE]
> This pattern applies only to stateless components of your app.

## Components

The cross-cloud scaling pattern consists of the following components.

### Outside the cloud

#### Traffic Manager

In the diagram, this is located outside of the public cloud group, but it would need to able to coordinate traffic in both the local datacenter and the public cloud. The balancer delivers high availability for app by monitoring endpoints and providing failover redistribution when required.

#### Domain Name System (DNS)

The Domain Name System, or DNS, is responsible for translating (or resolving) a website or service name to its IP address.

### Cloud

#### Hosted build server

An environment for hosting your build pipeline.

#### App resources

The app resources need to be able to scale in and scale out, like virtual machine scale sets and Containers.

#### Custom domain name

Use a custom domain name for routing requests glob.

#### Public IP addresses

Public IP addresses are used to route the incoming traffic through traffic manager to the public cloud app resources endpoint.  

### Local cloud

#### Hosted build server

An environment for hosting your build pipeline.

#### App resources

The app resources need the ability to scale in and scale out, like virtual machine scale sets and Containers.

#### Custom domain name

Use a custom domain name for routing requests glob.

#### Public IP addresses

Public IP addresses are used to route the incoming traffic through traffic manager to the public cloud app resources endpoint.

## Issues and considerations

Consider the following points when deciding how to implement this pattern:

### Scalability

The key component of cross-cloud scaling is the ability to deliver on-demand scaling. Scaling must happen between public and local cloud infrastructure and provide a consistent, reliable service per the demand.

### Availability

Ensure locally deployed apps are configured for high-availability through on-premises hardware configuration and software deployment.

### Manageability

The cross-cloud pattern ensures seamless management and familiar interface between environments.

## When to use this pattern

Use this pattern:

- When you need to increase your app capacity with unexpected demands or periodic demands in demand.
- When you don't want to invest in resources that will only be used during peaks. Pay for what you use.

This pattern isn't recommended when:

- Your solution requires users connecting over the internet.
- Your business has local regulations that require that the originating connection to come from an onsite call.
- Your network experiences regular bottlenecks that would restrict the performance of the scaling.
- Your environment is disconnected from the internet and can't reach the public cloud.

## Next steps

To learn more about topics introduced in this article:

- See the [Azure Traffic Manager overview](/azure/traffic-manager/traffic-manager-overview) to learn more about how this DNS-based traffic load balancer works.
- See the [Azure Stack family of products and solutions](/azure-stack) to learn more about the entire portfolio of products and solutions.

When you're ready to test the solution example, continue with the [Cross-cloud scaling solution deployment guide](/azure/architecture/hybrid/deployments/solution-deployment-guide-cross-cloud-scaling?toc=/hybrid/app-solutions/toc.json&bc=/hybrid/breadcrumb/toc.json). The deployment guide provides step-by-step instructions for deploying and testing its components. You learn how to create a cross-cloud solution to provide a manually triggered process for switching from an Azure Stack Hub hosted web app to an Azure hosted web app. You also learn how to use autoscaling via traffic manager, ensuring flexible and scalable cloud utility when under load.