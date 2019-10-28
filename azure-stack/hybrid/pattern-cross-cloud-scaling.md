---
title: Cross-cloud scaling pattern for the intelligent edge with Azure Stack | Microsoft Docs
description: Learn about the cross-cloud scaling pattern for the intelligent edge with Azure Stack
author: BryanLa
ms.service: azure-stack
ms.topic: article
ms.date: 10/31/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 10/31/2019
---

# Cross-cloud scaling pattern

Automatically add resources to an existing application to accommodate an increase in load.

## Context and problem

Your app cannot increase capacity to meet unexpected increased in demand. This results in users not reaching the app during peak usage times. The app can service a fixed number of users.

Global enterprises require secure, reliable, and available cloud-based applications. Meeting increases in demand, and using the right infrastructure to support that demand is critical. Businesses struggle to balance costs and maintenance with business data security, storage, and real-time availability.

You may not be able to run your application in the public cloud. However, it may not be economically feasible for the business to maintain the capacity required in their on-premises environment to handle spikes in demand for the app. With this pattern, you can use the elasticity of the public cloud with your on-premises solution.

## Solution

The cross-cloud scaling pattern extends an app located in a local cloud with public cloud resources. The pattern is triggered by an increase or decrease in demand, and respectively adds or removes resources in the cloud. These resources provide redundancy, rapid availability, and geo-compliant routing.

![Cross-cloud scaling pattern](media/solution-overview-cross-cloud-scaling/cross-cloud-scaling.png)

> Note:  
> This pattern applies only to stateless apps.

The Cross-cloud Scaling Pattern consists of the following components.

**Traffic Manager**  
**In the diagram this is located outside of the public cloud group, but it would need to able to coordinate traffic in both the local data center and the public cloud. The balancer delivers high availability for application by monitoring endpoints and providing failover redistribution when required.

**Domain Name System (DNS)**  
The Domain Name System, or DNS, is responsible for translating (or resolving) a website or service name to its IP address.

### Cloud

**Hosted Build Server**  
An environment for hosting your build pipeline.

**Application Resources**  
The application resources need to be able to scale in and scale out, such as VM ScaleSets and Containers.

**Custom Domain Name**  
Use a custom domain name for routing requests glob.

**Public IP Addresses**  
Public IP addresses are used to route the incoming traffic through traffic manager to the public cloud application resources endpoint.  

### Local cloud

**Hosted Build Server**  
An environment for hosting your build pipeline.

**Application Resources**  
The application resources need to be able to scale in and scale out, such as VM ScaleSets and Containers.

**Custom Domain Name**  
Use a custom domain name for routing requests glob.

**Public IP Addresses**  
Public IP addresses are used to route the incoming traffic through traffic manager to the public cloud application resources endpoint. 

## Issues and considerations


Consider the following points when deciding how to implement this pattern:

### Scalability considerations

The key component of cross-cloud scaling is the ability to deliver on-demand scaling between public and local cloud infrastructure, proving consistent, reliable service as prescribed by the demand.

### Availability considerations

Ensure locally deployed apps are configured for high-availability through on-premises hardware configuration and software deployment.

### Manageability considerations

The cross-cloud pattern ensures seamless management and familiar interface between environments.

#### When to use this pattern

Use this pattern:

-   When you need to increase your app capacity with unexpected demands or periodic demands in demand.

-   When you do not want to invest in resources that will only be used during peaks. Pay for what you use.

This pattern isn't recommended when:

-   Your solution requires users connecting over the internet.

-   Your business has local regulations that require that the originating connection to come from an onsite call.

-   Your network experiences regular bottlenecks that would restrict the performance of the scaling.

-   Your environment is disconnected from the Internet and cannot reach the public cloud.

## Example

Learn how to create a cross-cloud solution to provide a manually triggered process for switching from an Azure Stack hosted web app, to an Azure hosted web app with auto-scaling via traffic manager, ensuring flexible and scalable cloud utility when under load.

[Create cross-cloud scaling solutions with Azure](solution-deployment-guide-cross-cloud-scaling.md)

## Next steps

Learn about [Hybrid cloud design patterns for Azure Stack](overview-app-design-considerations.md)
