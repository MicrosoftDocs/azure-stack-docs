---
title: Update noProxy settings in Azure Kubernetes Service on AKS hybrid
description: Learn how to update noProxy settings in Azure Kubernetes Service (AKS) on Azure Stack HCI or AKS on Windows Server.
ms.topic: how-to
ms.date: 10/21/2022
ms.author: sethm
ms.lastreviewed: 05/31/2022
ms.reviewer: abha
author: sethmanheim

# Intent: As an IT Pro, I want to learn how to update the NoProxy settings.
# Keyword: noproxy proxy settings

---

# Update noProxy settings in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

If you need to update the **noProxy** settings of your Azure Kubernetes Service (AKS) deployment in AKS hybrid, you can walk through the steps in this article to add URLs to your **noProxy** list after you've deployed your AKS workload clusters.

[!INCLUDE [aks-hybrid-description](includes/aks-hybrid-description.md)]

## Limitations and other details

The following scenarios are **not** supported:
- Different proxy configurations per node pool/workload cluster.
- Updating HTTP and HTTPs settings after cluster creation.
- Updating proxy certificate after cluster creation.

## Prerequisites

* AKS deployment running the May build.<!--Build ID is too general - 2022? Link to build release notes?-->
* Latest version of the AksHci PowerShell module. For more information, see [Install the AksHci PowerShell module](kubernetes-walkthrough-powershell.md#install-the-akshci-powershell-module).
* At least one update available for your workload clusters. You can check if there's an update available using the [`Get-AksHciClusterUpdates`](/azure-stack/aks-hci/reference/ps/get-akshciclusterupdates) command in the AksHci PowerShell module.

## Add URLs to the proxy exclusion list post deployment

You can use this scenario to change the proxy exclusion list if you have an update available for your Azure Stack HCI and Windows Server management cluster or target clusters.

1. Update proxy settings by using the below command:

    ```powershell  
    $noProxy = ".contoso.com"
    Set-AksHciProxySetting -noProxy $noProxy 
    ```

2. Check if a management cluster update is possible by running the below command:

    ```powershell  
    Get-AksHciUpdates
    ```

    If an update is available, update the management cluster by running `Update-AksHci`. If an update isn't available, skip this step and proceed to the next step.

    ```powershell  
    Update-AksHci
    ```
   
3. Check if there are workload cluster updates available by running the below command:

    ```powershell  
    Get-AksHciClusterUpdates -name mycluster
    ```

    If an update is available (either Kubernetes version or operating system (OS) image), update all of the workload clusters one-by-one by running `Update-AksHciCluster`.
    
    ```powershell  
    Update-AksHciCluster -name cluster-1
    ```

## Next steps

- To learn more about networking in AKS hybrid, see [Kubernetes networking concepts](/azure-stack/aks-hci/concepts-node-networking).
