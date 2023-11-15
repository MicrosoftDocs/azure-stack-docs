---
title: Azure Kubernetes Service on Azure Stack Hub overview for users
description: Learn about Azure Kubernetes Service (ASK) on Azure Stack Hub overview for users.
author: sethmanheim
ms.topic: article
ms.date: 10/26/2021
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub overview for users

Azure Kubernetes Service (AKS) makes it simple to deploy a Kubernetes cluster in Azure and Azure Stack Hub. AKS reduces the complexity and operational overhead of managing Kubernetes clusters.

As a managed Kubernetes service, Azure Stack Hub handles critical tasks like health monitoring and facilitates maintenance for you. The Azure Stack team manages the image used for maintaining the clusters. The cluster administrator will only need to apply the updates as needed. The services come at no extra cost. AKS is free: you only pay to use the VMs (master and agent nodes) within your clusters. It is simpler to use than [AKS engine](azure-stack-kubernetes-aks-engine-overview.md) since it removes some of the manual tasks required with AKS engine.

> [!IMPORTANT]
> Azure Kubernetes Service on Azure Stack Hub, currently in preview, is being discontinued and will not become GA. See [AKS Engine](../user/azure-stack-kubernetes-aks-engine-overview.md) for a Kubernetes solution on Azure Stack Hub. 
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.


## AKS on Azure Stack Hub

You can manage AKS clusters on Azure Stack Hub in the same way you do on the Azure cloud using the same Azure CLI, Azure Stack Hub user portal, Azure Resource Manager templates, and REST API. When you deploy an AKS cluster, the Kubernetes master and all nodes are deployed and configured for you.

For more information on Kubernetes concepts, check out the [Kubernetes documentation](https://kubernetes.io/docs/concepts/). For a complete documentation of the AKS Service on global Azure refer to the docs at [Azure Kubernetes Service](/azure/aks/).

## User roles and responsibilities

[Azure Stack Hub](https://azure.microsoft.com/products/azure-stack/hub/) is an on-premises system that customers can use inside their datacenters to run their cloud-native workloads. These systems support two user types: the [cloud operator](/azure-stack/operator/) and a [user](/azure-stack/user/). 

The following tasks fall on the **Azure Stack Hub Operator**:

1. Make sure that the Azure Kubernetes Service base images are available in the Azure Stack Hub instance, this includes downloading them from Azure.
2. Make sure that the Azure Kubernetes Service is available for customers plans and user subscriptions, as is the case with any other service in Azure Stack Hub.
3. Monitor the Azure Kubernetes Service and act on any alert and associated remediation.
4. For details on the Operator tasks see [Install and offer the Azure Kubernetes Service on Azure Stack Hub](../operator/aks-add-on.md)

The following tasks correspond to the user, that is, the **Tenant AKS Cluster Administrator**:

1. Monitor the Kubernetes cluster agents' health and act on any event and associated remediation. Even though the masters are created within the tenant subscription, the service will monitor their state and will perform remediation steps as needed. However, there may be support scenarios in which the Tenant Cluster Administrator may be needed to bring back the cluster to a healthy state. 
2. Use the Azure Kubernetes Service facilities to manage the lifecycle of the cluster, that is creation, upgrade, and scale operations.
3. Maintenance operations: deploy applications, backup and restore, troubleshooting, collection of logs, and monitoring apps.
4. For Details on the tenant tasks see [ Using Azure Kubernetes Service on Azure Stack Hub with the CLI](aks-how-to-use-cli.md)

## Feature comparison

The following table provides an overview of features of AKS in global Azure compared to the features in Azure Stack Hub.

| Area                         | Feature                                             | Azure AKS | Azure Stack Hub AKS |
|------------------------------|-----------------------------------------------------|-----------|---------|
| Access Security              |                                                     |           |         |
|                              | Kubernetes RBAC                                     | Yes       | Yes     |
|                              | Security Center Integration                         | Yes       | Yes     |
|                              | Microsoft Entra auth/RBAC                                  | Yes       | No      |
|                              | Calico Network Policy                               | Yes       | No      |
| Monitoring & Logging         |                                                     |           |         |
|                              | Integrated Azure Monitoring (Insights, Logs, Metrics, Alerts) | Yes       | No     |
|                              | Monitoring and Remediation of Master Nodes          | Yes       | Yes     |
|                              | Cluster Metrics                                     | Yes       | Yes     |
|                              | Advisor Recommendations                             | Yes       | No      |
|                              | Diagnostic settings                                 | Yes       | Yes     |
|                              | Kubernetes Control Plane Logs                              | Yes       | Yes     |
|                              | Workbooks                                           | Yes       | No      |
| Clusters & Nodes             |                                                     |           |         |
|                              | Automatic Node Scaling (Autoscaler)                 | Yes       | No      |
|                              | Directed Node Scaling                               | Yes       | Yes     |
|                              | Automatic Pod Scaling                               | Yes       | Yes     |
|                              | GPU Enable Pods                                     | Yes       | No      |
|                              | Storage Volume Support                              | Yes       | Yes     |
|                              | Multi node pool Management                           | Yes       | No      |
|                              | Azure Container Instance Integration & Virtual Node | Yes       | No      |
|                              | Uptime SLA                                          | Yes       | No      |
|                              | Hidden Master Nodes                                 | Yes       | No      |
| Virtual Networks and Ingress |                                                     |           |         |
|                              | Default VNET                                        | Yes       | Yes     |
|                              | Custom VNET                                         | Yes       | Yes     |
|                              | HTTP Ingress                                        | Yes       | No      |
| Development Tooling          |                                                     |           |         |
|                              | Helm                                                | Yes       | Yes     |
|                              | Dev Studio                                          | Yes       | No      |
|                              | DevOps Starter                                      | Yes       | No      |
|                              | Docker image support and private container registry | Yes       | Yes     |
| Certifications               |                                                     |           |         |
|                              | CNCF-certified                                      | Yes       | Yes     |
| Cluster Lifecycle Management |                                                     |           |         |
|                              | AKS Ux                                              | Yes       | Yes     |
|                              | AKS CLI (Windows and Linux)                        | Yes       | Yes     |
|                              | AKS API                                             | Yes       | Yes     |
|                              | AKS Templates                                       | Yes       | Yes     |
|                              | AKS PowerShell                                      | Yes       | No      |

## Differences between Azure and Azure Stack Hub

AKS on Azure and on Azure Stack Hubs share the same source repository. There are no conceptual differences between the two. However, operating in different environments brings along differences to keep in mind when using AKS on Azure Stack Hub. Most of the differences are related to the system residing inside customers' Data Centers and related to functionality that is not yet available in Azure Stack Hub.

### Connected or Disconnected Azure Stack Hub in customer's data center 

In both scenarios, Azure Stack Hub is under the control of the customer. Also, customers may deploy Azure Stack Hub in fully disconnected, an *air-gapped*, environment. You may want to consider the following factors:

 - For Operators:
   * They need to ensure the AKS Service and corresponding images are available to Tenants.
   * They need to partner with tenants and Microsoft Support when solving support incidents (ex: collecting stamp logs). See the Operator article for more details.
 - For Tenants:
   * They need to collaborate with the stamp Operator to request AKS base Images or AKS Service not available in the stamp.
   * They also need to collaborate with the Operator and Microsoft Support during Support Cases. One task would be the collection of AKS cluster-related logs using the information provided [here](https://github.com/msazurestackworkloads/azurestack-gallery/tree/master/diagnosis#troubleshooting-aks-cluster-issues-on-azure-stack).

### Connect to Azure Stack Hub using the CLI or PowerShell

When you use the Azure CLI to connect to Azure, the CLI binary will default to using Microsoft Entra ID for authentication and the global Azure Resource Manager endpoint for APIs. You can use also use Azure CLI with Azure Stack Hub. However, you will need to explicitly connect to the Azure Stack Hub Azure Resource Manager endpoint and use either Microsoft Entra ID or Active Directory Federated Services (AD FS) for authentication. The reason is that Azure Stack Hub is meant to work within enterprises, and they may choose AD FS in disconnected scenarios.

1.  For information on how to connect to Azure Stack Hub using either Microsoft Entra ID or AD FS identities using PowerShell, see [Connect to Azure Stack Hub with PowerShell as a user](azure-stack-powershell-configure-user.md).

2.  Use [this](azure-stack-version-profiles-azurecli2.md) one for connecting using Azure CLI with either Microsoft Entra ID or AD FS identities.

### Supported platform features

Azure Stack Hub supports a subset of the features available in global Azure. Take note of the following differences:

 - No Standard Load Balancer. Azure Stack Hub only supports basic load balancer, this implies that the following features, which depend on Standard Load Balancer are not yet available with AKS on Azure Stack Hub:
    * No parameter api-server-authorized-ip-ranges </azure/aks/api-server-authorized-ip-ranges>
    * No parameter load-balancer-managed-ip-count [/azure/aks/load-balancer-standard\#scale-the-number-of-managed-outbound-public-ips](/azure/aks/load-balancer-standard#scale-the-number-of-managed-outbound-public-ips)
    * No parameter enable-private-cluster </azure/aks/private-clusters>
    * No cluster autoscaler: </azure/aks/cluster-autoscaler>
    * No parameter enable-cluster-autoscaler
    * [az aks update](/cli/azure/aks#az-aks-update) not available.
    * No multiple node-pool support. The node pool commands are not available.
    * UI support for multi-node-pool operations is not enabled.
 - No Azure Regions or Availability Zones
 - No Availability Sets, only virtual machine scale sets
 - Review command list for supported and unsupported commands.

### Supported services

Absence of some Azure services limits some functionality options on AKS on Azure Stack Hub:

 - No Files Service. This makes it so that there is no support for File Service based volumes in Kubernetes in Azure Stack Hub.
 - No Azure Log Analytics and Azure Container Monitor. Any Kubernetes cluster can be connected to Azure Container Monitor as long as it is connected to the internet, if it is disconnected there is no equivalent service locally in Azure Stack Hub. So there is not integrated support for Azure Container Monitor in AKS on Azure Stack Hub.
 - No Azure DevOps. Since this service is not available for a disconnected Azure Stack Hub, there is no integrated support for it.

### Supported AKS API and Kubernetes versions

It will often be the case that Azure Stack Hub AKS will fall behind Azure in the versions supported for Kubernetes and AKS API. This is due to the fact of the difficulties of shipping code for customers to run in their own Data Centers.

### Default Azure AKS CLI parameter values to change when using AKS CLI on Azure Stack Hub

Given the differences between the two platforms outlined above, the user should be aware that some default values in parameters in commands and API that work on Azure AKS, do not in Azure Stack Hub AKS. For example:

| Common parameters                 |Notes |
| ---                 | --- |
| `--service-principal  --client-secret`  | Azure Stack Hub does not support managed identities yet; service principal credentials are always needed. |
| `--load-balancer-sku basic`             | Azure Stack Hub does not support standard load balancer (SLB) yet. |
| `--location`                            | The location value is specific to the customer's chosen one. |

<a name='service-principals-can-be-provided-by-azure-ad-or-ad-fs'></a>

### Service principals can be provided by Microsoft Entra ID or AD FS

Service principals (SPN) are a requirement for creating and managing an AKS cluster. Since Azure Stack Hub can be deployed in disconnected mode from the internet, it must have available an alternative Identity manager to Microsoft Entra ID, therefore Active Directory Federated Services (AD FS) is used. How Azure Stack Hub tenants create SPNs is documented here:

- [Microsoft Entra SPN](../operator/give-app-access-to-resources.md?tabs=az1&az2&pivots=state-connected#overview)
- [AD FS SPN](../operator/give-app-access-to-resources.md?tabs=az1&az2&pivots=state-disconnected#create-app-registration-client-secret-adfs)

## Next steps

[Learn how to use AKS on Azure Stack Hub](aks-how-to-use-cli.md)
