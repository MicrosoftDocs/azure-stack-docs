---
title: Use built-in RBAC roles to manage Azure Local VMs for multi-rack deployments (Preview)
description: Learn how to use RBAC built-in roles to manage Azure Local VMs for multi-rack deployments (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/14/2025
---

# Use Role-based Access Control to manage Azure Local VMs for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to use Role-based Access Control (RBAC) to control access to Azure Local virtual machines (VMs) for multi-rack deployments.

You can use the RBAC roles to control access to VMs and VM resources such as virtual disks, network interfaces, VM images, logical networks, and virtual networks. You can assign these roles to users, groups, service principals, and managed identities.

## Multi-team operational model

The following section explains an operational model and associated custom role definitions that Microsoft provides merely as a reference. You can choose to disregard this model and create custom roles that work for your organization.

Given the scale of Azure Local for multi-rack deployments, this guide assumes that a central team operates and administers it but shares it across many application teams. Under this model, we assume two primary user personas: infrastructure admins and application admins.

- **Infrastructure admins**: This persona administers shared platform resources, owning Azure Local platform assets (clusters, logical networks, Public IPs) that require additional admin overview and maintaining governance.  

- **Application admins**: This persona administers shared platform resources, owning Azure Local platform assets (clusters, logical networks, Public IPs) that require additional admin overview and maintaining governance.

> [!NOTE]
> While the use of separate subscriptions to disaggregate responsibility across various personas is supported, the subscriptions must exist within the same Microsoft Entra tenant.

### Control split 

In this operational paradigm, we assume a shared access model. Infrastructure teams own shared resources such as internal networks and logical networks. Application teams own application-specific resources such as VMs.

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
> The infrastructure/workload resource classification shown previously is guidance provided by Microsoft as a baseline. You can choose to use your own approach to configuring RBAC based on your specific team structures, operational models, and governance requirements.

### Custom roles 

Based on the control split of resource ownership and access, we recommend the following custom roles be created and assigned to application teams for tenant resource creation:

- **Infrastructure network consumer role**: Consume shared infrastructure network resources. **Scope**: Infrastructure subscription or application-specific resource group.

- **Workload VM contributor role**: Gives application teams least privileged access to consume shared infrastructure network resources. **Scope**: Infrastructure subscription or application-specific resource group.

For more information, see [Custom role definitions](#custom-role-definitions).

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

- Make sure that you complete the Azure Local requirements for multi-rack deployments.

- Make sure that you have access to an Azure subscription as an Owner or User Access Administrator to assign roles to others.

## Create custom roles

To control access to Azure Local VM and workload resources, you can create custom roles as needed. Custom roles can be created using the Azure portal, Azure PowerShell, Azure CLI, or the REST API.

1. **Determine permissions you need for the custom role**. When you create a custom role, you need to know the actions that are available to define your permissions. You can add the actions to the Actions or NotActions properties of the [role definition](/azure/role-based-access-control/role-definitions). If you have data actions, you can add them to the DataActions or NotDataActions properties.

    For multi-rack deployments, we recommend the following [Custom role definitions](#custom-role-definitions) to be used as a starting point.

1. **Decide how you want to create the custom role**. You can create custom roles using [Azure portal](/azure/role-based-access-control/custom-roles-portal), [Azure PowerShell](/azure/role-based-access-control/custom-roles-powershell), [Azure CLI](/en-us/azure/role-based-access-control/custom-roles-cli), or the [REST API](/azure/role-based-access-control/custom-roles-rest).

1. **Create the custom role**. The easiest way is to use the Azure portal. For steps on how to create a custom role using the Azure portal, see  [Create or update Azure custom roles using the Azure portal](/azure/role-based-access-control/custom-roles-portal).

1. **Test the custom role**. Once you have your custom role, you have to test it to verify that it works as you expect. If you need to adjust later, you can update the custom role.

## Assign custom roles to users

After you create the custom roles according to your requirements, you can assign them to users, user groups, service principals, or managed identities. Use Azure CLI or Azure portal to assign the roles.

- **Azure CLI**: To assign RBAC roles via Azure CLI, see [Assign Azure roles using Azure CLI](/azure/role-based-access-control/role-assignments-cli).

- **Azure portal**: To assign RBAC roles via Azure portal, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

## Custom role definitions

You can use the following role examples as a starting point to determine which permissions are needed and create custom roles as needed.  

### Azure Local Infrastructure Network Reader
Allows consuming shared infrastructure network resources for  workload deployments. 

`{  "Name": "Azure Local Infrastructure Network Consumer",  "Id": "2f3baa15-1dc2-4f2d-9db7-22377a75481b",  "IsCustom": true,  "Description": "Allows consuming shared infrastructure network resources for cross-subscription workload deployments.",  "Actions": [    "Microsoft.AzureStackHCI/LogicalNetworks/Read",    "Microsoft.AzureStackHCI/LogicalNetworks/join/action",    "Microsoft.AzureStackHCI/publicIPAddresses/Read", 
"Microsoft.AzureStackHCI/publicIPAddresses/join/action", 
"Microsoft.ExtendedLocation/customLocations/Read",    "Microsoft.ExtendedLocation/customLocations/deploy/action",    "Microsoft.NetworkCloud/clusters/read"  ],  "NotActions": [],  "DataActions": [],  "NotDataActions": [],  "AssignableScopes": ["/subscriptions/6331f5e9-a352-4c5d-b2dd-51da18d8c243"]}`

### Azure Local Workload VM Contributor

Comprehensive role for managing VMs, NICs, disks, and consuming shared infrastructure resources in workload subscriptions.

`{  "Name": "Azure Local Workload VM Contributor",  "Id": "a21d23da-3565-43d2-9960-0660a1791ea2",  "IsCustom": true,  "Description": "Comprehensive role for managing VMs, NICs, disks and consuming shared infrastructure resources in workload subscriptions.",  "Actions": [    "Microsoft.AzureStackHCI/VirtualMachines/*",    "Microsoft.AzureStackHCI/virtualMachineInstances/*",    "Microsoft.AzureStackHCI/NetworkInterfaces/*",    "Microsoft.AzureStackHCI/VirtualHardDisks/*",    "Microsoft.AzureStackHCI/GalleryImages/*",    "Microsoft.AzureStackHCI/loadBalancers/*",    "Microsoft.AzureStackHCI/natGateways/*",    "Microsoft.AzureStackHCI/VirtualNetworks/*",    "Microsoft.AzureStackHCI/NetworkSecurityGroups/*",    "Microsoft.Insights/AlertRules/Write",    "Microsoft.Insights/AlertRules/Delete",    "Microsoft.Insights/AlertRules/Read",    "Microsoft.Insights/AlertRules/Activated/Action",    "Microsoft.Insights/AlertRules/Resolved/Action",    "Microsoft.Insights/AlertRules/Throttled/Action",    "Microsoft.Insights/AlertRules/Incidents/Read",    "Microsoft.Resources/deployments/read",    "Microsoft.Resources/deployments/write",    "Microsoft.Resources/deployments/delete",    "Microsoft.Resources/deployments/cancel/action",    "Microsoft.Resources/deployments/validate/action",    "Microsoft.Resources/deployments/whatIf/action",    "Microsoft.Resources/deployments/exportTemplate/action",    "Microsoft.Resources/deployments/operations/read",    "Microsoft.Resources/deployments/operationstatuses/read",    "Microsoft.Resources/subscriptions/resourcegroups/deployments/read",    "Microsoft.Resources/subscriptions/resourcegroups/deployments/write",    "Microsoft.Resources/subscriptions/resourcegroups/deployments/operations/read",    "Microsoft.Resources/subscriptions/resourcegroups/deployments/operationstatuses/read",    "Microsoft.ResourceHealth/availabilityStatuses/read",    "Microsoft.Authorization/*/read",    "Microsoft.Resources/subscriptions/read",    "Microsoft.Resources/subscriptions/resourceGroups/read",    "Microsoft.Resources/subscriptions/operationresults/read",    "Microsoft.HybridCompute/machines/read",    "Microsoft.HybridCompute/machines/write",    "Microsoft.HybridCompute/machines/delete",    "Microsoft.HybridCompute/machines/UpgradeExtensions/action",    "Microsoft.HybridCompute/machines/assessPatches/action",    "Microsoft.HybridCompute/machines/installPatches/action",    "Microsoft.HybridCompute/machines/extensions/read",    "Microsoft.HybridCompute/machines/extensions/write",    "Microsoft.HybridCompute/machines/extensions/delete",    "Microsoft.HybridCompute/operations/read",    "Microsoft.HybridCompute/locations/operationresults/read",    "Microsoft.HybridCompute/locations/operationstatus/read",    "Microsoft.HybridCompute/machines/patchAssessmentResults/read",    "Microsoft.HybridCompute/machines/patchAssessmentResults/softwarePatches/read",    "Microsoft.HybridCompute/machines/patchInstallationResults/read",    "Microsoft.HybridCompute/machines/patchInstallationResults/softwarePatches/read",    "Microsoft.HybridCompute/locations/updateCenterOperationResults/read",    "Microsoft.HybridCompute/machines/hybridIdentityMetadata/read",    "Microsoft.HybridCompute/osType/agentVersions/read",    "Microsoft.HybridCompute/osType/agentVersions/latest/read",    "Microsoft.HybridCompute/machines/runcommands/read",    "Microsoft.HybridCompute/machines/runcommands/write",    "Microsoft.HybridCompute/machines/runcommands/delete",    "Microsoft.HybridCompute/machines/licenseProfiles/read",    "Microsoft.HybridCompute/machines/licenseProfiles/write",    "Microsoft.HybridCompute/machines/licenseProfiles/delete",    "Microsoft.HybridCompute/licenses/read",    "Microsoft.HybridCompute/licenses/write",    "Microsoft.HybridCompute/licenses/delete",Microsoft.KubernetesConfiguration/extensions/read  ],  "NotActions": [],  "DataActions": [],  "NotDataActions": [],  "AssignableScopes": [    "/subscriptions/fca2e8ee-1179-48b8-9532-428ed0873a2e"  ]}`
