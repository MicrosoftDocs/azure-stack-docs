---
title: Migrate workloads from AKS on Azure Stack Hub to AKS Engine on Azure Stack Hub
description: Learn how to migrate workloads to AKS Engine.
author: sethmanheim
ms.topic: article
ms.date: 12/15/2022
ms.author: sethm
ms.reviewer: sethm
ms.lastreviewed: 12/14/2022

# Intent: As an Azure Stack operator, I need to konw how to migrate my existing AKS deployments to AKS Engine and what to expect after the applications are migrated.
# Keyword: Kubernetes AKS Engine difference
---

# Migrate workloads from AKS on Azure Stack Hub to AKS Engine on Azure Stack Hub

The AKS on Azure Stack Hub preview is being deprecated in favor of extending support for AKS Engine on Hub. This doc will help those of you with workloads on the AKS preview migrate to AKS Engine and outline expected feature differences between the services. To learn more about AKS Engine, see the [AKS Engine overview](azure-stack-kubernetes-aks-engine-overview.md) and the following feature comparison table.  

You can have AKS and AKS Engine running at the same time. To minimize application downtime, we recommend deploying and validating workloads on AKS Engine before deleting your AKS clusters.  

Recommended steps to move workloads to AKS Engine:

1. Follow the documentation to [understand the prerequisites of AKS Engine](azure-stack-kubernetes-aks-engine-set-up.md).

1. [Deploy a cluster with AKS Engine](azure-stack-kubernetes-aks-engine-deploy-cluster.md).

1. Deploy the workloads that are running on AKS Engine.

1. Validate that your workloads are running successfully on AKS Engine. 

1. (Optional) Once the newly deployed workloads have been validated, [delete deployed AKS clusters](aks-how-to-use-cli.md?view=azs-2206&preserve-view=true&tabs=windows%2Clinuxcon#delete-cluster).

## Feature comparison

The following table provides an overview of features of AKS in global Azure compared to the features in Azure Stack Hub.

| Area                         | Feature                                             | Azure AKS | Azure Stack Hub AKS preview<sup>1</sup> | AKS Engine on Hub |
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
| Cluster Lifecycle Management |                                                     |           |                               |                   |
|                              | AKS Ux                                              | Yes       | Yes                           | No                |
|                              | AKS CLI (Windows and Linux)                         | Yes       | Yes                           | No                |
|                              | AKS API                                             | Yes       | Yes                           | No                |
|                              | AKS Templates                                       | Yes       | Yes                           | No                |
|                              | AKS PowerShell                                      | Yes       | No                            | No                |

<sup>1</sup>Discontinued.
<sup>2</sup>To collect diagnostic logs, the user can log in to the VM to gather this information.
<sup>3</sup>AKS Engine isn't a managed service, so these logs don't exist. To collect diagnostic information, log into the VM to gather this information.

## Next steps

[Learn how to use AKS on Azure Stack Hub](aks-how-to-use-cli.md)<!--Upate.-->