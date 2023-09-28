---
title: How to deploy AKS on Azure Stack HCI with Arc VMs
description: Learn how to deploy the AKS service on Azure Stack HCI with Arc VMs.
author: abha
ms.author: abha
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 09/21/2023
---


# How to install AKS service on Azure Stack HCI alongside Arc VMs

> Applies to: Azure Stack HCI

Arc VMs and Arc-provisioned AKS clusters share the same prerequisites: Arc Resource Bridge and custom location. This how-to guide walks you through enabling Arc-provisioned AKS clusters alongside Arc VMs on Azure Stack HCI.

If you want to install Arc-provisioned AKS clusters on Windows Server, see [Install Arc Resource Bridge and AKS service on Windows Server](deploy-arc-resource-bridge-windows-server.md).

## Prerequisites

- [Review system requirements for installing Arc provisioned AKS clusters on Azure Stack HCI](aks-hybrid-preview-requirements.md)
- [Install Arc Resource Bridge and Arc VMs using command line](/azure-stack/hci/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2) 
- Collect the following variables. You should have these after installing Arc VMs using the previous link:

| Parameter  |  Parameter details |
| -----------| ------------ |
| `$subscriptionID` | The Azure subscription ID where you installed Azure Arc Resource Bridge and custom location.  |
| `$resourceGroup` | The resource group in the Azure subscription listed previously, where you installed Arc Resource Bridge and custom location.  |
| `$resourceBridgeName` | The name of your Azure Arc Resource Bridge. |
| `$customLocationName` | The name of the custom location where you want to enable the AKS hybrid extension. |
| `$aksHybridExtnName` | The name of the AKS hybrid extension. This parameter can be any name; for example, **aks-hybrid-extn**. |

## Step 1: Verify that Arc Resource Bridge and custom location have been provisioned successfully

Run the following command to check if your Arc Resource Bridge is in a **running** state:

```azurecli
# Sign in to Azure
az account set -s $subscriptionID
```

```azurecli
az arcappliance show --resource-group $resourceGroup --name $resourceBridgeName --query "status" -o tsv
```

Expected output:

```output
Running
```

Run the following command to check if you have a functioning custom location in the **Succeeded** state:

```azurecli
az customlocation show --name $customLocationName --resource-group $resourceGroup --query "provisioningState" -o tsv
```

Expected output:

```output
Succeeded
```

(**Optional**) Verify if you have the Arc VMs extension installed on your Arc Resource Bridge and custom location. Your output should be the Azure Resource Manager ID of the Arc VMs extension:

### [PowerShell](#tab/powershell)

```azurecli
az k8s-extension list -g $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --query "[?extensionType == ``microsoft.azstackhci.operator``]" 
```

### [Az CLI](#tab/shell)

```azurecli
az k8s-extension list -g $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --query "[?extensionType == \`microsoft.azstackhci.operator\`]" 
```

---

## Step 2: Verify if the custom location is in the default namespace

Run the following command to return the Arc Resource Bridge namespace where you created the custom location:
```azurecli
az customlocation show --name $customLocationName --resource-group $resourceGroup --query "namespace" -o tsv
```

```Expected output
default
```

If your custom location is not in the default namespace, you will have to re-create the custom location. Note that doing so will delete all your existing Azure VMs, gallery images, etc. Delete all the Azure resources being managed by the custom location before proceeding. 

```azurecli
az customlocation delete --name <custom location name> --resource-group <resource group name>
```

Install the custom location in the default namespace.
```azurecli
$hciClusterId= (Get-AzureStackHci).AzureResourceUri
$resource_name= ((Get-AzureStackHci).AzureResourceName) + "-arcbridge"
$customloc_name= ((Get-AzureStackHci).AzureResourceName) + "-CL"
$subscription = <Azure subscription ID>
$resource_group = <Azure resource group>
$location = <Azure location. Available regions include "eastus" or "westeurope">
az customlocation create --resource-group $resource_group --name $customloc_name --cluster-extension-ids "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name/providers/Microsoft.KubernetesConfiguration/extensions/hci-vmoperator" --namespace default --host-resource-id "/subscriptions/$subscription/resourceGroups/$resource_group/providers/Microsoft.ResourceConnector/appliances/$resource_name" --location $location
```

# Step 3:
To install the AKS hybrid extension, run the following commands:

```azurecli
$aksHybridExtnName = "aks-hybrid-extn"
$release_train = "stable"
$version = "0.1.7"
az k8s-extension create --resource-group $resourceGroup --cluster-name $clusterName --cluster-type appliances --name $extensionName --extension-type Microsoft.HybridAKSOperator --config Microsoft.CustomLocation.ServiceAccount="default" --release-train $release_train --version $version --auto-upgrade-minor-version $false 
```

Once you have created the AKS hybrid extension on top of the Azure Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says **Succeeded**. It might say something else at first. This takes time, so try again after 10 minutes:

```azurecli
az k8s-extension show --resource-group $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --name $aksHybridExtnName --query "provisioningState" -o tsv
```

Expected output:

```output
Succeeded
```

## Step 3: Patch your existing custom location to support AKS hybrid alongside Arc VMs

Run the following commands to patch your existing custom location on top of the Arc Resource Bridge. Choose this custom location when creating virtual machines and AKS hybrid clusters through Azure.

Collect the Azure Resource Manager IDs of the Azure Arc Resource Bridge and the Azure Stack HCI VM and AKS hybrid extensions in variables:

### [PowerShell](#tab/powershell)

```azurecli
$ArcResourceBridgeId=az arcappliance show -g $resourceGroup --name $resourceBridgeName --query id -o tsv
$VMClusterExtensionResourceId=az k8s-extension list -g $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --query "[?extensionType == ``microsoft.azstackhci.operator``].id" -o tsv
$AKSClusterExtensionResourceId=az k8s-extension show -g $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --name $aksHybridExtnName --query id -o tsv
```

### [Az CLI](#tab/shell)

```azurecli
$ArcResourceBridgeId=az arcappliance show -g $resourceGroup --name $resourceBridgeName --query id -o tsv
$VMClusterExtensionResourceId=az k8s-extension list -g $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --query "[?extensionType == \`microsoft.azstackhci.operator\`].id" -o tsv
$AKSClusterExtensionResourceId=az k8s-extension show -g $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --name $aksHybridExtnName --query id -o tsv
```

---
  
You can then patch the custom location for your Azure Stack HCI cluster by running the following command:

```azurecli
az customlocation patch --name $customLocationName --namespace default --host-resource-id $ArcResourceBridgeId --cluster-extension-ids $VMClusterExtensionResourceId $AKSClusterExtensionResourceId --resource-group $resourceGroup
```

Once you've patched the custom location on top of the Azure Arc Resource Bridge, run the following command to check if the custom location has both AKS hybrid and Arc VM extensions installed:

```azurecli
az customlocation show --name $customLocationName --resource-group $resourceGroup --query "clusterExtensionIds" -o tsv
```

## Next steps

[Create networks and download VHD images for deploying AKS hybrid clusters from Azure](create-aks-hybrid-preview-networks.md)
