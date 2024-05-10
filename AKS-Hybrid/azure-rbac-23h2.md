---
title: Use Azure RBAC for AKS clusters (preview)
description: Use Azure RBAC with Microsoft Entra ID to control access to AKS clusters.
ms.topic: how-to
ms.custom: devx-track-azurecli
author: sethmanheim
ms.author: sethm
ms.reviewer: sulahiri
ms.date: 10/09/2023
ms.lastreviewed: 03/23/2023

# Intent: As an IT Pro, I want to use Azure RBAC to authenticate connections to my AKS clusters over the Internet or on a private network.
# Keyword: Kubernetes role-based access control AKS Azure RBAC AD

---

# Use Azure role-based access control (RBAC) for Kubernetes Authorization

[!INCLUDE [hci-applies-to-23h2](https://github.com/MicrosoftDocs/azure-stack-docs/blob/main/AKS-Hybrid/includes/hci-applies-to-23h2.md)]

You can interact with Kubernetes clusters using the `kubectl` tool. The Azure CLI provides an easy way to get the access credentials and *kubeconfig* configuration file to connect to your AKS Arc clusters using `kubectl`. You can use Azure role-based access control (Azure RBAC) to limit who can get access to the *kubeconfig* file and the permissions they have.

This article describes how to use Azure RBAC for Kubernetes cluster authorization with Microsoft Entra ID and Azure role assignments.

For a conceptual overview, please see [Azure RBAC on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/conceptual-azure-rbac) or [Access and identity options](concepts-security-access-and-identity-options.md) for AKS enabled by Azure Arc.



## Before you begin

- AKS on Azure Stack HCI 23H2 currently only supports enabling Azure RBAC during Kubernetes cluster creation. You cannot enable Azure RBAC after the Kubernetes cluster has been created.
- To use Azure RBAC, you must be running Azure CLI version x.x.x or later. Run `az --version` to find the version. If you need to install or upgrade, see [Install Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli).
-  You can find the role assignment in the [Built-in roles](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI%2Ckubernetes-latest#built-in-roles).



## Step 1: Create an Azure RBAC-enabled Kubernetes cluster

Create an Azure RBAC-enabled Kubernetes cluster for authorization and Microsoft Azure AD for authentication.

```Azure CLI
az aksarc create --custom-location $custom-location-id --name "<cluster-name>" --resource-group "<resource-group-name>" --vnet-id $vnet-id --aad-admin-group-object-ids $aad-admin-group-object-ids --enable-azure-rbac
```



## Step 2: Create a Service Principal to manage role-based access control

Use the [`az ad sp create`](/cli/azure/ad/sp?view=azure-cli-latest#az-ad-sp-create) command to create an Azure service principal to obtain the credentials needed to access the Azure RBAC-enabled Kubernetes cluster. You may find the instructions as follows, or more detailed instructions documented in [Use a service principal with Azure Kubernetes Service]( /azure/aks/kubernetes-service-principal?tabs=azure-cli)

```azurecli
$spnenablerbacappid = az ad app create --display-name <service-principal-name> --query appID --output tsv
​
az ad sp create --id $spnenablerbacappid
​
az ad sp credential reset --id $spnenablerbacappid
```

> [!IMPORTANT]
> The command output for `az ad sp` includes credentials that you must protect. Do not include these credentials in your code or check the credentials into your source control. For more information, see [Create an Azure service principal](/cli/azure/azure-cli-sp-tutorial-1).



## Step 3: Get admin certificate-based kubeconfig and change it to SPN login mode 

Use the  [`az aks get-credentials`](/cli/azure/aksarc?view=azure-cli-latest#az-aksarc-get-credentials)command to get the admin certificate-based kubeconfig.

```Azure CLI
az aksarc get-credentials --name "<cluster-name>" --resource-group "<resource-group-name>" -o json
```

This command prompts for a password.



## Step 4: Create role assignments for users to access the cluster 

Now, we are ready to create role assignments for users to access the cluster. You can find the role assignment in the [Built-in roles](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI%2Ckubernetes-latest#built-in-roles).

We use the [`az role assignment create`](/cli/azure/role/assignment?view=azure-cli-latest) command to create role assignments. For detailed instructions, see [How to create role assignments](/azure/azure-arc/kubernetes/azure-rbac?tabs=AzureCLI%2Ckubernetes-latest#create-role-assignments-for-users-to-access-the-cluster).

Here's an example of the `az role assignment create` command.

```Azure CLI
az role assignment create --role "Azure Arc Kubernetes Cluster Admin" --assignee <AZURE-AD-ENTITY-ID> --scope $ARM_ID
```



## Step 5: Connect to AKS cluster via Azure RBAC over a private network

The Azure RBAC setup on the Kubernetes cluster is now complete. To test your Azure RBAC setup, connect to the AKS cluster over a private network. Azure RBAC authenticates the connections. 

- When you connect to an AKS cluster over a private network, there's no limit on the number of groups you can use.
- To retrieve the Microsoft Entra kubeconfig, log into an on-premises machine (for example, an HCI cluster), and generate the Microsoft Entra kubeconfig using the following command. You can distribute the Microsoft Entra kubeconfig to users that connect from their client machine. The Microsoft Entra kubeconfig doesn't contain any secrets.

To connect to an AKS cluster over a private network, perform the following steps:

1. Download the **kubeconfig** file:

   ```Azure CLI
   az aksarc get-credentials --name "<cluster-name>" --resource-group "<resource-group-name>" 
   ```

2. Start sending requests to AKS API server by running the `kubectl` command `api-server`. You are prompted for your Microsoft Entra credentials.

   You might get a warning message, but you can ignore it.

   

## Next steps

- [Learn more about SPNs](/cli/azure/azure-cli-sp-tutorial-1)
