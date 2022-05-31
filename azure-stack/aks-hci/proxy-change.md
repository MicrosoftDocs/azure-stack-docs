---
title: Update noProxy settings in Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: Learn how to update noProxy settings in Azure Kubernetes Service on Azure Stack HCI and Windows Server.
ms.topic: conceptual
ms.date: 05/31/2022
ms.author: mabrigg 
ms.lastreviewed: 05/31/2022
ms.reviewer: abha
author: mattbriggs

# Intent: As an IT Pro, I want to learn how to update the NoProxy settings.
# Keyword: noproxy proxy settings

---

# Update noProxy settings in Azure Kubernetes Service on Azure Stack HCI and Windows Server

If you need to update the noProxy settings of your Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server deployment, you can walk through the steps in this article to add URLs to your noProxy list after you've deployed your AKS workload clusters.


## Limitations and other details

The following scenarios are **not** supported:
- Different proxy configurations per node pool/workload cluster
- Updating HTTP and HTTPs settings post cluster creation
- Updating proxy certificate post cluster creation


## Prerequisites

* AKS deployment running the February or April build
* Latest version of the AksHci PowerShell module. Fore more information see [Install the AksHci PowerShell module](kubernetes-walkthrough-powershell.md#install-the-akshci-powershell-module).
* At least one (1) update available for your workload clusters. You can check if there's an update available using the AksHci PowerShell module cmdlet [`Get-AksHciClusterUpdates`](/azure-stack/aks-hci/reference/ps/get-akshciclusterupdates).

## Management

You can use this scenario to change the proxy exclusion list if you have an update available for your AKS-HCI management cluster and/or target clusters.

1. Update proxy settings by using the below command:

    ```powershell  
    $noProxy = ".contoso.com"
    Set-AksHciProxySetting -Name cluster-1 -noProxy $noProxy 
    ```

2. Check if a management cluster update is possible by running the below command:

    ```powershell  
    Get-AksHciUpdates
    ```

    If an update is available, update the management cluster by running `Update-AksHci`. If an update isn't available, skip this step and proceed.

3. Check if there are workload cluster updates available by running the below command:

    ```powershell  
    Get-AksHciClusterUpdates -name mycluster
    ```

If an update is available (either Kubernetes version or operating system (OS) image), update all of the workload clusters one-by-one by running `Update-AksHciCluster`.


## Next steps

To learn more about networking in AKS on Azure Stack HCI and Windows Server, head over to [Kubernetes networking concepts](/azure-stack/aks-hci/concepts-node-networking).