---
title: Install and uninstall Kubernetes Extension for AKS Arc Operators (preview)
description: Learn how to install and uninstall the Kubernetes Extension for AKS Arc Operators.
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 03/21/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: leslielin
ms.lastreviewed: 03/21/2024
---

# Enable the Kubernetes Extension for AKS Arc Operators (preview)

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

To use the AKS Arc on VMware preview, you must first onboard [Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/overview) by connecting vCenter to Azure through the [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview) There are two scenarios available for accessing this preview:

- If you deploy the Arc Resource Bridge with the Kubernetes Extension for AKS Arc Operators installed, you should only follow [Step #1: register feature/provider for the first time user](#step-1-register-featureprovider-for-the-first-time-user), and [Step #2: install the `aksarc` CLI extension](#step-2-install-the-aksarc-cli-extension).
- If you deploy the Arc Resource Bridge without installing the Kubernetes Extension for AKS Arc Operators, follow all the steps in this article.

## Before you begin

Before you begin, [install the Azure CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli).

## Step 1. Register feature/provider for the first time user

If your subscription is deploying the Kubernetes Extension for AKS Arc Operators (preview) for the first time, you must register the preview features.

1. Prepare your Azure account:

   ```azurecli
    az login --use-device-code
    az account set -s '<$subscriptionID>'
    ```

1. Perform a one-time feature registration:

   ```azurecli
   ### Register your subscription ID with the feature
   az feature register --namespace Microsoft.HybridConnectivity --name hiddenPreviewAccess

   ### Check feature registrationState -o tsv == Registered
   az feature show --name hiddenPreviewAccess --namespace Microsoft.HybridConnectivity
    ```

1. Perform a one-time provider registration:

   ```azurecli
   ### Register your subscription ID with the provider
   az provider register --namespace "Microsoft.HybridContainerService" 
   az provider register --namespace "Microsoft.HybridConnectivity"

   ### Check provider registrationState -o tsv == Registered
   az provider show -n Microsoft.HybridContainerService --query registrationState
   az provider show -n Microsoft.HybridConnectivity --query registrationState
   ```

## Step 2. Install the aksarc CLI extension

Install the CLI extension. Use the [az extension add](/cli/azure/extension#az-extension-add) command:

```azurecli
az extension add -n aksarc --version 1.0.0b1
az extension add -n connectedk8s
az extension add -n k8s-extension
az extension add -n arcappliance
az extension add -n customlocation
```

## Step 3. Install the Kubernetes Extension for AKS Arc Operators

1. Specify the version of the Kubernetes extension for AKS Arc operators:

   ```PowerShell
   $extension_name = 'hybridaksopext'
   $extension_version = '0.4.5'
   $extension_release_train = 'preview'
   ```

   ```Bash
   export extension_name='hybridaksopext'
   export extension_version='0.4.5'
   export extension_release_train='preview'
   ```

1. Specify the `$resource_group` and `$appliance_name`:

   ```azurecli
   $resource_group = '$resourceGroup from Arc Resource Bridge deployment'
   $appliance_name = '$applianceName from Arc Resource Bridge deployment'
   ```

1. Install the Kubernetes extension for AKS Arc operators:

   ```azurecli
   az k8s-extension create -g $resource_group -c $appliance_name --cluster-type appliances --name $extension_name --extension-type Microsoft.HybridAKSOperator --version $extension_version --release-train $extension_release_train --config Microsoft.CustomLocation.ServiceAccount="default" --auto-upgrade false 
   ```

## Step 4. Prepare your custom location

The custom location was created during the Arc Resource Bridge deployment.

1. Get the IDs to configure the custom location:

   ```azurecli
   ### $extension_name = 'hybridaksopext'
   $ArcApplianceResourceId = (az arcappliance show -g $resource_group -n $appliance_name --query id -o tsv)
   $ClusteraksExtensionId = (az k8s-extension show -g $resource_group -c $appliance_name --cluster-type appliances --name $extension_name --query id -o tsv)
   ```

1. Specify the `$customLocationResourceGroupName` and `$customLocationName`, which you created during the Arc Resource Bridge deployment:

   ```azurecli
   $customLocationResourceGroupName = '$resourceGroup from Arc Resource Bridge deployment'
   $customLocationName = '$customLocationName from Arc Resource Bridge deployment'
   ```

1. Patch the custom location: `ProvisioningState: "Patching"`. 

   ```azurecli
   ### Use the same custom location information from the Arc Resource Bridge deployment
   az customlocation patch -g $customLocationResourceGroupName -n $customLocationName --cluster-extension-ids $clusteraksExtensionId
   ```

1. Verify the custom location provisioning state is successful: `ProvisioningState: "Succeeded"`:

   ```azurecli
   az customlocation show -g $customLocationResourceGroupName -n $customLocationName 
   ```

Now that you successfully enabled the Kubernetes Extension for AKS Arc Operators (preview), you can proceed to the next steps to create a Kubernetes cluster.

## Clean up environment from deployments of AKS Arc on VMware

Once you complete the evaluation of the AKS Arc on VMware preview, you can follow these steps to clean up your environment:

1. Delete the AKS cluster. To delete the workload cluster, use the [az aksarc delete](/cli/azure/aksarc#az-aksarc-delete) command, or go to the Azure portal:

   ```azurecli
   az aksarc delete -n '<cluster name>' -g $applianceResourceGroupName
   ```

1. Uninstall the Kubernetes Extension. You can uninstall the Kubernetes Extension for AKS Arc Operators by using the [az extension remove](/cli/azure/extension#az-extension-remove) command:

   ```azurecli
   az extension remove -n aksarc
   az extension remove -n connectedk8s
   ```

## Next steps

- If you're beginning to evaluate the AKS Arc on VMware preview and finished enabling the Kubernetes Extension for AKS Arc Operators, you can create a Kubernetes cluster by following the instructions in the [Quickstart: Deploy an AKS cluster using Azure CLI](aks-vmware-quickstart-deploy.md).
- If you completed the evaluation of AKS Arc on VMware, you can share your feedback with us through [GitHub](https://github.com/Azure/aksArc/issues).
