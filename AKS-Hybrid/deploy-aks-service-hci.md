---
title: How to deploy AKS service on Azure Stack HCI
description: How to deploy AKS service on Azure Stack HCI
author: abha
ms.author: abha
ms.topic: how-to
ms.custom: devx-track-azurecli
ms.date: 05/04/2023
---


# How to install AKS service on Azure Stack HCI, along side Arc VMs
> Applies to: Azure Stack HCI

Arc VMs and Arc provisioned AKS clusters share the same pre-requisites - Arc Resource Bridge and custom location. This how-to guide walks you through enabling Arc provisioned AKS clusters along side Arc VMs on Azure Stack HCI.
If you want to install Arc provisioned AKS clusters on Windows Server, follow this guide [Install Arc Resource Bridge and AKS service on Windows Server]().


## Pre-requisites
- [Review system requirements for installing Arc provisioned AKS clusters on Azure Stack HCI](aks-hybrid-preview-requirements.md)
- [Install Arc Resource Bridge and Arc VMs using command line](/azure-stack/hci/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2) 
- Collect the following variables. You should have these after installing Arc VMs using the above link.

| Parameter  |  Parameter details |
| -----------| ------------ |
| $subscriptionID | The Azure subscription ID where you installed Azure Arc Resource Bridge & custom location.  |
| $resourceGroup | The resource group in the Azure subscription listed above where you installed Arc Resource Bridge & custom location.  |
| $resourceBridgeName | The name of your Azure Arc Resource Bridge. |
| $customLocationName | The name of your custom location where you want to enable AKS hybrid extension. |
| $aksHybridExtnName| The name of the AKS hybrid extentinsion name, it can be any name (ie. AKSExtension-01). 


## Step 1: Verify if your Arc Resource Bridge and custom location have been provisioned successfully. 
#### Run the following command to check if your Arc Resource Bridge is in "running" state.
```azurecli
#login to Azure
az account set -s $subscriptionID
```

```azurecli
az arcappliance show --resource-group $resourceGroup --name $resourceBridgeName --query "status" -o tsv
```
Expected output:
```output
Running
```

#### Run the following command to check if you have a functioning custom location in the "Succeeded" state.
```azurecli
az customlocation show --name $customLocationName --resource-group $resourceGroup --query "provisioningState" -o tsv
```

Expected output:
```output
Succeeded
```

#### **Optional** Verify if you have Arc VMs extension installed on your Arc Resource Bridge & custom location. Your output should be the ARM ID of the Arc VMs extension.
### [PowerShell](#tab/powershell)

```azurecli
az k8s-extension list -g $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --query "[?extensionType == ``microsoft.azstackhci.operator``]" 
```
### [Az CLI](#tab/shell)

```azurecli
az k8s-extension list -g $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --query "[?extensionType == \`microsoft.azstackhci.operator\`]" 
```

---

## Step 2: Install the AKS hybrid extension on the Azure Arc Resource Bridge 
Run the following command to obtain the Arc Resource Bridge namespace where you created the custom location.
```azurecli
$namespace = az customlocation show --name $customLocationName --resource-group $resourceGroup --query "namespace" -o tsv
```

To install the AKS hybrid extension, run the following command:
```azurecli
$aksHybridExtnName = "aks-hybrid-extn"
az k8s-extension create --resource-group $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --name $aksHybridExtnName --extension-type Microsoft.HybridAKSOperator --config Microsoft.CustomLocation.ServiceAccount=$namespace   
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
Run the following commands to patch your existing custom location on top of the Arc Resource Bridge. You will choose this custom location when creating virtual machines and AKS hybrid clusters through Azure.

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
az customlocation patch --name $customLocationName --namespace $namespace --host-resource-id $ArcResourceBridgeId --cluster-extension-ids $VMClusterExtensionResourceId $AKSClusterExtensionResourceId --resource-group $resourceGroup
```

Once you've patched the custom location on top of the Azure Arc Resource Bridge, run the following command to check if the custom location has both AKS hybrid and Arc VM extensions installed on it by running the following command.

```azurecli
az customlocation show --name $customLocationName --resource-group $resourceGroup --query "clusterExtensionIds" -o tsv
```

## Next steps
[Create networks and download VHD images for deploying AKS hybrid clusters from Azure](create-aks-hybrid-preview-networks.md)
