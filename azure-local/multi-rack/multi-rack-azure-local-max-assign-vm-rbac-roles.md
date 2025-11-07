---
title: Use built-in RBAC roles for to manage Azure Local VMs for multi-rack deployments (Preview)
description: Learn how to use RBAC built-in roles to manage Azure Local VMs for multi-rack deployments. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/07/2025
---

# Use Role-based Access Control to manage Azure Local VMs for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to use Role-based Access Control (RBAC) to control access to Azure Local virtual machines (VMs) for multi-rack deployments.

You can use the RBAC roles to control access to VMs and VM resources such as virtual disks, network interfaces, VM images, logical networks, virtual networks, NAT gateways, and load balancers. You can assign these roles to users, groups, service principals and managed identities.

## Multi-team operational model 

The following section explains an operational model and associated custom role definitions that Microsoft provides merely as a reference. You can choose to disregard this model and create custom roles that work for your organization.

Given that Azure Local max is multi-rack infrastructure, this guide assumes that it is operated and administered by a central team but shared across many application teams. Under this model, we assume two primary user personas, infrastructure admins and application admins:

- **Infrastructure admins**: This persona administers shared platform resources, owning core Azure Local platform assets (clusters, logical networks, Public IPs) and maintaining governance.  

- **Application admins**: This persona deploys tenant workloads in a separate subscription, managing VMs, NICs, disks, and their own networking (VNets, NSGs, NAT GWs, Load Balancers) with configuration autonomy. 

Infra and application admins use separate subscriptions but must exist within the same Microsoft Entra tenant.

### Control split 

In this operational paradigm, we assume a shared access model, where shared resources such as internal networks and logical networks are owned by the infrastructure teams and application-specific resources such as VMs are owned by the application teams.

With this assumption, here’s the sample reference pattern that forms the basis for the custom role definitions we recommend:

| Resource Type | Infrastructure Team | Application Team |
| --- | --- | --- | 
| **Subscriptions** | | |
| Subscription (Infrastructure) | Full control | Reader (discovery only) |
| Subscription (Application) | No access | Full control |
| **Resource Groups** | | |
| Resource groups (Infrastructure) | Owner | Reader (for shared resources discovery) |
| Resource groups (Application) | No access | Owner | 
| **Networking Resources** | | |
| Logical networks | Owner (create/modify/delete) | Reader + Join (attach NICs only) |
| Virtual networks | No control | Owner (full lifecycle in workload subscription) |
| Network security groups | No control | Owner (full lifecycle in workload subscription) |
| Network interfaces | No control | Owner (create/modify/delete in workload subscription) |
| **Platform Resources** | | |
| Custom locations | Owner | Deploy action (for ARM deployments) |
| Gallery images | No control | Owner (full lifecycle in workload subscription) |
| **Infrastructure Services** | | |
| Public IP addresses | Owner (create/allocate/manage) | Reader + Reference (consume allocated public IPs) |
| NAT gateways | No control | Owner (full lifecycle, uses infra-allocated public IPs) |
| Load balancers | No control | Owner (full lifecycle, uses infra-allocated public IPs) |
| **Compute Resources** | | |
| Virtual machine instances | No control | Owner (full lifecycle in workload subscription) |
| Virtual hard disks | No control | Owner (full lifecycle in workload subscription) |
| VM child resources | No control | Owner (platform-managed components) |

> [!IMPORTANT]
> The infrastructure/workload resource classification shown above is guidance provided by Microsoft as a baseline. You can choose to use your own approach to configuring RBAC based on your specific team structures, operational models, and governance requirements. 

### Custom roles 

Based on the above split of resource ownership and access, we recommend the following custom roles to be created and assigned to application teams for tenant resource creation:

- **Infrastructure network consumer role**: Consume shared infrastructure network resources. **Scope**: Infrastructure subscription or application-specific resource group.

- **Workload VM contributor role**: Complete workload VM and other workload resources lifecycle management.  **Scope**: Workload subscription or a specific resource group.

You can find the custom role definitions here.

## Prerequisites 

Before you begin, make sure to complete the following prerequisites:

- Make sure that complete the Azure Local requirements. 

- Make sure that you have access to Azure subscription as an Owner or User Access Administrator to assign roles to others.

## Create custom roles

To controll access to VM and VM resources, you can create custom roles as needed. Custom roles can be created using the Azure portal, Azure PowerShell, Azure CLI, or the REST API.

1. **Determine permissions you need for the custom role**. When you create a custom role, you need to know the actions that are available to define your permissions. You will add the actions to the Actions or NotActions properties of the role definition. If you have data actions, you will add those to the DataActions or NotDataActions properties.

    For Azure Local max, we recommend the following custom role definitions to be used as a starting point. Use this doc to learn more.

1. **Decide how you want to create the custom role**. You can create custom roles using Azure portal, Azure PowerShell, Azure CLI, or the REST API.

1. **Create the custom role**. The easiest way is to use the Azure portal. For steps on how to create a custom role using the Azure portal, see Create or update Azure custom roles using the Azure portal.

1. **Test the custom role**. Once you have your custom role, you have to test it to verify that it works as you expect. If you need to adjust later, you can update the custom role. 
 
## Assign custom roles to users

Once you’ve created the custom roles according to your requirements, you can assign these custom RBAC roles to users, user groups, service principals, or managed identities via Azure CLI or Azure portal. 

- **Azure CLI**: To assign RBAC roles via Azure CLI, see [Assign Azure roles using Azure CLI](/azure/role-based-access-control/role-assignments-cli). 

- **Azure portal**: To assign RBAC roles via Azure Portal, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal). 

