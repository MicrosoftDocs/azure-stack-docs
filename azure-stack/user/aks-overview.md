---
title: Azure Kubernetes Service on Azure Stack Hub overview for users
description: Learn about Azure Kubernetes Service (ASK) on Azure Stack Hub overview for users.
author: mattbriggs
ms.topic: article
ms.date: 07/01/2021
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 07/01/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Azure Kubernetes Service on Azure Stack Hub overview for users

Azure Kubernetes Service (AKS) makes it simple to deploy a Kubernetes cluster in Azure and Azure Stack Hub. AKS reduces the complexity and operational overhead of managing Kubernetes clusters.

As a hosted Kubernetes service, Azure Stack Hub handles critical tasks like health monitoring and facilitates maintenance for you. The Azure Stack team manages the image used for maintaining the clusters. The cluster administrator will only need to apply the updates as needed. The services come at no extra cost. AKS is free: you only pay to use the VMs (master and agent nodes) within your clusters. It is simpler to use than [AKS engine](azure-stack-kubernetes-aks-engine-overview.md) since it removes some of the manual tasks required with AKS engine.

> [!IMPORTANT]
> Azure Kubernetes Service on Azure Stack Hub is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.


## AKS on Azure Stack Hub

You can manage AKS clusters on Azure Stack Hub in the same way you do on the Azure cloud using the same Azure CLI, Azure Stack Hub user portal, Azure Resource Manager templates, and REST API. When you deploy an AKS cluster, the Kubernetes master and all nodes are deployed and configured for you.

For more information on Kubernetes concepts, check out the [Kubernetes documentation](https://kubernetes.io/docs/concepts/). For a complete documentation of the AKS Service on global Azure refer to the docs at [Azure Kubernetes Service](/azure/aks/).

## User roles and responsibilities

As the **ASK cluster administrator**, you can:

1.  Monitor the Kubernetes cluster agent health and act on any event and associated remediation. Even though the masters are created within your subscription, the service will monitor their state and will perform remediation steps as needed. However, there may be situations in which the cloud operator for your Azure Stack Hub may be needed to bring back the cluster to a healthy state.
2.  Use the AKS facilities to manage the lifecycle of the cluster, that is, creation, upgrade, and scale operations.
3.  Maintenance operations: deploy applications, back up and restore, troubleshooting, collection of logs, and monitoring apps.
4.  For Details on your tasks, see [Using AKS on Azure Stack Hub](aks-how-to-use.md)

## Feature comparison

The following table provides an overview of features of AKS in global Azure compared to the features in Azure Stack Hub.

| Area                         | Feature                                             | Azure AKS | Azure Stack Hub AKS |
|------------------------------|-----------------------------------------------------|-----------|---------|
| Access Security & Monitoring |                                                     |           |         |
|                              | Kubernetes RBAC                                     | Yes       | Yes     |
|                              | Cluster Metrics                                     | Yes       | Yes     |
|                              | K8s Control Plane Logs                              | Yes       | Yes     |
|                              | Integrated Azure Log Analytics                      | Yes       | No      |
|                              | Azure AD Auth/RBAC                                  | Yes       | No      |
|                              | Integrated Azure Monitoring                         | Yes       | No      |
|                              | Monitoring and Remediation of Master Nodes          | Yes       | Yes     |
| Clusters & Nodes             |                                                     |           |         |
|                              | Automatic Node Scaling (Autoscaler)                 | Yes       | No      |
|                              | Directed Node Scaling                               | Yes       | Yes     |
|                              | Automatic Pod Scaling                               | Yes       | Yes     |
|                              | GPU Enable Pods                                     | Yes       | No      |
|                              | Storage Volume Support                              | Yes       | Yes     |
|                              | Multi-nodepool Management                           | Yes       | No      |
|                              | Azure Container Instance Integration & Virtual Node | Yes       | No      |
|                              | Hidden Master Nodes                                 | Yes       | No      |
| Virtual Networks and Ingress |                                                     |           |         |
|                              | Default VNET                                        | Yes       | Yes     |
|                              | Custom VNET                                         | Yes       | Yes     |
|                              | HTTP Ingress                                        | Yes       | \<?\>   |
| Development Tooling          |                                                     |           |         |
|                              | Helm                                                | Yes       | Yes     |
|                              | Dev Studio                                          | Yes       | \<?\>   |
|                              | DevOps Starter                                      | Yes       | No      |
|                              | Docker image support and private container registry | Yes       | Yes     |
| Certifications               |                                                     |           |         |
|                              | CNCF-certified                                      | Yes       | Yes     |
| Cluster Lifecycle Management |                                                     |           |         |
|                              | AKS Ux                                              | Yes       | Yes     |
|                              | AKS CLI                                             | Yes       | Yes     |
|                              | AKS API                                             | Yes       | Yes     |
|                              | AKS Templates                                       | Yes       | Yes     |
|                              | AKS PowerShell                                      | Yes       | \<?\>   |

## Differences between Azure and Azure Stack Hub

AKS on Azure and on Azure Stack Hubs share the same source repository. There are no conceptual differences between the two. However, operating in different environments brings along differences to keep in mind when using AKS on Azure Stack Hub. Most of the differences are on functionality that is not yet available in Azure Stack Hub.

### Connected or Disconnected Azure Stack Hub in customer's data center 

In both scenarios, Azure Stack Hub is under the control of the customer. Also, customers may deploy Azure Stack Hub in fully disconnected, an *air-gapped*, environment. You may want to consider the following factors:

1.  **Support Engineers do not have direct access**.  
    Engineers work with the customer to troubleshoot issues in live sessions or by examining logs provided by the customer.
2.  **Accessing the Privileged End Point**
    Your cloud operator can't access the Azure Stack Hub infrastructure without the authorization of a Microsoft support engineer. Accessing the privileged end point is only necessary when the information provided by alerts and logs is not sufficient to diagnose a problem or is needed to implement the mitigation steps. This step is authorized by Azure Stack Hub support engineer and carried out in collaboration with your cloud operator. For more information, see [Use the privileged endpoint in Azure Stack Hub](../operator/azure-stack-privileged-endpoint.md).
3.  **All troubleshooting occurs through alerts that the system produces or through examining logs**
    - For information on monitoring and alerts, see [Monitor health and alerts in Azure Stack Hub](../operator/azure-stack-monitor-health.md).
    - For information on how you can get help from Microsoft and collect logs (including AKS logs), see [Azure Stack Hub help and support](../operator/azure-stack-help-and-support-overview.md). Customers have three options to [collect logs](../operator/diagnostic-log-collection.md) depending on their requirements:
        -   [Send logs proactively (recommended)](../operator/diagnostic-log-collection.md#send-logs-proactively)
        -   [Send logs now](../operator/diagnostic-log-collection.md#send-logs-now)
        -   [Save logs locally](../operator/diagnostic-log-collection.md#save-logs-locally)

### Connect to Azure Stack Hub using the CLI or PowerShell

When you use the Azure CLI to connect to Azure, the CLI binary will default to using Azure Active Directory (Azure AD) for authentication and the global Azure Resource Manager endpoint for APIs. You can use also use Azure CLI with Azure Stack Hub. However, you will need to explicitly connect to the Azure Stack Hub Azure Resource Manager endpoint and use either Azure AD or Active Directory Federated Services (AD FS) for authentication. The reason is that Azure Stack Hub is meant to work within enterprises, and they may choose AD FS in disconnected scenarios.

1.  For information on how to connect to Azure Stack Hub using either Azure AD or AD FS identities using PowerShell, see [Connect to Azure Stack Hub with PowerShell as a user](azure-stack-powershell-configure-user.md).

2.  Use [this](azure-stack-version-profiles-azurecli2.md) one for connecting using Azure CLI with either Azure AD or AD FS identities.

### Supported platform features

Azure Stack Hub supports a subset of the features available in global Azure. Take note of the following differences:

1.  No Standard Load Balancer. Azure Stack Hub only supports basic load balancer, this implies that the following features, which depend on basic load balancer are not yet available with AKS on Azure Stack Hub:
3.  No parameter api-server-authorized-ip-ranges </azure/aks/api-server-authorized-ip-ranges>
4.  No parameter load-balancer-managed-ip-count [/azure/aks/load-balancer-standard\#scale-the-number-of-managed-outbound-public-ips](/azure/aks/load-balancer-standard#scale-the-number-of-managed-outbound-public-ips)
5.  No parameter enable-private-cluster </azure/aks/private-clusters>
6.  No cluster autoscaler: </azure/aks/cluster-autoscaler>
    1.  No parameter enable-cluster-autoscaler
7.  [az aks update](/cli/azure/aks?view=azure-cli-latest#az_aks_update) not available**.**
8.  No multiple node-pool support. The node pool commands are not available.
9.  UI support for multi-node-pool operations is not enabled.
10. Windows containers
1.  No Azure Regions or Availability Zones
2.  No Availability Sets, only virtual machine scale sets
3.  Review command list for supported and unsupported commands.

### Supported services

Absence of some Azure services limits some functionality options on AKS on Azure Stack Hub:

1.  No Files Service. This makes it so that there is no support for File Service based volumes in K8s in Azure Stack Hub.
2.  No Azure Log Analytics and Azure Container Monitor. Any Kubernetes cluster can be connected to Azure Container Monitor as long as it is connected to the internet, if it is disconnected there is no equivalent service locally in Azure Stack Hub. So there is not integrated support for Azure Container Monitor in AKS on Azure Stack Hub.
3.  No Azure DevOps. Since this service is not available for a disconnected Azure Stack Hub, there is no integrated support for it.

### Supported AKS API and Kubernetes versions

It will often be the case that Azure Stack Hub AKS will fall behind Azure in the versions supported for Kubernetes and AKS API. This is due to the fact of the difficulties of shipping code for customers to run in their own Data Centers.

### Default Azure AKS CLI parameter values to change when using AKS CLI on Azure Stack Hub

Given the differences between the two platforms outlined above, the user should be aware that some default values in parameters in commands and API that work on Azure AKS, do not in Azure Stack Hub AKS. For example:

| Common parameters                 |Notes |
| ---                 | --- |
| `--service-principal  --client-secret`  | Azure Stack Hub does not support Managed Identities yet; Service Principal credentials are always needed. |
| `--load-balancer-sku basic`             | Azure Stack Hub does not support Standard Load Balancer yet (SLB). |
| `--location`                            | The location value is specific to the customer's chosen one. |
## Next steps

[Learn how to use AKS on Azure Stack Hub](aks-how-to-use.md)