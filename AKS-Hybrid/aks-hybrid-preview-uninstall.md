---
title: Before you begin - uninstall the AKS hybrid cluster provisioning preview
description: Learn how to uninstall the AKS hybrid cluster provisioning from Azure preview.
ms.topic: overview
ms.date: 01/30/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: guanghu
ms.lastreviewed: 01/30/2024

---

# Before you begin: uninstall the AKS hybrid cluster provisioning preview

This step is only required if you installed the AKS hybrid cluster provisioning from Azure preview. The preview ended with the release of [AKS enabled by Azure Arc on HCI version 23H2](aks-overview.md). This article describes the steps to uninstall the preview bits before upgrading to AKS Arc.

## Step 1: delete all preview AKS hybrid clusters and Azure vnets created using Az CLI

```azurecli
az hybridaks delete --resource-group <resource group name> --name <aks-hybrid cluster name>
az hybridaks vnet delete --resource-group <resource group name> --name <vnet name>
```

## Step 2: delete the custom location

```azurecli
az customlocation delete --name <custom location name> --resource-group <resource group name>
```

## Step 3: delete the cluster extension

```azurecli
az k8s-extension delete --resource-group <resource group name> --cluster-name <arc appliance name> --cluster-type appliances --name <aks-hybrid extension name>
```

## Step 4: delete the Arc Resource Bridge

```azurecli
az arcappliance delete hci --config-file "<path to working directory>\hci-appliance.yaml"
```

## Step 5: delete the ArcHCI config files

```powershell
Remove-ArcHciAksConfigFiles -workDirectory <path to working directory>
```

## Next steps

[AKS Arc overview](aks-overview.md)