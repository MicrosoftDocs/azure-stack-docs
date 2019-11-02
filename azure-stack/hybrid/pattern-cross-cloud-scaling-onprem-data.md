---
title: Pattern for building an application that scales cross-cloud and uses on-prem data, on Azure and Azure Stack Hub.
description: Learn how to use Azure and Azure Stack Hub, to build a scalable cross-cloud application that uses on-prem data.
author: BryanLa
ms.service: azure-stack
ms.topic: article
ms.date: 11/05/2019
ms.author: bryanla
ms.reviewer: anajod
ms.lastreviewed: 11/05/2019
---

# Cross-cloud scaling (on-premises data) pattern

Learn how to build a hybrid application that spans both Azure and Azure Stack Hub, but uses a single on-prem data source.

## Context and problem

Many organizations collect and store substantial amounts of customer-sensitive data and are often prevented from storing that data in the public cloud due to corporate regulations or government policy. Those organizations want to take advantage of the scalability of the public cloud to deal with seasonal peaks in traffic and to be able to pay for exactly the hardware they need, when they need it.

## Solution

The solution takes advantage of the compliance benefits of the private cloud, and combines them with the scalability of the public cloud. Using Azure and Azure Stack, a consistent hybrid cloud, developers are able to take advantage of the vast Microsoft developer ecosystem and apply their skills to both public cloud and on-premises environments.

We’ve created a workflow that allows developers to deploy an identical web application to a public and private cloud and be able access a non-internet routable network hosted on the private cloud. These web applications are monitored and upon a significant increase in traffic, a program can trigger the manipulation of DNS records to redirect traffic to the public cloud, and vice versa when traffic is no longer significant.

[![cross-cloud scaling with on-prem data architecture](media/pattern-cross-cloud-scaling-onprem-data/solution-architecture.png)](media/pattern-hybrid-app/solution-architecture.png#lightbox)

## Components

This solution uses the following components:

| Layer | Component | Description |
|----------|-----------|-------------|
| Azure |  |  |
| | Azure App Services | [Azure App Services](/azure/app-service/) allow you to build and host web apps, mobile back ends, and RESTful APIs in the programming language of your choice, without managing infrastructure. |
| | Azure Virtual Network| [Azure Virtual Network (VNet)](/azure/virtual-network/virtual-networks-overview) is the fundamental building block for private networks in Azure. VNet enables multiple Azure resource types, such as Virtual Machines (VM), to securely communicate with each other, the internet, and on-premises networks. The solution also demonstrates the use of additional networking components:<br>- application and gateway subnets<br>- a local on-premises network gateway<br>- a virtual network gateway, which acts as a site-to-site VPN gateway connection<br>- a public IP address<br>- a point-to-site VPN connection<br>- Azure DNS for hosting DNS domains and providing name resolution |
| | Azure Traffic Manager | [Azure Traffic Manager](/azure/traffic-manager/traffic-manager-overview) is a DNS-based traffic load balancer, allowing you to control the distribution of user traffic for service endpoints in different datacenters. |
| | Azure Application Insights | [Application Insights](/azure/azure-monitor/app/app-insights-overview) is an extensible Application Performance Management service, for web developers building and managing apps on multiple platforms.|
| | Azure Functions | [Azure Functions](/azure/azure-functions/) let you execute your code in a serverless environment without having to first create a VM or publish a web application. |
| | Azure Autoscale | [Autoscale](/azure/azure-monitor/platform/autoscale-overview) is a built-in feature of Cloud Services, Virtual Machines, and Web apps. The feature allows applications to perform their best when demand changes. Apps will adjust for traffic spikes, notifying you when metrics change, and scaling as needed. |
| Azure Stack Hub |    |             |
| | Compute, SQL Server VM | Use the same application model, self-service portal, and APIs enabled by Azure. Azure Stack IaaS allows for a broad range of open source technologies for consistent hybrid cloud deployments. |
| Azure DevOps | | |
| | Azure DevOps Account | Quickly set up continuous integration for build, test and deployment. For more information, see [Sign up, sign in to Azure DevOps](/azure/devops/user-guide/sign-up-invite-teammates?view=azure-devops). |

## Issues and considerations

Consider the following points when deciding how to implement this solution:

### Scalability 


### Availability


### Manageability


### Security


## Next steps

To learn more about topics introduced in this article:
- See [Hybrid application design considerations](overview-app-design-considerations.md) to learn more about best practices, and answer additional questions.
- This pattern uses the Azure Stack family of products, including Azure Stack Hub. See the [Azure Stack family of products and solutions](/azure-stack), to learn more about the entire portfolio of products and solutions.

When you're ready to test the solution example, continue with the [Cross-cloud scaling (on-premises data) solution deployment guide](solution-deployment-guide-cross-cloud-scaling-onprem-data.md). The deployment guide provides step-by-step instructions for deploying and testing its components. 


You learn how to create a cross-cloud solution to provide a manually triggered process for switching from an Azure Stack Hub hosted web app, to an Azure hosted web app. You also learn how to use autoscaling via traffic manager, ensuring flexible and scalable cloud utility when under load.