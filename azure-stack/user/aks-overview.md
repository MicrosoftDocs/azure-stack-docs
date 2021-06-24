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

The purpose of the public preview is to collect feedback about the quality, features, and user experience of the Azure Kubernetes Service on Azure Stack Hub.

## What is Azure Kubernetes Service on Azure Stack Hub?

Azure Kubernetes Service (AKS) makes it simple to deploy a Kubernetes cluster in Azure and Azure Stack Hub. Azure Kubernetes Service reduces the complexity and operational overhead of managing Kubernetes clusters. As a hosted Kubernetes service, Azure Stack Hub handles critical tasks like health monitoring and facilitates maintenance for you. The Azure Stack team manages the image used for maintaining the clusters. The cluster administrator will only need to apply the updates as needed. The services come at no extra cost. Azure Kubernetes Service is free: you only pay to use the VMs (master and agent nodes) within your clusters. It is simpler to use than AKS engine since it offloads some of the manual tasks required with AKS Engine to the service itself.

You can manage AKS clusters on Azure Stack Hub in the same way you do on the Azure cloud using the same CLI, Ux, Templates, and API. When you deploy an Azure Kubernetes Service cluster, the Kubernetes master and all nodes are deployed and configured for you.

For more information on Kubernetes concepts, see the [Kubernetes documentation](https://kubernetes.io/docs/concepts/). For a complete documentation of the AKS Service on Azure find it [here](https://docs.microsoft.com/en-us/azure/aks/).

# User roles and responsibilities 

[Azure Stack Hub](https://azure.microsoft.com/en-us/products/azure-stack/hub/) (Azure Stack Hub) is an on-premise system that customers can use inside their datacenters to run their cloud-native workloads. These systems support two user types: an [Operator](https://docs.microsoft.com/en-us/azure-stack/operator/) and a [Tenant](https://docs.microsoft.com/en-us/azure-stack/user/). In the specific context of AKS here are their tasks:

The following tasks fall on the **Azure Stack Hub Operator**:

1.  Make sure that the Azure Kubernetes Service base images are available in the stamp, this includes downloading them from Azure.
2.  Make sure that the Azure Kubernetes Service is available for customers plans and user subscriptions, as is the case with any other service in Azure Stack Hub.
3.  Monitor the Azure Kubernetes Service and act on any alert and associated remediation.
4.  For details on the Operator tasks see \<TODO: Link to Operator doc\>

The following tasks correspond to the **Tenant** **AKS Cluster Administrator**:

1.  Monitor the Kubernetes cluster agents' health and act on any event and associated remediation. Even though the masters are created within the tenant subscription, the service will monitor their state and will perform remediation steps as needed. However, there may be support scenarios in which the Tenant Cluster Administrator may be needed to bring back the cluster to a healthy state.
2.  Use the Azure Kubernetes Service facilities to manage the lifecycle of the cluster, that is creation, upgrade, and scale operations.
3.  Maintenance operations: deploy applications, back up and restore, troubleshooting, collection of logs, and monitoring apps.
4.  For Details on the Tenant tasks see \<TODO: Link to Quick Guide\>

# Feature area support comparison

The purpose of the following table is to provide a high-level view of what features areas from Azure AKS and available in Azure Stack Hub.

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

# Differences between Azure and Hub

AKS on Azure and on Azure Stack Hub share the same source repository. There are no conceptual differences between the two. However, operating in different environments brings along differences to keep in mind when using AKS on Azure Stack Hub. Most of the differences are on functionality that is not yet available in Azure Stack Hub. Here they are:

1.  **Connected or Disconnected Azure Stack Hub stamps in customer's data center**. In both scenarios, the stamps are under the control of the customer. Also, customers may deploy Azure Stack Hub in fully disconnected ("Air-gap") environments. This brings along 3 main factors:
    1.  **Support Engineers do not have direct access to the stamp**. Engineers work with the customer to troubleshoot issues in live sessions or by examining logs provided by the customer.
    2.  **"Breaking Glass".** Customers cannot access the Azure Stack Hub infrastructure without the authorization of a CSS support engineer through a process we refer to as "Braking Glass" or "Use the PEP" (Privilege Endpoint). This is only necessary when the information provided by Alerts and Logs is not sufficient to diagnose a problem or is needed to implement the mitigation steps. This step is authorized by Azure Stack Hub CSS engineer and carried out in collaboration with the customer. For more information, see this [article](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-privileged-endpoint?view=azs-2102).
    3.  **All troubleshooting occurs through Alerts that the system produces or through examining logs**:
        1.  For information on Monitoring and Alerting see this [article](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-monitor-health?view=azs-2102).
        2.  For information on how Azure Stack Hub customers get help from Microsoft and collect logs (including AKS logs) see this [article](https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-help-and-support-overview?view=azs-2102). Customers have three options to [collect logs](https://docs.microsoft.com/en-us/azure-stack/operator/diagnostic-log-collection?view=azs-2102) depending on their requirements:
-   [Send logs proactively (recommended)](https://docs.microsoft.com/en-us/azure-stack/operator/diagnostic-log-collection?view=azs-2102#send-logs-proactively)
-   [Send logs now](https://docs.microsoft.com/en-us/azure-stack/operator/diagnostic-log-collection?view=azs-2102#send-logs-now)
-   [Save logs locally](https://docs.microsoft.com/en-us/azure-stack/operator/diagnostic-log-collection?view=azs-2102#save-logs-locally)
    1.  Troubleshooting [guide](https://microsoft.sharepoint.com/teams/AzureStack/_layouts/15/Doc.aspx?sourcedoc=%7b79e49f73-5568-4688-ba5b-4b87a20ea293%7d&action=edit&wd=target%28Kubernetes%20-%20Public.one%7Cbf5f365a-e7eb-452d-8b15-514f7fe96f82%2FAKS%20Service%20Troubleshooting%20Guide%20for%20Engineer%20Team%20%20CSS%7C9b73ca46-e863-4ecf-bdca-3a092cda7440%2F%29&wdorigin=703) for CSS
1.  **Users connecting to Azure Stack Hub using the CLI or PowerShell**. When you use the Azure CLI to connect to Azure, the CLI binary will default to using AAD for authentication and the global Azure Azure Resource Manager endpoint for APIs. You can use the same Azure CLI on Azure Stack Hub. But the user needs to explicitly connect to the Azure Stack Hub Azure Resource Manager endpoint and use either AAD or AD FS for authentication. The reason is that Azure Stack Hub is meant to work within enterprises, and they may choose AD FS in disconnected scenarios.
    1.  For information on how to connect to Azure Stack Hub using either AAD or AD FS identities using PowerShell see this [article](https://docs.microsoft.com/en-us/azure-stack/user/azure-stack-powershell-configure-user?view=azs-2102&tabs=az1%2Caz2%2Caz3%2Caz4).
    2.  Use [this](https://docs.microsoft.com/en-us/azure-stack/user/azure-stack-version-profiles-azurecli2?view=azs-2102&tabs=ad-win) one for connecting using Azure CLI with either AAD or AD FS identities.
2.  **Supported platform features**. Another area of differences resides in the features provided by each platform. Azure Stack Hub provides a subset of the features available in Azure. This limits the features offered in Azure Stack Hub AKS:
    1.  No Standard Load Balancer. Now Azure Stack Hub only supports Basic Load Balancer, this implies that the following features, which depend on SLB are not yet available on Azure Stack Hub AKS RP:
3.  No parameter api-server-authorized-ip-ranges <https://docs.microsoft.com/en-us/azure/aks/api-server-authorized-ip-ranges>
4.  No parameter load-balancer-managed-ip-count [https://docs.microsoft.com/en-us/azure/aks/load-balancer-standard\#scale-the-number-of-managed-outbound-public-ips](https://docs.microsoft.com/en-us/azure/aks/load-balancer-standard#scale-the-number-of-managed-outbound-public-ips)
5.  No parameter enable-private-cluster <https://docs.microsoft.com/en-us/azure/aks/private-clusters>
6.  No cluster autoscaler: <https://docs.microsoft.com/en-us/azure/aks/cluster-autoscaler>
    1.  No parameter enable-cluster-autoscaler
7.  [az aks update](https://docs.microsoft.com/en-us/cli/azure/aks?view=azure-cli-latest#az_aks_update) not available**.**
8.  No multiple node-pool support. The node pool commands are not available.
9.  UI support for multi-node-pool operations is not enabled.
10. Windows containers \<todo\>
    1.  No Azure Regions or Availability Zones
    2.  No Availability Sets, only virtual machine scale sets
    3.  Review command list for supported and unsupported commands.
11. **Supported services**. Absence of some Azure services limits some functionality options on Azure Stack Hub AKS RP:
    1.  No Files Service. This makes it so that there is no support for File Service based volumes in K8s in Azure Stack Hub. \<TODO\>
    2.  No Azure Log Analytics and Azure Container Monitor. Any Kubernetes cluster can be connected to Azure Container Monitor as long as it is connected to the internet, if it is disconnected there is no equivalent service locally in Azure Stack Hub. So there is not integrated support for Azure Container Monitor in Azure Stack Hub AKS RP. \<TODO\>
    3.  No Azure DevOps. Since this service is not available for disconnected Azure Stack Hub stamps, there is no integrated support for it. \<TODO\>
12. **Supported AKS API and Kubernetes versions**. It will often be the case that Azure Stack Hub AKS will fall behind Azure in the versions supported for Kubernetes and AKS API. This is due to the fact of the difficulties of shipping code for customers to run in their own Data Centers.
13. **Default Azure AKS CLI parameter values to change when using AKS CLI on Azure Stack Hub**. Given the differences between the two platforms outlined above, the user should be aware that some default values in parameters in commands and API that work on Azure AKS, do not in Azure Stack Hub AKS. For example:

| **Common Parameters**                 | **Notes**                                                                                     |
|---------------------------------------|-----------------------------------------------------------------------------------------------|
| --service-principal  --client-secret  | Azure Stack Hub does not support Managed Identities yet; Service Principal credentials are always needed. |
| --load-balancer-sku basic             | Azure Stack Hub does not support Standard Load Balancer yet (SLB).                                        |
| --location                            | The location value is specific to the customer's chosen one.                                  |
|                                       |                                                                                               |

## Next steps

[Learn how to use AKS on Azure Stack Hub](aks-how-to-use.md)