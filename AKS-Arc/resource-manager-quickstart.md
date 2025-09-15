---
title: Deploy a Kubernetes (AKS) cluster using an Azure Resource Manager template
description: Learn how to deploy a Kubernetes cluster in AKS enabled by Azure Arc using an Azure Resource Manager template.
ms.topic: quickstart-arm
ms.custom: devx-track-arm-template, devx-track-azurecli
ms.date: 02/26/2025
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 01/31/2024
ms.reviewer: rbaziwane
---

# Quickstart: deploy a Kubernetes cluster using an Azure Resource Manager template

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This quickstart shows how to deploy a Kubernetes cluster in AKS Arc using an Azure Resource Manager (ARM) template. Azure Arc extends Azure management capabilities to Kubernetes clusters anywhere, providing a unified approach to managing different environments.

## Before you begin

This article assumes a basic understanding of Kubernetes concepts.

To deploy an ARM template, you need write access on the resources you're deploying, and access to all operations on the **Microsoft.Resources/deployments** resource type. For example, to deploy a virtual machine, you need **Microsoft.Compute/virtualMachines/write** and **Microsoft.Resources/deployments/\*** permissions. For a list of roles and permissions, see [Azure built-in roles](/azure/role-based-access-control/built-in-roles).

### Prerequisites

- An Azure account with an active subscription.
- An Azure Local cluster.
- The latest Azure CLI version.

## Step 1: Prepare your Azure account

1. Sign in to Azure: open your terminal or command prompt and sign in to your Azure account using the Azure CLI:

   ```azurecli
   az login
   ```

1. Set your subscription: replace `<your-subscription-id>` with your subscription ID:

   ```azurecli
   az account set --subscription "<your-subscription-id>"
   ```

## Step 2: Create an SSH key pair

Create an SSH key pair in Azure and store the private key file for troubleshooting and log collection purposes. For detailed instructions, see [Create and store SSH keys with the Azure CLI](/azure/virtual-machines/ssh-keys-azure-cli), or in the [Azure portal](/azure/virtual-machines/ssh-keys-portal).

1. [Open a Cloud Shell session](https://shell.azure.com/) in your web browser or launch a terminal on your local machine.
1. Create an SSH key pair using the [az sshkey create](/cli/azure/sshkey#az-sshkey-create) command:

   ```azurecli
   az sshkey create --name "mySSHKey" --resource-group $<resource_group_name>
   ```

   or, use the `ssh-keygen` command:

   ```azurecli
   ssh-keygen -t rsa -b 4096 
   ```

1. Retrieve the value of your public key from Azure or from your local machine under **/.ssh/id_rsa.pub**.

For more options, you can either follow [Configure SSH keys for an AKS cluster](/azure/aks/aksarc/configure-ssh-keys) to create SSH keys, or use [Restrict SSH access](/azure/aks/aksarc/restrict-ssh-access) during cluster creation. To access nodes afterward, see [Connect to Windows or Linux worker nodes with SSH](/azure/aks/aksarc/ssh-connect-to-windows-and-linux-worker-nodes).


## Step 3: Review the template

Download the template and parameter files from the [AKSArc repo](https://github.com/Azure/aksArc/tree/main/deploymentTemplates) to your local machine. Review all the default values and ensure they are correct.

## Step 4: Deploy the template

To deploy the Kubernetes cluster, run the following command:

```azurecli
az deployment group create \
--name "<deployment-name>" \
--resource-group "<resource-group-name>" \
--template-file "azuredeploy.json" \
--parameters "azuredeploy.parameters.json"
```

It takes a few minutes to create the cluster. Wait for the cluster to be successfully deployed before you move on to the next step.

## Step 5: Verify the deployment

Once the deployment is complete, use the following command to verify that your Kubernetes cluster is up and running:

```azurecli
az aksarc show --resource-group "<resource-group-name>" --name "<cluster-name>" --output table
```

## Step 6: Connect to the cluster

1. To connect to the cluster, run the `az connectedk8s proxy` command. The command downloads and runs a proxy binary on the client machine, and fetches a **kubeconfig** file associated with the cluster:

   ```azurecli
   az connectedk8s proxy --name <cluster name> -g <resource group>
   ```

   Or, use the Kubernetes command-line client, **kubectl**. If you use Azure Cloud Shell, **kubectl** is already installed. To install and run **kubectl** locally, run the `az aksarc install-cli` command.

   Configure **kubectl** to connect to your Kubernetes cluster using the `az aksarc get-credentials` command. This command downloads credentials and configures the Kubernetes CLI to use them:

   ```azurecli
   az aksarc get-credentials --resource-group "<resource-group-name>" --name "<cluster-name>"
   ```

1. Verify the connection to your cluster using the `kubectl get` command. This command returns a list of the cluster nodes:

   ```cmd
   kubectl get nodes -A --kubeconfig .\<path to kubecofig> 
   ```

   The following example output shows the three nodes created in the previous steps. Make sure the node status is **Ready**:

   ```output
   NAME                                STATUS   ROLES   AGE   VERSION
   aks-agentpool-27442051-vmss000000   Ready    agent   10m   v1.27.7
   aks-agentpool-27442051-vmss000001   Ready    agent   10m   v1.27.7
   aks-agentpool-27442051-vmss000002   Ready    agent   11m   v1.27.7
   ```

## Step 7: Deploy node pool using an Azure Resource Manager template (optional)

Similiar to step 3, download the node pool template and parameters from the [AKSArc repo](https://github.com/Azure/aksArc/tree/main/deploymentTemplates) and review the default values.

## Step 8: Deploy the template and validate the deployment (optional)

Review and apply the template. This process takes a few minutes to complete. You can use the Azure CLI to validate that the node pool is created successfully:

```azurecli
az deployment group create \
--name "<deployment-name>" \
--resource-group "<resource-group-name>" \
--template-file "azuredeploy.json" \
--parameters "azuredeploy.parameters.json"
```

```azurecli
az aksarc nodepool show --cluster-name "<cluster-name>" --resource-group "<resource-group-name>" --name "<nodepool-name>"
```

## Template resources

### connectedClusters

| Name             | Description                                         | Value                                                        |
| :--------------- | :-------------------------------------------------- | :----------------------------------------------------------- |
| `type`             | The resource type.                                   | **Microsoft.Kubernetes/ConnectedClusters**                 |
| `apiVersion`       | The resource API version.                            | **2024-01-01**                                                 |
| `name`             | The resource name.                                   | String (required)<br> Character limit: 1-63 <br> Valid characters: Alphanumerics, underscores, and hyphens. <br> Start and end with alphanumeric. |
| `location`         | The geo-location in which the resource lives.           | String (required).                                            |
| `tags`             | Resource tags.                                      | Dictionary of tag names and values. See [Tags in templates](/azure/azure-resource-manager/management/tag-resources-templates). |
| `extendedLocation` | The extended location of the virtual machine.       | [ExtendedLocation](/azure/templates/microsoft.containerservice/managedclusters?pivots=deployment-language-arm-template#extendedlocation-1) |
| `identity`         | The identity of the connected cluster, if configured. |  |
| `properties`       | Properties of a connected cluster.                    |  |

### ProvisionedClusterInstances

| Name             | Description                                         | Value                                                        |
| :--------------- | :-------------------------------------------------- | :----------------------------------------------------------- |
| `type`             | The resource type                                   | **microsoft.hybridcontainerservice/provisionedclusterinstances**                 |
| `apiVersion`       | The resource API version                            | **2024-01-01**                                                 |
| `name`             | The resource name                                   | String (required). Don't change this from **default**. |
| `properties`       | Properties of a connected cluster.                    |  |
| `extendedLocation` | The extended location of the cluster.       | [ExtendedLocation](/azure/templates/microsoft.containerservice/managedclusters?pivots=deployment-language-arm-template#extendedlocation-1) |

### ExtendedLocation

| Name | Description                        | Value      |
| :--- | :--------------------------------- | :--------- |
| `name` | The ID of the extended location. | string     |
| `type` | The type of the extended location. | **CustomLocation** |

## Next steps

[AKS Arc overview](overview.md)
