---
title: Create and access AKS hybrid clusters provisioned from Azure using Az CLI
description: Create and access AKS hybrid clusters provisioned from Azure using Az CLI
author: abha
ms.author: abha
ms.topic: how-to
ms.date: 09/29/2022
---
> Applies to: Windows Server 2019, Windows Server 2022, Azure Stack HCI


# Overview

In this walkthrough you will create an AKS hybrid cluster using the Azure control plane. The cluster will be Azure Arc connected by default. While creating the cluster, you can provide an AAD group that contains the list of AAD users with Kubernetes cluster administrator access. After you have created the AKS hybrid cluster, you will be able to authenticate to the cluster using your AAD account. You can also delegate cluster administration to other members of the group for further access and configuration and delegate access to the cluster to non-administrator users.

# Before you begin
 
Before you begin, make sure you have the following details from your Azure and Azure Stack HCI administrator:

| Parameter |  Parameter details |
| --------- | ------------------|
| Azure subscription ID | Your Azure admin should give you the Azure subscription ID where creating AKS hybrid has been enabled, and where the pre-requisites to creating ASK hybrid clusters exist.
| Custom-location  | ARM ID of the custom location. Your admin should give you the ARM ID of the custom location. This is a required parameter to create AKS clusters. You can also get the ARM ID using `az customlocation show --name <custom location name> --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group where the custom location has been created.
| vnet-id | ARM ID of the Azure hybridaks vnet. Your admin should give you the ARM ID of the Azure vnet. This is a required parameter to create AKS clusters. You can also get the ARM ID using `az hybridaks vnet show --name <vnet name> --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group where the Azure vnet has been created.

## Installing Az CLI and hybridAKS extension

Make sure you have the latest version of Az CLI installed on your dev box. [Install Az CLI](https://docs.microsoft.com/cli/azure/install-azure-cli). You can also choose to upgrade your Az CLI using `az upgrade`.

Confirm that you have alteast v2.34.0 of Az CLI installed using `az -v`

```
azure-cli                         2.34.1

core                              2.34.1
telemetry                          1.0.6
```

```azurecli
az extension remove -n hybridaks
az extension add --source "https://hybridaksstorage.z13.web.core.windows.net/HybridAKS/CLI/hybridaks-0.1.4-py3-none-any.whl" --yes
az hybridaks -h
```

## Create an AKS hybrid cluster using Az CLI 
Use the `az hybridaks create` command to create an AKS hybrid cluster using Az CLI. To create the cluster, you need to pass a list of AAD group or user object IDs that will have full cluster administrator privileges to the AKS cluster. To learn more about creating AAD groups and adding users, review this [documentation](https://docs.microsoft.com/azure/active-directory/fundamentals/active-directory-groups-create-azure-portal).

```azurecli
az hybridaks create -n <aks-hybrid cluster name> -g <Azure resource group> --custom-location <ARM ID of the custom location> --vnet-ids <ARM ID of the Azure hybridaks vnet> --kubernetes-version "v1.21.9" --aad-admin-group-object-ids <comma seperated list of AAD group IDs> --generate-ssh-keys 
```
You can skip adding --generate-ssh-keys if you already have an SSH key named `id_rsa` in the ~/.ssh folder.

### Show the AKS hybrid cluster
```azurecli
az hybridaks show -n <aks-hybrid cluster name> -g <Azure resource group>
```

### Add a nodepool to your AKS hybrid cluster
```
az hybridaks nodepool add --name <node pool name> --cluster-name <aks-hybrid cluster name> -g <Azure resource group>
```

### List nodepools in your AKS hybrid cluster
```
az hybridaks nodepool list --cluster-name <aks-hybrid cluster name> -g <Azure resource group>
```

## Access the AKS hybrid cluster using Az CLI 
Login to Azure and run the following command. Make sure you have installed the `hybridaks` extension in your environment.

```azurecli
az login -t <tenantID>
az account set --subscription <subscriptionId>
az hybridaks proxy --name <aks-hybrid cluster name> --resource-group <Azure resource group> 
```

Expected output:
```output
Proxy is listening on port 47011
Merged "aks-workload" as current context in C:\Users\contoso\.kube\config
Start sending kubectl requests on 'aks-workload' context using kubeconfig at C:\Users\contoso\.kube\config
Press Ctrl+C to close proxy.
```

Keep this session running and connect to your AKS hybrid cluster from a different terminal/command prompt.
```
kubectl get pods -A 
```

### Delete a nodepool on your AKS hybrid cluster
```
az hybridaks nodepool delete --name <node pool name> --cluster-name <aks-hybrid cluster name> -g <Azure resource group>
```

## Delete AKS hybrid cluster 

```azurecli
az hybridaks delete --resource-group <resource group name> --name <akshci cluster name>
```

# Next Steps
[Deploy Azure Defender and other services on your AKS hybrid preview cluster using Azure Arc extensions]()
