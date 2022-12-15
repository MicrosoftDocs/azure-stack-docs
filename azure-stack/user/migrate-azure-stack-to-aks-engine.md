---
title: Migrate workloads from AKS on Azure Stack Hub to AKS Engine on Azure Stack Hub
description: Find out how to migrate workloads from AKS on Azure Stack Hub to AKS Engine, and compare supported Azure Kubernetes Service features.
author: sethmanheim
ms.topic: article
ms.date: 12/15/2022
ms.author: sethm
ms.reviewer: sethm
ms.lastreviewed: 12/14/2022

# Intent: As an Azure Stack operator, I need to know how to migrate my existing AKS deployments to AKS Engine and what to expect after the applications are migrated.
# Keyword: Kubernetes AKS Engine difference
---

# Migrate workloads from AKS on Azure Stack Hub to AKS Engine on Azure Stack Hub

This article tells how to migrate existing workloads on the Azure Kubernetes Service (AKS) on Azure Stack Hub preview to AKS Engine on Azure Stack Hub, and summarizes feature differences between the services. The AKS on Azure Stack Hub preview is being deprecated in favor of extending support for AKS Engine on Hub.

To learn more about AKS Engine, see the [AKS Engine overview](azure-stack-kubernetes-aks-engine-overview.md) and reiew the [feature comparison table](#compare-aks-engine-features-with-aks) in this article.

## Migrate workloads to AKS Engine

You can run AKS and AKS Engine at the same time. To minimize application downtime, you should deploy and validate workloads on AKS Engine before you delete your AKS clusters.  

To move workloads to AKS Engine, do the following steps:

1. [Meet the prerequisites for AKS Engine](azure-stack-kubernetes-aks-engine-set-up.md).

1. [Deploy a cluster with AKS Engine](azure-stack-kubernetes-aks-engine-deploy-cluster.md).

1. Deploy your running workloads on AKS Engine.

1. Verify that your newly deployed workloads are running successfully on AKS Engine.

1. (Optional) After you make sure the workloads are running on AKS Engine, [delete deployed AKS clusters](aks-how-to-use-cli.md?view=azs-2206&preserve-view=true&tabs=windows%2Clinuxcon#delete-cluster).

## Compare AKS Engine features with AKS

The following table compares features of AKS in global Azure with the features available in AKS on Azure Stack Hub and in AKS Engine.

| Area                         | Feature                                             | Azure AKS | Azure Stack Hub AKS preview<sup>1</sup> | AKS Engine on Azure Stack Hub |
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
|                              | Diagnostic settings                                 | Yes       | Yes                           | No<sup>2</sup>    |
|                              | Kubernetes Control Plane Logs                       | Yes       | Yes                           | No<sup>3</sup>    |
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
|                              | AKS portal                                          | Yes       | Yes                           | No                |
|                              | AKS CLI (Windows and Linux)                         | Yes       | Yes                           | No                |
|                              | AKS API                                             | Yes       | Yes                           | No                |
|                              | AKS Templates                                       | Yes       | Yes                           | No                |
|                              | AKS PowerShell                                      | Yes       | No                            | No                |

<sup>1</sup>Discontinued.
<sup>2</sup>To collect diagnostic logs, the user can log in to the VM to gather this information.
<sup>3</sup>AKS Engine isn't a managed service, so these logs don't exist. To collect diagnostic information, log in to the VM to gather this information.

## Next steps

- [Learn more about AKS Engine](azure-stack-kubernetes-aks-engine-overview.md)
- 