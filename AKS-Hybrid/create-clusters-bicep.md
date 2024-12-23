---
title: Create Kubernetes clusters using Bicep
description: Learn how to create Kubernetes clusters in Azure Local using Bicep.
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 07/26/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: haojiehang
ms.lastreviewed: 07/24/2024

---

# Create Kubernetes clusters using Bicep

This article describes how to create Kubernetes clusters in Azure Local using Bicep. The workflow is as follows:

1. Create an SSH key pair
1. Create a Kubernetes cluster in Azure Local, version 23H2 using Bicep. By default, the cluster is Azure Arc-connected.
1. Validate the deployment and connect to the cluster.

## Before you begin

Before you begin, make sure you have the following prerequisites:

1. Get the following details from your on-premises infrastructure administrator:

   - Azure subscription ID: the Azure subscription ID that uses Azure Local for deployment and registration.
   - Custom location name or ID: the Azure Resource Manager ID of the custom location. The custom location is configured during the Azure Local cluster deployment. Your infrastructure admin should give you the Resource Manager ID of the custom location. This parameter is required in order to create Kubernetes clusters. You can also get the Resource Manager ID using `az customlocation show --name "<custom location name>" --resource-group <azure resource group> --query "id" -o tsv`, if the infrastructure admin provides a custom location name and resource group name.
   - Logical network name or ID: the Azure Resource Manager ID of the Azure Local logical network that was created following these steps. Your admin should give you the ID of the logical network. This parameter is required in order to create Kubernetes clusters. You can also get the Azure Resource Manager ID using `az stack-hci-vm network lnet show --name "<lnet name>" --resource-group <azure resource group> --query "id" -o tsv` if you know the resource group in which the logical network was created.

1. Make sure you have the [latest version of Azure CLI](/cli/azure/install-azure-cli) on your development machine. You can also upgrade your Azure CLI version using `az upgrade`.
1. Download and install **kubectl** on your development machine. The Kubernetes command-line tool, **kubectl**, enables you to run commands against Kubernetes clusters. You can use **kubectl** to deploy applications, inspect and manage cluster resources, and view logs.

## Create an SSH key pair

To create an SSH key pair (same as Azure AKS), use the following procedure:

1. [Open a Cloud Shell session](https://shell.azure.com) in your browser or open a terminal on your local machine.
1. Create an SSH key pair using `az sshkey create`:

   ```azurecli
   az sshkey create --name <Public_SSH_Key> --resource-group <Resource_Group_Name>
   ```

   Or, create a local SSH key pair using `ssh-keygen`:

   ```bash  
   ssh-keygen -t rsa -b 4096
   ```

It's recommended that you create an SSH key pair in Azure, as you can use it later for node access or troubleshooting. For more information about creating SSH keys, see [Create and manage SSH keys for authentication in Azure](/azure/virtual-machines/linux/create-ssh-keys-detailed) and [Restrict SSH Access](restrict-ssh-access.md).

## Download and update the Bicep scripts

You need to download two files for your Bicep deployment: **main.bicep** and **aksarc.bicepparam** from [AKSArc Github repo](https://github.com/Azure/aksArc/tree/main/deploymentTemplates). Please update the parameters from aksarc.bicepparam as needed and make sure all the default values from main.bicep are correct.

The **Microsoft.HybridContainerService/provisionedClusterInstances** resource type is defined in file main.bicep. If you want to customize more properties for cluster creation, please see [provisionedClusterInstances API Reference](/azure/templates/microsoft.hybridcontainerservice/provisionedclusterinstances?pivots=deployment-language-bicep).

## Deploy the Bicep templates

Create a Bicep deployment using Azure CLI:

   ```azurecli
   az deployment group create --name BicepDeployment --resource-group <Resource_Group_Name> --parameters aksarc.bicepparam
   ```

## Validate the deployment and connect to the cluster

You can now connect to your Kubernetes cluster by running `az connectedk8s proxy` command from your development machine. You can also use **kubectl** to see the node and pod status. Follow the same steps as described in [Connect to the Kubernetes cluster](aks-create-clusters-cli.md#connect-to-the-kubernetes-cluster).

## Next steps

[Create Kubernetes clusters using Azure CLI](aks-create-clusters-cli.md)
