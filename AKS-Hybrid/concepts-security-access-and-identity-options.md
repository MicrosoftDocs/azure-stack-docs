---
title: Concepts - Access and Identity Options for Azure Kubernetes Service (AKS) enabled by Azure Arc
description: Learn about options in access and identity management on a Kubernetes cluster in AKS on Azure Stack HCI.
author: leslielin-5
ms.topic: conceptual
ms.date: 05/05/2024
ms.author: leslielin-5
ms.lastreviewed: 
ms.reviewer: 

# Intent: As an IT Pro, I want to learn how to improve the security of the applications and infrastructure within my AKS on Azure Stack HCI deployment(s).
# Keyword: security concepts infrastructure security


---

# Access and identity options for AKS enabled by Azure Arc 

Applies to: AKS on Azure Stack HCI 23H2 and 22H2



You can authenticate, authorize, secure, and control access to Kubernetes clusters in a variety of ways:

- Using Kubernetes role-based access control (Kubernetes RBAC), you can grant users, groups, and service accounts access to only the resources they need.
- With Azure Kubernetes Service (AKS) enabled by Azure Arc, you can further enhance the security and permissions structure using Microsoft Entra ID and Azure RBAC. Note that Azure RBAC is supported for AKS on Azure Stack HCI 23H2, while for AKS on Azure Stack HCI 22H2, it's in preview.

Kubernetes RBAC and AKS Arc help you secure your cluster access and provide only the minimum required permissions to developers and operators.

This article introduces the core concepts that help you authenticate and assign permissions in AKS Arc.



# Kubernetes RBAC

Kubernetes RBAC provides granular filtering of user actions. With this control mechanism:

- You assign users or user groups permission to create and modify resources or view logs from running application workloads.
- You can scope permissions to a single namespace or across the entire AKS cluster.
- You create *roles* to define permissions, and then assign those roles to users with *role bindings*.

For more information, see [Using Kubernetes RBAC authorization](https://kubernetes.io/docs/reference/access-authn-authz/rbac/).



## Roles and ClusterRoles

### Roles (namespace-level)

Before assigning permissions to users with Kubernetes RBAC, you'll define user permissions as a *Role*. Grant permissions within a namespace using roles.

[!**Note**]  Kubernetes roles *grant* permissions;  they don't *deny* permissions.  

To grant permissions across the entire cluster or to cluster resources outside a given namespace, you can instead use *ClusterRoles*.

### ClusterRoles (cluster-level)

A ClusterRole grants and applies permissions to resources across the entire cluster, not a specific namespace.



## RoleBindings and ClusterRoleBindings

Once you've defined roles to grant permissions to resources, you assign those Kubernetes RBAC permissions with a *RoleBinding*. If your AKS Arc cluster [integrates with Microsoft Entra ID](Microsoft Entra integration), RoleBindings grant permissions to Microsoft Entra users to perform actions within the cluster. See [How-to use Kubernetes role-based access control and Microsoft Entra ID](kubernetes-rbac-azure-ad.md)



### RoleBindings

Assign roles to users for a given namespace using RoleBindings. With RoleBindings, you can logically segregate a single AKS cluster, only enabling users to access the application resources in their assigned namespace.

To bind roles across the entire cluster, or to cluster resources outside a given namespace, you instead use *ClusterRoleBindings*.



### ClusterRoleBinding

With a ClusterRoleBinding, you bind roles to users and apply to resources across the entire cluster, not a specific namespace. This approach lets you grant administrators or support engineers access to all resources in the AKS cluster.

[**!Note**]  Microsoft/AKS Arc performs any cluster actions with user consent under a built-in Kubernetes role `aks-service` and built-in role binding `aks-service-rolebinding`.  This role enables AKS to troubleshoot and diagnose cluster issues, but can't modify permissions nor create roles or role bindings, or other high privilege actions. Role access is only enabled under active support tickets with just-in-time (JIT) access. 



## Kubernetes service accounts

*Service accounts* are one of the primary user types in Kubernetes. The Kubernetes API holds and manages service accounts. Service account credentials are stored as Kubernetes secrets, allowing them to be used by authorized pods to communicate with the API Server. Most API requests provide an authentication token for a service account or a normal user account.

Normal user accounts allow more traditional access for human administrators or developers, not just services and processes. While Kubernetes doesn't provide an identity management solution to store regular user accounts and passwords, you can integrate external identity solutions into Kubernetes. For AKS Arc clusters, this integrated identity solution is Microsoft Entra ID.

For more information on the identity options in Kubernetes, see [Kubernetes authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication).



# Azure role-based access control

Azure role-based access control (RBAC) is an authorization system built on [Azure Resource Manager](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/overview) that provides fine-grained access management of Azure resources.

| **RBAC system** | **Description**                                              |
| --------------- | ------------------------------------------------------------ |
| Kubernetes RBAC | Designed to work on Kubernetes resources within your AKS Arc cluster. |
| Azure RBAC      | Designed to work on resources within your Azure subscription. |

With Azure RBAC, you create a *role definition* that outlines the permissions to be applied. You then assign a user or group this role definition via a *role assignment* for a particular *scope*. The scope can be an individual resource, a resource group, or across the subscription.

For more information, see [What is Azure role-based access control (Azure RBAC)?](https://learn.microsoft.com/en-us/azure/role-based-access-control/overview)

There are two levels of access needed to fully operate an AKS Arc cluster:

- Access the AKS resource in your Azure subscription.
  
  - Control scaling or upgrading your cluster using the AKS Arc APIs.
  - Pull your `kubeconfig`.
- Access to the Kubernetes API. This access is controlled by either:
  - Kubernetes RBAC (traditionally).
  - Integrating Azure RBAC with AKS Arc for Kubernetes authorization.
  

**[!NOTE]** Azure RBAC is supported for AKS on Azure Stack HCI 23H2, while for AKS on Azure Stack HCI 22H2, it's in preview.



## Azure RBAC to authorize access to the AKS resource

With Azure RBAC, you can provide your users (or identities) with granular access to AKS Arc resources across one or more subscriptions. For example, the [Azure Arc Kubernetes Admin](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI%2Ckubernetes-latest#built-in-roles) only has permission to pull the Admin `kubeconfig`.



## Azure RBAC for Kubernetes Authorization

With the Azure RBAC integration, AKS Arc will use a Kubernetes Authorization webhook server so you can manage Microsoft Entra integrated Kubernetes cluster resource permissions and assignments using Azure role definition and role assignments.

![Azure RBAC for Kubernetes authorization flow](C:\MicrosoftDocs\azure-stack-docs\azure-stack\aks-hci\clip_image002.png)

As shown in the above diagram, when using the Azure RBAC integration, all requests to the Kubernetes API will follow the same authentication flow as explained on the [Microsoft Entra integration section](Microsoft Entra integration).

If the identity making the request exists in Microsoft Entra ID, Azure will team with Kubernetes RBAC to authorize the request. If the identity exists outside of Microsoft Entra ID (i.e., a Kubernetes service account), authorization will defer to the normal Kubernetes RBAC.

In this scenario, you use Azure RBAC mechanisms and APIs to assign users built-in roles or create custom roles, just as you would with Kubernetes roles.

With this feature, you not only give users permissions to the AKS Arc resource across subscriptions, but you also configure the role and permissions for inside each of those clusters controlling Kubernetes API access. For example, you can grant the Azure Kubernetes Service Arc RBAC Reader role on the subscription scope. The role recipient will be able to list and get all Kubernetes objects from all clusters without modifying them.

[**!Important**] You need to enable Azure RBAC for Kubernetes authorization before using this feature. For more details and step by step  guidance, follow our [**Use Azure RBAC for Kubernetes Authorization**](azure-rbac-23h2.md) how-to guide.  



## Built-in roles

AKS Arc provides the following four built-in roles. They are similar to the [Kubernetes built-in roles](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#user-facing-roles) with a few differences, like supporting CRDs. See the full list of actions allowed by each [Azure built-in role](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles).

| **Role**                                                     | **Where the role can control access.** | **Description**                                              |
| ------------------------------------------------------------ | -------------------------------------- | ------------------------------------------------------------ |
| AKS hybrid  contributor role                                 | Custom location                        | Create, Read, Update, and Delete (CRUD) operation            |
| AKS hybrid  admin role                                       | AKS cluster                            | Perform `get-credential` to download cert-based `kubeconfig` |
| AKS hybrid user role                                         | AKS cluster                            | Perform `get-credential` to download Entra ID line of sight `kubeconfig` |
| [Azure Arc Kubernetes Viewer](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-viewer) | AKS cluster                            | Allows read-only access to see most objects in a namespace. This role doesn't allow viewing secrets, because `read` permission on secrets would enable access to `ServiceAccount` credentials in the namespace. These credentials would in turn allow API access through that `ServiceAccount` value (a form of privilege escalation). |
| [Azure Arc Kubernetes Writer](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-writer) | AKS cluster                            | Allows read/write access to most objects in a namespace. This role doesn't allow viewing or modifying roles or role bindings. However, this role allows accessing secrets and running pods as any `ServiceAccount` value in the namespace, so it can be used to gain the API access levels of any `ServiceAccount` value in the namespace. |
| [Azure Arc Kubernetes Admin](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-admin) | AKS cluster                            | Allows admin access. It's intended to be granted within a namespace through `RoleBinding`. If you use it in `RoleBinding`, it allows read/write access to most resources in a namespace, including the ability to create roles and role bindings within the namespace. This role doesn't allow write access to resource quota or to the namespace itself. |
| [Azure Arc Kubernetes Cluster Admin](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-cluster-admin) | AKS cluster (all namespaces)           | Allows superuser access to execute any action on any resource. When you use it in `ClusterRoleBinding`, it gives full control over every resource in the cluster and in all namespaces. When you use it in `RoleBinding`, it gives full control over every resource in the role binding's namespace, including the namespace itself. |



# Microsoft Entra integration

Enhance your AKS Arc cluster security with Microsoft Entra integration. Built on decades of enterprise identity management, Microsoft Entra ID is a multi-tenant, cloud-based directory and identity management service that combines core directory services, application access management, and identity protection. With Microsoft Entra ID, you can integrate on-premises identities into AKS Arc clusters to provide a single source for account management and security.

![Microsoft Entra integration with AKS clusters](C:\MicrosoftDocs\azure-stack-docs\azure-stack\aks-hci\clip_image004.jpg)

With Microsoft Entra integrated AKS clusters, you can grant users or groups access to Kubernetes resources within a namespace or across the cluster.

1. To obtain a `kubectl` configuration context, a user runs the [az aksarc get-credentials](/azure/aksarc?view=azure-cli-latest#az-aksarc-get-credentials) command.
2. When a user interacts with the AKS Arc cluster with `kubectl`, they're prompted to sign in with their Microsoft Entra credentials.

This approach provides a single source for user account management and password credentials. The user can only access the resources as defined by the cluster administrator.

Microsoft Entra authentication is provided to AKS clusters with OpenID Connect. OpenID Connect is an identity layer built on top of the OAuth 2.0 protocol. For more information on OpenID Connect, see the [OpenID Connect documentation](https://learn.microsoft.com/en-us/azure/active-directory/develop/v2-protocols-oidc). From inside of the Kubernetes cluster, [Webhook Token Authentication](https://kubernetes.io/docs/reference/access-authn-authz/authentication/#webhook-token-authentication) is used to verify authentication tokens. Webhook token authentication is configured and managed as part of the AKS cluster.

**TBC w/ Mengze: OIDC for Entra ID**



# AKS Arc service permissions

**TBC w/ Mengze about this section**

When creating a cluster, AKS generates or modifies resources it needs (like VMs and NICs) to create and run the cluster on behalf of the user. This identity is distinct from the cluster's identity permission, which is created during cluster creation.



## Identity creating and operating the cluster permissions

The following permissions are needed by the identity creating and operating the cluster.

Expand table

| **Permission**                                               | **Reason**                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Microsoft.Compute/diskEncryptionSets/read                    | Required to read disk  encryption set ID.                    |
| Microsoft.Compute/proximityPlacementGroups/write             | Required for updating  proximity placement groups.           |
| Microsoft.Network/applicationGateways/read   Microsoft.Network/applicationGateways/write   Microsoft.Network/virtualNetworks/subnets/join/action | Required to configure  application gateways and join the subnet. |
| Microsoft.Network/virtualNetworks/subnets/join/action        | Required to configure the  Network Security Group for the subnet when using a custom VNET. |
| Microsoft.Network/publicIPAddresses/join/action   Microsoft.Network/publicIPPrefixes/join/action | Required to configure the  outbound public IPs on the Standard Load Balancer. |
| Microsoft.OperationalInsights/workspaces/sharedkeys/read   Microsoft.OperationalInsights/workspaces/read   Microsoft.OperationsManagement/solutions/write   Microsoft.OperationsManagement/solutions/read   Microsoft.ManagedIdentity/userAssignedIdentities/assign/action | Required to create and update  Log Analytics workspaces and Azure monitoring for containers. |
| Microsoft.Network/virtualNetworks/joinLoadBalancer/action    | Required to configure the  IP-based Load Balancer Backend Pools. |

# AKS Arc cluster identity permissions

**TBC w/ Mengze about this section**

The following permissions are used by the AKS cluster identity, which is created and associated with the AKS cluster. Each permission is used for the reasons below:

| **Permission**                                               | **Reason**                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Microsoft.ContainerService/managedClusters/*                 | Required for creating users  and operating the cluster       |
| Microsoft.Network/loadBalancers/delete   Microsoft.Network/loadBalancers/read   Microsoft.Network/loadBalancers/write | Required to configure the load  balancer for a LoadBalancer service. |
| Microsoft.Network/publicIPAddresses/delete   Microsoft.Network/publicIPAddresses/read   Microsoft.Network/publicIPAddresses/write | Required to find and configure  public IPs for a LoadBalancer service. |
| Microsoft.Network/publicIPAddresses/join/action              | Required for configuring  public IPs for a LoadBalancer service. |
| Microsoft.Network/networkSecurityGroups/read   Microsoft.Network/networkSecurityGroups/write | Required to create or delete  security rules for a LoadBalancer service. |
| Microsoft.Compute/disks/delete   Microsoft.Compute/disks/read   Microsoft.Compute/disks/write   Microsoft.Compute/locations/DiskOperations/read | Required to configure  AzureDisks.                           |
| Microsoft.Storage/storageAccounts/delete   Microsoft.Storage/storageAccounts/listKeys/action   Microsoft.Storage/storageAccounts/read   Microsoft.Storage/storageAccounts/write   Microsoft.Storage/operations/read | Required to configure storage  accounts for AzureFile or AzureDisk. |
| Microsoft.Network/routeTables/read   Microsoft.Network/routeTables/routes/delete   Microsoft.Network/routeTables/routes/read   Microsoft.Network/routeTables/routes/write   Microsoft.Network/routeTables/write | Required to configure route  tables and routes for nodes.    |
| Microsoft.Compute/virtualMachines/read                       | Required to find information  for virtual machines in a VMAS, such as zones, fault domain, size, and data  disks. |
| Microsoft.Compute/virtualMachines/write                      | Required to attach AzureDisks  to a virtual machine in a VMAS. |
| Microsoft.Compute/virtualMachineScaleSets/read   Microsoft.Compute/virtualMachineScaleSets/virtualMachines/read   Microsoft.Compute/virtualMachineScaleSets/virtualmachines/instanceView/read | Required to find information  for virtual machines in a virtual machine scale set, such as zones, fault  domain, size, and data disks. |
| Microsoft.Network/networkInterfaces/write                    | Required to add a virtual  machine in a VMAS to a load balancer backend address pool. |
| Microsoft.Compute/virtualMachineScaleSets/write              | Required to add a virtual  machine scale set to a load balancer backend address pools and scale out  nodes in a virtual machine scale set. |
| Microsoft.Compute/virtualMachineScaleSets/delete             | Required to delete a virtual  machine scale set to a load balancer backend address pools and scale down  nodes in a virtual machine scale set. |
| Microsoft.Compute/virtualMachineScaleSets/virtualmachines/write | Required to attach AzureDisks  and add a virtual machine from a virtual machine scale set to the load  balancer. |
| Microsoft.Network/networkInterfaces/read                     | Required to search internal  IPs and load balancer backend address pools for virtual machines in a VMAS. |
| Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/read | Required to search internal  IPs and load balancer backend address pools for a virtual machine in a  virtual machine scale set. |
| Microsoft.Compute/virtualMachineScaleSets/virtualMachines/networkInterfaces/ipconfigurations/publicipaddresses/read | Required to find public IPs  for a virtual machine in a virtual machine scale set. |
| Microsoft.Network/virtualNetworks/read   Microsoft.Network/virtualNetworks/subnets/read | Required to verify if a subnet  exists for the internal load balancer in another resource group. |
| Microsoft.Compute/snapshots/delete   Microsoft.Compute/snapshots/read   Microsoft.Compute/snapshots/write | Required to configure  snapshots for AzureDisk.              |
| Microsoft.Compute/locations/vmSizes/read   Microsoft.Compute/locations/operations/read | Required to find virtual  machine sizes for finding AzureDisk volume limits. |



# Additional cluster identity permissions

**TBC w/ Mengze about this section**

When creating a cluster with specific attributes, you will need the following additional permissions for the cluster identity. Since these permissions are not automatically assigned, you must add them to the cluster identity after it's created.

| **Permission**                                               | **Reason**                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| Microsoft.Network/networkSecurityGroups/write   Microsoft.Network/networkSecurityGroups/read | Required if using a network  security group in another resource group. Required to configure security  rules for a LoadBalancer service. |
| Microsoft.Network/virtualNetworks/subnets/read   Microsoft.Network/virtualNetworks/subnets/join/action | Required if using a subnet in  another resource group such as a custom VNET. |
| Microsoft.Network/routeTables/routes/read   Microsoft.Network/routeTables/routes/write | Required if using a subnet  associated with a route table in another resource group such as a custom VNET  with a custom route table. Required to verify if a subnet already exists for  the subnet in the other resource group. |
| Microsoft.Network/virtualNetworks/subnets/read               | Required if using an internal  load balancer in another resource group. Required to verify if a subnet  already exists for the internal load balancer in the resource group. |
| Microsoft.Network/privatednszones/*                          | Required if using a private  DNS zone in another resource group such as a custom privateDNSZone. |



# AKS Node Access

**TBC w/ Mengze about this section**

By default Node Access is not required for AKS. The following access is needed for the node if a specific component is leveraged.

| **Access**         | **Reason**                                                   |
| ------------------ | ------------------------------------------------------------ |
| kubelet            | Required to grant MSI access  to ACR.                        |
| http app routing   | Required for write permission  to "random name".aksapp.io.   |
| container insights | Required to grant permission  to the Log Analytics workspace. |



# Next steps

------

- To get started with Kubernetes RBAC for Kubernetes Authorization, see [How-to use Kubernetes role-based access control and Microsoft Entra ID](kubernetes-rbac-azure-ad.md)
- To get started with Azure RBAC for Kubernetes Authorization, see [**Use Azure RBAC for Kubernetes Authorization**](azure-rbac-23h2.md)