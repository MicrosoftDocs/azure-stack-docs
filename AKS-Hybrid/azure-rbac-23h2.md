---
title: Use Azure role-based access control (RBAC) for Kubernetes Authorization
description: Infrastructure administrators can use Azure role-based access control (Azure RBAC) to control who can access the *kubeconfig* file and the permissions they have. 
ms.topic: how-to
ms.custom: devx-track-azurecli
author: sethmanheim
ms.author: leslielin
ms.reviewer: sethm
ms.date: 5/16/2024
ms.lastreviewed: 5/16/2024

# Intent: As an IT Pro, I want to use Azure RBAC to authenticate connections to my AKS clusters over the Internet or on a private network.
# Keyword: Kubernetes role-based access control AKS Azure RBAC AD

---

# Use Azure role-based access control (RBAC) for Kubernetes Authorization

Applies to: AKS on Azure Stack HCI 23H2

Infrastructure administrators can use Azure role-based access control (Azure RBAC) to control who can access the *kubeconfig* file and the permissions they have. Kubernetes operators can interact with Kubernetes clusters using the `kubectl` tool based on the given permissions. The Azure CLI provides an easy way to get the access credentials and *kubeconfig* configuration file to connect to your AKS Arc clusters using `kubectl`.

This article describes how to use Azure RBAC for Kubernetes cluster authorization with Microsoft Azure AD and Azure role assignments.

For a conceptual overview, see [Azure RBAC on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-azure-rbac) and [Access and identity options](concepts-security-access-and-identity-options.md) for AKS enabled by Azure Arc.



## Before you begin

- AKS on Azure Stack HCI 23H2 currently only supports enabling Azure RBAC during Kubernetes cluster creation. You cannot enable Azure RBAC after the Kubernetes cluster has been created.

- To enable Azure RBAC, you must be running Azure CLI `aksarc extension version 1.1.1` or later. Run `az --version` to find the version. If you need to install or upgrade, see [Install Azure CLI](/cli/azure/install-azure-cli).

- To interact with Kubernetes clusters, you must install [kubectl]([Install Tools | Kubernetes](https://kubernetes.io/docs/tasks/tools/)) and [kubelogin]([Installation - Azure Kubelogin](https://azure.github.io/kubelogin/install.html)). Follow links to the public documentation to complete the installation.

- The infrastructure administrator will need the following permissions to enable Azure RBAC while creating an Kubernetes cluster.

  (1) To create an Kubernetes cluster, you will need the ***Azure Kubernetes Service hybrid Contributor Role*** 

  (2) To use `--enable-azure-rbac` parameter, you need access to the Microsoft.Authorization/roleAssignments/write permission. This includes roles such as Role Based Access Control Administrator, User Access Administrator, and Owner. For the least privilege principle, Microsoft recommends the ***Role Based Access Control Administrator role***.  Learn more from [Azure built-in roles - Azure RBAC | Microsoft Learn](/azure/role-based-access-control/built-in-roles/general)

- Once Azure RBAC is enabled, Infrastructure administrator can assign roles to Kubernetes operators, the available role assignment are documented in the [Arc Kubernetes Built-in roles](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI%2Ckubernetes-latest#built-in-roles).



## Step 1: Create an Azure RBAC-enabled Kubernetes cluster

Infrastructure administrator can create an Azure RBAC-enabled Kubernetes cluster for authorization and Microsoft Azure AD for authentication.

```Azure CLI
az aksarc create -n $aksclustername -g $resource_group --custom-location $customlocationID --vnet-ids $logicnetId --aad-admin-group-object-ids $aadgroupID --generate-ssh-keys --load-balancer-count 0 --control-plane-ip $controlplaneIP --enable-azure-rbac
```

After a few minutes, the command completes and returns JSON-formatted information about the cluster.



## Step 2: Get admin certificate-based kubeconfig for Entra ID authentication

To access the Kubernetes cluster with the given permissions, the Kubernetes operator will need the Microsoft Entra *kubeconfig*, which can be obtained using the [az aksarc get-credentials](/cli/azure/aksarc#az-aksarc-get-credentials). This *kubeconfig* can be distributed to users connecting from their client machines. The Microsoft Entra kubeconfig does not contain any secrets.

To run this Azure CLI command, you must have "Contributor," "Owner," and "Azure Kubernetes Service Hybrid Cluster Admin Role" permissions on the cluster. Learn more from [Retrieve certificate-based admin kubeconfig](/azure/aks/hybrid/retrieve-admin-kubeconfig)

```Azure CLI
az aksarc get-credentials --subscription "<$subscriptionID>" -g "<$resource_Group>" -n "<name of your cluster>" --file <file-name>
```

This command prompts for a password.



### [Optional] Create a Service Principal to manage role-based access control

When assigning a role for a Kubernetes cluster, infrastructure administrator can choose to assign the role with a Microsoft Enter ID or Service Principal client ID. If you choose to assign to a service principal, see the following steps.



First, use the [`az ad sp create`](/cli/azure/ad/sp#az-ad-sp-create) command to create an Azure service principal and obtain the credentials needed to access the Azure RBAC-enabled Kubernetes cluster. You can find the instructions below, or more detailed instructions are documented in [Use a service principal with Azure Kubernetes Service]( /azure/aks/kubernetes-service-principal?tabs=azure-cli)

```azurecli
$spnenablerbac = "<SPN-name>"
​
$spnenablerbacappid = az ad app create --display-name $spnenablerbac --query appId --output tsv
​
$spnenablerbacappid = $spnenablerbacappid -replace "\r","" -replace "\n",""
​
az ad sp create --id $spnenablerbacappid
​
az ad sp credential reset --id $spnenablerbacappid
```

> [!IMPORTANT]
> The command output for `az ad sp` includes credentials that you must protect. Do not include these credentials in your code or check the credentials into your source control. For more information, see [Create an Azure service principal](/cli/azure/azure-cli-sp-tutorial-1).



Second, modify the Microsoft Entra *kubeconfig* file from the previous step with the following:

1. Replace "interactive" with "spn".
2. Replace variable for client-id with service principal's "appId".
3. Add a new variable "client-secret" and the corresponding password under the client-secret from your service principal password.

Here's an example of the updated *kubeconfig* file.

```
users:
- name: aad-user
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1beta1
      args:
      - get-token
      - --login
      - spn
      - --server-id
      - 6256c85f-0aad-4d50-b960-e6e9b21efe35
      - --client-id
      - 3f4439ff-e698-4d6d-84fe-09c9d574f06b
      - --client-secret
      - RLy8Q~u3wwFrvazJPCtvbgIN2on_Cr7nD0gwEbpZ
      - --tenant-id
      - d9b73d5e-a9d3-41ba-88c3-796a643e3edd
      - --environment
      - AzurePublicCloud
      - --pop-enabled
      - --pop-claims
      - u=/subscriptions/<subscription>/resourceGroups/<resource-group>/providers/Microsoft.Kubernetes/connectedClusters/<cluster-name>
      command: kubelogin
```



## Step 3: Create role assignments for users to access the cluster 

Now, infrastructure administrators are ready to create role assignments for users to access the cluster. To assign roles on a Kubernetes cluster, you must have Owner permission on the subscription, resource group, or cluster. We use the [az role assignment create](/cli/azure/role/assignment?view=azure-cli-latest#az-role-assignment-create) command to create role assignments. For available role assignments and detailed instructions, see [How to create role assignments](/azure/azure-arc/kubernetes/azure-rbac#create-role-assignments-for-users-to-access-the-cluster).

First, we get the $ARM-ID for the target cluster to which we'd like to assign a role.

```
$ARM_ID = (az connectedk8s show --subscription "<$subscriptionID>" -g "<$resource_Group>" -n "<name of your cluster>" --query id -o tsv)
```



Second, use the `az role assignment create` command to assign roles to your target cluster. You will need to provide the `$ARM_ID` from the first step and the `assignee-object-id` for this step. The `assignee-object-id` could be an `Microsoft Entra ID` or `Service Principal client ID`.

The following example assigns the `Azure Arc Kubernetes Cluster Admin` role to the resource group that contains the cluster. 

```Azure CLI
az role assignment create --role "Azure Arc Kubernetes Cluster Admin" --assignee <assignee-object-id> --scope $ARM_ID
```



## Step 4: Connect to an AKS cluster over a private network via Azure RBAC for authorized activity

Now the infrastructure administrator has created an Azure RBAC-enabled Kubernetes cluster and completed the role assignment. The Kubernetes operator can now use *kubelogin* and *kubectl* with signed-in Azure credentials to perform authorized activities. See [How to create role assignments](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI%2Ckubernetes-latest#create-role-assignments-for-users-to-access-the-cluster) for Built-in roles with respective permissions.

Use the Microsoft Entra *kubeconfig* file from step #3 to perform *kubelogin*. See the following command as an example.

```
.\kubectl.exe get pod --kubeconfig <file-name>
```



[**Note!**]

- You will need to have kubectl and kubelogin installed in the environment to which you would like to connect over a private network.

- When you connect to an AKS cluster over a private network, there's no limit on the number of groups you can use.





## Next steps

- [Learn more about SPNs](/cli/azure/azure-cli-sp-tutorial-1)
