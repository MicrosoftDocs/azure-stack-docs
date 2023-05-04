---
title: How to deploy AKS service on Azure Stack HCI
description: How to deploy AKS service on Azure Stack HCI
author: abha
ms.author: abha
ms.topic: how-to
ms.date: 05/04/2023
---


# How to install AKS service on Azure Stack HCI, along side Arc VMs
> Applies to: Azure Stack HCI

Arc VMs and Arc provisioned AKS clusters share the same pre-requisites - Arc Resource Bridge and custom location. This how-to guide walks you through enabling Arc provisioned AKS clusters along side Arc VMs on Azure Stack HCI.
If you want to install Arc provisioned AKS clusters on Windows Server, follow this guide [Install Arc Resource Bridge and AKS service on Windows Server]().


## Pre-requisites
- [Review system requirements for installing Arc provisioned AKS clusters on Azure Stack HCI]()
- Install Arc Resource Bridge and Arc VMs by following [deploy Arc Resource Bridge using command line](https://learn.microsoft.com/en-us/azure-stack/hci/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2) 


## Step 1: Verify if Arc Resource Bridge is in "running" state
Run the following command to check if your Arc Resource Bridge is in "running" state.

```
#login to Azure
az account set -s $subscriptionID
```

```azurecli
az arcappliance show --resource-group $resourceGroup --name $resourceBridgeName --query "status" -o tsv
```
Expected output:
```
Running
```

| Parameter  |  Parameter details |
| -----------| ------------ |
| $subscriptionID | The Azure subscription ID where you installed Azure Arc Resource Bridge.  |
| $resourceGroup | The resource group in the Azure subscription listed above where you installed Arc Resource Bridge.  |
| $resourceBridgeName | The name of your Azure Arc Resource Bridge. |

## Step 2: Verify if you've correctly set up a custom location for your Azure Stack HCI cluster
Run the following command to check if you have a functioning custom location in the "Succeeded" state.

```azurecli
az customlocation show --name $clName --resource-group $resourceGroup --query "provisioningState" -o tsv
```

Expected output:
```
Succeeded
```
| Parameter  |  Parameter details |
| -----------| ------------ |
| $resourceGroup | The resource group in the same Azure subscription as Arc Resource Bridge, where you created a custom location.  |
| $clName | The name of your custom location. |

## Step 3: Install the AKS service extension on the Azure Arc Resource Bridge 
Run the following command to obtain the Arc Resource Bridge namespace where you created the custom location.
```azurecli
$namespace = az customlocation show --name $clName --resource-group $resourceGroup --query "namespace" -o tsv
```

To install the AKS service extension, run the following command:
```azurecli
az k8s-extension create --resource-group $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --name $AKSServiceName --extension-type Microsoft.HybridAKSOperator --config Microsoft.CustomLocation.ServiceAccount=$namespace   
```

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| $resourceGroup |  A resource group in the Azure subscription. Make sure you use the same resource group you used when deploying Azure Arc Resource Bridge.  |
| $resourceBridgeName  |  The name of your Azure Arc Resource Bridge. |
| $AKSServiceName  |  Name of your AKS hybrid extension to be created on top of Azure Arc Resource Bridge.  |
| cluster-type  | Must be `appliances`. Do not change this value.  |
| extension-type  |  Must be `Microsoft.HybridAKSOperator`. Do not change this value. |
| $namespace  | the Arc Resoource Bridge namespace where you created the custom location. You can get this value by running `az customlocation show --name $clName --resource-group $resourceGroup --query "namespace" -o tsv` |

Once you have created the AKS hybrid extension on top of the Azure Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says **Succeeded**. It might say something else at first. This takes time, so try again after 10 minutes:

```azurecli
az k8s-extension show --resource-group $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --name $AKSServiceName --extension-type Microsoft.HybridAKSOperator --query "provisioningState" -o tsv
```

## Step 4: Patch your existing custom location to support AKS hybrid alongside Arc VMs
Run the following commands to patch your existing custom location on top of the Arc Resource Bridge. You will choose this custom location when creating virtual machines and AKS hybrid clusters through Azure.

Collect the Azure Resource Manager IDs of the Azure Arc Resource Bridge and the Azure Stack HCI VM and AKS hybrid extensions in variables:

```azurecli
$ArcResourceBridgeId=az arcappliance show --resource-group $resourceGroup --name $resourceBridgeName --query id -o tsv
$VMClusterExtensionResourceId=az k8s-extension show --resource-group $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --name $ArcVMName --query id -o tsv
$AKSClusterExtensionResourceId=az k8s-extension show --resource-group $resourceGroup --cluster-name $resourceBridgeName --cluster-type appliances --name $AKSServiceName --query id -o tsv
```
  
You can then patch the custom location for your Azure Stack HCI cluster by running the following command:

```azurecli
az customlocation patch --name $CLname --namespace $namespace --host-resource-id $ArcResourceBridgeId --cluster-extension-ids $VMClusterExtensionResourceId $AKSClusterExtensionResourceId --resource-group $resourceGroup
```

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| $resourceGroup |  A resource group in the Azure subscription listed above. Make sure you use the same resource group you used when deploying Arc Resource Bridge. |
| $namespace  | the Arc Resoource Bridge namespace where you created the custom location. You can get this value by running `az customlocation show --name $clName --resource-group $resourceGroup --query "namespace" -o tsv` |
| $CLname  |  Name of your Azure Stack HCI Custom Location that you created for Arc VMs. |
| host-resource-id  | Resource Manager ID of the Azure Arc Resource Bridge. |
| cluster-extension-ids   | Resource Manager IDs of the Azure Stack HCI VM and AKS hybrid extensions. |

Once you've patched the custom location on top of the Azure Arc Resource Bridge, run the following command to check if the custom location has both AKS hybrid and Arc VM extensions installed on it by running the following command.

```azurecli
az customlocation show --name $CLname --resource-group $resourceGroup --query "clusterExtensionIds" -o tsv
```

  
## Next steps
[Create networks and download VHD images for deploying AKS hybrid clusters from Azure](create-aks-hybrid-preview-networks.md)
