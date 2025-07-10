---
title: Commands for the Azure Kubernetes Service on Azure Stack Hub
description: Learn about commands for Azure Kubernetes Service (ASK) on Azure Stack Hub.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.date: 10/26/2021
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 10/26/2021

# Intent: As an Azure Stack operator, I want to install and offer Azure Kubernetes Service on Azure Stack Hub so my supported user can offer containerized solutions.
# Keyword: Kubernetes AKS difference
---

# Commands for the Azure Kubernetes Service on Azure Stack Hub

The following commands and parameters are supported for the Azure Kubernetes Service (AKS) on Azure Stack Hub.

## Supported commands

| Command | Description | Parameter/Required(*) |
|---|---|---|
| [az aks create](/cli/azure/aks#az-aks-create) | Create a new managed Kubernetes cluster. | resource-group *<br>service-principal *<br>client-secret *<br>load-balancer-sku *<br>vm-set-type<br>dns-name-prefix<br>admin-username<br>kubernetes-version<br>generate-ssh-keys<br>location<br>network-plugin<br>network-policy<br>node-count<br>nodepool-name<br>vnet-subnet-id<br>max-pods<br>node-vm-size<br>windows-admin-passsword<br>windows-admin-username |
| [az aks get-upgrades](/cli/azure/aks#az-aks-get-upgrades) | Get the upgrade versions available for a managed Kubernetes cluster. | name *<br>resource-group * |
| [az aks list](/cli/azure/aks#az-aks-list) | List managed Kubernetes clusters. | location * |
| [az aks get-versions](/cli/azure/aks#az-aks-get-versions) | Get the versions available for creating a managed Kubernetes cluster.  |  |
| [az aks show](/cli/azure/aks#az-aks-show) | Show the details for a managed Kubernetes cluster. | name *<br>resource-group * |
| [az aks get-credentials](/cli/azure/aks#az-aks-get-credentials) | Get access credentials for a managed Kubernetes cluster.  | name *<br>resource-group *<br>admin |
| [az aks delete](/cli/azure/aks#az-aks-delete) | Delete a managed Kubernetes cluster. |  |
| [az aks scale](/cli/azure/aks#az-aks-scale) | Scale the node pool in a managed Kubernetes cluster. | name *<br>resource-group *<br>node-count * |
| [az aks upgrade](/cli/azure/aks#az-aks-upgrade) | Upgrade a managed Kubernetes cluster to a newer version.  | name *<br>resource-group *<br>kubernetes-version *<br>control-plane-only |
| [az aks install-cli](/cli/azure/aks#az-aks-install-cli) | Download and install kubectl, the Kubernetes command-line tool. Download and install kubelogin, a client-go credential (exec) plugin implementing Azure authentication. |  |
| [az aks nodepool list](/cli/azure/aks/nodepool#az-aks-nodepool-list) | List node pools in the managed Kubernetes cluster. | name *<br>resource-group * |
| [az aks nodepool show](/cli/azure/aks/nodepool#az-aks-nodepool-show) | Show the details for a node pool in the managed Kubernetes cluster.  | name *<br>resource-group * |
| [az aks nodepool get-upgrades](/cli/azure/aks/nodepool#az-aks-nodepool-get-upgrades) | Get the available upgrade versions for an agent pool of the managed Kubernetes cluster.  | name *<br>resource-group *<br>nodepool-name * |
| [az aks nodepool upgrade](/cli/azure/aks/nodepool#az-aks-nodepool-upgrade) | Upgrade the node pool in a managed Kubernetes cluster. | cluster-name *<br>resource-group *<br>name *<br>kubernetes-version * |
| [az aks nodepool scale](/cli/azure/aks/nodepool#az-aks-nodepool-scale) | Scale the node pool in a managed Kubernetes cluster.  | name *<br>resource-group *<br>nodepool-name<br>node-count |

## Next steps

[Learn about AKS on Azure Stack Hub](aks-overview.md)
