---
title: Azure Kubernetes Service on Azure Stack Hub overview for users
description: Learn about Azure Kubernetes Service (ASK) on Azure Stack Hub overview for users.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.date: 02/27/2025
ms.author: sethm
ms.reviewer: sumsmith
ms.lastreviewed: 02/27/2025

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub overview for users

> [!IMPORTANT]
> Azure Kubernetes Service on Azure Stack Hub, previously a preview feature, was discontinued and is no longer supported. See the [AKS engine](../user/azure-stack-kubernetes-aks-engine-overview.md) documentation for a Kubernetes solution on Azure Stack Hub.

Azure Kubernetes Service (AKS) makes it easy to deploy a Kubernetes cluster in Azure and Azure Stack Hub. AKS reduces the complexity and operational overhead of managing Kubernetes clusters.

As a managed Kubernetes service, Azure Stack Hub handles critical tasks such as health monitoring, and facilitates maintenance for you. The Azure Stack Hub team manages the image used for maintaining the clusters. The cluster administrator only needs to apply the updates as needed. The services come at no extra cost. AKS is free; you only pay to use the VMs (master and agent nodes) within your clusters. It's simpler to use than the [AKS engine](azure-stack-kubernetes-aks-engine-overview.md) since it removes some of the manual tasks required with the AKS engine.

## AKS on Azure Stack Hub

You can manage AKS clusters on Azure Stack Hub in the same way you do on the Azure cloud using the same Azure CLI, Azure Stack Hub user portal, Azure Resource Manager templates, and REST API. When you deploy an AKS cluster, the Kubernetes master and all nodes are deployed and configured for you.

For more information on Kubernetes concepts, check out the [Kubernetes documentation](https://kubernetes.io/docs/concepts/). For a complete documentation of the AKS Service on global Azure refer to the docs at [Azure Kubernetes Service](/azure/aks/).

## User roles and responsibilities

[Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub/) is an on-premises system that customers can use inside their datacenters to run their cloud-native workloads. These systems support two user types: the [cloud operator](/azure-stack/operator/) and a [user](/azure-stack/user/). 

The following tasks fall on the Azure Stack Hub operator:

1. Make sure that the Azure Kubernetes Service base images are available in the Azure Stack Hub instance. If necessary, download them from Azure.
1. Make sure that the Azure Kubernetes Service is available for customers plans and user subscriptions, as is the case with any other service in Azure Stack Hub.
1. Monitor the Azure Kubernetes Service and act on any alert and associated remediation.
1. For details on the Operator tasks see [Install and offer the Azure Kubernetes Service on Azure Stack Hub](../operator/aks-add-on.md)

The following tasks correspond to the user; that is, the tenant AKS cluster administrator:

1. Monitor the Kubernetes cluster agents' health and act on any event and associated remediation. Even though the agents are created within the tenant subscription, the service monitors their state and performs remediation steps as needed. However, there might be support scenarios in which the Tenant Cluster Administrator is needed to bring back the cluster to a healthy state.
1. Use the Azure Kubernetes Service facilities to manage the lifecycle of the cluster, for creation, upgrade, and scale operations.
1. Maintenance operations: deploy applications, backup and restore, troubleshooting, collection of logs, and monitoring apps.
1. For Details on the tenant tasks see [ Using Azure Kubernetes Service on Azure Stack Hub with the CLI](aks-how-to-use-cli.md)

## Feature comparison

The following table provides an overview of features of AKS in global Azure compared to the features in Azure Stack Hub.

| Area                         | Feature                                             | Azure AKS | Azure Stack Hub AKS |
|------------------------------|-----------------------------------------------------|-----------|---------|
| Access security              |                                                     |           |         |
|                              | Kubernetes RBAC                                     | Yes       | Yes     |
|                              | Security Center integration                         | Yes       | Yes     |
|                              | Microsoft Entra auth/RBAC                                  | Yes       | No      |
|                              | Calico network policy                               | Yes       | No      |
| Monitoring and logging         |                                                     |           |         |
|                              | Integrated Azure monitoring (Insights, Logs, Metrics, Alerts) | Yes       | No     |
|                              | Monitoring and remediation of master nodes          | Yes       | Yes     |
|                              | Cluster metrics                                     | Yes       | Yes     |
|                              | Advisor recommendations                             | Yes       | No      |
|                              | Diagnostic settings                                 | Yes       | Yes     |
|                              | Kubernetes control plane logs                              | Yes       | Yes     |
|                              | Workbooks                                           | Yes       | No      |
| Clusters and nodes             |                                                     |           |         |
|                              | Automatic node scaling (Autoscaler)                 | Yes       | No      |
|                              | Directed node scaling                               | Yes       | Yes     |
|                              | Automatic pod scaling                               | Yes       | Yes     |
|                              | GPU enable pods                                     | Yes       | No      |
|                              | Storage volume support                              | Yes       | Yes     |
|                              | Multiple node pool management                        | Yes       | No      |
|                              | Azure Container Instance integration and virtual nodes | Yes       | No      |
|                              | Uptime SLA                                          | Yes       | No      |
|                              | Hidden master nodes                                 | Yes       | No      |
| Virtual Networks and ingress |                                                     |           |         |
|                              | Default VNET                                        | Yes       | Yes     |
|                              | Custom VNET                                         | Yes       | Yes     |
|                              | HTTP ingress                                        | Yes       | No      |
| Development tooling          |                                                     |           |         |
|                              | Helm                                                | Yes       | Yes     |
|                              | Dev Studio                                          | Yes       | No      |
|                              | DevOps Starter                                      | Yes       | No      |
|                              | Docker image support and private container registry | Yes       | Yes     |
| Certifications               |                                                     |           |         |
|                              | CNCF-certified                                      | Yes       | Yes     |
| Cluster lifecycle management |                                                     |           |         |
|                              | AKS Ux                                              | Yes       | Yes     |
|                              | AKS CLI (Windows and Linux)                        | Yes       | Yes     |
|                              | AKS API                                             | Yes       | Yes     |
|                              | AKS templates                                       | Yes       | Yes     |
|                              | AKS PowerShell                                      | Yes       | No      |

## Differences between Azure and Azure Stack Hub

AKS on Azure and on Azure Stack Hubs share the same source repository. There are no conceptual differences between the two. However, operating in different environments brings along differences to keep in mind when using AKS on Azure Stack Hub. Most of the differences are related to the system residing inside customers' Data Centers and related to functionality that isn't yet available in Azure Stack Hub.

### Connected or Disconnected Azure Stack Hub in customer's data center

In both scenarios, Azure Stack Hub is under the control of the customer. Also, customers may deploy Azure Stack Hub in fully disconnected, an *air-gapped*, environment. You might want to consider the following factors:

- Operators:
  - Ensure that the AKS service and corresponding images are available to tenants.
  - Partner with tenants and Microsoft Support when solving support incidents (for example, collecting stamp logs). See the operator article for more details.
- Tenants:
  - Collaborate with the stamp operator to request AKS base images or the AKS service to not be available in the stamp.
  - Also collaborate with the operator and Microsoft Support during support cases. One task is the collection of AKS cluster-related logs using the [information provided here](https://github.com/msazurestackworkloads/azurestack-gallery/tree/master/diagnosis#troubleshooting-aks-cluster-issues-on-azure-stack).

### Connect to Azure Stack Hub using the CLI or PowerShell

When you use the Azure CLI to connect to Azure, the CLI binary defaults to using Microsoft Entra ID for authentication and the global Azure Resource Manager endpoint for APIs. You can use also use the Azure CLI with Azure Stack Hub. However, you must explicitly connect to the Azure Stack Hub Azure Resource Manager endpoint and use either Microsoft Entra ID or Active Directory Federated Services (AD FS) for authentication. The reason is that Azure Stack Hub is meant to work within enterprises, and they may choose AD FS in disconnected scenarios.

1. For information about how to connect to Azure Stack Hub using either Microsoft Entra ID or AD FS identities using PowerShell, see [Connect to Azure Stack Hub with PowerShell as a user](azure-stack-powershell-configure-user.md).
1. [See this article](azure-stack-version-profiles-azurecli2.md) for connecting using Azure CLI with either Microsoft Entra ID or AD FS identities.

### Supported platform features

Azure Stack Hub supports a subset of the features available in global Azure. Note the following differences:

- No Standard Load Balancer. Azure Stack Hub only supports the basic load balancer. This support implies that the following features, which depend on the standard load balancer, aren't yet available with AKS on Azure Stack Hub:
  - No parameter for [API server authorized IP ranges](/azure/aks/api-server-authorized-ip-ranges).
  - No parameter for [load balancer managed ip count](/azure/aks/load-balancer-standard#scale-the-number-of-managed-outbound-public-ips).
  - No parameter for [enabling private cluster](/azure/aks/private-clusters).
  - No [cluster autoscaler](/azure/aks/cluster-autoscaler).
  - [az aks update](/cli/azure/aks#az-aks-update) isn't available.
  - No multiple node pool support. The node pool commands aren't available.
  - UI support for multiple node pool operations isn't enabled.
- No Azure regions or Availability Zones.
- No Availability Sets, only virtual machine scale sets.
- Review command list for supported and unsupported commands.

### Supported services

The absence of some Azure services limits some functionality options in AKS on Azure Stack Hub:

- No file service. There's no support for file service-based volumes in Kubernetes on Azure Stack Hub.
- No Azure Log Analytics and Azure Container Monitor. Any Kubernetes cluster can be connected to Azure Container Monitor as long as it's connected to the internet. If it's disconnected, there's no equivalent service locally in Azure Stack Hub. Therefore, there's no integrated support for Azure Container Monitor in AKS on Azure Stack Hub.
- No Azure DevOps. Since this service isn't available for a disconnected Azure Stack Hub, there's no integrated support for it.

### Supported AKS API and Kubernetes versions

Often, AKS on Azure Stack Hub falls behind Azure in the versions supported for Kubernetes and AKS API. This lack of support is due to the difficulties of shipping code for customers to run in their own datacenters.

### Default Azure AKS CLI parameter values to change when using AKS CLI on Azure Stack Hub

Given the differences between the two platforms, some default values of parameters in commands and API that work on Azure AKS, don't work on Azure Stack Hub AKS. For example:

| Common parameters                 |Notes |
| ---                 | --- |
| `--service-principal  --client-secret`  | Azure Stack Hub doesn't support managed identities yet; service principal credentials are always needed. |
| `--location`                            | The location value is specific to the customer's chosen one. |

<a name='service-principals-can-be-provided-by-azure-ad-or-ad-fs'></a>

### Service principals can be provided by Microsoft Entra ID or AD FS

Service principals (SPN) are a requirement for creating and managing an AKS cluster. Since Azure Stack Hub can be deployed in disconnected mode from the internet, it must have an alternative identity manager to Microsoft Entra ID available. Therefore, Active Directory Federated Services (AD FS) is used. How Azure Stack Hub tenants create SPNs is documented here:

- [Microsoft Entra SPN](../operator/give-app-access-to-resources.md?tabs=az1&az2&pivots=state-connected#overview)
- [AD FS SPN](../operator/give-app-access-to-resources.md?tabs=az1&az2&pivots=state-disconnected#create-app-registration-client-secret-adfs)

## Next steps

[Learn how to use AKS on Azure Stack Hub](aks-how-to-use-cli.md)
