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

AKS service is an extension installed on Arc Resource Bridge. This extension allows you to manage Arc provisioned AKS clusters from Azure portal. AKS service shares the same pre-requisites with Arc VMs on Azure Stack HCI. The how-to guide walks you through how to install the AKS service, and get started with managing Arc enabled AKS clusters from Azure, on Azure Stack HCI

## Pre-requisites
Make sure you've installed Arc VMs by following this document - https://learn.microsoft.com/en-us/azure-stack/hci/manage/deploy-arc-resource-bridge-using-command-line?tabs=for-static-ip-address-1%2Cfor-static-ip-address-2


## Step 1: Verify if Arc Resource Bridge is up and running
We need to first ensure that Arc Resource Bridge is up and running. Run the following command to check this -


## Step 2: Verify if you've correctly set up a custom location for your Azure Stack HCI cluster


## Step 3: Install the AKS hybrid extension on the Azure Arc Resource Bridge 
To install the AKS hybrid extension, run the following command:

```azurecli
az account set -s <subscription ID>

az k8s-extension create --resource-group <azure resource group> --cluster-name <arc resource bridge name> --cluster-type appliances --name <aks hybrid cluster extension name> --extension-type Microsoft.HybridAKSOperator --config Microsoft.CustomLocation.ServiceAccount="default"   
```

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| resource-group |  A resource group in the Azure subscription. Make sure you use the same resource group you used when deploying Azure Arc Resource Bridge.  |
| cluster-name  |  The name of your Azure Arc Resource Bridge. |
| name  |  Name of your AKS hybrid cluster extension to be created on top of Azure Arc Resource Bridge.  |
| cluster-type  | Must be `appliances`. Do not change this value.  |
| extension-type  |  Must be `Microsoft.HybridAKSOperator`. Do not change this value. |
| config  | Must be `config Microsoft.CustomLocation.ServiceAccount="default"`. Do not change this value. |

Once you have created the AKS hybrid extension on top of the Azure Arc Resource Bridge, run the following command to check if the cluster extension provisioning state says **Succeeded**. It might say something else at first. This takes time, so try again after 10 minutes:

```azurecli
az k8s-extension show --resource-group <resource group name> --cluster-name <azure arc resource bridge name> --cluster-type appliances --name <aks hybrid extension name> --query "provisioningState" -o tsv
```

## Step 5: Patch your existing custom location to support AKS service
Run the following commands to patch your existing custom location on top of the Arc Resource Bridge. You will choose this custom location when creating virtual machines or AKS clusters through Azure.

Collect the Azure Resource Manager IDs of the Azure Arc Resource Bridge and the Azure Stack HCI VM and AKS hybrid extensions in variables:

```azurecli
$ArcResourceBridgeId=az arcappliance show --resource-group <resource group name> --name <arc resource bridge name> --query id -o tsv
$VMClusterExtensionResourceId=az k8s-extension show --resource-group <resource group name> --cluster-name <arc resource bridge name> --cluster-type appliances --name <azure stack hci VM extension name> --query id -o tsv
$AKSClusterExtensionResourceId=az k8s-extension show --resource-group <resource group name> --cluster-name <arc resource bridge name> --cluster-type appliances --name <AKS hybrid extension name> --query id -o tsv
```

Collect the namespace of your custom location in a variable:
```azurecli
az customlocation show --name <custom location name> --resource-group <resource group name> --query "namespace" -o tsv
```
  
You can then create the custom location for your Azure Stack HCI cluster running the following command:

```azurecli
az customlocation patch --name <customlocation name> --namespace "default" --host-resource-id $ArcResourceBridgeId --cluster-extension-ids $VMClusterExtensionResourceId $AKSClusterExtensionResourceId --resource-group <resource group name>
```

|  Parameter  |  Parameter details  |
| ------------|  ----------------- |
| resource-group |  A resource group in the Azure subscription listed above. Make sure you use the same resource group you used when deploying Arc Resource Bridge. |
| namespace  |  Must be `default`. Do not change this value. |
| name  |  Name of your Azure Stack HCI Custom Location |
| host-resource-id  | Resource Manager ID of the Azure Arc Resource Bridge. |
| cluster-extension-ids   | Resource Manager IDs of the Azure Stack HCI VM and AKS hybrid extensions. |

Once you create the custom location on top of the Azure Arc Resource Bridge, run the following command to check if the custom location provisioning state says **Succeeded**. It might say something else at first. This takes time, so try again after 10 minutes:

```azurecli
az customlocation show --name <custom location name> --resource-group <resource group name> --query "provisioningState" -o tsv
```
  
## Next steps
[Create networks and download VHD images for deploying AKS hybrid clusters from Azure](create-aks-hybrid-preview-networks.md)
