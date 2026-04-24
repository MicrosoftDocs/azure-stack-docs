---
title: Access and identity options for Azure Kubernetes Service (AKS) on Azure Local for multi-rack deployments
description: Learn about access and identity management options for Kubernetes clusters in AKS on Azure Local.
ms.topic: concept-article
ms.date: 04/24/2026
ms.author: davidsmatlak
author: sanjanamsft
---

# Access and identity options for AKS enabled Azure Arc (multi-rack)

You can authenticate, authorize, secure, and control access to Kubernetes clusters with [Kubernetes role-based access control (Kubernetes RBAC)](#kubernetes-rbac). You can grant users, groups, and service accounts access to only the Kubernetes resources they need. Kubernetes RBAC helps you secure your cluster access and provide only the minimum required permissions to developers and operators.

This article introduces the core concepts that help you authenticate and assign permissions in AKS.

> [!NOTE]
> - The "Microsoft Entra ID with Azure role-based access control (Azure RBAC) for Kubernetes authorization" scenario isn't currently available on multi-rack deployments.
> - Azure RBAC isn't currently supported on multi-rack deployments.

## Kubernetes RBAC

Kubernetes RBAC provides granular filtering of user actions. With this control mechanism:

- You assign users or user groups permission to create, read, update, or delete resources or view logs from running application workloads.
- You can scope permissions to a single namespace or across the entire AKS cluster.
- You create _roles_ to define permissions, and then assign those roles to users with _role bindings_.

For more information, see [Using Kubernetes RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

> [!NOTE]
> Kubernetes RBAC is enabled by default. No flags required in CLI to manually enable it.

### Roles and ClusterRoles

In Kubernetes RBAC, you define permissions as a role.

#### Roles

Before assigning permissions to users with Kubernetes RBAC, you define user permissions as a role. Grant permissions within a Kubernetes namespace using roles.

Kubernetes roles grant permissions but they don't deny permissions. To grant permissions across the entire cluster or to cluster resources outside a given namespace, you can use _ClusterRoles_.

#### ClusterRoles

A ClusterRole grants and applies permissions to resources across the entire cluster, not a specific namespace.

### RoleBindings and ClusterRoleBindings

Once you define roles to grant permissions to resources, you assign those Kubernetes RBAC permissions with a _RoleBinding_.

#### RoleBindings

Assign roles to users for a given namespace using RoleBindings. With RoleBindings, you can logically segregate a single AKS cluster, only enabling users to access the application resources in their assigned namespace.

To bind roles across the entire cluster, or to cluster resources outside a given namespace, use _ClusterRoleBindings_.

#### ClusterRoleBinding

With a ClusterRoleBinding, you bind roles to users and apply to resources across the entire cluster, not a specific namespace. This approach lets you grant administrators or support engineers access to all resources in the AKS cluster.

## Kubernetes service accounts

_Service accounts_ are one of the primary user types in Kubernetes. The Kubernetes API holds and manages service accounts. Service account credentials are stored as Kubernetes secrets, allowing them to be used by authorized pods to communicate with the API server. Most API requests provide an authentication token for a service account or a standard user account.

Standard user accounts allow more traditional access for human administrators or developers, not just services and processes. While Kubernetes doesn't provide an identity management solution to store regular user accounts and passwords, you can integrate external identity solutions into Kubernetes.

## Current limitations

The following security features aren't currently available on AKS on Azure Local for multi-rack deployments:

| Feature | Status | Notes |
|---|---|---|
| Azure RBAC for Kubernetes authorization | Not available | The `enableAzureRBAC` field is accepted in the API schema but isn't currently enforced. Use Kubernetes RBAC. |
| OIDC issuer / Workload identity | Not available | Workload identity federation isn't currently supported on AKS on Azure Local for multi-rack deployments. |
| SSH access restriction (`authorizedIPRanges`) | Not available | The `clusterVMAccessProfile.authorizedIPRanges` field is accepted in the API schema but isn't currently enforced. |
| Microsoft Entra ID integration| Not available | Microsoft Entra ID integration isn't currently available on AKS on Azure Local for multi-rack deployments. |

## Summary

The following steps are how users can authenticate to Kubernetes when Microsoft Entra integration is enabled.

1. Run `az login` and authenticate to Azure.
1. Connect to the cluster (for example, using `az connectedk8s proxy`).
1. Run `kubectl` commands.
   The first command can trigger browser-based authentication to authenticate to the Kubernetes cluster.

## Next steps

To learn about Kubernetes RBAC, see [Using Kubernetes RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).
