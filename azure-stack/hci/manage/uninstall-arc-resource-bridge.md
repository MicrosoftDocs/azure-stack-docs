---
title: Uninstall Azure Arc VM management 
description: Learn how to uninstall Azure Arc VM management.
author: ksurjan
ms.author: ksurjan
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/23/2022
---

# Uninstall Azure Arc VM management

> Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article describes how to uninstall Azure Arc VM management on an Azure Arc-enabled Azure Stack HCI cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## How to uninstall Azure Arc VM management

Perform the following steps to uninstall Azure Arc VM management:

1. Remove the virtual network:

   ```azurecli
   az azurestackhci virtualnetwork delete --subscription $subscription --resource-group $resource_group --name $vnetName --yes
   ```

2. Remove the gallery images:

   ```azurecli
   az azurestackhci galleryimage delete --subscription $subscription --resource-group $resource_group --name $galleryImageName
   ```

3. Remove the custom location:

   ```azurecli
   az customlocation delete --resource-group $resource_group --name $customloc_name --yes
   ```

4. Remove the Kubernetes extension:

   ```azurecli
   az k8s-extension delete --cluster-type appliances --cluster-name $resource_name --resource-group $resource_group --name hci-vmoperator --yes
   ```

5. Remove the appliance:

   ```azurecli
   az arcappliance delete hci --config-file $csv_path\ResourceBridge\hci-appliance.yaml --yes
   ```

6. Remove the config files:

   ```PowerShell
   Remove-ArcHciConfigFiles
   ```
   > [!NOTE]
   >  The uninstallation of Azure Arc VM management completes at this step if Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server is installed. If it's not installed, proceed to the next step.

7. (Required only if AKS on Azure Stack HCI is not installed) Run the following cmdlet to uninstall the Microsoft on Cloud (MOC) service:

   ```PowerShell
   Uninstall-Moc
   ```

## Next steps

- [Troubleshoot](troubleshoot-arc-enabled-vms.md)