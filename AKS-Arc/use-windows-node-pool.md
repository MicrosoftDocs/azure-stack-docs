---
title: Use Windows node pools 
description: Learn how to use the Windows nodepool feature.
ms.topic: how-to
ms.date: 09/11/2025
author: rcheeran
ms.author: rcheeran 
ms.reviewer: sethm
ms.lastreviewed: 09/11/2025

---

# Using Windows nodepool feature on Azure Local

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

Virtual hard disks (VHDs)  serve as the base operating system images for the Kubernetes nodes within your AKS cluster. Starting with Azure Local version 2509, only the Azure Linux VHDs are downloaded by default on the Azure Local instance. The Azure Linux VHDs are used to create the default Linux nodepool on the AKS Arc cluster. For Windows based workloads, AKS Arc supports Windows Server 2019 and Windows Server 2022 images that can be used to create corresponding Windows node pool, however these VHDs are not available by default and needs to be downloaded before you can create your Windows based node pools.  Having Windows nodepool feature disabled by default ensures that the Windows-based OS images are not downloaded unnecessarily and helps saves bandwidth and storage space.


## Before you begin

Before you begin creating Windows node pools, make sure you have the following prerequisites in place:

- **Azure Local deployed**. This article is only applicable if you already deployed Azure Local, release 2509. You can't run the commands in this article before you deploy Azure Local release 2509. 
- **Azure RBAC permissions to update Azure Local configuration**. Make sure you have the following roles. For more information, see [required permissions for deployment](/azure/azure-local/deploy/deployment-arc-register-server-permissions?tabs=powershell#assign-required-permissions-for-deployment):
  - Azure Local Administrator
  - Reader
- **Custom Location**. Name of the custom location. The custom location is configured during the Azure Local deployment. If you're in the Azure portal, go to the **Overview > Server** page in the Azure Local system resource. You should see a custom location for your cluster.
- **Azure resource group**. The Azure resource group in which Azure Local is deployed.
- Access to atleast one node on the Azure Local instance.
- You have access to an Azure Local system that is running 2311 or higher. The system should be registered in Azure.
- You have access to a client that can connect to your Azure Local. <!--This client should be running PowerShell 5.0 or later.-->


## Enable the Windows nodepool feature on AKS Arc clusters

### Step 1: Enable the Windows nodepool feature

> [!IMPORTANT]
> Run these steps as a local administrator on any of the Azure Local nodes .

Install the **Support.AksArc** module using the following command:

```powershell
Install-Module -Name Support.AksArc
Import-Module Support.AksArc
```

You can then run the following command to enable the Windows nodepool feature and download the Windows related VHDs. 

```powershell
Invoke-SupportAksArcRemediation_EnableWindowsNodepool -Verbose
```

This would enable the Windows node pool feature and begin the download of the Windows VHDs. This could take some time depending on the network bandwidth available on your Azure Local instance. 

### Step 2: Check if the Windows VHDs are ready

Run the following command to check if the Windows VHDs are downloaded and ready for use. 

```azurecli

$customlocationName = <The custom location name for Azure Local>
$resourceGroup = <The Azure resource group in which Azure Local is deployed>

az aksarc get-versions --resource-group $resourceGroup --custom-location $customlocationName
```

For the Kubernetes version you intend to use, find the right Windows SKU by looking for `osType=Windows` and the `osSKU` fields and ensure that the `ready` state is `true`.

```output
...
         "1.29.4": { 
            "readiness": [ 
              { 
                "errorMessage": null, 
                "osSku": "CBLMariner", 
                "osType": "Linux", 
                "ready": true 
              }, 
              { 
                "errorMessage": null, 
                "osSku": "Windows2019", 
                "osType": "Windows", 
                "ready": true 
              }, 
              { 
                "errorMessage": null, 
                "osSku": "Windows2022", 
                "osType": "Windows", 
                "ready": true 
              } 
            ], 
            "upgrades": null 
          } 
...
```


### Step 3: Create the Windows nodepool 

With the VHDs downloaded and ready to use, you can now proceed to create the Windows node pool either from the Azure Portal or using the CLI as shown. Specify the right OS SKU based on the results from the `get-versions ` command.

```azurecli
az aksarc nodepool add --name "<nodepool-name>" --cluster-name "<cluster-name>" --resource-group $resourceGroup --os-type Windows --os-sku "<sku-name>"

```

> [!IMPORTANT]
> The Windows Server nodepools needs to be licenced either using the Windows Server subscription or using Azure Hybrid Benefit as described the [Activate Windows Server VMs on Azure Local](/azure/azure-local/manage/vm-activate) document.

## Disable the Windows nodepool feature on AKS Arc clusters

### Step 1: Delete existing Windows node pools

If you intend to disable the Windows node pool feature on your cluster, its recommended to delete any Windows node pool that you may have. You can delete your Windows node pools either from the Azure portal or using the CLI as shown:

```azurecli
az aksarc nodepool delete --name "<nodepool-name>" --cluster-name "<cluster-name>" --resource-group $resourceGroup 

```

### Step 2: Disable the Windows node pool feature on your cluster

Install the **Support.AksArc** module using the following command:

```powershell
Install-Module -Name Support.AksArc
Import-Module Support.AksArc
```

You can then run the following command to disable the Windows nodepool feature and delete the Windows related VHDs from your Axure Local instance.

```powershell
Invoke-SupportAksArcRemediation_DisableWindowsNodepool -Verbose
```

This would disable the Windows node pool feature and delete the existing Windows VHDs.

### Step 3: Verify that the Windows VHDs are no longer available

Next, check if Windows nodepools were disabled by running the following command. You can see that the `errorMessage` parameter shows that the Windows node pool feature is disabled and the `ready` parameter shows as `false`,  for each of the Kubernetes versions.

```azurecli
az aksarc get-versions --resource-group $resourceGroup --custom-location $customlocationName
```

```output
...
     - patchVersion: 1.29.4 
          readiness: 
          - osSku: CBLMariner 
            osType: Linux 
            ready: true 
          - errorMessage: Windows nodepool feature is disabled 
            isDisabled: true 
            osSku: Windows2019 
            osType: Windows 
            ready: false 
          - errorMessage: Windows nodepool feature is disabled 
            isDisabled: true 
            osSku: Windows2022 
            osType: Windows 
            ready: false 
....
```

You can verify if Windows VHDs were removed from the Azure Local storage paths. Deletion can take a while so wait for around 30 minutes before checking. You must check all the storage paths, because Windows VHDs are assigned to storage paths in round-robin fashion, based on available storage capacity.

> [!IMPORTANT]
> Once the Windows node pool feature is disabled then operations like adding a Windows node pool, or updating a Windows node pool or attemtping to upgrade a cluster with a Windows node pool are blocked with the error message stating that 'Windows node pool feature is disabled.'. In such scenarios you will have to enable the Windows node pool feature to proceed with the operation.



## Next steps

- [Add a node pool](/azure/aks/aksarc/manage-node-pools#add-a-node-pool)
- [Delerte a node pool](/azure/aks/aksarc/manage-node-pools#delete-a-node-pool)
