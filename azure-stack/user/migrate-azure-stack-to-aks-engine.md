---
title: Migrate workloads to AKS engine from AKS on Azure Stack Hub preview
description: Find out how to migrate workloads from AKS on Azure Stack Hub to a Kubernetes cluster created in AKS engine. Compare supported Azure Kubernetes Service features.
author: sethmanheim
ms.topic: article
ms.date: 12/20/2022
ms.author: sethm
ms.reviewer: summer.smith
ms.lastreviewed: 12/14/2022

# Intent: As an Azure Stack operator, I need to know how to migrate my existing AKS deployments to Kubernetes clusters created using AKS engine and what to expect after I migrate the applications.
# Keyword: Kubernetes AKS Engine difference
---

# Migrate workloads to AKS engine from AKS on Azure Stack Hub preview

This article tells how to migrate existing workloads in the Azure Kubernetes Service (AKS) on Azure Stack Hub preview to AKS engine on Azure Stack Hub, and summarizes AKS feature differences. The AKS on Azure Stack Hub preview is being deprecated in favor of extending support for AKS engine.

[AKS engine](https://github.com/Azure/aks-engine) provides a command-line tool to bootstrap Kubernetes clusters on Azure and Azure Stack Hub. By using Azure Resource Manager, AKS engine helps you create and maintain clusters running on VMs, virtual networks, and other Azure infrastructure as a service (IaaS) resources in Azure Stack Hub. To learn more about AKS engine, see the [AKS engine overview](azure-stack-kubernetes-aks-engine-overview.md), and review the [AKS engine feature comparison](#compare-features-aks-engine-vs-aks-preview) in this article.

## Migrate workloads to AKS engine

You can run AKS and AKS engine on Azure Stack Hub at the same time. To minimize application downtime, deploy and verify workloads on AKS engine before you delete your AKS clusters.

To move workloads to AKS engine, do the following steps:

1. Meet the [prerequisites for AKS engine](azure-stack-kubernetes-aks-engine-set-up.md#prerequisites-for-the-aks-engine).

1. [Deploy a cluster using AKS engine](azure-stack-kubernetes-aks-engine-deploy-cluster.md).

1. Deploy your running workloads on the Kubernetes cluster created with AKS engine.

1. Verify that your newly deployed workloads are running successfully on AKS engine.

1. (Optional) [Delete your deployed AKS clusters](aks-how-to-use-cli.md?view=azs-2206&preserve-view=true&tabs=windows%2Clinuxcon#delete-cluster) after you verify a successful deployment via AKS engine.

## Compare features: AKS engine vs. AKS preview

The following table compares AKS features in global Azure with features in the AKS on Azure Stack Hub preview, which is being deprecated, and AKS engine on Azure Stack Hub.

| Area                         | Feature                                             | Azure AKS | Azure Stack Hub AKS preview **(1)** | AKS engine on Azure Stack Hub |
|------------------------------|-----------------------------------------------------|-----------|-------------------------------|-------------------|
| Access Security              |                                                     |           |                               |                   |
|                              | Kubernetes RBAC                                     | Yes       | Yes                           | Yes               |
|                              | Security Center Integration                         | Yes       | Yes                           | Yes               |  
|                              | Azure AD Auth/RBAC                                  | Yes       | No                            | No                |
|                              | Calico Network Policy                               | Yes       | No                            | No                |
| Monitoring & Logging         |                                                     |           |                               |                   |
|                              | Integrated Azure Monitoring (Insights, Logs, Metrics, Alerts)   | Yes     | No                  | Yes               |
|                              | Monitoring and Remediation of Master Nodes          | Yes       | Yes                           | No                |
|                              | Cluster Metrics                                     | Yes       | Yes                           | Yes               |  
|                              | Advisor Recommendations                             | Yes       | No                            | No                |
|                              | Diagnostic settings                                 | Yes       | Yes                           | No **(2)**        |
|                              | Kubernetes Control Plane Logs                       | Yes       | Yes                           | No **(3)**        |
|                              | Workbooks                                           | Yes       | No                            | No                |
| Clusters & Nodes             |                                                     |           |                               |                   |
|                              | Automatic Node Scaling (Autoscaler)                 | Yes       | No                            | No                |
|                              | Automatic Pod Scaling                               | Yes       | Yes                           | Yes               |
|                              | GPU Enable Pods                                     | Yes       | No                            | No                |
|                              | Storage Volume Support                              | Yes       | Yes                           | Yes               |
|                              | Multi node pool Management                          | Yes       | No                            | No                |
|                              | Azure Container Instance Integration & Virtual Node | Yes       | No                            | No                |
|                              | Uptime SLA                                          | Yes       | No                            | No                |
|                              | Hidden Master Nodes                                 | Yes       | No                            | No                |
| Virtual Networks and Ingress |                                                     |           |                               |                   |
|                              | Default VNET                                        | Yes       | Yes                           | Yes               |
|                              | Custom VNET                                         | Yes       | Yes                           | Yes               |
|                              | HTTP Ingress                                        | Yes       | No                            | No                |
| Development Tooling          |                                                     |           |                               |                   |
|                              | Helm                                                | Yes       | Yes                           | Yes               |
|                              | Dev Studio                                          | Yes       | No                            | No                |
|                              | DevOps Starter                                      | Yes       | No                            | No                |
|                              | Docker image support and private container registry | Yes       | Yes                           | Yes               |
| Certifications               |                                                     |           |                               |                   |
|                              | CNCF-certified                                      | Yes       | Yes                           | Yes               |
| Management Interfaces        |                                                     |           |                               |                   |
|                              | AKS UX                                              | Yes       | Yes                           | No                |
|                              | AKS CLI (Windows and Linux)                         | Yes       | Yes                           | No                |
|                              | AKS API                                             | Yes       | Yes                           | No                |
|                              | AKS Templates                                       | Yes       | Yes                           | No                |
|                              | AKS PowerShell                                      | Yes       | No                            | No                |

**(1)** Discontinued.

**(2)** To collect diagnostic logs, log in to the VM to gather this information.

**(3)** AKS engine isn't a managed service, so these logs aren't created. To collect diagnostic information, log in to the VM to gather this information.

## Next steps

- [Learn more about AKS engine](azure-stack-kubernetes-aks-engine-overview.md)
