---
title: Access and identity options for Azure Kubernetes Service (AKS) enabled by Azure Arc
description: Learn about options in access and identity management on a Kubernetes cluster in AKS on Azure Stack HCI.
author: leslielin
ms.topic: conceptual
ms.date: 05/05/2024
ms.author: leslielin
ms.lastreviewed: 
ms.reviewer: 

# Intent: As an IT Pro, I want to learn how to improve the security of the applications and infrastructure within my AKS on Azure Stack HCI deployment(s).
# Keyword: security concepts infrastructure security


---

# Access and identity options for AKS enabled by Azure Arc 

Applies to: AKS on Azure Stack HCI 23H2

You can authenticate, authorize, secure, and control access to Kubernetes clusters in various ways:

- With Kubernetes role-based access control (Kubernetes RBAC), you can grant users, groups, and service accounts access to only the resources they need.
- With Azure Kubernetes Service (AKS) enabled by Azure Arc, you can further enhance the security and permissions structure using Microsoft Entra ID and Azure RBAC. 

Kubernetes RBAC and AKS enabled by Arc help you secure your cluster access and provide only the minimum required permissions to developers and operators.

This article introduces the core concepts that help you authenticate and assign permissions in AKS enabled by Azure Arc.

## Kubernetes RBAC

Kubernetes RBAC provides granular filtering of user actions. With this control mechanism:

- You assign users or user groups permission to create and modify resources or view logs from running application workloads.
- You can scope permissions to a single namespace or across the entire AKS cluster.
- You create *roles* to define permissions, and then assign those roles to users with *role bindings*.

For more information, see [Using Kubernetes RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).

### Roles and ClusterRoles

#### Roles

Before assigning permissions to users with Kubernetes RBAC, you define user permissions as a *role*. Grant permissions within a namespace using roles.

Kubernetes roles grant permissions; they don't deny permissions. To grant permissions across the entire cluster or to cluster resources outside a given namespace, you can use *ClusterRoles*.

#### ClusterRoles

A ClusterRole grants and applies permissions to resources across the entire cluster, not a specific namespace.

### RoleBindings and ClusterRoleBindings

Once you define roles to grant permissions to resources, you assign those Kubernetes RBAC permissions with a *RoleBinding*. If your AKS Arc cluster [integrates with Microsoft Entra ID](#microsoft-entra-integration), RoleBindings grant permissions to Microsoft Entra users to perform actions within the cluster. See [Control access using Microsoft Entra ID and Kubernetes RBAC](kubernetes-rbac-23h2.md)

#### RoleBindings

Assign roles to users for a given namespace using RoleBindings. With RoleBindings, you can logically segregate a single AKS cluster, only enabling users to access the application resources in their assigned namespace.

To bind roles across the entire cluster, or to cluster resources outside a given namespace, use *ClusterRoleBindings*.

#### ClusterRoleBinding

With a ClusterRoleBinding, you bind roles to users and apply to resources across the entire cluster, not a specific namespace. This approach lets you grant administrators or support engineers access to all resources in the AKS cluster.

> [!NOTE]
> AKS enabled by Arc performs any cluster actions with user consent under a built-in Kubernetes role named **aks-service** and a built-in role binding **aks-service-rolebinding**. This role enables AKS to troubleshoot and diagnose cluster issues, but can't modify permissions or create roles or role bindings, or perform other high privilege actions. Role access is only enabled under active support tickets with just-in-time (JIT) access. 

## Kubernetes service accounts

*Service accounts* are one of the primary user types in Kubernetes. The Kubernetes API holds and manages service accounts. Service account credentials are stored as Kubernetes secrets, allowing them to be used by authorized pods to communicate with the API server. Most API requests provide an authentication token for a service account or a normal user account.

Normal user accounts allow more traditional access for human administrators or developers, not just services and processes. While Kubernetes doesn't provide an identity management solution to store regular user accounts and passwords, you can integrate external identity solutions into Kubernetes. For AKS Arc clusters, this integrated identity solution is Microsoft Entra ID.

For more information about the identity options in Kubernetes, see [Kubernetes authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication).

## Azure role-based access control

Azure Role-based Access Ccontrol (RBAC) is an authorization system built on [Azure Resource Manager](/azure/azure-resource-manager/management/overview) that provides fine-grained access management of Azure resources.

| RBAC system | Description                                              |
| --------------- | ------------------------------------------------------------ |
| Kubernetes RBAC | Designed to work on Kubernetes resources within your AKS Arc cluster. |
| Azure RBAC      | Designed to work on resources within your Azure subscription. |

With Azure RBAC, you create a *role definition* that outlines the permissions to be applied. You then assign a user or group this role definition via a *role assignment* for a particular *scope*. The scope can be an individual resource, a resource group, or across the subscription.

For more information, see [What is Azure role-based access control (Azure RBAC)?](/azure/role-based-access-control/overview)

There are two levels of access needed to fully operate an AKS Arc cluster:

- Access the AKS resource in your Azure subscription.
  - Control scaling or upgrading your cluster using the AKS Arc APIs.
  - Pull your **kubeconfig**.
- Access to the Kubernetes API. This access is controlled by either:
  - Kubernetes RBAC.
  - Integrating Azure RBAC with AKS Arc for Kubernetes authorization.
  
### Azure RBAC to authorize access to the AKS resource

With Azure RBAC, you can provide your users (or identities) with granular access to AKS resources across one or more subscriptions. For example, you could use the **Azure Kubernetes Service Arc Contributor** role to scale and upgrade your cluster. Meanwhile, another user with the **Azure Kubernetes Service Arc Cluster Admin** role only has permission to pull the Admin **kubeconfig**.

### Azure RBAC for Kubernetes authorization

With the Azure RBAC integration, AKS Arc uses a Kubernetes authorization webhook server so you can manage Microsoft Entra integrated Kubernetes cluster resource permissions and assignments using Azure role definition and role assignments.

:::image type="content" source="media/concepts-security-access-and-identity-options/azure-rbac-k8s-authz-flow.png" alt-text="Image showing authorization flow." lightbox="media/concepts-security-access-and-identity-options/azure-rbac-k8s-authz-flow.png":::

As shown in this diagram, when using the Azure RBAC integration, all requests to the Kubernetes API follow the same authentication flow as described in [Microsoft Entra integration](#microsoft-entra-integration).

If the identity making the request exists in Microsoft Entra ID, Azure teams with Kubernetes RBAC to authorize the request. If the identity exists outside of Microsoft Entra ID (for example, a Kubernetes service account), authorization defers to the normal Kubernetes RBAC.

In this scenario, you use Azure RBAC mechanisms and APIs to assign users built-in roles or create custom roles, just as you would with Kubernetes roles.

With this feature, you not only give users permissions to the AKS Arc resource across subscriptions, but you also configure the role and permissions for inside each of those clusters controlling Kubernetes API access. For example, you can grant the **Azure Kubernetes Service Arc RBAC Reader** role on the subscription scope. The role recipient can list and get all Kubernetes objects from all clusters without modifying them.

> [!IMPORTANT]
> You must enable Azure RBAC for Kubernetes authorization before doing role assignment. For more details and step by step guidance, see [Use Azure RBAC for Kubernetes authorization](azure-rbac-23h2.md).

### Built-in roles

AKS enabled by Azure Arc provides the following four built-in roles. They are similar to the [Kubernetes built-in roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles) with a few differences, such as supporting CRDs. See the full list of actions allowed by each [Azure built-in role](/azure/role-based-access-control/built-in-roles).

| Role                                                     | Description                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Azure Arc Kubernetes Viewer](/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-viewer) | Allows read-only access to see most objects in a namespace. <br />Doesn't allow viewing roles or role bindings. <br />Doesn't allow viewing `secrets`, because `read` permission on secrets enables access to `ServiceAccount` credentials in the namespace, which allows API access as any `ServiceAccount` in the namespace (a form of privilege escalation). |
| [Azure Arc Kubernetes Writer](/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-writer) | Allows read/write access to most objects in a namespace. <br />Doesn't allow viewing or modifying roles or role bindings. <br />Allows accessing `secrets` and running pods as any `ServiceAccount` in the namespace, so it can be used to gain the API access levels of any `ServiceAccount` in the namespace. |
| [Azure Arc Kubernetes Admin](/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-admin) | Allows admin access, intended to be granted within a namespace. <br />Allows read/write access to most resources in a namespace (or cluster scope), including the ability to create roles and role bindings within the namespace. <br />Doesn't allow write access to resource quota or to the namespace itself. |
| [Azure Arc Kubernetes Cluster Admin](/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-cluster-admin) | Allows super-user access to perform any action on any resource.<br/>Gives full control over every resource in the cluster and in all namespaces. |

## Microsoft Entra integration

Enhance your AKS Arc cluster security with Microsoft Entra integration. Built on enterprise identity management experience, Microsoft Entra ID is a multi-tenant, cloud-based directory and identity management service that combines core directory services, application access management, and identity protection. With Microsoft Entra ID, you can integrate on-premises identities into AKS Arc clusters to provide a single source for account management and security.

:::image type="content" source="media/concepts-security-access-and-identity-options/entra-integration.png" alt-text="Flowchart showing Entra integration." lightbox="media/concepts-security-access-and-identity-options/entra-integration.png":::

With Microsoft Entra integrated AKS clusters, you can grant users or groups access to Kubernetes resources within a namespace or across the cluster.

- To obtain a **kubectl** configuration context, run the [az aksarc get-credentials](/cli/azure/aksarc#az-aksarc-get-credentials) command.
- When a user interacts with the AKS Arc cluster with **kubectl**, they're prompted to sign in with their Microsoft Entra credentials.

This approach provides a single source for user account management and password credentials. The user can only access the resources as defined by the cluster administrator.

Microsoft Entra authentication is provided to AKS clusters with OpenID Connect. OpenID Connect is an identity layer built on top of the OAuth 2.0 protocol. For more information on OpenID Connect, see the [OpenID Connect documentation](/azure/active-directory/develop/v2-protocols-oidc). From inside of the Kubernetes cluster, [Webhook Token Authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#webhook-token-authentication) is used to verify authentication tokens. Webhook token authentication is configured and managed as part of the AKS cluster.

## Summary

View the table for a summary of how users can authenticate to Kubernetes when Microsoft Entra integration is enabled. In all cases, the sequence of commands is:

1. Run `az login` to authenticate to Azure.
2. Run `az aksarc get-credentials` to download credentials for the cluster into `.kube/config`.
3. Run `kubectl` commands.
   - The first command can trigger browser-based authentication to authenticate to the cluster, as described in the following table.

In the Azure portal, you can find:

- The *Role Assignment* (Azure RBAC role grant) referred to in the second column is shown on the **Access Control (IAM)** tab.
- The Cluster Admin Microsoft Entra group is shown on the **Configuration** tab.
  - You can also use the `--aad-admin-group-object-ids` parameter in the Azure CLI.

| Description                                                  | Role grant required                                          | Cluster admin Microsoft Entra groups                       | When to use                                                  |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Legacy admin login using client certificate                  | **Azure Kubernetes Service Arc Cluster Admin Role**. This role allows `az aksarc get-credentials` to be used with the `--admin` flag, which downloads a [legacy (non-Microsoft Entra) cluster admin certificate](/azure/aks/control-kubeconfig-access) into the user's **.kube/config**. This is the only purpose of the Azure Kubernetes Admin role. | n/a                                                          | If you're permanently blocked by not having access to a valid Microsoft Entra group with access to your cluster. |
| Microsoft Entra ID with manual (Cluster) RoleBindings        | **Azure Kubernetes Service Arc Cluster User Role**. The "User" role allows `az aks get-credentials` to be used without the `--admin` flag. This is the only purpose of the "Azure Kubernetes Service Cluster User" role.) The result, on a Microsoft Entra ID-enabled cluster, is the download of [an empty entry](/azure/aks/control-kubeconfig-access) into **.kube/config**, which triggers browser-based authentication when it's first used by **kubectl**. | Because the user is not in any Cluster Admin group, their rights are controlled entirely by any RoleBindings or ClusterRoleBindings that are set up by cluster admins. The (Cluster) RoleBindings [nominate Microsoft Entra users or Microsoft Entra groups](/azure/aks/azure-ad-rbac) as their subjects. If no such bindings were set up, the user can't excute any **kubectl** commands. | If you want fine-grained access control, and you're not using Azure RBAC for Kubernetes Authorization. Note that the user who sets up the bindings must log in by one of the other methods listed in this table. |
| Microsoft Entra ID by member of admin group                  | Same as above                                                | User is a member of one of the groups listed here. AKS automatically generates a ClusterRoleBinding that binds all of the listed groups to the `cluster-admin` Kubernetes role. So users in these groups can run all `kubectl` commands as `cluster-admin`. | If you want to grant users full admin rights, and are not using Azure RBAC for Kubernetes authorization. |
| Microsoft Entra ID with Azure RBAC for Kubernetes authorization | Two roles: <br />**Azure Kubernetes Service Arc Cluster User role** (as above). <br />One of the **Azure Arc Kubernetes** roles decribed previously, or your own custom alternative. | The admin roles field on the **Configuration** tab is irrelevant when Azure RBAC for Kubernetes authorization is enabled. | You use Azure RBAC for Kubernetes authorization. This approach gives you fine-grained control, without the need to set up RoleBindings or ClusterRoleBindings. |

## Next steps

- To get started with Kubernetes RBAC for Kubernetes authorization, see [Control access using Microsoft Entra ID and Kubernetes RBAC](kubernetes-rbac-23h2.md)
- To get started with Azure RBAC for Kubernetes authorization, see [Use Azure RBAC for Kubernetes Authorization](azure-rbac-23h2.md)
