---
title: Use Azure role-based access control (RBAC) for Kubernetes authorization
description: Learn how infrastructure administrators can use Azure RBAC to control who can access kubeconfig. 
ms.topic: how-to
ms.custom: devx-track-azurecli
author: sethmanheim
ms.author: sethm
ms.reviewer: leslielin
ms.date: 5/29/2024
ms.lastreviewed: 5/29/2024

# Intent: As an IT Pro, I want to use Azure RBAC to authenticate connections to my AKS clusters over the Internet or on a private network.
# Keyword: Kubernetes role-based access control AKS Azure RBAC AD

---

# Use Azure role-based access control (RBAC) for Kubernetes authorization

Applies to: AKS on Azure Stack HCI 23H2

Infrastructure administrators can use Azure role-based access control (Azure RBAC) to control who can access the *kubeconfig* file and the permissions they have. Kubernetes operators can interact with Kubernetes clusters using the **kubectl** tool based on the given permissions. Azure CLI provides an easy way to get the access credentials and kubeconfig configuration file to connect to your AKS enabled by Arc clusters using **kubectl**.

When you use integrated authentication between Microsoft Entra ID and AKS Arc, you can use Microsoft Entra users, groups, or service principals as subjects in [Kubernetes role-based access control (Kubernetes RBAC)](concepts-security-access-and-identity-options.md). This feature frees you from having to separately manage user identities and credentials for Kubernetes. However, you still must set up and manage Azure RBAC and Kubernetes RBAC separately.

This article describes how to use Azure RBAC for Kubernetes cluster authorization with Microsoft Entra ID and Azure role assignments.

For a conceptual overview, see [Azure RBAC for Kubernetes Authorization](concepts-security-access-and-identity-options.md) for AKS enabled by Azure Arc.

## Before you begin

- AKS on Azure Stack HCI 23H2 currently supports enabling Azure RBAC only during Kubernetes cluster creation. You can't enable Azure RBAC after the Kubernetes cluster is created.
- To enable Azure RBAC, you must be running the Azure CLI **aksarc extension version 1.1.1** or later. Run `az --version` to find the version. If you need to install or upgrade, see [Install Azure CLI](/cli/azure/install-azure-cli).
- To interact with Kubernetes clusters, you must install [kubectl](https://kubernetes.io/docs/tasks/tools/) and [kubelogin](https://azure.github.io/kubelogin/install.html).
- The infrastructure administrator needs the following permissions to enable Azure RBAC while creating a Kubernetes cluster.
  - To create a Kubernetes cluster, you need the **Azure Kubernetes Service Arc Contributor** role. 
  - To use the `--enable-azure-rbac` parameter, you need the **Role-Based Access Control Administrator** role for access to the Microsoft.Authorization/roleAssignments/write permission. For more information, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles/general).
- New role assignments can take up to five minutes to propagate and be updated by the authorization server.
- Azure RBAC for Kubernetes authorization requires that the Microsoft Entra tenant configured for authentication is same as the tenant for the subscription that contains your AKS Arc cluster.

## Step 1: Create an Azure RBAC-enabled Kubernetes cluster

You can create an Azure RBAC-enabled Kubernetes cluster for authorization and a Microsoft Entra ID for authentication.

```azurecli
az aksarc create -n $aks_cluster_name -g $resource_group_name --custom-location $customlocation_ID --vnet-ids $logicnet_Id --generate-ssh-keys --control-plane-ip $controlplaneIP --enable-azure-rbac
```

After a few minutes, the command completes and returns JSON-formatted information about the cluster.

## Step 2: Create role assignments for users to access the cluster

AKS enabled by Azure Arc provides the following built-in roles:

| Role                                                     | Description                                              |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [Azure Arc Kubernetes Viewer](/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-viewer) | Allows read-only access to see most objects in a namespace. <br />Doesn't allow viewing roles or role bindings. <br />Doesn't allow viewing `secrets`, because `read` permission on secrets enables access to `ServiceAccount` credentials in the namespace, which allows API access as any `ServiceAccount` in the namespace (a form of privilege escalation). |
| [Azure Arc Kubernetes Writer](/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-writer) | Allows read/write access to most objects in a namespace. <br />Doesn't allow viewing or modifying roles or role bindings. <br />Allows accessing `secrets` and running pods as any `ServiceAccount` in the namespace, so it can be used to gain the API access levels of any `ServiceAccount` in the namespace. |
| [Azure Arc Kubernetes Admin](/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-admin) | Allows admin access, intended to be granted within a namespace. <br />Allows read/write access to most resources in a namespace (or cluster scope), including the ability to create roles and role bindings within the namespace. <br />Doesn't allow write access to resource quota or to the namespace itself. |
| [Azure Arc Kubernetes Cluster Admin](/azure/role-based-access-control/built-in-roles#azure-arc-kubernetes-cluster-admin) | Allows "super-user" access to perform any action on any resource.<br/>Gives full control over every resource in the cluster and in all namespaces. |

You can use the [az role assignment create](/cli/azure/role/assignment#az-role-assignment-create) command to create role assignments.

First, get the `$ARM-ID` for the target cluster to which you want to assign a role.

```azurecli
$ARM_ID = (az connectedk8s show --subscription "$subscription_ID" -g "$resource_group_name" -n "name_of_your_cluster>" --query id -o tsv)
```

Then, use the `az role assignment create` command to assign roles to your Kubernetes cluster. You must provide the `$ARM_ID` from the first step and the `assignee-object-id` for this step. The `assignee-object-id` can be a Microsoft Entra ID or a service principal client ID.

The following example assigns the **Azure Arc Kubernetes Cluster Admin** role to the Kubernetes cluster:

```azurecli
az role assignment create --role "Azure Arc Kubernetes Cluster Admin" --assignee <assignee-object-id> --scope $ARM_ID
```

### Create custom role definitions

You can choose to create your own role definition for use in role assignments.

The following example shows a role definition that allows a user to only read deployments. For more information, see [the full list of data actions that you can use to construct a role definition](/azure/role-based-access-control/resource-provider-operations#microsoftkubernetes). For more information about creating a custom role, see [Steps to create a custom role](/azure/role-based-access-control/custom-roles#steps-to-create-a-custom-role)

To create your own custom role definitions, copy the following JSON object into a file called **custom-role.json**. Replace the `<subscription-id>` placeholder with the actual subscription ID. The custom role uses one of the data actions and lets you view all deployments in the scope (cluster or namespace) where the role assignment is created.

```json
{
    "Name": "AKS Arc Deployment Reader",
    "Description": "Lets you view all deployments in cluster/namespace.",
    "Actions": [],
    "NotActions": [],
    "DataActions": [
        "Microsoft.Kubernetes/connectedClusters/apps/deployments/read"
    ],
    "NotDataActions": [],
    "assignableScopes": [
        "/subscriptions/<YOUR SUBSCRIPTION ID>"
    ]
}
```

For information about custom roles and how to author them, see [Azure custom roles](/azure/role-based-access-control/custom-roles).

Create the role definition using the [az role definition create](/cli/azure/role/definition#az-role-definition-create) command, setting the `--role-definition` parameter to the **deploy-view.json** file you created in the previous step:

```azurecli
az role definition create --role-definition @deploy-view.json 
```

Assign the role definition to a user or other identity using the [az role assignment create](/cli/azure/role/assignment#az-role-assignment-create) command:

```azurecli
az role assignment create --role "AKS Arc Deployment Reader" --assignee <assignee-object-id> --scope $ARM_ID
```

## Step 3: Use Azure RBAC for Kubernetes authorization with kubectl

To access the Kubernetes cluster with the given permissions, the Kubernetes operator needs the Microsoft Entra **kubeconfig**, which you can get using the [az aksarc get-credentials](/cli/azure/aksarc#az-aksarc-get-credentials) command. The admin-based kubeconfig file contains secrets and should be securely stored and rotated periodically. On the other hand, the user-based Microsoft Entra ID kubeconfig doesn't contain secrets and can be distributed to users who connect from their client machines.

> [!CAUTION]
> The admin kubeconfig contains secrets, so you should follow best security practices for the admin kubeconfig; such as securely handle it, rotate secrets periodically, and so on.

To run this Azure CLI command, you must have **Azure Kubernetes Service Arc Cluster Admin** role permissions on the cluster. For more information, see [Retrieve certificate-based admin kubeconfig](/azure/aks/hybrid/retrieve-admin-kubeconfig).

```azurecli
az aksarc get-credentials --subscription "<$subscriptionID>" -g "<$resource_Group>" -n "<name of your cluster>" --file <file-name>
```

Now, you can use kubectl manage your cluster. For example, you can list the nodes in your cluster using `kubectl get nodes`. The first time you run it, you must sign in, as shown in the following example:

```azurecli
kubectl get nodes
```

To sign in, use a web browser to open the page `https://microsoft.com/devicelogin`, and enter the code **AAAAAAAAA** to authenticate.

### Use Azure RBAC for Kubernetes authorization with kubelogin

AKS enabled by Azure Arc provides the [`kubelogin`](https://github.com/Azure/kubelogin) plugin to help unblock additional scenarios, such as non-interactive logins, older `kubectl` versions, or using SSO across multiple clusters without the need to sign in to a new cluster.

You can use the `kubelogin` plugin by running the following command:

```bash
export KUBECONFIG=/path/to/kubeconfig
kubelogin convert-kubeconfig
```

Similar to `kubectl`, you must log in the first time you run it, as shown in the following example:

```bash
kubectl get nodes
```

To sign in, use a web browser to open the page `https://microsoft.com/devicelogin`, and enter the code **AAAAAAAAA** to authenticate.

## Clean up resources

### Delete role assignment

```azurecli
# List role assignments
az role assignment list --scope $ARM_ID --query [].id -o tsv

# Delete role assignments
az role assignment delete --ids <LIST OF ASSIGNMENT IDS>
```

### Delete role definition

```azurecli
az role definition delete -n "AKS Arc Deployment Reader"
```

## Next steps

- [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/overview)
- [Access and identity options](concepts-security-access-and-identity-options.md) for AKS enabled by Azure Arc
- [Create an Azure service principal with Azure CLI](/cli/azure/azure-cli-sp-tutorial-1)
- Available Azure permissions for [Hybrid + Multicloud](/azure/role-based-access-control/resource-provider-operations#microsoftkubernetes)
